import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/contact_invitation_bloc.dart';
import '../widgets/contact_invitation_body.dart';

/// {@template contact_invitation_page}
/// Page for inviting contacts to groups
/// {@endtemplate}
class ContactInvitationPage extends StatelessWidget {
  /// {@macro contact_invitation_page}
  const ContactInvitationPage({
    super.key,
    required this.groupId,
    this.groupName,
  });

  final String groupId;
  final String? groupName;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              ContactInvitationBloc()..add(const RequestContactPermission()),
      child: ContactInvitationView(groupId: groupId, groupName: groupName),
    );
  }
}

class ContactInvitationView extends StatelessWidget {
  const ContactInvitationView({
    super.key,
    required this.groupId,
    this.groupName,
  });

  final String groupId;
  final String? groupName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invite to ${groupName ?? 'Group'}'),
        actions: [
          IconButton(
            onPressed: () => _showSyncDialog(context),
            icon: const Icon(Icons.sync),
            tooltip: 'Sync Contacts',
          ),
        ],
      ),
      body: BlocListener<ContactInvitationBloc, ContactInvitationState>(
        listener: (context, state) {
          if (state is ContactInvitationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '${state.sentCount}/${state.totalCount} invitations sent successfully',
                ),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop();
          } else if (state is ContactInvitationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: ContactInvitationBody(groupId: groupId, groupName: groupName),
      ),
    );
  }

  void _showSyncDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Sync Contacts'),
            content: const Text(
              'This will sync your contacts with app users to find people who are already using the app.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.read<ContactInvitationBloc>().add(
                    const SyncContactsWithUsers(),
                  );
                },
                child: const Text('Sync'),
              ),
            ],
          ),
    );
  }
}
