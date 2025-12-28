/// Store Presentation Layer Providers
///
/// Re-exports @riverpod generated providers for store feature.
/// All providers are now generated from notifier classes with @riverpod annotation.
///
/// Following Clean Architecture:
/// - NO imports from Data layer
/// - Only Domain layer imports allowed
///
/// Usage:
/// ```dart
/// // Watch state
/// final storeState = ref.watch(storeNotifierProvider);
///
/// // Trigger action
/// ref.read(storeNotifierProvider.notifier).createStore(
///   storeName: name,
///   companyId: companyId,
/// );
///
/// // Reset state
/// ref.read(storeNotifierProvider.notifier).reset();
/// ```
library;

// Re-export generated provider
export 'store_notifier.dart';
export 'states/store_state.dart';
