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
}
