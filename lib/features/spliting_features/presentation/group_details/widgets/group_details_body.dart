import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:subscription_splitter_app/core/extensions/translation_extension.dart';
import 'package:subscription_splitter_app/core/router/screens.dart';
import 'package:subscription_splitter_app/features/spliting_features/presentation/group_details/bloc/bloc.dart';
import 'package:subscription_splitter_app/features/user_features/presentation/send_notification/utils/notification_composer_helper.dart';
import 'package:subscription_splitter_app/features/user_features/presentation/contact_invitation/contact_invitation.dart';

/// {@template group_details_body}
/// Body of the GroupDetailsPage.
///
/// Add what it does
/// {@endtemplate}
class GroupDetailsBody extends StatelessWidget {
  /// {@macro group_details_body}
  const GroupDetailsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupDetailsBloc, GroupDetailsState>(
      builder: (context, state) {
        final groupId = context.read<GroupDetailsBloc>().groupId;

        return Scaffold(
          appBar: AppBar(
            title: Text(context.tr.groupDetails),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  context.read<GroupDetailsBloc>().add(
                    const RefreshGroupDetails(),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  NotificationComposerHelper.showGroupNotificationComposer(
                    context,
                    groupId: groupId,
                    groupName: state.groupName,
                  );
                },
                tooltip: 'Send Notification',
              ),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  // Navigate to group settings

                  context.push(
                    Screens.groupSettings.path.replaceAll(':groupId', groupId),
                  );
                },
              ),
            ],
          ),
          floatingActionButton: Builder(
            builder: (context) {
              return FloatingActionButton.extended(
                onPressed: () {
                  final currentState = context.read<GroupDetailsBloc>().state;
                  NotificationComposerHelper.showGroupNotificationComposer(
                    context,
                    groupId: groupId,
                    groupName: currentState.groupName,
                  );
                },
                icon: const Icon(Icons.send),
                label: const Text('Send Notification'),
                backgroundColor: Colors.green[600],
                foregroundColor: Colors.white,
              );
            },
          ),
          body:
              state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : state.error != null
                  ? _buildErrorState(context, state.error!)
                  : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildGroupInfoCard(context, state),
                        const SizedBox(height: 16),
                        _buildQuickActionsCard(context, groupId, state),
                        const SizedBox(height: 16),
                        _buildMembersCard(context, state, groupId),
                        const SizedBox(height: 16),
                        _buildRecentActivityCard(context, state),
                        const SizedBox(height: 24),
                        _buildLeaveGroupButton(context, state, groupId),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
        );
      },
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
            const SizedBox(height: 16),
            Text(
              context.tr.errorOccurred,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: Colors.red[600]),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<GroupDetailsBloc>().add(
                  const RefreshGroupDetails(),
                );
              },
              icon: const Icon(Icons.refresh),
              label: Text(context.tr.tryAgain),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupInfoCard(BuildContext context, GroupDetailsState state) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.group, color: Colors.blue[600], size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    context.tr.groupInformation,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildInfoRow(
              context,
              context.tr.groupName,
              state.groupName ?? 'Loading...',
              Icons.label_outline,
              Colors.blue,
            ),
            _buildInfoRow(
              context,
              context.tr.service,
              state.serviceName ?? 'Loading...',
              Icons.business,
              Colors.green,
            ),
            _buildInfoRow(
              context,
              context.tr.totalCost,
              '\$${state.totalCost?.toStringAsFixed(2) ?? '0.00'}',
              Icons.attach_money,
              Colors.orange,
            ),
            _buildInfoRow(
              context,
              context.tr.billingCycle,
              state.billingCycle ?? 'Loading...',
              Icons.schedule,
              Colors.purple,
            ),
            _buildInfoRow(
              context,
              context.tr.nextRenewal,
              state.nextRenewal ?? 'Loading...',
              Icons.calendar_today,
              Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsCard(
    BuildContext context,
    String groupId,
    GroupDetailsState state,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.flash_on,
                    color: Colors.green[600],
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    context.tr.quickActions,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    context: context,
                    icon: Icons.people,
                    label: context.tr.manageMembers,
                    color: Colors.blue,
                    onPressed: () {
                      context.push(
                        Screens.groupMembers.path.replaceAll(
                          ':groupId',
                          groupId,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildActionButton(
                    context: context,
                    icon: Icons.settings,
                    label: context.tr.groupSettings,
                    color: Colors.orange,
                    onPressed: () {
                      context.push(
                        Screens.groupSettings.path.replaceAll(
                          ':groupId',
                          groupId,
                        ),
                      );
                    },
                    isOutlined: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    context: context,
                    icon: Icons.send,
                    label: 'Send Notification',
                    color: Colors.green,
                    onPressed: () {
                      NotificationComposerHelper.showGroupNotificationComposer(
                        context,
                        groupId: groupId,
                        groupName: state.groupName,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildActionButton(
                    context: context,
                    icon: Icons.person_add,
                    label: 'Invite Contacts',
                    color: Colors.purple,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (context) => ContactInvitationPage(
                                groupId: groupId,
                                groupName: state.groupName,
                              ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
    bool isOutlined = false,
  }) {
    if (isOutlined) {
      return OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(label, style: const TextStyle(fontSize: 13)),
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    } else {
      return ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(label, style: const TextStyle(fontSize: 13)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  Widget _buildMembersCard(
    BuildContext context,
    GroupDetailsState state,
    String groupId,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.purple[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.people,
                          color: Colors.purple[600],
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          context.tr.groupMembers,
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () {
                    context.push(
                      Screens.groupMembers.path.replaceAll(':groupId', groupId),
                    );
                  },
                  icon: const Icon(Icons.arrow_forward, size: 16),
                  label: Text(context.tr.viewAll),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.purple[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (state.members.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Icon(
                          Icons.people_outline,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        context.tr.noMembersYet,
                        style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Invite members to get started',
                        style: TextStyle(color: Colors.grey[500], fontSize: 14),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...state.members
                  .take(3)
                  .map((member) => _buildMemberTile(context, member)),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberTile(BuildContext context, Map<String, dynamic> member) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.purple[100],
            radius: 20,
            child: Text(
              (member['name'] ?? 'U')[0].toUpperCase(),
              style: TextStyle(
                color: Colors.purple[800],
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member['name'] ?? 'Unknown',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  member['email'] ?? '',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '\$${(member['share'] ?? 0.0).toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivityCard(
    BuildContext context,
    GroupDetailsState state,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.history,
                    color: Colors.orange[600],
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    context.tr.recentActivity,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (state.recentActivities.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Icon(
                          Icons.history,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        context.tr.noRecentActivity,
                        style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Activity will appear here',
                        style: TextStyle(color: Colors.grey[500], fontSize: 14),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...state.recentActivities.map(
                (activity) => _buildActivityTile(context, activity),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityTile(
    BuildContext context,
    Map<String, dynamic> activity,
  ) {
    final icon = _getActivityIcon(activity['type']);
    final color = _getActivityColor(activity['type']);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity['description'] ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  activity['timestamp'] ?? '',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getActivityIcon(String? type) {
    switch (type) {
      case 'payment':
        return Icons.payment;
      case 'member_added':
        return Icons.person_add;
      case 'member_removed':
        return Icons.person_remove;
      case 'settings_updated':
        return Icons.settings;
      default:
        return Icons.info;
    }
  }

  Color _getActivityColor(String? type) {
    switch (type) {
      case 'payment':
        return Colors.green;
      case 'member_added':
        return Colors.blue;
      case 'member_removed':
        return Colors.red;
      case 'settings_updated':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Widget _buildLeaveGroupButton(
    BuildContext context,
    GroupDetailsState state,
    String groupId,
  ) {
    return BlocListener<GroupDetailsBloc, GroupDetailsState>(
      listener: (context, state) {
        if (state.isLeaving) {
          // Show success message and navigate back
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Successfully left the group!'),
              backgroundColor: Colors.green,
            ),
          );

          // Navigate to home dashboard and trigger refresh
          context.go(Screens.homeDashboard.path);
        }
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!), backgroundColor: Colors.red),
          );
        }
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.withOpacity(0.3)),
        ),
        child: ElevatedButton.icon(
          onPressed:
              state.isLeaving
                  ? null
                  : () {
                    // Show confirmation dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return AlertDialog(
                          title: const Text('Leave Group'),
                          content: const Text(
                            'Are you sure you want to leave this group? You will no longer be able to access group activities or receive notifications.',
                          ),
                          actions: [
                            TextButton(
                              onPressed:
                                  () => Navigator.of(dialogContext).pop(),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                                context.read<GroupDetailsBloc>().add(
                                  const LeaveGroupRequested(),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Leave Group'),
                            ),
                          ],
                        );
                      },
                    );
                  },
          icon:
              state.isLeaving
                  ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                  : const Icon(Icons.exit_to_app),
          label: Text(state.isLeaving ? 'Leaving...' : 'Leave Group'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}
