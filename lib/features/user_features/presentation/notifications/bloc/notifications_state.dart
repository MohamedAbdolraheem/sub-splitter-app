part of 'notifications_bloc.dart';

/// {@template notifications_state}
/// Base state for the notifications BLoC
/// {@endtemplate}
abstract class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class NotificationsInitial extends NotificationsState {
  const NotificationsInitial();
}

/// Loading state
class NotificationsLoading extends NotificationsState {
  const NotificationsLoading();
}

/// Loaded state with notifications
class NotificationsLoaded extends NotificationsState {
  const NotificationsLoaded({
    required this.notifications,
    required this.filteredNotifications,
    required this.selectedFilter,
    this.error,
    this.isLoading = false,
    this.isRefreshing = false,
    this.isMarkingAsRead = false,
    this.isDeleting = false,
  });

  final List<NotificationModel> notifications;
  final List<NotificationModel> filteredNotifications;
  final String selectedFilter;
  final String? error;
  final bool isLoading;
  final bool isRefreshing;
  final bool isMarkingAsRead;
  final bool isDeleting;

  @override
  List<Object?> get props => [
    notifications,
    filteredNotifications,
    selectedFilter,
    error,
    isLoading,
    isRefreshing,
    isMarkingAsRead,
    isDeleting,
  ];

  NotificationsLoaded copyWith({
    List<NotificationModel>? notifications,
    List<NotificationModel>? filteredNotifications,
    String? selectedFilter,
    String? error,
    bool? isLoading,
    bool? isRefreshing,
    bool? isMarkingAsRead,
    bool? isDeleting,
    bool clearError = false,
  }) {
    return NotificationsLoaded(
      notifications: notifications ?? this.notifications,
      filteredNotifications:
          filteredNotifications ?? this.filteredNotifications,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      error: clearError ? null : (error ?? this.error),
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isMarkingAsRead: isMarkingAsRead ?? this.isMarkingAsRead,
      isDeleting: isDeleting ?? this.isDeleting,
    );
  }
}

/// Error state
class NotificationsError extends NotificationsState {
  const NotificationsError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
