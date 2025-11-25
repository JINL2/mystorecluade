import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/store_shift_repository.dart';

/// Store Shift Repository Provider Interface
///
/// This provider is defined at Domain level to maintain Clean Architecture.
/// The actual implementation is provided by the Data layer through override.
///
/// Benefits:
/// - Presentation layer doesn't directly depend on Data layer
/// - Repository implementation can be easily swapped for testing
/// - Clear separation of concerns across layers
///
/// Usage in Data layer:
/// ```dart
/// final storeShiftRepositoryProvider = Provider<StoreShiftRepository>((ref) {
///   final dataSource = ref.watch(storeShiftDataSourceProvider);
///   return StoreShiftRepositoryImpl(dataSource);
/// });
/// ```
final storeShiftRepositoryProvider = Provider<StoreShiftRepository>((ref) {
  throw UnimplementedError(
    'storeShiftRepositoryProvider must be overridden by Data layer.\n'
    'Import repository_providers.dart from data layer to provide the implementation.',
  );
});
