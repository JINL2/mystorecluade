/// Form Providers for Time Table Feature
///
/// This file contains form state providers for:
/// - Add Shift Form
///
/// Note: Migrated to @riverpod annotation pattern.
/// The actual provider is now generated in add_shift_form_notifier.g.dart
library;

// Re-export the new @riverpod generated provider
export '../notifiers/add_shift_form_notifier.dart';

// ============================================================================
// Add Shift Form Provider (Deprecated Alias)
// ============================================================================

// The provider has been migrated to @riverpod annotation pattern.
// Use addShiftFormNotifierProvider(storeId) instead.
//
// New Usage:
// ```dart
// final formState = ref.watch(addShiftFormNotifierProvider(storeId));
// final notifier = ref.read(addShiftFormNotifierProvider(storeId).notifier);
// ```
//
// The provider is now generated from AddShiftFormNotifier class
// in add_shift_form_notifier.dart
