/// Repository Providers for time_table_manage module
///
/// Following Clean Architecture pattern: Presentation layer imports this file
/// through domain/providers/repository_providers.dart facade.
///
/// Private providers (_prefix) are internal to Data layer.
/// Public providers expose Domain interfaces to Presentation layer.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/repositories/time_table_repository.dart';
import '../datasources/time_table_datasource.dart';
import '../repositories/time_table_repository_impl.dart';

// ============================================================================
// Internal Providers (Private - used only within this file)
// ============================================================================

/// Supabase client provider (Internal)
final _supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Time Table datasource provider (Internal)
///
/// Creates the datasource that handles all Supabase RPC calls
final _timeTableDatasourceProvider = Provider<TimeTableDatasource>((ref) {
  final client = ref.watch(_supabaseClientProvider);
  return TimeTableDatasource(client);
});

// ============================================================================
// Public Repository Providers (Exposed to Presentation layer)
// ============================================================================

/// Time Table repository provider
///
/// Provides TimeTableRepositoryImpl implementation.
/// Presentation layer should import this through domain/providers facade.
final timeTableRepositoryProvider = Provider<TimeTableRepository>((ref) {
  final datasource = ref.watch(_timeTableDatasourceProvider);
  return TimeTableRepositoryImpl(datasource);
});
