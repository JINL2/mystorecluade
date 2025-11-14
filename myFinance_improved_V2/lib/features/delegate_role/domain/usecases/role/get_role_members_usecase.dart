// lib/features/delegate_role/domain/usecases/role/get_role_members_usecase.dart

import '../../exceptions/role_exceptions.dart';
import '../../repositories/role_repository.dart';

/// Get Role Members UseCase
///
/// Retrieves all members assigned to a specific role
/// Encapsulates the business logic previously in widget
class GetRoleMembersUseCase {
  final RoleRepository _repository;

  GetRoleMembersUseCase({
    required RoleRepository repository,
  }) : _repository = repository;

  /// Execute the use case
  ///
  /// Returns list of role members with their details
  /// Throws [RoleMembersFetchException] if fetch fails
  Future<List<Map<String, dynamic>>> execute(String roleId) async {
    try {
      final members = await _repository.getRoleMembers(roleId);
      return members;
    } catch (e, stackTrace) {
      throw RoleMembersFetchException(
        'Failed to get role members: $e',
        stackTrace,
      );
    }
  }
}
