import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:subscription_splitter_app/features/spliting_features/domain/entities/group.dart';
import 'package:subscription_splitter_app/features/spliting_features/domain/repositories/groups_repository.dart';

part 'groups_event.dart';
part 'groups_state.dart';

/// {@template groups_bloc}
/// Bloc for managing groups state and operations
/// {@endtemplate}
class GroupsBloc extends Bloc<GroupsEvent, GroupsState> {
  /// {@macro groups_bloc}
  GroupsBloc({required GroupsRepository groupsRepository})
    : _groupsRepository = groupsRepository,
      super(const GroupsState()) {
    on<LoadGroups>(_onLoadGroups);
    on<RefreshGroups>(_onRefreshGroups);
    on<CreateGroup>(_onCreateGroup);
    on<JoinGroup>(_onJoinGroup);
    on<LeaveGroup>(_onLeaveGroup);
    on<DeleteGroup>(_onDeleteGroup);
  }

  final GroupsRepository _groupsRepository;

  FutureOr<void> _onLoadGroups(
    LoadGroups event,
    Emitter<GroupsState> emit,
  ) async {
    emit(state.copyWith(status: GroupsStatus.loading));

    try {
      // Get current user ID
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        debugPrint('GroupsBloc: User not authenticated');
        emit(
          state.copyWith(
            status: GroupsStatus.error,
            errorMessage: 'User not authenticated',
          ),
        );
        return;
      }

      debugPrint('GroupsBloc: Loading groups for user: ${user.id}');

      // Load user groups
      final groups = await _groupsRepository.getUserGroups(user.id);

      debugPrint('GroupsBloc: Loaded ${groups.length} groups');
      for (final group in groups) {
        debugPrint(
          'GroupsBloc: Group - ${group.name} (Owner: ${group.ownerId})',
        );
      }

      // Separate owned and member groups
      final ownedGroups =
          groups.where((group) => group.ownerId == user.id).toList();
      final memberGroups =
          groups.where((group) => group.ownerId != user.id).toList();

      debugPrint(
        'GroupsBloc: Owned groups: ${ownedGroups.length}, Member groups: ${memberGroups.length}',
      );

      emit(
        state.copyWith(
          status: GroupsStatus.success,
          ownedGroups: ownedGroups,
          memberGroups: memberGroups,
          allGroups: groups,
        ),
      );
    } catch (e) {
      debugPrint('GroupsBloc: Error loading groups: $e');
      emit(
        state.copyWith(status: GroupsStatus.error, errorMessage: e.toString()),
      );
    }
  }

  FutureOr<void> _onRefreshGroups(
    RefreshGroups event,
    Emitter<GroupsState> emit,
  ) async {
    add(const LoadGroups());
  }

  FutureOr<void> _onCreateGroup(
    CreateGroup event,
    Emitter<GroupsState> emit,
  ) async {
    emit(state.copyWith(status: GroupsStatus.loading));

    try {
      // Get current user ID
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        emit(
          state.copyWith(
            status: GroupsStatus.error,
            errorMessage: 'User not authenticated',
          ),
        );
        return;
      }

      // Create group
      await _groupsRepository.createGroup(
        name: event.name,
        serviceId: event.serviceId,
        totalCost: event.totalCost,
        cycle: event.cycle,
        ownerId: user.id,
        renewDate:
            DateTime.now().add(const Duration(days: 30)).toIso8601String(),
      );

      // Refresh groups list
      add(const LoadGroups());
    } catch (e) {
      emit(
        state.copyWith(status: GroupsStatus.error, errorMessage: e.toString()),
      );
    }
  }

  FutureOr<void> _onJoinGroup(
    JoinGroup event,
    Emitter<GroupsState> emit,
  ) async {
    try {
      // Get current user ID
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        emit(
          state.copyWith(
            status: GroupsStatus.error,
            errorMessage: 'User not authenticated',
          ),
        );
        return;
      }

      // Join group - TODO: Implement joinGroup method in GroupsRepository
      // await _groupsRepository.joinGroup(
      //   groupId: event.groupId,
      //   userId: user.id,
      //   share: event.share,
      // );

      // Refresh groups list
      add(const LoadGroups());
    } catch (e) {
      emit(
        state.copyWith(status: GroupsStatus.error, errorMessage: e.toString()),
      );
    }
  }

  FutureOr<void> _onLeaveGroup(
    LeaveGroup event,
    Emitter<GroupsState> emit,
  ) async {
    try {
      // Get current user ID
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        emit(
          state.copyWith(
            status: GroupsStatus.error,
            errorMessage: 'User not authenticated',
          ),
        );
        return;
      }

      // Leave group - TODO: Implement leaveGroup method in GroupsRepository
      // await _groupsRepository.leaveGroup(
      //   groupId: event.groupId,
      //   userId: user.id,
      // );

      // Refresh groups list
      add(const LoadGroups());
    } catch (e) {
      emit(
        state.copyWith(status: GroupsStatus.error, errorMessage: e.toString()),
      );
    }
  }

  FutureOr<void> _onDeleteGroup(
    DeleteGroup event,
    Emitter<GroupsState> emit,
  ) async {
    try {
      // Delete group
      await _groupsRepository.deleteGroup(event.groupId);

      // Refresh groups list
      add(const LoadGroups());
    } catch (e) {
      emit(
        state.copyWith(status: GroupsStatus.error, errorMessage: e.toString()),
      );
    }
  }
}
