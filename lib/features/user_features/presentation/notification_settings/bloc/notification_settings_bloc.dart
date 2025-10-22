import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:subscription_splitter_app/core/notifications/models/notification_preferences.dart';
import 'package:subscription_splitter_app/core/di/service_locator.dart';
import '../../../domain/repositories/notifications_repository.dart';

part 'notification_settings_event.dart';
part 'notification_settings_state.dart';

/// {@template notification_settings_bloc}
/// BLoC for managing notification settings state and business logic
/// {@endtemplate}
class NotificationSettingsBloc
    extends Bloc<NotificationSettingsEvent, NotificationSettingsState> {
  /// {@macro notification_settings_bloc}
  NotificationSettingsBloc() : super(const NotificationSettingsInitial()) {
    on<LoadNotificationSettings>(_onLoadNotificationSettings);
    on<UpdateNotificationSettings>(_onUpdateNotificationSettings);
    on<ToggleNotificationSetting>(_onToggleNotificationSetting);
    on<UpdateQuietHours>(_onUpdateQuietHours);
    on<ResetToDefaults>(_onResetToDefaults);
    on<SaveNotificationSettings>(_onSaveNotificationSettings);
  }

  final NotificationsRepository _notificationsRepository =
      ServiceLocator().notificationsRepository;

  /// Load notification settings
  FutureOr<void> _onLoadNotificationSettings(
    LoadNotificationSettings event,
    Emitter<NotificationSettingsState> emit,
  ) async {
    emit(const NotificationSettingsLoading());

    try {
      // Get current user ID
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        emit(
          const NotificationSettingsError(message: 'User not authenticated'),
        );
        return;
      }

      // Load preferences from repository
      final preferencesMap = await _notificationsRepository
          .getNotificationPreferences(user.id);
      final preferences = NotificationPreferences.fromJson(preferencesMap);

      emit(
        NotificationSettingsLoaded(
          preferences: preferences,
          hasUnsavedChanges: false,
        ),
      );
    } catch (e) {
      debugPrint('Error loading notification settings: $e');
      emit(NotificationSettingsError(message: 'Failed to load settings: $e'));
    }
  }

  /// Update notification settings
  FutureOr<void> _onUpdateNotificationSettings(
    UpdateNotificationSettings event,
    Emitter<NotificationSettingsState> emit,
  ) {
    if (state is NotificationSettingsLoaded) {
      final currentState = state as NotificationSettingsLoaded;
      emit(
        currentState.copyWith(
          preferences: event.preferences,
          hasUnsavedChanges: true,
        ),
      );
    }
  }

  /// Toggle a specific notification setting
  void _onToggleNotificationSetting(
    ToggleNotificationSetting event,
    Emitter<NotificationSettingsState> emit,
  ) {
    if (state is! NotificationSettingsLoaded) return;

    final currentState = state as NotificationSettingsLoaded;
    final updatedPreferences = _updateSetting(
      currentState.preferences,
      event.settingKey,
      event.value,
    );

    emit(
      currentState.copyWith(
        preferences: updatedPreferences,
        hasUnsavedChanges: true,
      ),
    );
  }

  /// Update quiet hours
  void _onUpdateQuietHours(
    UpdateQuietHours event,
    Emitter<NotificationSettingsState> emit,
  ) {
    if (state is! NotificationSettingsLoaded) return;

    final currentState = state as NotificationSettingsLoaded;
    final updatedPreferences = currentState.preferences.copyWith(
      quietHoursEnabled: event.enabled,
      quietHoursStart:
          event.startTime ?? currentState.preferences.quietHoursStart,
      quietHoursEnd: event.endTime ?? currentState.preferences.quietHoursEnd,
    );

    emit(
      currentState.copyWith(
        preferences: updatedPreferences,
        hasUnsavedChanges: true,
      ),
    );
  }

  /// Reset to default settings
  void _onResetToDefaults(
    ResetToDefaults event,
    Emitter<NotificationSettingsState> emit,
  ) {
    if (state is! NotificationSettingsLoaded) return;

    const defaultPreferences = NotificationPreferences();
    final currentState = state as NotificationSettingsLoaded;

    emit(
      currentState.copyWith(
        preferences: defaultPreferences,
        hasUnsavedChanges: true,
      ),
    );
  }

  /// Save notification settings
  FutureOr<void> _onSaveNotificationSettings(
    SaveNotificationSettings event,
    Emitter<NotificationSettingsState> emit,
  ) async {
    if (state is! NotificationSettingsLoaded) return;

    final currentState = state as NotificationSettingsLoaded;
    emit(currentState.copyWith(isSaving: true, error: null));

    try {
      // Get current user ID
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        emit(
          currentState.copyWith(
            isSaving: false,
            error: 'User not authenticated',
          ),
        );
        return;
      }

      // Save preferences via repository
      await _notificationsRepository.updateNotificationPreferences(
        userId: user.id,
        preferences: currentState.preferences.toJson(),
      );

      emit(
        currentState.copyWith(
          isSaving: false,
          hasUnsavedChanges: false,
          error: null,
        ),
      );
    } catch (e) {
      debugPrint('Error saving notification settings: $e');
      emit(
        currentState.copyWith(
          isSaving: false,
          error: 'Failed to save settings: $e',
        ),
      );
    }
  }

  /// Helper method to update a specific setting
  NotificationPreferences _updateSetting(
    NotificationPreferences preferences,
    String settingKey,
    bool value,
  ) {
    switch (settingKey) {
      case 'enabled':
        return preferences.copyWith(enabled: value);
      case 'pushNotifications':
        return preferences.copyWith(pushNotifications: value);
      case 'emailNotifications':
        return preferences.copyWith(emailNotifications: value);
      case 'smsNotifications':
        return preferences.copyWith(smsNotifications: value);
      case 'paymentReminders':
        return preferences.copyWith(paymentReminders: value);
      case 'paymentOverdue':
        return preferences.copyWith(paymentOverdue: value);
      case 'paymentConfirmations':
        return preferences.copyWith(paymentConfirmations: value);
      case 'newMemberJoined':
        return preferences.copyWith(newMemberJoined: value);
      case 'memberLeft':
        return preferences.copyWith(memberLeft: value);
      case 'groupInvitations':
        return preferences.copyWith(groupInvitations: value);
      case 'upcomingRenewals':
        return preferences.copyWith(upcomingRenewals: value);
      case 'renewalSuccessful':
        return preferences.copyWith(renewalSuccessful: value);
      case 'renewalFailed':
        return preferences.copyWith(renewalFailed: value);
      case 'groupMessages':
        return preferences.copyWith(groupMessages: value);
      case 'memberMentions':
        return preferences.copyWith(memberMentions: value);
      case 'savingsMilestones':
        return preferences.copyWith(savingsMilestones: value);
      case 'groupMilestones':
        return preferences.copyWith(groupMilestones: value);
      case 'appUpdates':
        return preferences.copyWith(appUpdates: value);
      case 'serviceOutages':
        return preferences.copyWith(serviceOutages: value);
      case 'quietHoursEnabled':
        return preferences.copyWith(quietHoursEnabled: value);
      default:
        return preferences;
    }
  }
}
