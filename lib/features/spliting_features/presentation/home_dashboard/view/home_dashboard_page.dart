import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:subscription_splitter_app/core/di/service_locator.dart';
import 'package:subscription_splitter_app/core/extensions/translation_extension.dart';
import 'package:subscription_splitter_app/core/widgets/app_drawer.dart';
import 'package:subscription_splitter_app/features/spliting_features/presentation/home_dashboard/bloc/bloc.dart';
import 'package:subscription_splitter_app/features/spliting_features/presentation/home_dashboard/widgets/home_dashboard_body_enhanced.dart';

/// {@template home_dashboard_page}
/// A description for HomeDashboardPage
/// {@endtemplate}
class HomeDashboardPage extends StatelessWidget {
  /// {@macro home_dashboard_page}
  const HomeDashboardPage({super.key});

  /// The static route for HomeDashboardPage
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(
      builder: (_) => const HomeDashboardPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final serviceLocator = ServiceLocator();
    return BlocProvider(
      create:
          (context) =>
              HomeDashboardBloc(
                  dashboardRepository: serviceLocator.dashboardRepository,
                  invitesRepository: serviceLocator.invitesRepository,
                  paymentsRepository: serviceLocator.paymentsRepository,
                  groupsRepository: serviceLocator.groupsRepository,
                )
                ..add(const HomeDashboardInitialized())
                ..add(const HomeDashboardNavigatedTo()),
      child: const HomeDashboardView(),
    );
  }
}

/// {@template home_dashboard_view}
/// Displays the Body of HomeDashboardView
/// {@endtemplate}
class HomeDashboardView extends StatelessWidget {
  /// {@macro home_dashboard_view}
  const HomeDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr.appName),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              context.push('/notifications');
            },
            tooltip: context.tr.notifications,
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: const HomeDashboardBodyEnhanced(),
    );
  }
}
