import 'dart:async';
import 'dart:developer' as console;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:subscription_splitter_app/features/user_features/data/repositories/auth_repositoy_impl.dart';
import 'package:subscription_splitter_app/features/user_features/domain/repositories/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit({AuthRepository? authRepository})
    : _authRepository =
          authRepository ??
          AuthRepositoryImpl(supabase: Supabase.instance.client),
      super(const SignupState());

  final AuthRepository _authRepository;

  /// Update name field
  void updateName(String name) {
    emit(state.copyWith(name: name));
  }

  /// Update email field
  void updateEmail(String email) {
    emit(state.copyWith(email: email));
  }

  /// Update password field
  void updatePassword(String password) {
    emit(state.copyWith(password: password));
  }

  /// Update confirm password field
  void updateConfirmPassword(String confirmPassword) {
    emit(state.copyWith(confirmPassword: confirmPassword));
  }

  /// Toggle password visibility
  void togglePasswordVisibility() {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  /// Toggle confirm password visibility
  void toggleConfirmPasswordVisibility() {
    emit(state.copyWith(obscureConfirmPassword: !state.obscureConfirmPassword));
  }

  /// Sign up with email and password
  Future<void> signupWithEmail(
    String name,
    String email,
    String password,
  ) async {
    emit(state.copyWith(status: SignupStatus.loading, errorMessage: null));

    try {
      final response = await _authRepository.signUp(
        email: email,
        password: password,
        metadata: {'full_name': name},
      );

      if (response.session != null) {
        // User signed up and session created successfully
        emit(state.copyWith(status: SignupStatus.success));
      } else {
        // Signup failed
        emit(
          state.copyWith(
            status: SignupStatus.failure,
            errorMessage: 'Signup failed. Please try again.',
          ),
        );
      }
    } catch (e) {
      // More detailed error logging
      console.log('Signup error: $e');
      String errorMessage = e.toString().replaceFirst('Exception: ', '');

      // Handle common Supabase errors
      if (errorMessage.contains('User already registered')) {
        errorMessage =
            'An account with this email already exists. Please sign in instead.';
      } else if (errorMessage.contains('Invalid email')) {
        errorMessage = 'Please enter a valid email address.';
      } else if (errorMessage.contains('Password')) {
        errorMessage = 'Password must be at least 6 characters long.';
      } else if (errorMessage.contains('network')) {
        errorMessage =
            'Network error. Please check your connection and try again.';
      }

      emit(
        state.copyWith(
          status: SignupStatus.failure,
          errorMessage: errorMessage,
        ),
      );
    }
  }

  /// Sign up with Google
  Future<void> signupWithGoogle() async {
    emit(state.copyWith(status: SignupStatus.loading, errorMessage: null));

    try {
      final success = await _authRepository.signInWithGoogle();
      if (success) {
        // OAuth flow started successfully
        // The actual result will come through auth state changes
        emit(state.copyWith(status: SignupStatus.success));
      } else {
        emit(
          state.copyWith(
            status: SignupStatus.failure,
            errorMessage: 'Google sign-up failed. Please try again.',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: SignupStatus.failure,
          errorMessage: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }
}
