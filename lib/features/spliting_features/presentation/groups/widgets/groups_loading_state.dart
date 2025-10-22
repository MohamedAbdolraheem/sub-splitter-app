import 'package:flutter/material.dart';
import 'package:subscription_splitter_app/core/theme/app_colors.dart';

/// {@template groups_loading_state}
/// Widget to display while groups are loading
/// {@endtemplate}
class GroupsLoadingState extends StatelessWidget {
  /// {@macro groups_loading_state}
  const GroupsLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppColors.primary),
            SizedBox(height: 16),
            Text(
              'Loading groups...',
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
