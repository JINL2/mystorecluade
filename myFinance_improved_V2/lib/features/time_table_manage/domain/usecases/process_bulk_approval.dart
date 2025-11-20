import '../entities/bulk_approval_result.dart';
import '../repositories/time_table_repository.dart';
import 'base_usecase.dart';

/// Process Bulk Approval UseCase
///
/// Processes bulk shift approval/rejection for multiple shift requests.
class ProcessBulkApproval
    implements UseCase<BulkApprovalResult, ProcessBulkApprovalParams> {
  final TimeTableRepository _repository;

  ProcessBulkApproval(this._repository);

  @override
  Future<BulkApprovalResult> call(ProcessBulkApprovalParams params) async {
    if (params.shiftRequestIds.isEmpty) {
      throw ArgumentError('At least one shift request must be provided');
    }

    if (params.shiftRequestIds.length != params.approvalStates.length) {
      throw ArgumentError(
        'Number of shift request IDs must match number of approval states',
      );
    }

    return await _repository.processBulkApproval(
      shiftRequestIds: params.shiftRequestIds,
      approvalStates: params.approvalStates,
    );
  }
}

/// Parameters for ProcessBulkApproval UseCase
class ProcessBulkApprovalParams {
  final List<String> shiftRequestIds;
  final List<bool> approvalStates;

  const ProcessBulkApprovalParams({
    required this.shiftRequestIds,
    required this.approvalStates,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProcessBulkApprovalParams &&
        _listEquals(other.shiftRequestIds, shiftRequestIds) &&
        _listEquals(other.approvalStates, approvalStates);
  }

  @override
  int get hashCode => shiftRequestIds.hashCode ^ approvalStates.hashCode;

  bool _listEquals<T>(List<T> a, List<T> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
