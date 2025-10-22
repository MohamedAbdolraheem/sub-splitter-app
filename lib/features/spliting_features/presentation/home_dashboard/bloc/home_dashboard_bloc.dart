import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:subscription_splitter_app/core/errors/failures.dart';
import '../../../domain/repositories/dashboard_repository.dart';
import '../../../domain/repositories/invites_repository.dart';
import '../../../domain/repositories/payments_repository.dart';
import '../../../domain/repositories/groups_repository.dart';
import '../../../data/models/dashboard_data_model.dart';

part 'home_dashboard_event.dart';
part 'home_dashboard_state.dart';

class HomeDashboardBloc extends Bloc<HomeDashboardEvent, HomeDashboardState> {
  final DashboardRepository _dashboardRepository;
  final InvitesRepository _invitesRepository;
  final PaymentsRepository _paymentsRepository;
  final GroupsRepository _groupsRepository;

  HomeDashboardBloc({
    required DashboardRepository dashboardRepository,
    required InvitesRepository invitesRepository,
    required PaymentsRepository paymentsRepository,
    required GroupsRepository groupsRepository,
  }) : _dashboardRepository = dashboardRepository,
       _invitesRepository = invitesRepository,
       _paymentsRepository = paymentsRepository,
       _groupsRepository = groupsRepository,
       super(const HomeDashboardState()) {
    on<HomeDashboardInitialized>(_onHomeDashboardInitialized);
    on<HomeDashboardRefreshRequested>(_onHomeDashboardRefreshRequested);
    on<HomeDashboardNavigatedTo>(_onHomeDashboardNavigatedTo);
    on<CreateGroupRequested>(_onCreateGroupRequested);
    on<JoinGroupRequested>(_onJoinGroupRequested);
    on<RejectInviteRequested>(_onRejectInviteRequested);
    on<MarkPaymentCompleted>(_onMarkPaymentCompleted);
    on<LeaveGroupRequested>(_onLeaveGroupRequested);
    on<HomeDashboardSuccessMessageCleared>(_onSuccessMessageCleared);
  }

  FutureOr<void> _onHomeDashboardInitialized(
    HomeDashboardInitialized event,
    Emitter<HomeDashboardState> emit,
  ) async {
    emit(state.copyWith(status: HomeDashboardStatus.loading));

    try {
      // Get current user ID
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        emit(
          state.copyWith(
            status: HomeDashboardStatus.error,
            errorMessage: 'User not authenticated',
          ),
        );
        return;
      }

      // Load dashboard data
      await _loadDashboardData(user.id, emit);
    } catch (e) {
      emit(
        state.copyWith(
          status: HomeDashboardStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  FutureOr<void> _onHomeDashboardRefreshRequested(
    HomeDashboardRefreshRequested event,
    Emitter<HomeDashboardState> emit,
  ) async {
    emit(
      state.copyWith(status: HomeDashboardStatus.loading, errorMessage: null),
    );

    try {
      // Get current user ID
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        emit(
          state.copyWith(
            status: HomeDashboardStatus.error,
            errorMessage: 'User not authenticated',
          ),
        );
        return;
      }

      // Refresh dashboard data
      await _loadDashboardData(user.id, emit);
    } catch (e) {
      emit(
        state.copyWith(
          status: HomeDashboardStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  FutureOr<void> _onHomeDashboardNavigatedTo(
    HomeDashboardNavigatedTo event,
    Emitter<HomeDashboardState> emit,
  ) async {
    try {
      // Get current user ID
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        emit(
          state.copyWith(
            status: HomeDashboardStatus.error,
            errorMessage: 'User not authenticated',
          ),
        );
        return;
      }

      // Load dashboard data when navigated to
      await _loadDashboardData(user.id, emit);
    } catch (e) {
      emit(
        state.copyWith(
          status: HomeDashboardStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  FutureOr<void> _onCreateGroupRequested(
    CreateGroupRequested event,
    Emitter<HomeDashboardState> emit,
  ) {
    // TODO: Navigate to create group page
    // This will be handled by the UI layer
  }

  FutureOr<void> _onJoinGroupRequested(
    JoinGroupRequested event,
    Emitter<HomeDashboardState> emit,
  ) async {
    try {
      // Get current user
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        emit(
          state.copyWith(
            status: HomeDashboardStatus.error,
            errorMessage: 'User not authenticated',
          ),
        );
        return;
      }

      // Accept the invitation via API
      await _invitesRepository.acceptInvitation(
        inviteId: event.inviteId,
        userId: user.id,
      );

      // Refresh dashboard data to get updated state
      await _loadDashboardData(user.id, emit);

      // Emit success message
      emit(state.copyWith(successMessage: 'Invitation accepted successfully!'));
    } catch (e) {
      emit(
        state.copyWith(
          status: HomeDashboardStatus.error,
          errorMessage: 'Failed to accept invitation: ${e.toString()}',
        ),
      );
    }
  }

  FutureOr<void> _onRejectInviteRequested(
    RejectInviteRequested event,
    Emitter<HomeDashboardState> emit,
  ) async {
    try {
      // Get current user
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        emit(
          state.copyWith(
            status: HomeDashboardStatus.error,
            errorMessage: 'User not authenticated',
          ),
        );
        return;
      }

      // Decline the invitation via API
      await _invitesRepository.declineInvitation(
        inviteId: event.inviteId,
        userId: user.id,
      );

      // Refresh dashboard data to get updated state
      await _loadDashboardData(user.id, emit);

      // Emit success message
      emit(state.copyWith(successMessage: 'Invitation declined successfully!'));
    } catch (e) {
      emit(
        state.copyWith(
          status: HomeDashboardStatus.error,
          errorMessage: 'Failed to reject invitation: ${e.toString()}',
        ),
      );
    }
  }

  FutureOr<void> _onMarkPaymentCompleted(
    MarkPaymentCompleted event,
    Emitter<HomeDashboardState> emit,
  ) async {
    try {
      // Mark payment as completed via API
      await _paymentsRepository.updatePaymentStatus(
        paymentId: event.paymentId,
        status: 'completed',
        paidAt: DateTime.now().toIso8601String(),
      );

      // Refresh dashboard data to get updated state
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        await _loadDashboardData(user.id, emit);
      }

      // Emit success message
      emit(state.copyWith(successMessage: 'Payment marked as completed!'));
    } catch (e) {
      emit(
        state.copyWith(
          status: HomeDashboardStatus.error,
          errorMessage: 'Failed to mark payment as completed: ${e.toString()}',
        ),
      );
    }
  }

  FutureOr<void> _onLeaveGroupRequested(
    LeaveGroupRequested event,
    Emitter<HomeDashboardState> emit,
  ) async {
    try {
      // Get current user
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        emit(
          state.copyWith(
            status: HomeDashboardStatus.error,
            errorMessage: 'User not authenticated',
          ),
        );
        return;
      }

      // Remove user from group via API
      await _groupsRepository.removeGroupMember(
        groupId: event.groupId,
        memberId: user.id,
      );

      // Refresh dashboard data to get updated state
      await _loadDashboardData(user.id, emit);

      // Emit success message
      emit(state.copyWith(successMessage: 'Successfully left the group!'));
    } catch (e) {
      emit(
        state.copyWith(
          status: HomeDashboardStatus.error,
          errorMessage: 'Failed to leave group: ${e.toString()}',
        ),
      );
    }
  }

  FutureOr<void> _onSuccessMessageCleared(
    HomeDashboardSuccessMessageCleared event,
    Emitter<HomeDashboardState> emit,
  ) {
    emit(state.copyWith(successMessage: null));
  }

  Future<void> _loadDashboardData(
    String userId,
    Emitter<HomeDashboardState> emit,
  ) async {
    try {
      print('HomeDashboardBloc: Loading dashboard data for user: $userId');

      // Single API call to get all dashboard data
      final dashboardDataEntity = await _dashboardRepository.getDashboardData(
        userId,
      );
      print('HomeDashboardBloc: Dashboard data loaded successfully');
      print(
        'HomeDashboardBloc: Groups count: ${dashboardDataEntity.recentGroups.length}',
      );
      print(
        'HomeDashboardBloc: Payments count: ${dashboardDataEntity.recentPayments.length}',
      );
      print(
        'HomeDashboardBloc: Upcoming renewals count: ${dashboardDataEntity.upcomingRenewals.length}',
      );

      // Convert entity to model
      final dashboardDataModel = DashboardDataModel.fromEntity(
        dashboardDataEntity,
      );

      // Use financial data from the dashboard model
      final totalOwed = 0.0; // TODO: Calculate from payments data
      final totalOwing = dashboardDataModel.payments.pendingAmount;

      print(
        'HomeDashboardBloc: Emitting loaded state with ${dashboardDataModel.recentGroups.length} groups, ${dashboardDataModel.recentPayments.length} payments, and ${dashboardDataModel.upcomingRenewals.length} renewals',
      );

      emit(
        state.copyWith(
          status: HomeDashboardStatus.loaded,
          groups: const [], // Empty - UI will use dashboardDataModel directly
          pendingInvites:
              const [], // Empty - UI will use dashboardDataModel directly
          upcomingPayments:
              const [], // Empty - UI will use dashboardDataModel directly
          upcomingRenewals:
              const [], // Empty - UI will use dashboardDataModel directly
          dashboardDataModel: dashboardDataModel,
          totalOwed: totalOwed,
          totalOwing: totalOwing,
          errorMessage: null,
        ),
      );
    } on NetworkFailure catch (e) {
      print('HomeDashboardBloc: Network error: ${e.message}');
      emit(
        state.copyWith(
          status: HomeDashboardStatus.error,
          errorMessage: 'Network error: ${e.message}',
        ),
      );
    } on ServerFailure catch (e) {
      print('HomeDashboardBloc: Server error: ${e.message} (${e.statusCode})');
      emit(
        state.copyWith(
          status: HomeDashboardStatus.error,
          errorMessage: 'Server error: ${e.message}',
        ),
      );
    } on ValidationFailure catch (e) {
      print('HomeDashboardBloc: Validation error: ${e.message}');
      emit(
        state.copyWith(
          status: HomeDashboardStatus.error,
          errorMessage: 'Validation error: ${e.message}',
        ),
      );
    } on UnknownFailure catch (e) {
      print('HomeDashboardBloc: Unknown error: ${e.message}');
      emit(
        state.copyWith(
          status: HomeDashboardStatus.error,
          errorMessage: 'Unknown error: ${e.message}',
        ),
      );
    } catch (e) {
      print('HomeDashboardBloc: Unexpected error: $e');
      print('HomeDashboardBloc: Error type: ${e.runtimeType}');
      emit(
        state.copyWith(
          status: HomeDashboardStatus.error,
          errorMessage: 'Unexpected error: $e',
        ),
      );
    }
  }
}
