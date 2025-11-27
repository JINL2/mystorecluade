import '../entities/operation_result.dart';
import '../repositories/time_table_repository.dart';
import 'base_usecase.dart';

/// Insert Schedule UseCase
///
/// Inserts a new schedule (assigns employee to shift) using v3 RPC.
/// - p_request_date is DATE type (yyyy-MM-dd format)
/// - No timezone parameter needed - RPC handles UTC conversion internally
class InsertSchedule implements UseCase<OperationResult, InsertScheduleParams> {
  final TimeTableRepository _repository;

  InsertSchedule(this._repository);

  @override
  Future<OperationResult> call(InsertScheduleParams params) async {
    if (params.userId.isEmpty) {
      throw ArgumentError('User ID cannot be empty');
    }

    if (params.shiftId.isEmpty) {
      throw ArgumentError('Shift ID cannot be empty');
    }

    if (params.storeId.isEmpty) {
      throw ArgumentError('Store ID cannot be empty');
    }

    if (params.requestDate.isEmpty) {
      throw ArgumentError('Request date cannot be empty');
    }

    if (params.approvedBy.isEmpty) {
      throw ArgumentError('Approver ID cannot be empty');
    }

    return await _repository.insertSchedule(
      userId: params.userId,
      shiftId: params.shiftId,
      storeId: params.storeId,
      requestDate: params.requestDate,
      approvedBy: params.approvedBy,
    );
  }
}

/// Parameters for InsertSchedule UseCase
class InsertScheduleParams {
  final String userId;
  final String shiftId;
  final String storeId;
  final String requestDate; // yyyy-MM-dd format
  final String approvedBy;

  const InsertScheduleParams({
    required this.userId,
    required this.shiftId,
    required this.storeId,
    required this.requestDate,
    required this.approvedBy,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is InsertScheduleParams &&
        other.userId == userId &&
        other.shiftId == shiftId &&
        other.storeId == storeId &&
        other.requestDate == requestDate &&
        other.approvedBy == approvedBy;
  }

  @override
  int get hashCode =>
      userId.hashCode ^
      shiftId.hashCode ^
      storeId.hashCode ^
      requestDate.hashCode ^
      approvedBy.hashCode;
}
