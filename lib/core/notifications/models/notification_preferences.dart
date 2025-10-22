import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:subscription_splitter_app/core/notifications/models/notification_model.dart';

/// {@template notification_preferences}
/// Model representing user notification preferences
/// {@endtemplate}
class NotificationPreferences extends Equatable {
  /// {@macro notification_preferences}
  const NotificationPreferences({
    this.enabled = true,
    this.pushNotifications = true,
    this.emailNotifications = false,
    this.smsNotifications = false,
    this.paymentReminders = true,
    this.paymentOverdue = true,
    this.paymentConfirmations = true,
    this.newMemberJoined = true,
    this.memberLeft = true,
    this.groupInvitations = true,
    this.upcomingRenewals = true,
    this.renewalSuccessful = true,
    this.renewalFailed = true,
    this.groupHealthAlerts = true,
    this.lowGroupActivity = false,
    this.groupMessages = true,
    this.memberMentions = true,
    this.savingsMilestones = true,
    this.groupMilestones = true,
    this.appUpdates = true,
    this.serviceOutages = true,
    this.quietHoursEnabled = false,
    this.quietHoursStart = const TimeOfDay(hour: 22, minute: 0),
    this.quietHoursEnd = const TimeOfDay(hour: 8, minute: 0),
  });

  /// Whether notifications are enabled globally
  final bool enabled;

  /// Whether push notifications are enabled
  final bool pushNotifications;

  /// Whether email notifications are enabled
  final bool emailNotifications;

  /// Whether SMS notifications are enabled
  final bool smsNotifications;

  // Payment-related preferences
  final bool paymentReminders;
  final bool paymentOverdue;
  final bool paymentConfirmations;

  // Group management preferences
  final bool newMemberJoined;
  final bool memberLeft;
  final bool groupInvitations;

  // Renewal preferences
  final bool upcomingRenewals;
  final bool renewalSuccessful;
  final bool renewalFailed;

  // Admin preferences
  final bool groupHealthAlerts;
  final bool lowGroupActivity;

  // Communication preferences
  final bool groupMessages;
  final bool memberMentions;

  // Achievement preferences
  final bool savingsMilestones;
  final bool groupMilestones;

  // System preferences
  final bool appUpdates;
  final bool serviceOutages;

  // Quiet hours preferences
  final bool quietHoursEnabled;
  final TimeOfDay quietHoursStart;
  final TimeOfDay quietHoursEnd;

  @override
  List<Object?> get props => [
    enabled,
    pushNotifications,
    emailNotifications,
    smsNotifications,
    paymentReminders,
    paymentOverdue,
    paymentConfirmations,
    newMemberJoined,
    memberLeft,
    groupInvitations,
    upcomingRenewals,
    renewalSuccessful,
    renewalFailed,
    groupHealthAlerts,
    lowGroupActivity,
    groupMessages,
    memberMentions,
    savingsMilestones,
    groupMilestones,
    appUpdates,
    serviceOutages,
    quietHoursEnabled,
    quietHoursStart,
    quietHoursEnd,
  ];

  /// Create a copy with updated fields
  NotificationPreferences copyWith({
    bool? enabled,
    bool? pushNotifications,
    bool? emailNotifications,
    bool? smsNotifications,
    bool? paymentReminders,
    bool? paymentOverdue,
    bool? paymentConfirmations,
    bool? newMemberJoined,
    bool? memberLeft,
    bool? groupInvitations,
    bool? upcomingRenewals,
    bool? renewalSuccessful,
    bool? renewalFailed,
    bool? groupHealthAlerts,
    bool? lowGroupActivity,
    bool? groupMessages,
    bool? memberMentions,
    bool? savingsMilestones,
    bool? groupMilestones,
    bool? appUpdates,
    bool? serviceOutages,
    bool? quietHoursEnabled,
    TimeOfDay? quietHoursStart,
    TimeOfDay? quietHoursEnd,
  }) {
    return NotificationPreferences(
      enabled: enabled ?? this.enabled,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      smsNotifications: smsNotifications ?? this.smsNotifications,
      paymentReminders: paymentReminders ?? this.paymentReminders,
      paymentOverdue: paymentOverdue ?? this.paymentOverdue,
      paymentConfirmations: paymentConfirmations ?? this.paymentConfirmations,
      newMemberJoined: newMemberJoined ?? this.newMemberJoined,
      memberLeft: memberLeft ?? this.memberLeft,
      groupInvitations: groupInvitations ?? this.groupInvitations,
      upcomingRenewals: upcomingRenewals ?? this.upcomingRenewals,
      renewalSuccessful: renewalSuccessful ?? this.renewalSuccessful,
      renewalFailed: renewalFailed ?? this.renewalFailed,
      groupHealthAlerts: groupHealthAlerts ?? this.groupHealthAlerts,
      lowGroupActivity: lowGroupActivity ?? this.lowGroupActivity,
      groupMessages: groupMessages ?? this.groupMessages,
      memberMentions: memberMentions ?? this.memberMentions,
      savingsMilestones: savingsMilestones ?? this.savingsMilestones,
      groupMilestones: groupMilestones ?? this.groupMilestones,
      appUpdates: appUpdates ?? this.appUpdates,
      serviceOutages: serviceOutages ?? this.serviceOutages,
      quietHoursEnabled: quietHoursEnabled ?? this.quietHoursEnabled,
      quietHoursStart: quietHoursStart ?? this.quietHoursStart,
      quietHoursEnd: quietHoursEnd ?? this.quietHoursEnd,
    );
  }

  /// Create from JSON
  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    return NotificationPreferences(
      enabled: json['enabled'] as bool? ?? true,
      pushNotifications: json['pushNotifications'] as bool? ?? true,
      emailNotifications: json['emailNotifications'] as bool? ?? false,
      smsNotifications: json['smsNotifications'] as bool? ?? false,
      paymentReminders: json['paymentReminders'] as bool? ?? true,
      paymentOverdue: json['paymentOverdue'] as bool? ?? true,
      paymentConfirmations: json['paymentConfirmations'] as bool? ?? true,
      newMemberJoined: json['newMemberJoined'] as bool? ?? true,
      memberLeft: json['memberLeft'] as bool? ?? true,
      groupInvitations: json['groupInvitations'] as bool? ?? true,
      upcomingRenewals: json['upcomingRenewals'] as bool? ?? true,
      renewalSuccessful: json['renewalSuccessful'] as bool? ?? true,
      renewalFailed: json['renewalFailed'] as bool? ?? true,
      groupHealthAlerts: json['groupHealthAlerts'] as bool? ?? true,
      lowGroupActivity: json['lowGroupActivity'] as bool? ?? false,
      groupMessages: json['groupMessages'] as bool? ?? true,
      memberMentions: json['memberMentions'] as bool? ?? true,
      savingsMilestones: json['savingsMilestones'] as bool? ?? true,
      groupMilestones: json['groupMilestones'] as bool? ?? true,
      appUpdates: json['appUpdates'] as bool? ?? true,
      serviceOutages: json['serviceOutages'] as bool? ?? true,
      quietHoursEnabled: json['quietHoursEnabled'] as bool? ?? false,
      quietHoursStart:
          json['quietHoursStart'] != null
              ? TimeOfDayJson.fromJson(
                json['quietHoursStart'] as Map<String, dynamic>,
              )
              : const TimeOfDay(hour: 22, minute: 0),
      quietHoursEnd:
          json['quietHoursEnd'] != null
              ? TimeOfDayJson.fromJson(
                json['quietHoursEnd'] as Map<String, dynamic>,
              )
              : const TimeOfDay(hour: 8, minute: 0),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'pushNotifications': pushNotifications,
      'emailNotifications': emailNotifications,
      'smsNotifications': smsNotifications,
      'paymentReminders': paymentReminders,
      'paymentOverdue': paymentOverdue,
      'paymentConfirmations': paymentConfirmations,
      'newMemberJoined': newMemberJoined,
      'memberLeft': memberLeft,
      'groupInvitations': groupInvitations,
      'upcomingRenewals': upcomingRenewals,
      'renewalSuccessful': renewalSuccessful,
      'renewalFailed': renewalFailed,
      'groupHealthAlerts': groupHealthAlerts,
      'lowGroupActivity': lowGroupActivity,
      'groupMessages': groupMessages,
      'memberMentions': memberMentions,
      'savingsMilestones': savingsMilestones,
      'groupMilestones': groupMilestones,
      'appUpdates': appUpdates,
      'serviceOutages': serviceOutages,
      'quietHoursEnabled': quietHoursEnabled,
      'quietHoursStart': {
        'hour': quietHoursStart.hour,
        'minute': quietHoursStart.minute,
      },
      'quietHoursEnd': {
        'hour': quietHoursEnd.hour,
        'minute': quietHoursEnd.minute,
      },
    };
  }

  /// Check if a specific notification type is enabled
  bool isNotificationEnabled(NotificationType type) {
    if (!enabled || !pushNotifications) return false;

    // Check quiet hours
    if (quietHoursEnabled && _isInQuietHours()) return false;

    switch (type) {
      case NotificationType.paymentReminder:
        return paymentReminders;
      case NotificationType.paymentConfirm:
        return paymentConfirmations;
      case NotificationType.paymentOverdue:
        return paymentOverdue;
      case NotificationType.paymentConfirmation:
        return paymentConfirmations;
      case NotificationType.memberJoined:
        return newMemberJoined;
      case NotificationType.newMemberJoined:
        return newMemberJoined;
      case NotificationType.memberLeft:
        return memberLeft;
      case NotificationType.groupInvite:
        return groupInvitations;
      case NotificationType.groupInvitation:
        return groupInvitations;
      case NotificationType.renewalReminder:
        return upcomingRenewals;
      case NotificationType.upcomingRenewal:
        return upcomingRenewals;
      case NotificationType.renewalSuccessful:
        return renewalSuccessful;
      case NotificationType.renewalFailed:
        return renewalFailed;
      case NotificationType.adminMessage:
        return groupHealthAlerts;
      case NotificationType.groupHealthAlert:
        return groupHealthAlerts;
      case NotificationType.lowGroupActivity:
        return lowGroupActivity;
      case NotificationType.groupMessage:
        return groupMessages;
      case NotificationType.memberMention:
        return memberMentions;
      case NotificationType.achievement:
        return savingsMilestones;
      case NotificationType.savingsMilestone:
        return savingsMilestones;
      case NotificationType.groupMilestone:
        return groupMilestones;
      case NotificationType.system:
        return appUpdates;
      case NotificationType.appUpdate:
        return appUpdates;
      case NotificationType.serviceOutage:
        return serviceOutages;
    }
  }

  /// Check if current time is within quiet hours
  bool _isInQuietHours() {
    final now = DateTime.now();
    final currentTime = TimeOfDay(hour: now.hour, minute: now.minute);

    // Convert to minutes for easier comparison
    final currentMinutes = currentTime.hour * 60 + currentTime.minute;
    final startMinutes = quietHoursStart.hour * 60 + quietHoursStart.minute;
    final endMinutes = quietHoursEnd.hour * 60 + quietHoursEnd.minute;

    if (startMinutes <= endMinutes) {
      // Same day quiet hours (e.g., 22:00 to 08:00)
      return currentMinutes >= startMinutes && currentMinutes <= endMinutes;
    } else {
      // Overnight quiet hours (e.g., 22:00 to 08:00)
      return currentMinutes >= startMinutes || currentMinutes <= endMinutes;
    }
  }
}

/// Extension for TimeOfDay to support JSON serialization
extension TimeOfDayJson on TimeOfDay {
  /// Create TimeOfDay from JSON
  static TimeOfDay fromJson(Map<String, dynamic> json) {
    return TimeOfDay(hour: json['hour'] as int, minute: json['minute'] as int);
  }
}
