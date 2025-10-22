part of 'group_settings_bloc.dart';

abstract class GroupSettingsEvent extends Equatable {
  const GroupSettingsEvent();

  @override
  List<Object> get props => [];
}

/// {@template load_group_settings}
/// Event to load group settings
/// {@endtemplate}
class LoadGroupSettings extends GroupSettingsEvent {
  /// {@macro load_group_settings}
  const LoadGroupSettings();
}

/// {@template group_name_changed}
/// Event when group name changes
/// {@endtemplate}
class GroupNameChanged extends GroupSettingsEvent {
  /// {@macro group_name_changed}
  const GroupNameChanged(this.groupName);

  final String groupName;

  @override
  List<Object> get props => [groupName];
}

/// {@template description_changed}
/// Event when description changes
/// {@endtemplate}
class DescriptionChanged extends GroupSettingsEvent {
  /// {@macro description_changed}
  const DescriptionChanged(this.description);

  final String description;

  @override
  List<Object> get props => [description];
}

/// {@template total_cost_changed}
/// Event when total cost changes
/// {@endtemplate}
class TotalCostChanged extends GroupSettingsEvent {
  /// {@macro total_cost_changed}
  const TotalCostChanged(this.totalCost);

  final double totalCost;

  @override
  List<Object> get props => [totalCost];
}

/// {@template billing_cycle_changed}
/// Event when billing cycle changes
/// {@endtemplate}
class BillingCycleChanged extends GroupSettingsEvent {
  /// {@macro billing_cycle_changed}
  const BillingCycleChanged(this.billingCycle);

  final String billingCycle;

  @override
  List<Object> get props => [billingCycle];
}

/// {@template max_members_changed}
/// Event when max members changes
/// {@endtemplate}
class MaxMembersChanged extends GroupSettingsEvent {
  /// {@macro max_members_changed}
  const MaxMembersChanged(this.maxMembers);

  final int maxMembers;

  @override
  List<Object> get props => [maxMembers];
}

/// {@template is_public_changed}
/// Event when public setting changes
/// {@endtemplate}
class IsPublicChanged extends GroupSettingsEvent {
  /// {@macro is_public_changed}
  const IsPublicChanged(this.isPublic);

  final bool isPublic;

  @override
  List<Object> get props => [isPublic];
}

/// {@template allow_invites_changed}
/// Event when allow invites setting changes
/// {@endtemplate}
class AllowInvitesChanged extends GroupSettingsEvent {
  /// {@macro allow_invites_changed}
  const AllowInvitesChanged(this.allowInvites);

  final bool allowInvites;

  @override
  List<Object> get props => [allowInvites];
}

/// {@template auto_split_changed}
/// Event when auto split setting changes
/// {@endtemplate}
class AutoSplitChanged extends GroupSettingsEvent {
  /// {@macro auto_split_changed}
  const AutoSplitChanged(this.autoSplit);

  final bool autoSplit;

  @override
  List<Object> get props => [autoSplit];
}

/// {@template save_group_settings}
/// Event to save group settings
/// {@endtemplate}
class SaveGroupSettings extends GroupSettingsEvent {
  /// {@macro save_group_settings}
  const SaveGroupSettings();
}

/// {@template delete_group}
/// Event to delete group
/// {@endtemplate}
class DeleteGroup extends GroupSettingsEvent {
  /// {@macro delete_group}
  const DeleteGroup();
}
