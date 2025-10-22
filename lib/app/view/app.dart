import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/router/app_router.dart';
import '../../core/router/screens.dart';
import '../../core/theme/font_service.dart';
import '../bloc/app_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppBloc>(
          create: (context) => AppBloc()..add(AppStarted()),
        ),
      ],
      child: BlocListener<AppBloc, AppState>(
        listener: (context, state) {
          // Handle authentication state changes
          WidgetsBinding.instance.addPostFrameCallback((_) {
            try {
              if (state.status == AppStatus.unauthenticated) {
                // User signed out, navigate to login
                AppRouter.router.go(Screens.login.path);
              } else if (state.status == AppStatus.authenticated) {
                // User signed in, navigate to home
                AppRouter.router.go(Screens.homeDashboard.path);
              }
            } catch (e) {
              // Handle any context-related errors gracefully
              print('Navigation error: $e');
            }
          });
        },
        child: BlocBuilder<AppBloc, AppState>(
          buildWhen: (previous, current) {
            // Rebuild only when language changes
            return previous.languageCode != current.languageCode;
          },
          builder: (context, state) {
            // Get the appropriate font family for current language
            final fontFamily = FontService.getFontFamilyByLanguage(
              state.languageCode,
            );

            return MaterialApp.router(
              key: ValueKey(
                'app_${state.languageCode}',
              ), // Force rebuild on language change
              title: 'Subscription Splitter',
              theme: _buildTheme(fontFamily, Brightness.light),
              darkTheme: _buildTheme(fontFamily, Brightness.dark),
              themeMode: ThemeMode.system,
              routerConfig: AppRouter.router,
              debugShowCheckedModeBanner: false,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('ar', 'SA'), // Arabic (Saudi Arabia)
                Locale('en', 'US'), // English (United States)
              ],
              locale: Locale(
                state.languageCode,
                state.languageCode == 'ar' ? 'SA' : 'US',
              ),
            );
          },
        ),
      ),
    );
  }

  /// Build theme with language-specific font
  ThemeData _buildTheme(String fontFamily, Brightness brightness) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF6750A4),
        brightness: brightness,
      ),
      fontFamily: fontFamily,
      textTheme: _buildTextTheme(fontFamily),
      appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }

  /// Build text theme with language-specific font
  TextTheme _buildTextTheme(String fontFamily) {
    return TextTheme(
      // Display styles
      displayLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 57,
        fontWeight: FontWeight.w400,
      ),
      displayMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 45,
        fontWeight: FontWeight.w400,
      ),
      displaySmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 36,
        fontWeight: FontWeight.w400,
      ),

      // Headline styles
      headlineLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 32,
        fontWeight: FontWeight.w400,
      ),
      headlineMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 28,
        fontWeight: FontWeight.w400,
      ),
      headlineSmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 24,
        fontWeight: FontWeight.w400,
      ),

      // Title styles
      titleLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 22,
        fontWeight: FontWeight.w500,
      ),
      titleMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      titleSmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),

      // Body styles
      bodyLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),

      // Label styles
      labelLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      labelMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 11,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
