part of 'group_members_bloc.dart';

abstract class GroupMembersEvent extends Equatable {
  const GroupMembersEvent();

  @override
  List<Object> get props => [];
}

/// {@template load_group_members}
/// Event to load group members
/// {@endtemplate}
class LoadGroupMembers extends GroupMembersEvent {
  /// {@macro load_group_members}
  const LoadGroupMembers();
}

/// {@template invite_member}
/// Event to invite a new member
/// {@endtemplate}
class InviteMember extends GroupMembersEvent {
  /// {@macro invite_member}
  const InviteMember(this.email);

  final String email;

  @override
  List<Object> get props => [email];
}

/// {@template remove_member}
/// Event to remove a member
/// {@endtemplate}
class RemoveMember extends GroupMembersEvent {
  /// {@macro remove_member}
  const RemoveMember(this.memberId);

  final String memberId;

  @override
  List<Object> get props => [memberId];
}

/// {@template update_member_share}
/// Event to update a member's share percentage
/// {@endtemplate}
class UpdateMemberShare extends GroupMembersEvent {
  /// {@macro update_member_share}
  const UpdateMemberShare(this.memberId, this.sharePercentage);

  final String memberId;
  final double sharePercentage;

  @override
  List<Object> get props => [memberId, sharePercentage];
}

/// {@template rebalance_shares}
/// Event to rebalance all shares equally
/// {@endtemplate}
class RebalanceShares extends GroupMembersEvent {
  /// {@macro rebalance_shares}
  const RebalanceShares();
}

/// {@template toggle_auto_equal_shares}
/// Event to toggle auto-equal shares mode
/// {@endtemplate}
class ToggleAutoEqualShares extends GroupMembersEvent {
  /// {@macro toggle_auto_equal_shares}
  const ToggleAutoEqualShares();
}

/// {@template show_share_editor}
/// Event to show/hide share editor for a member
/// {@endtemplate}
class ShowShareEditor extends GroupMembersEvent {
  /// {@macro show_share_editor}
  const ShowShareEditor(this.memberId);

  final String memberId;

  @override
  List<Object> get props => [memberId];
}

/// {@template hide_share_editor}
/// Event to hide share editor
/// {@endtemplate}
class HideShareEditor extends GroupMembersEvent {
  /// {@macro hide_share_editor}
  const HideShareEditor();
}

/// {@template invite_email_changed}
/// Event when invite email changes
/// {@endtemplate}
class InviteEmailChanged extends GroupMembersEvent {
  /// {@macro invite_email_changed}
  const InviteEmailChanged(this.email);

  final String email;

  @override
  List<Object> get props => [email];
}
