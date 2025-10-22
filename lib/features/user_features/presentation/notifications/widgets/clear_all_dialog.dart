import 'package:flutter/material.dart';

/// {@template clear_all_dialog}
/// Confirmation dialog for clearing all notifications
/// {@endtemplate}
class ClearAllDialog extends StatelessWidget {
  /// {@macro clear_all_dialog}
  const ClearAllDialog({super.key, required this.onConfirm});

  /// Callback when user confirms clearing all notifications
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Clear All Notifications'),
      content: const Text(
        'Are you sure you want to clear all notifications? This action cannot be undone.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Clear All'),
        ),
      ],
    );
  }
}
