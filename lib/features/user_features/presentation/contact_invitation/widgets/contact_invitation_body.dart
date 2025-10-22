import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscription_splitter_app/core/contacts/models/contact_model.dart';
import 'package:subscription_splitter_app/core/contacts/models/contact_user_match.dart';

import '../bloc/contact_invitation_bloc.dart';
import 'contact_search_bar.dart';
import 'contact_list.dart';
import 'contact_selection_bottom_bar.dart';
import 'invitation_method_selector.dart';

/// {@template contact_invitation_body}
/// Body widget for contact invitation page
/// {@endtemplate}
class ContactInvitationBody extends StatelessWidget {
  /// {@macro contact_invitation_body}
  const ContactInvitationBody({
    super.key,
    required this.groupId,
    this.groupName,
  });

  final String groupId;
  final String? groupName;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactInvitationBloc, ContactInvitationState>(
      builder: (context, state) {
        if (state is ContactInvitationInitial) {
          return const _InitialView();
        } else if (state is ContactInvitationLoading) {
          return const _LoadingView();
        } else if (state is ContactInvitationPermissionDenied) {
          return const _PermissionDeniedView();
        } else if (state is ContactInvitationLoaded) {
          return _LoadedView(
            state: state,
            groupId: groupId,
            groupName: groupName,
            onSendInvitations:
                () => _showInvitationTypeSelector(context, state),
          );
        } else if (state is ContactInvitationLinkGenerated) {
          return _LinkGeneratedView(state: state);
        } else if (state is ContactInvitationSuccess) {
          return _SuccessView(state: state);
        } else if (state is ContactInvitationError) {
          return _ErrorView(message: state.message);
        }

        return const SizedBox.shrink();
      },
    );
  }

  void _sendAppNotifications(
    BuildContext context,
    List<ContactModel> contacts,
    ContactInvitationBloc bloc,
  ) {
    for (final contact in contacts) {
      bloc.add(
        SendContactInvitation(
          contact: contact,
          groupId: groupId,
          customMessage: null,
          invitationType: ContactInvitationType.appNotification,
        ),
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Notifications sent to ${contacts.length} contact${contacts.length == 1 ? '' : 's'}!',
        ),
      ),
    );
  }

  void _sendEmailInvitations(
    BuildContext context,
    List<ContactModel> contacts,
    ContactInvitationBloc bloc,
  ) {
    final contactsWithEmail =
        contacts.where((contact) => contact.emails.isNotEmpty).toList();

    for (final contact in contactsWithEmail) {
      bloc.add(
        SendContactInvitation(
          contact: contact,
          groupId: groupId,
          customMessage: null,
          invitationType: ContactInvitationType.email,
        ),
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Email invitations sent to ${contactsWithEmail.length} contact${contactsWithEmail.length == 1 ? '' : 's'}!',
        ),
      ),
    );
  }

  void _generateInvitationLink(
    BuildContext context,
    ContactInvitationBloc bloc,
  ) {
    bloc.add(GenerateInvitationLink(groupId: groupId, customMessage: null));
  }

  void _showInvitationTypeSelector(
    BuildContext context,
    ContactInvitationLoaded state,
  ) {
    final appUserContacts =
        state.selectedContacts.where((contact) {
          return contact.isAppUser && contact.appUserId != null;
        }).toList();

    final nonAppUserContacts =
        state.selectedContacts.where((contact) {
          return !contact.isAppUser;
        }).toList();

    final bloc = context.read<ContactInvitationBloc>();
    showModalBottomSheet(
      context: context,
      builder:
          (context) => BlocProvider.value(
            value: bloc,
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Send Invitations',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${state.selectedContacts.length} contact${state.selectedContacts.length == 1 ? '' : 's'} selected',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),

                  // App notifications option (for app users only)
                  if (appUserContacts.isNotEmpty) ...[
                    _buildInvitationOption(
                      context: context,
                      title: 'Send App Notifications',
                      subtitle:
                          '${appUserContacts.length} app user${appUserContacts.length == 1 ? '' : 's'}',
                      icon: Icons.notifications,
                      onTap: () {
                        Navigator.pop(context);
                        _sendAppNotifications(context, appUserContacts, bloc);
                      },
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Email invitations option (for non-app users only)
                  if (nonAppUserContacts.isNotEmpty) ...[
                    _buildInvitationOption(
                      context: context,
                      title: 'Send Email Invitations',
                      subtitle:
                          '${nonAppUserContacts.length} contact${nonAppUserContacts.length == 1 ? '' : 's'} with email',
                      icon: Icons.email,
                      onTap: () {
                        Navigator.pop(context);
                        _sendEmailInvitations(
                          context,
                          nonAppUserContacts,
                          bloc,
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Generate link option
                  _buildInvitationOption(
                    context: context,
                    title: 'Generate Invitation Link',
                    subtitle: 'Create a shareable link',
                    icon: Icons.link,
                    onTap: () {
                      Navigator.pop(context);
                      _generateInvitationLink(context, bloc);
                    },
                  ),

                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildInvitationOption({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).primaryColor),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  Text(
                    subtitle,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}

class _InitialView extends StatelessWidget {
  const _InitialView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.contacts, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Loading contacts...',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Loading contacts...',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _PermissionDeniedView extends StatelessWidget {
  const _PermissionDeniedView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.contacts_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Contact Permission Required',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'We need access to your contacts to help you invite friends to your groups.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<ContactInvitationBloc>().add(
                  const RequestContactPermission(),
                );
              },
              icon: const Icon(Icons.contacts),
              label: const Text('Grant Permission'),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadedView extends StatelessWidget {
  const _LoadedView({
    required this.state,
    required this.groupId,
    this.groupName,
    required this.onSendInvitations,
  });

  final ContactInvitationLoaded state;
  final String groupId;
  final String? groupName;
  final VoidCallback onSendInvitations;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search bar
        ContactSearchBar(
          searchQuery: state.searchQuery,
          onSearchChanged: (query) {
            context.read<ContactInvitationBloc>().add(
              SearchContacts(query: query),
            );
          },
          onClearSearch: () {
            context.read<ContactInvitationBloc>().add(const ClearSearch());
          },
          onFilterChanged: (appUsersOnly) {
            context.read<ContactInvitationBloc>().add(
              FilterAppUsersOnly(appUsersOnly: appUsersOnly),
            );
          },
          appUsersOnly: state.isAppUsersOnly,
          appUsersCount: state.appUsersCount,
          totalContactsCount: state.contacts.length,
        ),

        // Sync status banner
        if (state.syncStatus != null)
          _SyncStatusBanner(syncStatus: state.syncStatus!),

        // Loading overlay
        if (state.isLoading) const LinearProgressIndicator(),

        // Error banner
        if (state.error != null) _ErrorBanner(message: state.error!),

        // Contact list
        Expanded(
          child: ContactList(
            contacts: state.filteredContacts,
            selectedContacts: state.selectedContacts,
            onContactSelected: (contact) {
              context.read<ContactInvitationBloc>().add(
                SelectContact(contact: contact),
              );
            },
            onContactDeselected: (contact) {
              context.read<ContactInvitationBloc>().add(
                DeselectContact(contact: contact),
              );
            },
          ),
        ),

        // Selection bottom bar
        if (state.selectedContacts.isNotEmpty)
          ContactSelectionBottomBar(
            selectedCount: state.selectedContacts.length,
            isSending: state.isSending,
            onSelectAll: () {
              context.read<ContactInvitationBloc>().add(
                const SelectAllContacts(),
              );
            },
            onDeselectAll: () {
              context.read<ContactInvitationBloc>().add(
                const DeselectAllContacts(),
              );
            },
            onSendInvitations: onSendInvitations,
          ),
      ],
    );
  }
}

class _LinkGeneratedView extends StatelessWidget {
  const _LinkGeneratedView({required this.state});

  final ContactInvitationLinkGenerated state;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.link, size: 64, color: Colors.green),
            const SizedBox(height: 16),
            Text(
              'Invitation Link Generated!',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: Colors.green),
            ),
            const SizedBox(height: 8),
            Text(
              state.message,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                children: [
                  const Text(
                    'Invitation Link:',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  SelectableText(
                    state.invitationLink,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Implement share functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Share functionality coming soon!'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.share),
                  label: const Text('Share'),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.close),
                  label: const Text('Done'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SuccessView extends StatelessWidget {
  const _SuccessView({required this.state});

  final ContactInvitationSuccess state;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 64, color: Colors.green),
            const SizedBox(height: 16),
            Text(
              'Invitations Sent!',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: Colors.green),
            ),
            const SizedBox(height: 8),
            Text(
              '${state.sentCount}/${state.totalCount} invitations sent successfully',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.close),
              label: const Text('Done'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: Colors.red),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<ContactInvitationBloc>().add(const LoadContacts());
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SyncStatusBanner extends StatelessWidget {
  const _SyncStatusBanner({required this.syncStatus});

  final ContactSyncStatus syncStatus;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      color: Colors.blue[50],
      child: Row(
        children: [
          Icon(Icons.sync, color: Colors.blue[600], size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Found ${syncStatus.appUsersFound} app users in your contacts',
              style: TextStyle(
                color: Colors.blue[700],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      color: Colors.red[50],
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red[600], size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Colors.red[700],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
