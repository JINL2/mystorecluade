import '../entities/operation_result.dart';
import '../repositories/time_table_repository.dart';
import 'base_usecase.dart';

/// Insert Schedule UseCase
///
/// Inserts a new schedule (assigns employee to shift).
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

    if (params.requestTime.isEmpty) {
      throw ArgumentError('Request time cannot be empty');
    }

    if (params.approvedBy.isEmpty) {
      throw ArgumentError('Approver ID cannot be empty');
    }

    return await _repository.insertSchedule(
      userId: params.userId,
      shiftId: params.shiftId,
      storeId: params.storeId,
      requestTime: params.requestTime,
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
  final String requestTime;
  final String approvedBy;
  final String timezone;

  const InsertScheduleParams({
    required this.userId,
    required this.shiftId,
    required this.storeId,
    required this.requestTime,
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
        other.requestTime == requestTime &&
        other.approvedBy == approvedBy &&
        other.timezone == timezone;
  }

  @override
  int get hashCode =>
      userId.hashCode ^
      shiftId.hashCode ^
      storeId.hashCode ^
      requestTime.hashCode ^
      approvedBy.hashCode ^
      timezone.hashCode;
}
