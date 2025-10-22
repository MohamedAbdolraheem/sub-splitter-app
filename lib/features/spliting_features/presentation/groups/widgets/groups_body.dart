import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/theme/app_colors.dart';
import '../bloc/groups_bloc.dart';
import 'groups_list.dart';
import 'groups_empty_state.dart';
import 'groups_loading_state.dart';

/// {@template groups_body}
/// Main body widget for the groups page
/// {@endtemplate}
class GroupsBody extends StatelessWidget {
  /// {@macro groups_body}
  const GroupsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupsBloc, GroupsState>(
      builder: (context, state) {
        if (state.hasError) {
          // Show error in the UI instead of snackbar
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Error Loading Groups',
                    style: Theme.of(
                      context,
                    ).textTheme.headlineSmall?.copyWith(color: Colors.red[700]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.errorMessage ?? 'An error occurred',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed:
                        () =>
                            context.read<GroupsBloc>().add(const LoadGroups()),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try Again'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[600],
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return CustomScrollView(
          slivers: [
            // Header with stats
            SliverToBoxAdapter(child: _buildHeader(context, state)),

            // Groups content
            if (state.isLoading)
              const SliverToBoxAdapter(child: GroupsLoadingState())
            else if (state.allGroups.isEmpty)
              const SliverToBoxAdapter(child: GroupsEmptyState())
            else
              SliverToBoxAdapter(
                child: GroupsList(
                  ownedGroups: state.ownedGroups,
                  memberGroups: state.memberGroups,
                  currentUserId:
                      Supabase.instance.client.auth.currentUser?.id ?? '',
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, GroupsState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Groups',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Manage your subscription groups',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),

          // Stats cards
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  'Total Groups',
                  '${state.totalGroups}',
                  Icons.group,
                  AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  context,
                  'Owned',
                  '${state.ownedGroupsCount}',
                  Icons.star,
                  AppColors.secondary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  context,
                  'Member',
                  '${state.memberGroupsCount}',
                  Icons.person,
                  AppColors.accent,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Quick actions
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => context.push('/create-group'),
                  icon: const Icon(Icons.add),
                  label: const Text('Create Group'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => context.push('/join-group'),
                  icon: const Icon(Icons.group_add),
                  label: const Text('Join Group'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textTertiary),
          ),
        ],
      ),
    );
  }
}
