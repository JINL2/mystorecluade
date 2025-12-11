// lib/features/auth/domain/repositories/auth_repository.dart

import '../entities/user_entity.dart';

/// Authentication repository interface.
///
/// This is defined in the domain layer as an abstract interface.
/// The actual implementation will be in the data layer.
/// This follows the Dependency Inversion Principle.
///
/// YAGNI Principle Applied: Only contains methods actually used by UseCases.
abstract class AuthRepository {
  /// Login with email and password
  ///
  /// Returns the authenticated [User] if successful, or `null` if credentials are invalid.
  /// Throws [AuthException] for other errors (network, server, etc.)
  Future<User?> login({
    required String email,
    required String password,
  });

  /// Sign up with email and password
  ///
  /// Returns the created [User].
  /// Throws [EmailAlreadyExistsException] if email exists.
  /// Throws [WeakPasswordException] if password is weak.
  /// Throws [AuthException] for other errors.
  Future<User> signUp({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  });

  /// Logout current user
  ///
  /// Clears the session and auth tokens.
  Future<void> logout();

  /// Update user password
  ///
  /// Updates the password for the currently authenticated user.
  /// User must be authenticated (via reset link or OTP) to call this.
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
  /// Returns [User] after successful verification.
  Future<User> verifySignupOtp({
    required String email,
    required String token,
  });

  /// Sign in with Google
  ///
  /// Uses native Google Sign-In and authenticates with Supabase.
  /// Returns [User] after successful authentication.
  Future<User> signInWithGoogle();

  /// Sign in with Apple
  ///
  /// Uses native Apple Sign-In and authenticates with Supabase.
  /// Returns [User] after successful authentication.
  Future<User> signInWithApple();
}
