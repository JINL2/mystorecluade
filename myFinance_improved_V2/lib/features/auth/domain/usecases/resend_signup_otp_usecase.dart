import '../repositories/auth_repository.dart';

/// Resend Signup OTP UseCase
///
/// Resends the 6-digit OTP code for email verification after signup.
/// Used when the user didn't receive the original code or it expired.
class ResendSignupOtpUseCase {
  final AuthRepository _repository;

  const ResendSignupOtpUseCase(this._repository);

  /// Execute the resend OTP flow
  ///
  /// [email] - The email address to resend the OTP code to
  ///
  /// Throws exception if email is invalid or network error occurs.
  Future<void> execute({
    required String email,
  }) async {
    // Validate email format
    if (email.isEmpty) {
      throw Exception('Email is required');
    }

    if (!_isValidEmail(email)) {
      throw Exception('Invalid email format');
    }

    await _repository.resendSignupOtp(
      email: email.trim(),
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
