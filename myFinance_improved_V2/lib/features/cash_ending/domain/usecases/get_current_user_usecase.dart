// lib/features/cash_ending/domain/usecases/get_current_user_usecase.dart

import '../repositories/auth_repository.dart';

/// UseCase: Get current authenticated user ID
///
/// Business Logic:
/// - Get user ID from auth repository
/// - Validate that user is authenticated
/// - Return user ID or throw error if not authenticated
class GetCurrentUserUseCase {
  final AuthRepository _repository;

  GetCurrentUserUseCase(this._repository);

  /// Execute the use case
  ///
  /// Returns the current user ID
  /// Throws [StateError] if user is not authenticated
  String execute() {
    // Business Rule: User must be authenticated
    if (!_repository.isAuthenticated()) {
      throw StateError('User is not authenticated');
    }

    final userId = _repository.getCurrentUserId();

    // Business Rule: User ID must not be null
    if (userId == null || userId.isEmpty) {
      throw StateError('User ID is not available');
    }

    return userId;
  }

  /// Execute the use case (nullable version)
  ///
  /// Returns the current user ID or null if not authenticated
  String? executeOrNull() {
    if (!_repository.isAuthenticated()) {
      return null;
    }

    return _repository.getCurrentUserId();
  }
}
