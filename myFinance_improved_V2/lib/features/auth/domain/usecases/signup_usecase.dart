// lib/features/auth/domain/usecases/signup_usecase.dart

import '../entities/user_entity.dart';
import '../exceptions/auth_exceptions.dart';
import '../exceptions/validation_exception.dart';
import '../repositories/auth_repository.dart';
import '../validators/email_validator.dart';
import '../validators/name_validator.dart';
import '../validators/password_validator.dart';
import '../value_objects/signup_command.dart';

/// Signup use case.
///
/// Handles user registration with validation.
/// Throws exceptions for error cases - no Result pattern wrapper.
///
/// Note: Name fields are optional - they will be collected on the
/// Complete Profile page after OTP verification.
class SignupUseCase {
  final AuthRepository _authRepository;

  const SignupUseCase({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  /// Execute signup
  ///
  /// Returns [User] if successful.
  /// Throws exceptions for error cases:
  /// - [ValidationException] for invalid input
  /// - [EmailAlreadyExistsException] if email exists
  /// - [WeakPasswordException] if password is weak
  /// - [NetworkException] for network errors
  Future<User> execute(SignupCommand command) async {
    // Step 1: Validate email
    final emailError = EmailValidator.validate(command.email);
    if (emailError != null) {
      throw ValidationException(emailError);
    }

    // Step 2: Validate password
    final passwordResult = PasswordValidator.validate(command.password);
    if (!passwordResult.isValid) {
      throw ValidationException(passwordResult.errors.first);
    }

    // Step 3: Validate names (only if provided)
    if (command.firstName != null && command.firstName!.isNotEmpty) {
      final firstNameError = NameValidator.validate(
        command.firstName!,
        fieldName: 'First name',
      );
      if (firstNameError != null) {
        throw ValidationException(firstNameError);
      }
    }

    if (command.lastName != null && command.lastName!.isNotEmpty) {
      final lastNameError = NameValidator.validate(
        command.lastName!,
        fieldName: 'Last name',
      );
      if (lastNameError != null) {
        throw ValidationException(lastNameError);
      }
    }

    // Step 4: Create account
    final user = await _authRepository.signUp(
      email: command.email.trim(),
      password: command.password,
      firstName: command.firstName?.trim(),
      lastName: command.lastName?.trim(),
    );

    return user;
  }
}
