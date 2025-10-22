import 'package:subscription_splitter_app/core/notifications/models/notification_model.dart';
import 'package:subscription_splitter_app/core/notifications/templates/multilingual_templates.dart';

/// {@template notification_sender}
/// Utility class for sending notifications (simulated for now)
/// {@endtemplate}
class NotificationSender {
  /// Send a payment reminder notification
  static NotificationModel sendPaymentReminder({
    required String groupId,
    required String groupName,
    required double amount,
    required DateTime dueDate,
    required String userId,
    String? customText,
    String language = 'en',
  }) {
    return MultilingualTemplates.paymentReminder(
      groupId: groupId,
      groupName: groupName,
      amount: amount,
      dueDate: dueDate,
      userId: userId,
      customText: customText,
      language: language,
    );
  }

  /// Send a payment overdue notification
  static NotificationModel sendPaymentOverdue({
    required String groupId,
    required String groupName,
    required double amount,
    required DateTime dueDate,
    required String userId,
    String? customText,
    String language = 'en',
  }) {
    return MultilingualTemplates.paymentOverdue(
      groupId: groupId,
      groupName: groupName,
      amount: amount,
      dueDate: dueDate,
      userId: userId,
      customText: customText,
      language: language,
    );
  }

  /// Send a group invitation notification
  static NotificationModel sendGroupInvitation({
    required String groupId,
    required String groupName,
    required String inviterName,
    required String userId,
    String? customText,
    String language = 'en',
  }) {
    return MultilingualTemplates.groupInvitation(
      groupId: groupId,
      groupName: groupName,
      inviterName: inviterName,
      userId: userId,
      customText: customText,
      language: language,
    );
  }

  /// Send a new member joined notification
  static NotificationModel sendNewMemberJoined({
    required String groupId,
    required String groupName,
    required String memberName,
    required String userId,
    String? customText,
    String language = 'en',
  }) {
    return MultilingualTemplates.newMemberJoined(
      groupId: groupId,
      groupName: groupName,
      memberName: memberName,
      userId: userId,
      customText: customText,
      language: language,
    );
  }

  /// Send an upcoming renewal notification
  static NotificationModel sendUpcomingRenewal({
    required String groupId,
    required String groupName,
    required double amount,
    required DateTime renewalDate,
    required String userId,
    String? customText,
    String language = 'en',
  }) {
    return MultilingualTemplates.upcomingRenewal(
      groupId: groupId,
      groupName: groupName,
      amount: amount,
      renewalDate: renewalDate,
      userId: userId,
      customText: customText,
      language: language,
    );
  }

  /// Send a custom notification
  static NotificationModel sendCustomNotification({
    required String groupId,
    required String title,
    required String customText,
    required String userId,
    NotificationType type = NotificationType.groupMessage,
    String language = 'en',
  }) {
    return MultilingualTemplates.customNotification(
      groupId: groupId,
      title: title,
      customText: customText,
      userId: userId,
      type: type,
      language: language,
    );
  }

  /// Send notification to multiple users (simulated)
  static List<NotificationModel> sendToMultipleUsers({
    required List<String> userIds,
    required String groupId,
    required String title,
    required String customText,
    NotificationType type = NotificationType.groupMessage,
    String language = 'en',
  }) {
    return userIds.map((userId) {
      return MultilingualTemplates.customNotification(
        groupId: groupId,
        title: title,
        customText: customText,
        userId: userId,
        type: type,
        language: language,
      );
    }).toList();
  }

  /// Send notification to all group members (simulated)
  static List<NotificationModel> sendToGroup({
    required String groupId,
    required String groupName,
    required List<String> memberIds,
    required String title,
    required String customText,
    NotificationType type = NotificationType.groupMessage,
    String language = 'en',
  }) {
    return memberIds.map((memberId) {
      return MultilingualTemplates.customNotification(
        groupId: groupId,
        title: title,
        customText: customText,
        userId: memberId,
        type: type,
        language: language,
      );
    }).toList();
  }

  /// Simulate sending notification via API (for testing)
  static Future<void> simulateApiSend(NotificationModel notification) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    print('📱 Notification Sent:');
    print('   Title: ${notification.title}');
    print('   Body: ${notification.displayText}');
    print('   Language: ${notification.language}');
    print('   Type: ${notification.type.displayName}');
    print('   User: ${notification.userId}');
    print('   Group: ${notification.groupId}');
    print('   Custom Text: ${notification.customText ?? "None"}');
    print('   ---');
  }

  /// Send notification and log it (for testing)
  static Future<NotificationModel> sendAndLog({
    required String groupId,
    required String title,
    required String customText,
    required String userId,
    NotificationType type = NotificationType.groupMessage,
    String language = 'en',
  }) async {
    final notification = sendCustomNotification(
      groupId: groupId,
      title: title,
      customText: customText,
      userId: userId,
      type: type,
      language: language,
    );

    await simulateApiSend(notification);
    return notification;
  }
}
