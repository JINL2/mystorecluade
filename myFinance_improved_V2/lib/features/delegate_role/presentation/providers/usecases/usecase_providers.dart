// lib/features/delegate_role/presentation/providers/usecases/usecase_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/usecases/role/assign_user_to_role_usecase.dart';
import '../../../domain/usecases/role/create_role_usecase.dart';
import '../../../domain/usecases/role/get_role_members_usecase.dart';
import '../../../domain/usecases/role/get_user_role_assignments_usecase.dart';
import '../../../domain/usecases/role/update_role_details_usecase.dart';
import '../../../domain/usecases/role/update_role_permissions_usecase.dart';
import '../repositories/repository_providers.dart';

// ============================================================================
// Role UseCase Providers - Tier 3: Business Logic Layer
// ============================================================================

/// Create Role UseCase Provider
///
/// Provides the use case for creating a new role with validation
/// Encapsulates business rules for role creation
final createRoleUseCaseProvider = Provider<CreateRoleUseCase>((ref) {
  final repository = ref.watch(roleRepositoryProvider);
  return CreateRoleUseCase(repository: repository);
});

/// Update Role Details UseCase Provider
///
/// Provides the use case for updating role name, description, and tags
/// Encapsulates business rules for role updates
final updateRoleDetailsUseCaseProvider = Provider<UpdateRoleDetailsUseCase>((ref) {
  final repository = ref.watch(roleRepositoryProvider);
  return UpdateRoleDetailsUseCase(repository: repository);
});

/// Update Role Permissions UseCase Provider
///
/// Provides the use case for updating role permissions
/// Encapsulates business rules for permission management
final updateRolePermissionsUseCaseProvider = Provider<UpdateRolePermissionsUseCase>((ref) {
  final repository = ref.watch(roleRepositoryProvider);
  return UpdateRolePermissionsUseCase(repository: repository);
});

/// Assign User to Role UseCase Provider
///
/// Provides the use case for assigning a user to a role
/// ⭐ Replaces widget's _assignUserToRole() method
/// Encapsulates business rules for user-role assignments
final assignUserToRoleUseCaseProvider = Provider<AssignUserToRoleUseCase>((ref) {
  final repository = ref.watch(roleRepositoryProvider);
  return AssignUserToRoleUseCase(repository: repository);
});

/// Get Role Members UseCase Provider
///
/// Provides the use case for retrieving role members
/// ⭐ Replaces widget's _getRoleMembers() method
/// Encapsulates business logic for fetching role member details
final getRoleMembersUseCaseProvider = Provider<GetRoleMembersUseCase>((ref) {
  final repository = ref.watch(roleRepositoryProvider);
  return GetRoleMembersUseCase(repository: repository);
});

/// Get User Role Assignments UseCase Provider
///
/// Provides the use case for retrieving user role assignments
/// ⭐ Replaces widget's _loadUserRoleAssignments() method
/// Returns a map of userId -> roleId for the company
final getUserRoleAssignmentsUseCaseProvider = Provider<GetUserRoleAssignmentsUseCase>((ref) {
  final repository = ref.watch(roleRepositoryProvider);
  return GetUserRoleAssignmentsUseCase(repository: repository);
});
