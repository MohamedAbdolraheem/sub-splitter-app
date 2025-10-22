import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/notifications_bloc.dart';
import '../widgets/widgets.dart';

/// {@template notifications_page}
/// Main page for viewing and managing notifications using BLoC pattern
/// {@endtemplate}
class NotificationsPage extends StatelessWidget {
  /// {@macro notifications_page}
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationsBloc()..add(const LoadNotifications()),
      child: const NotificationsView(),
    );
  }
}

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NotificationsAppBar(),
      body: const NotificationsBody(),
    );
  }
}
