part of 'notification_settings_bloc.dart';

abstract class NotificationSettingsState extends Equatable {
  const NotificationSettingsState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class NotificationSettingsInitial extends NotificationSettingsState {
  const NotificationSettingsInitial();
}

/// Loading state
class NotificationSettingsLoading extends NotificationSettingsState {
  const NotificationSettingsLoading();
}

/// Loaded state with settings
class NotificationSettingsLoaded extends NotificationSettingsState {
  const NotificationSettingsLoaded({
    required this.preferences,
    this.isLoading = false,
    this.isSaving = false,
    this.error,
    this.hasUnsavedChanges = false,
  });

  final NotificationPreferences preferences;
  final bool isLoading;
  final bool isSaving;
  final String? error;
  final bool hasUnsavedChanges;

  @override
  List<Object?> get props => [
    preferences,
    isLoading,
    isSaving,
    error,
    hasUnsavedChanges,
  ];

  NotificationSettingsLoaded copyWith({
    NotificationPreferences? preferences,
    bool? isLoading,
    bool? isSaving,
    String? error,
    bool? hasUnsavedChanges,
    bool clearError = false,
  }) {
    return NotificationSettingsLoaded(
      preferences: preferences ?? this.preferences,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      error: clearError ? null : (error ?? this.error),
      hasUnsavedChanges: hasUnsavedChanges ?? this.hasUnsavedChanges,
    );
  }
}

/// Error state
class NotificationSettingsError extends NotificationSettingsState {
  const NotificationSettingsError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
