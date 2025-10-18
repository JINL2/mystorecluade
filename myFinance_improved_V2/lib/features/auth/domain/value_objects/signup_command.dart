// lib/features/auth/domain/value_objects/signup_command.dart

/// Command pattern for signup operation.
///
/// Simple input data value object - no entity dependencies.
class SignupCommand {
  final String email;
  final String password;
  final String firstName;
  final String lastName;

  const SignupCommand({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });

  @override
  String toString() {
    return 'SignupCommand(email: $email, firstName: $firstName, lastName: $lastName)';
  }
}
