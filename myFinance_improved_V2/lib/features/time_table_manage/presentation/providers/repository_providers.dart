/// Repository Providers for Time Table Feature
///
/// This file manages all concrete implementations and their dependencies.
/// Presentation layer should NOT directly import Data layer classes.
///
/// Clean Architecture Compliance:
/// - Presentation → Domain (interface only)
/// - Data → Domain (implements interface)
/// - This file handles concrete implementations
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/datasources/time_table_datasource.dart';
import '../../data/repositories/time_table_repository_impl.dart';
import '../../domain/repositories/time_table_repository.dart';

// ============================================================================
// Infrastructure Layer (Supabase)
// ============================================================================

/// Supabase Client Provider
///
/// Provides access to Supabase client instance
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// ============================================================================
// Data Layer (Datasource)
// ============================================================================

/// Time Table Datasource Provider
///
/// Concrete implementation of data source using Supabase
/// Exposed for direct RPC calls that don't need full Clean Architecture flow
final timeTableDatasourceProvider = Provider<TimeTableDatasource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return TimeTableDatasource(client);
});

// ============================================================================
// Data Layer (Repository Implementation)
// ============================================================================

/// Time Table Repository Implementation Provider
///
/// Provides concrete implementation of TimeTableRepository
/// Presentation layer accesses this through the interface type
final timeTableRepositoryProvider = Provider<TimeTableRepository>((ref) {
  final datasource = ref.watch(timeTableDatasourceProvider);
  return TimeTableRepositoryImpl(datasource);
});
