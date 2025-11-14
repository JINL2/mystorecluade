import '../entities/available_employees_data.dart';
import '../repositories/time_table_repository.dart';
import 'base_usecase.dart';

/// Get Available Employees UseCase
///
/// Retrieves available employees for shift assignment on a specific date.
class GetAvailableEmployees
    implements UseCase<AvailableEmployeesData, GetAvailableEmployeesParams> {
  final TimeTableRepository _repository;

  GetAvailableEmployees(this._repository);

  @override
  Future<AvailableEmployeesData> call(
      GetAvailableEmployeesParams params,) async {
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
class GetAvailableEmployeesParams {
  final String storeId;
  final String shiftDate;

  const GetAvailableEmployeesParams({
    required this.storeId,
    required this.shiftDate,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GetAvailableEmployeesParams &&
        other.storeId == storeId &&
        other.shiftDate == shiftDate;
  }

  @override
  int get hashCode => storeId.hashCode ^ shiftDate.hashCode;
}
