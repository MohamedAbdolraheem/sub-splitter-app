part of 'create_group_bloc.dart';

enum CreateGroupStatus { initial, loading, success, failure }

/// {@template create_group_state}
/// CreateGroupState description
/// {@endtemplate}
class CreateGroupState extends Equatable {
  /// {@macro create_group_state}
  const CreateGroupState({
    this.status = CreateGroupStatus.initial,
    this.groupName = '',
    this.serviceId = '',
    this.totalCost = 0.0,
    this.billingCycle = 'monthly',
    this.description = '',
    this.services = const [],
    this.errorMessage,
  });

  final CreateGroupStatus status;
  final String groupName;
  final String serviceId;
  final double totalCost;
  final String billingCycle;
  final String description;
  final List<Service> services;
  final String? errorMessage;

  @override
  List<Object?> get props => [
    status,
    groupName,
    serviceId,
    totalCost,
    billingCycle,
    description,
    services,
    errorMessage,
  ];

  /// Creates a copy of the current CreateGroupState with property changes
  CreateGroupState copyWith({
    CreateGroupStatus? status,
    String? groupName,
    String? serviceId,
    double? totalCost,
    String? billingCycle,
    String? description,
    List<Service>? services,
    String? errorMessage,
  }) {
    return CreateGroupState(
      status: status ?? this.status,
      groupName: groupName ?? this.groupName,
      serviceId: serviceId ?? this.serviceId,
      totalCost: totalCost ?? this.totalCost,
      billingCycle: billingCycle ?? this.billingCycle,
      description: description ?? this.description,
      services: services ?? this.services,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  /// Check if form is valid
  bool get isValid {
    return groupName.isNotEmpty &&
        serviceId.isNotEmpty &&
        totalCost > 0 &&
        billingCycle.isNotEmpty;
  }
}

/// {@template create_group_initial}
/// The initial state of CreateGroupState
/// {@endtemplate}
class CreateGroupInitial extends CreateGroupState {
  /// {@macro create_group_initial}
  const CreateGroupInitial() : super();
}
