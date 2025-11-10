import 'package:freezed_annotation/freezed_annotation.dart';

import '../entities/available_employees_data.dart';
import '../repositories/time_table_repository.dart';
import 'base_usecase.dart';

part 'get_available_employees.freezed.dart';

/// Get Available Employees UseCase
///
/// Retrieves available employees for shift assignment on a specific date.
class GetAvailableEmployees
    implements UseCase<AvailableEmployeesData, GetAvailableEmployeesParams> {
  final TimeTableRepository _repository;

  GetAvailableEmployees(this._repository);

  @override
  Future<AvailableEmployeesData> call(
      GetAvailableEmployeesParams params) async {
    if (params.storeId.isEmpty) {
      throw ArgumentError('Store ID cannot be empty');
    }

    if (params.shiftDate.isEmpty) {
      throw ArgumentError('Shift date cannot be empty');
    }

    return await _repository.getAvailableEmployees(
      storeId: params.storeId,
      shiftDate: params.shiftDate,
    );
  }
}

/// Parameters for GetAvailableEmployees UseCase
@freezed
class GetAvailableEmployeesParams with _$GetAvailableEmployeesParams {
  const factory GetAvailableEmployeesParams({
    required String storeId,
    required String shiftDate,
  }) = _GetAvailableEmployeesParams;
}
