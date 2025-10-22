import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:subscription_splitter_app/core/notifications/models/notification_preferences.dart';
import '../bloc/notification_settings_bloc.dart';

/// {@template notification_settings_cards}
/// Widget containing all notification settings cards
/// {@endtemplate}
class NotificationSettingsCards extends StatelessWidget {
  /// {@macro notification_settings_cards}
  const NotificationSettingsCards({super.key, required this.preferences});

  final NotificationPreferences preferences;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGlobalSettingsCard(context),
          const SizedBox(height: 16),
          _buildPaymentNotificationsCard(context),
          const SizedBox(height: 16),
          _buildGroupNotificationsCard(context),
          const SizedBox(height: 16),
          _buildRenewalNotificationsCard(context),
          const SizedBox(height: 16),
          _buildCommunicationNotificationsCard(context),
          const SizedBox(height: 16),
          _buildAchievementNotificationsCard(context),
          const SizedBox(height: 16),
          _buildSystemNotificationsCard(context),
          const SizedBox(height: 16),
          _buildQuietHoursCard(context),
          const SizedBox(height: 16),
          _buildActionsCard(context),
        ],
      ),
    );
  }

  Widget _buildGlobalSettingsCard(BuildContext context) {
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
                    Icons.settings,
                    color: Colors.blue[600],
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Global Settings',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildSwitchTile(
              context: context,
              title: 'Enable Notifications',
              subtitle:
                  'Turn all subscription & payment notifications on or off',
              value: preferences.enabled,
              onChanged: (value) => _toggleSetting(context, 'enabled', value),
            ),
            _buildSwitchTile(
              context: context,
              title: 'Push Notifications',
              subtitle: 'Receive real-time alerts about shared subscriptions',
              value: preferences.pushNotifications,
              onChanged:
                  preferences.enabled
                      ? (value) =>
                          _toggleSetting(context, 'pushNotifications', value)
                      : null,
            ),
            _buildSwitchTile(
              context: context,
              title: 'Email Notifications',
              subtitle: 'Receive notifications via email',
              value: preferences.emailNotifications,
              onChanged:
                  preferences.enabled
                      ? (value) =>
                          _toggleSetting(context, 'emailNotifications', value)
                      : null,
            ),
            _buildSwitchTile(
              context: context,
              title: 'SMS Notifications',
              subtitle: 'Receive notifications via SMS',
              value: preferences.smsNotifications,
              onChanged:
                  preferences.enabled
                      ? (value) =>
                          _toggleSetting(context, 'smsNotifications', value)
                      : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentNotificationsCard(BuildContext context) {
    return _buildNotificationTypeCard(
      context: context,
      title: 'Payment Notifications',
      icon: Icons.payment,
      color: Colors.green,
      children: [
        _buildSwitchTile(
          context: context,
          title: 'Payment Reminders',
          subtitle: 'Get reminders for your share of shared subscriptions',
          value: preferences.paymentReminders,
          onChanged:
              (value) => _toggleSetting(context, 'paymentReminders', value),
        ),
        _buildSwitchTile(
          context: context,
          title: 'Payment Overdue',
          subtitle: 'Alerts when your subscription payments are overdue',
          value: preferences.paymentOverdue,
          onChanged:
              (value) => _toggleSetting(context, 'paymentOverdue', value),
        ),
        _buildSwitchTile(
          context: context,
          title: 'Payment Confirmations',
          subtitle: 'Confirmations when subscription payments are processed',
          value: preferences.paymentConfirmations,
          onChanged:
              (value) => _toggleSetting(context, 'paymentConfirmations', value),
        ),
      ],
    );
  }

  Widget _buildGroupNotificationsCard(BuildContext context) {
    return _buildNotificationTypeCard(
      context: context,
      title: 'Group Management',
      icon: Icons.people,
      color: Colors.blue,
      children: [
        _buildSwitchTile(
          context: context,
          title: 'New Member Joined',
          subtitle:
              'Notifications when someone joins your subscription sharing group',
          value: preferences.newMemberJoined,
          onChanged:
              (value) => _toggleSetting(context, 'newMemberJoined', value),
        ),
        _buildSwitchTile(
          context: context,
          title: 'Member Left',
          subtitle: 'Alerts when someone leaves a shared subscription group',
          value: preferences.memberLeft,
          onChanged: (value) => _toggleSetting(context, 'memberLeft', value),
        ),
        _buildSwitchTile(
          context: context,
          title: 'Group Invitations',
          subtitle:
              'Get notified about joining subscription cost-splitting groups',
          value: preferences.groupInvitations,
          onChanged:
              (value) => _toggleSetting(context, 'groupInvitations', value),
        ),
      ],
    );
  }

  Widget _buildRenewalNotificationsCard(BuildContext context) {
    return _buildNotificationTypeCard(
      context: context,
      title: 'Renewal Notifications',
      icon: Icons.autorenew,
      color: Colors.orange,
      children: [
        _buildSwitchTile(
          context: context,
          title: 'Upcoming Renewals',
          subtitle:
              'Get notified before shared subscriptions auto-renew (Netflix, Spotify, etc.)',
          value: preferences.upcomingRenewals,
          onChanged:
              (value) => _toggleSetting(context, 'upcomingRenewals', value),
        ),
        _buildSwitchTile(
          context: context,
          title: 'Renewal Successful',
          subtitle: 'Get notified when renewals are successful',
          value: preferences.renewalSuccessful,
          onChanged:
              (value) => _toggleSetting(context, 'renewalSuccessful', value),
        ),
        _buildSwitchTile(
          context: context,
          title: 'Renewal Failed',
          subtitle: 'Get notified when renewals fail',
          value: preferences.renewalFailed,
          onChanged: (value) => _toggleSetting(context, 'renewalFailed', value),
        ),
      ],
    );
  }

  Widget _buildCommunicationNotificationsCard(BuildContext context) {
    return _buildNotificationTypeCard(
      context: context,
      title: 'Communication',
      icon: Icons.message,
      color: Colors.purple,
      children: [
        _buildSwitchTile(
          context: context,
          title: 'Group Messages',
          subtitle: 'Get notified about new group messages',
          value: preferences.groupMessages,
          onChanged: (value) => _toggleSetting(context, 'groupMessages', value),
        ),
        _buildSwitchTile(
          context: context,
          title: 'Member Mentions',
          subtitle: 'Get notified when someone mentions you',
          value: preferences.memberMentions,
          onChanged:
              (value) => _toggleSetting(context, 'memberMentions', value),
        ),
      ],
    );
  }

  Widget _buildAchievementNotificationsCard(BuildContext context) {
    return _buildNotificationTypeCard(
      context: context,
      title: 'Achievements',
      icon: Icons.emoji_events,
      color: Colors.amber,
      children: [
        _buildSwitchTile(
          context: context,
          title: 'Savings Milestones',
          subtitle: 'Get notified when you reach savings milestones',
          value: preferences.savingsMilestones,
          onChanged:
              (value) => _toggleSetting(context, 'savingsMilestones', value),
        ),
        _buildSwitchTile(
          context: context,
          title: 'Group Milestones',
          subtitle: 'Get notified when your group reaches milestones',
          value: preferences.groupMilestones,
          onChanged:
              (value) => _toggleSetting(context, 'groupMilestones', value),
        ),
      ],
    );
  }

  Widget _buildSystemNotificationsCard(BuildContext context) {
    return _buildNotificationTypeCard(
      context: context,
      title: 'System Notifications',
      icon: Icons.settings,
      color: Colors.grey,
      children: [
        _buildSwitchTile(
          context: context,
          title: 'App Updates',
          subtitle: 'Get notified about app updates',
          value: preferences.appUpdates,
          onChanged: (value) => _toggleSetting(context, 'appUpdates', value),
        ),
        _buildSwitchTile(
          context: context,
          title: 'Service Outages',
          subtitle: 'Get notified about service outages',
          value: preferences.serviceOutages,
          onChanged:
              (value) => _toggleSetting(context, 'serviceOutages', value),
        ),
      ],
    );
  }

  Widget _buildQuietHoursCard(BuildContext context) {
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
                    color: Colors.indigo[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.bedtime,
                    color: Colors.indigo[600],
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Quiet Hours',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildSwitchTile(
              context: context,
              title: 'Enable Quiet Hours',
              subtitle: 'Pause notifications during specified hours',
              value: preferences.quietHoursEnabled,
              onChanged:
                  (value) =>
                      _toggleSetting(context, 'quietHoursEnabled', value),
            ),
            if (preferences.quietHoursEnabled) ...[
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Start Time'),
                subtitle: Text(_formatTimeOfDay(preferences.quietHoursStart)),
                trailing: const Icon(Icons.access_time),
                onTap: () => _selectStartTime(context),
              ),
              ListTile(
                title: const Text('End Time'),
                subtitle: Text(_formatTimeOfDay(preferences.quietHoursEnd)),
                trailing: const Icon(Icons.access_time),
                onTap: () => _selectEndTime(context),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionsCard(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Actions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  context.read<NotificationSettingsBloc>().add(
                    const ResetToDefaults(),
                  );
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Reset to Defaults'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationTypeCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
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
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool>? onChanged,
  }) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.blue[600],
    );
  }

  void _toggleSetting(BuildContext context, String settingKey, bool value) {
    context.read<NotificationSettingsBloc>().add(
      ToggleNotificationSetting(settingKey: settingKey, value: value),
    );
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: preferences.quietHoursStart,
    );
    if (time != null) {
      context.read<NotificationSettingsBloc>().add(
        UpdateQuietHours(
          enabled: preferences.quietHoursEnabled,
          startTime: time,
        ),
      );
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: preferences.quietHoursEnd,
    );
    if (time != null) {
      context.read<NotificationSettingsBloc>().add(
        UpdateQuietHours(enabled: preferences.quietHoursEnabled, endTime: time),
      );
    }
  }
}
