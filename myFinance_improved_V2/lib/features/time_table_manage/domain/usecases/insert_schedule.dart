import '../entities/operation_result.dart';
import '../repositories/time_table_repository.dart';
import 'base_usecase.dart';

/// Insert Schedule UseCase
///
/// Inserts a new schedule (assigns employee to shift) using v4 RPC.
/// - p_start_time and p_end_time are user's LOCAL timestamps (yyyy-MM-dd HH:mm:ss)
/// - p_timezone is required for converting local time to UTC
/// - No longer uses request_date or request_time columns
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

    if (params.startTime.isEmpty) {
      throw ArgumentError('Start time cannot be empty');
    }

    if (params.endTime.isEmpty) {
      throw ArgumentError('End time cannot be empty');
    }

    if (params.approvedBy.isEmpty) {
      throw ArgumentError('Approver ID cannot be empty');
    }

    if (params.timezone.isEmpty) {
      throw ArgumentError('Timezone cannot be empty');
    }

    return await _repository.insertSchedule(
      userId: params.userId,
      shiftId: params.shiftId,
      storeId: params.storeId,
      startTime: params.startTime,
      endTime: params.endTime,
      approvedBy: params.approvedBy,
      timezone: params.timezone,
    );
  }
}

/// Parameters for InsertSchedule UseCase
class InsertScheduleParams {
  final String userId;
  final String shiftId;
  final String storeId;
  final String startTime; // yyyy-MM-dd HH:mm:ss format (user's local time)
  final String endTime; // yyyy-MM-dd HH:mm:ss format (user's local time)
  final String approvedBy;
  final String timezone; // e.g., "Asia/Ho_Chi_Minh"

  const InsertScheduleParams({
    required this.userId,
    required this.shiftId,
    required this.storeId,
    required this.startTime,
    required this.endTime,
    required this.approvedBy,
    required this.timezone,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is InsertScheduleParams &&
        other.userId == userId &&
        other.shiftId == shiftId &&
        other.storeId == storeId &&
        other.startTime == startTime &&
        other.endTime == endTime &&
        other.approvedBy == approvedBy &&
        other.timezone == timezone;
  }

  @override
  int get hashCode =>
      userId.hashCode ^
      shiftId.hashCode ^
      storeId.hashCode ^
      startTime.hashCode ^
      endTime.hashCode ^
      approvedBy.hashCode ^
      timezone.hashCode;
}
