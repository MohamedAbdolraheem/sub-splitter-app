import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:subscription_splitter_app/features/user_features/presentation/profile/cubit/cubit.dart';
import 'package:subscription_splitter_app/features/user_features/presentation/profile_completion/widgets/profile_completion_form.dart';

/// {@template profile_completion_page}
/// A dedicated page for completing user profile with all required fields
/// {@endtemplate}
class ProfileCompletionPage extends StatelessWidget {
  /// {@macro profile_completion_page}
  const ProfileCompletionPage({super.key});

  /// The static route for ProfileCompletionPage
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(
      builder: (_) => const ProfileCompletionPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit()..loadProfile(),
      child: Scaffold(
        body: SafeArea(
          child: BlocConsumer<ProfileCubit, ProfileState>(
            listener: (context, state) {
              if (state.status == ProfileStatus.loaded &&
                  state.isProfileComplete) {
                // Profile is now complete, navigate back with result
                context.pop(
                  true,
                ); // Pass true to indicate profile was completed
              } else if (state.status == ProfileStatus.error) {
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
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ProfileState state) {
    switch (state.status) {
      case ProfileStatus.initial:
      case ProfileStatus.loading:
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading profile...'),
            ],
          ),
        );
      case ProfileStatus.loaded:
        return _buildProfileCompletionContent(context, state);
      case ProfileStatus.error:
        return _buildErrorContent(context, state);
    }
  }

  Widget _buildProfileCompletionContent(
    BuildContext context,
    ProfileState state,
  ) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header with gradient background
          _buildHeader(context),

          // Profile completion form
          const Padding(
            padding: EdgeInsets.all(24),
            child: ProfileCompletionForm(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Back button
            Row(
              children: [
                IconButton(
                  onPressed: () => context.pop(),
                  icon: Icon(Icons.arrow_back, color: Colors.white, size: 28),
                ),
                const Spacer(),
                Text(
                  'Complete Profile',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                const SizedBox(width: 48), // Balance the back button
              ],
            ),
            const SizedBox(height: 20),

            // Profile completion icon
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(
                Icons.person_add,
                size: 60,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 20),

            // Title and description
            Text(
              'Complete Your Profile',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Add your details to get the most out of Subscription Splitter',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white.withOpacity(0.9),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorContent(BuildContext context, ProfileState state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80, color: Colors.red[400]),
            const SizedBox(height: 24),
            Text(
              'Something went wrong',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.red[700],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              state.errorMessage ?? 'Unable to load profile information',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<ProfileCubit>().loadProfile();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Go Back'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
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
