// lib/features/delegate_role/domain/providers/repository_providers.dart
//
// ✅ CLEAN ARCHITECTURE: Domain Layer Providers
// Domain layer can import Data implementations for Dependency Injection
// This follows the Dependency Inversion Principle

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers/datasource_providers.dart';
import '../../data/repositories/delegation_repository_impl.dart';
import '../../data/repositories/role_repository_impl.dart';
import '../repositories/delegation_repository.dart';
import '../repositories/role_repository.dart';

// ============================================================================
// Repository Providers - Tier 2: Data Access Layer
// ============================================================================

/// Role Repository Provider
///
/// 📜 계약 이행자 - Implements Domain Repository Interface
/// Uses RoleRemoteDataSource for Supabase communication
/// All role-related data access goes through this repository
///
/// ✅ Clean Architecture: Domain provides the interface, Data provides implementation
final roleRepositoryProvider = Provider<RoleRepository>((ref) {
  final dataSource = ref.watch(roleDataSourceProvider);
  return RoleRepositoryImpl(dataSource);
});

/// Delegation Repository Provider
///
/// 📜 계약 이행자 - Implements Domain Repository Interface
/// Uses DelegationRemoteDataSource for Supabase communication
/// All delegation-related data access goes through this repository
///
/// ✅ Clean Architecture: Domain provides the interface, Data provides implementation
final delegationRepositoryProvider = Provider<DelegationRepository>((ref) {
  final dataSource = ref.watch(delegationDataSourceProvider);
  return DelegationRepositoryImpl(dataSource);
});
