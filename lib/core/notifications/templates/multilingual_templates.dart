import 'package:flutter/material.dart';
import 'package:subscription_splitter_app/core/notifications/models/notification_model.dart';

/// {@template multilingual_templates}
/// Multilingual notification templates supporting Arabic and English
/// {@endtemplate}
class MultilingualTemplates {
  /// Create a payment reminder notification with custom text
  static NotificationModel paymentReminder({
    required String groupId,
    required String groupName,
    required double amount,
    required DateTime dueDate,
    required String userId,
    String? customText,
    String language = 'en',
  }) {
    final template = _getPaymentReminderTemplate(
      language,
      groupName,
      amount,
      dueDate,
    );

    return NotificationModel(
      id: 'payment_reminder_${DateTime.now().millisecondsSinceEpoch}',
      type: NotificationType.paymentReminder,
      title: _getPaymentReminderTitle(language),
      body: customText ?? template,
      timestamp: DateTime.now(),
      groupId: groupId,
      userId: userId,
      actionType: NotificationActionType.openPayment,
      actionData: {
        'groupId': groupId,
        'amount': amount,
        'dueDate': dueDate.toIso8601String(),
      },
      customText: customText,
      language: language,
    );
  }

  /// Create a payment overdue notification with custom text
  static NotificationModel paymentOverdue({
    required String groupId,
    required String groupName,
    required double amount,
    required DateTime dueDate,
    required String userId,
    String? customText,
    String language = 'en',
  }) {
    final daysOverdue = DateTime.now().difference(dueDate).inDays;
    final template = _getPaymentOverdueTemplate(
      language,
      groupName,
      amount,
      daysOverdue,
    );

    return NotificationModel(
      id: 'payment_overdue_${DateTime.now().millisecondsSinceEpoch}',
      type: NotificationType.paymentOverdue,
      title: _getPaymentOverdueTitle(language),
      body: customText ?? template,
      timestamp: DateTime.now(),
      groupId: groupId,
      userId: userId,
      actionType: NotificationActionType.openPayment,
      actionData: {
        'groupId': groupId,
        'amount': amount,
        'dueDate': dueDate.toIso8601String(),
        'daysOverdue': daysOverdue,
      },
      customText: customText,
      language: language,
    );
  }

  /// Create a group invitation notification with custom text
  static NotificationModel groupInvitation({
    required String groupId,
    required String groupName,
    required String inviterName,
    required String userId,
    String? customText,
    String language = 'en',
  }) {
    final template = _getGroupInvitationTemplate(
      language,
      inviterName,
      groupName,
    );

    return NotificationModel(
      id: 'group_invitation_${DateTime.now().millisecondsSinceEpoch}',
      type: NotificationType.groupInvitation,
      title: _getGroupInvitationTitle(language),
      body: customText ?? template,
      timestamp: DateTime.now(),
      groupId: groupId,
      userId: userId,
      actionType: NotificationActionType.openInvitation,
      actionData: {'groupId': groupId, 'inviterName': inviterName},
      customText: customText,
      language: language,
    );
  }

  /// Create a new member joined notification with custom text
  static NotificationModel newMemberJoined({
    required String groupId,
    required String groupName,
    required String memberName,
    required String userId,
    String? customText,
    String language = 'en',
  }) {
    final template = _getNewMemberJoinedTemplate(
      language,
      memberName,
      groupName,
    );

    return NotificationModel(
      id: 'new_member_${DateTime.now().millisecondsSinceEpoch}',
      type: NotificationType.newMemberJoined,
      title: _getNewMemberJoinedTitle(language),
      body: customText ?? template,
      timestamp: DateTime.now(),
      groupId: groupId,
      userId: userId,
      actionType: NotificationActionType.openGroup,
      actionData: {'groupId': groupId, 'memberName': memberName},
      customText: customText,
      language: language,
    );
  }

  /// Create a renewal notification with custom text
  static NotificationModel upcomingRenewal({
    required String groupId,
    required String groupName,
    required double amount,
    required DateTime renewalDate,
    required String userId,
    String? customText,
    String language = 'en',
  }) {
    final daysUntilRenewal = renewalDate.difference(DateTime.now()).inDays;
    final template = _getUpcomingRenewalTemplate(
      language,
      groupName,
      amount,
      daysUntilRenewal,
    );

    return NotificationModel(
      id: 'upcoming_renewal_${DateTime.now().millisecondsSinceEpoch}',
      type: NotificationType.upcomingRenewal,
      title: _getUpcomingRenewalTitle(language),
      body: customText ?? template,
      timestamp: DateTime.now(),
      groupId: groupId,
      userId: userId,
      actionType: NotificationActionType.openGroup,
      actionData: {
        'groupId': groupId,
        'amount': amount,
        'renewalDate': renewalDate.toIso8601String(),
        'daysUntilRenewal': daysUntilRenewal,
      },
      customText: customText,
      language: language,
    );
  }

  /// Create a payment confirmation notification
  static NotificationModel paymentConfirmation({
    required String groupId,
    required String groupName,
    required double amount,
    required String userId,
    String? customText,
    String language = 'en',
  }) {
    final template = _getPaymentConfirmationTemplate(
      language,
      groupName,
      amount,
    );

    return NotificationModel(
      id: 'payment_confirmation_${DateTime.now().millisecondsSinceEpoch}',
      type: NotificationType.paymentConfirmation,
      title: _getPaymentConfirmationTitle(language),
      body: customText ?? template,
      timestamp: DateTime.now(),
      groupId: groupId,
      userId: userId,
      actionType: NotificationActionType.openGroup,
      actionData: {
        'groupId': groupId,
        'amount': amount,
        'timestamp': DateTime.now().toIso8601String(),
      },
      customText: customText,
      language: language,
    );
  }

  /// Create a member left notification
  static NotificationModel memberLeft({
    required String groupId,
    required String groupName,
    required String memberName,
    required String userId,
    String? customText,
    String language = 'en',
  }) {
    final template = _getMemberLeftTemplate(language, memberName, groupName);

    return NotificationModel(
      id: 'member_left_${DateTime.now().millisecondsSinceEpoch}',
      type: NotificationType.memberLeft,
      title: _getMemberLeftTitle(language),
      body: customText ?? template,
      timestamp: DateTime.now(),
      groupId: groupId,
      userId: userId,
      actionType: NotificationActionType.openGroup,
      actionData: {
        'groupId': groupId,
        'memberName': memberName,
        'timestamp': DateTime.now().toIso8601String(),
      },
      customText: customText,
      language: language,
    );
  }

  /// Create a custom notification with user-defined text
  static NotificationModel customNotification({
    required String groupId,
    required String title,
    required String customText,
    required String userId,
    NotificationType type = NotificationType.groupMessage,
    NotificationActionType? actionType,
    Map<String, dynamic> actionData = const {},
    String language = 'en',
  }) {
    return NotificationModel(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      type: type,
      title: title,
      body: customText,
      timestamp: DateTime.now(),
      groupId: groupId,
      userId: userId,
      actionType: actionType,
      actionData: actionData,
      customText: customText,
      language: language,
    );
  }

  // Template methods for English
  static String _getPaymentReminderTemplate(
    String language,
    String groupName,
    double amount,
    DateTime dueDate,
  ) {
    if (language == 'ar') {
      return 'تذكير بالدفع: مبلغ \$${amount.toStringAsFixed(2)} مستحق لمجموعة $groupName في ${_formatDateArabic(dueDate)}';
    }
    return 'Payment reminder: \$${amount.toStringAsFixed(2)} is due for $groupName on ${_formatDate(dueDate)}';
  }

  static String _getPaymentOverdueTemplate(
    String language,
    String groupName,
    double amount,
    int daysOverdue,
  ) {
    if (language == 'ar') {
      return 'دفعة متأخرة: مبلغ \$${amount.toStringAsFixed(2)} لمجموعة $groupName متأخر $daysOverdue أيام';
    }
    return 'Overdue payment: \$${amount.toStringAsFixed(2)} for $groupName is $daysOverdue days overdue';
  }

  static String _getGroupInvitationTemplate(
    String language,
    String inviterName,
    String groupName,
  ) {
    if (language == 'ar') {
      return '$inviterName دعاك للانضمام إلى مجموعة $groupName';
    }
    return '$inviterName has invited you to join $groupName';
  }

  static String _getNewMemberJoinedTemplate(
    String language,
    String memberName,
    String groupName,
  ) {
    if (language == 'ar') {
      return 'انضم $memberName إلى مجموعة $groupName';
    }
    return '$memberName has joined $groupName';
  }

  static String _getUpcomingRenewalTemplate(
    String language,
    String groupName,
    double amount,
    int daysUntilRenewal,
  ) {
    if (language == 'ar') {
      return 'تجديد قريب: $groupName سيتجدد خلال $daysUntilRenewal أيام بمبلغ \$${amount.toStringAsFixed(2)}';
    }
    return 'Upcoming renewal: $groupName will renew in $daysUntilRenewal days for \$${amount.toStringAsFixed(2)}';
  }

  // Title methods for English
  static String _getPaymentReminderTitle(String language) {
    return language == 'ar' ? '💰 تذكير بالدفع' : '💰 Payment Reminder';
  }

  static String _getPaymentOverdueTitle(String language) {
    return language == 'ar' ? '⚠️ دفعة متأخرة' : '⚠️ Payment Overdue';
  }

  static String _getGroupInvitationTitle(String language) {
    return language == 'ar' ? '📨 دعوة للمجموعة' : '📨 Group Invitation';
  }

  static String _getNewMemberJoinedTitle(String language) {
    return language == 'ar' ? '👥 عضو جديد' : '👥 New Member Joined';
  }

  static String _getUpcomingRenewalTitle(String language) {
    return language == 'ar' ? '🔄 تجديد قريب' : '🔄 Upcoming Renewal';
  }

  // Payment confirmation templates
  static String _getPaymentConfirmationTemplate(
    String language,
    String groupName,
    double amount,
  ) {
    if (language == 'ar') {
      return 'الدفع تم بنجاح: \$${amount.toStringAsFixed(2)} لمجموعة $groupName';
    }
    return 'Payment confirmed: \$${amount.toStringAsFixed(2)} for $groupName';
  }

  static String _getPaymentConfirmationTitle(String language) {
    return language == 'ar' ? '✅ تم تأكيد الدفع' : '✅ Payment Confirmed';
  }

  // Member left templates
  static String _getMemberLeftTemplate(
    String language,
    String memberName,
    String groupName,
  ) {
    if (language == 'ar') {
      return '$memberName غادر مجموعة $groupName';
    }
    return '$memberName left $groupName group';
  }

  static String _getMemberLeftTitle(String language) {
    return language == 'ar' ? '👋 عضو غادر' : '👋 Member Left';
  }

  // Helper methods
  static String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;

    if (difference == 0) {
      return 'today';
    } else if (difference == 1) {
      return 'tomorrow';
    } else if (difference == -1) {
      return 'yesterday';
    } else if (difference > 0) {
      return 'in $difference days';
    } else {
      return '${-difference} days ago';
    }
  }

  static String _formatDateArabic(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;

    if (difference == 0) {
      return 'اليوم';
    } else if (difference == 1) {
      return 'غداً';
    } else if (difference == -1) {
      return 'أمس';
    } else if (difference > 0) {
      return 'خلال $difference أيام';
    } else {
      return 'منذ ${-difference} أيام';
    }
  }

  /// Get all supported languages
  static List<String> get supportedLanguages => ['en', 'ar'];

  /// Check if a language is supported
  static bool isLanguageSupported(String language) {
    return supportedLanguages.contains(language);
  }

  /// Get language display name
  static String getLanguageDisplayName(String language) {
    switch (language) {
      case 'en':
        return 'English';
      case 'ar':
        return 'العربية';
      default:
        return 'English';
    }
  }

  /// Get language direction (LTR or RTL)
  static TextDirection getLanguageDirection(String language) {
    switch (language) {
      case 'ar':
        return TextDirection.rtl;
      case 'en':
      default:
        return TextDirection.ltr;
    }
  }
}
