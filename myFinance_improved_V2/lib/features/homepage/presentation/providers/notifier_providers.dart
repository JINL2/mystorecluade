/// Notifier Providers for homepage module
///
/// Re-exports generated @riverpod providers for backward compatibility.
/// All providers are now generated from notifier classes with @riverpod annotation.
///
/// Usage:
/// ```dart
/// // Watch state
/// final companyState = ref.watch(companyNotifierProvider);
///
/// // Trigger action
/// ref.read(companyNotifierProvider.notifier).createCompany(...);
///
/// // Reset state
/// ref.read(companyNotifierProvider.notifier).reset();
/// ```
library;

// Re-export generated providers for backward compatibility
export 'company_notifier.dart';
export 'store_notifier.dart';
export 'join_notifier.dart';

// Re-export states for convenience
export 'states/company_state.dart';
export 'states/store_state.dart';
export 'states/join_state.dart';
