part of 'home_dashboard_bloc.dart';

/// {@template home_dashboard_state}
/// HomeDashboardState description
/// {@endtemplate}
class HomeDashboardState extends Equatable {
  /// {@macro home_dashboard_state}
  const HomeDashboardState({
    this.status = HomeDashboardStatus.initial,
    this.groups = const [],
    this.pendingInvites = const [],
    this.upcomingPayments = const [],
    this.upcomingRenewals = const [],
    this.dashboardData,
    this.dashboardDataModel,
    this.totalOwed = 0.0,
    this.totalOwing = 0.0,
    this.errorMessage,
    this.successMessage,
  });

  /// Current status
  final HomeDashboardStatus status;

  /// User's groups (owned and member) - using Map for now
  final List<Map<String, dynamic>> groups;

  /// Pending invites for the user - using Map for now
  final List<Map<String, dynamic>> pendingInvites;

  /// Upcoming payments due - using Map for now
  final List<Map<String, dynamic>> upcomingPayments;

  /// Upcoming renewals - using Map for now
  final List<Map<String, dynamic>> upcomingRenewals;

  /// Full dashboard data from API
  final Map<String, dynamic>? dashboardData;

  /// Dashboard data model
  final DashboardDataModel? dashboardDataModel;

  /// Total amount owed to user
  final double totalOwed;

  /// Total amount user owes
  final double totalOwing;

  /// Error message if any
  final String? errorMessage;

  /// Success message if any
  final String? successMessage;

  @override
  List<Object?> get props => [
    status,
    groups,
    pendingInvites,
    upcomingPayments,
    upcomingRenewals,
    dashboardData,
    dashboardDataModel,
    totalOwed,
    totalOwing,
    errorMessage,
    successMessage,
  ];

  /// Creates a copy of the current HomeDashboardState with property changes
  HomeDashboardState copyWith({
    HomeDashboardStatus? status,
    List<Map<String, dynamic>>? groups,
    List<Map<String, dynamic>>? pendingInvites,
    List<Map<String, dynamic>>? upcomingPayments,
    List<Map<String, dynamic>>? upcomingRenewals,
    Map<String, dynamic>? dashboardData,
    DashboardDataModel? dashboardDataModel,
    double? totalOwed,
    double? totalOwing,
    String? errorMessage,
    String? successMessage,
  }) {
    return HomeDashboardState(
      status: status ?? this.status,
      groups: groups ?? this.groups,
      pendingInvites: pendingInvites ?? this.pendingInvites,
      upcomingPayments: upcomingPayments ?? this.upcomingPayments,
      upcomingRenewals: upcomingRenewals ?? this.upcomingRenewals,
      dashboardData: dashboardData ?? this.dashboardData,
      dashboardDataModel: dashboardDataModel ?? this.dashboardDataModel,
      totalOwed: totalOwed ?? this.totalOwed,
      totalOwing: totalOwing ?? this.totalOwing,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
    );
  }
}

/// Dashboard status enum
enum HomeDashboardStatus { initial, loading, loaded, error }
