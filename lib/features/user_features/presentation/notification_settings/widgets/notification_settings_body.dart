import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/notification_settings_bloc.dart';
import 'notification_settings_cards.dart';

/// {@template notification_settings_body}
/// Body widget for notification settings page that handles all UI logic
/// {@endtemplate}
class NotificationSettingsBody extends StatelessWidget {
  /// {@macro notification_settings_body}
  const NotificationSettingsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationSettingsBloc, NotificationSettingsState>(
      listener: (context, state) {
        if (state is NotificationSettingsLoaded && state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!), backgroundColor: Colors.red),
          );
        } else if (state is NotificationSettingsLoaded &&
            state.hasUnsavedChanges == false &&
            state.isSaving == false) {
          // Settings saved successfully
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Notification preferences saved'),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is NotificationSettingsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is NotificationSettingsError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Error loading settings',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  state.message,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<NotificationSettingsBloc>().add(
                      const LoadNotificationSettings(),
                    );
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is NotificationSettingsLoaded) {
          return NotificationSettingsCards(preferences: state.preferences);
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
