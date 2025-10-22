part of 'app_bloc.dart';

enum AppStatus { initial, initialized, authenticated, unauthenticated, error }

class AppState extends Equatable {
  final AppStatus status;
  final ThemeMode themeMode;
  final String languageCode;
  final User? user;
  final Session? session;
  final String? errorMessage;

  const AppState({
    this.status = AppStatus.initial,
    this.themeMode = ThemeMode.system,
    this.languageCode = 'ar',
    this.user,
    this.session,
    this.errorMessage,
  });

  AppState copyWith({
    AppStatus? status,
    ThemeMode? themeMode,
    String? languageCode,
    User? user,
    Session? session,
    String? errorMessage,
  }) {
    return AppState(
      status: status ?? this.status,
      themeMode: themeMode ?? this.themeMode,
      languageCode: languageCode ?? this.languageCode,
      user: user ?? this.user,
      session: session ?? this.session,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get isAuthenticated =>
      status == AppStatus.authenticated && session != null;

  bool get isArabic => languageCode == 'ar';
  bool get isEnglish => languageCode == 'en';

  @override
  List<Object?> get props => [
    status,
    themeMode,
    languageCode,
    user,
    session,
    errorMessage,
  ];
}
