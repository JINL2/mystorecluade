// lib/features/delegate_role/presentation/providers/repositories/repository_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/repositories/role_repository.dart';
import '../../../domain/repositories/delegation_repository.dart';
import '../../../data/repositories/role_repository_impl.dart';
import '../../../data/repositories/delegation_repository_impl.dart';
import '../infrastructure/datasource_providers.dart';

// ============================================================================
// Repository Providers - Tier 2: Data Access Layer
// ============================================================================

/// Role Repository Provider
///
/// 📜 계약 이행자 - Implements Domain Repository Interface
/// Uses RoleRemoteDataSource for Supabase communication
/// All role-related data access goes through this repository
final roleRepositoryProvider = Provider<RoleRepository>((ref) {
  final dataSource = ref.watch(roleDataSourceProvider);
  return RoleRepositoryImpl(dataSource);
});

/// Delegation Repository Provider
///
/// 📜 계약 이행자 - Implements Domain Repository Interface
/// Uses DelegationRemoteDataSource for Supabase communication
/// All delegation-related data access goes through this repository
final delegationRepositoryProvider = Provider<DelegationRepository>((ref) {
  final dataSource = ref.watch(delegationDataSourceProvider);
  return DelegationRepositoryImpl(dataSource);
});
