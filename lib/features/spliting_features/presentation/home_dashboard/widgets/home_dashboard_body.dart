import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:subscription_splitter_app/core/router/screens.dart';
import 'package:subscription_splitter_app/core/extensions/translation_extension.dart';
import 'package:subscription_splitter_app/core/utils/currency_formatter.dart';
import 'package:subscription_splitter_app/core/utils/date_formatter.dart';
import 'package:subscription_splitter_app/features/spliting_features/presentation/home_dashboard/bloc/bloc.dart';

/// {@template home_dashboard_body}
/// Body of the HomeDashboardPage.
///
/// Add what it does
/// {@endtemplate}
class HomeDashboardBody extends StatelessWidget {
  /// {@macro home_dashboard_body}
  const HomeDashboardBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeDashboardBloc, HomeDashboardState>(
      listener: (context, state) {
        if (state.status == HomeDashboardStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'An error occurred'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return _buildBody(context, state);
      },
    );
  }

  Widget _buildBody(BuildContext context, HomeDashboardState state) {
    switch (state.status) {
      case HomeDashboardStatus.initial:
      case HomeDashboardStatus.loading:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text('Loading...', style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        );
      case HomeDashboardStatus.loaded:
        return _buildDashboardContent(context, state);
      case HomeDashboardStatus.error:
        return _buildErrorContent(context, state);
    }
  }

  Widget _buildDashboardContent(
    BuildContext context,
    HomeDashboardState state,
  ) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Welcome Header
          _buildWelcomeHeader(context),

          // Financial Summary Cards
          _buildFinancialSummary(context, state),

          // Pending Invites Section
          if (state.pendingInvites.isNotEmpty) ...[
            _buildPendingInvitesSection(context, state),
            const SizedBox(height: 24),
          ],

          // Upcoming Payments Section
          if (state.upcomingPayments.isNotEmpty) ...[
            _buildUpcomingPaymentsSection(context, state),
            const SizedBox(height: 24),
          ],

          // My Groups Section
          _buildMyGroupsSection(context, state),

          // Quick Actions
          _buildQuickActions(context),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildWelcomeHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.8),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr.welcomeBack,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                context.tr.manageSubscriptions,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFinancialSummary(
    BuildContext context,
    HomeDashboardState state,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              context,
              context.tr.youOwe,
              CurrencyFormatter.format(state.totalOwing),
              Colors.red,
              Icons.arrow_upward,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildSummaryCard(
              context,
              context.tr.owedToYou,
              CurrencyFormatter.format(state.totalOwed),
              Colors.green,
              Icons.arrow_downward,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    String title,
    String amount,
    Color color,
    IconData icon,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              amount,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingInvitesSection(
    BuildContext context,
    HomeDashboardState state,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.mail, color: Colors.orange[600]),
              const SizedBox(width: 8),
              Text(
                '${context.tr.pendingInvites} (${state.pendingInvites.length})',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...state.pendingInvites.map(
            (invite) => _buildInviteCard(context, invite),
          ),
        ],
      ),
    );
  }

  Widget _buildInviteCard(BuildContext context, Map<String, dynamic> invite) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.group_add,
                    color: Colors.orange[600],
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        invite['groupName'] ?? 'Unknown Group',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${invite['service'] ?? 'Unknown Service'} • ${context.tr.invitedBy(invite['inviterName'] ?? 'Unknown')}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      context.read<HomeDashboardBloc>().add(
                        RejectInviteRequested(inviteId: invite['id'] ?? ''),
                      );
                    },
                    child: Text(context.tr.reject),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<HomeDashboardBloc>().add(
                        JoinGroupRequested(inviteId: invite['id'] ?? ''),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[600],
                      foregroundColor: Colors.white,
                    ),
                    child: Text(context.tr.accept),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingPaymentsSection(
    BuildContext context,
    HomeDashboardState state,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.payment, color: Colors.blue[600]),
              const SizedBox(width: 8),
              Text(
                'Upcoming Payments (${state.upcomingPayments.length})',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...state.upcomingPayments.map(
            (payment) => _buildPaymentCard(context, payment),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard(BuildContext context, Map<String, dynamic> payment) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color:
                        (payment['isOverdue'] ?? false)
                            ? Colors.red.withOpacity(0.1)
                            : Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    (payment['isOverdue'] ?? false)
                        ? Icons.warning
                        : Icons.payment,
                    color:
                        (payment['isOverdue'] ?? false)
                            ? Colors.red[600]
                            : Colors.blue[600],
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        payment['groupName'] ?? 'Unknown Group',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${payment['service'] ?? 'Unknown Service'} • Due ${_formatDate(DateTime.tryParse(payment['dueDate'] ?? '') ?? DateTime.now())}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Text(
                  '\$${(payment['amount'] ?? 0.0).toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color:
                        (payment['isOverdue'] ?? false)
                            ? Colors.red[600]
                            : Colors.blue[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  context.read<HomeDashboardBloc>().add(
                    MarkPaymentCompleted(paymentId: payment['id'] ?? ''),
                  );
                },
                icon: const Icon(Icons.check, size: 18),
                label: const Text('Mark as Paid'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600],
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyGroupsSection(BuildContext context, HomeDashboardState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.groups, color: Colors.purple[600]),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'My Groups (${state.groups.length})',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              TextButton(
                onPressed: () => context.push(Screens.groups.path),
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (state.groups.isEmpty)
            _buildEmptyGroupsCard(context)
          else
            ...state.groups.map((group) => _buildGroupCard(context, group)),
        ],
      ),
    );
  }

  Widget _buildEmptyGroupsCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(Icons.groups_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No groups yet',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Create a group or accept an invite to get started',
              style: TextStyle(color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => context.push(Screens.createGroup.path),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Create Group'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple[600],
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () => context.push(Screens.groups.path),
                  icon: const Icon(Icons.groups, size: 18),
                  label: const Text('View All'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupCard(BuildContext context, Map<String, dynamic> group) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          final groupId = group['id'] as String?;
          if (groupId != null) {
            context.push(
              Screens.groupDetails.path.replaceAll(':groupId', groupId),
            );
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color:
                          (group['isOwner'] ?? false)
                              ? Colors.purple.withOpacity(0.1)
                              : Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      (group['isOwner'] ?? false) ? Icons.star : Icons.person,
                      color:
                          (group['isOwner'] ?? false)
                              ? Colors.purple[600]
                              : Colors.blue[600],
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          group['name'] ?? 'Unknown Group',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${group['service'] ?? 'Unknown Service'} • ${group['memberCount'] ?? 0} members',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$${(group['userShare'] ?? 0.0).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'of \$${(group['totalCost'] ?? 0.0).toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    (group['isPaid'] ?? false)
                        ? Icons.check_circle
                        : Icons.schedule,
                    color:
                        (group['isPaid'] ?? false)
                            ? Colors.green
                            : Colors.orange,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    (group['isPaid'] ?? false)
                        ? 'Paid'
                        : 'Due ${_formatDate(DateTime.tryParse(group['nextBillingDate'] ?? '') ?? DateTime.now())}',
                    style: TextStyle(
                      fontSize: 12,
                      color:
                          (group['isPaid'] ?? false)
                              ? Colors.green
                              : Colors.orange,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  if (group['isOwner'] ?? false)
                    Text(
                      'Owner',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.purple[600],
                        fontWeight: FontWeight.w500,
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

  Widget _buildQuickActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  context,
                  'Create Group',
                  'Start a new subscription group',
                  Icons.add_circle,
                  Colors.green,
                  () {
                    context.push(Screens.createGroup.path);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionCard(
                  context,
                  'Join Group',
                  'Join with invite code',
                  Icons.group_add,
                  Colors.blue,
                  () {
                    // TODO: Navigate to join group page
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorContent(BuildContext context, HomeDashboardState state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Error Loading Dashboard',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            state.errorMessage ?? 'An unknown error occurred',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context.read<HomeDashboardBloc>().add(
                const HomeDashboardRefreshRequested(),
              );
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormatter.formatBillingDate(date);
  }
}
