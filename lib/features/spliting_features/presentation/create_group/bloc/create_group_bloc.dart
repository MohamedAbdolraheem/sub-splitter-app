import 'dart:async';
import 'dart:developer' as console;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:subscription_splitter_app/core/di/service_locator.dart';
import 'package:subscription_splitter_app/core/errors/failures.dart';
import 'package:subscription_splitter_app/features/spliting_features/domain/entities/service.dart';
import 'package:subscription_splitter_app/features/spliting_features/domain/repositories/groups_repository.dart';
import 'package:subscription_splitter_app/features/spliting_features/domain/repositories/services_repository.dart';

part 'create_group_event.dart';
part 'create_group_state.dart';

class CreateGroupBloc extends Bloc<CreateGroupEvent, CreateGroupState> {
  final GroupsRepository _groupsRepository;
  final ServicesRepository _servicesRepository;

  CreateGroupBloc({
    GroupsRepository? groupsRepository,
    ServicesRepository? servicesRepository,
  }) : _groupsRepository =
           groupsRepository ?? ServiceLocator().groupsRepository,
       _servicesRepository =
           servicesRepository ?? ServiceLocator().servicesRepository,
       super(const CreateGroupInitial()) {
    on<GroupNameChanged>(_onGroupNameChanged);
    on<ServiceChanged>(_onServiceChanged);
    on<TotalCostChanged>(_onTotalCostChanged);
    on<BillingCycleChanged>(_onBillingCycleChanged);
    on<DescriptionChanged>(_onDescriptionChanged);
    on<CreateGroupSubmitted>(_onCreateGroupSubmitted);
    on<CreateGroupReset>(_onCreateGroupReset);
    on<LoadServices>(_onLoadServices);
  }

  FutureOr<void> _onGroupNameChanged(
    GroupNameChanged event,
    Emitter<CreateGroupState> emit,
  ) {
    emit(state.copyWith(groupName: event.name));
  }

  FutureOr<void> _onServiceChanged(
    ServiceChanged event,
    Emitter<CreateGroupState> emit,
  ) {
    emit(state.copyWith(serviceId: event.serviceId));
  }

  FutureOr<void> _onTotalCostChanged(
    TotalCostChanged event,
    Emitter<CreateGroupState> emit,
  ) {
    emit(state.copyWith(totalCost: event.cost));
  }

  FutureOr<void> _onBillingCycleChanged(
    BillingCycleChanged event,
    Emitter<CreateGroupState> emit,
  ) {
    emit(state.copyWith(billingCycle: event.cycle));
  }

  FutureOr<void> _onDescriptionChanged(
    DescriptionChanged event,
    Emitter<CreateGroupState> emit,
  ) {
    emit(state.copyWith(description: event.description));
  }

  FutureOr<void> _onCreateGroupSubmitted(
    CreateGroupSubmitted event,
    Emitter<CreateGroupState> emit,
  ) async {
    if (!state.isValid) {
      emit(
        state.copyWith(
          status: CreateGroupStatus.failure,
          errorMessage: 'Please fill in all required fields',
        ),
      );
      return;
    }

    emit(state.copyWith(status: CreateGroupStatus.loading));

    try {
      // Get current user
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        throw AuthenticationFailure(message: 'User not authenticated');
      }

      // Calculate renew date (next month for monthly, next year for yearly)
      final now = DateTime.now();
      final renewDate =
          state.billingCycle == 'yearly'
              ? DateTime(now.year + 1, now.month, now.day)
              : DateTime(now.year, now.month + 1, now.day);

      // Create the group
      await _groupsRepository.createGroup(
        serviceId: state.serviceId,
        ownerId: user.id,
        name: state.groupName,
        totalCost: state.totalCost,
        cycle: state.billingCycle,
        renewDate: renewDate.toIso8601String(),
      );

      emit(state.copyWith(status: CreateGroupStatus.success));
    } catch (e) {
      String errorMessage = 'Failed to create group. Please try again.';

      if (e is NetworkFailure) {
        errorMessage = 'Network error. Please check your connection.';
      } else if (e is ServerFailure) {
        errorMessage = 'Server error: ${e.message}';
      } else if (e is ValidationFailure) {
        errorMessage = 'Validation error: ${e.message}';
      } else if (e is AuthenticationFailure) {
        errorMessage = 'Authentication error: ${e.message}';
      } else {
        console.log('CreateGroupBloc: Unexpected error: ${e.toString()}');
        errorMessage = 'Unexpected error: ${e.toString()} ';
      }

      emit(
        state.copyWith(
          status: CreateGroupStatus.failure,
          errorMessage: errorMessage,
        ),
      );
    }
  }

  FutureOr<void> _onCreateGroupReset(
    CreateGroupReset event,
    Emitter<CreateGroupState> emit,
  ) {
    emit(const CreateGroupInitial());
  }

  FutureOr<void> _onLoadServices(
    LoadServices event,
    Emitter<CreateGroupState> emit,
  ) async {
    try {
      print('CreateGroupBloc: Loading services...');
      final services = await _servicesRepository.getServices();
      print('CreateGroupBloc: Loaded ${services.length} services');
      emit(state.copyWith(services: services));
    } catch (e) {
      print('CreateGroupBloc: Error loading services: $e');
      emit(
        state.copyWith(
          errorMessage: 'Failed to load services: ${e.toString()}',
        ),
      );
    }
  }
}
