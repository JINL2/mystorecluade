/// Store Data Layer Providers
///
/// This file contains all data layer providers for store feature.
/// These providers are internal to the data layer and should NOT be
/// imported directly by presentation layer.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/repositories/store_repository.dart';
import '../datasources/store_remote_datasource.dart';
import '../repositories/store_repository_impl.dart';
import 'company_providers.dart';

// ============================================================================
// Internal Providers (Private - used only within data layer)
// ============================================================================

/// Store Remote Data Source provider (Internal)
final storeRemoteDataSourceProvider = Provider<StoreRemoteDataSource>((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return StoreRemoteDataSourceImpl(supabaseClient);
});

// ============================================================================
// Public Repository Providers (Exposed to Domain layer)
// ============================================================================

/// Store Repository provider
///
/// Provides StoreRepositoryImpl implementation.
/// This is the ONLY provider that should be exported to domain layer.
final storeRepositoryProvider = Provider<StoreRepository>((ref) {
  final remoteDataSource = ref.watch(storeRemoteDataSourceProvider);
  return StoreRepositoryImpl(remoteDataSource);
});
