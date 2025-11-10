import 'package:freezed_annotation/freezed_annotation.dart';

import '../entities/shift_approval_result.dart';
import '../repositories/time_table_repository.dart';
import 'base_usecase.dart';

part 'toggle_shift_approval.freezed.dart';

/// Toggle Shift Approval UseCase
///
/// Toggles the approval status of a shift request.
class ToggleShiftApproval
    implements UseCase<ShiftApprovalResult, ToggleShiftApprovalParams> {
  final TimeTableRepository _repository;

  ToggleShiftApproval(this._repository);

  @override
  Future<ShiftApprovalResult> call(ToggleShiftApprovalParams params) async {
    return await _repository.toggleShiftApproval(
      shiftRequestId: params.shiftRequestId,
      newApprovalState: params.newApprovalState,
    );
  }
}

/// Parameters for ToggleShiftApproval UseCase
@freezed
class ToggleShiftApprovalParams with _$ToggleShiftApprovalParams {
  const factory ToggleShiftApprovalParams({
    required String shiftRequestId,
    required bool newApprovalState,
  }) = _ToggleShiftApprovalParams;
}
