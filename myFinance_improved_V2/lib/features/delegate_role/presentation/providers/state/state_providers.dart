// lib/features/delegate_role/presentation/providers/state/state_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/delegatable_role.dart';
import '../../../domain/entities/delegation_audit.dart';
import '../../../domain/entities/role.dart';
import '../../../domain/entities/role_delegation.dart';
import '../repositories/repository_providers.dart';
import '../infrastructure/datasource_providers.dart';
import '../usecases/usecase_providers.dart';

// ============================================================================
// State Providers - Tier 4: UI State Management
// ============================================================================

/// Params for company roles query
class CompanyRolesParams {
  final String companyId;
  final String? userId;

  const CompanyRolesParams({
    required this.companyId,
    this.userId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompanyRolesParams &&
          runtimeType == other.runtimeType &&
          companyId == other.companyId &&
          userId == other.userId;

  @override
  int get hashCode => companyId.hashCode ^ (userId?.hashCode ?? 0);
}

/// Get all company roles
final allCompanyRolesProvider = FutureProvider.family<List<Role>, CompanyRolesParams>(
  (ref, params) async {
    final repository = ref.watch(roleRepositoryProvider);
    return await repository.getAllCompanyRoles(params.companyId, params.userId);
  },
);

/// Get role by ID
final roleByIdProvider = FutureProvider.family<Role, String>((ref, roleId) async {
  final repository = ref.watch(roleRepositoryProvider);
  return await repository.getRoleById(roleId);
});

/// Get role permissions
final rolePermissionsProvider = FutureProvider.family<Map<String, dynamic>, String>(
  (ref, roleId) async {
    final repository = ref.watch(roleRepositoryProvider);
    return await repository.getRolePermissions(roleId);
  },
);

/// Get delegatable roles
final delegatableRolesProvider = FutureProvider.family<List<DelegatableRole>, String>(
  (ref, companyId) async {
    final repository = ref.watch(roleRepositoryProvider);
    return await repository.getDelegatableRoles(companyId);
  },
);

/// Get role members
final roleMembersProvider = FutureProvider.family<List<Map<String, dynamic>>, String>(
  (ref, roleId) async {
    final repository = ref.watch(roleRepositoryProvider);
    return await repository.getRoleMembers(roleId);
  },
);

/// Get company users with roles
///
/// Note: Uses dataSource directly for simple read-only queries
/// No business logic needed - avoiding over-engineering
final companyUsersProvider = FutureProvider.family<List<Map<String, dynamic>>, String>(
  (ref, companyId) async {
    final dataSource = ref.watch(roleDataSourceProvider);
    return await dataSource.getCompanyUsersWithRoles(companyId);
  },
);

/// Get all features with categories
///
/// Note: Uses dataSource directly for simple read-only queries
/// No business logic needed - avoiding over-engineering
final allFeaturesWithCategoriesProvider = FutureProvider<List<Map<String, dynamic>>>(
  (ref) async {
    final dataSource = ref.watch(roleDataSourceProvider);
    return await dataSource.getAllFeaturesWithCategories();
  },
);

// ============================================================================
// Delegation Providers
// ============================================================================

/// Params for active delegations query
class ActiveDelegationsParams {
  final String userId;
  final String companyId;

  const ActiveDelegationsParams({
    required this.userId,
    required this.companyId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActiveDelegationsParams &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          companyId == other.companyId;

  @override
  int get hashCode => userId.hashCode ^ companyId.hashCode;
}

/// Get active delegations
final activeDelegationsProvider = FutureProvider.family<List<RoleDelegation>, ActiveDelegationsParams>(
  (ref, params) async {
    final repository = ref.watch(delegationRepositoryProvider);
    return await repository.getActiveDelegations(params.userId, params.companyId);
  },
);

/// Get delegation history
final delegationHistoryProvider = FutureProvider.family<List<DelegationAudit>, String>(
  (ref, companyId) async {
    final repository = ref.watch(delegationRepositoryProvider);
    return await repository.getDelegationHistory(companyId);
  },
);

// ============================================================================
// Action Providers (Legacy - kept for backward compatibility)
// These call UseCase providers but wrapped for easier usage
// ============================================================================

/// Update role details provider
final updateRoleDetailsProvider = Provider((ref) {
  return ({
    required String roleId,
    required String roleName,
    String? description,
    List<String>? tags,
  }) async {
    // Get role to extract companyId
    final repository = ref.read(roleRepositoryProvider);
    final role = await repository.getRoleById(roleId);

    // Use UpdateRoleDetailsUseCase following Clean Architecture
    final useCase = ref.read(updateRoleDetailsUseCaseProvider);
    await useCase.execute(
      roleId: roleId,
      companyId: role.companyId,
      roleNameStr: roleName,
      currentRoleName: role.roleName,
      description: description,
      tagsStr: tags,
    );

    // Invalidate related providers
    ref.invalidate(allCompanyRolesProvider);
    ref.invalidate(delegatableRolesProvider);
    ref.invalidate(roleByIdProvider(roleId));
  };
});

/// Update role permissions provider
final updateRolePermissionsProvider = Provider((ref) {
  return (String roleId, Set<String> permissions) async {
    // Use UpdateRolePermissionsUseCase following Clean Architecture
    final useCase = ref.read(updateRolePermissionsUseCaseProvider);
    await useCase.execute(
      roleId: roleId,
      permissions: permissions,
    );

    // Invalidate related providers
    ref.invalidate(allCompanyRolesProvider);
    ref.invalidate(rolePermissionsProvider(roleId));
    ref.invalidate(roleByIdProvider(roleId));
  };
});
