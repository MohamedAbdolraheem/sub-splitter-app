import 'package:flutter/material.dart';
import 'package:subscription_splitter_app/features/user_features/presentation/login/widgets/login_form.dart';

/// {@template login_body}
/// Body of the LoginPage with modern gradient background and responsive design.
/// {@endtemplate}
class LoginBody extends StatelessWidget {
  /// {@macro login_body}
  const LoginBody({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.surface,
              colorScheme.surfaceContainerHighest.withOpacity(0.3),
              colorScheme.primary.withOpacity(0.05),
            ],
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Responsive padding based on screen size
              final horizontalPadding =
                  constraints.maxWidth > 600 ? 48.0 : 24.0;
              final verticalPadding = constraints.maxHeight > 800 ? 32.0 : 16.0;

              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: verticalPadding,
                ),
                child: const LoginForm(),
              );
            },
          ),
        ),
      ),
    );
  }
}
