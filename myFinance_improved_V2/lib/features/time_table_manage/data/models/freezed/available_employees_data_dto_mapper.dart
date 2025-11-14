import '../../../domain/entities/available_employees_data.dart';
import 'available_employees_data_dto.dart';
import 'employee_info_dto_mapper.dart';
import 'shift_dto_mapper.dart';

/// Extension to map AvailableEmployeesDataDto → Domain Entity
extension AvailableEmployeesDataDtoMapper on AvailableEmployeesDataDto {
  AvailableEmployeesData toEntity() {
    return AvailableEmployeesData(
      availableEmployees: availableEmployees.map((e) => e.toEntity()).toList(),
      existingShifts: existingShifts.map((s) => s.toEntity()).toList(),
      storeId: storeId,
      shiftDate: shiftDate,
    );
  }
}
