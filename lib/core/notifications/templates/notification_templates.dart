import 'package:subscription_splitter_app/core/notifications/models/notification_model.dart';

/// {@template notification_templates}
/// Templates for creating different types of notifications
/// {@endtemplate}
class NotificationTemplates {
  /// Create a payment reminder notification
  static NotificationModel paymentReminder({
    required String groupId,
    required String groupName,
    required double amount,
    required DateTime dueDate,
    required String userId,
  }) {
    return NotificationModel(
      id: 'payment_reminder_${DateTime.now().millisecondsSinceEpoch}',
      type: NotificationType.paymentReminder,
      title: '💰 Payment Reminder',
      body:
          'Your payment of \$${amount.toStringAsFixed(2)} for $groupName is due on ${_formatDate(dueDate)}',
      timestamp: DateTime.now(),
      groupId: groupId,
      userId: userId,
      actionType: NotificationActionType.openPayment,
      actionData: {
        'groupId': groupId,
        'amount': amount,
        'dueDate': dueDate.toIso8601String(),
      },
    );
  }

  /// Create a payment overdue notification
  static NotificationModel paymentOverdue({
    required String groupId,
    required String groupName,
    required double amount,
    required DateTime dueDate,
    required String userId,
  }) {
    final daysOverdue = DateTime.now().difference(dueDate).inDays;
    return NotificationModel(
      id: 'payment_overdue_${DateTime.now().millisecondsSinceEpoch}',
      type: NotificationType.paymentOverdue,
      title: '⚠️ Payment Overdue',
      body:
          'Your payment of \$${amount.toStringAsFixed(2)} for $groupName is $daysOverdue days overdue',
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
    );
  }

  /// Create a payment confirmation notification
  static NotificationModel paymentConfirmation({
    required String groupId,
    required String groupName,
    required double amount,
    required String userId,
  }) {
    return NotificationModel(
      id: 'payment_confirmation_${DateTime.now().millisecondsSinceEpoch}',
      type: NotificationType.paymentConfirmation,
      title: '✅ Payment Confirmed',
      body:
          'Your payment of \$${amount.toStringAsFixed(2)} for $groupName has been confirmed',
      timestamp: DateTime.now(),
      groupId: groupId,
      userId: userId,
      actionType: NotificationActionType.openGroup,
      actionData: {'groupId': groupId},
    );
  }

  /// Create a new member joined notification
  static NotificationModel newMemberJoined({
    required String groupId,
    required String groupName,
    required String memberName,
    required String userId,
  }) {
    return NotificationModel(
      id: 'new_member_${DateTime.now().millisecondsSinceEpoch}',
      type: NotificationType.newMemberJoined,
      title: '👥 New Member Joined',
      body: '$memberName has joined $groupName',
      timestamp: DateTime.now(),
      groupId: groupId,
      userId: userId,
      actionType: NotificationActionType.openGroup,
      actionData: {'groupId': groupId, 'memberName': memberName},
    );
  }

  /// Create a member left notification
  static NotificationModel memberLeft({
    required String groupId,
    required String groupName,
    required String memberName,
    required String userId,
  }) {
    return NotificationModel(
      id: 'member_left_${DateTime.now().millisecondsSinceEpoch}',
      type: NotificationType.memberLeft,
      title: '👋 Member Left',
      body: '$memberName has left $groupName',
      timestamp: DateTime.now(),
      groupId: groupId,
      userId: userId,
      actionType: NotificationActionType.openGroup,
      actionData: {'groupId': groupId, 'memberName': memberName},
    );
  }

  /// Create a group invitation notification
  static NotificationModel groupInvitation({
    required String groupId,
    required String groupName,
    required String inviterName,
    required String userId,
  }) {
    return NotificationModel(
      id: 'group_invitation_${DateTime.now().millisecondsSinceEpoch}',
      type: NotificationType.groupInvitation,
      title: '📨 Group Invitation',
      body: '$inviterName has invited you to join $groupName',
      timestamp: DateTime.now(),
      groupId: groupId,
      userId: userId,
      actionType: NotificationActionType.openInvitation,
      actionData: {'groupId': groupId, 'inviterName': inviterName},
    );
  }

  /// Create an upcoming renewal notification
  static NotificationModel upcomingRenewal({
    required String groupId,
    required String groupName,
    required double amount,
    required DateTime renewalDate,
    required String userId,
  }) {
    final daysUntilRenewal = renewalDate.difference(DateTime.now()).inDays;
    return NotificationModel(
      id: 'upcoming_renewal_${DateTime.now().millisecondsSinceEpoch}',
      type: NotificationType.upcomingRenewal,
      title: '🔄 Upcoming Renewal',
      body:
          '$groupName will renew in $daysUntilRenewal days for \$${amount.toStringAsFixed(2)}',
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
    );
  }

  /// Create a renewal successful notification
  static NotificationModel renewalSuccessful({
    required String groupId,
    required String groupName,
    required double amount,
    required String userId,
  }) {
    return NotificationModel(
      id: 'renewal_successful_${DateTime.now().millisecondsSinceEpoch}',
      type: NotificationType.renewalSuccessful,
      title: '✅ Renewal Successful',
      body: '$groupName has been renewed for \$${amount.toStringAsFixed(2)}',
      timestamp: DateTime.now(),
      groupId: groupId,
      userId: userId,
      actionType: NotificationActionType.openGroup,
      actionData: {'groupId': groupId, 'amount': amount},
    );
  }

  /// Create a renewal failed notification
  static NotificationModel renewalFailed({
    required String groupId,
    required String groupName,
    required double amount,
    required String reason,
    required String userId,
  }) {
    return NotificationModel(
      id: 'renewal_failed_${DateTime.now().millisecondsSinceEpoch}',
      type: NotificationType.renewalFailed,
      title: '❌ Renewal Failed',
      body:
          'Failed to renew $groupName for \$${amount.toStringAsFixed(2)}. $reason',
      timestamp: DateTime.now(),
      groupId: groupId,
      userId: userId,
      actionType: NotificationActionType.openGroup,
      actionData: {'groupId': groupId, 'amount': amount, 'reason': reason},
    );
  }

  /// Create a group health alert notification
  static NotificationModel groupHealthAlert({
    required String groupId,
    required String groupName,
    required String alertType,
    required String message,
    required String userId,
  }) {
    return NotificationModel(
      id: 'group_health_${DateTime.now().millisecondsSinceEpoch}',
      type: NotificationType.groupHealthAlert,
      title: '⚠️ Group Health Alert',
      body: '$groupName: $message',
      timestamp: DateTime.now(),
      groupId: groupId,
      userId: userId,
      actionType: NotificationActionType.openGroup,
      actionData: {
        'groupId': groupId,
        'alertType': alertType,
        'message': message,
      },
    );
  }

  /// Create a low group activity notification
  static NotificationModel lowGroupActivity({
    required String groupId,
    required String groupName,
    required int daysInactive,
    required String userId,
  }) {
    return NotificationModel(
      id: 'low_activity_${DateTime.now().millisecondsSinceEpoch}',
      type: NotificationType.lowGroupActivity,
      title: '📉 Low Group Activity',
      body: '$groupName has been inactive for $daysInactive days',
      timestamp: DateTime.now(),
      groupId: groupId,
      userId: userId,
      actionType: NotificationActionType.openGroup,
      actionData: {'groupId': groupId, 'daysInactive': daysInactive},
    );
  }

  /// Create a group message notification
  static NotificationModel groupMessage({
    required String groupId,
    required String groupName,
    required String senderName,
    required String message,
    required String userId,
  }) {
    return NotificationModel(
      id: 'group_message_${DateTime.now().millisecondsSinceEpoch}',
      type: NotificationType.groupMessage,
      title: '💬 $groupName',
      body: '$senderName: ${_truncateMessage(message)}',
      timestamp: DateTime.now(),
      groupId: groupId,
      userId: userId,
      actionType: NotificationActionType.openMessage,
      actionData: {
        'groupId': groupId,
        'senderName': senderName,
        'message': message,
      },
    );
  }

  /// Create a member mention notification
  static NotificationModel memberMention({
    required String groupId,
    required String groupName,
    required String senderName,
    required String message,
    required String userId,
  }) {
    return NotificationModel(
      id: 'member_mention_${DateTime.now().millisecondsSinceEpoch}',
      type: NotificationType.memberMention,
      title: '👋 You were mentioned',
      body:
          '$senderName mentioned you in $groupName: ${_truncateMessage(message)}',
      timestamp: DateTime.now(),
      groupId: groupId,
      userId: userId,
      actionType: NotificationActionType.openMessage,
      actionData: {
        'groupId': groupId,
        'senderName': senderName,
        'message': message,
      },
    );
  }

  /// Create a savings milestone notification
  static NotificationModel savingsMilestone({
    required String groupId,
    required String groupName,
    required double totalSavings,
    required String milestone,
    required String userId,
  }) {
    return NotificationModel(
      id: 'savings_milestone_${DateTime.now().millisecondsSinceEpoch}',
      type: NotificationType.savingsMilestone,
      title: '🏆 Savings Milestone!',
      body:
          'Congratulations! You\'ve saved \$${totalSavings.toStringAsFixed(2)} in $groupName',
      timestamp: DateTime.now(),
      groupId: groupId,
      userId: userId,
      actionType: NotificationActionType.openGroup,
      actionData: {
        'groupId': groupId,
        'totalSavings': totalSavings,
        'milestone': milestone,
      },
    );
  }

  /// Create a group milestone notification
  static NotificationModel groupMilestone({
    required String groupId,
    required String groupName,
    required String milestone,
    required String description,
    required String userId,
  }) {
    return NotificationModel(
      id: 'group_milestone_${DateTime.now().millisecondsSinceEpoch}',
      type: NotificationType.groupMilestone,
      title: '🎉 Group Milestone!',
      body: '$groupName has reached a new milestone: $description',
      timestamp: DateTime.now(),
      groupId: groupId,
      userId: userId,
      actionType: NotificationActionType.openGroup,
      actionData: {
        'groupId': groupId,
        'milestone': milestone,
        'description': description,
      },
    );
  }

  /// Create an app update notification
  static NotificationModel appUpdate({
    required String version,
    required String description,
    required String userId,
  }) {
    return NotificationModel(
      id: 'app_update_${DateTime.now().millisecondsSinceEpoch}',
      type: NotificationType.appUpdate,
      title: '🔧 App Update Available',
      body: 'Version $version is now available. $description',
      timestamp: DateTime.now(),
      userId: userId,
      actionType: NotificationActionType.openApp,
      actionData: {'version': version, 'description': description},
    );
  }

  /// Create a service outage notification
  static NotificationModel serviceOutage({
    required String service,
    required String description,
    required DateTime estimatedResolution,
    required String userId,
  }) {
    return NotificationModel(
      id: 'service_outage_${DateTime.now().millisecondsSinceEpoch}',
      type: NotificationType.serviceOutage,
      title: '🚨 Service Outage',
      body: '$service is currently experiencing issues. $description',
      timestamp: DateTime.now(),
      userId: userId,
      actionType: NotificationActionType.openApp,
      actionData: {
        'service': service,
        'description': description,
        'estimatedResolution': estimatedResolution.toIso8601String(),
      },
    );
  }

  /// Helper method to format dates
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

  /// Helper method to truncate long messages
  static String _truncateMessage(String message, {int maxLength = 50}) {
    if (message.length <= maxLength) {
      return message;
    }
    return '${message.substring(0, maxLength)}...';
  }
}
