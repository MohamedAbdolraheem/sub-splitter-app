import 'package:flutter/material.dart';
import 'package:subscription_splitter_app/features/user_features/presentation/signup/widgets/signup_form.dart';

/// {@template signup_body}
/// Body of the SignupPage.
///
/// Add what it does
/// {@endtemplate}
class SignupBody extends StatelessWidget {
  /// {@macro signup_body}
  const SignupBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: const SignupForm(),
        ),
      ),
    );
  }
}
