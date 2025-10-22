part of 'home_dashboard_bloc.dart';

abstract class HomeDashboardEvent extends Equatable {
  const HomeDashboardEvent();

  @override
  List<Object> get props => [];
}

/// {@template home_dashboard_initialized}
/// Event when home dashboard is initialized
/// {@endtemplate}
class HomeDashboardInitialized extends HomeDashboardEvent {
  /// {@macro home_dashboard_initialized}
  const HomeDashboardInitialized();
}

/// {@template home_dashboard_refresh_requested}
/// Event when user requests to refresh the dashboard
/// {@endtemplate}
class HomeDashboardRefreshRequested extends HomeDashboardEvent {
  /// {@macro home_dashboard_refresh_requested}
  const HomeDashboardRefreshRequested();
}

/// {@template home_dashboard_navigated_to}
/// Event when user navigates to the home dashboard
/// {@endtemplate}
class HomeDashboardNavigatedTo extends HomeDashboardEvent {
  /// {@macro home_dashboard_navigated_to}
  const HomeDashboardNavigatedTo();
}

/// {@template create_group_requested}
/// Event when user wants to create a new group
/// {@endtemplate}
class CreateGroupRequested extends HomeDashboardEvent {
  /// {@macro create_group_requested}
  const CreateGroupRequested();
}

/// {@template join_group_requested}
/// Event when user wants to join a group via invite
/// {@endtemplate}
class JoinGroupRequested extends HomeDashboardEvent {
  /// {@macro join_group_requested}
  const JoinGroupRequested({required this.inviteId});

  final String inviteId;

  @override
  List<Object> get props => [inviteId];
}

/// {@template reject_invite_requested}
/// Event when user wants to reject an invite
/// {@endtemplate}
class RejectInviteRequested extends HomeDashboardEvent {
  /// {@macro reject_invite_requested}
  const RejectInviteRequested({required this.inviteId});

  final String inviteId;

  @override
  List<Object> get props => [inviteId];
}

/// {@template mark_payment_completed}
/// Event when user marks a payment as completed
/// {@endtemplate}
class MarkPaymentCompleted extends HomeDashboardEvent {
  /// {@macro mark_payment_completed}
  const MarkPaymentCompleted({required this.paymentId});

  final String paymentId;

  @override
  List<Object> get props => [paymentId];
}

/// {@template leave_group_requested}
/// Event when user wants to leave a group
/// {@endtemplate}
class LeaveGroupRequested extends HomeDashboardEvent {
  /// {@macro leave_group_requested}
  const LeaveGroupRequested({required this.groupId});

  final String groupId;

  @override
  List<Object> get props => [groupId];
}

/// {@template home_dashboard_success_message_cleared}
/// Event to clear success message
/// {@endtemplate}
class HomeDashboardSuccessMessageCleared extends HomeDashboardEvent {
  /// {@macro home_dashboard_success_message_cleared}
  const HomeDashboardSuccessMessageCleared();
}
