import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:subscription_splitter_app/core/notifications/models/notification_model.dart';
import 'package:subscription_splitter_app/core/router/screens.dart';
import 'package:subscription_splitter_app/core/di/service_locator.dart';

/// {@template notification_handler}
/// Handles notification actions and navigation
/// {@endtemplate}
class NotificationHandler {
  static final NotificationHandler _instance = NotificationHandler._internal();
  factory NotificationHandler() => _instance;
  NotificationHandler._internal();

  /// Handle notification tap/action
  static void handleNotificationAction(
    BuildContext context,
    NotificationModel notification,
  ) {
    // Check if context is still valid before proceeding
    if (!context.mounted) {
      debugPrint(
        'NotificationHandler: Context is no longer valid, ignoring action',
      );
      return;
    }

    debugPrint(
      'NotificationHandler: Handling notification action - ${notification.type.displayName}',
    );

    switch (notification.actionType) {
      case NotificationActionType.openGroup:
        _handleOpenGroup(context, notification);
        break;
      case NotificationActionType.openPayment:
        _handleOpenPayment(context, notification);
        break;
      case NotificationActionType.openSettings:
        _handleOpenSettings(context, notification);
        break;
      case NotificationActionType.openProfile:
        _handleOpenProfile(context, notification);
        break;
      case NotificationActionType.openInvitation:
        _handleOpenInvitation(context, notification);
        break;
      case NotificationActionType.openMessage:
        _handleOpenMessage(context, notification);
        break;
      case NotificationActionType.openApp:
        _handleOpenApp(context, notification);
        break;
      case null:
        _handleDefaultAction(context, notification);
        break;
    }
  }

  /// Handle opening a group
  static void _handleOpenGroup(
    BuildContext context,
    NotificationModel notification,
  ) {
    if (!context.mounted) return;

    if (notification.groupId != null) {
      final path = Screens.groupDetails.path.replaceAll(
        ':groupId',
        notification.groupId!,
      );
      context.push(path);
    } else {
      _showErrorSnackBar(context, 'Group not found');
    }
  }

  /// Handle opening payment details
  static void _handleOpenPayment(
    BuildContext context,
    NotificationModel notification,
  ) {
    if (!context.mounted) return;

    if (notification.groupId != null) {
      // Navigate to group details and show payment section
      final path = Screens.groupDetails.path.replaceAll(
        ':groupId',
        notification.groupId!,
      );
      context.push(path);

      // Show payment details after navigation
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          _showPaymentDetails(context, notification);
        }
      });
    } else {
      _showErrorSnackBar(context, 'Payment details not found');
    }
  }

  /// Handle opening settings
  static void _handleOpenSettings(
    BuildContext context,
    NotificationModel notification,
  ) {
    if (!context.mounted) return;

    if (notification.groupId != null) {
      final path = Screens.groupSettings.path.replaceAll(
        ':groupId',
        notification.groupId!,
      );
      context.push(path);
    } else {
      context.push(Screens.settings.path);
    }
  }

  /// Handle opening profile
  static void _handleOpenProfile(
    BuildContext context,
    NotificationModel notification,
  ) {
    if (!context.mounted) return;

    final userId = notification.actionData['userId'] as String?;
    if (userId != null) {
      // Navigate to user profile
      context.push('/profile/$userId');
    } else {
      // Navigate to settings as fallback
      context.push(Screens.settings.path);
    }
  }

  /// Handle opening invitation
  static void _handleOpenInvitation(
    BuildContext context,
    NotificationModel notification,
  ) {
    if (!context.mounted) return;

    if (notification.groupId != null) {
      // Show invitation dialog or navigate to invitation screen
      _showInvitationDialog(context, notification);
    } else {
      _showErrorSnackBar(context, 'Invitation not found');
    }
  }

  /// Handle opening message
  static void _handleOpenMessage(
    BuildContext context,
    NotificationModel notification,
  ) {
    if (!context.mounted) return;

    if (notification.groupId != null) {
      // Navigate to group messages
      final path = Screens.groupDetails.path.replaceAll(
        ':groupId',
        notification.groupId!,
      );
      context.push(path);

      // Show message section after navigation
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          _showMessageSection(context, notification);
        }
      });
    } else {
      _showErrorSnackBar(context, 'Message not found');
    }
  }

  /// Handle opening app (default action)
  static void _handleOpenApp(
    BuildContext context,
    NotificationModel notification,
  ) {
    if (!context.mounted) return;

    // Navigate to home or relevant screen based on notification type
    switch (notification.type) {
      case NotificationType.appUpdate:
        context.push(Screens.settings.path);
        break;
      case NotificationType.serviceOutage:
        context.push(Screens.homeDashboard.path);
        break;
      default:
        context.push(Screens.homeDashboard.path);
    }
  }

  /// Handle default action when no specific action is defined
  static void _handleDefaultAction(
    BuildContext context,
    NotificationModel notification,
  ) {
    if (!context.mounted) return;

    // Default behavior based on notification type
    switch (notification.type) {
      case NotificationType.paymentReminder:
      case NotificationType.paymentConfirm:
      case NotificationType.paymentOverdue:
      case NotificationType.paymentConfirmation:
        _handleOpenPayment(context, notification);
        break;
      case NotificationType.memberJoined:
      case NotificationType.newMemberJoined:
      case NotificationType.memberLeft:
      case NotificationType.groupInvite:
      case NotificationType.groupInvitation:
        _handleOpenGroup(context, notification);
        break;
      case NotificationType.renewalReminder:
      case NotificationType.upcomingRenewal:
      case NotificationType.renewalSuccessful:
      case NotificationType.renewalFailed:
        _handleOpenGroup(context, notification);
        break;
      case NotificationType.adminMessage:
      case NotificationType.groupHealthAlert:
      case NotificationType.lowGroupActivity:
        _handleOpenGroup(context, notification);
        break;
      case NotificationType.groupMessage:
      case NotificationType.memberMention:
        _handleOpenMessage(context, notification);
        break;
      case NotificationType.achievement:
      case NotificationType.savingsMilestone:
      case NotificationType.groupMilestone:
        _handleOpenGroup(context, notification);
        break;
      case NotificationType.system:
      case NotificationType.appUpdate:
      case NotificationType.serviceOutage:
        _handleOpenApp(context, notification);
        break;
    }
  }

  /// Show payment details dialog
  static void _showPaymentDetails(
    BuildContext context,
    NotificationModel notification,
  ) {
    if (!context.mounted) return;

    final amount = notification.actionData['amount'] as double?;
    final dueDate = notification.actionData['dueDate'] as String?;

    if (amount != null && dueDate != null) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Payment Details'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Amount: \$${amount.toStringAsFixed(2)}'),
                  Text(
                    'Due Date: ${DateTime.parse(dueDate).toString().split(' ')[0]}',
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Navigate to payment screen or trigger payment flow
                    if (context.mounted) {
                      _handlePaymentAction(context, notification);
                    }
                  },
                  child: const Text('Pay Now'),
                ),
              ],
            ),
      );
    }
  }

  /// Show invitation dialog
  static void _showInvitationDialog(
    BuildContext context,
    NotificationModel notification,
  ) {
    if (!context.mounted) return;

    final groupId = notification.groupId;
    final inviterName = notification.actionData['inviterName'] as String?;

    if (groupId != null) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Group Invitation'),
              content: Text(
                '$inviterName has invited you to join a group. Would you like to accept?',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Decline group invitation
                    if (context.mounted) {
                      _handleDeclineInvitation(context, notification);
                    }
                  },
                  child: const Text('Decline'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Accept group invitation and open group
                    if (context.mounted) {
                      _handleAcceptInvitation(context, notification);
                    }
                  },
                  child: const Text('Accept'),
                ),
              ],
            ),
      );
    }
  }

  /// Show message section (placeholder)
  static void _showMessageSection(
    BuildContext context,
    NotificationModel notification,
  ) {
    if (!context.mounted) return;

    // Navigate to messages section and highlight relevant message
    try {
      final groupId = notification.groupId;
      if (groupId != null) {
        // Navigate to the group's details page
        context.push('/group-details/$groupId');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Opening group messages...'),
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        // Fallback to general message section
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please navigate to the messages section.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error navigating to message section: $e');
    }
  }

  /// Show error snackbar
  static void _showErrorSnackBar(BuildContext context, String message) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Get notification icon based on type
  static IconData getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.paymentReminder:
      case NotificationType.paymentConfirm:
      case NotificationType.paymentOverdue:
      case NotificationType.paymentConfirmation:
        return Icons.payment;
      case NotificationType.memberJoined:
      case NotificationType.newMemberJoined:
      case NotificationType.memberLeft:
      case NotificationType.groupInvite:
      case NotificationType.groupInvitation:
        return Icons.people;
      case NotificationType.renewalReminder:
      case NotificationType.upcomingRenewal:
      case NotificationType.renewalSuccessful:
      case NotificationType.renewalFailed:
        return Icons.autorenew;
      case NotificationType.adminMessage:
      case NotificationType.groupHealthAlert:
      case NotificationType.lowGroupActivity:
        return Icons.warning;
      case NotificationType.groupMessage:
      case NotificationType.memberMention:
        return Icons.message;
      case NotificationType.achievement:
      case NotificationType.savingsMilestone:
      case NotificationType.groupMilestone:
        return Icons.emoji_events;
      case NotificationType.system:
      case NotificationType.appUpdate:
      case NotificationType.serviceOutage:
        return Icons.settings;
    }
  }

  /// Get notification color based on type
  static Color getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.paymentOverdue:
      case NotificationType.renewalFailed:
      case NotificationType.serviceOutage:
        return Colors.red;
      case NotificationType.paymentReminder:
      case NotificationType.renewalReminder:
      case NotificationType.upcomingRenewal:
      case NotificationType.groupHealthAlert:
        return Colors.orange;
      case NotificationType.paymentConfirm:
      case NotificationType.paymentConfirmation:
      case NotificationType.renewalSuccessful:
      case NotificationType.achievement:
      case NotificationType.savingsMilestone:
      case NotificationType.groupMilestone:
        return Colors.green;
      case NotificationType.memberJoined:
      case NotificationType.newMemberJoined:
      case NotificationType.groupInvite:
      case NotificationType.groupInvitation:
        return Colors.blue;
      case NotificationType.memberLeft:
        return Colors.grey;
      case NotificationType.groupMessage:
      case NotificationType.memberMention:
        return Colors.purple;
      case NotificationType.adminMessage:
      case NotificationType.lowGroupActivity:
        return Colors.amber;
      case NotificationType.system:
      case NotificationType.appUpdate:
        return Colors.indigo;
    }
  }

  /// Handle payment actions
  static void _handlePaymentAction(
    BuildContext context,
    NotificationModel notification,
  ) {
    if (!context.mounted) return;

    try {
      final groupId = notification.groupId;
      if (groupId != null) {
        // Navigate to group payments
        context.push('/group-details/$groupId');

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Opening payment section...'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please check your payments dashboard.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error handling payment action: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error opening payments. Please try again.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  /// Handle invitation acceptance
  static void _handleAcceptInvitation(
    BuildContext context,
    NotificationModel notification,
  ) {
    if (!context.mounted) return;

    try {
      final groupId = notification.groupId;
      final actionData = notification.actionData;
      final groupName = actionData['groupName'] as String?;
      final inviteId = actionData['inviteId'] as String?;

      if (inviteId == null) {
        debugPrint('Error: No inviteId found in notification action data');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid invitation. Please try again.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
        return;
      }

      // Accept the invitation via API
      _acceptInvitationAPI(context, inviteId, groupId, groupName);
    } catch (e) {
      debugPrint('Error accepting invitation: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error joining group. Please try again.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  /// Accept invitation via API call
  static Future<void> _acceptInvitationAPI(
    BuildContext context,
    String inviteId,
    String? groupId,
    String? groupName,
  ) async {
    try {
      // Show loading indicator
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Joining ${groupName ?? 'group'}...'),
            duration: const Duration(seconds: 1),
          ),
        );
      }

      // Get the invites repository and current user from service locator
      final serviceLocator = ServiceLocator();
      final invitesRepository = serviceLocator.invitesRepository;
      final authRepository = serviceLocator.authRepository;

      // Get current user ID
      final currentUser = authRepository.currentUser;
      if (currentUser?.id == null) {
        throw Exception('User not authenticated');
      }

      // Accept the invitation using the correct API endpoint
      final result = await invitesRepository.acceptInvitation(
        inviteId: inviteId,
        userId: currentUser!.id,
      );

      debugPrint('Invitation acceptance result: $result');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully joined ${groupName ?? 'the group'}!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }

      // Navigate to group details or dashboard
      if (groupId != null && context.mounted) {
        // Navigate to the group details page after joining
        context.push('/group-details/$groupId');
      } else if (context.mounted) {
        // Fallback to dashboard
        context.go('/home-dashboard');
      }
    } catch (e) {
      debugPrint('Error accepting invitation via API: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to join group: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  /// Handle invitation decline
  static void _handleDeclineInvitation(
    BuildContext context,
    NotificationModel notification,
  ) {
    if (!context.mounted) return;

    try {
      final actionData = notification.actionData;
      final groupName = actionData['groupName'] as String?;
      final inviteId = actionData['inviteId'] as String?;

      if (inviteId == null) {
        debugPrint('Error: No inviteId found in notification action data');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid invitation. Please try again.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
        return;
      }

      // Decline the invitation via API
      _declineInvitationAPI(context, inviteId, groupName);
    } catch (e) {
      debugPrint('Error declining invitation: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error declining invitation. Please try again.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  /// Decline invitation via API call
  static Future<void> _declineInvitationAPI(
    BuildContext context,
    String inviteId,
    String? groupName,
  ) async {
    try {
      // Show loading indicator
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Declining ${groupName ?? 'group'} invitation...'),
            duration: const Duration(seconds: 1),
          ),
        );
      }

      // Get the invites repository and current user from service locator
      final serviceLocator = ServiceLocator();
      final invitesRepository = serviceLocator.invitesRepository;
      final authRepository = serviceLocator.authRepository;

      // Get current user ID
      final currentUser = authRepository.currentUser;
      if (currentUser?.id == null) {
        throw Exception('User not authenticated');
      }

      // Decline the invitation using the correct API endpoint
      final result = await invitesRepository.declineInvitation(
        inviteId: inviteId,
        userId: currentUser!.id,
      );

      debugPrint('Invitation decline result: $result');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Declined invitation to ${groupName ?? 'the group'}'),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 2),
          ),
        );
      }

      // Navigate back to dashboard
      if (context.mounted) {
        context.go('/home-dashboard');
      }
    } catch (e) {
      debugPrint('Error declining invitation via API: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to decline invitation: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}
