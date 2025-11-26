// lib/features/cash_ending/domain/repositories/auth_repository.dart

/// Repository interface for Authentication operations (Domain Layer)
///
/// This is the contract that data layer must implement.
/// NO dependencies on infrastructure or external libraries.
abstract class AuthRepository {
  /// Get current authenticated user ID
  ///
  /// Returns the user ID if authenticated
  /// Returns null if not authenticated
  String? getCurrentUserId();

  /// Check if user is authenticated
  ///
  /// Returns true if user is logged in
  bool isAuthenticated();
}
