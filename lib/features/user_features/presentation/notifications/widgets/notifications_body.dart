import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:subscription_splitter_app/core/notifications/handlers/notification_handler.dart';
import 'package:subscription_splitter_app/core/notifications/widgets/notification_tile.dart';
import 'package:subscription_splitter_app/core/router/screens.dart';
import '../bloc/notifications_bloc.dart';

/// {@template notifications_body}
/// Body widget for notifications page that handles all UI logic
/// {@endtemplate}
class NotificationsBody extends StatelessWidget {
  /// {@macro notifications_body}
  const NotificationsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationsBloc, NotificationsState>(
      listener: (context, state) {
        if (state is NotificationsLoaded && state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            _buildFilterChips(context, state),
            Expanded(child: _buildBody(context, state)),
          ],
        );
      },
    );
  }

  Widget _buildFilterChips(BuildContext context, NotificationsState state) {
    String selectedFilter = 'all';
    if (state is NotificationsLoaded) {
      selectedFilter = state.selectedFilter;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip(context, 'All', 'all', selectedFilter),
            const SizedBox(width: 8),
            _buildFilterChip(context, 'Unread', 'unread', selectedFilter),
            const SizedBox(width: 8),
            _buildFilterChip(context, 'Payments', 'payments', selectedFilter),
            const SizedBox(width: 8),
            _buildFilterChip(context, 'Groups', 'groups', selectedFilter),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    String label,
    String value,
    String selectedFilter,
  ) {
    final isSelected = selectedFilter == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          context.read<NotificationsBloc>().add(
            FilterNotifications(filterType: value),
          );
        }
      },
      selectedColor: Colors.blue[100],
      checkmarkColor: Colors.blue[700],
    );
  }

  Widget _buildBody(BuildContext context, NotificationsState state) {
    if (state is NotificationsLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is NotificationsError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Error loading notifications',
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
                context.read<NotificationsBloc>().add(
                  const LoadNotifications(),
                );
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state is NotificationsLoaded) {
      return _buildNotificationsList(context, state);
    }

    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildNotificationsList(
    BuildContext context,
    NotificationsLoaded state,
  ) {
    final notifications = state.filteredNotifications;

    if (notifications.isEmpty) {
      return _buildEmptyState(context, state.selectedFilter);
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<NotificationsBloc>().add(const RefreshNotifications());
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: NotificationTile(
              notification: notification,
              onTap: () => _handleNotificationTap(context, notification),
              onDismiss:
                  () => _handleNotificationDismiss(context, notification),
              showActions: true,
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String selectedFilter) {
    String title, subtitle;

    switch (selectedFilter) {
      case 'unread':
        title = 'No unread notifications';
        subtitle = 'You\'re all caught up!';
        break;
      case 'payments':
        title = 'No payment notifications';
        subtitle = 'Payment-related notifications will appear here';
        break;
      case 'groups':
        title = 'No group notifications';
        subtitle = 'Group-related notifications will appear here';
        break;
      default:
        title = 'No notifications yet';
        subtitle =
            'You\'ll see notifications about payments, groups, and more here';
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_none,
              size: 64,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _composeNotification(context),
            icon: const Icon(Icons.add),
            label: const Text('Compose Notification'),
          ),
        ],
      ),
    );
  }

  void _handleNotificationTap(BuildContext context, notification) {
    context.read<NotificationsBloc>().add(
      MarkNotificationAsRead(notificationId: notification.id),
    );

    // Use the NotificationHandler for proper navigation
    NotificationHandler.handleNotificationAction(context, notification);
  }

  void _handleNotificationDismiss(BuildContext context, notification) {
    context.read<NotificationsBloc>().add(
      DeleteNotification(notificationId: notification.id),
    );
  }

  void _composeNotification(BuildContext context) {
    // Redirect to groups page where users can send notifications from group context
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(Screens.homeDashboard.path, (route) => false);
  }
}
