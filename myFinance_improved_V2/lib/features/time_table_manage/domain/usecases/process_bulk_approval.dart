import 'package:freezed_annotation/freezed_annotation.dart';

import '../entities/bulk_approval_result.dart';
import '../repositories/time_table_repository.dart';
import 'base_usecase.dart';

part 'process_bulk_approval.freezed.dart';

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
@freezed
class ProcessBulkApprovalParams with _$ProcessBulkApprovalParams {
  const factory ProcessBulkApprovalParams({
    required List<String> shiftRequestIds,
    required List<bool> approvalStates,
  }) = _ProcessBulkApprovalParams;
}
