// lib/features/delegate_role/domain/exceptions/role_exceptions.dart

/// Base exception for role-related domain errors
abstract class RoleException implements Exception {
  final String message;
  final StackTrace? stackTrace;

  const RoleException(this.message, [this.stackTrace]);

  @override
  String toString() => 'RoleException: $message';
}

/// Validation exception for role business rules
class RoleValidationException extends RoleException {
  const RoleValidationException(super.message, [super.stackTrace]);

  @override
  String toString() => 'RoleValidationException: $message';
}

/// Exception for duplicate role names
class RoleDuplicateException extends RoleException {
  const RoleDuplicateException(super.message, [super.stackTrace]);

  @override
  String toString() => 'RoleDuplicateException: $message';
}

/// Exception for role creation failures
class RoleCreationException extends RoleException {
  const RoleCreationException(super.message, [super.stackTrace]);

  @override
  String toString() => 'RoleCreationException: $message';
}

/// Exception for role update failures
class RoleUpdateException extends RoleException {
  const RoleUpdateException(super.message, [super.stackTrace]);

  @override
  String toString() => 'RoleUpdateException: $message';
}

/// Exception for role deletion failures
class RoleDeletionException extends RoleException {
  const RoleDeletionException(super.message, [super.stackTrace]);

  @override
  String toString() => 'RoleDeletionException: $message';
}

/// Exception for role not found
class RoleNotFoundException extends RoleException {
  const RoleNotFoundException(super.message, [super.stackTrace]);

  @override
  String toString() => 'RoleNotFoundException: $message';
}

/// Exception for role member operations
class RoleMemberException extends RoleException {
  const RoleMemberException(super.message, [super.stackTrace]);

  @override
  String toString() => 'RoleMemberException: $message';
}

/// Exception for fetching role members
class RoleMembersFetchException extends RoleMemberException {
  const RoleMembersFetchException(super.message, [super.stackTrace]);

  @override
  String toString() => 'RoleMembersFetchException: $message';
}

/// Exception for assigning user to role
class UserRoleAssignmentException extends RoleMemberException {
  const UserRoleAssignmentException(super.message, [super.stackTrace]);

  @override
  String toString() => 'UserRoleAssignmentException: $message';
}

/// Exception for permission operations
class PermissionException extends RoleException {
  const PermissionException(super.message, [super.stackTrace]);

  @override
  String toString() => 'PermissionException: $message';
}
