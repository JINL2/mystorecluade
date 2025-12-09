// lib/features/auth/domain/usecases/google_sign_in_usecase.dart

import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Google Sign-In use case.
///
/// Orchestrates the Google Sign-In process.
/// Simpler than email login - no validation needed as Google handles it.
class GoogleSignInUseCase {
  final AuthRepository _authRepository;

  const GoogleSignInUseCase({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  /// Execute Google Sign-In
  ///
  /// Returns [User] if successful.
  /// Throws exceptions for error cases:
  /// - [Exception] if user cancelled or sign-in failed
  /// - [NetworkException] for network errors
  Future<User> execute() async {
    return _authRepository.signInWithGoogle();
  }
}
