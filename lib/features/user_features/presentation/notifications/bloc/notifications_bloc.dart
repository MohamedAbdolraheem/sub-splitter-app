import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:subscription_splitter_app/core/notifications/models/notification_model.dart';
import 'package:subscription_splitter_app/core/di/service_locator.dart';
import '../../../domain/repositories/notifications_repository.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

/// {@template notifications_bloc}
/// BLoC for managing notifications state and business logic
/// {@endtemplate}
class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  /// {@macro notifications_bloc}
  NotificationsBloc() : super(const NotificationsInitial()) {
    on<CustomNotificationsEvent>(_onCustomNotificationsEvent);
    on<LoadNotifications>(_onLoadNotifications);
    on<RefreshNotifications>(_onRefreshNotifications);
    on<MarkNotificationAsRead>(_onMarkNotificationAsRead);
    on<DeleteNotification>(_onDeleteNotification);
    on<FilterNotifications>(_onFilterNotifications);
    on<AddNotification>(_onAddNotification);
    on<ClearAllNotifications>(_onClearAllNotifications);
    on<MarkAllAsRead>(_onMarkAllAsRead);
    on<SendTestNotification>(_onSendTestNotification);
  }

  final NotificationsRepository _notificationsRepository =
      ServiceLocator().notificationsRepository;

  List<NotificationModel> _notifications = [];
  String _selectedFilter = 'all';

  /// Handle custom notifications event
  FutureOr<void> _onCustomNotificationsEvent(
    CustomNotificationsEvent event,
    Emitter<NotificationsState> emit,
  ) {
    // Handle custom logic here
    emit(const NotificationsInitial());
  }

  /// Load user notifications
  FutureOr<void> _onLoadNotifications(
    LoadNotifications event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(const NotificationsLoading());

    try {
      // Get current user ID
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        emit(const NotificationsError(message: 'User not authenticated'));
        return;
      }

      debugPrint(
        'NotificationsBloc: Loading notifications for user: ${user.id}',
      );

      // Load notifications from repository
      final notifications = await _notificationsRepository.getUserNotifications(
        userId: user.id,
        page: 1,
        limit: 50,
      );

      debugPrint(
        'NotificationsBloc: Loaded ${notifications.length} notifications',
      );

      _notifications = notifications;
      final filteredNotifications = _getFilteredNotifications();

      emit(
        NotificationsLoaded(
          notifications: _notifications,
          filteredNotifications: filteredNotifications,
          selectedFilter: _selectedFilter,
        ),
      );
    } catch (e) {
      debugPrint('Error loading notifications: $e');
      emit(NotificationsError(message: 'Failed to load notifications: $e'));
    }
  }

  /// Refresh notifications
  FutureOr<void> _onRefreshNotifications(
    RefreshNotifications event,
    Emitter<NotificationsState> emit,
  ) async {
    if (state is NotificationsLoaded) {
      emit((state as NotificationsLoaded).copyWith(isRefreshing: true));
    } else {
      emit(const NotificationsLoading());
    }

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;

      final notifications = await _notificationsRepository.getUserNotifications(
        userId: user.id,
        page: 1,
        limit: 50,
      );

      _notifications = notifications;
      final filteredNotifications = _getFilteredNotifications();

      emit(
        NotificationsLoaded(
          notifications: _notifications,
          filteredNotifications: filteredNotifications,
          selectedFilter: _selectedFilter,
        ),
      );
    } catch (e) {
      debugPrint('Error refreshing notifications: $e');
      emit(NotificationsError(message: 'Failed to refresh notifications: $e'));
    }
  }

  /// Mark notification as read
  FutureOr<void> _onMarkNotificationAsRead(
    MarkNotificationAsRead event,
    Emitter<NotificationsState> emit,
  ) async {
    if (state is! NotificationsLoaded) return;

    final currentState = state as NotificationsLoaded;
    emit(currentState.copyWith(isMarkingAsRead: true));

    try {
      await _notificationsRepository.markNotificationAsRead(
        event.notificationId,
      );

      // Update local state
      final updatedNotifications =
          _notifications.map((notification) {
            if (notification.id == event.notificationId) {
              return notification.copyWith(isRead: true);
            }
            return notification;
          }).toList();

      _notifications = updatedNotifications;
      final filteredNotifications = _getFilteredNotifications();

      emit(
        NotificationsLoaded(
          notifications: _notifications,
          filteredNotifications: filteredNotifications,
          selectedFilter: _selectedFilter,
        ),
      );
    } catch (e) {
      debugPrint('Error marking notification as read: $e');
      emit(
        currentState.copyWith(
          isMarkingAsRead: false,
          error: 'Failed to mark notification as read: $e',
        ),
      );
    }
  }

  /// Delete notification
  FutureOr<void> _onDeleteNotification(
    DeleteNotification event,
    Emitter<NotificationsState> emit,
  ) async {
    if (state is! NotificationsLoaded) return;

    final currentState = state as NotificationsLoaded;
    emit(currentState.copyWith(isDeleting: true));

    try {
      await _notificationsRepository.deleteNotification(event.notificationId);

      // Update local state
      _notifications.removeWhere((n) => n.id == event.notificationId);
      final filteredNotifications = _getFilteredNotifications();

      emit(
        NotificationsLoaded(
          notifications: _notifications,
          filteredNotifications: filteredNotifications,
          selectedFilter: _selectedFilter,
        ),
      );
    } catch (e) {
      debugPrint('Error deleting notification: $e');
      emit(
        currentState.copyWith(
          isDeleting: false,
          error: 'Failed to delete notification: $e',
        ),
      );
    }
  }

  /// Filter notifications
  FutureOr<void> _onFilterNotifications(
    FilterNotifications event,
    Emitter<NotificationsState> emit,
  ) {
    _selectedFilter = event.filterType;
    final filteredNotifications = _getFilteredNotifications();

    if (state is NotificationsLoaded) {
      emit(
        (state as NotificationsLoaded).copyWith(
          selectedFilter: _selectedFilter,
          filteredNotifications: filteredNotifications,
        ),
      );
    }
  }

  /// Add new notification
  FutureOr<void> _onAddNotification(
    AddNotification event,
    Emitter<NotificationsState> emit,
  ) {
    _notifications.insert(0, event.notification);
    final filteredNotifications = _getFilteredNotifications();

    if (state is NotificationsLoaded) {
      emit(
        (state as NotificationsLoaded).copyWith(
          notifications: _notifications,
          filteredNotifications: filteredNotifications,
        ),
      );
    } else {
      emit(
        NotificationsLoaded(
          notifications: _notifications,
          filteredNotifications: filteredNotifications,
          selectedFilter: _selectedFilter,
        ),
      );
    }
  }

  /// Clear all notifications
  FutureOr<void> _onClearAllNotifications(
    ClearAllNotifications event,
    Emitter<NotificationsState> emit,
  ) async {
    if (state is! NotificationsLoaded) return;

    try {
      // Delete all notifications via repository
      for (final notification in _notifications) {
        try {
          await _notificationsRepository.deleteNotification(notification.id);
        } catch (e) {
          debugPrint('Error deleting notification ${notification.id}: $e');
        }
      }

      _notifications.clear();
      final filteredNotifications = _getFilteredNotifications();

      emit(
        NotificationsLoaded(
          notifications: _notifications,
          filteredNotifications: filteredNotifications,
          selectedFilter: _selectedFilter,
        ),
      );
    } catch (e) {
      debugPrint('Error clearing notifications: $e');
      emit(
        (state as NotificationsLoaded).copyWith(
          error: 'Failed to clear notifications: $e',
        ),
      );
    }
  }

  /// Mark all notifications as read
  FutureOr<void> _onMarkAllAsRead(
    MarkAllAsRead event,
    Emitter<NotificationsState> emit,
  ) async {
    if (state is! NotificationsLoaded) return;

    try {
      // Mark all unread notifications as read
      final unreadNotifications = _notifications.where((n) => !n.isRead);

      for (final notification in unreadNotifications) {
        try {
          await _notificationsRepository.markNotificationAsRead(
            notification.id,
          );
        } catch (e) {
          debugPrint(
            'Error marking notification ${notification.id} as read: $e',
          );
        }
      }

      // Update local state
      _notifications =
          _notifications.map((notification) {
            return notification.copyWith(isRead: true);
          }).toList();

      final filteredNotifications = _getFilteredNotifications();

      emit(
        NotificationsLoaded(
          notifications: _notifications,
          filteredNotifications: filteredNotifications,
          selectedFilter: _selectedFilter,
        ),
      );
    } catch (e) {
      debugPrint('Error marking all notifications as read: $e');
      emit(
        (state as NotificationsLoaded).copyWith(
          error: 'Failed to mark all notifications as read: $e',
        ),
      );
    }
  }

  /// Send test notification
  FutureOr<void> _onSendTestNotification(
    SendTestNotification event,
    Emitter<NotificationsState> emit,
  ) async {
    debugPrint('NotificationsBloc: _onSendTestNotification called');

    if (state is! NotificationsLoaded) {
      debugPrint(
        'NotificationsBloc: State is not NotificationsLoaded, returning',
      );
      return;
    }

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        debugPrint('NotificationsBloc: User is null, returning');
        return;
      }

      final title = event.title ?? 'Test Notification';
      final body = event.message ?? 'This is a test notification';

      debugPrint(
        'NotificationsBloc: Sending notification - Title: $title, Body: $body',
      );

      await _notificationsRepository.sendCustomNotification(
        userId: user.id,
        title: title,
        body: body,
        type: NotificationType.adminMessage, // Use valid type from backend
        groupId: event.groupId,
      );

      debugPrint('NotificationsBloc: API notification sent successfully');

      // Refresh notifications to show the new one
      debugPrint('NotificationsBloc: Refreshing notifications list');
      add(const RefreshNotifications());
    } catch (e) {
      debugPrint('Error sending test notification: $e');
      emit(
        (state as NotificationsLoaded).copyWith(
          error: 'Failed to send test notification: $e',
        ),
      );
    }
  }

  /// Get filtered notifications based on current filter
  List<NotificationModel> _getFilteredNotifications() {
    switch (_selectedFilter) {
      case 'unread':
        return _notifications.where((n) => !n.isRead).toList();
      case 'payments':
        return _notifications
            .where(
              (n) =>
                  n.type == NotificationType.paymentReminder ||
                  n.type == NotificationType.paymentOverdue ||
                  n.type == NotificationType.paymentConfirmation,
            )
            .toList();
      case 'groups':
        return _notifications
            .where(
              (n) =>
                  n.type == NotificationType.groupInvitation ||
                  n.type == NotificationType.newMemberJoined ||
                  n.type == NotificationType.memberLeft,
            )
            .toList();
      default:
        return _notifications;
    }
  }
}
