import '../repositories/auth_repository.dart';

/// Verify Password Recovery OTP UseCase
///
/// Verifies the 6-digit OTP code and establishes a recovery session.
/// After successful verification, user can set a new password.
class VerifyPasswordOtpUseCase {
  final AuthRepository _repository;

  const VerifyPasswordOtpUseCase(this._repository);

  /// Execute the verify OTP flow
  ///
  /// [email] - The email address that received the OTP
  /// [token] - The 6-digit OTP code entered by user
  ///
  /// Throws exception if OTP is invalid or expired.
  Future<void> execute({
    required String email,
    required String token,
  }) async {
    // Validate inputs
    if (email.isEmpty) {
      throw Exception('Email is required');
    }

    if (token.isEmpty) {
      throw Exception('OTP code is required');
    }

    // OTP should be 6 digits
    if (token.length != 6 || !RegExp(r'^\d{6}$').hasMatch(token)) {
      throw Exception('Invalid OTP format. Please enter 6 digits.');
    }

    await _repository.verifyPasswordRecoveryOtp(
      email: email.trim(),
      token: token,
    );
  }
}
