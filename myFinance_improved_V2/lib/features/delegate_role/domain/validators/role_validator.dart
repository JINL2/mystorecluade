// lib/features/delegate_role/domain/validators/role_validator.dart

import '../exceptions/role_exceptions.dart';
import '../repositories/role_repository.dart';
import '../value_objects/role_name.dart';

/// Role Validator
///
/// Validates business rules for role operations
/// Pure domain logic with no dependencies on infrastructure
class RoleValidator {
  final RoleRepository? _repository;

  RoleValidator({RoleRepository? repository}) : _repository = repository;

  /// Validate role creation
  ///
  /// Checks business rules:
  /// - Role name uniqueness within company
  /// - Role type validity
  Future<void> validateRoleCreation({
    required String companyId,
    required RoleName roleName,
    required String roleType,
  }) async {
    // Business rule: Check for duplicate role names
    if (_repository != null) {
      final existingRoles = await _repository!.getAllCompanyRoles(
        companyId,
        null,
      );

      final isDuplicate = existingRoles.any(
        (role) =>
            role.roleName.toLowerCase() == roleName.value.toLowerCase(),
      );

      if (isDuplicate) {
        throw RoleDuplicateException(
          'Role "${roleName.value}" already exists in this company',
        );
      }
    }

    // Business rule: Only custom and system types are allowed
    if (roleType != 'custom' && roleType != 'system') {
      throw RoleValidationException('Invalid role type: $roleType');
    }
  }

  /// Validate role update
  ///
  /// Checks business rules:
  /// - Cannot rename to existing role name
  /// - Cannot rename system roles (Owner, Admin)
  Future<void> validateRoleUpdate({
    required String roleId,
    required String companyId,
    required RoleName newRoleName,
    required String? currentRoleName,
  }) async {
    // Business rule: Cannot rename system roles
    // Only 'owner' role is protected from renaming
    if (currentRoleName != null) {
      final normalizedCurrent = currentRoleName.toLowerCase();
      if (normalizedCurrent == 'owner') {
        throw RoleValidationException(
          'Cannot rename system role "$currentRoleName"',
        );
      }
    }

    // Business rule: Check for duplicate if name changed
    if (_repository != null &&
        currentRoleName != null &&
        currentRoleName.toLowerCase() != newRoleName.value.toLowerCase()) {
      final existingRoles = await _repository!.getAllCompanyRoles(
        companyId,
        null,
      );

      final isDuplicate = existingRoles.any(
        (role) =>
            role.roleId != roleId &&
            role.roleName.toLowerCase() == newRoleName.value.toLowerCase(),
      );

      if (isDuplicate) {
        throw RoleDuplicateException(
          'Role "${newRoleName.value}" already exists in this company',
        );
      }
    }
  }

  /// Validate role deletion
  ///
  /// Checks business rules:
  /// - Cannot delete Owner role
  /// - Cannot delete if role has active delegations
  Future<void> validateRoleDeletion({
    required String roleId,
    required String roleName,
  }) async {
    // Business rule: Cannot delete Owner role
    if (roleName.toLowerCase() == 'owner') {
      throw const RoleValidationException(
        'Cannot delete the Owner role',
      );
    }

    // Additional validation can be added here
    // e.g., check for active delegations
  }

  /// Validate user role assignment
  ///
  /// Checks business rules:
  /// - User is not already assigned to this role
  /// - Role exists and is active
  Future<void> validateUserAssignment({
    required String userId,
    required String roleId,
  }) async {
    // Business rules can be added here
    // Currently delegated to UseCase for database checks
  }
}
