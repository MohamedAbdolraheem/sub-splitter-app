import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:subscription_splitter_app/core/extensions/translation_extension.dart';
import 'package:subscription_splitter_app/core/router/screens.dart';
import 'package:subscription_splitter_app/features/user_features/presentation/login/cubit/cubit.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status == LoginStatus.success) {
          // Navigate to home on successful login
          context.go(Screens.homeDashboard.path);
        } else if (state.status == LoginStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? context.tr.loginFailed),
              backgroundColor: colorScheme.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        // Sync controllers with state only when needed
        if (_emailController.text != state.email) {
          _emailController.text = state.email;
          _emailController.selection = TextSelection.collapsed(
            offset: state.email.length,
          );
        }
        if (_passwordController.text != state.password) {
          _passwordController.text = state.password;
          _passwordController.selection = TextSelection.collapsed(
            offset: state.password.length,
          );
        }

        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: IntrinsicHeight(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),

                    // Logo Section
                    _buildLogoSection(colorScheme),
                    const SizedBox(height: 60),

                    // Form Section
                    _buildFormSection(context, state, colorScheme),
                    const SizedBox(height: 40),

                    // Social Login Section
                    _buildSocialLoginSection(context, state, colorScheme),
                    const SizedBox(height: 32),

                    // Sign Up Link
                    _buildSignUpLink(context, colorScheme),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLogoSection(ColorScheme colorScheme) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.primary,
                colorScheme.primary.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Icon(
            Icons.account_balance_wallet_rounded,
            size: 60,
            color: colorScheme.onPrimary,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          context.tr.welcome,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          context.tr.manageSubscriptions,
          style: TextStyle(
            fontSize: 16,
            color: colorScheme.onSurface.withOpacity(0.7),
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFormSection(
    BuildContext context,
    LoginState state,
    ColorScheme colorScheme,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Email Field
          _buildEmailField(context, state, colorScheme),
          const SizedBox(height: 20),

          // Password Field
          _buildPasswordField(context, state, colorScheme),
          const SizedBox(height: 8),

          // Forgot Password Link
          Align(
            alignment: Alignment.centerRight,
            child: Semantics(
              label: context.tr.forgotPassword,
              button: true,
              child: TextButton(
                onPressed: () {
                  // TODO: Implement forgot password
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(context.tr.comingSoon),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: Text(
                  context.tr.forgotPassword,
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Login Button
          _buildLoginButton(context, state, colorScheme),
        ],
      ),
    );
  }

  Widget _buildEmailField(
    BuildContext context,
    LoginState state,
    ColorScheme colorScheme,
  ) {
    return Semantics(
      label: 'Email address input field',
      hint: 'Enter your email address to sign in',
      textField: true,
      child: TextFormField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        autofillHints: const [AutofillHints.email],
        decoration: InputDecoration(
          labelText: 'Email Address',
          hintText: 'Enter your email',
          prefixIcon: Icon(Icons.email_outlined, color: colorScheme.primary),
          filled: true,
          fillColor: colorScheme.surfaceContainerHighest.withOpacity(0.3),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: colorScheme.outline.withOpacity(0.3),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.error, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.error, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your email';
          }
          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
            return 'Please enter a valid email address';
          }
          return null;
        },
        onChanged: (value) {
          context.read<LoginCubit>().updateEmail(value);
        },
      ),
    );
  }

  Widget _buildPasswordField(
    BuildContext context,
    LoginState state,
    ColorScheme colorScheme,
  ) {
    return Semantics(
      label: 'Password input field',
      hint: 'Enter your password to sign in',
      textField: true,
      child: TextFormField(
        controller: _passwordController,
        obscureText: state.obscurePassword,
        textInputAction: TextInputAction.done,
        autofillHints: const [AutofillHints.password],
        decoration: InputDecoration(
          labelText: 'Password',
          hintText: 'Enter your password',
          prefixIcon: Icon(Icons.lock_outline, color: colorScheme.primary),
          suffixIcon: Semantics(
            label: state.obscurePassword ? 'Show password' : 'Hide password',
            button: true,
            child: IconButton(
              icon: Icon(
                state.obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
              onPressed: () {
                context.read<LoginCubit>().togglePasswordVisibility();
              },
            ),
          ),
          filled: true,
          fillColor: colorScheme.surfaceContainerHighest.withOpacity(0.3),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: colorScheme.outline.withOpacity(0.3),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.error, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.error, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your password';
          }
          if (value.length < 6) {
            return 'Password must be at least 6 characters';
          }
          return null;
        },
        onChanged: (value) {
          context.read<LoginCubit>().updatePassword(value);
        },
      ),
    );
  }

  Widget _buildLoginButton(
    BuildContext context,
    LoginState state,
    ColorScheme colorScheme,
  ) {
    final isLoading = state.status == LoginStatus.loading;

    return SizedBox(
      height: 56,
      child: Semantics(
        label:
            isLoading ? 'Signing in, please wait' : 'Sign in to your account',
        button: true,
        enabled: !isLoading,
        child: ElevatedButton(
          onPressed:
              isLoading
                  ? null
                  : () {
                    if (_formKey.currentState!.validate()) {
                      context.read<LoginCubit>().loginWithEmail(
                        state.email,
                        state.password,
                      );
                    }
                  },
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            elevation: 0,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child:
              isLoading
                  ? SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        colorScheme.onPrimary,
                      ),
                    ),
                  )
                  : const Text(
                    'Sign In',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
        ),
      ),
    );
  }

  Widget _buildSocialLoginSection(
    BuildContext context,
    LoginState state,
    ColorScheme colorScheme,
  ) {
    return Column(
      children: [
        // Divider
        Row(
          children: [
            Expanded(
              child: Divider(
                color: colorScheme.outline.withOpacity(0.3),
                thickness: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'or continue with',
                style: TextStyle(
                  color: colorScheme.onSurface.withOpacity(0.6),
                  fontSize: 14,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: colorScheme.outline.withOpacity(0.3),
                thickness: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Google Sign In Button
        SizedBox(
          height: 56,
          child: Semantics(
            label: 'Sign in with Google',
            button: true,
            enabled: state.status != LoginStatus.loading,
            child: OutlinedButton.icon(
              onPressed:
                  state.status == LoginStatus.loading
                      ? null
                      : () {
                        context.read<LoginCubit>().loginWithGoogle();
                      },
              icon: Image.asset(
                'assets/images/google_logo.png',
                height: 20,
                width: 20,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.login,
                    size: 20,
                    color: colorScheme.primary,
                  );
                },
              ),
              label: const Text(
                'Continue with Google',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: colorScheme.onSurface,
                side: BorderSide(
                  color: colorScheme.outline.withOpacity(0.3),
                  width: 1,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpLink(BuildContext context, ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: TextStyle(
            color: colorScheme.onSurface.withOpacity(0.7),
            fontSize: 14,
          ),
        ),
        Semantics(
          label: 'Create a new account',
          button: true,
          child: TextButton(
            onPressed: () => context.go('/signup'),
            child: Text(
              'Sign Up',
              style: TextStyle(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
