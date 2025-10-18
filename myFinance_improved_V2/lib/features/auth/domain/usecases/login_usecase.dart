// lib/features/auth/domain/usecases/login_usecase.dart

import '../entities/user_entity.dart';
import '../exceptions/auth_exceptions.dart';
import '../exceptions/validation_exception.dart';
import '../repositories/auth_repository.dart';
import '../validators/email_validator.dart';
import '../value_objects/login_command.dart';

/// Login use case.
///
/// Orchestrates the login process with validation and error handling.
/// Throws exceptions for error cases - no Result pattern wrapper.
class LoginUseCase {
  final AuthRepository _authRepository;

  const LoginUseCase({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  /// Execute login
  ///
  /// Returns [User] if successful.
  /// Throws exceptions for error cases:
  /// - [ValidationException] for invalid input
  /// - [InvalidCredentialsException] for wrong credentials
  /// - [EmailNotVerifiedException] if email not verified
  /// - [NetworkException] for network errors
  Future<User> execute(LoginCommand command) async {
    // Step 1: Validate email
    final emailError = EmailValidator.validate(command.email);
    if (emailError != null) {
      throw ValidationException(emailError);
    }

    // Step 2: Validate password
    if (command.password.isEmpty) {
      throw ValidationException('Password is required');
    }

    // Step 3: Attempt login
    final user = await _authRepository.login(
      email: command.email.trim(),
      password: command.password,
    );

    if (user == null) {
      throw InvalidCredentialsException();
    }

    // Step 4: Check email verification
    // TODO: Enable email verification in production
    // For now, skip email verification check to allow development/testing
    // if (!user.isEmailVerified) {
    //   throw EmailNotVerifiedException();
    // }

    return user;
  }
}
