import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../domain/entities/group.dart';
import '../../../domain/entities/group_member.dart' as entities;
import '../../../domain/repositories/groups_repository.dart';
part 'group_members_event.dart';
part 'group_members_state.dart';

class GroupMembersBloc extends Bloc<GroupMembersEvent, GroupMembersState> {
  final String groupId;
  final GroupsRepository _groupsRepository;

  GroupMembersBloc({required this.groupId})
    : _groupsRepository = ServiceLocator().groupsRepository,
      super(const GroupMembersInitial()) {
    on<LoadGroupMembers>(_onLoadGroupMembers);
    on<InviteMember>(_onInviteMember);
    on<RemoveMember>(_onRemoveMember);
    on<UpdateMemberShare>(_onUpdateMemberShare);
    on<RebalanceShares>(_onRebalanceShares);
    on<ToggleAutoEqualShares>(_onToggleAutoEqualShares);
    on<ShowShareEditor>(_onShowShareEditor);
    on<HideShareEditor>(_onHideShareEditor);
    on<InviteEmailChanged>(_onInviteEmailChanged);
  }

  FutureOr<void> _onLoadGroupMembers(
    LoadGroupMembers event,
    Emitter<GroupMembersState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      // Load group details to get total cost and basic info
      final Group group = await _groupsRepository.getGroupDetails(groupId);

      // Load group members
      final List<entities.GroupMember> groupMembers = await _groupsRepository
          .getGroupMembers(groupId);

      // Convert entities to UI models
      final List<GroupMember> members =
          groupMembers
              .map(
                (member) => GroupMember(
                  id: member.id,
                  name: member.user.fullName,
                  email: member.user.phone ?? 'No phone',
                  sharePercentage:
                      (member.share *
                          100), // Convert from decimal to percentage
                  amount: group.totalCost * member.share,
                  isOwner: member.userId == group.ownerId,
                  isAdmin:
                      member.userId == group.ownerId, // Owner is also admin
                  avatar: member.user.avatarUrl,
                  joinedAt: member.joinedAt,
                ),
              )
              .toList();

      // Check if shares are equal (auto-equal shares)
      final bool isAutoEqualShares =
          members.length > 1 &&
          members.every(
            (member) => member.sharePercentage == members.first.sharePercentage,
          );

      emit(
        state.copyWith(
          isLoading: false,
          members: members,
          totalCost: group.totalCost,
          isAutoEqualShares: isAutoEqualShares,
          error: null,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  FutureOr<void> _onInviteMember(
    InviteMember event,
    Emitter<GroupMembersState> emit,
  ) async {
    emit(state.copyWith(isInviting: true, error: null));

    try {
      // Calculate share for new member
      final double newMemberShare =
          state.isAutoEqualShares
              ? 1.0 / (state.members.length + 1)
              : 0.0; // Will be set manually if not auto-equal

      // Add member via API
      await _groupsRepository.addGroupMember(
        groupId: groupId,
        userId: event.email, // Assuming email is used as user identifier
        share: newMemberShare,
      );

      // Reload members to get updated data
      add(const LoadGroupMembers());

      emit(state.copyWith(isInviting: false, inviteEmail: ''));
    } catch (e) {
      emit(state.copyWith(isInviting: false, error: e.toString()));
    }
  }

  FutureOr<void> _onRemoveMember(
    RemoveMember event,
    Emitter<GroupMembersState> emit,
  ) async {
    emit(state.copyWith(isRemoving: true, error: null));

    try {
      // Remove member via API
      await _groupsRepository.removeGroupMember(
        groupId: groupId,
        memberId: event.memberId,
      );

      // Reload members to get updated data
      add(const LoadGroupMembers());

      emit(state.copyWith(isRemoving: false));
    } catch (e) {
      emit(state.copyWith(isRemoving: false, error: e.toString()));
    }
  }

  FutureOr<void> _onUpdateMemberShare(
    UpdateMemberShare event,
    Emitter<GroupMembersState> emit,
  ) async {
    emit(state.copyWith(isSaving: true, error: null));

    try {
      // Convert percentage to decimal share
      final double share = event.sharePercentage / 100.0;

      // Update member share via API
      await _groupsRepository.updateMemberShare(
        groupId: groupId,
        memberId: event.memberId,
        share: share,
      );

      // Reload members to get updated data
      add(const LoadGroupMembers());

      emit(
        state.copyWith(
          isSaving: false,
          showShareEditor: false,
          selectedMemberId: null,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isSaving: false, error: e.toString()));
    }
  }

  FutureOr<void> _onRebalanceShares(
    RebalanceShares event,
    Emitter<GroupMembersState> emit,
  ) async {
    emit(state.copyWith(isSaving: true, error: null));

    try {
      // Rebalance shares via API
      await _groupsRepository.rebalanceGroup(groupId);

      // Reload members to get updated data
      add(const LoadGroupMembers());

      emit(state.copyWith(isSaving: false, isAutoEqualShares: true));
    } catch (e) {
      emit(state.copyWith(isSaving: false, error: e.toString()));
    }
  }

  FutureOr<void> _onToggleAutoEqualShares(
    ToggleAutoEqualShares event,
    Emitter<GroupMembersState> emit,
  ) {
    final newValue = !state.isAutoEqualShares;

    if (newValue) {
      // Enable auto-equal shares and rebalance
      final rebalancedMembers = _rebalanceShares(
        state.members,
        state.totalCost,
      );
      emit(
        state.copyWith(isAutoEqualShares: newValue, members: rebalancedMembers),
      );
    } else {
      // Disable auto-equal shares
      emit(state.copyWith(isAutoEqualShares: newValue));
    }
  }

  FutureOr<void> _onShowShareEditor(
    ShowShareEditor event,
    Emitter<GroupMembersState> emit,
  ) {
    emit(
      state.copyWith(showShareEditor: true, selectedMemberId: event.memberId),
    );
  }

  FutureOr<void> _onHideShareEditor(
    HideShareEditor event,
    Emitter<GroupMembersState> emit,
  ) {
    emit(state.copyWith(showShareEditor: false, selectedMemberId: null));
  }

  FutureOr<void> _onInviteEmailChanged(
    InviteEmailChanged event,
    Emitter<GroupMembersState> emit,
  ) {
    emit(state.copyWith(inviteEmail: event.email));
  }

  /// Helper method to rebalance shares equally among all members
  List<GroupMember> _rebalanceShares(
    List<GroupMember> members,
    double totalCost,
  ) {
    if (members.isEmpty) return members;

    final sharePerMember = 100.0 / members.length;
    final amountPerMember = totalCost / members.length;

    return members.map((member) {
      return member.copyWith(
        sharePercentage: sharePerMember,
        amount: amountPerMember,
      );
    }).toList();
  }
}
