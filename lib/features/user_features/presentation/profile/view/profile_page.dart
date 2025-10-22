import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscription_splitter_app/core/extensions/translation_extension.dart';
import 'package:subscription_splitter_app/features/user_features/presentation/profile/cubit/cubit.dart';
import 'package:subscription_splitter_app/features/user_features/presentation/profile/widgets/profile_body.dart';

/// {@template profile_page}
/// A description for ProfilePage
/// {@endtemplate}
class ProfilePage extends StatelessWidget {
  /// {@macro profile_page}
  const ProfilePage({super.key});

  /// The static route for ProfilePage
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(builder: (_) => const ProfilePage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit()..loadProfile(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.tr.profileTitle),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                context.read<ProfileCubit>().refreshProfile();
              },
            ),
          ],
        ),
        body: const ProfileView(),
      ),
    );
  }
}

/// {@template profile_view}
/// Displays the Body of ProfileView
/// {@endtemplate}
class ProfileView extends StatelessWidget {
  /// {@macro profile_view}
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProfileBody();
  }
}
