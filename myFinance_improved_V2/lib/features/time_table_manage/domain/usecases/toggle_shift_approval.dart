import '../repositories/time_table_repository.dart';
import 'base_usecase.dart';

/// Toggle Shift Approval UseCase (v2)
///
/// Uses toggle_shift_approval_v2 RPC
/// - Toggles approval status for one or more shift requests
/// - Updates approved_by and updated_at_utc
/// - Updates start_time_utc and end_time_utc from store_shifts
/// - Handles overnight shifts correctly
class ToggleShiftApproval
    implements UseCase<void, ToggleShiftApprovalParams> {
  final TimeTableRepository _repository;

  ToggleShiftApproval(this._repository);

  @override
  Future<void> call(ToggleShiftApprovalParams params) async {
    return await _repository.toggleShiftApproval(
      shiftRequestIds: params.shiftRequestIds,
      userId: params.userId,
    );
  }
}

/// Parameters for ToggleShiftApproval UseCase
class ToggleShiftApprovalParams {
  final List<String> shiftRequestIds;
  final String userId;

  const ToggleShiftApprovalParams({
    required this.shiftRequestIds,
    required this.userId,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ToggleShiftApprovalParams &&
        _listEquals(other.shiftRequestIds, shiftRequestIds) &&
        other.userId == userId;
  }

  @override
  int get hashCode => Object.hash(
        Object.hashAll(shiftRequestIds),
        userId,
      );

  bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
