// lib/features/delegate_role/presentation/providers/role_providers.dart
//
// Presentation Layer Providers with @riverpod
// All providers migrated to riverpod_generator for Clean Architecture 2025

import 'package:riverpod_annotation/riverpod_annotation.dart';

// Import centralized DI providers
import '../../di/delegate_role_providers.dart';

// Import domain entities
import '../../domain/entities/delegatable_role.dart';
import '../../domain/entities/delegation_audit.dart';
import '../../domain/entities/role.dart';
import '../../domain/entities/role_delegation.dart';

// Import state classes
import 'states/role_page_state.dart';
import 'states/role_creation_state.dart';
import 'states/role_management_state.dart';

// Re-export DI providers for convenience
export '../../di/delegate_role_providers.dart';

part 'role_providers.g.dart';

// =============================================================================
// Role Query Providers (@riverpod)
// =============================================================================

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
@riverpod
Future<List<Role>> allCompanyRoles(
  AllCompanyRolesRef ref,
  CompanyRolesParams params,
) async {
  final repository = ref.watch(roleRepositoryProvider);
  return repository.getAllCompanyRoles(params.companyId, params.userId);
}

/// Get role by ID
@riverpod
Future<Role> roleById(RoleByIdRef ref, String roleId) async {
  final repository = ref.watch(roleRepositoryProvider);
  return repository.getRoleById(roleId);
}

/// Get role permissions
@riverpod
Future<Map<String, dynamic>> rolePermissions(
  RolePermissionsRef ref,
  String roleId,
) async {
  final repository = ref.watch(roleRepositoryProvider);
  return repository.getRolePermissions(roleId);
}

/// Get delegatable roles
@riverpod
Future<List<DelegatableRole>> delegatableRoles(
  DelegatableRolesRef ref,
  String companyId,
) async {
  final repository = ref.watch(roleRepositoryProvider);
  return repository.getDelegatableRoles(companyId);
}

/// Get role members
@riverpod
Future<List<Map<String, dynamic>>> roleMembers(
  RoleMembersRef ref,
  String roleId,
) async {
  final repository = ref.watch(roleRepositoryProvider);
  return repository.getRoleMembers(roleId);
}

/// Get company users with roles
@riverpod
Future<List<Map<String, dynamic>>> companyUsers(
  CompanyUsersRef ref,
  String companyId,
) async {
  final dataSource = ref.watch(roleRemoteDataSourceProvider);
  return dataSource.getCompanyUsersWithRoles(companyId);
}

/// Get all features with categories
@riverpod
Future<List<Map<String, dynamic>>> allFeaturesWithCategories(
  AllFeaturesWithCategoriesRef ref,
) async {
  final dataSource = ref.watch(roleRemoteDataSourceProvider);
  return dataSource.getAllFeaturesWithCategories();
}

// =============================================================================
// Delegation Query Providers (@riverpod)
// =============================================================================

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
@riverpod
Future<List<RoleDelegation>> activeDelegations(
  ActiveDelegationsRef ref,
  ActiveDelegationsParams params,
) async {
  final repository = ref.watch(delegationRepositoryProvider);
  return repository.getActiveDelegations(params.userId, params.companyId);
}

/// Get delegation history
@riverpod
Future<List<DelegationAudit>> delegationHistory(
  DelegationHistoryRef ref,
  String companyId,
) async {
  final repository = ref.watch(delegationRepositoryProvider);
  return repository.getDelegationHistory(companyId);
}

// =============================================================================
// Page State Management (@riverpod Notifier)
// =============================================================================

/// Role Page State Notifier
@riverpod
class RolePageNotifier extends _$RolePageNotifier {
  @override
  RolePageState build() => RolePageState.initial();

  /// Update search query and filter roles
  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query.toLowerCase());
  }

  /// Set filtered roles
  void setFilteredRoles(List<Role> roles) {
    state = state.copyWith(filteredRoles: roles);
  }

  /// Set loading state
  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  /// Set error message
  void setError(String? errorMessage) {
    state = state.copyWith(errorMessage: errorMessage);
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  /// Reset state
  void reset() {
    state = RolePageState.initial();
  }
}

// =============================================================================
// Role Creation State Management (@riverpod Notifier)
// =============================================================================

/// Role Creation State Notifier
@riverpod
class RoleCreationNotifier extends _$RoleCreationNotifier {
  @override
  RoleCreationState build() => RoleCreationState.initial();

  /// Move to next step
  void nextStep() {
    if (state.currentStep < 2) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  /// Move to previous step
  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  /// Set current step
  void setStep(int step) {
    if (step >= 0 && step <= 2) {
      state = state.copyWith(currentStep: step);
    }
  }

  /// Set creating state
  void setCreating(bool isCreating) {
    state = state.copyWith(isCreating: isCreating);
  }

  /// Set editing text state
  void setEditingText(bool isEditingText) {
    state = state.copyWith(isEditingText: isEditingText);
  }

  /// Toggle permission selection
  void togglePermission(String permissionId) {
    final newPermissions = Set<String>.from(state.selectedPermissions);
    if (newPermissions.contains(permissionId)) {
      newPermissions.remove(permissionId);
    } else {
      newPermissions.add(permissionId);
    }
    state = state.copyWith(selectedPermissions: newPermissions);
  }

  /// Set all permissions
  void setPermissions(Set<String> permissions) {
    state = state.copyWith(selectedPermissions: permissions);
  }

  /// Toggle category expansion
  void toggleCategory(String categoryId) {
    final newExpanded = Set<String>.from(state.expandedCategories);
    if (newExpanded.contains(categoryId)) {
      newExpanded.remove(categoryId);
    } else {
      newExpanded.add(categoryId);
    }
    state = state.copyWith(expandedCategories: newExpanded);
  }

  /// Add tag
  void addTag(String tag) {
    if (!state.selectedTags.contains(tag)) {
      state = state.copyWith(
        selectedTags: [...state.selectedTags, tag],
      );
    }
  }

  /// Remove tag
  void removeTag(String tag) {
    state = state.copyWith(
      selectedTags: state.selectedTags.where((t) => t != tag).toList(),
    );
  }

  /// Set error
  void setError(String? errorMessage) {
    state = state.copyWith(errorMessage: errorMessage);
  }

  /// Set field error
  void setFieldError(String field, String error) {
    final newErrors = Map<String, String>.from(state.fieldErrors);
    newErrors[field] = error;
    state = state.copyWith(fieldErrors: newErrors);
  }

  /// Clear field error
  void clearFieldError(String field) {
    final newErrors = Map<String, String>.from(state.fieldErrors);
    newErrors.remove(field);
    state = state.copyWith(fieldErrors: newErrors);
  }

  /// Clear all errors
  void clearErrors() {
    state = state.copyWith(
      errorMessage: null,
      fieldErrors: {},
    );
  }

  /// Set created role ID
  void setCreatedRoleId(String? roleId) {
    state = state.copyWith(createdRoleId: roleId);
  }

  /// Reset state
  void reset() {
    state = RoleCreationState.initial();
  }
}

// =============================================================================
// Role Management State Management (@riverpod Notifier)
// =============================================================================

/// Role Management State Notifier
@riverpod
class RoleManagementNotifier extends _$RoleManagementNotifier {
  @override
  RoleManagementState build() => RoleManagementState.initial();

  /// Set selected tab
  void setTab(int tabIndex) {
    state = state.copyWith(selectedTab: tabIndex);
  }

  /// Set loading members state
  void setLoadingMembers(bool isLoading) {
    state = state.copyWith(isLoadingMembers: isLoading);
  }

  /// Set loading role assignments state
  void setLoadingRoleAssignments(bool isLoading) {
    state = state.copyWith(isLoadingRoleAssignments: isLoading);
  }

  /// Set members list
  void setMembers(List<Map<String, dynamic>> members) {
    state = state.copyWith(members: members);
  }

  /// Set user role assignments
  void setUserRoleAssignments(Map<String, String?> assignments) {
    state = state.copyWith(userRoleAssignments: assignments);
  }

  /// Set company ID
  void setCompanyId(String? companyId) {
    state = state.copyWith(companyId: companyId);
  }

  /// Set error
  void setError(String? errorMessage) {
    state = state.copyWith(errorMessage: errorMessage);
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  /// Reset state
  void reset() {
    state = RoleManagementState.initial();
  }
}

// =============================================================================
// Role Action Notifier (@riverpod) - Handles create, update, delete operations
// =============================================================================

/// Role Actions Notifier for mutations
@riverpod
class RoleActionsNotifier extends _$RoleActionsNotifier {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  /// Create a new role
  Future<String> createRole({
    required String companyId,
    required String roleName,
    String? description,
    String roleType = 'custom',
    List<String>? tags,
  }) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(roleRepositoryProvider);
      final roleId = await repository.createRole(
        companyId: companyId,
        roleName: roleName,
        description: description,
        roleType: roleType,
        tags: tags,
      );

      // Invalidate related providers
      ref.invalidate(allCompanyRolesProvider);
      ref.invalidate(delegatableRolesProvider);

      state = const AsyncValue.data(null);
      return roleId;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  /// Update role details
  Future<void> updateRoleDetails({
    required String roleId,
    required String roleName,
    String? description,
    List<String>? tags,
  }) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(roleRepositoryProvider);
      await repository.updateRoleDetails(
        roleId: roleId,
        roleName: roleName,
        description: description,
        tags: tags,
      );

      // Invalidate related providers
      ref.invalidate(allCompanyRolesProvider);
      ref.invalidate(delegatableRolesProvider);
      ref.invalidate(roleByIdProvider(roleId));

      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  /// Update role permissions
  Future<void> updateRolePermissions(
    String roleId,
    Set<String> newPermissions,
  ) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(roleRepositoryProvider);
      await repository.updateRolePermissions(roleId, newPermissions);

      // Invalidate related providers
      ref.invalidate(allCompanyRolesProvider);
      ref.invalidate(rolePermissionsProvider(roleId));

      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  /// Delete role
  Future<void> deleteRole(String roleId, String companyId) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(roleRepositoryProvider);
      await repository.deleteRole(roleId, companyId);

      // Invalidate roles list to refresh
      ref.invalidate(allCompanyRolesProvider);

      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  /// Assign user to role
  Future<void> assignUserToRole({
    required String userId,
    required String roleId,
    required String companyId,
  }) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(roleRepositoryProvider);
      await repository.assignUserToRole(
        userId: userId,
        roleId: roleId,
        companyId: companyId,
      );

      // Invalidate related providers
      ref.invalidate(companyUsersProvider);
      ref.invalidate(allCompanyRolesProvider);
      ref.invalidate(roleMembersProvider(roleId));

      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}

// =============================================================================
// Delegation Action Notifier (@riverpod) - Handles delegation operations
// =============================================================================

/// Delegation Actions Notifier for mutations
@riverpod
class DelegationActionsNotifier extends _$DelegationActionsNotifier {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  /// Create a new delegation
  Future<void> createDelegation({
    required String delegateId,
    required String roleId,
    required List<String> permissions,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(delegationRepositoryProvider);
      await repository.createDelegation(
        delegateId: delegateId,
        roleId: roleId,
        permissions: permissions,
        startDate: startDate,
        endDate: endDate,
      );

      // Invalidate delegations to refresh
      ref.invalidate(activeDelegationsProvider);

      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  /// Revoke delegation
  Future<void> revokeDelegation(String delegationId) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(delegationRepositoryProvider);
      await repository.revokeDelegation(delegationId);

      // Invalidate delegations to refresh
      ref.invalidate(activeDelegationsProvider);

      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}
