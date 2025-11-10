// lib/features/auth/data/datasources/supabase_auth_datasource.dart

import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import '../../domain/entities/user_entity.dart';
import '../../domain/exceptions/auth_exceptions.dart' as domain;
import '../../domain/exceptions/validation_exception.dart';

/// Supabase Auth DataSource (Refactored with Freezed Entity)
///
/// 🚚 배달 기사 - Supabase Auth API와 직접 통신하는 계층
///
/// 🎯 Improvements:
/// - Uses Freezed User entity directly (no UserModel needed)
/// - Simpler: User.fromJson() instead of UserModel.fromJson() → toEntity()
/// - Type-safe: Freezed guarantees JSON serialization
///
/// 책임:
/// - Supabase Auth API 호출 (signIn, signUp, signOut)
/// - Auth 응답 → User Entity 변환
/// - 인증 관련 에러 처리
///
/// 이 계층은 Supabase Auth에 대한 모든 지식을 가지고 있습니다.
/// Repository는 이 DataSource를 통해서만 인증 기능을 수행합니다.
abstract class AuthDataSource {
  /// Sign in with email and password
  ///
  /// Returns [User] entity if successful.
  /// Throws exception if credentials are invalid or network error occurs.
  Future<User> signIn({
    required String email,
    required String password,
  });

  /// Sign up with email and password
  ///
  /// Creates a new user account and returns [User] entity.
  /// Throws exception if email exists or validation fails.
  Future<User> signUp({
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
  /// Returns [User] entity if user is authenticated, null otherwise.
  Future<User?> getCurrentUser();
}

/// Supabase implementation of AuthDataSource
class SupabaseAuthDataSource implements AuthDataSource {
  final SupabaseClient _client;

  SupabaseAuthDataSource(this._client);

  @override
  Future<User> signIn({
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
        throw domain.InvalidCredentialsException();
      }

      // 2. Fetch user profile from database
      final userData = await _client
          .from('users')
          .select()
          .eq('user_id', response.user!.id)
          .maybeSingle();

      if (userData == null) {
        throw domain.UserNotFoundException(userId: response.user!.id);
      }

      // 3. Convert to User Entity (Freezed)
      return User.fromJson(userData);
    } on AuthException catch (e) {
      // Supabase Auth-specific exceptions (from Supabase)
      if (e.message.toLowerCase().contains('invalid login credentials') ||
          e.message.toLowerCase().contains('invalid_credentials')) {
        throw domain.InvalidCredentialsException();
      } else if (e.message.toLowerCase().contains('email not confirmed')) {
        throw domain.EmailNotVerifiedException();
      } else if (e.message.toLowerCase().contains('network')) {
        throw domain.NetworkException(details: e.message);
      }
      throw domain.NetworkException(details: 'Authentication failed: ${e.message}');
    } on PostgrestException catch (e) {
      // Database-specific exceptions
      throw domain.NetworkException(details: 'Database error: ${e.message}');
    } on domain.AuthException catch (e) {
      // Re-throw domain exceptions
      rethrow;
    } catch (e) {
      // Unknown errors
      throw domain.NetworkException(details: 'Unexpected sign in error: $e');
    }
  }

  @override
  Future<User> signUp({
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
        throw domain.NetworkException(details: 'Sign up failed - no user returned');
      }

      // 2. Create user profile in users table
      final now = DateTime.now().toUtc();
      // Use default timezone for Vietnam
      // In the future, this can be detected from device settings or user preferences
      final timezone = 'Asia/Ho_Chi_Minh';

      final user = User(
        id: response.user!.id,
        email: email,
        firstName: firstName,
        lastName: lastName,
        timezone: timezone,
        createdAt: now,
        updatedAt: now,
      );

      try {
        // Use UPSERT to handle case where row already exists (e.g., created by trigger or elsewhere)
        await _client.from('users').upsert(
          user.toInsertMap(),
          onConflict: 'user_id',
        );
      } catch (e) {
        // CRITICAL: Profile creation failed but auth user exists
        // Rollback by deleting the auth user to maintain consistency
        try {
          await _client.auth.signOut();
          // Note: Supabase doesn't provide user deletion via client SDK
          // This would need to be handled by a backend function or manual cleanup
          print('⚠️ WARNING: Auth user created but profile failed. User: ${response.user!.id}');
        } catch (rollbackError) {
          print('🚨 CRITICAL: Failed to rollback auth user creation: $rollbackError');
        }

        // Throw domain exception with context
        throw domain.NetworkException(
          details: 'Failed to create user profile. Please contact support. User ID: ${response.user!.id}',
        );
      }

      // 3. Return User Entity
      return user;
    } on AuthException catch (e) {
      // Supabase Auth-specific exceptions (from Supabase SDK)
      if (e.message.toLowerCase().contains('user already registered') ||
          e.message.toLowerCase().contains('already exists')) {
        throw domain.EmailAlreadyExistsException(email: email);
      } else if (e.message.toLowerCase().contains('password') &&
          e.message.toLowerCase().contains('weak')) {
        throw domain.WeakPasswordException(['Password is too weak']);
      } else if (e.message.toLowerCase().contains('invalid email')) {
        throw ValidationException('Invalid email format');
      }
      throw domain.NetworkException(details: 'Sign up failed: ${e.message}');
    } on PostgrestException catch (e) {
      throw domain.NetworkException(details: 'Database error during sign up: ${e.message}');
    } on domain.AuthException catch (e) {
      // Re-throw domain exceptions
      rethrow;
    } catch (e) {
      throw domain.NetworkException(details: 'Unexpected sign up error: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } on AuthException catch (e) {
      throw domain.NetworkException(details: 'Sign out failed: ${e.message}');
    } catch (e) {
      throw domain.NetworkException(details: 'Unexpected sign out error: $e');
    }
  }

  @override
  Future<User?> getCurrentUser() async {
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

      return User.fromJson(userData);
    } catch (e) {
      rethrow;
    }
  }
}
