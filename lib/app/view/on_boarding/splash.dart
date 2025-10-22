import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:subscription_splitter_app/core/router/screens.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// {@template splash_screen}
/// Splash screen for the Subscription Splitter app
/// {@endtemplate}
class SplashScreen extends StatefulWidget {
  /// {@macro splash_screen}
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
      ),
    );

    // Start animations
    _animationController.forward();

    // Navigate after delay
    Timer(const Duration(seconds: 3), _navigateToNextScreen);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _navigateToNextScreen() {
    if (mounted) {
      // Check if user is authenticated
      final supabase = Supabase.instance.client;
      final session = supabase.auth.currentSession;

      if (session != null) {
        // User is authenticated, go to home
        context.go(Screens.homeDashboard.path);
      } else {
        // User is not authenticated, go to login
        context.go(Screens.login.path);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0.8),
              Theme.of(context).colorScheme.secondary,
            ],
          ),
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated App Icon
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.account_balance_wallet,
                            size: 80,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Animated App Name
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: const Text(
                        'Subscription Splitter',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Animated Tagline
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: const Text(
                        'Split expenses, share subscriptions',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                          fontWeight: FontWeight.w300,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 80),

                    // Animated Loading Indicator
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        children: [
                          SizedBox(
                            width: 40,
                            height: 40,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Loading...',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Version info at bottom
                    const Spacer(),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 32),
                        child: Text(
                          'Version 1.0.0',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.6),
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
