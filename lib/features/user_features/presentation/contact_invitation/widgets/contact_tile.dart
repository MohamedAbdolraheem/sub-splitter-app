import 'package:flutter/material.dart';

import 'package:subscription_splitter_app/core/contacts/models/contact_model.dart';

/// {@template contact_tile}
/// Individual contact tile with selection functionality
/// {@endtemplate}
class ContactTile extends StatelessWidget {
  /// {@macro contact_tile}
  const ContactTile({
    super.key,
    required this.contact,
    required this.isSelected,
    required this.onTap,
  });

  final ContactModel contact;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue[50] : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? Colors.blue[300]! : Colors.grey[200]!,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: _buildAvatar(),
        title: _buildTitle(),
        subtitle: _buildSubtitle(),
        trailing: _buildTrailing(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  Widget _buildAvatar() {
    return Stack(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: _getAvatarColor(),
          backgroundImage:
              contact.avatar != null ? NetworkImage(contact.avatar!) : null,
          child:
              contact.avatar == null
                  ? Text(
                    contact.displayName.isNotEmpty
                        ? contact.displayName[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  )
                  : null,
        ),
        if (contact.isAppUser)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 10),
            ),
          ),
      ],
    );
  }

  Widget _buildTitle() {
    return Row(
      children: [
        Expanded(
          child: Text(
            contact.displayName,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: isSelected ? Colors.blue[800] : Colors.grey[800],
            ),
          ),
        ),
        if (contact.isAppUser)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'App User',
              style: TextStyle(
                color: Colors.green[700],
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSubtitle() {
    final primaryPhone = contact.primaryPhoneNumber;
    final primaryEmail = contact.primaryEmail;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (primaryPhone != null)
          Row(
            children: [
              Icon(Icons.phone, size: 14, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  primaryPhone,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ),
            ],
          ),
        if (primaryEmail != null)
          Row(
            children: [
              Icon(Icons.email, size: 14, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  primaryEmail,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ),
            ],
          ),
        if (primaryPhone == null && primaryEmail == null)
          Text(
            'No contact information',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
          ),
      ],
    );
  }

  Widget _buildTrailing() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Contact type indicator
        if (contact.isAppUser)
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(Icons.people, size: 16, color: Colors.green[700]),
          )
        else
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.orange[100],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(Icons.person_add, size: 16, color: Colors.orange[700]),
          ),

        const SizedBox(width: 8),

        // Selection indicator
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? Colors.blue[600]! : Colors.grey[400]!,
              width: 2,
            ),
            color: isSelected ? Colors.blue[600] : Colors.transparent,
          ),
          child:
              isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
        ),
      ],
    );
  }

  Color _getAvatarColor() {
    if (contact.isAppUser) {
      return Colors.green[400]!;
    }

    // Generate color based on name
    final colors = [
      Colors.blue[400]!,
      Colors.purple[400]!,
      Colors.orange[400]!,
      Colors.teal[400]!,
      Colors.pink[400]!,
      Colors.indigo[400]!,
    ];

    final index = contact.displayName.hashCode % colors.length;
    return colors[index.abs()];
  }
}
