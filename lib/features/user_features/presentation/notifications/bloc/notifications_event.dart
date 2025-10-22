part of 'notifications_bloc.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load user notifications
class LoadNotifications extends NotificationsEvent {
  const LoadNotifications();
}

/// Event to refresh notifications
class RefreshNotifications extends NotificationsEvent {
  const RefreshNotifications();
}

/// Event to mark a notification as read
class MarkNotificationAsRead extends NotificationsEvent {
  const MarkNotificationAsRead({required this.notificationId});

  final String notificationId;

  @override
  List<Object?> get props => [notificationId];
}

/// Event to delete a notification
class DeleteNotification extends NotificationsEvent {
  const DeleteNotification({required this.notificationId});

  final String notificationId;

  @override
  List<Object?> get props => [notificationId];
}

/// Event to filter notifications by type
class FilterNotifications extends NotificationsEvent {
  const FilterNotifications({required this.filterType});

  final String filterType;

  @override
  List<Object?> get props => [filterType];
}

/// Event to clear all notifications
class ClearAllNotifications extends NotificationsEvent {
  const ClearAllNotifications();
}

/// Event to mark all notifications as read
class MarkAllAsRead extends NotificationsEvent {
  const MarkAllAsRead();
}

/// Event to add a new notification to the list
class AddNotification extends NotificationsEvent {
  const AddNotification({required this.notification});

  final NotificationModel notification;

  @override
  List<Object?> get props => [notification];
}

/// Event to send a test notification
class SendTestNotification extends NotificationsEvent {
  const SendTestNotification({this.groupId, this.title, this.message});

  final String? groupId;
  final String? title;
  final String? message;

  @override
  List<Object?> get props => [groupId, title, message];
}

/// {@template custom_notifications_event}
/// Event added when some custom logic happens
/// {@endtemplate}
class CustomNotificationsEvent extends NotificationsEvent {
  /// {@macro custom_notifications_event}
  const CustomNotificationsEvent();
}
