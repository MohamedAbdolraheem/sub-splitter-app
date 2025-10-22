import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:subscription_splitter_app/core/extensions/translation_extension.dart';
import 'package:subscription_splitter_app/features/user_features/presentation/signup/cubit/cubit.dart';

class SignupForm extends StatelessWidget {
  const SignupForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupCubit, SignupState>(
      listener: (context, state) {
        if (state.status == SignupStatus.success) {
          context.go('/');
        } else if (state.status == SignupStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? context.tr.signupFailed),
            ),
          );
        }
      },
      builder: (context, state) {
        final formKey = GlobalKey<FormState>();

        return Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo/Title
              const Icon(
                Icons.account_balance_wallet,
                size: 80,
                color: Colors.blue,
              ),
              const SizedBox(height: 16),
              Text(
                context.tr.signup,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                context.tr.appTagline,
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Name Field
              TextFormField(
                initialValue: state.name,
                decoration: InputDecoration(
                  labelText: context.tr.name,
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return context.tr.required;
                  }
                  if (value.length < 2) {
                    return context.tr.nameTooShort;
                  }
                  return null;
                },
                onChanged: (value) {
                  context.read<SignupCubit>().updateName(value);
                },
              ),
              const SizedBox(height: 16),

              // Email Field
              TextFormField(
                initialValue: state.email,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: context.tr.email,
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return context.tr.required;
                  }
                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(value)) {
                    return context.tr.emailInvalid;
                  }
                  return null;
                },
                onChanged: (value) {
                  context.read<SignupCubit>().updateEmail(value);
                },
              ),
              const SizedBox(height: 16),

              // Password Field
              TextFormField(
                initialValue: state.password,
                obscureText: state.obscurePassword,
                decoration: InputDecoration(
                  labelText: context.tr.password,
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      state.obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      context.read<SignupCubit>().togglePasswordVisibility();
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return context.tr.required;
                  }
                  if (value.length < 6) {
                    return context.tr.passwordTooShort;
                  }
                  return null;
                },
                onChanged: (value) {
                  context.read<SignupCubit>().updatePassword(value);
                },
              ),
              const SizedBox(height: 16),

              // Confirm Password Field
              TextFormField(
                initialValue: state.confirmPassword,
                obscureText: state.obscureConfirmPassword,
                decoration: InputDecoration(
                  labelText: context.tr.confirmPassword,
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      state.obscureConfirmPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      context
                          .read<SignupCubit>()
                          .toggleConfirmPasswordVisibility();
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return context.tr.required;
                  }
                  if (value != state.password) {
                    return context.tr.passwordsDoNotMatch;
                  }
                  return null;
                },
                onChanged: (value) {
                  context.read<SignupCubit>().updateConfirmPassword(value);
                },
              ),
              const SizedBox(height: 24),

              // Sign Up Button
              ElevatedButton(
                onPressed:
                    state.status == SignupStatus.loading
                        ? null
                        : () {
                          if (formKey.currentState!.validate()) {
                            context.read<SignupCubit>().signupWithEmail(
                              state.name,
                              state.email,
                              state.password,
                            );
                          }
                        },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child:
                    state.status == SignupStatus.loading
                        ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : Text(context.tr.signup),
              ),
              const SizedBox(height: 16),

              // Google Sign Up Button
              OutlinedButton.icon(
                onPressed:
                    state.status == SignupStatus.loading
                        ? null
                        : () {
                          context.read<SignupCubit>().signupWithGoogle();
                        },
                icon: const Icon(Icons.login, size: 20),
                label: Text(context.tr.signUpWithGoogle),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              const SizedBox(height: 24),

              // Sign In Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? "),
                  TextButton(
                    onPressed: () => context.go('/login'),
                    child: Text(context.tr.login),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
