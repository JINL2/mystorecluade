// lib/features/auth/domain/usecases/logout_usecase.dart

import '../repositories/auth_repository.dart';

/// Logout use case.
///
/// Simple use case for logging out the current user.
class LogoutUseCase {
  final AuthRepository _authRepository;

  const LogoutUseCase({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  Future<void> execute() async {
    await _authRepository.logout();
  }
}
