// lib/features/delegate_role/domain/usecases/role/assign_user_to_role_usecase.dart

import '../../exceptions/role_exceptions.dart';
import '../../repositories/role_repository.dart';

/// Assign User to Role UseCase
///
/// Business logic for assigning a user to a role
/// Encapsulates validation and assignment logic
class AssignUserToRoleUseCase {
  final RoleRepository _repository;

  AssignUserToRoleUseCase({
    required RoleRepository repository,
  }) : _repository = repository;

  /// Execute the use case
  ///
  /// Assigns a user to a role, replacing any existing role assignment
  /// in the same company (handled by database trigger)
  ///
  /// Throws [UserRoleAssignmentException] if assignment fails
  Future<void> execute({
    required String userId,
    required String roleId,
    required String companyId,
  }) async {
    try {
      // Business rule validation is handled by repository/database
      // - User cannot be assigned to same role twice
      // - Existing role in same company will be replaced
      // - Database trigger handles role replacement logic

      await _repository.assignUserToRole(
        userId: userId,
        roleId: roleId,
        companyId: companyId,
      );
    } catch (e, stackTrace) {
      // Convert repository exceptions to domain exceptions
      if (e.toString().contains('already assigned')) {
        throw UserRoleAssignmentException(
          'User is already assigned to this role',
          stackTrace,
        );
      }

      throw UserRoleAssignmentException(
        'Failed to assign user to role: $e',
        stackTrace,
      );
    }
  }
}
