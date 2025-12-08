import '../../../domain/entities/schedule_data.dart';
import 'schedule_data_dto.dart';
import 'store_employee_dto_mapper.dart';
import 'store_shift_dto_mapper.dart';

/// Extension to map ScheduleDataDto → Domain Entity
extension ScheduleDataDtoMapper on ScheduleDataDto {
  ScheduleData toEntity({required String storeId, String shiftDate = ''}) {
    return ScheduleData(
      employees: storeEmployees.map((e) => e.toEmployeeInfo()).toList(),
      shifts: storeShifts
          .map((s) => s.toEntity(storeId: storeId, shiftDate: shiftDate))
          .toList(),
      storeId: storeId,
    );
  }
}
