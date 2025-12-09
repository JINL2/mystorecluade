import '../repositories/auth_repository.dart';

/// Send Password Recovery OTP UseCase
///
/// Sends a 6-digit OTP code to the specified email address for password recovery.
/// User enters this code in the app to verify their identity before resetting password.
class SendPasswordOtpUseCase {
  final AuthRepository _repository;

  const SendPasswordOtpUseCase(this._repository);

  /// Execute the send OTP flow
  ///
  /// [email] - The email address to send the OTP code to
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

    await _repository.sendPasswordRecoveryOtp(
      email: email.trim(),
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
