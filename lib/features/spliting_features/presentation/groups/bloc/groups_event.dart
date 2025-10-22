part of 'groups_bloc.dart';

/// {@template groups_event}
/// Base class for all groups events
/// {@endtemplate}
abstract class GroupsEvent extends Equatable {
  /// {@macro groups_event}
  const GroupsEvent();

  @override
  List<Object?> get props => [];
}

/// {@template load_groups}
/// Event to load all user groups
/// {@endtemplate}
class LoadGroups extends GroupsEvent {
  /// {@macro load_groups}
  const LoadGroups();
}

/// {@template refresh_groups}
/// Event to refresh the groups list
/// {@endtemplate}
class RefreshGroups extends GroupsEvent {
  /// {@macro refresh_groups}
  const RefreshGroups();
}

/// {@template create_group}
/// Event to create a new group
/// {@endtemplate}
class CreateGroup extends GroupsEvent {
  /// {@macro create_group}
  const CreateGroup({
    required this.name,
    required this.serviceId,
    required this.totalCost,
    required this.cycle,
  });

  final String name;
  final String serviceId;
  final double totalCost;
  final String cycle;

  @override
  List<Object?> get props => [name, serviceId, totalCost, cycle];
}

/// {@template join_group}
/// Event to join an existing group
/// {@endtemplate}
class JoinGroup extends GroupsEvent {
  /// {@macro join_group}
  const JoinGroup({required this.groupId, required this.share});

  final String groupId;
  final double share;

  @override
  List<Object?> get props => [groupId, share];
}

/// {@template leave_group}
/// Event to leave a group
/// {@endtemplate}
class LeaveGroup extends GroupsEvent {
  /// {@macro leave_group}
  const LeaveGroup({required this.groupId});

  final String groupId;

  @override
  List<Object?> get props => [groupId];
}

/// {@template delete_group}
/// Event to delete a group (owner only)
/// {@endtemplate}
class DeleteGroup extends GroupsEvent {
  /// {@macro delete_group}
  const DeleteGroup({required this.groupId});

  final String groupId;

  @override
  List<Object?> get props => [groupId];
}
