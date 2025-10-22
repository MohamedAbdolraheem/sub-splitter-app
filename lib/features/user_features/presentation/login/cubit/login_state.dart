part of 'login_cubit.dart';

enum LoginStatus { initial, loading, success, failure }

/// {@template login_state}
/// LoginState description
/// {@endtemplate}
class LoginState extends Equatable {
  /// {@macro login_state}
  const LoginState({
    this.status = LoginStatus.initial,
    this.email = '',
    this.password = '',
    this.obscurePassword = true,
    this.errorMessage,
  });

  /// Login status
  final LoginStatus status;

  /// Email field value
  final String email;

  /// Password field value
  final String password;

  /// Whether password is obscured
  final bool obscurePassword;

  /// Error message if login fails
  final String? errorMessage;

  @override
  List<Object?> get props => [
    status,
    email,
    password,
    obscurePassword,
    errorMessage,
  ];

  /// Creates a copy of the current LoginState with property changes
  LoginState copyWith({
    LoginStatus? status,
    String? email,
    String? password,
    bool? obscurePassword,
    String? errorMessage,
  }) {
    return LoginState(
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
