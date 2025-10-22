import 'dart:async';
import 'dart:developer' as console;

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/view/app.dart';
import 'firebase_options.dart';
import 'core/config/supabase_config.dart';
import 'core/notifications/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    console.log('Firebase initialized successfully');

    // Initialize Supabase with custom configuration
    await Supabase.initialize(
      url: SupabaseConfig.url,
      anonKey: SupabaseConfig.anonKey,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
        autoRefreshToken: true,
      ),
      realtimeClientOptions: const RealtimeClientOptions(
        logLevel: RealtimeLogLevel.info,
      ),
      storageOptions: const StorageClientOptions(retryAttempts: 3),
    );
    console.log('Supabase initialized successfully');

    // Initialize Hive
    await Hive.initFlutter();
    console.log('Hive initialized successfully');

    // Initialize Firebase services
    await _initializeFirebaseServices();

    // Initialize Notification Service
    await _initializeNotificationService();

    runApp(const App());
  } catch (e, stackTrace) {
    console.log('Initialization error: $e');
    console.log('Stack trace: $stackTrace');

    // Initialize basic services and run app anyway
    try {
      await Hive.initFlutter();
      runApp(const App());
    } catch (hiveError) {
      console.log('Hive initialization failed: $hiveError');
      runApp(const App());
    }
  }
}

Future<void> _initializeFirebaseServices() async {
  try {
    // Initialize Crashlytics
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };

    // Initialize Analytics
    await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
    console.log('Firebase Analytics initialized');

    // Initialize Messaging
    await FirebaseMessaging.instance.requestPermission();
    console.log('Firebase Messaging permissions requested');

    // Register background message handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    console.log('Firebase Messaging background handler registered');
  } catch (e) {
    console.log('Firebase services initialization error: $e');
    // Continue without Firebase services
  }
}

Future<void> _initializeNotificationService() async {
  try {
    console.log('Starting Notification Service initialization...');
    // Initialize the notification service with timeout
    await NotificationService().initialize().timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        console.log('NotificationService initialization timed out');
        throw TimeoutException(
          'NotificationService initialization timed out',
          const Duration(seconds: 10),
        );
      },
    );
    console.log('Notification Service initialized successfully');

    // Test if the service is working
    console.log('Testing NotificationService...');
    try {
      await NotificationService().testLocalNotification();
      console.log('NotificationService test successful');
    } catch (testError) {
      console.log('NotificationService test failed: $testError');
    }
  } catch (e) {
    console.log('Notification Service initialization error: $e');
    // Continue without notification service
  }
}
