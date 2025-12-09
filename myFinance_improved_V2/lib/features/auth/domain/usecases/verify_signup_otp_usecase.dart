import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Verify Signup OTP UseCase
///
/// Verifies the 6-digit OTP code sent to the user's email after signup.
/// This confirms the email address and completes the registration process.
class VerifySignupOtpUseCase {
  final AuthRepository _repository;

  const VerifySignupOtpUseCase(this._repository);

  /// Execute the verify OTP flow
  ///
  /// [email] - The email address that received the OTP
  /// [token] - The 6-digit OTP code entered by the user
  ///
  /// Returns [User] after successful verification.
  /// Throws exception if OTP is invalid, expired, or network error occurs.
  Future<User> execute({
    required String email,
    required String token,
  }) async {
    // Validate inputs
    if (email.isEmpty) {
      throw Exception('Email is required');
    }

    if (!_isValidEmail(email)) {
      throw Exception('Invalid email format');
    }

    if (token.isEmpty) {
      throw Exception('Verification code is required');
    }

    if (token.length != 6) {
      throw Exception('Verification code must be 6 digits');
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(token)) {
      throw Exception('Verification code must contain only numbers');
    }

    return _repository.verifySignupOtp(
      email: email.trim(),
      token: token.trim(),
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
