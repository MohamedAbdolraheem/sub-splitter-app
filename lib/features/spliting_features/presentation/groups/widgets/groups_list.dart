import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:subscription_splitter_app/core/theme/app_colors.dart';
import 'package:subscription_splitter_app/features/spliting_features/domain/entities/group.dart';

import 'group_card.dart';

/// {@template groups_list}
/// Widget to display lists of owned and member groups
/// {@endtemplate}
class GroupsList extends StatelessWidget {
  /// {@macro groups_list}
  const GroupsList({
    super.key,
    required this.ownedGroups,
    required this.memberGroups,
    required this.currentUserId,
  });

  final List<Group> ownedGroups;
  final List<Group> memberGroups;
  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Owned Groups Section
          if (ownedGroups.isNotEmpty) ...[
            _buildSectionHeader(
              context,
              'Owned Groups',
              ownedGroups.length,
              Icons.star,
              AppColors.secondary,
            ),
            const SizedBox(height: 12),
            ...ownedGroups.map(
              (group) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GroupCard(
                  group: group,
                  isOwner: true,
                  currentUserId: currentUserId,
                  onTap: () => context.push('/group-details/${group.id}'),
                  onSettings: () => context.push('/group-settings/${group.id}'),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Member Groups Section
          if (memberGroups.isNotEmpty) ...[
            _buildSectionHeader(
              context,
              'Member Groups',
              memberGroups.length,
              Icons.person,
              AppColors.accent,
            ),
            const SizedBox(height: 12),
            ...memberGroups.map(
              (group) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GroupCard(
                  group: group,
                  isOwner: false,
                  currentUserId: currentUserId,
                  onTap: () => context.push('/group-details/${group.id}'),
                  onLeave: () => _showLeaveGroupDialog(context, group),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Empty state if no groups
          if (ownedGroups.isEmpty && memberGroups.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(
                      Icons.group_outlined,
                      size: 64,
                      color: AppColors.textTertiary,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No groups yet',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Create or join a group to get started',
                      style: TextStyle(color: AppColors.textTertiary),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    int count,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$count',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  void _showLeaveGroupDialog(BuildContext context, Group group) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Leave Group'),
            content: Text(
              'Are you sure you want to leave "${group.name}"? You will lose access to this group and any shared subscriptions.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // TODO: Implement leave group functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Leave group functionality not implemented yet',
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Leave'),
              ),
            ],
          ),
    );
  }
}
