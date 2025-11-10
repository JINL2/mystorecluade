import 'package:freezed_annotation/freezed_annotation.dart';

import '../entities/operation_result.dart';
import '../repositories/time_table_repository.dart';
import 'base_usecase.dart';

part 'insert_shift_schedule.freezed.dart';

/// Insert Shift Schedule UseCase
///
/// Inserts shift schedules for selected employees.
class InsertShiftSchedule
    implements UseCase<OperationResult, InsertShiftScheduleParams> {
  final TimeTableRepository _repository;

  InsertShiftSchedule(this._repository);

  @override
  Future<OperationResult> call(InsertShiftScheduleParams params) async {
    if (params.storeId.isEmpty) {
      throw ArgumentError('Store ID cannot be empty');
    }

    if (params.shiftId.isEmpty) {
      throw ArgumentError('Shift ID cannot be empty');
    }

    if (params.employeeIds.isEmpty) {
      throw ArgumentError('At least one employee must be selected');
    }

    return await _repository.insertShiftSchedule(
      storeId: params.storeId,
      shiftId: params.shiftId,
      employeeIds: params.employeeIds,
    );
  }
}

/// Parameters for InsertShiftSchedule UseCase
@freezed
class InsertShiftScheduleParams with _$InsertShiftScheduleParams {
  const factory InsertShiftScheduleParams({
    required String storeId,
    required String shiftId,
    required List<String> employeeIds,
  }) = _InsertShiftScheduleParams;
}
