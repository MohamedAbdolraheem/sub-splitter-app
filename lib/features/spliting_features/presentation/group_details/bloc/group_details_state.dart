part of 'group_details_bloc.dart';

/// {@template group_details_state}
/// GroupDetailsState description
/// {@endtemplate}
class GroupDetailsState extends Equatable {
  /// {@macro group_details_state}
  const GroupDetailsState({
    this.isLoading = false,
    this.isLeaving = false,
    this.groupName,
    this.serviceName,
    this.totalCost,
    this.billingCycle,
    this.nextRenewal,
    this.members = const [],
    this.recentActivities = const [],
    this.error,
  });

  final bool isLoading;
  final bool isLeaving;
  final String? groupName;
  final String? serviceName;
  final double? totalCost;
  final String? billingCycle;
  final String? nextRenewal;
  final List<Map<String, dynamic>> members;
  final List<Map<String, dynamic>> recentActivities;
  final String? error;

  @override
  List<Object?> get props => [
    isLoading,
    isLeaving,
    groupName,
    serviceName,
    totalCost,
    billingCycle,
    nextRenewal,
    members,
    recentActivities,
    error,
  ];

  /// Creates a copy of the current GroupDetailsState with property changes
  GroupDetailsState copyWith({
    bool? isLoading,
    bool? isLeaving,
    String? groupName,
    String? serviceName,
    double? totalCost,
    String? billingCycle,
    String? nextRenewal,
    List<Map<String, dynamic>>? members,
    List<Map<String, dynamic>>? recentActivities,
    String? error,
  }) {
    return GroupDetailsState(
      isLoading: isLoading ?? this.isLoading,
      isLeaving: isLeaving ?? this.isLeaving,
      groupName: groupName ?? this.groupName,
      serviceName: serviceName ?? this.serviceName,
      totalCost: totalCost ?? this.totalCost,
      billingCycle: billingCycle ?? this.billingCycle,
      nextRenewal: nextRenewal ?? this.nextRenewal,
      members: members ?? this.members,
      recentActivities: recentActivities ?? this.recentActivities,
      error: error ?? this.error,
    );
  }
}

/// {@template group_details_initial}
/// The initial state of GroupDetailsState
/// {@endtemplate}
class GroupDetailsInitial extends GroupDetailsState {
  /// {@macro group_details_initial}
  const GroupDetailsInitial() : super();
}
