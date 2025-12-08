/// Form Providers for Time Table Feature
///
/// This file contains form state providers for:
/// - Add Shift Form
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/utils/datetime_utils.dart';
import '../notifiers/add_shift_form_notifier.dart';
import '../states/add_shift_form_state.dart';
import '../usecase/time_table_usecase_providers.dart';

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
  // Use UseCases instead of Repository directly (Clean Architecture)
  final getScheduleDataUseCase = ref.watch(getScheduleDataUseCaseProvider);
  final insertScheduleUseCase = ref.watch(insertScheduleUseCaseProvider);
  // Use device local timezone instead of user DB timezone
  final timezone = DateTimeUtils.getLocalTimezone();
  return AddShiftFormNotifier(
    getScheduleDataUseCase,
    insertScheduleUseCase,
    storeId,
    timezone,
  );
});
