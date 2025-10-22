import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/send_notification_bloc.dart';
import '../view/group_notification_composer.dart';

/// Helper class for showing notification composer from group pages
class NotificationComposerHelper {
  /// Show group notification composer modal
  static void showGroupNotificationComposer(
    BuildContext context, {
    required String groupId,
    String? groupName,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => BlocProvider(
            create: (context) => SendNotificationBloc(groupId: groupId),
            child: GroupNotificationComposer(
              groupId: groupId,
              groupName: groupName,
            ),
          ),
    );
  }

  /// Show group notification composer as full screen dialog
  static void showGroupNotificationComposerFullScreen(
    BuildContext context, {
    required String groupId,
    String? groupName,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => BlocProvider(
              create: (context) => SendNotificationBloc(groupId: groupId),
              child: Scaffold(
                appBar: AppBar(
                  title: Text(
                    'Send Notification${groupName != null ? ' to $groupName' : ''}',
                  ),
                ),
                body: GroupNotificationComposer(
                  groupId: groupId,
                  groupName: groupName,
                ),
              ),
            ),
        fullscreenDialog: true,
      ),
    );
  }
}
