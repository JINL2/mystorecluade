// lib/features/delegate_role/domain/usecases/role/create_role_usecase.dart

import 'package:myfinance_improved/core/utils/tag_validator.dart';

import '../../exceptions/role_exceptions.dart';
import '../../repositories/role_repository.dart';
import '../../validators/role_validator.dart';
import '../../value_objects/role_name.dart';

/// Create Role UseCase
///
/// Business logic for creating a new role with validation
/// Encapsulates all role creation rules and validation
class CreateRoleUseCase {
  final RoleRepository _repository;
  final RoleValidator _validator;

  CreateRoleUseCase({
    required RoleRepository repository,
    RoleValidator? validator,
  })  : _repository = repository,
        _validator = validator ?? RoleValidator(repository: repository);

  /// Execute the use case
  ///
  /// Returns the created role ID
  /// Throws [RoleValidationException] for validation errors
  /// Throws [RoleDuplicateException] for duplicate names
  /// Throws [RoleCreationException] for creation failures
  Future<String> execute({
    required String companyId,
    required String roleNameStr,
    String? description,
    String roleType = 'custom',
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

      // Step 3: Apply business validation rules
      await _validator.validateRoleCreation(
        companyId: companyId,
        roleName: roleName,
        roleType: roleType,
      );

      // Step 4: Delegate to repository
      final roleId = await _repository.createRole(
        companyId: companyId,
        roleName: roleName.value,
        description: description,
        roleType: roleType,
        tags: tagsStr,
      );

      return roleId;
    } on RoleValidationException {
      rethrow; // Domain exception - let UI handle
    } on RoleDuplicateException {
      rethrow; // Domain exception - let UI handle
    } catch (e, stackTrace) {
      throw RoleCreationException(
        'Failed to create role: $e',
        stackTrace,
      );
    }
  }
}
