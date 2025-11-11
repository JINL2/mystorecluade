import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/shift_card.dart';
import '../../../domain/repositories/time_table_repository.dart';
import '../../../domain/value_objects/shift_time_formatter.dart';
import '../../../domain/value_objects/tag_input.dart';
import '../states/shift_details_form_state.dart';

/// Shift Details Form Notifier
///
/// Manages the business logic for the Shift Details form
class ShiftDetailsFormNotifier extends StateNotifier<ShiftDetailsFormState> {
  final TimeTableRepository _repository;

  ShiftDetailsFormNotifier(ShiftCard card, this._repository)
      : super(_createInitialState(card));

  /// Create initial state from card data
  static ShiftDetailsFormState _createInitialState(ShiftCard card) {
    // Initialize with confirmed times - convert UTC to local time for display
    final requestDate = card.requestDate;
    final editedStartTime = ShiftTimeFormatter.formatTime(
      card.confirmedStartTime?.toIso8601String(),
      requestDate,
    );
    final editedEndTime = ShiftTimeFormatter.formatTime(
      card.confirmedEndTime?.toIso8601String(),
      requestDate,
    );

    // Initialize problem solved state
    final isProblem = card.hasProblem;
    final wasSolved = card.isProblemSolved;

    final bool isProblemSolved;
    if (!isProblem) {
      // If not a problem, default to solved (clicked)
      isProblemSolved = true;
    } else if (isProblem && wasSolved) {
      // If problem and already solved, default to solved (clicked)
      isProblemSolved = true;
    } else {
      // If problem and not solved, default to unsolved (unclicked)
      isProblemSolved = false;
    }

    return ShiftDetailsFormState(
      card: card,
      editedStartTime: editedStartTime,
      editedEndTime: editedEndTime,
      originalStartTime: editedStartTime,
      originalEndTime: editedEndTime,
      isProblemSolved: isProblemSolved,
      originalProblemSolved: isProblemSolved,
    );
  }

  /// Update edited start time
  void updateStartTime(String time) {
    state = state.copyWith(editedStartTime: time);
  }

  /// Update edited end time
  void updateEndTime(String time) {
    state = state.copyWith(editedEndTime: time);
  }

  /// Update selected tag type
  void updateTagType(String? tagType) {
    state = state.copyWith(selectedTagType: tagType);
  }

  /// Update tag content
  void updateTagContent(String? content) {
    state = state.copyWith(tagContent: content);
  }

  /// Toggle problem solved status
  void toggleProblemSolved() {
    state = state.copyWith(isProblemSolved: !state.isProblemSolved);
  }

  /// Save changes
  Future<bool> saveChanges({
    required String managerId,
  }) async {
    if (!state.canSave) {
      return false;
    }

    state = state.copyWith(isSaving: true, error: null);

    try {
      // Prepare tag input if tag is being added
      TagInput? tagInput;
      if (state.selectedTagType != null &&
          state.tagContent != null &&
          state.tagContent!.isNotEmpty) {
        tagInput = TagInput(
          tagType: state.selectedTagType!,
          content: state.tagContent!,
        );
      }

      // Call repository to update shift
      await _repository.inputCard(
        managerId: managerId,
        shiftRequestId: state.card.shiftRequestId,
        confirmStartTime: state.editedStartTime,
        confirmEndTime: state.editedEndTime,
        newTagContent: tagInput?.content,
        newTagType: tagInput?.tagType,
        isLate: false, // TODO: Calculate based on times
        isProblemSolved: state.isProblemSolved,
      );

      // Update original values after successful save
      state = state.copyWith(
        originalStartTime: state.editedStartTime,
        originalEndTime: state.editedEndTime,
        originalProblemSolved: state.isProblemSolved,
        selectedTagType: null,
        tagContent: null,
        isSaving: false,
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// Delete a tag
  Future<bool> deleteTag({required String tagId, required String userId}) async {
    state = state.copyWith(isDeletingTag: true, error: null);

    try {
      await _repository.deleteShiftTag(tagId: tagId, userId: userId);

      state = state.copyWith(isDeletingTag: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isDeletingTag: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// Update bonus amount
  Future<bool> updateBonus({
    required double bonusAmount,
  }) async {
    state = state.copyWith(isSaving: true, error: null);

    try {
      await _repository.updateBonusAmount(
        shiftRequestId: state.card.shiftRequestId,
        bonusAmount: bonusAmount,
      );

      state = state.copyWith(isSaving: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: e.toString(),
      );
      return false;
    }
  }
}
