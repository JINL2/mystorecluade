// lib/features/delegate_role/di/delegate_role_providers.dart
//
// Centralized Dependency Injection for delegate_role feature
// All DataSource, Repository, and UseCase providers in one place
// Following Clean Architecture 2025 with @riverpod

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Data Layer
import '../data/datasources/delegation_remote_data_source.dart';
import '../data/datasources/role_remote_data_source.dart';
import '../data/repositories/delegation_repository_impl.dart';
import '../data/repositories/role_repository_impl.dart';

// Domain Layer
import '../domain/repositories/delegation_repository.dart';
import '../domain/repositories/role_repository.dart';
import '../domain/usecases/role/assign_user_to_role_usecase.dart';
import '../domain/usecases/role/create_role_usecase.dart';
import '../domain/usecases/role/get_role_members_usecase.dart';
import '../domain/usecases/role/get_user_role_assignments_usecase.dart';
import '../domain/usecases/role/update_role_details_usecase.dart';
import '../domain/usecases/role/update_role_permissions_usecase.dart';

part 'delegate_role_providers.g.dart';

// ============================================================================
// TIER 1: INFRASTRUCTURE - External Dependencies
// ============================================================================

/// Supabase Client Provider
/// Singleton instance for all database operations
@riverpod
SupabaseClient supabaseClient(SupabaseClientRef ref) {
  return Supabase.instance.client;
}

// ============================================================================
// TIER 2: DATA SOURCES - Database Communication
// ============================================================================

/// Role Remote DataSource
/// Handles all role-related Supabase operations
@riverpod
RoleRemoteDataSource roleRemoteDataSource(RoleRemoteDataSourceRef ref) {
  final client = ref.watch(supabaseClientProvider);
  return RoleRemoteDataSource(client);
}

/// Delegation Remote DataSource
/// Handles all delegation-related Supabase operations
@riverpod
DelegationRemoteDataSource delegationRemoteDataSource(
  DelegationRemoteDataSourceRef ref,
) {
  final client = ref.watch(supabaseClientProvider);
  return DelegationRemoteDataSource(client);
}

// ============================================================================
// TIER 3: REPOSITORIES - Domain Interface Implementations
// ============================================================================

/// Role Repository
/// Implements domain RoleRepository interface
@riverpod
RoleRepository roleRepository(RoleRepositoryRef ref) {
  final dataSource = ref.watch(roleRemoteDataSourceProvider);
  return RoleRepositoryImpl(dataSource);
}

/// Delegation Repository
/// Implements domain DelegationRepository interface
@riverpod
DelegationRepository delegationRepository(DelegationRepositoryRef ref) {
  final dataSource = ref.watch(delegationRemoteDataSourceProvider);
  return DelegationRepositoryImpl(dataSource);
}

// ============================================================================
// TIER 4: USE CASES - Business Logic
// ============================================================================

/// Create Role UseCase
@riverpod
CreateRoleUseCase createRoleUseCase(CreateRoleUseCaseRef ref) {
  final repository = ref.watch(roleRepositoryProvider);
  return CreateRoleUseCase(repository: repository);
}

/// Update Role Details UseCase
@riverpod
UpdateRoleDetailsUseCase updateRoleDetailsUseCase(
  UpdateRoleDetailsUseCaseRef ref,
) {
  final repository = ref.watch(roleRepositoryProvider);
  return UpdateRoleDetailsUseCase(repository: repository);
}

/// Update Role Permissions UseCase
@riverpod
UpdateRolePermissionsUseCase updateRolePermissionsUseCase(
  UpdateRolePermissionsUseCaseRef ref,
) {
  final repository = ref.watch(roleRepositoryProvider);
  return UpdateRolePermissionsUseCase(repository: repository);
}

/// Assign User to Role UseCase
@riverpod
AssignUserToRoleUseCase assignUserToRoleUseCase(
  AssignUserToRoleUseCaseRef ref,
) {
  final repository = ref.watch(roleRepositoryProvider);
  return AssignUserToRoleUseCase(repository: repository);
}

/// Get Role Members UseCase
@riverpod
GetRoleMembersUseCase getRoleMembersUseCase(GetRoleMembersUseCaseRef ref) {
  final repository = ref.watch(roleRepositoryProvider);
  return GetRoleMembersUseCase(repository: repository);
}

/// Get User Role Assignments UseCase
@riverpod
GetUserRoleAssignmentsUseCase getUserRoleAssignmentsUseCase(
  GetUserRoleAssignmentsUseCaseRef ref,
) {
  final repository = ref.watch(roleRepositoryProvider);
  return GetUserRoleAssignmentsUseCase(repository: repository);
}
