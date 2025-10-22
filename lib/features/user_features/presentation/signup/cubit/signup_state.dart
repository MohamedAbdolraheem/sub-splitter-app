part of 'signup_cubit.dart';

enum SignupStatus { initial, loading, success, failure }

/// {@template signup_state}
/// SignupState description
/// {@endtemplate}
class SignupState extends Equatable {
  /// {@macro signup_state}
  const SignupState({
    this.status = SignupStatus.initial,
    this.name = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.obscurePassword = true,
    this.obscureConfirmPassword = true,
    this.errorMessage,
  });

  /// Signup status
  final SignupStatus status;

  /// Name field value
  final String name;

  /// Email field value
  final String email;

  /// Password field value
  final String password;

  /// Confirm password field value
  final String confirmPassword;

  /// Whether password is obscured
  final bool obscurePassword;

  /// Whether confirm password is obscured
  final bool obscureConfirmPassword;

  /// Error message if signup fails
  final String? errorMessage;

  @override
  List<Object?> get props => [
    status,
    name,
    email,
    password,
    confirmPassword,
    obscurePassword,
    obscureConfirmPassword,
    errorMessage,
  ];

  /// Creates a copy of the current SignupState with property changes
  SignupState copyWith({
    SignupStatus? status,
    String? name,
    String? email,
    String? password,
    String? confirmPassword,
    bool? obscurePassword,
    bool? obscureConfirmPassword,
    String? errorMessage,
  }) {
    return SignupState(
      status: status ?? this.status,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscureConfirmPassword:
          obscureConfirmPassword ?? this.obscureConfirmPassword,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
