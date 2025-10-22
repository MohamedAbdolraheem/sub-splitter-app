import 'dart:developer' as console;

import 'package:subscription_splitter_app/features/spliting_features/domain/entities/dashboard_data.dart';

/// {@template dashboard_data_model}
/// Dashboard data model for JSON serialization
/// {@endtemplate}
class DashboardDataModel extends DashboardData {
  /// {@macro dashboard_data_model}
  const DashboardDataModel({
    required super.summary,
    required super.payments,
    required super.invites,
    required super.upcomingRenewals,
    required super.serviceUsage,
    required super.monthlyTrend,
    required super.groupHealth,
    required super.recentActivities,
    required super.recentGroups,
    required super.recentPayments,
  });

  /// Creates a DashboardDataModel from JSON
  factory DashboardDataModel.fromJson(Map<String, dynamic> json) {
    return DashboardDataModel(
      summary: DashboardSummaryModel.fromJson(
        json['summary'] as Map<String, dynamic>? ?? {},
      ),
      payments: PaymentStatsModel.fromJson(
        json['payments'] as Map<String, dynamic>? ?? {},
      ),
      invites: InviteStatsModel.fromJson(
        json['invites'] as Map<String, dynamic>? ?? {},
      ),
      upcomingRenewals: _parseList<UpcomingRenewalModel>(
        json['upcoming_renewals'],
        (item) => UpcomingRenewalModel.fromJson(item as Map<String, dynamic>),
      ),
      serviceUsage: _parseList<ServiceUsageModel>(
        json['service_usage'],
        (item) => ServiceUsageModel.fromJson(item as Map<String, dynamic>),
      ),
      monthlyTrend: _parseList<MonthlyTrendModel>(
        json['monthly_trend'],
        (item) => MonthlyTrendModel.fromJson(item as Map<String, dynamic>),
      ),
      groupHealth: _parseList<GroupHealthModel>(
        json['group_health'],
        (item) => GroupHealthModel.fromJson(item as Map<String, dynamic>),
      ),
      recentActivities: _parseList<RecentActivityModel>(
        json['recent_activities'],
        (item) => RecentActivityModel.fromJson(item as Map<String, dynamic>),
      ),
      recentGroups: _parseList<RecentGroupModel>(
        json['recent_groups'],
        (item) => RecentGroupModel.fromJson(item as Map<String, dynamic>),
      ),
      recentPayments: _parseList<RecentPaymentModel>(
        json['recent_payments'],
        (item) => RecentPaymentModel.fromJson(item as Map<String, dynamic>),
      ),
    );
  }

  /// Helper method to safely parse lists that might be null
  static List<T> _parseList<T>(dynamic jsonList, T Function(dynamic) fromJson) {
    console.log('_parseList called with: $jsonList');
    console.log('Type: ${jsonList.runtimeType}');

    if (jsonList == null) {
      console.log('jsonList is null, returning empty list');
      return [];
    }

    if (jsonList is! List) {
      console.log('jsonList is not a List, returning empty list');
      return [];
    }

    try {
      console.log('Processing ${jsonList.length} items');
      return jsonList
          .where((item) => item != null)
          .map((item) => fromJson(item))
          .toList();
    } catch (e) {
      console.log('Error parsing list: $e');
      console.log('Stack trace: ${StackTrace.current}');
      return [];
    }
  }

  /// Converts this DashboardDataModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'summary': (summary as DashboardSummaryModel).toJson(),
      'payments': (payments as PaymentStatsModel).toJson(),
      'invites': (invites as InviteStatsModel).toJson(),
      'upcoming_renewals':
          upcomingRenewals
              .map((item) => (item as UpcomingRenewalModel).toJson())
              .toList(),
      'service_usage':
          serviceUsage
              .map((item) => (item as ServiceUsageModel).toJson())
              .toList(),
      'monthly_trend':
          monthlyTrend
              .map((item) => (item as MonthlyTrendModel).toJson())
              .toList(),
      'group_health':
          groupHealth
              .map((item) => (item as GroupHealthModel).toJson())
              .toList(),
      'recent_activities':
          recentActivities
              .map((item) => (item as RecentActivityModel).toJson())
              .toList(),
      'recent_groups':
          recentGroups
              .map((item) => (item as RecentGroupModel).toJson())
              .toList(),
      'recent_payments':
          recentPayments
              .map((item) => (item as RecentPaymentModel).toJson())
              .toList(),
    };
  }

  /// Creates a DashboardDataModel from a DashboardData entity
  factory DashboardDataModel.fromEntity(DashboardData dashboardData) {
    return DashboardDataModel(
      summary: DashboardSummaryModel.fromEntity(dashboardData.summary),
      payments: PaymentStatsModel.fromEntity(dashboardData.payments),
      invites: InviteStatsModel.fromEntity(dashboardData.invites),
      upcomingRenewals:
          dashboardData.upcomingRenewals
              .map((item) => UpcomingRenewalModel.fromEntity(item))
              .toList(),
      serviceUsage:
          dashboardData.serviceUsage
              .map((item) => ServiceUsageModel.fromEntity(item))
              .toList(),
      monthlyTrend:
          dashboardData.monthlyTrend
              .map((item) => MonthlyTrendModel.fromEntity(item))
              .toList(),
      groupHealth:
          dashboardData.groupHealth
              .map((item) => GroupHealthModel.fromEntity(item))
              .toList(),
      recentActivities:
          dashboardData.recentActivities
              .map((item) => RecentActivityModel.fromEntity(item))
              .toList(),
      recentGroups:
          dashboardData.recentGroups
              .map((item) => RecentGroupModel.fromEntity(item))
              .toList(),
      recentPayments:
          dashboardData.recentPayments
              .map((item) => RecentPaymentModel.fromEntity(item))
              .toList(),
    );
  }

  /// Converts this DashboardDataModel to a DashboardData entity
  DashboardData toEntity() {
    return DashboardData(
      summary: summary,
      payments: payments,
      invites: invites,
      upcomingRenewals: upcomingRenewals,
      serviceUsage: serviceUsage,
      monthlyTrend: monthlyTrend,
      groupHealth: groupHealth,
      recentActivities: recentActivities,
      recentGroups: recentGroups,
      recentPayments: recentPayments,
    );
  }
}

/// {@template dashboard_summary_model}
/// Dashboard summary model
/// {@endtemplate}
class DashboardSummaryModel extends DashboardSummary {
  /// {@macro dashboard_summary_model}
  const DashboardSummaryModel({
    required super.totalGroups,
    required super.ownedGroups,
    required super.memberGroups,
    required super.totalMonthlyCost,
    required super.totalYearlyCost,
    required super.totalSavings,
    required super.totalFullCost,
    required super.savingsPercentage,
  });

  factory DashboardSummaryModel.fromJson(Map<String, dynamic> json) {
    return DashboardSummaryModel(
      totalGroups: json['total_groups'] as int? ?? 0,
      ownedGroups: json['owned_groups'] as int? ?? 0,
      memberGroups: json['member_groups'] as int? ?? 0,
      totalMonthlyCost: (json['total_monthly_cost'] as num? ?? 0).toDouble(),
      totalYearlyCost: (json['total_yearly_cost'] as num? ?? 0).toDouble(),
      totalSavings: (json['total_savings'] as num? ?? 0).toDouble(),
      totalFullCost: (json['total_full_cost'] as num? ?? 0).toDouble(),
      savingsPercentage: (json['savings_percentage'] as num? ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_groups': totalGroups,
      'owned_groups': ownedGroups,
      'member_groups': memberGroups,
      'total_monthly_cost': totalMonthlyCost,
      'total_yearly_cost': totalYearlyCost,
      'total_savings': totalSavings,
      'total_full_cost': totalFullCost,
      'savings_percentage': savingsPercentage,
    };
  }

  factory DashboardSummaryModel.fromEntity(DashboardSummary summary) {
    return DashboardSummaryModel(
      totalGroups: summary.totalGroups,
      ownedGroups: summary.ownedGroups,
      memberGroups: summary.memberGroups,
      totalMonthlyCost: summary.totalMonthlyCost,
      totalYearlyCost: summary.totalYearlyCost,
      totalSavings: summary.totalSavings,
      totalFullCost: summary.totalFullCost,
      savingsPercentage: summary.savingsPercentage,
    );
  }
}

/// {@template payment_stats_model}
/// Payment stats model
/// {@endtemplate}
class PaymentStatsModel extends PaymentStats {
  /// {@macro payment_stats_model}
  const PaymentStatsModel({
    required super.totalPayments,
    required super.pendingPayments,
    required super.completedPayments,
    required super.failedPayments,
    required super.totalPaid,
    required super.pendingAmount,
    required super.averagePayment,
  });

  factory PaymentStatsModel.fromJson(Map<String, dynamic> json) {
    return PaymentStatsModel(
      totalPayments: json['total_payments'] as int? ?? 0,
      pendingPayments: json['pending_payments'] as int? ?? 0,
      completedPayments: json['completed_payments'] as int? ?? 0,
      failedPayments: json['failed_payments'] as int? ?? 0,
      totalPaid: (json['total_paid'] as num? ?? 0).toDouble(),
      pendingAmount: (json['pending_amount'] as num? ?? 0).toDouble(),
      averagePayment: (json['average_payment'] as num? ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_payments': totalPayments,
      'pending_payments': pendingPayments,
      'completed_payments': completedPayments,
      'failed_payments': failedPayments,
      'total_paid': totalPaid,
      'pending_amount': pendingAmount,
      'average_payment': averagePayment,
    };
  }

  factory PaymentStatsModel.fromEntity(PaymentStats payments) {
    return PaymentStatsModel(
      totalPayments: payments.totalPayments,
      pendingPayments: payments.pendingPayments,
      completedPayments: payments.completedPayments,
      failedPayments: payments.failedPayments,
      totalPaid: payments.totalPaid,
      pendingAmount: payments.pendingAmount,
      averagePayment: payments.averagePayment,
    );
  }
}

/// {@template invite_stats_model}
/// Invite stats model
/// {@endtemplate}
class InviteStatsModel extends InviteStats {
  /// {@macro invite_stats_model}
  const InviteStatsModel({
    required super.totalInvites,
    required super.pendingInvites,
    required super.acceptedInvites,
    required super.declinedInvites,
    required super.acceptanceRate,
  });

  factory InviteStatsModel.fromJson(Map<String, dynamic> json) {
    return InviteStatsModel(
      totalInvites: json['total_invites'] as int? ?? 0,
      pendingInvites: json['pending_invites'] as int? ?? 0,
      acceptedInvites: json['accepted_invites'] as int? ?? 0,
      declinedInvites: json['declined_invites'] as int? ?? 0,
      acceptanceRate: (json['acceptance_rate'] as num? ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_invites': totalInvites,
      'pending_invites': pendingInvites,
      'accepted_invites': acceptedInvites,
      'declined_invites': declinedInvites,
      'acceptance_rate': acceptanceRate,
    };
  }

  factory InviteStatsModel.fromEntity(InviteStats invites) {
    return InviteStatsModel(
      totalInvites: invites.totalInvites,
      pendingInvites: invites.pendingInvites,
      acceptedInvites: invites.acceptedInvites,
      declinedInvites: invites.declinedInvites,
      acceptanceRate: invites.acceptanceRate,
    );
  }
}

/// {@template upcoming_renewal_model}
/// Upcoming renewal model
/// {@endtemplate}
class UpcomingRenewalModel extends UpcomingRenewal {
  /// {@macro upcoming_renewal_model}
  const UpcomingRenewalModel({
    required super.id,
    required super.groupId,
    required super.groupName,
    required super.serviceName,
    required super.amount,
    required super.renewDate,
    required super.isOverdue,
  });

  factory UpcomingRenewalModel.fromJson(Map<String, dynamic> json) {
    return UpcomingRenewalModel(
      id: json['id'] as String,
      groupId:
          json['group_id'] as String? ??
          json['id'] as String, // Use id as fallback
      groupName:
          json['group_name'] as String? ??
          json['name'] as String? ??
          '', // Use name as fallback
      serviceName:
          json['service_name'] as String? ??
          json['service'] as String? ??
          '', // Use service as fallback
      amount:
          (json['amount'] as num? ?? json['total_cost'] as num? ?? 0)
              .toDouble(), // Use total_cost as fallback
      renewDate: DateTime.parse(json['renew_date'] as String),
      isOverdue:
          json['is_overdue'] as bool? ?? false, // Handle missing is_overdue
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'group_id': groupId,
      'group_name': groupName,
      'service_name': serviceName,
      'amount': amount,
      'renew_date': renewDate.toIso8601String(),
      'is_overdue': isOverdue,
    };
  }

  factory UpcomingRenewalModel.fromEntity(UpcomingRenewal renewal) {
    return UpcomingRenewalModel(
      id: renewal.id,
      groupId: renewal.groupId,
      groupName: renewal.groupName,
      serviceName: renewal.serviceName,
      amount: renewal.amount,
      renewDate: renewal.renewDate,
      isOverdue: renewal.isOverdue,
    );
  }
}

/// {@template service_usage_model}
/// Service usage model
/// {@endtemplate}
class ServiceUsageModel extends ServiceUsage {
  /// {@macro service_usage_model}
  const ServiceUsageModel({
    required super.serviceId,
    required super.serviceName,
    required super.usageCount,
    required super.totalCost,
    required super.averageCost,
  });

  factory ServiceUsageModel.fromJson(Map<String, dynamic> json) {
    return ServiceUsageModel(
      serviceId: json['service_id'] as String,
      serviceName: json['service_name'] as String,
      usageCount: json['usage_count'] as int,
      totalCost: (json['total_cost'] as num).toDouble(),
      averageCost: (json['average_cost'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'service_id': serviceId,
      'service_name': serviceName,
      'usage_count': usageCount,
      'total_cost': totalCost,
      'average_cost': averageCost,
    };
  }

  factory ServiceUsageModel.fromEntity(ServiceUsage usage) {
    return ServiceUsageModel(
      serviceId: usage.serviceId,
      serviceName: usage.serviceName,
      usageCount: usage.usageCount,
      totalCost: usage.totalCost,
      averageCost: usage.averageCost,
    );
  }
}

/// {@template monthly_trend_model}
/// Monthly trend model
/// {@endtemplate}
class MonthlyTrendModel extends MonthlyTrend {
  /// {@macro monthly_trend_model}
  const MonthlyTrendModel({
    required super.month,
    required super.year,
    required super.totalCost,
    required super.savings,
    required super.groupCount,
  });

  factory MonthlyTrendModel.fromJson(Map<String, dynamic> json) {
    return MonthlyTrendModel(
      month: json['month'] as int,
      year: json['year'] as int,
      totalCost: (json['total_cost'] as num).toDouble(),
      savings: (json['savings'] as num).toDouble(),
      groupCount: json['group_count'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'year': year,
      'total_cost': totalCost,
      'savings': savings,
      'group_count': groupCount,
    };
  }

  factory MonthlyTrendModel.fromEntity(MonthlyTrend trend) {
    return MonthlyTrendModel(
      month: trend.month,
      year: trend.year,
      totalCost: trend.totalCost,
      savings: trend.savings,
      groupCount: trend.groupCount,
    );
  }
}

/// {@template group_health_model}
/// Group health model
/// {@endtemplate}
class GroupHealthModel extends GroupHealth {
  /// {@macro group_health_model}
  const GroupHealthModel({
    required super.groupId,
    required super.groupName,
    required super.healthScore,
    required super.memberCount,
    required super.paymentRate,
    required super.lastActivity,
  });

  factory GroupHealthModel.fromJson(Map<String, dynamic> json) {
    return GroupHealthModel(
      groupId: json['group_id'] as String,
      groupName: json['group_name'] as String,
      healthScore: (json['health_score'] as num).toDouble(),
      memberCount: json['member_count'] as int,
      paymentRate: (json['payment_rate'] as num).toDouble(),
      lastActivity: DateTime.parse(json['last_activity'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'group_id': groupId,
      'group_name': groupName,
      'health_score': healthScore,
      'member_count': memberCount,
      'payment_rate': paymentRate,
      'last_activity': lastActivity.toIso8601String(),
    };
  }

  factory GroupHealthModel.fromEntity(GroupHealth health) {
    return GroupHealthModel(
      groupId: health.groupId,
      groupName: health.groupName,
      healthScore: health.healthScore,
      memberCount: health.memberCount,
      paymentRate: health.paymentRate,
      lastActivity: health.lastActivity,
    );
  }
}

/// {@template recent_activity_model}
/// Recent activity model
/// {@endtemplate}
class RecentActivityModel extends RecentActivity {
  /// {@macro recent_activity_model}
  const RecentActivityModel({
    required super.id,
    required super.type,
    required super.description,
    required super.timestamp,
    required super.groupId,
    required super.groupName,
  });

  factory RecentActivityModel.fromJson(Map<String, dynamic> json) {
    return RecentActivityModel(
      id: json['id'] as String,
      type: json['type'] as String,
      description: json['description'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      groupId: json['group_id'] as String,
      groupName: json['group_name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
      'group_id': groupId,
      'group_name': groupName,
    };
  }

  factory RecentActivityModel.fromEntity(RecentActivity activity) {
    return RecentActivityModel(
      id: activity.id,
      type: activity.type,
      description: activity.description,
      timestamp: activity.timestamp,
      groupId: activity.groupId,
      groupName: activity.groupName,
    );
  }
}

/// {@template recent_group_model}
/// Recent group model
/// {@endtemplate}
class RecentGroupModel extends RecentGroup {
  /// {@macro recent_group_model}
  const RecentGroupModel({
    required super.id,
    required super.serviceId,
    required super.ownerId,
    required super.name,
    required super.totalCost,
    required super.cycle,
    required super.renewDate,
    required super.createdAt,
  });

  factory RecentGroupModel.fromJson(Map<String, dynamic> json) {
    console.log('RecentGroupModel.fromJson called with: $json');

    try {
      return RecentGroupModel(
        id: json['id'] as String,
        serviceId:
            json['service_id'] as String? ?? '', // Handle missing service_id
        ownerId: json['owner_id'] as String? ?? '', // Handle missing owner_id
        name: json['name'] as String,
        totalCost: (json['total_cost'] as num? ?? 0).toDouble(),
        cycle: json['cycle'] as String? ?? 'monthly', // Handle missing cycle
        renewDate:
            json['renew_date'] != null
                ? DateTime.parse(json['renew_date'] as String)
                : DateTime.now(), // Handle missing renew_date
        createdAt:
            json['created_at'] != null
                ? DateTime.parse(json['created_at'] as String)
                : DateTime.now(), // Handle missing created_at
      );
    } catch (e) {
      console.log('Error in RecentGroupModel.fromJson: $e');
      console.log('JSON: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'service_id': serviceId,
      'owner_id': ownerId,
      'name': name,
      'total_cost': totalCost,
      'cycle': cycle,
      'renew_date': renewDate.toIso8601String().split('T')[0],
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory RecentGroupModel.fromEntity(RecentGroup group) {
    return RecentGroupModel(
      id: group.id,
      serviceId: group.serviceId,
      ownerId: group.ownerId,
      name: group.name,
      totalCost: group.totalCost,
      cycle: group.cycle,
      renewDate: group.renewDate,
      createdAt: group.createdAt,
    );
  }
}

/// {@template recent_payment_model}
/// Recent payment model
/// {@endtemplate}
class RecentPaymentModel extends RecentPayment {
  /// {@macro recent_payment_model}
  const RecentPaymentModel({
    required super.id,
    required super.groupId,
    required super.userId,
    required super.amount,
    required super.status,
    super.paidAt,
  });

  factory RecentPaymentModel.fromJson(Map<String, dynamic> json) {
    return RecentPaymentModel(
      id: json['id'] as String,
      groupId: json['group_id'] as String,
      userId: json['user_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      status: json['status'] as String,
      paidAt:
          json['paid_at'] != null
              ? DateTime.parse(json['paid_at'] as String)
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'group_id': groupId,
      'user_id': userId,
      'amount': amount,
      'status': status,
      'paid_at': paidAt?.toIso8601String(),
    };
  }

  factory RecentPaymentModel.fromEntity(RecentPayment payment) {
    return RecentPaymentModel(
      id: payment.id,
      groupId: payment.groupId,
      userId: payment.userId,
      amount: payment.amount,
      status: payment.status,
      paidAt: payment.paidAt,
    );
  }
}
