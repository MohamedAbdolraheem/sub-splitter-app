import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:subscription_splitter_app/app/bloc/app_bloc.dart';
import 'package:subscription_splitter_app/core/router/screens.dart';
import 'package:subscription_splitter_app/core/widgets/language_switcher.dart';
import 'package:subscription_splitter_app/core/extensions/translation_extension.dart';

/// {@template app_drawer}
/// A shared drawer component used across the app
/// {@endtemplate}
class AppDrawer extends StatelessWidget {
  /// {@macro app_drawer}
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      buildWhen: (previous, current) {
        // Rebuild when language changes
        return previous.languageCode != current.languageCode;
      },
      builder: (context, state) {
        return Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // Drawer Header
              _buildDrawerHeader(context),

              // Profile
              _buildProfileTile(context),

              // Notifications
              _buildNotificationsTile(context),

              // Subscriptions
              _buildSubscriptionsTile(context),

              // Expenses
              _buildExpensesTile(context),

              // Payments
              _buildPaymentsTile(context),

              const Divider(),

              // Language Switcher
              _buildLanguageTile(context),

              // Settings
              _buildSettingsTile(context),

              // Help & Support
              _buildHelpSupportTile(context),

              const Divider(),

              // Sign Out
              _buildSignOutTile(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    return DrawerHeader(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.8),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Icon(
            Icons.account_balance_wallet,
            size: 48,
            color: Colors.white,
          ),
          const SizedBox(height: 8),
          Text(
            context.tr.appName,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            context.tr.appTagline,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.person),
      title: Text(context.tr.profileTitle),
      subtitle: Text(context.tr.accountInfo),
      onTap: () {
        Navigator.pop(context);
        context.push(Screens.displayProfile.path);
      },
    );
  }

  Widget _buildNotificationsTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.notifications),
      title: const Text('Notifications'),
      subtitle: const Text('View and manage notifications'),
      onTap: () {
        Navigator.pop(context);
        context.push(Screens.notifications.path);
      },
    );
  }

  Widget _buildSubscriptionsTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.subscriptions),
      title: Text(context.tr.subscriptions),
      subtitle: Text(context.tr.manageSubscriptions),
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.tr.comingSoon)));
      },
    );
  }

  Widget _buildExpensesTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.receipt_long),
      title: Text(context.tr.expenses),
      subtitle: Text(context.tr.appTagline),
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.tr.comingSoon)));
      },
    );
  }

  Widget _buildPaymentsTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.payment),
      title: Text(context.tr.payments),
      subtitle: Text(context.tr.paymentHistory),
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.tr.comingSoon)));
      },
    );
  }

  Widget _buildSettingsTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.settings),
      title: Text(context.tr.settings),
      subtitle: Text(context.tr.privacySettings),
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.tr.comingSoon)));
      },
    );
  }

  Widget _buildHelpSupportTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.help),
      title: Text(context.tr.helpSupport),
      subtitle: Text(context.tr.helpSupport),
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.tr.comingSoon)));
      },
    );
  }

  Widget _buildSignOutTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.logout, color: Colors.red),
      title: Text(
        context.tr.signOut,
        style: const TextStyle(color: Colors.red),
      ),
      onTap: () {
        Navigator.pop(context);
        _showSignOutDialog(context);
      },
    );
  }

  Widget _buildLanguageTile(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return ListTile(
          leading: const Icon(Icons.language),
          title: Text(context.tr.language),
          trailing: LanguageToggleButton(
            currentLanguage: state.languageCode,
            onLanguageChanged: (languageCode) {
              context.read<AppBloc>().add(
                AppLanguageChanged(languageCode: languageCode),
              );
            },
          ),
        );
      },
    );
  }

  void _showSignOutDialog(BuildContext context) {
    // Save AppBloc reference before opening dialog
    final appBloc = context.read<AppBloc>();

    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: Text(context.tr.signOut),
            content: Text(context.tr.signOutConfirm),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(context.tr.cancel),
              ),
              ElevatedButton(
                onPressed: () {
                  // Use saved AppBloc reference for global logout
                  print('AppDrawer: Triggering logout...');
                  appBloc.add(const AppLogoutRequested());
                  Navigator.of(dialogContext).pop();
                  print('AppDrawer: Logout event sent, dialog closed');
                  // Navigation will be handled by App BLoC auth state change
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: Text(context.tr.signOut),
              ),
            ],
          ),
    );
  }
}
