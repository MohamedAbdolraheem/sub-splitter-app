import 'package:subscription_splitter_app/core/notifications/models/notification_model.dart';
import 'package:subscription_splitter_app/core/notifications/services/notification_service.dart';
import 'package:subscription_splitter_app/core/notifications/services/notification_api_service.dart';
import 'package:subscription_splitter_app/core/localization/language_service.dart';
import '../../domain/repositories/notifications_repository.dart';

/// {@template notifications_repository_impl}
/// Implementation of notifications repository using NotificationService and NotificationApiService
/// {@endtemplate}
class NotificationsRepositoryImpl implements NotificationsRepository {
  /// {@macro notifications_repository_impl}
  const NotificationsRepositoryImpl({
    required this.notificationService,
    required this.apiService,
  });

  final NotificationService notificationService;
  final NotificationApiService apiService;

  /// Get current language or fallback to default
  Future<String> _getLanguage(String? language) async {
    if (language != null && language.isNotEmpty) {
      return language;
    }
    return await LanguageService.instance.getCurrentLanguage();
  }

  @override
  Future<List<NotificationModel>> getUserNotifications({
    required String userId,
    int page = 1,
    int limit = 50,
    String? type,
    bool? isRead,
  }) async {
    return await apiService.getUserNotificationsList(
      userId: userId,
      page: page,
      limit: limit,
      type: type,
      read: isRead,
    );
  }

  @override
  Future<void> markNotificationAsRead(String notificationId) async {
    return await apiService.markNotificationAsRead(notificationId);
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    return await apiService.deleteNotification(notificationId);
  }

  @override
  Future<Map<String, dynamic>> sendCustomNotification({
    required String userId,
    required String title,
    required String body,
    required NotificationType type,
    String? groupId,
    Map<String, dynamic>? data,
  }) async {
    return await apiService.sendNotificationToUser(
      userId: userId,
      title: title,
      body: body,
      type: type,
      groupId: groupId,
      data: data,
      language: await _getLanguage(null),
    );
  }

  @override
  Future<Map<String, dynamic>> sendPaymentReminder({
    required String userId,
    required double amount,
    required DateTime dueDate,
    String? groupName,
    String? language,
  }) async {
    final currentLanguage = await _getLanguage(language);
    return await apiService.sendPaymentReminder(
      userId: userId,
      amount: amount,
      dueDate: dueDate,
      groupName: groupName,
      language: currentLanguage,
    );
  }

  @override
  Future<Map<String, dynamic>> sendGroupInvitation({
    required String recipientUserId,
    required String groupId,
    required String groupName,
    required String inviterName,
    String? language,
  }) async {
    final currentLanguage = await _getLanguage(language);
    return await apiService.sendGroupInvitation(
      recipientUserId: recipientUserId,
      groupId: groupId,
      groupName: groupName,
      invitedByName: inviterName,
      language: currentLanguage,
    );
  }

  @override
  Future<Map<String, dynamic>> notifyGroupMemberJoined({
    required String affectedUserId,
    required String groupId,
    required String memberName,
    String? language,
  }) async {
    final currentLanguage = await _getLanguage(language);
    return await apiService.sendGroupActivityNotification(
      activityType: 'member_joined',
      groupId: groupId,
      affectedUserId: affectedUserId,
      additionalInfo: memberName,
      language: currentLanguage,
    );
  }

  @override
  Future<Map<String, dynamic>> notifyGroupMemberLeft({
    required String affectedUserId,
    required String groupId,
    required String memberName,
    String? language,
  }) async {
    final currentLanguage = await _getLanguage(language);
    return await apiService.sendGroupActivityNotification(
      activityType: 'member_left',
      groupId: groupId,
      affectedUserId: affectedUserId,
      additionalInfo: memberName,
      language: currentLanguage,
    );
  }

  @override
  Future<Map<String, dynamic>> sendPaymentOverdue({
    required String userId,
    required double amount,
    required DateTime dueDate,
    String? groupName,
    String? language,
  }) async {
    final currentLanguage = await _getLanguage(language);
    final title = currentLanguage == 'ar' ? 'الدفع متأخر' : 'Payment Overdue';
    final body =
        currentLanguage == 'ar'
            ? 'متأخر: \$${amount.toStringAsFixed(2)} كان مستحق في ${_formatDateArabic(dueDate)}'
            : 'Overdue: \$${amount.toStringAsFixed(2)} was due on ${_formatDateEnglish(dueDate)}';

    return await apiService.sendNotificationToUser(
      userId: userId,
      title: title,
      body: body,
      customText: body,
      language: currentLanguage,
      type: NotificationType.paymentOverdue,
      data: {
        'amount': amount,
        'dueDate': dueDate.toIso8601String(),
        'groupName': groupName,
      },
    );
  }

  @override
  Future<Map<String, dynamic>> sendPaymentConfirmation({
    required String userId,
    required double amount,
    String? groupName,
    String? language,
  }) async {
    final currentLanguage = await _getLanguage(language);
    final title = currentLanguage == 'ar' ? 'تأكيد الدفع' : 'Payment Confirmed';
    final body =
        currentLanguage == 'ar'
            ? 'تم تأكيد دفع \$${amount.toStringAsFixed(2)}'
            : 'Payment of \$${amount.toStringAsFixed(2)} confirmed';

    return await apiService.sendNotificationToUser(
      userId: userId,
      title: title,
      body: body,
      customText: body,
      language: currentLanguage,
      type: NotificationType.paymentConfirmation,
      data: {'amount': amount, 'groupName': groupName},
    );
  }

  @override
  Future<Map<String, dynamic>> sendRenewalReminder({
    required String userId,
    required String groupName,
    required DateTime renewalDate,
    required double amount,
    String? language,
  }) async {
    final currentLanguage = await _getLanguage(language);
    final title =
        currentLanguage == 'ar' ? 'تذكير التجديد' : 'Renewal Reminder';
    final body =
        currentLanguage == 'ar'
            ? 'اشتراك $groupName ينتهي في ${_formatDateArabic(renewalDate)}'
            : '$groupName subscription expires on ${_formatDateEnglish(renewalDate)}';

    return await apiService.sendNotificationToUser(
      userId: userId,
      title: title,
      body: body,
      customText: body,
      language: currentLanguage,
      type: NotificationType.upcomingRenewal,
      data: {
        'groupName': groupName,
        'renewalDate': renewalDate.toIso8601String(),
        'amount': amount,
      },
    );
  }

  @override
  Future<Map<String, dynamic>> sendGroupMessage({
    required String recipientUserId,
    required String groupId,
    required String senderName,
    required String message,
    String? language,
  }) async {
    final currentLanguage = await _getLanguage(language);
    final title =
        currentLanguage == 'ar' ? 'رسالة مجموعة جديدة' : 'New Group Message';
    final body =
        currentLanguage == 'ar'
            ? '$senderName: $message'
            : '$senderName: $message';

    return await apiService.sendNotificationToUser(
      userId: recipientUserId,
      title: title,
      body: body,
      customText: body,
      language: currentLanguage,
      type: NotificationType.groupMessage,
      groupId: groupId,
      data: {'senderName': senderName, 'message': message, 'groupId': groupId},
    );
  }

  @override
  Future<void> handleGroupActivity({
    required String affectedUserId,
    required String groupId,
    required String activityType,
    required String activityDescription,
    String? language,
  }) async {
    final currentLanguage = await _getLanguage(language);
    await apiService.sendGroupActivityNotification(
      activityType: activityType,
      groupId: groupId,
      affectedUserId: affectedUserId,
      contextData: {'description': activityDescription},
      language: currentLanguage,
    );
  }

  @override
  Future<void> registerDeviceToken({
    required String userId,
    required String token,
    String platform = 'flutter',
  }) async {
    return await apiService.registerDeviceToken(
      userId: userId,
      token: token,
      deviceType: platform,
    );
  }

  @override
  Future<void> updateNotificationPreferences({
    required String userId,
    required Map<String, dynamic> preferences,
  }) async {
    await apiService.updateNotificationPreferences(preferences);
  }

  @override
  Future<Map<String, dynamic>> getNotificationPreferences(String userId) async {
    final preferences = await apiService.getNotificationPreferences(userId);
    return preferences.toJson();
  }

  /// Helper: Format date for Arabic display
  String _formatDateArabic(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  /// Helper: Format date for English display
  String _formatDateEnglish(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}
