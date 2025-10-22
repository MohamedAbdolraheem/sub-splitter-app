import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:subscription_splitter_app/features/user_features/data/repositories/auth_repositoy_impl.dart';
import 'package:subscription_splitter_app/features/user_features/domain/repositories/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({AuthRepository? authRepository})
    : _authRepository =
          authRepository ??
          AuthRepositoryImpl(supabase: Supabase.instance.client),
      super(const LoginState());

  final AuthRepository _authRepository;

  /// Update email field
  void updateEmail(String email) {
    emit(state.copyWith(email: email));
  }

  /// Update password field
  void updatePassword(String password) {
    emit(state.copyWith(password: password));
  }

  /// Toggle password visibility
  void togglePasswordVisibility() {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  /// Login with email and password
  Future<void> loginWithEmail(String email, String password) async {
    print('LoginCubit: Starting login with email: $email');
    emit(state.copyWith(status: LoginStatus.loading, errorMessage: null));

    try {
      // Attempt login directly - let Supabase handle connectivity
      print('LoginCubit: Attempting login with email: $email');
      final response = await _authRepository.signIn(
        email: email,
        password: password,
      );

      print('LoginCubit: Sign in response: ${response.session?.user.id}');
      if (response.session != null) {
        print('LoginCubit: Login successful, emitting success state');
        emit(state.copyWith(status: LoginStatus.success));
      } else {
        print('LoginCubit: Login failed - no session');
        emit(
          state.copyWith(
            status: LoginStatus.failure,
            errorMessage: 'Login failed. Please try again.',
          ),
        );
      }
    } catch (e) {
      print('LoginCubit: Login error: $e');
      print('LoginCubit: Error type: ${e.runtimeType}');

      String errorMessage = 'Login failed. Please try again.';

      if (e.toString().contains('Invalid login credentials')) {
        errorMessage = 'Invalid email or password. Please try again.';
      } else if (e.toString().contains('Email not confirmed')) {
        errorMessage = 'Please check your email and confirm your account.';
      } else if (e.toString().contains('SocketException') ||
          e.toString().contains('Connection refused') ||
          e.toString().contains('Network is unreachable') ||
          e.toString().contains('Failed host lookup')) {
        errorMessage =
            'Unable to connect. Please check your internet connection and try again.';
      } else if (e.toString().contains('TimeoutException')) {
        errorMessage = 'Connection timeout. Please try again.';
      } else {
        errorMessage = e.toString().replaceFirst('Exception: ', '');
      }

      emit(
        state.copyWith(status: LoginStatus.failure, errorMessage: errorMessage),
      );
    }
  }

  /// Login with Google
  Future<void> loginWithGoogle() async {
    emit(state.copyWith(status: LoginStatus.loading, errorMessage: null));

    try {
      final success = await _authRepository.signInWithGoogle();
      if (success) {
        // OAuth flow started successfully
        // Don't emit success immediately - wait for the actual callback
        // The success state will be handled when the user returns to the app

        // Start listening for auth state changes immediately
        _listenForAuthStateChanges();

        // Keep loading state until OAuth completes
        // The listener will handle the success/failure
      } else {
        emit(
          state.copyWith(
            status: LoginStatus.failure,
            errorMessage: 'Google sign-in failed. Please try again.',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: LoginStatus.failure,
          errorMessage: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  /// Listen for auth state changes (for OAuth)
  void _listenForAuthStateChanges() {
    _authRepository.authStateChanges.listen((authState) {
      if (authState.event == AuthChangeEvent.signedIn &&
          authState.session != null) {
        emit(state.copyWith(status: LoginStatus.success));
      } else if (authState.event == AuthChangeEvent.signedOut) {
        emit(
          state.copyWith(
            status: LoginStatus.failure,
            errorMessage: 'Authentication failed. Please try again.',
          ),
        );
      }
    });
  }
}
