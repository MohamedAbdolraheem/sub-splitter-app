import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:subscription_splitter_app/core/di/service_locator.dart';
import 'package:subscription_splitter_app/features/spliting_features/domain/entities/group.dart';
import 'package:subscription_splitter_app/features/spliting_features/domain/repositories/groups_repository.dart';

part 'group_details_event.dart';
part 'group_details_state.dart';

class GroupDetailsBloc extends Bloc<GroupDetailsEvent, GroupDetailsState> {
  final String groupId;
  final GroupsRepository _groupsRepository;

  GroupDetailsBloc({required this.groupId})
    : _groupsRepository = ServiceLocator().groupsRepository,
      super(const GroupDetailsInitial()) {
    on<LoadGroupDetails>(_onLoadGroupDetails);
    on<RefreshGroupDetails>(_onRefreshGroupDetails);
    on<LeaveGroupRequested>(_onLeaveGroupRequested);
  }

  FutureOr<void> _onLoadGroupDetails(
    LoadGroupDetails event,
    Emitter<GroupDetailsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      // Load group details from API
      final Group group = await _groupsRepository.getGroupDetails(groupId);

      // Format the renewal date
      final String formattedRenewalDate = DateFormat(
        'MMM dd, yyyy',
      ).format(group.renewDate);

      // Convert group members to the expected format
      final List<Map<String, dynamic>> membersData =
          group.groupMembers
              .map(
                (member) => {
                  'id': member.id,
                  'userId': member.userId,
                  'name': member.user.fullName,
                  'email': member.user.phone ?? 'No phone',
                  'avatar': member.user.avatarUrl,
                  'share': member.share,
                  'status': member.status,
                  'joinedAt': member.joinedAt.toIso8601String(),
                },
              )
              .toList();

      // Create sample recent activities (you can implement real activities later)
      final List<Map<String, dynamic>> recentActivities = [
        {
          'id': '1',
          'type': 'member_joined',
          'description':
              '${group.groupMembers.isNotEmpty ? group.groupMembers.first.user.fullName : 'Someone'} joined the group',
          'timestamp':
              DateTime.now()
                  .subtract(const Duration(hours: 2))
                  .toIso8601String(),
          'userId':
              group.groupMembers.isNotEmpty
                  ? group.groupMembers.first.userId
                  : '',
        },
        {
          'id': '2',
          'type': 'group_created',
          'description': 'Group was created',
          'timestamp': group.createdAt.toIso8601String(),
          'userId': group.ownerId,
        },
      ];

      emit(
        state.copyWith(
          isLoading: false,
          groupName: group.name,
          serviceName: group.service.name,
          totalCost: group.totalCost,
          billingCycle: group.cycle,
          nextRenewal: formattedRenewalDate,
          members: membersData,
          recentActivities: recentActivities,
          error: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Failed to load group details: $e',
        ),
      );
    }
  }

  FutureOr<void> _onRefreshGroupDetails(
    RefreshGroupDetails event,
    Emitter<GroupDetailsState> emit,
  ) async {
    add(const LoadGroupDetails());
  }

  FutureOr<void> _onLeaveGroupRequested(
    LeaveGroupRequested event,
    Emitter<GroupDetailsState> emit,
  ) async {
    try {
      // Get current user
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        emit(state.copyWith(error: 'User not authenticated'));
        return;
      }

      // Find the current user's member ID in the group
      final currentUserMember = state.members.firstWhere(
        (member) => member['userId'] == user.id,
        orElse: () => throw Exception('User is not a member of this group'),
      );

      final memberId = currentUserMember['id'] as String;

      // Remove user from group via API using the member ID
      await _groupsRepository.removeGroupMember(
        groupId: groupId,
        memberId: memberId,
      );

      // Emit success state - this will trigger navigation back
      emit(state.copyWith(isLeaving: true, error: null));
    } catch (e) {
      emit(state.copyWith(error: 'Failed to leave group: ${e.toString()}'));
    }
  }
}
