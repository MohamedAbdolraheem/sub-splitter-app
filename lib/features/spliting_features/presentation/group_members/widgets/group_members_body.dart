import 'package:flutter/material.dart';
import 'package:subscription_splitter_app/core/extensions/translation_extension.dart';
import 'package:subscription_splitter_app/features/spliting_features/presentation/group_members/bloc/bloc.dart';

/// {@template group_members_body}
/// Body of the GroupMembersPage.
///
/// Add what it does
/// {@endtemplate}
class GroupMembersBody extends StatefulWidget {
  /// {@macro group_members_body}
  const GroupMembersBody({super.key});

  @override
  State<GroupMembersBody> createState() => _GroupMembersBodyState();
}

class _GroupMembersBodyState extends State<GroupMembersBody> {
  final _inviteEmailController = TextEditingController();
  final _shareController = TextEditingController();

  @override
  void dispose() {
    _inviteEmailController.dispose();
    _shareController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GroupMembersBloc, GroupMembersState>(
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!), backgroundColor: Colors.red),
          );
        }

        if (state.isInviting == false &&
            state.error == null &&
            state.inviteEmail.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Member invited successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      builder: (context, state) {
        return state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSummaryCard(context, state),
                  const SizedBox(height: 16),
                  _buildShareManagementCard(context, state),
                  const SizedBox(height: 16),
                  _buildMembersList(context, state),
                ],
              ),
            );
      },
    );
  }

  Widget _buildSummaryCard(BuildContext context, GroupMembersState state) {
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
                  child: Icon(
                    Icons.analytics_outlined,
                    color: Colors.blue[600],
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Group Summary',
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
                  child: _buildSummaryItem(
                    'Total Cost',
                    '\$${state.totalCost.toStringAsFixed(2)}',
                    Icons.attach_money,
                    Colors.green,
                  ),
                ),
                Expanded(
                  child: _buildSummaryItem(
                    'Members',
                    '${state.members.length}',
                    Icons.people,
                    Colors.blue,
                  ),
                ),
                Expanded(
                  child: _buildSummaryItem(
                    'Avg Share',
                    '${(100 / state.members.length).toStringAsFixed(1)}%',
                    Icons.pie_chart,
                    Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShareManagementCard(
    BuildContext context,
    GroupMembersState state,
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
                    Icons.pie_chart_outline,
                    color: Colors.green[600],
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Share Management',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                Switch(
                  value: state.isAutoEqualShares,
                  onChanged: (value) {
                    context.read<GroupMembersBloc>().add(
                      const ToggleAutoEqualShares(),
                    );
                  },
                  activeColor: Colors.green[600],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    state.isAutoEqualShares
                        ? Colors.green[50]
                        : Colors.orange[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color:
                      state.isAutoEqualShares
                          ? Colors.green[200]!
                          : Colors.orange[200]!,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    state.isAutoEqualShares ? Icons.auto_awesome : Icons.tune,
                    color:
                        state.isAutoEqualShares
                            ? Colors.green[600]
                            : Colors.orange[600],
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      state.isAutoEqualShares
                          ? 'Auto-equal shares enabled'
                          : 'Custom shares enabled',
                      style: TextStyle(
                        color:
                            state.isAutoEqualShares
                                ? Colors.green[700]
                                : Colors.orange[700],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (!state.isAutoEqualShares) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed:
                      state.isSaving
                          ? null
                          : () {
                            context.read<GroupMembersBloc>().add(
                              const RebalanceShares(),
                            );
                          },
                  icon: const Icon(Icons.balance),
                  label: const Text('Rebalance Shares'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMembersList(BuildContext context, GroupMembersState state) {
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
                    'Members (${state.members.length})',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => _showInviteDialog(context, state),
                  icon: const Icon(Icons.person_add),
                  tooltip: 'Invite Member',
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.purple[50],
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
                        'No members yet',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
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
              ...state.members.map(
                (member) => _buildMemberTile(context, state, member),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberTile(
    BuildContext context,
    GroupMembersState state,
    GroupMember member,
  ) {
    final isSelected = state.selectedMemberId == member.id;
    final showEditor = state.showShareEditor && isSelected;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: isSelected ? Colors.blue[50] : null,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: member.isOwner ? Colors.amber : Colors.blue,
                  child: Text(
                    member.name[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            member.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          if (member.isOwner) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Owner',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                          if (member.isAdmin && !member.isOwner) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Admin',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      Text(
                        member.email,
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${member.sharePercentage.toStringAsFixed(1)}%',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '\$${member.amount.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                PopupMenuButton<String>(
                  onSelected:
                      (value) => _handleMemberAction(context, value, member),
                  itemBuilder:
                      (context) => [
                        if (!member.isOwner)
                          const PopupMenuItem(
                            value: 'remove',
                            child: Row(
                              children: [
                                Icon(Icons.person_remove, color: Colors.red),
                                SizedBox(width: 8),
                                Text('Remove'),
                              ],
                            ),
                          ),
                        if (!state.isAutoEqualShares && !member.isOwner)
                          const PopupMenuItem(
                            value: 'edit_share',
                            child: Row(
                              children: [
                                Icon(Icons.edit),
                                SizedBox(width: 8),
                                Text('Edit Share'),
                              ],
                            ),
                          ),
                      ],
                ),
              ],
            ),
            if (showEditor) ...[
              const SizedBox(height: 12),
              _buildShareEditor(context, state, member),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildShareEditor(
    BuildContext context,
    GroupMembersState state,
    GroupMember member,
  ) {
    _shareController.text = member.sharePercentage.toStringAsFixed(1);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _shareController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Share %',
                border: OutlineInputBorder(),
                suffixText: '%',
              ),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed:
                state.isSaving
                    ? null
                    : () {
                      final share = double.tryParse(_shareController.text);
                      if (share != null && share > 0 && share <= 100) {
                        context.read<GroupMembersBloc>().add(
                          UpdateMemberShare(member.id, share),
                        );
                      }
                    },
            child: const Text('Save'),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: () {
              context.read<GroupMembersBloc>().add(const HideShareEditor());
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _handleMemberAction(
    BuildContext context,
    String action,
    GroupMember member,
  ) {
    switch (action) {
      case 'remove':
        _showRemoveConfirmation(context, member);
        break;
      case 'edit_share':
        context.read<GroupMembersBloc>().add(ShowShareEditor(member.id));
        break;
    }
  }

  void _showRemoveConfirmation(BuildContext context, GroupMember member) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Remove Member'),
            content: Text(
              'Are you sure you want to remove ${member.name} from this group?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(context.tr.cancel),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.read<GroupMembersBloc>().add(RemoveMember(member.id));
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Remove'),
              ),
            ],
          ),
    );
  }

  void _showInviteDialog(BuildContext context, GroupMembersState state) {
    _inviteEmailController.text = state.inviteEmail;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Invite Member'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _inviteEmailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  onChanged: (value) {
                    context.read<GroupMembersBloc>().add(
                      InviteEmailChanged(value),
                    );
                  },
                ),
                const SizedBox(height: 16),
                if (state.isInviting)
                  const Center(child: CircularProgressIndicator())
                else
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          state.inviteEmail.isNotEmpty
                              ? () {
                                context.read<GroupMembersBloc>().add(
                                  InviteMember(state.inviteEmail),
                                );
                                Navigator.of(context).pop();
                              }
                              : null,
                      child: const Text('Send Invite'),
                    ),
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(context.tr.cancel),
              ),
            ],
          ),
    );
  }
}
