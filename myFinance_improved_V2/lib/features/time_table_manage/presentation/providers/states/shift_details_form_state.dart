import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/shift_card.dart';

part 'shift_details_form_state.freezed.dart';

/// Shift Details Form State
///
/// Manages the state of the Shift Details bottom sheet
@freezed
class ShiftDetailsFormState with _$ShiftDetailsFormState {
  const factory ShiftDetailsFormState({
    // Card data
    required ShiftCard card,

    // Edited values
    required String editedStartTime,
    required String editedEndTime,
    String? selectedTagType,
    String? tagContent,
    required bool isProblemSolved,

    // Original values for change tracking
    required String originalStartTime,
    required String originalEndTime,
    required bool originalProblemSolved,

    // Loading states
    @Default(false) bool isSaving,
    @Default(false) bool isDeletingTag,
    String? error,
  }) = _ShiftDetailsFormState;

  const ShiftDetailsFormState._();

  /// Check if any changes have been made
  bool get hasChanges {
    // Check if times have changed
    final timeChanged =
        editedStartTime != originalStartTime || editedEndTime != originalEndTime;

    // Check if problem status changed
    final problemChanged = isProblemSolved != originalProblemSolved;

    // Check if tag is being added
    final tagAdded = (selectedTagType != null &&
        tagContent != null &&
        tagContent!.isNotEmpty);

    return timeChanged || problemChanged || tagAdded;
  }

  /// Check if save button should be enabled
  bool get canSave => hasChanges && !isSaving;
}
