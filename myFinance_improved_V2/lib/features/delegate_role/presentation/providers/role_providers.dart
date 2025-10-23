import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/datasources/delegation_remote_data_source.dart';
import '../../data/datasources/role_remote_data_source.dart';
import '../../data/repositories/delegation_repository_impl.dart';
import '../../data/repositories/role_repository_impl.dart';
import '../../domain/entities/delegatable_role.dart';
import '../../domain/entities/delegation_audit.dart';
import '../../domain/entities/role.dart';
import '../../domain/entities/role_delegation.dart';
import '../../domain/repositories/delegation_repository.dart';
import '../../domain/repositories/role_repository.dart';
import 'states/role_page_state.dart';
import 'states/role_creation_state.dart';
import 'states/role_management_state.dart';

// =============================================================================
// Data Source Providers
// =============================================================================

/// Supabase client provider
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Role remote data source provider
final roleRemoteDataSourceProvider = Provider<RoleRemoteDataSource>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return RoleRemoteDataSource(supabase);
});

/// Delegation remote data source provider
final delegationRemoteDataSourceProvider = Provider<DelegationRemoteDataSource>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return DelegationRemoteDataSource(supabase);
});

// =============================================================================
// Repository Providers
// =============================================================================

/// Role repository provider
final roleRepositoryProvider = Provider<RoleRepository>((ref) {
  final dataSource = ref.watch(roleRemoteDataSourceProvider);
  return RoleRepositoryImpl(dataSource);
});

/// Delegation repository provider
final delegationRepositoryProvider = Provider<DelegationRepository>((ref) {
  final dataSource = ref.watch(delegationRemoteDataSourceProvider);
  return DelegationRepositoryImpl(dataSource);
});

// =============================================================================
// Role Use Case Providers
// =============================================================================

/// Get all company roles
final allCompanyRolesProvider = FutureProvider.family<List<Role>, ({String companyId, String? userId})>((ref, params) async {
  final repository = ref.watch(roleRepositoryProvider);
  return await repository.getAllCompanyRoles(params.companyId, params.userId);
});

/// Get role by ID
final roleByIdProvider = FutureProvider.family<Role, String>((ref, roleId) async {
  final repository = ref.watch(roleRepositoryProvider);
  return await repository.getRoleById(roleId);
});

/// Get role permissions
final rolePermissionsProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, roleId) async {
  final repository = ref.watch(roleRepositoryProvider);
  return await repository.getRolePermissions(roleId);
});

/// Get delegatable roles
final delegatableRolesProvider = FutureProvider.family<List<DelegatableRole>, String>((ref, companyId) async {
  final repository = ref.watch(roleRepositoryProvider);
  return await repository.getDelegatableRoles(companyId);
});

/// Get role members
final roleMembersProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, roleId) async {
  final repository = ref.watch(roleRepositoryProvider);
  return await repository.getRoleMembers(roleId);
});

/// Get company users with roles
final companyUsersProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, companyId) async {
  final dataSource = ref.watch(roleRemoteDataSourceProvider);
  return await dataSource.getCompanyUsersWithRoles(companyId);
});

/// Get all features with categories
final allFeaturesWithCategoriesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final dataSource = ref.watch(roleRemoteDataSourceProvider);
  return await dataSource.getAllFeaturesWithCategories();
});

// =============================================================================
// Role Action Providers
// =============================================================================

/// Create role provider
final createRoleProvider = Provider((ref) {
  return ({
    required String companyId,
    required String roleName,
    String? description,
    String roleType = 'custom',
    List<String>? tags,
  }) async {
    final repository = ref.read(roleRepositoryProvider);
    final roleId = await repository.createRole(
      companyId: companyId,
      roleName: roleName,
      description: description,
      roleType: roleType,
      tags: tags,
    );

    // Invalidate roles list to refresh
    ref.invalidate(allCompanyRolesProvider);
    ref.invalidate(delegatableRolesProvider);

    return roleId;
  };
});

/// Update role details provider
final updateRoleDetailsProvider = Provider((ref) {
  return ({
    required String roleId,
    required String roleName,
    String? description,
    List<String>? tags,
  }) async {
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

    return true;
  };
});

/// Update role permissions provider
final updateRolePermissionsProvider = Provider((ref) {
  return (String roleId, Set<String> newPermissions) async {
    final repository = ref.read(roleRepositoryProvider);
    await repository.updateRolePermissions(roleId, newPermissions);

    // Invalidate related providers
    ref.invalidate(allCompanyRolesProvider);
    ref.invalidate(rolePermissionsProvider(roleId));

    return true;
  };
});

/// Delete role provider
final deleteRoleProvider = Provider((ref) {
  return (String roleId, String companyId) async {
    final repository = ref.read(roleRepositoryProvider);
    await repository.deleteRole(roleId, companyId);

    // Invalidate roles list to refresh
    ref.invalidate(allCompanyRolesProvider);
  };
});

/// Assign user to role provider
final assignUserToRoleProvider = Provider((ref) {
  return ({
    required String userId,
    required String roleId,
    required String companyId,
  }) async {
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
  };
});

// =============================================================================
// Delegation Use Case Providers
// =============================================================================

/// Get active delegations
final activeDelegationsProvider = FutureProvider.family<List<RoleDelegation>, ({String userId, String companyId})>((ref, params) async {
  final repository = ref.watch(delegationRepositoryProvider);
  return await repository.getActiveDelegations(params.userId, params.companyId);
});

/// Get delegation history
final delegationHistoryProvider = FutureProvider.family<List<DelegationAudit>, String>((ref, companyId) async {
  final repository = ref.watch(delegationRepositoryProvider);
  return await repository.getDelegationHistory(companyId);
});

// =============================================================================
// Delegation Action Providers
// =============================================================================

/// Create delegation provider
final createDelegationProvider = Provider((ref) {
  return ({
    required String delegateId,
    required String roleId,
    required List<String> permissions,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
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
  };
});

/// Revoke delegation provider
final revokeDelegationProvider = Provider((ref) {
  return (String delegationId) async {
    final repository = ref.read(delegationRepositoryProvider);
    await repository.revokeDelegation(delegationId);

    // Invalidate delegations to refresh
    ref.invalidate(activeDelegationsProvider);
  };
});

// =============================================================================
// Page State Management
// =============================================================================

/// Role Page State Notifier
class RolePageNotifier extends StateNotifier<RolePageState> {
  RolePageNotifier() : super(RolePageState.initial());

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

/// Role page state provider
final rolePageStateProvider = StateNotifierProvider<RolePageNotifier, RolePageState>((ref) {
  return RolePageNotifier();
});

// =============================================================================
// Role Creation State Management
// =============================================================================

/// Role Creation State Notifier
class RoleCreationNotifier extends StateNotifier<RoleCreationState> {
  RoleCreationNotifier() : super(RoleCreationState.initial());

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

/// Role creation state provider
final roleCreationStateProvider = StateNotifierProvider<RoleCreationNotifier, RoleCreationState>((ref) {
  return RoleCreationNotifier();
});

// =============================================================================
// Role Management State Management
// =============================================================================

/// Role Management State Notifier
class RoleManagementNotifier extends StateNotifier<RoleManagementState> {
  RoleManagementNotifier() : super(RoleManagementState.initial());

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

/// Role management state provider
final roleManagementStateProvider = StateNotifierProvider<RoleManagementNotifier, RoleManagementState>((ref) {
  return RoleManagementNotifier();
});
