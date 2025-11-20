import '../entities/shift_approval_result.dart';
import '../repositories/time_table_repository.dart';
import 'base_usecase.dart';

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
class ToggleShiftApprovalParams {
  final String shiftRequestId;
  final bool newApprovalState;

  const ToggleShiftApprovalParams({
    required this.shiftRequestId,
    required this.newApprovalState,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ToggleShiftApprovalParams &&
        other.shiftRequestId == shiftRequestId &&
        other.newApprovalState == newApprovalState;
  }

  @override
  int get hashCode => shiftRequestId.hashCode ^ newApprovalState.hashCode;
}
