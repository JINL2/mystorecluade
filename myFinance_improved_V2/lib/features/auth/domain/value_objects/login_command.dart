// lib/features/auth/domain/value_objects/login_command.dart

/// Command pattern for login operation.
///
/// This value object encapsulates all the data needed for a login operation.
/// Commands are simple input data - no business logic, no entity dependencies.
class LoginCommand {
  final String email;
  final String password;

  const LoginCommand({
    required this.email,
    required this.password,
  });

  @override
  String toString() {
    return 'LoginCommand(email: $email)';
  }
}
