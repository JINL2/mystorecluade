import '../../domain/entities/schedule_data.dart';
import 'employee_info_model.dart';
import 'shift_model.dart';

/// Schedule Data Model (DTO + Mapper)
class ScheduleDataModel {
  final List<EmployeeInfoModel> employees;
  final List<ShiftModel> shifts;
  final String storeId;

  const ScheduleDataModel({
    required this.employees,
    required this.shifts,
    required this.storeId,
  });

  factory ScheduleDataModel.fromJson(Map<String, dynamic> json) {
    // Handle both 'employees' and 'store_employees' keys for compatibility
    final employeesData = json['employees'] ?? json['store_employees'];
    // Handle both 'shifts' and 'store_shifts' keys for compatibility
    final shiftsData = json['shifts'] ?? json['store_shifts'];

    return ScheduleDataModel(
      employees: (employeesData as List<dynamic>?)
              ?.map((e) {
                final employeeMap = e as Map<String, dynamic>;
                // Map RPC response fields to model fields
                // RPC returns: user_id, full_name, email, display_name
                // Model expects: user_id, user_name, profile_image
                return EmployeeInfoModel.fromJson({
                  'user_id': employeeMap['user_id'],
                  'user_name': employeeMap['full_name'] ?? employeeMap['user_name'] ?? '',
                  'profile_image': employeeMap['profile_image'],
                  'position': employeeMap['position'],
                  'hourly_wage': employeeMap['hourly_wage'],
                });
              })
              .toList() ??
          [],
      shifts: (shiftsData as List<dynamic>?)
              ?.map((e) {
                final shiftMap = e as Map<String, dynamic>;
                // Map RPC response fields to model fields
                // RPC returns: shift_id, shift_name, start_time, end_time, display_name
                // Model expects: shift_id, shift_name, plan_start_time, plan_end_time, target_count, current_count
                return ShiftModel.fromJson({
                  'shift_id': shiftMap['shift_id'],
                  'shift_name': shiftMap['shift_name'],
                  'store_id': shiftMap['store_id'] ?? '',
                  'shift_date': shiftMap['shift_date'] ?? '',
                  // Map start_time/end_time to plan_start_time/plan_end_time
                  'plan_start_time': shiftMap['start_time'] ?? shiftMap['plan_start_time'] ?? '',
                  'plan_end_time': shiftMap['end_time'] ?? shiftMap['plan_end_time'] ?? '',
                  'target_count': shiftMap['target_count'] ?? shiftMap['required_employees'] ?? 0,
                  'current_count': shiftMap['current_count'] ?? 0,
                  'tags': shiftMap['tags'] ?? <String>[],
                });
              })
              .toList() ??
          [],
      storeId: json['store_id'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employees': employees.map((e) => e.toJson()).toList(),
      'shifts': shifts.map((e) => e.toJson()).toList(),
      'store_id': storeId,
    };
  }

  ScheduleData toEntity() {
    return ScheduleData(
      employees: employees.map((e) => e.toEntity()).toList(),
      shifts: shifts.map((e) => e.toEntity()).toList(),
      storeId: storeId,
    );
  }

  factory ScheduleDataModel.fromEntity(ScheduleData entity) {
    return ScheduleDataModel(
      employees: entity.employees
          .map((e) => EmployeeInfoModel.fromEntity(e))
          .toList(),
      shifts: entity.shifts
          .map((e) => ShiftModel.fromEntity(e))
          .toList(),
      storeId: entity.storeId,
    );
  }
}
