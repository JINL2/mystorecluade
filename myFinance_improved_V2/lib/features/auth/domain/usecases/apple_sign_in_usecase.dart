// lib/features/auth/domain/usecases/apple_sign_in_usecase.dart

import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Apple Sign-In use case.
///
/// Orchestrates the Apple Sign-In process.
/// Simpler than email login - no validation needed as Apple handles it.
class AppleSignInUseCase {
  final AuthRepository _authRepository;

  const AppleSignInUseCase({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  /// Execute Apple Sign-In
  ///
  /// Returns [User] if successful.
  /// Throws exceptions for error cases:
  /// - [Exception] if user cancelled or sign-in failed
  /// - [NetworkException] for network errors
  Future<User> execute() async {
    return _authRepository.signInWithApple();
  }
}
