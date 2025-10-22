import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/services/language_service.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  late final StreamSubscription<AuthState> _authSubscription;

  AppBloc() : super(const AppState()) {
    on<AppStarted>(_onAppStarted);
    on<AppThemeChanged>(_onAppThemeChanged);
    on<AppLanguageChanged>(_onLanguageChanged);
    on<AppAuthenticationChanged>(_onAuthenticationChanged);
    on<AppLogoutRequested>(_onLogoutRequested);
    on<AppSessionRefreshRequested>(_onSessionRefreshRequested);

    // Start listening to auth changes immediately
    _setupAuthListener();
  }

  void _setupAuthListener() {
    try {
      _authSubscription = Supabase.instance.client.auth.onAuthStateChange.listen((
        data,
      ) {
        print(
          'Auth state changed: ${data.event} - User: ${data.session?.user.id}',
        );
        add(
          AppAuthenticationChanged(
            user: data.session?.user,
            session: data.session,
            event: data.event,
          ),
        );
      });
    } catch (e) {
      print('Error setting up auth listener: $e');
      // Continue without auth listener - this will show login screen
    }
  }

  void _onAppStarted(AppStarted event, Emitter<AppState> emit) async {
    // Load saved language preference
    final savedLanguage = await LanguageService.getLanguage();

    // Try to refresh the session first
    add(const AppSessionRefreshRequested());

    // Check initial auth state
    final supabase = Supabase.instance.client;
    final currentSession = supabase.auth.currentSession;
    final currentUser = supabase.auth.currentUser;

    if (currentSession != null && currentUser != null) {
      emit(
        state.copyWith(
          status: AppStatus.authenticated,
          languageCode: savedLanguage,
          user: currentUser,
          session: currentSession,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: AppStatus.unauthenticated,
          languageCode: savedLanguage,
        ),
      );
    }
  }

  void _onAppThemeChanged(AppThemeChanged event, Emitter<AppState> emit) {
    emit(state.copyWith(themeMode: event.themeMode));
  }

  void _onLanguageChanged(
    AppLanguageChanged event,
    Emitter<AppState> emit,
  ) async {
    // Save language preference
    await LanguageService.setLanguage(event.languageCode);

    // Update state without changing status to avoid navigation reset
    emit(
      state.copyWith(
        languageCode: event.languageCode,
        // Keep the same status to maintain current route
      ),
    );
  }

  void _onAuthenticationChanged(
    AppAuthenticationChanged event,
    Emitter<AppState> emit,
  ) {
    print('AppBloc: Auth state changed - ${event.event}');
    switch (event.event) {
      case AuthChangeEvent.signedIn:
        print('AppBloc: User signed in');
        if (event.session != null && event.user != null) {
          emit(
            state.copyWith(
              status: AppStatus.authenticated,
              user: event.user,
              session: event.session,
              errorMessage: null,
            ),
          );
        }
        break;
      case AuthChangeEvent.signedOut:
        print('AppBloc: User signed out, updating state to unauthenticated');
        emit(
          state.copyWith(
            status: AppStatus.unauthenticated,
            user: null,
            session: null,
            errorMessage: null,
          ),
        );
        break;
      case AuthChangeEvent.tokenRefreshed:
        print('AppBloc: Token refreshed');
        if (event.session != null) {
          emit(state.copyWith(session: event.session, user: event.user));
        }
        break;
      default:
        print('AppBloc: Other auth event: ${event.event}');
        // Handle other auth events if needed
        break;
    }
  }

  void _onLogoutRequested(
    AppLogoutRequested event,
    Emitter<AppState> emit,
  ) async {
    print('AppBloc: Logout requested, calling Supabase signOut...');
    try {
      await Supabase.instance.client.auth.signOut();
      print('AppBloc: Supabase signOut completed');
      // The auth state change will be handled by the listener
    } catch (e) {
      print('AppBloc: Logout error: $e');
      emit(state.copyWith(status: AppStatus.error, errorMessage: e.toString()));
    }
  }

  FutureOr<void> _onSessionRefreshRequested(
    AppSessionRefreshRequested event,
    Emitter<AppState> emit,
  ) async {
    print('AppBloc: Session refresh requested...');
    try {
      final response = await Supabase.instance.client.auth.refreshSession();
      print(
        'AppBloc: Session refreshed successfully: ${response.session?.user.id}',
      );
      // The auth state change will be handled by the listener
    } catch (e) {
      print('AppBloc: Session refresh error: $e');
      // If refresh fails, sign out to clear invalid session
      try {
        await Supabase.instance.client.auth.signOut();
      } catch (signOutError) {
        print('AppBloc: Sign out after refresh failure error: $signOutError');
      }
    }
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }
}
