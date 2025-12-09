import '../repositories/auth_repository.dart';

/// Update Password UseCase
///
/// Updates the password for the currently authenticated user.
/// This is called after the user clicks the reset link in their email.
class UpdatePasswordUseCase {
  final AuthRepository _repository;

  const UpdatePasswordUseCase(this._repository);

  /// Execute the password update
  ///
  /// [newPassword] - The new password to set
  ///
  /// Throws exception if:
  /// - Password is too short (minimum 6 characters)
  /// - User is not authenticated
  /// - Network error occurs
  Future<void> execute({
    required String newPassword,
  }) async {
    // Validate password
    if (newPassword.isEmpty) {
      throw Exception('Password is required');
    }

    if (newPassword.length < 6) {
      throw Exception('Password must be at least 6 characters');
    }

    await _repository.updatePassword(
      newPassword: newPassword,
    );
  }
}
