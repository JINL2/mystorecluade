// lib/features/auth/data/datasources/supabase_auth_datasource.dart

import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import '../models/user_model.dart';

/// Supabase Auth DataSource
///
/// 🚚 배달 기사 - Supabase Auth API와 직접 통신하는 계층
///
/// 책임:
/// - Supabase Auth API 호출 (signIn, signUp, signOut)
/// - Auth 응답 → UserModel 변환
/// - 인증 관련 에러 처리
///
/// 이 계층은 Supabase Auth에 대한 모든 지식을 가지고 있습니다.
/// Repository는 이 DataSource를 통해서만 인증 기능을 수행합니다.
abstract class AuthDataSource {
  /// Sign in with email and password
  ///
  /// Returns [UserModel] if successful.
  /// Throws exception if credentials are invalid or network error occurs.
  Future<UserModel> signIn({
    required String email,
    required String password,
  });

  /// Sign up with email and password
  ///
  /// Creates a new user account and returns [UserModel].
  /// Throws exception if email exists or validation fails.
  Future<UserModel> signUp({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  });

  /// Sign out current user
  ///
  /// Clears the session and auth tokens.
  Future<void> signOut();

  /// Get current authenticated user
  ///
  /// Returns [UserModel] if user is authenticated, null otherwise.
  Future<UserModel?> getCurrentUser();
}

/// Supabase implementation of AuthDataSource
class SupabaseAuthDataSource implements AuthDataSource {
  final SupabaseClient _client;

  SupabaseAuthDataSource(this._client);

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      // 1. Authenticate with Supabase Auth
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('Sign in failed - no user returned');
      }

      // 2. Fetch user profile from database
      final userData = await _client
          .from('users')
          .select()
          .eq('user_id', response.user!.id)
          .maybeSingle();

      if (userData == null) {
        throw Exception('User profile not found');
      }

      // 3. Convert to UserModel
      return UserModel.fromJson(userData);
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  }) async {
    try {
      // 1. Sign up with Supabase Auth
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {
          'first_name': firstName ?? 'User',
          'last_name': lastName ?? 'Name',
          'full_name': '${firstName ?? 'User'} ${lastName ?? 'Name'}',
        },
      );

      if (response.user == null) {
        throw Exception('Sign up failed - no user returned');
      }

      // 2. Create user profile in users table
      final now = DateTime.now().toIso8601String();
      final userModel = UserModel(
        userId: response.user!.id,
        email: email,
        firstName: firstName,
        lastName: lastName,
        createdAt: now,
        updatedAt: now,
        isEmailVerified: false,
      );

      try {
        await _client.from('users').insert(userModel.toInsertMap());
      } catch (e) {
        // If profile creation fails, user is still created in auth
        // Log this critical error for monitoring
        print('🚨 ERROR: Failed to create user profile for ${response.user!.id}');
        print('Error: $e');
        // TODO: In production, use proper logging service (Sentry, Firebase Crashlytics)
        // TODO: Add retry queue or compensating transaction
      }

      // 3. Return UserModel
      return userModel;
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final session = _client.auth.currentSession;
      if (session == null) return null;

      final userId = session.user.id;

      // Fetch user profile from database
      final userData = await _client
          .from('users')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (userData == null) return null;

      return UserModel.fromJson(userData);
    } catch (e) {
      throw Exception('Failed to get current user: $e');
    }
  }
}
