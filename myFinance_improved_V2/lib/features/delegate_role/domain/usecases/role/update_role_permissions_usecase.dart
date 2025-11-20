// lib/features/delegate_role/domain/usecases/role/update_role_permissions_usecase.dart

import '../../exceptions/role_exceptions.dart';
import '../../repositories/role_repository.dart';
import '../../value_objects/permission_set.dart';

/// Update Role Permissions UseCase
///
/// Business logic for updating role permissions with validation
class UpdateRolePermissionsUseCase {
  final RoleRepository _repository;

  UpdateRolePermissionsUseCase({
    required RoleRepository repository,
  }) : _repository = repository;

  /// Execute the use case
  ///
  /// Throws [RoleValidationException] for validation errors
  /// Throws [PermissionException] for permission update failures
  Future<void> execute({
    required String roleId,
    required Set<String> permissions,
  }) async {
    try {
      // Step 1: Validate permissions using value object
      // Allow empty set for system roles or when removing all permissions
      PermissionSet permissionSet;
      if (permissions.isEmpty) {
        permissionSet = PermissionSet.empty();
      } else {
        permissionSet = PermissionSet.create(permissions);
      }

      // Step 2: Delegate to repository
      await _repository.updateRolePermissions(
        roleId,
        permissionSet.permissions,
      );
    } on RoleValidationException {
      rethrow;
    } catch (e, stackTrace) {
      throw PermissionException(
        'Failed to update role permissions: $e',
        stackTrace,
      );
    }
  }
}
