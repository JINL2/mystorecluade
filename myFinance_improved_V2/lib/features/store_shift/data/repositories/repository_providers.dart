import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/supabase_service.dart';
import '../../domain/repositories/store_shift_repository.dart';
import '../datasources/store_shift_data_source.dart';
import 'store_shift_repository_impl.dart';

/// ========================================
/// Data Layer Dependency Injection
/// ========================================
///
/// This file contains DI configuration for the data layer.
///
/// ⚠️ IMPORTANT: This file should ONLY be imported in app initialization,
/// NOT in the Presentation layer.
///
/// Presentation layer imports domain/providers/repository_provider.dart instead.
///
/// Usage in main.dart or app initialization:
/// ```dart
/// import 'features/store_shift/data/repositories/repository_providers.dart';
/// import 'features/store_shift/domain/providers/repository_provider.dart';
///
/// ProviderScope(
///   overrides: [
///     storeShiftRepositoryProvider.overrideWithProvider(
///       storeShiftRepositoryImplProvider,
///     ),
///   ],
///   child: MyApp(),
/// )
/// ```

/// Data Source Provider
///
/// Creates the data source that handles Supabase operations.
/// Uses the global supabaseServiceProvider from core/services/supabase_service.dart
final storeShiftDataSourceProvider = Provider<StoreShiftDataSource>((ref) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  return StoreShiftDataSource(supabaseService);
});

/// Repository Implementation Provider
///
/// This provider supplies the concrete implementation of StoreShiftRepository.
/// It should be used to override the abstract provider defined in Domain layer.
///
/// ✅ Clean Architecture: Domain defines the interface, Data provides implementation
final storeShiftRepositoryImplProvider = Provider<StoreShiftRepository>((ref) {
  final dataSource = ref.watch(storeShiftDataSourceProvider);
  return StoreShiftRepositoryImpl(dataSource);
});
