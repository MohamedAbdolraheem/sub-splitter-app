import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/send_notification_bloc.dart';

/// {@template user_selection}
/// Widget for selecting users to send notifications to
/// {@endtemplate}
class UserSelection extends StatelessWidget {
  /// {@macro user_selection}
  const UserSelection({
    super.key,
    required this.sendToAll,
    required this.onSendToAllChanged,
  });

  final bool sendToAll;
  final ValueChanged<bool> onSendToAllChanged;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SendNotificationBloc, SendNotificationState>(
      builder: (context, state) {
        if (state is SendNotificationLoading) {
          return _buildLoadingCard();
        }

        if (state is SendNotificationError) {
          return _buildErrorCard(state.message);
        }

        if (state is SendNotificationLoaded) {
          return _buildUserSelectionCard(context, state);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildLoadingCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'Loading group members...',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorCard(String message) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(Icons.error_outline, color: Colors.red[600], size: 48),
            const SizedBox(height: 16),
            Text(
              'Failed to load group members',
              style: TextStyle(
                color: Colors.red[600],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserSelectionCard(
    BuildContext context,
    SendNotificationLoaded state,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.people, color: Colors.orange[600]),
                const SizedBox(width: 8),
                Text(
                  'Select Recipients',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (!sendToAll)
                  Text(
                    '${state.selectedUserIds.length}/${state.groupMembers.length} selected',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (sendToAll)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.blue[600]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Sending to all ${state.groupMembers.length} group members',
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView.builder(
                  itemCount: state.groupMembers.length,
                  itemBuilder: (context, index) {
                    final member = state.groupMembers[index];
                    final isSelected = state.selectedUserIds.contains(
                      member.id,
                    );

                    return CheckboxListTile(
                      title: Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor:
                                member.isOnline ? Colors.green : Colors.grey,
                            child: Text(
                              member.name.isNotEmpty
                                  ? member.name[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  member.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  member.email,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (member.isOnline)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      value: isSelected,
                      onChanged: (value) {
                        final newSelection = List<String>.from(
                          state.selectedUserIds,
                        );
                        if (value == true) {
                          newSelection.add(member.id);
                        } else {
                          newSelection.remove(member.id);
                        }

                        context.read<SendNotificationBloc>().add(
                          UpdateSelectedUsers(userIds: newSelection),
                        );
                      },
                      activeColor: Colors.blue[600],
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
