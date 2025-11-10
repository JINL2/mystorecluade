import 'package:freezed_annotation/freezed_annotation.dart';

import '../entities/operation_result.dart';
import '../repositories/time_table_repository.dart';
import 'base_usecase.dart';

part 'insert_schedule.freezed.dart';

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
@freezed
class InsertScheduleParams with _$InsertScheduleParams {
  const factory InsertScheduleParams({
    required String userId,
    required String shiftId,
    required String storeId,
    required String requestDate,
    required String approvedBy,
  }) = _InsertScheduleParams;
}
