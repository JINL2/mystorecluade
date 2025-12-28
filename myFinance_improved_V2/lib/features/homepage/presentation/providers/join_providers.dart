/// Join Presentation Layer Providers
///
/// Re-exports @riverpod generated providers for join feature.
/// All providers are now generated from notifier classes with @riverpod annotation.
///
/// Following Clean Architecture:
/// - NO imports from Data layer
/// - Only Domain layer imports allowed
///
/// Usage:
/// ```dart
/// // Watch state
/// final joinState = ref.watch(joinNotifierProvider);
///
/// // Trigger action
/// ref.read(joinNotifierProvider.notifier).joinByCode(
///   userId: userId,
///   code: code,
/// );
///
/// // Reset state
/// ref.read(joinNotifierProvider.notifier).reset();
/// ```
library;

// Re-export generated provider
export 'join_notifier.dart';
export 'states/join_state.dart';
