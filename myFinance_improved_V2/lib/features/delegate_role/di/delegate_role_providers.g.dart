// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delegate_role_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$supabaseClientHash() => r'36e9cae00709545a85bfe4a5a2cb98d8686a01ea';

/// Supabase Client Provider
/// Singleton instance for all database operations
///
/// Copied from [supabaseClient].
@ProviderFor(supabaseClient)
final supabaseClientProvider = AutoDisposeProvider<SupabaseClient>.internal(
  supabaseClient,
  name: r'supabaseClientProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$supabaseClientHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SupabaseClientRef = AutoDisposeProviderRef<SupabaseClient>;
String _$roleRemoteDataSourceHash() =>
    r'f1aa5f8f5fcfaffcea32d081bcb05067180a332d';

/// Role Remote DataSource
/// Handles all role-related Supabase operations
///
/// Copied from [roleRemoteDataSource].
@ProviderFor(roleRemoteDataSource)
final roleRemoteDataSourceProvider =
    AutoDisposeProvider<RoleRemoteDataSource>.internal(
  roleRemoteDataSource,
  name: r'roleRemoteDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$roleRemoteDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RoleRemoteDataSourceRef = AutoDisposeProviderRef<RoleRemoteDataSource>;
String _$delegationRemoteDataSourceHash() =>
    r'a7b924e7ad35a5b6619f823f28ba44c0d8129358';

/// Delegation Remote DataSource
/// Handles all delegation-related Supabase operations
///
/// Copied from [delegationRemoteDataSource].
@ProviderFor(delegationRemoteDataSource)
final delegationRemoteDataSourceProvider =
    AutoDisposeProvider<DelegationRemoteDataSource>.internal(
  delegationRemoteDataSource,
  name: r'delegationRemoteDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$delegationRemoteDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DelegationRemoteDataSourceRef
    = AutoDisposeProviderRef<DelegationRemoteDataSource>;
String _$roleRepositoryHash() => r'465d1eef88ac8c8cc1d1e56e209ff08d47122072';

/// Role Repository
/// Implements domain RoleRepository interface
///
/// Copied from [roleRepository].
@ProviderFor(roleRepository)
final roleRepositoryProvider = AutoDisposeProvider<RoleRepository>.internal(
  roleRepository,
  name: r'roleRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$roleRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RoleRepositoryRef = AutoDisposeProviderRef<RoleRepository>;
String _$delegationRepositoryHash() =>
    r'69696f8a33cad29f7fc2cf996c2229eb5b221ea6';

/// Delegation Repository
/// Implements domain DelegationRepository interface
///
/// Copied from [delegationRepository].
@ProviderFor(delegationRepository)
final delegationRepositoryProvider =
    AutoDisposeProvider<DelegationRepository>.internal(
  delegationRepository,
  name: r'delegationRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$delegationRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DelegationRepositoryRef = AutoDisposeProviderRef<DelegationRepository>;
String _$createRoleUseCaseHash() => r'f582896aee60bdd76ef47186d5fc06b20d556e5c';

/// Create Role UseCase
///
/// Copied from [createRoleUseCase].
@ProviderFor(createRoleUseCase)
final createRoleUseCaseProvider =
    AutoDisposeProvider<CreateRoleUseCase>.internal(
  createRoleUseCase,
  name: r'createRoleUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$createRoleUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CreateRoleUseCaseRef = AutoDisposeProviderRef<CreateRoleUseCase>;
String _$updateRoleDetailsUseCaseHash() =>
    r'1a64b57636d7a3af8f44603b6d963e59053cc5c0';

/// Update Role Details UseCase
///
/// Copied from [updateRoleDetailsUseCase].
@ProviderFor(updateRoleDetailsUseCase)
final updateRoleDetailsUseCaseProvider =
    AutoDisposeProvider<UpdateRoleDetailsUseCase>.internal(
  updateRoleDetailsUseCase,
  name: r'updateRoleDetailsUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$updateRoleDetailsUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UpdateRoleDetailsUseCaseRef
    = AutoDisposeProviderRef<UpdateRoleDetailsUseCase>;
String _$updateRolePermissionsUseCaseHash() =>
    r'bb4f8e3671b2573bf5d355f6d8a167c3dd2e8870';

/// Update Role Permissions UseCase
///
/// Copied from [updateRolePermissionsUseCase].
@ProviderFor(updateRolePermissionsUseCase)
final updateRolePermissionsUseCaseProvider =
    AutoDisposeProvider<UpdateRolePermissionsUseCase>.internal(
  updateRolePermissionsUseCase,
  name: r'updateRolePermissionsUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$updateRolePermissionsUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UpdateRolePermissionsUseCaseRef
    = AutoDisposeProviderRef<UpdateRolePermissionsUseCase>;
String _$assignUserToRoleUseCaseHash() =>
    r'0f6a31c158dd11568d2f9d50ecaea260c42a79b8';

/// Assign User to Role UseCase
///
/// Copied from [assignUserToRoleUseCase].
@ProviderFor(assignUserToRoleUseCase)
final assignUserToRoleUseCaseProvider =
    AutoDisposeProvider<AssignUserToRoleUseCase>.internal(
  assignUserToRoleUseCase,
  name: r'assignUserToRoleUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$assignUserToRoleUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AssignUserToRoleUseCaseRef
    = AutoDisposeProviderRef<AssignUserToRoleUseCase>;
String _$getRoleMembersUseCaseHash() =>
    r'10076537fe4cbb8341792141fa49cfcce948209c';

/// Get Role Members UseCase
///
/// Copied from [getRoleMembersUseCase].
@ProviderFor(getRoleMembersUseCase)
final getRoleMembersUseCaseProvider =
    AutoDisposeProvider<GetRoleMembersUseCase>.internal(
  getRoleMembersUseCase,
  name: r'getRoleMembersUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getRoleMembersUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetRoleMembersUseCaseRef
    = AutoDisposeProviderRef<GetRoleMembersUseCase>;
String _$getUserRoleAssignmentsUseCaseHash() =>
    r'5c6299e01029fa61de728f6c9d2af09ab0116602';

/// Get User Role Assignments UseCase
///
/// Copied from [getUserRoleAssignmentsUseCase].
@ProviderFor(getUserRoleAssignmentsUseCase)
final getUserRoleAssignmentsUseCaseProvider =
    AutoDisposeProvider<GetUserRoleAssignmentsUseCase>.internal(
  getUserRoleAssignmentsUseCase,
  name: r'getUserRoleAssignmentsUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getUserRoleAssignmentsUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetUserRoleAssignmentsUseCaseRef
    = AutoDisposeProviderRef<GetUserRoleAssignmentsUseCase>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
