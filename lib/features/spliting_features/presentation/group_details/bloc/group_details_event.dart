part of 'group_details_bloc.dart';

abstract class GroupDetailsEvent extends Equatable {
  const GroupDetailsEvent();

  @override
  List<Object> get props => [];
}

/// {@template load_group_details}
/// Load group details event
/// {@endtemplate}
class LoadGroupDetails extends GroupDetailsEvent {
  /// {@macro load_group_details}
  const LoadGroupDetails();
}

/// {@template refresh_group_details}
/// Refresh group details event
/// {@endtemplate}
class RefreshGroupDetails extends GroupDetailsEvent {
  /// {@macro refresh_group_details}
  const RefreshGroupDetails();
}

/// {@template leave_group_requested}
/// Event when user wants to leave the group
/// {@endtemplate}
class LeaveGroupRequested extends GroupDetailsEvent {
  /// {@macro leave_group_requested}
  const LeaveGroupRequested();
}
