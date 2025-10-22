import 'package:flutter/material.dart';
import 'package:subscription_splitter_app/features/user_features/presentation/signup/cubit/cubit.dart';
import 'package:subscription_splitter_app/features/user_features/presentation/signup/widgets/signup_body.dart';

/// {@template signup_page}
/// A description for SignupPage
/// {@endtemplate}
class SignupPage extends StatelessWidget {
  /// {@macro signup_page}
  const SignupPage({super.key});

  /// The static route for SignupPage
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(builder: (_) => const SignupPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignupCubit(),
      child: const Scaffold(
        body: SignupView(),
      ),
    );
  }    
}

/// {@template signup_view}
/// Displays the Body of SignupView
/// {@endtemplate}
class SignupView extends StatelessWidget {
  /// {@macro signup_view}
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SignupBody();
  }
}
