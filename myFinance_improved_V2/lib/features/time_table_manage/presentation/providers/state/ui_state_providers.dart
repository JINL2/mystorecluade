/// UI State Providers
///
/// Simple UI state management (not business logic).
/// These providers manage transient UI state like selected dates.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

// ============================================================================
// Date Selection
// ============================================================================

/// Selected Date Provider
///
/// Manages the currently selected date in the overview and schedule tabs.
/// This is UI state only - not persisted or synchronized with backend.
///
/// Usage:
/// ```dart
/// // Read
/// final selectedDate = ref.watch(selectedDateProvider);
///
/// // Update
/// ref.read(selectedDateProvider.notifier).state = DateTime.now();
/// ```
final selectedDateProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});
