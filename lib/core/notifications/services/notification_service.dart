import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:subscription_splitter_app/core/di/service_locator.dart';
import 'package:subscription_splitter_app/core/notifications/models/notification_model.dart';

/// {@template notification_service}
/// Service for handling Firebase Cloud Messaging notifications
/// {@endtemplate}
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final StreamController<NotificationModel> _notificationController =
      StreamController<NotificationModel>.broadcast();

  /// Stream of incoming notifications
  Stream<NotificationModel> get notificationStream =>
      _notificationController.stream;

  /// Current FCM token
  String? _fcmToken;

  /// Performance optimization flags
  bool _isInitialized = false;
  bool _isInitializing = false;
  bool _initializationFailed = false;

  /// Get the current FCM token
  String? get fcmToken => _fcmToken;

  /// Check if service is initialized
  bool get isInitialized => _isInitialized;

  /// Initialize the notification service (blocking, complete initialization)
  Future<void> initialize() async {
    debugPrint('NotificationService: initialize() called');

    // Prevent multiple initializations
    if (_isInitialized) {
      debugPrint('NotificationService: Already initialized, returning');
      return;
    }

    if (_isInitializing) {
      debugPrint('NotificationService: Already initializing, waiting...');
      // Wait for current initialization to complete
      int waitCount = 0;
      while (_isInitializing && !_isInitialized && waitCount < 50) {
        await Future.delayed(const Duration(milliseconds: 100));
        waitCount++;
        debugPrint(
          'NotificationService: Waiting for initialization... $waitCount/50',
        );
      }

      if (_isInitialized) {
        debugPrint(
          'NotificationService: Initialization completed while waiting',
        );
        return;
      } else {
        debugPrint(
          'NotificationService: Initialization wait timed out, proceeding...',
        );
      }
    }

    if (_initializationFailed) {
      debugPrint(
        'NotificationService: Previous initialization failed, retrying...',
      );
    }

    _isInitializing = true;
    debugPrint('NotificationService: Setting _isInitializing = true');

    try {
      debugPrint('NotificationService: Starting complete initialization...');

      // Complete setup - await all operations
      debugPrint(
        'NotificationService: Step 1 - Configuring message handlers...',
      );
      _configureMessageHandlers();

      debugPrint(
        'NotificationService: Step 2 - Initializing local notifications...',
      );
      await _initializeLocalNotifications();

      debugPrint('NotificationService: Step 3 - Requesting permissions...');
      await _requestPermissionLazy();

      debugPrint('NotificationService: Step 4 - Getting FCM token...');
      await _getFCMTokenLazy();

      _isInitialized = true;
      debugPrint(
        'NotificationService: Complete initialization successful - _isInitialized = true',
      );
    } catch (e) {
      debugPrint('NotificationService: Initialization failed - $e');
      _initializationFailed = true;
      rethrow; // Re-throw to let caller handle the error
    } finally {
      _isInitializing = false;
      debugPrint('NotificationService: Setting _isInitializing = false');
    }
  }

  /// Lazy permission request (non-blocking)
  Future<void> _requestPermissionLazy() async {
    try {
      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      debugPrint(
        'NotificationService: Lazy permission status - ${settings.authorizationStatus}',
      );
    } catch (e) {
      debugPrint('NotificationService: Lazy permission request failed - $e');
    }
  }

  /// Lazy FCM token retrieval (non-blocking, with backend registration)
  Future<void> _getFCMTokenLazy() async {
    try {
      // On iOS, check APNS token first but don't wait forever
      if (Platform.isIOS) {
        try {
          debugPrint('NotificationService: Getting APNS token');
          await _firebaseMessaging.getAPNSToken();
          debugPrint('NotificationService: APNS token retrieved');
        } catch (e) {
          debugPrint(
            'NotificationService: APNS token not ready, continuing anyway - $e',
          );
        }
      }

      _fcmToken = await _firebaseMessaging.getToken();
      debugPrint('NotificationService: Lazy FCM Token - $_fcmToken');

      if (_fcmToken != null) {
        // Lazy background registration without blocking
        _registerWithBackendLazy(_fcmToken!);
      }
    } catch (e) {
      debugPrint('NotificationService: Lazy FCM token failed - $e');
      // Continue anyway - FCM token can be retrieved later
    }
  }

  /// Lazy backend registration - non-blocking
  void _registerWithBackendLazy(String token) {
    // Run registration in background - don't await
    Future.microtask(() async {
      try {
        final serviceLocator = ServiceLocator();
        final repository = serviceLocator.notificationsRepository;

        final currentUserId = _getCurrentUserId();

        await repository.registerDeviceToken(
          userId: currentUserId,
          token: token,
          platform: 'mobile',
        );

        debugPrint('NotificationService: Lazy backend registration completed');
      } catch (e) {
        debugPrint(
          'NotificationService: Lazy backend registration failed - $e',
        );
      }
    });
  }

  /// Get current user ID from Supabase authentication
  String _getCurrentUserId() {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      return user?.id ?? 'guest_user';
    } catch (e) {
      debugPrint('NotificationService: Failed to get current user - $e');
      return 'guest_user'; // Fallback for unauthenticated users
    }
  }

  /// Configure message handlers
  void _configureMessageHandlers() {
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle background messages
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);

    // Handle notification tap when app is terminated
    _firebaseMessaging.getInitialMessage().then((message) {
      if (message != null) {
        _handleTerminatedAppMessage(message);
      }
    });
  }

  /// Handle foreground messages
  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('NotificationService: Foreground message received');
    debugPrint('Title: ${message.notification?.title}');
    debugPrint('Body: ${message.notification?.body}');
    debugPrint('Data: ${message.data}');

    final notification = _parseMessage(message);
    if (notification != null) {
      // Add to internal stream
      _notificationController.add(notification);

      // Show as system notification when app is in foreground
      _showLocalNotification(notification);
    }
  }

  /// Handle background messages (when app is in background)
  void _handleBackgroundMessage(RemoteMessage message) {
    debugPrint('NotificationService: Background message received');
    debugPrint('Title: ${message.notification?.title}');
    debugPrint('Body: ${message.notification?.body}');
    debugPrint('Data: ${message.data}');

    final notification = _parseMessage(message);
    if (notification != null) {
      _notificationController.add(notification);
    }
  }

  /// Handle messages when app is terminated
  void _handleTerminatedAppMessage(RemoteMessage message) {
    debugPrint('NotificationService: Terminated app message received');
    debugPrint('Title: ${message.notification?.title}');
    debugPrint('Body: ${message.notification?.body}');
    debugPrint('Data: ${message.data}');

    final notification = _parseMessage(message);
    if (notification != null) {
      _notificationController.add(notification);
    }
  }

  /// Parse RemoteMessage to NotificationModel
  NotificationModel? _parseMessage(RemoteMessage message) {
    try {
      final data = message.data;
      final notification = message.notification;

      return NotificationModel(
        id: data['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
        type: NotificationType.fromString(data['type'] ?? 'group_message'),
        title: notification?.title ?? data['title'] ?? 'Notification',
        body: notification?.body ?? data['body'] ?? '',
        timestamp: DateTime.now(),
        data: data,
        groupId: data['groupId'],
        userId: data['userId'],
        actionType:
            data['actionType'] != null
                ? NotificationActionType.fromString(data['actionType'])
                : null,
        actionData:
            data['actionData'] != null
                ? Map<String, dynamic>.from(jsonDecode(data['actionData']))
                : {},
      );
    } catch (e) {
      debugPrint('NotificationService: Failed to parse message - $e');
      return null;
    }
  }

  /// Subscribe to a topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      debugPrint('NotificationService: Subscribed to topic - $topic');
    } catch (e) {
      debugPrint(
        'NotificationService: Failed to subscribe to topic $topic - $e',
      );
    }
  }

  /// Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      debugPrint('NotificationService: Unsubscribed from topic - $topic');
    } catch (e) {
      debugPrint(
        'NotificationService: Failed to unsubscribe from topic $topic - $e',
      );
    }
  }

  /// Subscribe to group notifications
  Future<void> subscribeToGroup(String groupId) async {
    await subscribeToTopic('group_$groupId');
  }

  /// Unsubscribe from group notifications
  Future<void> unsubscribeFromGroup(String groupId) async {
    await unsubscribeFromTopic('group_$groupId');
  }

  /// Subscribe to user notifications
  Future<void> subscribeToUser(String userId) async {
    await subscribeToTopic('user_$userId');
  }

  /// Unsubscribe from user notifications
  Future<void> unsubscribeFromUser(String userId) async {
    await unsubscribeFromTopic('user_$userId');
  }

  /// Initialize local notifications
  Future<void> _initializeLocalNotifications() async {
    debugPrint('NotificationService: Initializing local notifications');

    try {
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const DarwinInitializationSettings iosSettings =
          DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
          );

      const InitializationSettings settings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _localNotifications.initialize(
        settings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      debugPrint(
        'NotificationService: Local notifications initialized successfully',
      );

      // Create notification channel for Android
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'subscription_splitter',
        'Subscription Splitter Notifications',
        description: 'Notifications for subscription splitting app',
        importance: Importance.high,
      );

      await _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(channel);

      debugPrint('NotificationService: Android notification channel created');

      // Request permissions for Android 13+
      await _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();

      debugPrint('NotificationService: Android permissions requested');
    } catch (e) {
      debugPrint(
        'NotificationService: Error initializing local notifications: $e',
      );
      rethrow;
    }
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    debugPrint(
      'NotificationService: Notification tapped - ${response.payload}',
    );
    // Handle notification tap navigation here
    // You can parse the payload and navigate to specific screens
  }

  /// Show local notification
  Future<void> _showLocalNotification(NotificationModel notification) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'subscription_splitter',
          'Subscription Splitter Notifications',
          channelDescription: 'Notifications for subscription splitting app',
          importance: Importance.high,
          priority: Priority.high,
          showWhen: true,
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      notification.id.hashCode,
      notification.title,
      notification.body,
      details,
      payload: jsonEncode(notification.toJson()),
    );
  }

  /// Show local notification immediately (for testing/simulating push notifications)
  Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    debugPrint('NotificationService: showLocalNotification called');
    debugPrint('NotificationService: Title: $title, Body: $body');
    debugPrint('NotificationService: Is initialized: $_isInitialized');
    debugPrint('NotificationService: FCM Token: $_fcmToken');

    try {
      // Check if local notifications are initialized
      if (!_isInitialized) {
        debugPrint(
          'NotificationService: Service not initialized, attempting to initialize...',
        );
        await initialize();
      }

      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
            'subscription_splitter',
            'Subscription Splitter Notifications',
            channelDescription: 'Notifications for subscription splitting app',
            importance: Importance.high,
            priority: Priority.high,
            showWhen: true,
          );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      debugPrint('NotificationService: About to show notification...');
      await _localNotifications.show(
        DateTime.now().millisecondsSinceEpoch.remainder(100000),
        title,
        body,
        details,
        payload: payload,
      );

      debugPrint('NotificationService: Local notification shown successfully');
    } catch (e) {
      debugPrint('NotificationService: Error showing local notification: $e');
      rethrow;
    }
  }

  /// Test method to verify local notifications are working
  Future<void> testLocalNotification() async {
    debugPrint('NotificationService: Testing local notification...');

    try {
      await showLocalNotification(
        title: 'Test Notification',
        body: 'This is a test notification to verify local notifications work',
        payload: 'test',
      );
      debugPrint('NotificationService: Test notification sent successfully');
    } catch (e) {
      debugPrint('NotificationService: Error sending test notification: $e');
    }
  }

  /// Dispose resources
  void dispose() {
    _notificationController.close();
  }
}

/// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('NotificationService: Background message handler');
  debugPrint('Title: ${message.notification?.title}');
  debugPrint('Body: ${message.notification?.body}');
  debugPrint('Data: ${message.data}');

  // Handle background message processing here
  // This could include updating local database, showing local notifications, etc.
}
