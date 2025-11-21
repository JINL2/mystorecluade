/// Join Data Layer Providers
///
/// This file contains all data layer providers for join feature.
/// These providers are internal to the data layer and should NOT be
/// imported directly by presentation layer.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/repositories/join_repository.dart';
import '../datasources/join_remote_datasource.dart';
import '../repositories/join_repository_impl.dart';
import 'company_providers.dart';

// ============================================================================
// Internal Providers (Private - used only within data layer)
// ============================================================================

/// Join Remote Data Source provider (Internal)
final joinRemoteDataSourceProvider = Provider<JoinRemoteDataSource>((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return JoinRemoteDataSourceImpl(supabaseClient);
});

// ============================================================================
// Public Repository Providers (Exposed to Domain layer)
// ============================================================================

/// Join Repository provider
///
/// Provides JoinRepositoryImpl implementation.
/// This is the ONLY provider that should be exported to domain layer.
final joinRepositoryProvider = Provider<JoinRepository>((ref) {
  final remoteDataSource = ref.watch(joinRemoteDataSourceProvider);
  return JoinRepositoryImpl(remoteDataSource);
});
