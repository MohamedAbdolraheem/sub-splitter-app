import 'package:flutter/material.dart';
import 'package:subscription_splitter_app/core/notifications/handlers/notification_handler.dart';
import 'package:subscription_splitter_app/core/notifications/models/notification_model.dart';

/// {@template notification_tile}
/// A tile widget for displaying individual notifications
/// {@endtemplate}
class NotificationTile extends StatelessWidget {
  /// {@macro notification_tile}
  const NotificationTile({
    super.key,
    required this.notification,
    this.onTap,
    this.onDismiss,
    this.showActions = false,
  });

  /// The notification to display
  final NotificationModel notification;

  /// Callback when the tile is tapped
  final VoidCallback? onTap;

  /// Callback when the notification is dismissed
  final VoidCallback? onDismiss;

  /// Whether to show action buttons
  final bool showActions;

  @override
  Widget build(BuildContext context) {
    final color = NotificationHandler.getNotificationColor(notification.type);
    final icon = NotificationHandler.getNotificationIcon(notification.type);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: notification.isRead ? 1 : 3,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Notification icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 12),

              // Notification content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and timestamp
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium?.copyWith(
                              fontWeight:
                                  notification.isRead
                                      ? FontWeight.normal
                                      : FontWeight.bold,
                              color:
                                  notification.isRead
                                      ? Colors.grey[600]
                                      : Colors.grey[900],
                            ),
                          ),
                        ),
                        Text(
                          _formatTimestamp(notification.timestamp),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.grey[500]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Body text (use custom text if available)
                    Text(
                      notification.displayText,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color:
                            notification.isRead
                                ? Colors.grey[600]
                                : Colors.grey[700],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textDirection:
                          notification.isArabic
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                    ),

                    // Group name if available
                    if (notification.groupId != null) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Group: ${notification.groupId}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.blue[700], fontSize: 11),
                          textDirection:
                              notification.isArabic
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                        ),
                      ),
                    ],

                    // Action buttons if enabled
                    if (showActions) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          if (notification.actionType != null)
                            TextButton(
                              onPressed: onTap,
                              style: TextButton.styleFrom(
                                foregroundColor: color,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                              ),
                              child: Text(
                                _getActionText(notification.actionType!),
                              ),
                            ),
                          const Spacer(),
                          if (onDismiss != null)
                            IconButton(
                              onPressed: onDismiss,
                              icon: const Icon(Icons.close, size: 18),
                              style: IconButton.styleFrom(
                                foregroundColor: Colors.grey[500],
                                padding: const EdgeInsets.all(4),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // Unread indicator
              if (!notification.isRead)
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Format timestamp for display
  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  /// Get action text based on action type
  String _getActionText(NotificationActionType actionType) {
    switch (actionType) {
      case NotificationActionType.openGroup:
        return 'View Group';
      case NotificationActionType.openPayment:
        return 'View Payment';
      case NotificationActionType.openSettings:
        return 'Open Settings';
      case NotificationActionType.openProfile:
        return 'View Profile';
      case NotificationActionType.openInvitation:
        return 'View Invitation';
      case NotificationActionType.openMessage:
        return 'View Message';
      case NotificationActionType.openApp:
        return 'Open App';
    }
  }
}

/// {@template notification_list}
/// A list widget for displaying multiple notifications
/// {@endtemplate}
class NotificationList extends StatelessWidget {
  /// {@macro notification_list}
  const NotificationList({
    super.key,
    required this.notifications,
    this.onNotificationTap,
    this.onNotificationDismiss,
    this.showActions = false,
    this.emptyWidget,
  });

  /// List of notifications to display
  final List<NotificationModel> notifications;

  /// Callback when a notification is tapped
  final void Function(NotificationModel)? onNotificationTap;

  /// Callback when a notification is dismissed
  final void Function(NotificationModel)? onNotificationDismiss;

  /// Whether to show action buttons
  final bool showActions;

  /// Widget to show when list is empty
  final Widget? emptyWidget;

  @override
  Widget build(BuildContext context) {
    if (notifications.isEmpty) {
      return emptyWidget ?? _buildEmptyState(context);
    }

    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return NotificationTile(
          notification: notification,
          onTap: () => onNotificationTap?.call(notification),
          onDismiss:
              onNotificationDismiss != null
                  ? () => onNotificationDismiss!(notification)
                  : null,
          showActions: showActions,
        );
      },
    );
  }

  /// Build empty state widget
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                Icons.notifications_none,
                size: 48,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No notifications yet',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'You\'ll see notifications about payments, groups, and more here',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
