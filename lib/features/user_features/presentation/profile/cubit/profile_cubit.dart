import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:subscription_splitter_app/features/user_features/data/repositories/auth_repositoy_impl.dart';
import 'package:subscription_splitter_app/features/user_features/domain/repositories/auth_repository.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({AuthRepository? authRepository})
    : _authRepository =
          authRepository ??
          AuthRepositoryImpl(supabase: Supabase.instance.client),
      super(const ProfileState());

  final AuthRepository _authRepository;

  /// Load current user profile
  Future<void> loadProfile() async {
    emit(state.copyWith(status: ProfileStatus.loading));

    try {
      final currentUser = _authRepository.currentUser;
      if (currentUser != null) {
        final metadata = currentUser.userMetadata ?? {};
        final isComplete = _checkProfileCompleteness(
          name: metadata['full_name'] ?? metadata['name'] ?? '',
          mobileNumber: metadata['mobile_number'] ?? '',
          dateOfBirth: metadata['date_of_birth'],
          gender: metadata['gender'],
        );

        emit(
          state.copyWith(
            status: ProfileStatus.loaded,
            user: currentUser,
            name: metadata['full_name'] ?? metadata['name'] ?? 'User',
            email: currentUser.email ?? '',
            mobileNumber: metadata['mobile_number'] ?? '',
            dateOfBirth:
                metadata['date_of_birth'] != null
                    ? DateTime.tryParse(metadata['date_of_birth'])
                    : null,
            gender: metadata['gender'],
            location: metadata['location'] ?? '',
            bio: metadata['bio'] ?? '',
            avatarUrl: metadata['avatar_url'],
            isProfileComplete: isComplete,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: ProfileStatus.error,
            errorMessage: 'No user found. Please log in again.',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: ProfileStatus.error,
          errorMessage: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  /// Check if profile is complete
  bool _checkProfileCompleteness({
    required String name,
    required String mobileNumber,
    String? dateOfBirth,
    String? gender,
  }) {
    return name.isNotEmpty &&
        mobileNumber.isNotEmpty &&
        dateOfBirth != null &&
        gender != null;
  }

  /// Update user profile
  Future<void> updateProfile({
    String? name,
    String? mobileNumber,
    DateTime? dateOfBirth,
    String? gender,
    String? location,
    String? bio,
    String? avatarUrl,
  }) async {
    emit(state.copyWith(status: ProfileStatus.loading));

    try {
      final metadata = <String, dynamic>{};
      if (name != null) metadata['full_name'] = name;
      if (mobileNumber != null) metadata['mobile_number'] = mobileNumber;
      if (dateOfBirth != null)
        metadata['date_of_birth'] = dateOfBirth.toIso8601String();
      if (gender != null) metadata['gender'] = gender;
      if (location != null) metadata['location'] = location;
      if (bio != null) metadata['bio'] = bio;
      if (avatarUrl != null) metadata['avatar_url'] = avatarUrl;

      final updatedUser = await _authRepository.updateProfile(
        displayName: name,
        avatarUrl: avatarUrl,
        metadata: metadata,
      );

      // Check if profile is now complete
      final isComplete = _checkProfileCompleteness(
        name: name ?? state.name,
        mobileNumber: mobileNumber ?? state.mobileNumber,
        dateOfBirth:
            dateOfBirth?.toIso8601String() ??
            state.dateOfBirth?.toIso8601String(),
        gender: gender ?? state.gender,
      );

      emit(
        state.copyWith(
          status: ProfileStatus.loaded,
          user: updatedUser,
          name: name ?? state.name,
          mobileNumber: mobileNumber ?? state.mobileNumber,
          dateOfBirth: dateOfBirth ?? state.dateOfBirth,
          gender: gender ?? state.gender,
          location: location ?? state.location,
          bio: bio ?? state.bio,
          avatarUrl: avatarUrl ?? state.avatarUrl,
          isProfileComplete: isComplete,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ProfileStatus.error,
          errorMessage: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  /// Sign out user
  Future<void> signOut() async {
    emit(state.copyWith(status: ProfileStatus.loading));

    try {
      await _authRepository.signOut();
      emit(const ProfileState()); // Reset to initial state
    } catch (e) {
      emit(
        state.copyWith(
          status: ProfileStatus.error,
          errorMessage: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  /// Refresh profile data
  Future<void> refreshProfile() async {
    await loadProfile();
  }
}
