import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient _supabase;

  AuthRepositoryImpl({required SupabaseClient supabase}) : _supabase = supabase;

  @override
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: metadata,
      );
      return response;
    } on AuthException catch (e) {
      throw AuthenticationFailure(
        message: e.message,
        statusCode: int.tryParse(e.statusCode ?? '0'),
      );
    } catch (e) {
      throw UnknownFailure(message: e.toString());
    }
  }

  @override
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } on AuthException catch (e) {
      throw AuthenticationFailure(
        message: e.message,
        statusCode: int.tryParse(e.statusCode ?? '0'),
      );
    } catch (e) {
      throw UnknownFailure(message: e.toString());
    }
  }

  @override
  Future<bool> signInWithGoogle() async {
    try {
      final result = await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        // Don't specify redirectTo - let Supabase handle it
      );
      return result;
    } on AuthException catch (e) {
      throw AuthenticationFailure(
        message: e.message,
        statusCode: int.tryParse(e.statusCode ?? '0'),
      );
    } catch (e) {
      throw UnknownFailure(message: e.toString());
    }
  }

  @override
  Future<bool> signInWithApple() async {
    try {
      final result = await _supabase.auth.signInWithOAuth(
        OAuthProvider.apple,
        // Don't specify redirectTo - let Supabase handle it
      );
      return result;
    } on AuthException catch (e) {
      throw AuthenticationFailure(
        message: e.message,
        statusCode: int.tryParse(e.statusCode ?? '0'),
      );
    } catch (e) {
      throw UnknownFailure(message: e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } on AuthException catch (e) {
      throw AuthenticationFailure(
        message: e.message,
        statusCode: int.tryParse(e.statusCode ?? '0'),
      );
    } catch (e) {
      throw UnknownFailure(message: e.toString());
    }
  }

  @override
  Session? get currentSession => _supabase.auth.currentSession;

  @override
  User? get currentUser => _supabase.auth.currentUser;

  @override
  bool get isSignedIn => _supabase.auth.currentSession != null;

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } on AuthException catch (e) {
      throw AuthenticationFailure(
        message: e.message,
        statusCode: int.tryParse(e.statusCode ?? '0'),
      );
    } catch (e) {
      throw UnknownFailure(message: e.toString());
    }
  }

  @override
  Future<AuthResponse> updatePassword(String newPassword) async {
    try {
      final response = await _supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );
      // UserResponse doesn't have session, so we create a minimal AuthResponse
      return AuthResponse(
        user: response.user,
        session: _supabase.auth.currentSession,
      );
    } on AuthException catch (e) {
      throw AuthenticationFailure(
        message: e.message,
        statusCode: int.tryParse(e.statusCode ?? '0'),
      );
    } catch (e) {
      throw UnknownFailure(message: e.toString());
    }
  }

  @override
  Future<User> updateProfile({
    String? displayName,
    String? avatarUrl,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final response = await _supabase.auth.updateUser(
        UserAttributes(data: metadata),
      );
      return response.user!;
    } on AuthException catch (e) {
      throw AuthenticationFailure(
        message: e.message,
        statusCode: int.tryParse(e.statusCode ?? '0'),
      );
    } catch (e) {
      throw UnknownFailure(message: e.toString());
    }
  }

  @override
  Future<AuthResponse> refreshSession() async {
    try {
      final response = await _supabase.auth.refreshSession();
      return response;
    } on AuthException catch (e) {
      throw AuthenticationFailure(
        message: e.message,
        statusCode: int.tryParse(e.statusCode ?? '0'),
      );
    } catch (e) {
      throw UnknownFailure(message: e.toString());
    }
  }

  @override
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;
}
