import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:subscription_splitter_app/core/router/screens.dart';
import 'package:subscription_splitter_app/core/extensions/translation_extension.dart';
import 'package:subscription_splitter_app/core/utils/currency_formatter.dart';
import 'package:subscription_splitter_app/core/theme/app_colors.dart';
import 'package:subscription_splitter_app/features/spliting_features/data/models/dashboard_data_model.dart';
import 'package:subscription_splitter_app/features/spliting_features/presentation/home_dashboard/bloc/bloc.dart';

/// {@template home_dashboard_body_enhanced}
/// Enhanced dashboard body with modern UI/UX and rich API data utilization
/// {@endtemplate}
class HomeDashboardBodyEnhanced extends StatelessWidget {
  /// {@macro home_dashboard_body_enhanced}
  const HomeDashboardBodyEnhanced({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeDashboardBloc, HomeDashboardState>(
      listener: (context, state) {
        if (state.status == HomeDashboardStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? context.tr.errorOccurred),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
        if (state.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.successMessage!),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
          // Clear the success message after showing it
          context.read<HomeDashboardBloc>().add(
            const HomeDashboardSuccessMessageCleared(),
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
        return const _LoadingState();
      case HomeDashboardStatus.loaded:
        return _buildDashboardContent(context, state);
      case HomeDashboardStatus.error:
        return _ErrorState(errorMessage: state.errorMessage);
    }
  }

  Widget _buildDashboardContent(
    BuildContext context,
    HomeDashboardState state,
  ) {
    return Column(
      children: [
        // Fixed Welcome Header
        _buildWelcomeHeader(context),

        // Scrollable Content
        Expanded(
          child: CustomScrollView(
            slivers: [
              // Financial Overview Sliver
              SliverToBoxAdapter(
                child: _buildFinancialOverview(context, state),
              ),

              // Quick Actions Sliver
              SliverToBoxAdapter(child: _buildQuickActionsSection(context)),

              // Upcoming Renewals Sliver List
              if (state.dashboardDataModel?.upcomingRenewals.isNotEmpty ==
                  true) ...[
                _buildUpcomingRenewalsSliver(context, state),
              ],

              // Recent Groups Sliver List
              if (state.dashboardDataModel?.recentGroups.isNotEmpty ==
                  true) ...[
                _buildRecentGroupsSliver(context, state),
              ],

              // Pending Invites Sliver List
              if (state.dashboardDataModel?.invites.pendingInvites != null &&
                  state.dashboardDataModel!.invites.pendingInvites > 0) ...[
                _buildPendingInvitesSliver(context, state),
              ],

              // Bottom Spacing
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(gradient: AppColors.primaryGradient),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: context.startCrossAxisAlignment,
                children: [
                  Text(
                    context.tr.appName,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    context.tr.manageSubscriptions,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialOverview(
    BuildContext context,
    HomeDashboardState state,
  ) {
    final dashboardData = state.dashboardDataModel;
    if (dashboardData == null) return const SizedBox.shrink();

    final summary = dashboardData.summary;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.surface, AppColors.surface.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: context.startCrossAxisAlignment,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.analytics,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                context.tr.financialOverview,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: [
              _buildFinancialCard(
                context,
                context.tr.totalGroups,
                '${summary.totalGroups}',
                Icons.groups,
                AppColors.primary,
              ),
              _buildFinancialCard(
                context,
                context.tr.monthlyCost,
                CurrencyFormatter.format(summary.totalMonthlyCost),
                Icons.monetization_on,
                AppColors.secondary,
              ),
              _buildFinancialCard(
                context,
                context.tr.totalSavings,
                CurrencyFormatter.format(summary.totalSavings),
                Icons.savings,
                AppColors.success,
              ),
              _buildFinancialCard(
                context,
                context.tr.savingsPercentage,
                '${summary.savingsPercentage.toStringAsFixed(1)}%',
                Icons.trending_up,
                AppColors.accent,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: context.startCrossAxisAlignment,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 18),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(Icons.info_outline, color: color, size: 10),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: context.startCrossAxisAlignment,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.flash_on, color: AppColors.accent, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                context.tr.quickActions,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  context,
                  context.tr.createGroup,
                  context.tr.startNewSubscription,
                  Icons.add_circle,
                  AppColors.primary,
                  () => context.push(Screens.createGroup.path),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  context,
                  context.tr.viewGroups,
                  context.tr.manageGroups,
                  Icons.groups,
                  AppColors.secondary,
                  () => context.push(Screens.groups.path),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  context,
                  context.tr.joinGroup,
                  context.tr.enterInviteCode,
                  Icons.group_add,
                  AppColors.accent,
                  () => context.push('/join-group'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3), width: 1),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textTertiary,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingRenewalsSliver(
    BuildContext context,
    HomeDashboardState state,
  ) {
    final dashboardData = state.dashboardDataModel;
    if (dashboardData == null)
      return const SliverToBoxAdapter(child: SizedBox.shrink());

    final renewals = dashboardData.upcomingRenewals;

    return SliverMainAxisGroup(
      slivers: [
        // Section Header
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.schedule,
                    color: AppColors.warning,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  context.tr.upcomingRenewals,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                if (renewals.length > 3)
                  TextButton(
                    onPressed: () => context.push('/upcoming-renewals'),
                    child: Text(
                      context.tr.viewAll,
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
              ],
            ),
          ),
        ),
        // Renewals List
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            if (index >= renewals.take(3).length) return null;
            final renewal = renewals[index] as UpcomingRenewalModel;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: _buildRenewalCard(context, renewal),
            );
          }, childCount: renewals.take(3).length),
        ),
      ],
    );
  }

  Widget _buildRenewalCard(BuildContext context, UpcomingRenewalModel renewal) {
    final now = DateTime.now();
    final daysUntil = renewal.renewDate.difference(now).inDays;
    final isUrgent = daysUntil <= 3;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUrgent ? AppColors.error : AppColors.border,
          width: isUrgent ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => context.push('/group-details/${renewal.groupId}'),
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            // Service Icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.business, color: AppColors.textTertiary),
            ),
            const SizedBox(width: 16),

            // Renewal Info
            Expanded(
              child: Column(
                crossAxisAlignment: context.startCrossAxisAlignment,
                children: [
                  Text(
                    renewal.groupName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    renewal.serviceName,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isUrgent
                              ? AppColors.error.withOpacity(0.1)
                              : AppColors.warning.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 14,
                          color: isUrgent ? AppColors.error : AppColors.warning,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            daysUntil == 0
                                ? context.tr.dueToday
                                : daysUntil == 1
                                ? context.tr.dueTomorrow
                                : context.tr.dueInDays.replaceAll(
                                  '{count}',
                                  daysUntil.toString(),
                                ),
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(
                              color:
                                  isUrgent
                                      ? AppColors.error
                                      : AppColors.warning,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Cost
            Column(
              crossAxisAlignment: context.endCrossAxisAlignment,
              children: [
                Text(
                  CurrencyFormatter.format(renewal.amount),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  renewal.isOverdue ? context.tr.overdue : context.tr.dueSoon,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentGroupsSliver(
    BuildContext context,
    HomeDashboardState state,
  ) {
    final dashboardData = state.dashboardDataModel;
    if (dashboardData == null)
      return const SliverToBoxAdapter(child: SizedBox.shrink());

    final groups = dashboardData.recentGroups;

    return SliverMainAxisGroup(
      slivers: [
        // Section Header
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.groups, color: AppColors.primary, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  context.tr.recentGroups,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => context.push(Screens.groups.path),
                  child: Text(
                    context.tr.viewAll,
                    style: TextStyle(color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Groups List
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            if (index >= groups.take(3).length) return null;
            final group = groups[index] as RecentGroupModel;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: _buildGroupCard(context, group),
            );
          }, childCount: groups.take(3).length),
        ),
      ],
    );
  }

  Widget _buildGroupCard(BuildContext context, RecentGroupModel group) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => context.push('/group-details/${group.id}'),
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            // Group Icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.groups, color: AppColors.primary, size: 28),
            ),
            const SizedBox(width: 16),

            // Group Info
            Expanded(
              child: Column(
                crossAxisAlignment: context.startCrossAxisAlignment,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          group.name,
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            context.tr.active,
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(
                              color: AppColors.accent,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    context.tr.serviceId.replaceAll('{id}', group.serviceId),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        size: 14,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          context.tr.renewsOn
                              .replaceAll(
                                '{day}',
                                group.renewDate.day.toString(),
                              )
                              .replaceAll(
                                '{month}',
                                group.renewDate.month.toString(),
                              ),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.textTertiary),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Cost
            Column(
              crossAxisAlignment: context.endCrossAxisAlignment,
              children: [
                Text(
                  CurrencyFormatter.format(group.totalCost),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  group.cycle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingInvitesSliver(
    BuildContext context,
    HomeDashboardState state,
  ) {
    final dashboardData = state.dashboardDataModel;
    if (dashboardData == null)
      return const SliverToBoxAdapter(child: SizedBox.shrink());

    final pendingInviteCount = dashboardData.invites.pendingInvites;

    return SliverMainAxisGroup(
      slivers: [
        // Section Header
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.mail, color: AppColors.warning, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  '${context.tr.pendingInvites} ($pendingInviteCount)',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Empty state for now since we don't have actual invite data
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.mail_outline,
                  size: 48,
                  color: AppColors.textTertiary,
                ),
                const SizedBox(height: 16),
                Text(
                  context.tr.noPendingInvites,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  context.tr.pendingInvitesCount.replaceAll(
                    '{count}',
                    pendingInviteCount.toString(),
                  ),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textTertiary,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: AppColors.primary),
          const SizedBox(height: 16),
          Text(
            context.tr.loadingDashboard,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({this.errorMessage});

  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              context.tr.somethingWentWrong,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage ?? context.tr.errorLoadingDashboard,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<HomeDashboardBloc>().add(
                  const HomeDashboardRefreshRequested(),
                );
              },
              icon: const Icon(Icons.refresh),
              label: Text(context.tr.tryAgain),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
