import 'package:flutter/material.dart';

/// {@template contact_selection_bottom_bar}
/// Bottom bar for contact selection actions
/// {@endtemplate}
class ContactSelectionBottomBar extends StatelessWidget {
  /// {@macro contact_selection_bottom_bar}
  const ContactSelectionBottomBar({
    super.key,
    required this.selectedCount,
    required this.isSending,
    required this.onSelectAll,
    required this.onDeselectAll,
    required this.onSendInvitations,
  });

  final int selectedCount;
  final bool isSending;
  final VoidCallback onSelectAll;
  final VoidCallback onDeselectAll;
  final VoidCallback onSendInvitations;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Selection info
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$selectedCount contact${selectedCount == 1 ? '' : 's'} selected',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Tap to send invitations',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            // Action buttons
            Row(
              children: [
                // Select all / Deselect all button
                TextButton(
                  onPressed: isSending ? null : onDeselectAll,
                  child: const Text('Clear'),
                ),

                const SizedBox(width: 8),

                // Send invitations button
                ElevatedButton.icon(
                  onPressed: isSending ? null : onSendInvitations,
                  icon:
                      isSending
                          ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : const Icon(Icons.send, size: 18),
                  label: Text(isSending ? 'Sending...' : 'Send Invitations'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
