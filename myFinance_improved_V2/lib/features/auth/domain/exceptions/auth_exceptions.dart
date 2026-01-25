// lib/features/auth/domain/exceptions/auth_exceptions.dart

/// Base class for all authentication exceptions
class AuthException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const AuthException(
    this.message, {
    this.code,
    this.originalError,
  });

  @override
  String toString() {
    final codeStr = code != null ? ' (code: $code)' : '';
    return 'AuthException: $message$codeStr';
  }
}

/// Email already exists in the system
class EmailAlreadyExistsException extends AuthException {
  const EmailAlreadyExistsException({String? email})
      : super(
          email != null
              ? 'Email "$email" already exists'
              : 'Email already exists',
          code: 'EMAIL_EXISTS',
        );
}

/// Invalid login credentials
class InvalidCredentialsException extends AuthException {
  const InvalidCredentialsException()
      : super(
          'Invalid email or password',
          code: 'INVALID_CREDENTIALS',
        );
}

/// Email not verified
class EmailNotVerifiedException extends AuthException {
  const EmailNotVerifiedException()
      : super(
          'Email not verified. Please check your inbox.',
          code: 'EMAIL_NOT_VERIFIED',
        );
}

/// Weak password (doesn't meet requirements)
class WeakPasswordException extends AuthException {
  final List<String> requirements;

  const WeakPasswordException(this.requirements)
      : super(
          'Password does not meet requirements',
          code: 'WEAK_PASSWORD',
        );

  @override
  String toString() {
    return 'WeakPasswordException: ${requirements.join(', ')}';
  }
}

/// Network error during authentication
class NetworkException extends AuthException {
  const NetworkException({String? details})
      : super(
          details != null
              ? 'Network error: $details'
              : 'Network error occurred',
          code: 'NETWORK_ERROR',
        );
}

/// Company name already exists for this owner
class CompanyNameExistsException extends AuthException {
  const CompanyNameExistsException({String? name})
      : super(
          name != null
              ? 'Company name "$name" already exists'
              : 'Company name already exists',
          code: 'COMPANY_NAME_EXISTS',
        );
}

/// Store code already exists in company
class StoreCodeExistsException extends AuthException {
  const StoreCodeExistsException({String? code})
      : super(
          code != null
              ? 'Store code "$code" already exists'
              : 'Store code already exists',
          code: 'STORE_CODE_EXISTS',
        );
}

/// Invalid company code (for joining)
class InvalidCompanyCodeException extends AuthException {
  const InvalidCompanyCodeException()
      : super(
          'Invalid company code',
          code: 'INVALID_COMPANY_CODE',
        );
}

/// User is already a member of the company
class AlreadyMemberException extends AuthException {
  const AlreadyMemberException()
      : super(
          'You are already a member of this company',
          code: 'ALREADY_MEMBER',
        );
}

/// Company has reached its employee limit (subscription restriction)
class EmployeeLimitReachedException extends AuthException {
  final int maxEmployees;
  final int currentEmployees;

  const EmployeeLimitReachedException({
    required this.maxEmployees,
    required this.currentEmployees,
  }) : super(
          'This company has reached its employee limit ($currentEmployees/$maxEmployees). '
          'Please ask the owner to upgrade their subscription.',
          code: 'EMPLOYEE_LIMIT_REACHED',
        );
}

/// Owner cannot join their own company as employee
class OwnerCannotJoinException extends AuthException {
  const OwnerCannotJoinException()
      : super(
          'You cannot join your own business as an employee',
          code: 'OWNER_CANNOT_JOIN',
        );
}
