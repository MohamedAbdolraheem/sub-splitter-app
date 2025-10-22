import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscription_splitter_app/core/contacts/models/contact_model.dart';
import 'package:subscription_splitter_app/core/contacts/models/contact_user_match.dart';

import '../bloc/contact_invitation_bloc.dart';

/// {@template invitation_method_selector}
/// Widget for selecting invitation method and handling the invitation
/// {@endtemplate}
class InvitationMethodSelector extends StatelessWidget {
  /// {@macro invitation_method_selector}
  const InvitationMethodSelector({
    super.key,
    required this.groupId,
    required this.groupName,
    required this.selectedContacts,
    this.customMessage,
    this.onInvitationSent,
    this.bloc,
  });

  final String groupId;
  final String? groupName;
  final List<ContactModel> selectedContacts;
  final String? customMessage;
  final VoidCallback? onInvitationSent;
  final ContactInvitationBloc? bloc;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Invite to ${groupName ?? 'Group'}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Choose how you want to invite people to your group:',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),

          // Share Link Option
          _buildInvitationOption(
            context: context,
            icon: Icons.share,
            title: 'Share Link',
            subtitle: 'Share an invitation link via any app',
            color: Colors.blue,
            onTap: () => _handleShareLink(context),
          ),

          const SizedBox(height: 12),

          // Copy Link Option
          _buildInvitationOption(
            context: context,
            icon: Icons.copy,
            title: 'Copy Link',
            subtitle: 'Copy invitation link to clipboard',
            color: Colors.green,
            onTap: () => _handleCopyLink(context),
          ),

          const SizedBox(height: 12),

          // Email Option (for contacts with email)
          _buildInvitationOption(
            context: context,
            icon: Icons.email,
            title: 'Send Email',
            subtitle: 'Send email invitations to contacts',
            color: Colors.orange,
            onTap: () => _handleEmailInvitations(context),
          ),

          const SizedBox(height: 12),

          // App Notification Option (for app users)
          _buildInvitationOption(
            context: context,
            icon: Icons.notifications,
            title: 'App Notifications',
            subtitle: 'Send in-app notifications to existing users',
            color: Colors.purple,
            onTap: () => _handleAppNotifications(context),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  Widget _buildInvitationOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  void _handleShareLink(BuildContext context) {
    Navigator.of(context).pop();
    // TODO: Implement share functionality
    // This would generate a link and open the system share sheet
    _showComingSoon(context, 'Share Link');
  }

  void _handleCopyLink(BuildContext context) async {
    Navigator.of(context).pop();

    // Generate a simple invitation link (you can make this more sophisticated)
    final invitationLink = 'https://yourapp.com/invite/$groupId';

    await Clipboard.setData(ClipboardData(text: invitationLink));

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invitation link copied to clipboard!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _handleEmailInvitations(BuildContext context) {
    Navigator.of(context).pop();
    // TODO: Implement email invitation functionality
    _showComingSoon(context, 'Email Invitations');
  }

  void _handleAppNotifications(BuildContext context) {
    Navigator.of(context).pop();

    // Filter contacts to only app users (those who have user IDs)
    final appUserContacts =
        selectedContacts.where((contact) {
          return contact.isAppUser && contact.appUserId != null;
        }).toList();

    if (appUserContacts.isEmpty) {
      _showNoAppUsersDialog(context);
      return;
    }

    // Send notifications to app users
    _sendAppNotifications(context, appUserContacts);
  }

  void _showNoAppUsersDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('No App Users Selected'),
            content: const Text(
              'None of the selected contacts are app users. App notifications can only be sent to people who already have the app installed.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  void _sendAppNotifications(
    BuildContext context,
    List<ContactModel> appUserContacts,
  ) {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Send App Notifications'),
            content: Text(
              'Send group invitation notifications to ${appUserContacts.length} app user${appUserContacts.length == 1 ? '' : 's'}?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _confirmSendNotifications(context, appUserContacts);
                },
                child: const Text('Send'),
              ),
            ],
          ),
    );
  }

  void _confirmSendNotifications(
    BuildContext context,
    List<ContactModel> appUserContacts,
  ) {
    // Use the passed bloc or try to read from context
    final blocToUse = bloc ?? context.read<ContactInvitationBloc>();

    // Send invitations via ContactInvitationBloc
    for (final contact in appUserContacts) {
      // Get the app user ID
      final userId = contact.appUserId;
      if (userId == null) {
        throw Exception('No user ID found for contact: ${contact.displayName}');
      }

      blocToUse.add(
        SendContactInvitation(
          contact: contact,
          groupId: groupId,
          customMessage: customMessage,
          invitationType: ContactInvitationType.appNotification,
        ),
      );
    }

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Sending notifications to ${appUserContacts.length} user${appUserContacts.length == 1 ? '' : 's'}...',
        ),
        backgroundColor: Colors.blue,
      ),
    );

    // Call callback if provided
    onInvitationSent?.call();
  }

  void _showComingSoon(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Coming Soon'),
            content: Text('$feature functionality will be available soon!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }
}
