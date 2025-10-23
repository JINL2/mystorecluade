import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/store_shift.dart';

part 'shift_form_state.freezed.dart';

/// Shift Form State - UI state for shift creation/edit form
///
/// Tracks form input values, validation errors, and submission state.
@freezed
class ShiftFormState with _$ShiftFormState {
  const factory ShiftFormState({
    // Form field values
    @Default('') String shiftName,
    @Default('09:00') String startTime,
    @Default('18:00') String endTime,
    @Default(0) int shiftBonus,

    // Form state
    @Default(false) bool isSubmitting,
    @Default(false) bool isValidating,

    // Edit mode
    String? editingShiftId,

    // Validation errors
    @Default({}) Map<String, String> fieldErrors,

    // General error
    String? errorMessage,

    // Success result
    StoreShift? savedShift,
  }) = _ShiftFormState;

  /// Initial state for creating new shift
  factory ShiftFormState.initial() => const ShiftFormState();

  /// State for editing existing shift
  factory ShiftFormState.forEdit(StoreShift shift) => ShiftFormState(
        editingShiftId: shift.shiftId,
        shiftName: shift.shiftName,
        startTime: shift.startTime,
        endTime: shift.endTime,
        shiftBonus: shift.shiftBonus,
      );
}

/// Shift Validation Result
///
/// Result of validating shift form inputs.
@freezed
class ShiftValidationResult with _$ShiftValidationResult {
  const factory ShiftValidationResult({
    @Default(true) bool isValid,
    @Default({}) Map<String, String> errors,
  }) = _ShiftValidationResult;

  /// Valid result
  factory ShiftValidationResult.valid() => const ShiftValidationResult();

  /// Invalid result with errors
  factory ShiftValidationResult.invalid(Map<String, String> errors) =>
      ShiftValidationResult(
        isValid: false,
        errors: errors,
      );
}

/// Shift Deletion State - UI state for shift deletion
///
/// Tracks deletion confirmation and progress.
@freezed
class ShiftDeletionState with _$ShiftDeletionState {
  const factory ShiftDeletionState({
    String? shiftIdToDelete,
    String? shiftNameToDelete,
    @Default(false) bool isDeleting,
    @Default(false) bool showConfirmation,
    String? errorMessage,
  }) = _ShiftDeletionState;

  /// Initial state
  factory ShiftDeletionState.initial() => const ShiftDeletionState();

  /// Confirmation state
  factory ShiftDeletionState.confirmDelete({
    required String shiftId,
    required String shiftName,
  }) =>
      ShiftDeletionState(
        shiftIdToDelete: shiftId,
        shiftNameToDelete: shiftName,
        showConfirmation: true,
      );

  /// Deleting state
  factory ShiftDeletionState.deleting({
    required String shiftId,
    required String shiftName,
  }) =>
      ShiftDeletionState(
        shiftIdToDelete: shiftId,
        shiftNameToDelete: shiftName,
        isDeleting: true,
      );
}
