import 'package:flutter/material.dart';

import 'package:subscription_splitter_app/core/contacts/models/contact_model.dart';
import 'contact_tile.dart';

/// {@template contact_list}
/// List of contacts with selection functionality
/// {@endtemplate}
class ContactList extends StatelessWidget {
  /// {@macro contact_list}
  const ContactList({
    super.key,
    required this.contacts,
    required this.selectedContacts,
    required this.onContactSelected,
    required this.onContactDeselected,
  });

  final List<ContactModel> contacts;
  final List<ContactModel> selectedContacts;
  final ValueChanged<ContactModel> onContactSelected;
  final ValueChanged<ContactModel> onContactDeselected;

  @override
  Widget build(BuildContext context) {
    if (contacts.isEmpty) {
      return const _EmptyState();
    }

    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        final contact = contacts[index];
        final isSelected = selectedContacts.contains(contact);

        return ContactTile(
          contact: contact,
          isSelected: isSelected,
          onTap: () {
            if (isSelected) {
              onContactDeselected(contact);
            } else {
              onContactSelected(contact);
            }
          },
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.contacts_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No Contacts Found',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'No contacts match your search criteria',
              style: TextStyle(color: Colors.grey[500], fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
