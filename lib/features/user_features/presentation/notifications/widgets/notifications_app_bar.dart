import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/router/screens.dart';
import '../../notification_settings/notification_settings.dart';
import '../bloc/notifications_bloc.dart';
import 'clear_all_dialog.dart';

/// {@template notifications_app_bar}
/// Custom app bar for notifications page with actions
/// {@endtemplate}
class NotificationsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  /// {@macro notifications_app_bar}
  const NotificationsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Notifications'),
      actions: [
        IconButton(
          onPressed: () => _refreshNotifications(context),
          icon: const Icon(Icons.refresh),
          tooltip: 'Refresh Notifications',
        ),
        IconButton(
          onPressed: () => _openSettings(context),
          icon: const Icon(Icons.settings),
          tooltip: 'Notification Settings',
        ),
        IconButton(
          onPressed: () => context.push(Screens.homeDashboard.path),
          icon: const Icon(Icons.groups),
          tooltip: 'Go to Groups',
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) => _handleMenuAction(context, value),
          itemBuilder:
              (context) => [
                const PopupMenuItem(
                  value: 'mark_all_read',
                  child: Text('Mark All as Read'),
                ),
                const PopupMenuItem(
                  value: 'clear_all',
                  child: Text('Clear All'),
                ),
                const PopupMenuItem(
                  value: 'send_test',
                  child: Text('Send Test'),
                ),
                const PopupMenuItem(
                  value: 'test_local',
                  child: Text('Test Local Notification'),
                ),
                const PopupMenuItem(
                  value: 'test_direct',
                  child: Text('Test Direct Notification'),
                ),
              ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  void _handleMenuAction(BuildContext context, String action) {
    switch (action) {
      case 'mark_all_read':
        context.read<NotificationsBloc>().add(const MarkAllAsRead());
        break;
      case 'clear_all':
        _showClearAllDialog(context);
        break;
      case 'send_test':
        context.read<NotificationsBloc>().add(const SendTestNotification());
        break;
      case 'test_local':
        _testLocalNotification(context);
        break;
      case 'test_direct':
        _testDirectNotification(context);
        break;
    }
  }

  void _showClearAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => ClearAllDialog(
            onConfirm: () {
              context.read<NotificationsBloc>().add(
                const ClearAllNotifications(),
              );
            },
          ),
    );
  }

  void _refreshNotifications(BuildContext context) {
    context.read<NotificationsBloc>().add(const RefreshNotifications());
  }

  void _openSettings(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const NotificationSettingsPage()),
    );
  }

  void _testLocalNotification(BuildContext context) async {
    try {
      // Simple direct test without NotificationService
      debugPrint('Testing direct local notification...');

      final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      // Initialize with minimal settings
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const DarwinInitializationSettings iosSettings =
          DarwinInitializationSettings();
      const InitializationSettings settings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await flutterLocalNotificationsPlugin.initialize(settings);
      debugPrint('Local notifications plugin initialized');

      // Create notification channel
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'test_channel',
        'Test Notifications',
        description: 'Test notification channel',
        importance: Importance.high,
      );

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(channel);

      debugPrint('Notification channel created');

      // Show notification
      await flutterLocalNotificationsPlugin.show(
        1,
        'Test Notification',
        'This is a direct test notification',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'test_channel',
            'Test Notifications',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
      );

      debugPrint('Direct notification shown');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Direct local notification test sent'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error in direct local notification test: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error testing local notification: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _testDirectNotification(BuildContext context) async {
    try {
      debugPrint(
        'Testing direct notification (bypassing NotificationService)...',
      );

      final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      // Initialize with minimal settings
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const DarwinInitializationSettings iosSettings =
          DarwinInitializationSettings();
      const InitializationSettings settings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      debugPrint('Direct test: Initializing plugin...');
      await flutterLocalNotificationsPlugin.initialize(settings);
      debugPrint('Direct test: Plugin initialized');

      // Create notification channel
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'direct_test_channel',
        'Direct Test Notifications',
        description: 'Direct test notification channel',
        importance: Importance.high,
      );

      debugPrint('Direct test: Creating notification channel...');
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(channel);
      debugPrint('Direct test: Notification channel created');

      // Show notification
      debugPrint('Direct test: Showing notification...');
      await flutterLocalNotificationsPlugin.show(
        999,
        'Direct Test Notification',
        'This is a direct test notification bypassing NotificationService',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'direct_test_channel',
            'Direct Test Notifications',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
      );

      debugPrint('Direct test: Notification shown successfully');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Direct notification test sent'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error in direct notification test: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error in direct test: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}
