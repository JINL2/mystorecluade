// lib/features/auth/data/datasources/supabase_auth_datasource.dart

import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;

import '../../../../core/monitoring/sentry_config.dart';
import '../../../../core/utils/datetime_utils.dart';
import '../models/freezed/user_dto.dart';

/// Google OAuth Client IDs
const String _webClientId =
    '752488262590-9g4kfg64jn77bn0lt969ufol54sgar2g.apps.googleusercontent.com';
const String _iosClientId =
    '752488262590-rlnbhkifa8g3ltmsq3su14f9ih22i6f6.apps.googleusercontent.com';

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

  /// Update user password
  ///
  /// Updates the password for the currently authenticated user.
  /// User must be authenticated (via reset link) to call this.
  Future<void> updatePassword({
    required String newPassword,
  });

  /// Send OTP code for password recovery
  ///
  /// Sends a 6-digit OTP code to the email for password recovery.
  /// User enters this code in the app to verify their identity.
  Future<void> sendPasswordRecoveryOtp({
    required String email,
  });

  /// Verify OTP code and authenticate for password reset
  ///
  /// Verifies the OTP code and establishes a recovery session.
  /// After verification, user can set a new password.
  Future<void> verifyPasswordRecoveryOtp({
    required String email,
    required String token,
  });

  /// Resend signup confirmation OTP
  ///
  /// Resends the 6-digit OTP code to verify email after signup.
  Future<void> resendSignupOtp({
    required String email,
  });

  /// Verify signup OTP code
  ///
  /// Verifies the OTP code sent after signup to confirm email.
  /// Returns [UserDto] after successful verification.
  Future<UserDto> verifySignupOtp({
    required String email,
    required String token,
  });

  /// Sign in with Google
  ///
  /// Uses native Google Sign-In and authenticates with Supabase using ID token.
  /// Returns [UserDto] after successful authentication.
  Future<UserDto> signInWithGoogle();

  /// Sign in with Apple
  ///
  /// Uses native Apple Sign-In and authenticates with Supabase using ID token.
  /// Returns [UserDto] after successful authentication.
  Future<UserDto> signInWithApple();
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
      // Note: firstName/lastName may be null - user will set them on Complete Profile page
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {
          if (firstName != null) 'first_name': firstName,
          if (lastName != null) 'last_name': lastName,
          if (firstName != null || lastName != null)
            'full_name': '${firstName ?? ''} ${lastName ?? ''}'.trim(),
        },
      );

      if (response.user == null) {
        throw Exception('Sign up failed - no user returned');
      }

      // ✅ Check if email already exists (Supabase returns user with empty identities)
      // When email already exists, Supabase doesn't throw error for security reasons
      // But we can detect it by checking if identities is empty
      final identities = response.user!.identities;
      if (identities == null || identities.isEmpty) {
        throw Exception('This email is already registered. Please sign in instead.');
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
      // Note: firstName/lastName may be null - user will set them on Complete Profile page
      final now = DateTimeUtils.nowUtc();
      const timezone = 'Asia/Ho_Chi_Minh';

      final userModel = UserDto(
        userId: response.user!.id,
        email: email,
        firstName: firstName, // May be null - will be set on Complete Profile
        lastName: lastName,   // May be null - will be set on Complete Profile
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

  @override
  Future<void> updatePassword({
    required String newPassword,
  }) async {
    try {
      await _client.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } catch (e) {
      throw Exception('Failed to update password: $e');
    }
  }

  @override
  Future<void> sendPasswordRecoveryOtp({
    required String email,
  }) async {
    try {
      // Send OTP code for password recovery
      // shouldCreateUser: false ensures we only send to existing users
      await _client.auth.signInWithOtp(
        email: email,
        shouldCreateUser: false,
      );
    } catch (e) {
      throw Exception('Failed to send OTP code: $e');
    }
  }

  @override
  Future<void> verifyPasswordRecoveryOtp({
    required String email,
    required String token,
  }) async {
    try {
      // Verify OTP and establish recovery session
      final response = await _client.auth.verifyOTP(
        email: email,
        token: token,
        type: OtpType.email,
      );

      if (response.session == null) {
        throw Exception('OTP verification failed - no session returned');
      }
    } catch (e) {
      throw Exception('Failed to verify OTP code: $e');
    }
  }

  @override
  Future<void> resendSignupOtp({
    required String email,
  }) async {
    try {
      await _client.auth.resend(
        type: OtpType.signup,
        email: email,
      );
    } catch (e) {
      throw Exception('Failed to resend signup OTP: $e');
    }
  }

  @override
  Future<UserDto> verifySignupOtp({
    required String email,
    required String token,
  }) async {
    try {
      // Verify OTP and confirm email
      final response = await _client.auth.verifyOTP(
        email: email,
        token: token,
        type: OtpType.signup,
      );

      if (response.user == null) {
        throw Exception('Email verification failed - no user returned');
      }

      // Fetch user profile from database
      final userData = await _client
          .from('users')
          .select()
          .eq('user_id', response.user!.id)
          .maybeSingle();

      if (userData == null) {
        throw Exception('User profile not found after verification');
      }

      return UserDto.fromJson(userData);
    } catch (e) {
      throw Exception('Failed to verify email: $e');
    }
  }

  @override
  Future<UserDto> signInWithGoogle() async {
    try {
      // 1. Initialize Google Sign-In with client IDs
      await GoogleSignIn.instance.initialize(
        clientId: _iosClientId,
        serverClientId: _webClientId,
      );

      // 2. Trigger native Google Sign-In flow
      final googleAccount = await GoogleSignIn.instance.authenticate();

      // 3. Get authentication result
      final idToken = googleAccount.authentication.idToken;

      if (idToken == null) {
        throw Exception('Google Sign-In failed - no ID token');
      }

      // 4. Sign in to Supabase with ID token
      final response = await _client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
      );

      if (response.user == null) {
        throw Exception('Supabase authentication failed - no user returned');
      }

      // 5. Wait briefly for trigger to complete (if new user)
      await Future.delayed(const Duration(milliseconds: 100));

      // 6. Extract name and photo from Google account
      final nameParts = googleAccount.displayName?.split(' ') ?? [];
      final googleFirstName = nameParts.isNotEmpty ? nameParts.first : null;
      final googleLastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : null;
      final googlePhotoUrl = googleAccount.photoUrl;

      // 7. Fetch or create user profile
      final userData = await _client
          .from('users')
          .select()
          .eq('user_id', response.user!.id)
          .maybeSingle();

      if (userData != null) {
        // ✅ User exists - check if we need to update with Google data
        final existingFirstName = userData['first_name'] as String?;
        final existingProfileImage = userData['profile_image'] as String?;

        // Update if first_name is NULL or profile_image is NULL
        if ((existingFirstName == null || existingFirstName.isEmpty) ||
            (existingProfileImage == null && googlePhotoUrl != null)) {
          final updates = <String, dynamic>{
            'updated_at': DateTimeUtils.nowUtc(),
          };

          // Update name if missing
          if (existingFirstName == null || existingFirstName.isEmpty) {
            if (googleFirstName != null) updates['first_name'] = googleFirstName;
            if (googleLastName != null) updates['last_name'] = googleLastName;
          }

          // Update profile image if missing
          if (existingProfileImage == null && googlePhotoUrl != null) {
            updates['profile_image'] = googlePhotoUrl;
          }

          if (updates.length > 1) {
            await _client
                .from('users')
                .update(updates)
                .eq('user_id', response.user!.id);

            // Fetch updated data
            final updatedData = await _client
                .from('users')
                .select()
                .eq('user_id', response.user!.id)
                .single();
            return UserDto.fromJson(updatedData);
          }
        }

        return UserDto.fromJson(userData);
      }

      // ⚠️ New user from Google - create profile manually
      // Database trigger should handle this, but fallback just in case
      final now = DateTimeUtils.nowUtc();
      const timezone = 'Asia/Ho_Chi_Minh';

      final userModel = UserDto(
        userId: response.user!.id,
        email: googleAccount.email,
        firstName: googleFirstName ?? 'User',
        lastName: googleLastName ?? 'Name',
        profileImage: googlePhotoUrl,
        preferredTimezone: timezone,
        createdAt: now,
        updatedAt: now,
      );

      try {
        await _client.from('users').upsert(
          userModel.toJson(),
          onConflict: 'user_id',
        );

        return userModel;
      } catch (e, stackTrace) {
        // Log to Sentry but still return the user
        await SentryConfig.captureException(
          e,
          stackTrace,
          hint: 'Google Sign-In: User profile creation failed',
          extra: {
            'user_id': response.user!.id,
            'email': googleAccount.email,
            'context': 'google_signin_profile_creation',
          },
        );

        return userModel;
      }
    } on Exception catch (e) {
      throw Exception('Failed to sign in with Google: $e');
    }
  }

  @override
  Future<UserDto> signInWithApple() async {
    try {
      // 1. Generate a secure random nonce for Apple Sign-In
      final rawNonce = _generateNonce();
      final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

      // 2. Request Apple Sign-In credentials
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce,
      );

      final idToken = credential.identityToken;
      if (idToken == null) {
        throw Exception('Apple Sign-In failed - no ID token');
      }

      // 3. Sign in to Supabase with Apple ID token
      final response = await _client.auth.signInWithIdToken(
        provider: OAuthProvider.apple,
        idToken: idToken,
        nonce: rawNonce,
      );

      if (response.user == null) {
        throw Exception('Supabase authentication failed - no user returned');
      }

      // 4. Wait briefly for trigger to complete (if new user)
      await Future.delayed(const Duration(milliseconds: 100));

      // 5. Get email from Apple credential or Supabase user
      // Note: Apple only provides email on first sign-in, fallback to Supabase user email
      final email = credential.email ?? response.user!.email ?? '';

      // 6. Fetch or create user profile
      // ⚠️ IMPORTANT: We do NOT save Apple's name automatically
      // User will enter their name on the Complete Profile page
      // This ensures consistent flow with email signup
      final userData = await _client
          .from('users')
          .select()
          .eq('user_id', response.user!.id)
          .maybeSingle();

      if (userData != null) {
        // ✅ User exists - return existing data
        // Router will redirect to Complete Profile if first_name is NULL
        return UserDto.fromJson(userData);
      }

      // ⚠️ New user from Apple - create profile with NULL name
      // User will complete their profile on Complete Profile page
      final now = DateTimeUtils.nowUtc();
      const timezone = 'Asia/Ho_Chi_Minh';

      final userModel = UserDto(
        userId: response.user!.id,
        email: email,
        firstName: null, // Will be set on Complete Profile page
        lastName: null,  // Will be set on Complete Profile page
        preferredTimezone: timezone,
        createdAt: now,
        updatedAt: now,
      );

      try {
        await _client.from('users').upsert(
          userModel.toJson(),
          onConflict: 'user_id',
        );

        return userModel;
      } catch (e, stackTrace) {
        // Log to Sentry but still return the user
        await SentryConfig.captureException(
          e,
          stackTrace,
          hint: 'Apple Sign-In: User profile creation failed',
          extra: {
            'user_id': response.user!.id,
            'email': email,
            'context': 'apple_signin_profile_creation',
          },
        );

        return userModel;
      }
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        throw Exception('Apple Sign-In was cancelled');
      }
      throw Exception('Failed to sign in with Apple: ${e.message}');
    } on Exception catch (e) {
      throw Exception('Failed to sign in with Apple: $e');
    }
  }

  /// Generate a secure random nonce for Apple Sign-In
  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }
}
