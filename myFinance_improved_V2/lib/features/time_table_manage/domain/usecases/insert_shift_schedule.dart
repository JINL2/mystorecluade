import '../entities/operation_result.dart';
import '../repositories/time_table_repository.dart';
import 'base_usecase.dart';

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
class InsertShiftScheduleParams {
  final String storeId;
  final String shiftId;
  final List<String> employeeIds;

  const InsertShiftScheduleParams({
    required this.storeId,
    required this.shiftId,
    required this.employeeIds,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is InsertShiftScheduleParams &&
        other.storeId == storeId &&
        other.shiftId == shiftId &&
        _listEquals(other.employeeIds, employeeIds);
  }

  @override
  int get hashCode =>
      storeId.hashCode ^ shiftId.hashCode ^ employeeIds.hashCode;

  bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
