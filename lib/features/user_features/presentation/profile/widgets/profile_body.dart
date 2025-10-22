import 'dart:developer' as console;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:subscription_splitter_app/core/extensions/translation_extension.dart';
import 'package:subscription_splitter_app/core/router/screens.dart';
import 'package:subscription_splitter_app/features/user_features/presentation/profile/cubit/cubit.dart';

/// {@template profile_body}
/// Body of the ProfilePage.
///
/// Add what it does
/// {@endtemplate}
class ProfileBody extends StatelessWidget {
  /// {@macro profile_body}
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state.status == ProfileStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? context.tr.unknownError),
            ),
          );
        }
      },
      builder: (context, state) {
        return _buildBody(context, state);
      },
    );
  }

  Widget _buildBody(BuildContext context, ProfileState state) {
    switch (state.status) {
      case ProfileStatus.initial:
      case ProfileStatus.loading:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(context.tr.loading),
            ],
          ),
        );
      case ProfileStatus.loaded:
        return _buildProfileContent(context, state);
      case ProfileStatus.error:
        return _buildErrorContent(context, state);
    }
  }

  Widget _buildProfileContent(BuildContext context, ProfileState state) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Profile Header with Gradient Background
          _buildProfileHeader(context, state),

          // Profile Content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Completion Alert
                if (!state.isProfileComplete) ...[
                  _buildProfileCompletionAlert(context),
                  const SizedBox(height: 24),
                ],

                // Profile Information Card
                _buildProfileInfoCard(context, state),
                const SizedBox(height: 24),

                // Profile Actions
                _buildProfileActions(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, ProfileState state) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.8),
            Theme.of(context).primaryColor.withOpacity(0.6),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Profile Avatar with Animation
              Hero(
                tag: 'profile_avatar',
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    backgroundImage:
                        state.avatarUrl != null
                            ? NetworkImage(state.avatarUrl!)
                            : null,
                    child:
                        state.avatarUrl == null
                            ? Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.white.withOpacity(0.9),
                            )
                            : null,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // User Name
              Text(
                state.name,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // User Email
              Text(
                state.email,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Profile Completion Status Badge
              _buildProfileStatusBadge(context, state),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileStatusBadge(BuildContext context, ProfileState state) {
    if (state.isProfileComplete) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, size: 18, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              context.tr.profileComplete,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.warning, size: 18, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              'Complete Profile',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildProfileInfoCard(BuildContext context, ProfileState state) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Profile Information',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Mobile Number
            if (state.mobileNumber.isNotEmpty) ...[
              _buildInfoRow(
                icon: Icons.phone,
                label: 'Mobile',
                value: state.mobileNumber,
                color: Colors.green,
              ),
              const SizedBox(height: 16),
            ],

            // Location
            if (state.location.isNotEmpty) ...[
              _buildInfoRow(
                icon: Icons.location_on,
                label: 'Location',
                value: state.location,
                color: Colors.blue,
              ),
              const SizedBox(height: 16),
            ],

            // Gender
            if (state.gender != null) ...[
              _buildInfoRow(
                icon: Icons.person_outline,
                label: 'Gender',
                value: state.gender!,
                color: Colors.purple,
              ),
              const SizedBox(height: 16),
            ],

            // Date of Birth
            if (state.dateOfBirth != null) ...[
              _buildInfoRow(
                icon: Icons.cake,
                label: 'Date of Birth',
                value:
                    '${state.dateOfBirth!.day}/${state.dateOfBirth!.month}/${state.dateOfBirth!.year}',
                color: Colors.orange,
              ),
              const SizedBox(height: 16),
            ],

            // Bio
            if (state.bio.isNotEmpty) ...[
              _buildInfoRow(
                icon: Icons.description,
                label: 'Bio',
                value: state.bio,
                color: Colors.teal,
                isMultiline: true,
              ),
            ],

            // Show message if no additional info
            if (state.mobileNumber.isEmpty &&
                state.location.isEmpty &&
                state.gender == null &&
                state.dateOfBirth == null &&
                state.bio.isEmpty) ...[
              Center(
                child: Column(
                  children: [
                    Icon(Icons.info_outline, size: 48, color: Colors.grey[400]),
                    const SizedBox(height: 12),
                    Text(
                      'No additional information',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Complete your profile to add more details',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    bool isMultiline = false,
  }) {
    return Row(
      crossAxisAlignment:
          isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: isMultiline ? null : 1,
                overflow: isMultiline ? null : TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Profile Actions',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildProfileOptions(context),
      ],
    );
  }

  Widget _buildProfileCompletionAlert(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[50]!, Colors.blue[100]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[600],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.person_add, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Complete Your Profile',
                        style: TextStyle(
                          color: Colors.blue[800],
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Add your details to get the most out of Subscription Splitter',
                        style: TextStyle(color: Colors.blue[700], fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  console.log('Navigating to: ${Screens.createProfile.path}');
                  final result = await context.push<bool>(
                    Screens.createProfile.path,
                  );

                  // If profile was completed, refresh the profile data
                  if (result == true && context.mounted) {
                    console.log(
                      'Profile completed, refreshing profile data...',
                    );
                    context.read<ProfileCubit>().loadProfile();

                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Profile completed successfully!'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.edit, size: 20),
                label: const Text('Complete Profile'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOptions(BuildContext context) {
    return Column(
      children: [
        // Edit Profile
        _buildModernOptionTile(
          context: context,
          icon: Icons.edit,
          title: 'Edit Profile',
          subtitle: 'Update your personal information',
          color: Colors.blue,
          onTap: () async {
            console.log(
              'Navigating to edit profile: ${Screens.createProfile.path}',
            );
            final result = await context.push<bool>(Screens.createProfile.path);

            // If profile was updated, refresh the profile data
            if (result == true && context.mounted) {
              console.log('Profile updated, refreshing profile data...');
              context.read<ProfileCubit>().loadProfile();

              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profile updated successfully!'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ),
              );
            }
          },
        ),
        const SizedBox(height: 12),

        // Change Password
        _buildModernOptionTile(
          context: context,
          icon: Icons.lock,
          title: 'Change Password',
          subtitle: 'Update your account password',
          color: Colors.orange,
          onTap: () {
            _showChangePasswordDialog(context);
          },
        ),
        const SizedBox(height: 12),

        // Privacy Settings
        _buildModernOptionTile(
          context: context,
          icon: Icons.privacy_tip,
          title: 'Privacy Settings',
          subtitle: 'Manage your privacy preferences',
          color: Colors.purple,
          onTap: () {
            _showPrivacySettingsDialog(context);
          },
        ),
        const SizedBox(height: 12),

        // Account Information
        _buildModernOptionTile(
          context: context,
          icon: Icons.info_outline,
          title: 'Account Information',
          subtitle: 'View your account details',
          color: Colors.teal,
          onTap: () {
            _showAccountInfoDialog(context);
          },
        ),
      ],
    );
  }

  Widget _buildModernOptionTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.chevron_right,
                    color: Colors.grey[600],
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorContent(BuildContext context, ProfileState state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Error Loading Profile',
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
              context.read<ProfileCubit>().loadProfile();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (dialogContext) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.lock,
                          color: Colors.orange[600],
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Change Password',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        icon: Icon(Icons.close, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Form
                  TextField(
                    controller: currentPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Current Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.orange[600]!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: newPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      prefixIcon: const Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.orange[600]!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Confirm New Password',
                      prefixIcon: const Icon(Icons.lock_reset),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.orange[600]!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Actions
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(dialogContext).pop(),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: Implement password change
                            Navigator.of(dialogContext).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Password change coming soon!'),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange[600],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Change Password'),
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

  void _showPrivacySettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.purple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.privacy_tip,
                          color: Colors.purple[600],
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Privacy Settings',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        icon: Icon(Icons.close, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Content
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPrivacySection(
                        'Profile Visibility',
                        [
                          'Public - Anyone can see your profile',
                          'Friends - Only your connections can see',
                          'Private - Only you can see your profile',
                        ],
                        Icons.visibility,
                        Colors.blue,
                      ),
                      const SizedBox(height: 24),
                      _buildPrivacySection(
                        'Data Sharing',
                        [
                          'Share usage data for app improvement',
                          'Allow marketing communications',
                        ],
                        Icons.share,
                        Colors.green,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Actions
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(dialogContext).pop(),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Close'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Privacy settings coming soon!'),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple[600],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Save Settings'),
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

  Widget _buildPrivacySection(
    String title,
    List<String> items,
    IconData icon,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(left: 28, bottom: 8),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showAccountInfoDialog(BuildContext context) {
    final state = context.read<ProfileCubit>().state;

    showDialog(
      context: context,
      builder:
          (dialogContext) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.teal.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.info_outline,
                          color: Colors.teal[600],
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Account Information',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        icon: Icon(Icons.close, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Content
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Column(
                      children: [
                        _buildAccountInfoRow(
                          'User ID',
                          state.user?.id ?? 'N/A',
                          Icons.fingerprint,
                        ),
                        _buildAccountInfoRow('Email', state.email, Icons.email),
                        _buildAccountInfoRow('Name', state.name, Icons.person),
                        _buildAccountInfoRow(
                          'Mobile',
                          state.mobileNumber.isNotEmpty
                              ? state.mobileNumber
                              : 'Not provided',
                          Icons.phone,
                        ),
                        _buildAccountInfoRow(
                          'Location',
                          state.location.isNotEmpty
                              ? state.location
                              : 'Not provided',
                          Icons.location_on,
                        ),
                        _buildAccountInfoRow(
                          'Gender',
                          state.gender ?? 'Not specified',
                          Icons.person_outline,
                        ),
                        _buildAccountInfoRow(
                          'Date of Birth',
                          state.dateOfBirth != null
                              ? '${state.dateOfBirth!.day}/${state.dateOfBirth!.month}/${state.dateOfBirth!.year}'
                              : 'Not provided',
                          Icons.cake,
                        ),
                        _buildAccountInfoRow(
                          'Account Created',
                          state.user?.createdAt ?? 'Unknown',
                          Icons.calendar_today,
                        ),
                        _buildAccountInfoRow(
                          'Last Sign In',
                          state.user?.lastSignInAt ?? 'Unknown',
                          Icons.login,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Actions
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal[600],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Close'),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildAccountInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.teal[600], size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
