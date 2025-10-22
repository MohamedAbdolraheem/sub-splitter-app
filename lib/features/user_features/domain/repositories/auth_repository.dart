import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRepository {
  // Authentication methods
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? metadata,
  });

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  });

  Future<bool> signInWithGoogle();

  Future<bool> signInWithApple();

  Future<void> signOut();

  // Session management
  Session? get currentSession;
  User? get currentUser;
  bool get isSignedIn;

  // Password management
  Future<void> resetPassword(String email);
  Future<AuthResponse> updatePassword(String newPassword);

  // Profile management
  Future<User> updateProfile({
    String? displayName,
    String? avatarUrl,
    Map<String, dynamic>? metadata,
  });

  // Session refresh
  Future<AuthResponse> refreshSession();

  // Auth state changes
  Stream<AuthState> get authStateChanges;
}
