import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:subscription_splitter_app/core/network/dio_client.dart';
import 'package:subscription_splitter_app/core/notifications/models/notification_model.dart';
import 'package:subscription_splitter_app/core/notifications/models/notification_preferences.dart';
import 'package:subscription_splitter_app/core/di/service_locator.dart';

/// {@template notification_api_service}
/// Service for sending notifications via backend API
/// Updated to support all 8 API endpoints
/// {@endtemplate}
class NotificationApiService {
  /// {@macro notification_api_service}
  const NotificationApiService({required this.apiService});

  final ApiService apiService;

  /// Send a notification to a specific user
  /// Endpoints: POST /notifications/send
  Future<Map<String, dynamic>> sendNotificationToUser({
    required String userId,
    required String title,
    required String body,
    String? customText,
    String language = 'en',
    NotificationType type = NotificationType.groupMessage,
    String? groupId,
    Map<String, dynamic>? data,
  }) async {
    try {
      final payload = {
        'userId': userId,
        'title': title,
        'body': body,
        'customText': customText,
        'language': language,
        'type': type.value,
        'groupId': groupId,
        'data': data ?? {},
      };

      final response = await apiService.post(
        '/notifications/send',
        data: payload,
      );
      return response;
    } catch (e) {
      throw Exception('Failed to send notification: $e');
    }
  }

  /// Send notification to multiple users
  /// Endpoint: POST /notifications/send-bulk
  Future<Map<String, dynamic>> sendNotificationToUsers({
    required List<String> userIds,
    required String title,
    required String body,
    String? customText,
    String language = 'en',
    NotificationType type = NotificationType.groupMessage,
    String? groupId,
    Map<String, dynamic>? data,
  }) async {
    try {
      final payload = {
        'userIds': userIds,
        'title': title,
        'body': body,
        'customText': customText,
        'language': language,
        'type': type.value,
        'groupId': groupId,
        'data': data ?? {},
      };

      final response = await apiService.post(
        '/notifications/send-bulk',
        data: payload,
      );
      return response;
    } catch (e) {
      throw Exception('Failed to send bulk notifications: $e');
    }
  }

  /// Send notification to all members of a group
  /// Endpoint: POST /notifications/send-to-group
  Future<Map<String, dynamic>> sendNotificationToGroup({
    required String groupId,
    required String title,
    required String body,
    String? customText,
    String language = 'en',
    NotificationType type = NotificationType.groupMessage,
    Map<String, dynamic>? data,
  }) async {
    try {
      final payload = {
        'groupId': groupId,
        'title': title,
        'body': body,
        'customText': customText,
        'language': language,
        'type': type.value,
        'data': data ?? {},
      };

      final response = await apiService.post(
        '/notifications/send-to-group',
        data: payload,
      );
      return response;
    } catch (e) {
      throw Exception('Failed to send group notification: $e');
    }
  }

  /// Get user's notification history
  /// Endpoint: GET /notifications?userId=xxx&page=1&limit=20&type=xxx&read=xxx
  Future<Map<String, dynamic>> getUserNotifications({
    required String userId,
    int page = 1,
    int limit = 20,
    String? type,
    bool? read,
  }) async {
    try {
      final queryParams = {'userId': userId, 'page': page, 'limit': limit};

      if (type != null) queryParams['type'] = type;
      if (read != null) queryParams['read'] = read.toString();

      final response = await apiService.get(
        '/notifications',
        queryParameters: queryParams,
      );
      return response;
    } catch (e) {
      throw Exception('Failed to fetch notifications: $e');
    }
  }

  /// Mark notification as read
  /// Endpoint: PATCH /notifications/:id/read
  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await apiService.patch('/notifications/$notificationId/read');
    } catch (e) {
      throw Exception('Failed to mark notification as read: $e');
    }
  }

  /// Delete notification
  /// Endpoint: DELETE /notifications/:id
  Future<void> deleteNotification(String notificationId) async {
    try {
      await apiService.delete('/notifications/$notificationId');
    } catch (e) {
      throw Exception('Failed to delete notification: $e');
    }
  }

  /// Update user's notification preferences
  /// Endpoint: PATCH /notifications/preferences
  Future<Map<String, dynamic>> updateNotificationPreferences(
    Map<String, dynamic> preferences,
  ) async {
    try {
      final response = await apiService.patch(
        '/notifications/preferences',
        data: preferences,
      );
      return response;
    } catch (e) {
      throw Exception('Failed to update notification preferences: $e');
    }
  }

  /// Get user's notification preferences
  /// Endpoint: GET /notifications/preferences/:userId
  Future<NotificationPreferences> getNotificationPreferences(
    String userId,
  ) async {
    try {
      final response = await apiService.get(
        '/notifications/preferences/$userId',
      );
      return NotificationPreferences.fromJson(response['data']);
    } catch (e) {
      throw Exception('Failed to get notification preferences: $e');
    }
  }

  /// Register device token for push notifications
  /// Endpoint: POST /notifications/device-token
  Future<void> registerDeviceToken({
    required String userId,
    required String token,
    String deviceType = 'mobile',
    String? appVersion,
    String? appName,
    String? buildNumber,
    String? packageName,
  }) async {
    try {
      final payload = {
        'userId': userId,
        'token': token,
        'deviceType': deviceType,
        'appVersion': appVersion,
        'appName': appName,
        'buildNumber': buildNumber,
        'packageName': packageName,
      };

      await apiService.post('/notifications/device-token', data: payload);
    } catch (e) {
      throw Exception('Failed to register device token: $e');
    }
  }

  /// Convenience method: Update preferences using NotificationPreferences object
  Future<Map<String, dynamic>> updatePreferencesFromModel(
    NotificationPreferences preferences,
  ) async {
    return updateNotificationPreferences(preferences.toJson());
  }

  /// Convenience method: Get notifications list as NotificationModel objects
  Future<List<NotificationModel>> getUserNotificationsList({
    required String userId,
    int page = 1,
    int limit = 20,
    String? type,
    bool? read,
  }) async {
    final response = await getUserNotifications(
      userId: userId,
      page: page,
      limit: limit,
      type: type,
      read: read,
    );

    debugPrint('NotificationApiService: Raw API response: $response');

    // Handle different API response formats
    List<dynamic> notificationsJson = [];

    if (response['data'] is List) {
      // Direct array format: { "data": [...] }
      notificationsJson = response['data'] ?? [];
      debugPrint(
        'NotificationApiService: Found ${notificationsJson.length} notifications in direct array format',
      );
    } else if (response['data'] is Map &&
        response['data']['notifications'] != null) {
      // Nested format: { "data": { "notifications": [...] } }
      notificationsJson = response['data']['notifications'] ?? [];
      debugPrint(
        'NotificationApiService: Found ${notificationsJson.length} notifications in nested format',
      );
    } else {
      // Fallback: try to extract from response
      notificationsJson = [];
      debugPrint('NotificationApiService: No notifications found in response');
    }

    final notifications =
        notificationsJson
            .map((json) => NotificationModel.fromJson(json))
            .toList();

    debugPrint(
      'NotificationApiService: Parsed ${notifications.length} notification models',
    );

    return notifications;
  }

  /// Enhanced method: Send smart payment reminder notifications
  Future<Map<String, dynamic>> sendPaymentReminder({
    required String userId,
    required double amount,
    required DateTime dueDate,
    String? groupName,
    String language = 'en',
  }) async {
    final title = language == 'ar' ? 'تذكير بالدفع' : 'Payment Reminder';
    final body =
        language == 'ar'
            ? 'مبلغ \$${amount.toStringAsFixed(2)} مستحق في ${_formatDateArabic(dueDate)}'
            : 'Amount \$${amount.toStringAsFixed(2)} due on ${_formatDateEnglish(dueDate)}';

    return await sendNotificationToUser(
      userId: userId,
      title: title,
      body: body,
      customText: body,
      language: language,
      type: NotificationType.paymentReminder,
      groupId: groupName != null ? await _getGroupIdByName(groupName) : null,
      data: {
        'amount': amount,
        'dueDate': dueDate.toIso8601String(),
        'groupName': groupName,
      },
    );
  }

  /// Enhanced method: Send group invitation notifications
  Future<Map<String, dynamic>> sendGroupInvitation({
    required String recipientUserId,
    required String groupName,
    required String groupId,
    String invitedByName = 'Admin',
    String language = 'en',
  }) async {
    final title = language == 'ar' ? 'دعوة إلى المجموعة' : 'Group Invitation';
    final body =
        language == 'ar'
            ? '$invitedByName دعاك للانضمام إلى مجموعة $groupName'
            : '$invitedByName invited you to join group $groupName';

    return await sendNotificationToUser(
      userId: recipientUserId,
      title: title,
      body: body,
      customText: body,
      language: language,
      type: NotificationType.groupInvitation,
      groupId: groupId,
      data: {
        'groupName': groupName,
        'invitedByName': invitedByName,
        'groupId': groupId,
      },
    );
  }

  /// Enhanced method: Send smart group activity notifications
  Future<Map<String, dynamic>> sendGroupActivityNotification({
    required String activityType,
    required String groupId,
    required String affectedUserId,
    String? additionalInfo,
    Map<String, dynamic>? contextData,
    String language = 'en',
  }) async {
    String title, body;
    NotificationType type;

    switch (activityType) {
      case 'payment_due':
        title = language == 'ar' ? 'الدفع مستحق' : 'Payment Due';
        body =
            language == 'ar'
                ? 'دفع الاشتراك مستحق قريباً'
                : 'Your subscription payment is due soon';
        type = NotificationType.paymentReminder;
        break;
      case 'member_joined':
        title = language == 'ar' ? 'عضو جديد انضم' : 'New Member Joined';
        body =
            additionalInfo == null
                ? (language == 'ar'
                    ? 'عضو جديد انضم إلى المجموعة'
                    : 'A new member joined the group')
                : (language == 'ar'
                    ? '$additionalInfo انضم إلى المجموعة'
                    : '$additionalInfo joined the group');
        type = NotificationType.newMemberJoined;
        break;
      case 'member_left':
        title = language == 'ar' ? 'عضو غادر' : 'Member Left';
        body =
            additionalInfo == null
                ? (language == 'ar'
                    ? 'ترك عضو المجموعة'
                    : 'A group member has left')
                : (language == 'ar'
                    ? '$additionalInfo غادر المجموعة'
                    : '$additionalInfo left the group');
        type = NotificationType.memberLeft;
        break;
      default:
        title = language == 'ar' ? 'نشاط المجموعة' : 'Group Activity';
        body =
            language == 'ar'
                ? 'نشاط جديد في مجموعتك'
                : 'New activity in your group';
        type = NotificationType.groupMessage;
    }

    try {
      return await sendNotificationToUser(
        userId: affectedUserId,
        title: title,
        body: body,
        type: type,
        groupId: groupId,
        language: language,
        data: contextData ?? {},
      );
    } catch (e) {
      print(
        'NotificationApiService: Failed to send group activity notification - $e',
      );
      rethrow;
    }
  }

  /// Helper: Format date for Arabic display
  String _formatDateArabic(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  /// Helper: Format date for English display
  String _formatDateEnglish(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  /// Helper: Get group ID by name using ServiceLocator groups repository
  Future<String?> _getGroupIdByName(String groupName) async {
    try {
      // Get current user and ServiceLocator
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return null;

      final serviceLocator = ServiceLocator();
      final groupsData = await serviceLocator.groupsRepository.getUserGroups(
        user.id,
      );

      // Find group with matching name (handle both name/title matching)
      for (final group in groupsData) {
        if (group.name == groupName ||
            (group.name.toLowerCase()) == groupName.toLowerCase()) {
          return group.id;
        }
      }
      return null;
    } catch (e) {
      debugPrint('NotificationApiService: Failed to lookup group by name - $e');
      return null;
    }
  }
}
