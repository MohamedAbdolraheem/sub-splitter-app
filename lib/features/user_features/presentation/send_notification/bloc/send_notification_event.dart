part of 'send_notification_bloc.dart';

abstract class SendNotificationEvent extends Equatable {
  const SendNotificationEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load group members for notification selection
class LoadGroupMembers extends SendNotificationEvent {
  const LoadGroupMembers({required this.groupId});

  final String groupId;

  @override
  List<Object?> get props => [groupId];
}

/// Event to send notification to selected users
class SendNotificationToUsers extends SendNotificationEvent {
  const SendNotificationToUsers({
    required this.userIds,
    required this.title,
    required this.message,
    required this.type,
    this.groupId,
    this.language = 'en',
  });

  final List<String> userIds;
  final String title;
  final String message;
  final NotificationType type;
  final String? groupId;
  final String language;

  @override
  List<Object?> get props => [userIds, title, message, type, groupId, language];
}

/// Event to send notification to all group members
class SendNotificationToAll extends SendNotificationEvent {
  const SendNotificationToAll({
    required this.groupId,
    required this.title,
    required this.message,
    required this.type,
    this.language = 'en',
  });

  final String groupId;
  final String title;
  final String message;
  final NotificationType type;
  final String language;

  @override
  List<Object?> get props => [groupId, title, message, type, language];
}

/// Event to update selected users
class UpdateSelectedUsers extends SendNotificationEvent {
  const UpdateSelectedUsers({required this.userIds});

  final List<String> userIds;

  @override
  List<Object?> get props => [userIds];
}

/// Event to clear form
class ClearForm extends SendNotificationEvent {
  const ClearForm();
}
