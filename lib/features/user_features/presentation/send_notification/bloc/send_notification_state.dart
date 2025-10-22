part of 'send_notification_bloc.dart';

abstract class SendNotificationState extends Equatable {
  const SendNotificationState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class SendNotificationInitial extends SendNotificationState {
  const SendNotificationInitial();
}

/// Loading state
class SendNotificationLoading extends SendNotificationState {
  const SendNotificationLoading();
}

/// Loaded state with group members
class SendNotificationLoaded extends SendNotificationState {
  const SendNotificationLoaded({
    required this.groupMembers,
    this.selectedUserIds = const [],
    this.isLoading = false,
    this.isSending = false,
    this.error,
  });

  final List<GroupMember> groupMembers;
  final List<String> selectedUserIds;
  final bool isLoading;
  final bool isSending;
  final String? error;

  @override
  List<Object?> get props => [
    groupMembers,
    selectedUserIds,
    isLoading,
    isSending,
    error,
  ];

  SendNotificationLoaded copyWith({
    List<GroupMember>? groupMembers,
    List<String>? selectedUserIds,
    bool? isLoading,
    bool? isSending,
    String? error,
    bool clearError = false,
  }) {
    return SendNotificationLoaded(
      groupMembers: groupMembers ?? this.groupMembers,
      selectedUserIds: selectedUserIds ?? this.selectedUserIds,
      isLoading: isLoading ?? this.isLoading,
      isSending: isSending ?? this.isSending,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// Success state
class SendNotificationSuccess extends SendNotificationState {
  const SendNotificationSuccess({
    required this.sentCount,
    required this.totalCount,
  });

  final int sentCount;
  final int totalCount;

  @override
  List<Object?> get props => [sentCount, totalCount];
}

/// Error state
class SendNotificationError extends SendNotificationState {
  const SendNotificationError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

/// Group member model for notification selection
class GroupMember extends Equatable {
  const GroupMember({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    this.isOnline = false,
  });

  final String id;
  final String name;
  final String email;
  final String? avatar;
  final bool isOnline;

  @override
  List<Object?> get props => [id, name, email, avatar, isOnline];
}
