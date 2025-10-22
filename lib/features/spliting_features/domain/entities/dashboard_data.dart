import 'package:equatable/equatable.dart';

/// {@template dashboard_data}
/// Dashboard data entity containing all dashboard information
/// {@endtemplate}
class DashboardData extends Equatable {
  /// {@macro dashboard_data}
  const DashboardData({
    required this.summary,
    required this.payments,
    required this.invites,
    required this.upcomingRenewals,
    required this.serviceUsage,
    required this.monthlyTrend,
    required this.groupHealth,
    required this.recentActivities,
    required this.recentGroups,
    required this.recentPayments,
  });

  /// Summary statistics
  final DashboardSummary summary;

  /// Payment statistics
  final PaymentStats payments;

  /// Invite statistics
  final InviteStats invites;

  /// Upcoming renewals
  final List<UpcomingRenewal> upcomingRenewals;

  /// Service usage data
  final List<ServiceUsage> serviceUsage;

  /// Monthly trend data
  final List<MonthlyTrend> monthlyTrend;

  /// Group health data
  final List<GroupHealth> groupHealth;

  /// Recent activities
  final List<RecentActivity> recentActivities;

  /// Recent groups
  final List<RecentGroup> recentGroups;

  /// Recent payments
  final List<RecentPayment> recentPayments;

  @override
  List<Object?> get props => [
    summary,
    payments,
    invites,
    upcomingRenewals,
    serviceUsage,
    monthlyTrend,
    groupHealth,
    recentActivities,
    recentGroups,
    recentPayments,
  ];
}

/// {@template dashboard_summary}
/// Dashboard summary statistics
/// {@endtemplate}
class DashboardSummary extends Equatable {
  /// {@macro dashboard_summary}
  const DashboardSummary({
    required this.totalGroups,
    required this.ownedGroups,
    required this.memberGroups,
    required this.totalMonthlyCost,
    required this.totalYearlyCost,
    required this.totalSavings,
    required this.totalFullCost,
    required this.savingsPercentage,
  });

  final int totalGroups;
  final int ownedGroups;
  final int memberGroups;
  final double totalMonthlyCost;
  final double totalYearlyCost;
  final double totalSavings;
  final double totalFullCost;
  final double savingsPercentage;

  @override
  List<Object?> get props => [
    totalGroups,
    ownedGroups,
    memberGroups,
    totalMonthlyCost,
    totalYearlyCost,
    totalSavings,
    totalFullCost,
    savingsPercentage,
  ];
}

/// {@template payment_stats}
/// Payment statistics
/// {@endtemplate}
class PaymentStats extends Equatable {
  /// {@macro payment_stats}
  const PaymentStats({
    required this.totalPayments,
    required this.pendingPayments,
    required this.completedPayments,
    required this.failedPayments,
    required this.totalPaid,
    required this.pendingAmount,
    required this.averagePayment,
  });

  final int totalPayments;
  final int pendingPayments;
  final int completedPayments;
  final int failedPayments;
  final double totalPaid;
  final double pendingAmount;
  final double averagePayment;

  @override
  List<Object?> get props => [
    totalPayments,
    pendingPayments,
    completedPayments,
    failedPayments,
    totalPaid,
    pendingAmount,
    averagePayment,
  ];
}

/// {@template invite_stats}
/// Invite statistics
/// {@endtemplate}
class InviteStats extends Equatable {
  /// {@macro invite_stats}
  const InviteStats({
    required this.totalInvites,
    required this.pendingInvites,
    required this.acceptedInvites,
    required this.declinedInvites,
    required this.acceptanceRate,
  });

  final int totalInvites;
  final int pendingInvites;
  final int acceptedInvites;
  final int declinedInvites;
  final double acceptanceRate;

  @override
  List<Object?> get props => [
    totalInvites,
    pendingInvites,
    acceptedInvites,
    declinedInvites,
    acceptanceRate,
  ];
}

/// {@template upcoming_renewal}
/// Upcoming renewal data
/// {@endtemplate}
class UpcomingRenewal extends Equatable {
  /// {@macro upcoming_renewal}
  const UpcomingRenewal({
    required this.id,
    required this.groupId,
    required this.groupName,
    required this.serviceName,
    required this.amount,
    required this.renewDate,
    required this.isOverdue,
  });

  final String id;
  final String groupId;
  final String groupName;
  final String serviceName;
  final double amount;
  final DateTime renewDate;
  final bool isOverdue;

  @override
  List<Object?> get props => [
    id,
    groupId,
    groupName,
    serviceName,
    amount,
    renewDate,
    isOverdue,
  ];
}

/// {@template service_usage}
/// Service usage data
/// {@endtemplate}
class ServiceUsage extends Equatable {
  /// {@macro service_usage}
  const ServiceUsage({
    required this.serviceId,
    required this.serviceName,
    required this.usageCount,
    required this.totalCost,
    required this.averageCost,
  });

  final String serviceId;
  final String serviceName;
  final int usageCount;
  final double totalCost;
  final double averageCost;

  @override
  List<Object?> get props => [
    serviceId,
    serviceName,
    usageCount,
    totalCost,
    averageCost,
  ];
}

/// {@template monthly_trend}
/// Monthly trend data
/// {@endtemplate}
class MonthlyTrend extends Equatable {
  /// {@macro monthly_trend}
  const MonthlyTrend({
    required this.month,
    required this.year,
    required this.totalCost,
    required this.savings,
    required this.groupCount,
  });

  final int month;
  final int year;
  final double totalCost;
  final double savings;
  final int groupCount;

  @override
  List<Object?> get props => [month, year, totalCost, savings, groupCount];
}

/// {@template group_health}
/// Group health data
/// {@endtemplate}
class GroupHealth extends Equatable {
  /// {@macro group_health}
  const GroupHealth({
    required this.groupId,
    required this.groupName,
    required this.healthScore,
    required this.memberCount,
    required this.paymentRate,
    required this.lastActivity,
  });

  final String groupId;
  final String groupName;
  final double healthScore;
  final int memberCount;
  final double paymentRate;
  final DateTime lastActivity;

  @override
  List<Object?> get props => [
    groupId,
    groupName,
    healthScore,
    memberCount,
    paymentRate,
    lastActivity,
  ];
}

/// {@template recent_activity}
/// Recent activity data
/// {@endtemplate}
class RecentActivity extends Equatable {
  /// {@macro recent_activity}
  const RecentActivity({
    required this.id,
    required this.type,
    required this.description,
    required this.timestamp,
    required this.groupId,
    required this.groupName,
  });

  final String id;
  final String type;
  final String description;
  final DateTime timestamp;
  final String groupId;
  final String groupName;

  @override
  List<Object?> get props => [
    id,
    type,
    description,
    timestamp,
    groupId,
    groupName,
  ];
}

/// {@template recent_group}
/// Recent group data
/// {@endtemplate}
class RecentGroup extends Equatable {
  /// {@macro recent_group}
  const RecentGroup({
    required this.id,
    required this.serviceId,
    required this.ownerId,
    required this.name,
    required this.totalCost,
    required this.cycle,
    required this.renewDate,
    required this.createdAt,
  });

  final String id;
  final String serviceId;
  final String ownerId;
  final String name;
  final double totalCost;
  final String cycle;
  final DateTime renewDate;
  final DateTime createdAt;

  @override
  List<Object?> get props => [
    id,
    serviceId,
    ownerId,
    name,
    totalCost,
    cycle,
    renewDate,
    createdAt,
  ];
}

/// {@template recent_payment}
/// Recent payment data
/// {@endtemplate}
class RecentPayment extends Equatable {
  /// {@macro recent_payment}
  const RecentPayment({
    required this.id,
    required this.groupId,
    required this.userId,
    required this.amount,
    required this.status,
    this.paidAt,
  });

  final String id;
  final String groupId;
  final String userId;
  final double amount;
  final String status;
  final DateTime? paidAt;

  @override
  List<Object?> get props => [id, groupId, userId, amount, status, paidAt];

  /// Check if payment is completed
  bool get isCompleted => status == 'completed';

  /// Check if payment is pending
  bool get isPending => status == 'pending';

  /// Check if payment is failed
  bool get isFailed => status == 'failed';

  /// Check if payment is paid
  bool get isPaid => isCompleted;
}

