import 'package:subscription_splitter_app/core/notifications/models/notification_model.dart';

/// {@template notifications_repository}
/// Repository interface for notifications data operations
/// {@endtemplate}
abstract class NotificationsRepository {
  /// Get user notifications with pagination and filters
  Future<List<NotificationModel>> getUserNotifications({
    required String userId,
    int page = 1,
    int limit = 50,
    String? type,
    bool? isRead,
  });

  /// Mark a notification as read
  Future<void> markNotificationAsRead(String notificationId);

  /// Delete a notification
  Future<void> deleteNotification(String notificationId);

  /// Send a custom notification
  Future<Map<String, dynamic>> sendCustomNotification({
    required String userId,
    required String title,
    required String body,
    required NotificationType type,
    String? groupId,
    Map<String, dynamic>? data,
  });

  /// Send payment reminder notification
  Future<Map<String, dynamic>> sendPaymentReminder({
    required String userId,
    required double amount,
    required DateTime dueDate,
    String? groupName,
    String? language,
  });

  /// Send group invitation notification
  Future<Map<String, dynamic>> sendGroupInvitation({
    required String recipientUserId,
    required String groupId,
    required String groupName,
    required String inviterName,
    String? language,
  });

  /// Notify when a member joins a group
  Future<Map<String, dynamic>> notifyGroupMemberJoined({
    required String affectedUserId,
    required String groupId,
    required String memberName,
    String? language,
  });

  /// Notify when a member leaves a group
  Future<Map<String, dynamic>> notifyGroupMemberLeft({
    required String affectedUserId,
    required String groupId,
    required String memberName,
    String? language,
  });

  /// Send payment overdue notification
  Future<Map<String, dynamic>> sendPaymentOverdue({
    required String userId,
    required double amount,
    required DateTime dueDate,
    String? groupName,
    String? language,
  });

  /// Send payment confirmation notification
  Future<Map<String, dynamic>> sendPaymentConfirmation({
    required String userId,
    required double amount,
    String? groupName,
    String? language,
  });

  /// Send renewal reminder notification
  Future<Map<String, dynamic>> sendRenewalReminder({
    required String userId,
    required String groupName,
    required DateTime renewalDate,
    required double amount,
    String? language,
  });

  /// Send group message notification
  Future<Map<String, dynamic>> sendGroupMessage({
    required String recipientUserId,
    required String groupId,
    required String senderName,
    required String message,
    String? language,
  });

  /// Handle group activity notification
  Future<void> handleGroupActivity({
    required String affectedUserId,
    required String groupId,
    required String activityType,
    required String activityDescription,
    String? language,
  });

  /// Register device token for push notifications
  Future<void> registerDeviceToken({
    required String userId,
    required String token,
    String platform = 'flutter',
  });

  /// Update user notification preferences
  Future<void> updateNotificationPreferences({
    required String userId,
    required Map<String, dynamic> preferences,
  });

  /// Get user notification preferences
  Future<Map<String, dynamic>> getNotificationPreferences(String userId);
}
