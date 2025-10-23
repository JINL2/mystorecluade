import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/supabase_service.dart';
import '../../domain/repositories/store_shift_repository.dart';
import '../datasources/store_shift_data_source.dart';
import 'store_shift_repository_impl.dart';

/// ========================================
/// Data Layer Dependency Injection
/// ========================================
///
/// This file contains all DI configuration for the data layer.
/// Presentation layer should NOT import this file.
/// Instead, presentation imports domain interfaces only.

/// Data Source Provider
///
/// Creates the data source that handles Supabase operations.
/// Uses the global supabaseServiceProvider from core/services/supabase_service.dart
final storeShiftDataSourceProvider = Provider<StoreShiftDataSource>((ref) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  return StoreShiftDataSource(supabaseService);
});

/// Repository Provider
///
/// Provides the repository implementation.
/// Returns the interface type (StoreShiftRepository) to maintain
/// Clean Architecture dependency rules.
final storeShiftRepositoryProvider = Provider<StoreShiftRepository>((ref) {
  final dataSource = ref.watch(storeShiftDataSourceProvider);
  return StoreShiftRepositoryImpl(dataSource);
});
