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

/// User not found
class UserNotFoundException extends AuthException {
  const UserNotFoundException({String? userId})
      : super(
          userId != null ? 'User "$userId" not found' : 'User not found',
          code: 'USER_NOT_FOUND',
        );
}

/// Account locked (too many failed attempts)
class AccountLockedException extends AuthException {
  const AccountLockedException()
      : super(
          'Account locked due to too many failed login attempts',
          code: 'ACCOUNT_LOCKED',
        );
}

/// Account disabled by admin
class AccountDisabledException extends AuthException {
  const AccountDisabledException()
      : super(
          'Account has been disabled. Please contact support.',
          code: 'ACCOUNT_DISABLED',
        );
}

/// Session expired
class SessionExpiredException extends AuthException {
  const SessionExpiredException()
      : super(
          'Your session has expired. Please log in again.',
          code: 'SESSION_EXPIRED',
        );
}

/// Token invalid or expired
class InvalidTokenException extends AuthException {
  const InvalidTokenException({String? tokenType})
      : super(
          tokenType != null
              ? 'Invalid or expired $tokenType token'
              : 'Invalid or expired token',
          code: 'INVALID_TOKEN',
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

/// Terms and conditions not agreed
class TermsNotAgreedException extends AuthException {
  const TermsNotAgreedException()
      : super(
          'You must agree to the terms and conditions',
          code: 'TERMS_NOT_AGREED',
        );
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

/// Company not found
class CompanyNotFoundException extends AuthException {
  const CompanyNotFoundException({String? companyId})
      : super(
          companyId != null
              ? 'Company "$companyId" not found'
              : 'Company not found',
          code: 'COMPANY_NOT_FOUND',
        );
}

/// Store not found
class StoreNotFoundException extends AuthException {
  const StoreNotFoundException({String? storeId})
      : super(
          storeId != null ? 'Store "$storeId" not found' : 'Store not found',
          code: 'STORE_NOT_FOUND',
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

/// Permission denied
class PermissionDeniedException extends AuthException {
  const PermissionDeniedException({String? action})
      : super(
          action != null
              ? 'Permission denied: $action'
              : 'Permission denied',
          code: 'PERMISSION_DENIED',
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
