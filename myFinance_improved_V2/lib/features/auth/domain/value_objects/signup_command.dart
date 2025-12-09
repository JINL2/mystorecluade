// lib/features/auth/domain/value_objects/signup_command.dart

/// Command pattern for signup operation.
///
/// Simple input data value object - no entity dependencies.
/// Note: firstName and lastName are optional - they will be collected
/// on the Complete Profile page after OTP verification.
class SignupCommand {
  final String email;
  final String password;
  final String? firstName;
  final String? lastName;

  const SignupCommand({
    required this.email,
    required this.password,
    this.firstName,
    this.lastName,
  });

  @override
  String toString() {
    return 'SignupCommand(email: $email, firstName: $firstName, lastName: $lastName)';
  }
}
