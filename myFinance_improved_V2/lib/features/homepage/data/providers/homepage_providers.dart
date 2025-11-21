/// Homepage Data Layer Providers
///
/// This file contains all data layer providers for homepage feature.
/// These providers are internal to the data layer and should NOT be
/// imported directly by presentation layer.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/supabase_service.dart';
import '../../domain/repositories/homepage_repository.dart';
import '../datasources/homepage_data_source.dart';
import '../repositories/homepage_repository_impl.dart';

// ============================================================================
// Internal Providers (Private - used only within data layer)
// ============================================================================

/// SupabaseService provider (Internal)
final _supabaseServiceProvider = Provider<SupabaseService>((ref) {
  return SupabaseService();
});

/// Homepage data source provider (Internal)
final homepageDataSourceProvider = Provider<HomepageDataSource>((ref) {
  final supabaseService = ref.read(_supabaseServiceProvider);
  return HomepageDataSource(supabaseService);
});

// ============================================================================
// Public Repository Providers (Exposed to Domain layer)
// ============================================================================

/// Homepage Repository provider
///
/// Provides HomepageRepositoryImpl implementation.
/// This is the ONLY provider that should be exported to domain layer.
final homepageRepositoryProvider = Provider<HomepageRepository>((ref) {
  final dataSource = ref.watch(homepageDataSourceProvider);
  return HomepageRepositoryImpl(dataSource: dataSource);
});
