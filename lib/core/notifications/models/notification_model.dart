import 'package:equatable/equatable.dart';

/// {@template notification_model}
/// Model representing a notification in the app
/// {@endtemplate}
class NotificationModel extends Equatable {
  /// {@macro notification_model}
  const NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.timestamp,
    this.data = const {},
    this.isRead = false,
    this.groupId,
    this.userId,
    this.actionType,
    this.actionData = const {},
    this.customText,
    this.language = 'en',
  });

  /// Unique identifier for the notification
  final String id;

  /// Type of notification
  final NotificationType type;

  /// Notification title
  final String title;

  /// Notification body/message
  final String body;

  /// When the notification was created
  final DateTime timestamp;

  /// Additional data payload
  final Map<String, dynamic> data;

  /// Whether the notification has been read
  final bool isRead;

  /// Associated group ID (if applicable)
  final String? groupId;

  /// Target user ID
  final String? userId;

  /// Action type for handling notification tap
  final NotificationActionType? actionType;

  /// Data for the action
  final Map<String, dynamic> actionData;

  /// Custom text for the notification (overrides default template)
  final String? customText;

  /// Language of the notification ('en' or 'ar')
  final String language;

  @override
  List<Object?> get props => [
    id,
    type,
    title,
    body,
    timestamp,
    data,
    isRead,
    groupId,
    userId,
    actionType,
    actionData,
    customText,
    language,
  ];

  /// Create a copy of this notification with updated fields
  NotificationModel copyWith({
    String? id,
    NotificationType? type,
    String? title,
    String? body,
    DateTime? timestamp,
    Map<String, dynamic>? data,
    bool? isRead,
    String? groupId,
    String? userId,
    NotificationActionType? actionType,
    Map<String, dynamic>? actionData,
    String? customText,
    String? language,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      body: body ?? this.body,
      timestamp: timestamp ?? this.timestamp,
      data: data ?? this.data,
      isRead: isRead ?? this.isRead,
      groupId: groupId ?? this.groupId,
      userId: userId ?? this.userId,
      actionType: actionType ?? this.actionType,
      actionData: actionData ?? this.actionData,
      customText: customText ?? this.customText,
      language: language ?? this.language,
    );
  }

  /// Create notification from JSON
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      type: NotificationType.fromString(json['type'] as String),
      title: json['title'] as String,
      body: json['body'] as String,
      // Handle both 'timestamp' and 'created_at' field names
      timestamp:
          json['timestamp'] != null
              ? DateTime.parse(json['timestamp'] as String)
              : DateTime.parse(json['created_at'] as String),
      data: Map<String, dynamic>.from(json['data'] as Map? ?? {}),
      // Handle both 'isRead' and 'is_read' field names
      isRead: json['isRead'] as bool? ?? json['is_read'] as bool? ?? false,
      // Handle both 'groupId' and 'group_id' field names
      groupId: json['groupId'] as String? ?? json['group_id'] as String?,
      // Handle both 'userId' and 'user_id' field names
      userId: json['userId'] as String? ?? json['user_id'] as String?,
      actionType:
          json['actionType'] != null
              ? NotificationActionType.fromString(json['actionType'] as String)
              : null,
      actionData: Map<String, dynamic>.from(json['actionData'] as Map? ?? {}),
      // Handle both 'customText' and 'custom_text' field names
      customText:
          json['customText'] as String? ?? json['custom_text'] as String?,
      language: json['language'] as String? ?? 'en',
    );
  }

  /// Convert notification to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.value,
      'title': title,
      'body': body,
      'timestamp': timestamp.toIso8601String(),
      'data': data,
      'isRead': isRead,
      'groupId': groupId,
      'userId': userId,
      'actionType': actionType?.value,
      'actionData': actionData,
      'customText': customText,
      'language': language,
    };
  }

  /// Get the display text (custom text if available, otherwise body)
  String get displayText => customText ?? body;

  /// Check if the notification is in Arabic
  bool get isArabic => language == 'ar';

  /// Check if the notification is in English
  bool get isEnglish => language == 'en';
}

/// {@template notification_type}
/// Enum representing different types of notifications
/// {@endtemplate}
enum NotificationType {
  // Payment-related notifications
  paymentReminder('payment_reminder'),
  paymentConfirm('payment_confirm'), // Backend API type
  paymentOverdue('payment_overdue'),
  paymentConfirmation('payment_confirmation'),

  // Group management notifications
  memberJoined('member_joined'), // Backend API type
  newMemberJoined('new_member_joined'),
  memberLeft('member_left'),
  groupInvite('group_invite'), // Backend API type
  groupInvitation('group_invitation'),

  // Renewal notifications
  renewalReminder('renewal_reminder'), // Backend API type
  upcomingRenewal('upcoming_renewal'),
  renewalSuccessful('renewal_successful'),
  renewalFailed('renewal_failed'),

  // Admin notifications
  adminMessage('admin_message'), // Backend API type
  groupHealthAlert('group_health_alert'),
  lowGroupActivity('low_group_activity'),

  // Communication notifications
  groupMessage('group_message'),
  memberMention('member_mention'),

  // Achievement notifications
  achievement('achievement'), // Backend API type
  savingsMilestone('savings_milestone'),
  groupMilestone('group_milestone'),

  // System notifications
  system('system'), // Backend API type
  appUpdate('app_update'),
  serviceOutage('service_outage');

  const NotificationType(this.value);

  final String value;

  /// Create NotificationType from string value
  static NotificationType fromString(String value) {
    return NotificationType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => NotificationType.groupMessage, // Default fallback
    );
  }

  /// Get display name for the notification type
  String get displayName {
    switch (this) {
      case NotificationType.paymentReminder:
        return 'Payment Reminder';
      case NotificationType.paymentConfirm:
        return 'Payment Confirmation';
      case NotificationType.paymentOverdue:
        return 'Payment Overdue';
      case NotificationType.paymentConfirmation:
        return 'Payment Confirmation';
      case NotificationType.memberJoined:
        return 'Member Joined';
      case NotificationType.newMemberJoined:
        return 'New Member Joined';
      case NotificationType.memberLeft:
        return 'Member Left';
      case NotificationType.groupInvite:
        return 'Group Invitation';
      case NotificationType.groupInvitation:
        return 'Group Invitation';
      case NotificationType.renewalReminder:
        return 'Renewal Reminder';
      case NotificationType.upcomingRenewal:
        return 'Upcoming Renewal';
      case NotificationType.renewalSuccessful:
        return 'Renewal Successful';
      case NotificationType.renewalFailed:
        return 'Renewal Failed';
      case NotificationType.adminMessage:
        return 'Admin Message';
      case NotificationType.groupHealthAlert:
        return 'Group Health Alert';
      case NotificationType.lowGroupActivity:
        return 'Low Group Activity';
      case NotificationType.groupMessage:
        return 'Group Message';
      case NotificationType.memberMention:
        return 'Member Mention';
      case NotificationType.achievement:
        return 'Achievement';
      case NotificationType.savingsMilestone:
        return 'Savings Milestone';
      case NotificationType.groupMilestone:
        return 'Group Milestone';
      case NotificationType.system:
        return 'System Notification';
      case NotificationType.appUpdate:
        return 'App Update';
      case NotificationType.serviceOutage:
        return 'Service Outage';
    }
  }

  /// Get icon for the notification type
  String get icon {
    switch (this) {
      case NotificationType.paymentReminder:
      case NotificationType.paymentConfirm:
      case NotificationType.paymentOverdue:
      case NotificationType.paymentConfirmation:
        return '💰';
      case NotificationType.memberJoined:
      case NotificationType.newMemberJoined:
      case NotificationType.memberLeft:
      case NotificationType.groupInvite:
      case NotificationType.groupInvitation:
        return '👥';
      case NotificationType.renewalReminder:
      case NotificationType.upcomingRenewal:
      case NotificationType.renewalSuccessful:
      case NotificationType.renewalFailed:
        return '🔄';
      case NotificationType.adminMessage:
      case NotificationType.groupHealthAlert:
      case NotificationType.lowGroupActivity:
        return '⚠️';
      case NotificationType.groupMessage:
      case NotificationType.memberMention:
        return '💬';
      case NotificationType.achievement:
      case NotificationType.savingsMilestone:
      case NotificationType.groupMilestone:
        return '🏆';
      case NotificationType.system:
      case NotificationType.appUpdate:
      case NotificationType.serviceOutage:
        return '🔧';
    }
  }

  /// Get priority level for the notification type
  NotificationPriority get priority {
    switch (this) {
      case NotificationType.paymentOverdue:
      case NotificationType.renewalFailed:
      case NotificationType.serviceOutage:
        return NotificationPriority.high;
      case NotificationType.paymentReminder:
      case NotificationType.upcomingRenewal:
      case NotificationType.groupHealthAlert:
        return NotificationPriority.medium;
      default:
        return NotificationPriority.low;
    }
  }
}

/// {@template notification_action_type}
/// Enum representing different action types for notifications
/// {@endtemplate}
enum NotificationActionType {
  openGroup('open_group'),
  openPayment('open_payment'),
  openSettings('open_settings'),
  openProfile('open_profile'),
  openInvitation('open_invitation'),
  openMessage('open_message'),
  openApp('open_app');

  const NotificationActionType(this.value);

  final String value;

  /// Create NotificationActionType from string value
  static NotificationActionType fromString(String value) {
    return NotificationActionType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => NotificationActionType.openApp, // Default fallback
    );
  }
}

/// {@template notification_priority}
/// Enum representing notification priority levels
/// {@endtemplate}
enum NotificationPriority {
  low('low'),
  medium('medium'),
  high('high');

  const NotificationPriority(this.value);

  final String value;
}
