import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_shift_form_state.freezed.dart';

/// Add Shift Form State
///
/// Manages the state of the Add Shift bottom sheet form
@freezed
class AddShiftFormState with _$AddShiftFormState {
  const factory AddShiftFormState({
    // Loading states
    @Default(false) bool isLoadingData,
    @Default(false) bool isSaving,
    String? error,

    // Form data
    @Default([]) List<Map<String, dynamic>> employees,
    @Default([]) List<Map<String, dynamic>> shifts,

    // Selected values
    String? selectedEmployeeId,
    String? selectedShiftId,
    DateTime? selectedDate,
  }) = _AddShiftFormState;

  const AddShiftFormState._();

  /// Check if form is valid (all required fields filled)
  bool get isFormValid =>
      selectedEmployeeId != null &&
      selectedShiftId != null &&
      selectedDate != null &&
      !isLoadingData &&
      !isSaving;

  /// Check if data is loaded
  bool get isDataLoaded => employees.isNotEmpty && shifts.isNotEmpty;
}
