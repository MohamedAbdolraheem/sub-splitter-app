import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../app/bloc/app_bloc.dart';
import '../../app/view/on_boarding/splash.dart';
import '../../features/user_features/presentation/login/view/login_page.dart';
import '../../features/user_features/presentation/signup/view/signup_page.dart';
import '../../features/user_features/presentation/profile/view/profile_page.dart';
import '../../features/user_features/presentation/profile_completion/view/profile_completion_page.dart';
import '../../features/spliting_features/presentation/home_dashboard/view/home_dashboard_page.dart';
import '../../features/spliting_features/presentation/create_group/view/create_group_page.dart';
import '../../features/spliting_features/presentation/group_details/view/group_details_page.dart';
import '../../features/spliting_features/presentation/group_settings/view/group_settings_page.dart';
import '../../features/spliting_features/presentation/group_members/view/group_members_page.dart';
import '../../features/spliting_features/presentation/groups/view/groups_page.dart';
import '../../features/user_features/presentation/notifications/notifications.dart';
import 'screens.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static GoRouter router = GoRouter(
    initialLocation: Screens.splash.path,
    navigatorKey: rootNavigatorKey,
    routes: [
      // Splash Screen
      GoRoute(
        name: Screens.splash.name,
        path: Screens.splash.path,
        builder: (context, state) => const SplashScreen(),
      ),

      // Home Dashboard Screen
      GoRoute(
        name: Screens.homeDashboard.name,
        path: Screens.homeDashboard.path,
        builder: (context, state) => const HomeDashboardPage(),
      ),

      // Login Screen
      GoRoute(
        name: Screens.login.name,
        path: Screens.login.path,
        builder: (context, state) => const LoginPage(),
      ),

      // Signup Screen
      GoRoute(
        name: Screens.signup.name,
        path: Screens.signup.path,
        builder: (context, state) => const SignupPage(),
      ),

      // Profile Screen
      GoRoute(
        name: Screens.displayProfile.name,
        path: Screens.displayProfile.path,
        builder: (context, state) => const ProfilePage(),
      ),

      // Profile Completion Screen
      GoRoute(
        name: Screens.createProfile.name,
        path: Screens.createProfile.path,
        builder: (context, state) {
          return const ProfileCompletionPage();
        },
      ),

      // Create Group Screen
      GoRoute(
        name: Screens.createGroup.name,
        path: Screens.createGroup.path,
        builder: (context, state) => const CreateGroupPage(),
      ),

      // Group Details Screen
      GoRoute(
        name: Screens.groupDetails.name,
        path: Screens.groupDetails.path,
        builder: (context, state) {
          final groupId = state.pathParameters['groupId'] ?? '';
          return GroupDetailsPage(groupId: groupId);
        },
      ),

      // Group Settings Screen
      GoRoute(
        name: Screens.groupSettings.name,
        path: Screens.groupSettings.path,
        builder: (context, state) {
          final groupId = state.pathParameters['groupId'] ?? '';
          return GroupSettingsPage(groupId: groupId);
        },
      ),

      // Group Members Screen
      GoRoute(
        name: Screens.groupMembers.name,
        path: Screens.groupMembers.path,
        builder: (context, state) {
          final groupId = state.pathParameters['groupId'] ?? '';
          return GroupMembersPage(groupId: groupId);
        },
      ),

      // Groups Screen
      GoRoute(
        name: Screens.groups.name,
        path: Screens.groups.path,
        builder: (context, state) => const GroupsPage(),
      ),

      // Notifications Screen
      GoRoute(
        name: Screens.notifications.name,
        path: Screens.notifications.path,
        builder: (context, state) => const NotificationsPage(),
      ),
    ],
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isLoginPage = Screens.login.path == state.fullPath;
      final isSignupPage = Screens.signup.path == state.fullPath;
      final isSplashPage = Screens.splash.path == state.fullPath;
      final isProfilePage = Screens.displayProfile.path == state.fullPath;
      final isHomePage = state.fullPath == '/';
      final isCreateGroupPage = Screens.createGroup.path == state.fullPath;
      final isGroupDetailsPage =
          state.fullPath?.startsWith(
            Screens.groupDetails.path.replaceAll(':groupId', ''),
          ) ??
          false;
      final isGroupSettingsPage =
          state.fullPath?.startsWith(
            Screens.groupSettings.path.replaceAll(':groupId', ''),
          ) ??
          false;
      final isGroupMembersPage =
          state.fullPath?.startsWith(
            Screens.groupMembers.path.replaceAll(':groupId', ''),
          ) ??
          false;

      if (isSplashPage) {
        return null;
      }

      try {
        // Check App BLoC auth state
        final appState = context.read<AppBloc>().state;
        final isLoggedIn = appState.isAuthenticated;
        print(
          'Router redirect: isLoggedIn=$isLoggedIn, status=${appState.status}, path=${state.fullPath}',
        );

        // Redirect authenticated users away from auth pages
        if (isLoggedIn && (isLoginPage || isSignupPage)) {
          print('Router: Redirecting authenticated user to home');
          return '/';
        }

        // Redirect unauthenticated users away from protected pages
        if (!isLoggedIn &&
            (isProfilePage ||
                isHomePage ||
                isCreateGroupPage ||
                isGroupDetailsPage ||
                isGroupSettingsPage ||
                isGroupMembersPage)) {
          print('Router: Redirecting unauthenticated user to login');
          return '/login';
        }
      } catch (e) {
        print('Router redirect error: $e');
        // If there's an error reading the app state, redirect to login for safety
        if (isProfilePage ||
            isHomePage ||
            isCreateGroupPage ||
            isGroupDetailsPage ||
            isGroupSettingsPage ||
            isGroupMembersPage) {
          return '/login';
        }
      }

      return null;
    },
  );
}
