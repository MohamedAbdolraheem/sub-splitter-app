import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../domain/entities/group.dart';
import '../../../domain/repositories/groups_repository.dart';
part 'group_settings_event.dart';
part 'group_settings_state.dart';

class GroupSettingsBloc extends Bloc<GroupSettingsEvent, GroupSettingsState> {
  final String groupId;
  final GroupsRepository _groupsRepository;

  GroupSettingsBloc({required this.groupId})
    : _groupsRepository = ServiceLocator().groupsRepository,
      super(const GroupSettingsInitial()) {
    on<LoadGroupSettings>(_onLoadGroupSettings);
    on<GroupNameChanged>(_onGroupNameChanged);
    on<DescriptionChanged>(_onDescriptionChanged);
    on<TotalCostChanged>(_onTotalCostChanged);
    on<BillingCycleChanged>(_onBillingCycleChanged);
    on<MaxMembersChanged>(_onMaxMembersChanged);
    on<IsPublicChanged>(_onIsPublicChanged);
    on<AllowInvitesChanged>(_onAllowInvitesChanged);
    on<AutoSplitChanged>(_onAutoSplitChanged);
    on<SaveGroupSettings>(_onSaveGroupSettings);
    on<DeleteGroup>(_onDeleteGroup);
  }

  FutureOr<void> _onLoadGroupSettings(
    LoadGroupSettings event,
    Emitter<GroupSettingsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      // Load group details from API
      final Group group = await _groupsRepository.getGroupDetails(groupId);

      emit(
        state.copyWith(
          isLoading: false,
          groupName: group.name,
          description: '', // Description not available in Group entity
          totalCost: group.totalCost,
          billingCycle: group.cycle,
          maxMembers: group.groupMembers.length + 5, // Default max members
          isPublic: false, // Default to private
          allowInvites: true, // Default to allowing invites
          autoSplit: true, // Default to auto-split
          error: null,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  FutureOr<void> _onGroupNameChanged(
    GroupNameChanged event,
    Emitter<GroupSettingsState> emit,
  ) {
    emit(state.copyWith(groupName: event.groupName));
  }

  FutureOr<void> _onDescriptionChanged(
    DescriptionChanged event,
    Emitter<GroupSettingsState> emit,
  ) {
    emit(state.copyWith(description: event.description));
  }

  FutureOr<void> _onTotalCostChanged(
    TotalCostChanged event,
    Emitter<GroupSettingsState> emit,
  ) {
    emit(state.copyWith(totalCost: event.totalCost));
  }

  FutureOr<void> _onBillingCycleChanged(
    BillingCycleChanged event,
    Emitter<GroupSettingsState> emit,
  ) {
    emit(state.copyWith(billingCycle: event.billingCycle));
  }

  FutureOr<void> _onMaxMembersChanged(
    MaxMembersChanged event,
    Emitter<GroupSettingsState> emit,
  ) {
    emit(state.copyWith(maxMembers: event.maxMembers));
  }

  FutureOr<void> _onIsPublicChanged(
    IsPublicChanged event,
    Emitter<GroupSettingsState> emit,
  ) {
    emit(state.copyWith(isPublic: event.isPublic));
  }

  FutureOr<void> _onAllowInvitesChanged(
    AllowInvitesChanged event,
    Emitter<GroupSettingsState> emit,
  ) {
    emit(state.copyWith(allowInvites: event.allowInvites));
  }

  FutureOr<void> _onAutoSplitChanged(
    AutoSplitChanged event,
    Emitter<GroupSettingsState> emit,
  ) {
    emit(state.copyWith(autoSplit: event.autoSplit));
  }

  FutureOr<void> _onSaveGroupSettings(
    SaveGroupSettings event,
    Emitter<GroupSettingsState> emit,
  ) async {
    emit(state.copyWith(isSaving: true, error: null));

    try {
      // Update group via API
      await _groupsRepository.updateGroup(
        groupId,
        name: state.groupName,
        totalCost: state.totalCost,
        cycle: state.billingCycle,
      );

      emit(state.copyWith(isSaving: false));
      // TODO: Show success message or navigate back
    } catch (e) {
      emit(state.copyWith(isSaving: false, error: e.toString()));
    }
  }

  FutureOr<void> _onDeleteGroup(
    DeleteGroup event,
    Emitter<GroupSettingsState> emit,
  ) async {
    emit(state.copyWith(isSaving: true, error: null));

    try {
      // Delete group via API
      await _groupsRepository.deleteGroup(groupId);

      emit(state.copyWith(isSaving: false));
      // TODO: Navigate back to dashboard after successful deletion
    } catch (e) {
      emit(state.copyWith(isSaving: false, error: e.toString()));
    }
  }
}
