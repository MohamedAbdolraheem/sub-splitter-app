part of 'profile_cubit.dart';

enum ProfileStatus { initial, loading, loaded, error }

/// {@template profile_state}
/// ProfileState description
/// {@endtemplate}
class ProfileState extends Equatable {
  /// {@macro profile_state}
  const ProfileState({
    this.status = ProfileStatus.initial,
    this.user,
    this.name = '',
    this.email = '',
    this.mobileNumber = '',
    this.dateOfBirth,
    this.gender,
    this.location = '',
    this.bio = '',
    this.avatarUrl,
    this.isProfileComplete = false,
    this.errorMessage,
  });

  /// Profile loading status
  final ProfileStatus status;

  /// Current user data
  final User? user;

  /// User's display name
  final String name;

  /// User's email
  final String email;

  /// User's mobile number
  final String mobileNumber;

  /// User's date of birth
  final DateTime? dateOfBirth;

  /// User's gender
  final String? gender;

  /// User's location
  final String location;

  /// User's bio/description
  final String bio;

  /// User's avatar URL
  final String? avatarUrl;

  /// Whether profile is complete
  final bool isProfileComplete;

  /// Error message if profile operations fail
  final String? errorMessage;

  @override
  List<Object?> get props => [
    status,
    user,
    name,
    email,
    mobileNumber,
    dateOfBirth,
    gender,
    location,
    bio,
    avatarUrl,
    isProfileComplete,
    errorMessage,
  ];

  /// Creates a copy of the current ProfileState with property changes
  ProfileState copyWith({
    ProfileStatus? status,
    User? user,
    String? name,
    String? email,
    String? mobileNumber,
    DateTime? dateOfBirth,
    String? gender,
    String? location,
    String? bio,
    String? avatarUrl,
    bool? isProfileComplete,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      user: user ?? this.user,
      name: name ?? this.name,
      email: email ?? this.email,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      location: location ?? this.location,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
