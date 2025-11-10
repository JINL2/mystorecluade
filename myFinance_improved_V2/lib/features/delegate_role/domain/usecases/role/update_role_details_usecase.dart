// lib/features/delegate_role/domain/usecases/role/update_role_details_usecase.dart

import 'package:myfinance_improved/core/utils/tag_validator.dart';

import '../../exceptions/role_exceptions.dart';
import '../../repositories/role_repository.dart';
import '../../validators/role_validator.dart';
import '../../value_objects/role_name.dart';

/// Update Role Details UseCase
///
/// Business logic for updating role name, description, and tags
class UpdateRoleDetailsUseCase {
  final RoleRepository _repository;
  final RoleValidator _validator;

  UpdateRoleDetailsUseCase({
    required RoleRepository repository,
    RoleValidator? validator,
  })  : _repository = repository,
        _validator = validator ?? RoleValidator(repository: repository);

  /// Execute the use case
  ///
  /// Throws [RoleValidationException] for validation errors
  /// Throws [RoleDuplicateException] for duplicate names
  /// Throws [RoleUpdateException] for update failures
  Future<void> execute({
    required String roleId,
    required String companyId,
    required String roleNameStr,
    String? currentRoleName,
    String? description,
    List<String>? tagsStr,
  }) async {
    try {
      // Step 1: Validate and create value objects
      final roleName = RoleName.create(roleNameStr);

      // Step 2: Validate tags using existing TagValidator
      if (tagsStr != null && tagsStr.isNotEmpty) {
        final tagValidation = TagValidator.validateTags(tagsStr);
        if (!tagValidation.isValid) {
          throw RoleValidationException(
            'Invalid tags: ${tagValidation.firstError}',
          );
        }
      }

      // Step 3: Validate role update
      await _validator.validateRoleUpdate(
        roleId: roleId,
        companyId: companyId,
        newRoleName: roleName,
        currentRoleName: currentRoleName,
      );

      // Step 4: Delegate to repository
      await _repository.updateRoleDetails(
        roleId: roleId,
        roleName: roleName.value,
        description: description,
        tags: tagsStr,
      );
    } on RoleValidationException {
      rethrow;
    } on RoleDuplicateException {
      rethrow;
    } catch (e, stackTrace) {
      throw RoleUpdateException(
        'Failed to update role details: $e',
        stackTrace,
      );
    }
  }
}
