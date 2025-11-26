import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/supabase_service.dart';
import '../../domain/repositories/store_shift_repository.dart';
import '../datasources/store_shift_data_source.dart';
import 'store_shift_repository_impl.dart';

/// Re-export Domain provider interface
///
/// This allows Data layer to provide the implementation
/// while Presentation can import from Domain level
export '../../domain/providers/repository_provider.dart'
    show storeShiftRepositoryProvider;

/// ========================================
/// Data Layer Dependency Injection
/// ========================================
///
/// This file contains DI configuration for the data layer.
///
/// Clean Architecture Flow:
/// 1. Domain defines the interface: storeShiftRepositoryProvider (throws UnimplementedError)
/// 2. Data provides implementation: This file overrides with StoreShiftRepositoryImpl
/// 3. Presentation uses Domain provider: No direct dependency on Data layer
///
/// Usage in main.dart or app initialization:
/// ```dart
/// import 'features/store_shift/data/repositories/repository_providers.dart'
///     as store_shift_data;
/// import 'features/store_shift/domain/providers/repository_provider.dart'
///     as store_shift_domain;
///
/// ProviderScope(
///   overrides: [
///     store_shift_domain.storeShiftRepositoryProvider
///         .overrideWithProvider(store_shift_data.storeShiftRepositoryImplProvider),
///   ],
///   child: MyApp(),
/// )
/// ```

/// Data Source Provider (private to Data layer)
///
/// Creates the data source that handles Supabase operations.
/// Uses the global supabaseServiceProvider from core/services/supabase_service.dart
final _storeShiftDataSourceProvider = Provider<StoreShiftDataSource>((ref) {
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
  final dataSource = ref.watch(_storeShiftDataSourceProvider);
  return StoreShiftRepositoryImpl(dataSource);
});
