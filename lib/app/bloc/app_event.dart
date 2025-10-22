part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object?> get props => [];
}

class AppStarted extends AppEvent {
  const AppStarted();
}

class AppThemeChanged extends AppEvent {
  final ThemeMode themeMode;

  const AppThemeChanged(this.themeMode);

  @override
  List<Object?> get props => [themeMode];
}

class AppLanguageChanged extends AppEvent {
  final String languageCode;

  const AppLanguageChanged({required this.languageCode});

  @override
  List<Object?> get props => [languageCode];
}

class AppAuthenticationChanged extends AppEvent {
  final User? user;
  final Session? session;
  final AuthChangeEvent event;

  const AppAuthenticationChanged({
    required this.user,
    required this.session,
    required this.event,
  });

  @override
  List<Object?> get props => [user, session, event];
}

class AppLogoutRequested extends AppEvent {
  const AppLogoutRequested();
}

class AppSessionRefreshRequested extends AppEvent {
  const AppSessionRefreshRequested();
}
