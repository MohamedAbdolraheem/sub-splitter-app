part of 'notification_settings_bloc.dart';

abstract class NotificationSettingsEvent extends Equatable {
  const NotificationSettingsEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load notification settings
class LoadNotificationSettings extends NotificationSettingsEvent {
  const LoadNotificationSettings();
}

/// Event to update notification settings
class UpdateNotificationSettings extends NotificationSettingsEvent {
  const UpdateNotificationSettings({required this.preferences});

  final NotificationPreferences preferences;

  @override
  List<Object?> get props => [preferences];
}

/// Event to toggle a specific setting
class ToggleNotificationSetting extends NotificationSettingsEvent {
  const ToggleNotificationSetting({
    required this.settingKey,
    required this.value,
  });

  final String settingKey;
  final bool value;

  @override
  List<Object?> get props => [settingKey, value];
}

/// Event to update quiet hours
class UpdateQuietHours extends NotificationSettingsEvent {
  const UpdateQuietHours({required this.enabled, this.startTime, this.endTime});

  final bool enabled;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;

  @override
  List<Object?> get props => [enabled, startTime, endTime];
}

/// Event to reset settings to defaults
class ResetToDefaults extends NotificationSettingsEvent {
  const ResetToDefaults();
}

/// Event to save settings
class SaveNotificationSettings extends NotificationSettingsEvent {
  const SaveNotificationSettings();
}
