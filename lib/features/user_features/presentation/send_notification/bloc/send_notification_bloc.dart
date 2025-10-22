import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:subscription_splitter_app/core/notifications/models/notification_model.dart';
import 'package:subscription_splitter_app/core/di/service_locator.dart';
import 'package:subscription_splitter_app/features/user_features/domain/repositories/notifications_repository.dart';
import 'package:subscription_splitter_app/features/spliting_features/domain/repositories/groups_repository.dart';

part 'send_notification_event.dart';
part 'send_notification_state.dart';

/// {@template send_notification_bloc}
/// BLoC for sending notifications to group members
/// {@endtemplate}
class SendNotificationBloc
    extends Bloc<SendNotificationEvent, SendNotificationState> {
  /// {@macro send_notification_bloc}
  SendNotificationBloc({required this.groupId})
    : super(const SendNotificationInitial()) {
    on<LoadGroupMembers>(_onLoadGroupMembers);
    on<SendNotificationToUsers>(_onSendNotificationToUsers);
    on<SendNotificationToAll>(_onSendNotificationToAll);
    on<UpdateSelectedUsers>(_onUpdateSelectedUsers);
    on<ClearForm>(_onClearForm);
  }

  final String groupId;
  final NotificationsRepository _notificationsRepository =
      ServiceLocator().notificationsRepository;
  final GroupsRepository _groupsRepository = ServiceLocator().groupsRepository;

  /// Load group members
  FutureOr<void> _onLoadGroupMembers(
    LoadGroupMembers event,
    Emitter<SendNotificationState> emit,
  ) async {
    emit(const SendNotificationLoading());

    try {
      // Get group members from the groups repository
      final groupMembers = await _groupsRepository.getGroupMembers(
        event.groupId,
      );

      // Convert GroupMember entities to GroupMember models for the UI
      final uiGroupMembers =
          groupMembers
              .map(
                (member) => GroupMember(
                  id: member.userId,
                  name: member.user.fullName,
                  email: member.user.phone ?? 'No email',
                  avatar: member.user.avatarUrl,
                  isOnline:
                      member.status ==
                      'active', // Assume active members are online
                ),
              )
              .toList();

      emit(
        SendNotificationLoaded(
          groupMembers: uiGroupMembers,
          selectedUserIds: [],
        ),
      );
    } catch (e) {
      debugPrint('Error loading group members: $e');
      emit(SendNotificationError(message: 'Failed to load group members: $e'));
    }
  }

  /// Send notification to selected users
  FutureOr<void> _onSendNotificationToUsers(
    SendNotificationToUsers event,
    Emitter<SendNotificationState> emit,
  ) async {
    if (state is! SendNotificationLoaded) return;

    final currentState = state as SendNotificationLoaded;
    emit(currentState.copyWith(isSending: true, error: null));

    try {
      int sentCount = 0;
      int totalCount = event.userIds.length;

      // Send notification to each selected user
      for (final userId in event.userIds) {
        try {
          await _notificationsRepository.sendCustomNotification(
            userId: userId,
            title: event.title,
            body: event.message,
            type: event.type,
            groupId: event.groupId,
            data: {'language': event.language, 'composedBy': 'user'},
          );
          sentCount++;
        } catch (e) {
          debugPrint('Failed to send notification to user $userId: $e');
        }
      }

      emit(
        SendNotificationSuccess(sentCount: sentCount, totalCount: totalCount),
      );
    } catch (e) {
      debugPrint('Error sending notifications: $e');
      emit(
        currentState.copyWith(
          isSending: false,
          error: 'Failed to send notifications: $e',
        ),
      );
    }
  }

  /// Send notification to all group members
  FutureOr<void> _onSendNotificationToAll(
    SendNotificationToAll event,
    Emitter<SendNotificationState> emit,
  ) async {
    if (state is! SendNotificationLoaded) return;

    final currentState = state as SendNotificationLoaded;
    emit(currentState.copyWith(isSending: true, error: null));

    try {
      // Send to all group members individually
      final allUserIds = currentState.groupMembers.map((m) => m.id).toList();

      int sentCount = 0;
      int totalCount = allUserIds.length;

      for (final userId in allUserIds) {
        try {
          await _notificationsRepository.sendCustomNotification(
            userId: userId,
            title: event.title,
            body: event.message,
            type: event.type,
            groupId: event.groupId,
            data: {'language': event.language, 'composedBy': 'user'},
          );
          sentCount++;
        } catch (e) {
          debugPrint('Failed to send notification to user $userId: $e');
        }
      }

      emit(
        SendNotificationSuccess(sentCount: sentCount, totalCount: totalCount),
      );
    } catch (e) {
      debugPrint('Error sending notifications to all: $e');
      emit(
        currentState.copyWith(
          isSending: false,
          error: 'Failed to send notifications: $e',
        ),
      );
    }
  }

  /// Update selected users
  void _onUpdateSelectedUsers(
    UpdateSelectedUsers event,
    Emitter<SendNotificationState> emit,
  ) {
    if (state is! SendNotificationLoaded) return;

    final currentState = state as SendNotificationLoaded;
    emit(currentState.copyWith(selectedUserIds: event.userIds));
  }

  /// Clear form
  void _onClearForm(ClearForm event, Emitter<SendNotificationState> emit) {
    if (state is! SendNotificationLoaded) return;

    final currentState = state as SendNotificationLoaded;
    emit(currentState.copyWith(selectedUserIds: []));
  }
}
