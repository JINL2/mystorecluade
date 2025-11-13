// lib/features/delegate_role/presentation/providers/infrastructure/datasource_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/datasources/delegation_remote_data_source.dart';
import '../../../data/datasources/role_remote_data_source.dart';

// ============================================================================
// Infrastructure Layer - Tier 1: External Dependencies
// ============================================================================

/// Supabase Client Provider
///
/// Provides singleton Supabase instance for all data sources
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// ============================================================================
// DataSource Providers - Infrastructure Layer
// ============================================================================

/// Role DataSource Provider
///
/// 🚚 배달 기사 - Handles direct communication with Supabase
/// Responsible for all role-related database operations
final roleDataSourceProvider = Provider<RoleRemoteDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return RoleRemoteDataSource(client);
});

/// Delegation DataSource Provider
///
/// 🚚 배달 기사 - Handles direct communication with Supabase
/// Responsible for all delegation-related database operations
final delegationDataSourceProvider = Provider<DelegationRemoteDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return DelegationRemoteDataSource(client);
});
