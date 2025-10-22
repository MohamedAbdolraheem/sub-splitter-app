part of 'create_group_bloc.dart';

abstract class CreateGroupEvent extends Equatable {
  const CreateGroupEvent();

  @override
  List<Object> get props => [];
}

/// Event to update group name
class GroupNameChanged extends CreateGroupEvent {
  const GroupNameChanged(this.name);
  final String name;

  @override
  List<Object> get props => [name];
}

/// Event to update service selection
class ServiceChanged extends CreateGroupEvent {
  const ServiceChanged(this.serviceId);
  final String serviceId;

  @override
  List<Object> get props => [serviceId];
}

/// Event to update total cost
class TotalCostChanged extends CreateGroupEvent {
  const TotalCostChanged(this.cost);
  final double cost;

  @override
  List<Object> get props => [cost];
}

/// Event to update billing cycle
class BillingCycleChanged extends CreateGroupEvent {
  const BillingCycleChanged(this.cycle);
  final String cycle;

  @override
  List<Object> get props => [cycle];
}

/// Event to update group description
class DescriptionChanged extends CreateGroupEvent {
  const DescriptionChanged(this.description);
  final String description;

  @override
  List<Object> get props => [description];
}

/// Event to submit group creation
class CreateGroupSubmitted extends CreateGroupEvent {
  const CreateGroupSubmitted();
}

/// Event to reset form
class CreateGroupReset extends CreateGroupEvent {
  const CreateGroupReset();
}

/// Event to load services
class LoadServices extends CreateGroupEvent {
  const LoadServices();
}
