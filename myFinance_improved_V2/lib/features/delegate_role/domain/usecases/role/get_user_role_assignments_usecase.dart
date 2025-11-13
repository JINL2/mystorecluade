// lib/features/delegate_role/domain/usecases/role/get_user_role_assignments_usecase.dart

import '../../exceptions/role_exceptions.dart';
import '../../repositories/role_repository.dart';

/// Get User Role Assignments UseCase
///
/// Retrieves role assignments for users in a specific company
/// Returns a map of userId -> roleId for quick lookup
class GetUserRoleAssignmentsUseCase {
  final RoleRepository _repository;

  GetUserRoleAssignmentsUseCase({
    required RoleRepository repository,
  }) : _repository = repository;

  /// Execute the use case
  ///
  /// Returns a map of user IDs to their assigned role IDs
  /// Throws [RoleException] if fetch fails
  Future<Map<String, String?>> execute({
    required String roleId,
    required String companyId,
  }) async {
    try {
      // Get the role to verify it exists and get company context
      final role = await _repository.getRoleById(roleId);

      // Verify role belongs to the specified company
      if (role.companyId != companyId) {
        throw const RoleValidationException(
          'Role does not belong to the specified company',
        );
      }

      // Get all roles for this company
      final allRoles = await _repository.getAllCompanyRoles(companyId, null);

      // Get all users in all roles for this company
      final assignments = <String, String?>{};

      for (final companyRole in allRoles) {
        final members = await _repository.getRoleMembers(companyRole.roleId);
        for (final member in members) {
          final userId = member['user_id'] as String?;
          if (userId != null) {
            assignments[userId] = companyRole.roleId;
          }
        }
      }

      return assignments;
    } on RoleValidationException {
      rethrow;
    } on RoleNotFoundException {
      rethrow;
    } catch (e, stackTrace) {
      throw RoleMembersFetchException(
        'Failed to get user role assignments: $e',
        stackTrace,
      );
    }
  }
}
