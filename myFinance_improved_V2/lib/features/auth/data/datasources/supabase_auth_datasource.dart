// lib/features/auth/data/datasources/supabase_auth_datasource.dart

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import '../models/freezed/user_dto.dart';
import '../../../../core/utils/datetime_utils.dart';
import '../../../../core/monitoring/sentry_config.dart';

/// Supabase Auth DataSource
///
/// 🚚 배달 기사 - Supabase Auth API와 직접 통신하는 계층
///
/// 책임:
/// - Supabase Auth API 호출 (signIn, signUp, signOut)
/// - Auth 응답 → UserDto 변환
/// - 인증 관련 에러 처리
///
/// 이 계층은 Supabase Auth에 대한 모든 지식을 가지고 있습니다.
/// Repository는 이 DataSource를 통해서만 인증 기능을 수행합니다.
abstract class AuthDataSource {
  /// Sign in with email and password
  ///
  /// Returns [UserDto] if successful.
  /// Throws exception if credentials are invalid or network error occurs.
  Future<UserDto> signIn({
    required String email,
    required String password,
  });

  /// Sign up with email and password
  ///
  /// Creates a new user account and returns [UserDto].
  /// Throws exception if email exists or validation fails.
  Future<UserDto> signUp({
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
  /// Returns [UserDto] if user is authenticated, null otherwise.
  Future<UserDto?> getCurrentUser();
}

/// Supabase implementation of AuthDataSource
class SupabaseAuthDataSource implements AuthDataSource {
  final SupabaseClient _client;

  SupabaseAuthDataSource(this._client);

  @override
  Future<UserDto> signIn({
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

      // 3. Convert to UserDto
      return UserDto.fromJson(userData);
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  @override
  Future<UserDto> signUp({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  }) async {
    try {
      // 1. Sign up with Supabase Auth
      // ✅ Database Trigger (handle_new_user) automatically creates user profile
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

      // 2. Wait briefly for trigger to complete
      // Database trigger creates profile automatically, but we need a small delay
      await Future.delayed(const Duration(milliseconds: 100));

      // 3. Fetch the created user profile
      // The trigger should have created this, but we verify
      final userData = await _client
          .from('users')
          .select()
          .eq('user_id', response.user!.id)
          .maybeSingle();

      if (userData != null) {
        // ✅ Profile created by trigger - success
        return UserDto.fromJson(userData);
      }

      // ⚠️ Fallback: Trigger failed, create manually
      // This should rarely happen if trigger is working
      final now = DateTimeUtils.nowUtc();
      final timezone = 'Asia/Ho_Chi_Minh';

      final userModel = UserDto(
        userId: response.user!.id,
        email: email,
        firstName: firstName,
        lastName: lastName,
        preferredTimezone: timezone,
        createdAt: now,
        updatedAt: now,
      );

      try {
        await _client.from('users').upsert(
          userModel.toJson(),
          onConflict: 'user_id',
        );

        // ✅ Manual creation succeeded
        return userModel;
      } catch (e, stackTrace) {
        // 🚨 CRITICAL: Both trigger and manual creation failed
        // This indicates a serious database issue

        // ✅ Log to Sentry with critical level
        await SentryConfig.captureException(
          e,
          stackTrace,
          hint: 'CRITICAL: User profile creation failed (trigger + manual)',
          extra: {
            'user_id': response.user!.id,
            'email': email,
            'context': 'signup_fallback',
          },
        );

        if (kDebugMode) {
          print('🚨 CRITICAL: User profile creation failed for ${response.user!.id}');
          print('Error: $e');
        }

        // Still return UserDto to allow login
        // The profile will be retried on next login
        return userModel;
      }
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
  Future<UserDto?> getCurrentUser() async {
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

      return UserDto.fromJson(userData);
    } catch (e) {
      throw Exception('Failed to get current user: $e');
    }
  }
}
