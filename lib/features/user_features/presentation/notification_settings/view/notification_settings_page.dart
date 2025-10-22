import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/notification_settings_bloc.dart';
import '../widgets/notification_settings_body.dart';

/// {@template notification_settings_page}
/// Main page for managing notification settings using BLoC pattern
/// {@endtemplate}
class NotificationSettingsPage extends StatelessWidget {
  /// {@macro notification_settings_page}
  const NotificationSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              NotificationSettingsBloc()..add(const LoadNotificationSettings()),
      child: const NotificationSettingsView(),
    );
  }
}

class NotificationSettingsView extends StatelessWidget {
  const NotificationSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
        actions: [
          BlocBuilder<NotificationSettingsBloc, NotificationSettingsState>(
            builder: (context, state) {
              if (state is NotificationSettingsLoaded &&
                  state.hasUnsavedChanges) {
                return TextButton(
                  onPressed: () {
                    context.read<NotificationSettingsBloc>().add(
                      const SaveNotificationSettings(),
                    );
                  },
                  child: const Text('Save'),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: const NotificationSettingsBody(),
    );
  }
}
