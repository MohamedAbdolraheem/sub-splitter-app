import 'package:flutter/material.dart';
import 'package:subscription_splitter_app/core/theme/app_colors.dart';
import 'package:subscription_splitter_app/features/spliting_features/domain/entities/group.dart';

/// {@template group_card}
/// Card widget to display individual group information
/// {@endtemplate}
class GroupCard extends StatelessWidget {
  /// {@macro group_card}
  const GroupCard({
    super.key,
    required this.group,
    required this.isOwner,
    required this.currentUserId,
    this.onTap,
    this.onSettings,
    this.onLeave,
  });

  final Group group;
  final bool isOwner;
  final String currentUserId;
  final VoidCallback? onTap;
  final VoidCallback? onSettings;
  final VoidCallback? onLeave;

  @override
  Widget build(BuildContext context) {
    final groupName = group.name;
    final serviceName = group.service.name;
    final totalCost = group.totalCost;
    final cycle = group.cycle;
    final memberCount = group.totalMemberCount;

    // Calculate user's share and cost
    final currentUser = group.getMemberByUserId(currentUserId);
    final userShare = currentUser?.share ?? 1.0;
    final userCost = totalCost * userShare;

    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with group name and role indicator
              Row(
                children: [
                  Expanded(
                    child: Text(
                      groupName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  _buildRoleIndicator(context),
                  const SizedBox(width: 8),
                  if (isOwner && onSettings != null)
                    IconButton(
                      onPressed: onSettings,
                      icon: const Icon(Icons.settings, size: 20),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  if (!isOwner && onLeave != null)
                    IconButton(
                      onPressed: onLeave,
                      icon: const Icon(
                        Icons.exit_to_app,
                        size: 20,
                        color: Colors.red,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                ],
              ),

              const SizedBox(height: 8),

              // Service name
              Text(
                serviceName,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 12),

              // Cost information
              Row(
                children: [
                  Expanded(
                    child: _buildCostInfo(
                      context,
                      'Total Cost',
                      '\$${totalCost.toStringAsFixed(0)}',
                      AppColors.primary,
                    ),
                  ),
                  Expanded(
                    child: _buildCostInfo(
                      context,
                      'Your Share',
                      '\$${userCost.toStringAsFixed(0)}',
                      isOwner ? AppColors.secondary : AppColors.accent,
                    ),
                  ),
                  Expanded(
                    child: _buildCostInfo(
                      context,
                      'Share %',
                      '${(userShare * 100).toInt()}%',
                      AppColors.primary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Footer with cycle and member count
              Row(
                children: [
                  Icon(Icons.repeat, size: 16, color: AppColors.textTertiary),
                  const SizedBox(width: 4),
                  Text(
                    cycle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.group, size: 16, color: AppColors.textTertiary),
                  const SizedBox(width: 4),
                  Text(
                    '$memberCount ${memberCount == 1 ? 'member' : 'members'}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleIndicator(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color:
            isOwner
                ? AppColors.secondary.withOpacity(0.2)
                : AppColors.accent.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isOwner ? AppColors.secondary : AppColors.accent,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isOwner ? Icons.star : Icons.person,
            size: 12,
            color: isOwner ? AppColors.secondary : AppColors.accent,
          ),
          const SizedBox(width: 4),
          Text(
            isOwner ? 'Owner' : 'Member',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: isOwner ? AppColors.secondary : AppColors.accent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCostInfo(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.textTertiary),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}
