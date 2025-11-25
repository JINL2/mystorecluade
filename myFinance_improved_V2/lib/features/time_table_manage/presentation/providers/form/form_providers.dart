/// Form Providers for Time Table Feature
///
/// This file contains form state providers for:
/// - Add Shift Form
/// - Shift Details Form
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app/providers/app_state_provider.dart';
import '../../../di/dependency_injection.dart';
import '../../../domain/entities/shift_card.dart';
import '../notifiers/add_shift_form_notifier.dart';
import '../notifiers/shift_details_form_notifier.dart';
import '../states/add_shift_form_state.dart';
import '../states/shift_details_form_state.dart';

// ============================================================================
// Add Shift Form Provider
// ============================================================================

/// Add Shift Form Provider
///
/// Manages the state of the Add Shift bottom sheet form.
/// Requires storeId parameter to load schedule data.
///
/// Usage:
/// ```dart
/// final formState = ref.watch(addShiftFormProvider(storeId));
/// final notifier = ref.read(addShiftFormProvider(storeId).notifier);
/// ```
final addShiftFormProvider = StateNotifierProvider.family<
    AddShiftFormNotifier,
    AddShiftFormState,
    String>((ref, storeId) {
  final repository = ref.watch(timeTableRepositoryProvider);
  final appState = ref.watch(appStateProvider);
  final timezone = (appState.user['timezone'] as String?) ?? 'UTC';
  return AddShiftFormNotifier(repository, storeId, timezone);
});

// ============================================================================
// Shift Details Form Provider
// ============================================================================

/// Shift Details Form Provider
///
/// Manages the state of the Shift Details bottom sheet.
/// Requires ShiftCard parameter to initialize form with existing data.
///
/// Usage:
/// ```dart
/// final formState = ref.watch(shiftDetailsFormProvider(card));
/// final notifier = ref.read(shiftDetailsFormProvider(card).notifier);
/// ```
final shiftDetailsFormProvider = StateNotifierProvider.family<
    ShiftDetailsFormNotifier,
    ShiftDetailsFormState,
    ShiftCard>((ref, card) {
  final repository = ref.watch(timeTableRepositoryProvider);
  final appState = ref.watch(appStateProvider);
  final timezone = (appState.user['timezone'] as String?) ?? 'UTC';
  return ShiftDetailsFormNotifier(card, repository, timezone);
});
