import 'package:flutter/material.dart';

import '../utils/notification_composer_helper.dart';

/// Example of how to integrate the notification composer with a group page
class GroupPageExample extends StatelessWidget {
  const GroupPageExample({
    super.key,
    required this.groupId,
    required this.groupName,
  });

  final String groupId;
  final String groupName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(groupName),
        actions: [
          // Option 1: Send notification button in app bar
          IconButton(
            onPressed: () => _showNotificationComposer(context),
            icon: const Icon(Icons.send),
            tooltip: 'Send Notification',
          ),
        ],
      ),
      body: const Center(child: Text('Group Page Content')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showNotificationComposer(context),
        icon: const Icon(Icons.send),
        label: const Text('Send Notification'),
      ),
    );
  }

  void _showNotificationComposer(BuildContext context) {
    // Show the notification composer modal
    NotificationComposerHelper.showGroupNotificationComposer(
      context,
      groupId: groupId,
      groupName: groupName,
    );
  }
}

/// Alternative: Group page with notification option in a menu
class GroupPageWithMenuExample extends StatelessWidget {
  const GroupPageWithMenuExample({
    super.key,
    required this.groupId,
    required this.groupName,
  });

  final String groupId;
  final String groupName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(groupName),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'send_notification':
                  _showNotificationComposer(context);
                  break;
                case 'other_action':
                  // Handle other actions
                  break;
              }
            },
            itemBuilder:
                (context) => [
                  const PopupMenuItem(
                    value: 'send_notification',
                    child: Row(
                      children: [
                        Icon(Icons.send),
                        SizedBox(width: 8),
                        Text('Send Notification'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'other_action',
                    child: Row(
                      children: [
                        Icon(Icons.settings),
                        SizedBox(width: 8),
                        Text('Group Settings'),
                      ],
                    ),
                  ),
                ],
          ),
        ],
      ),
      body: const Center(child: Text('Group Page Content')),
    );
  }

  void _showNotificationComposer(BuildContext context) {
    NotificationComposerHelper.showGroupNotificationComposer(
      context,
      groupId: groupId,
      groupName: groupName,
    );
  }
}
