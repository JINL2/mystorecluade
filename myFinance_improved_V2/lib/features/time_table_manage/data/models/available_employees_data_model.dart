import '../../domain/entities/available_employees_data.dart';
import 'employee_info_model.dart';
import 'shift_model.dart';

/// Available Employees Data Model (DTO + Mapper)
class AvailableEmployeesDataModel {
  final List<EmployeeInfoModel> availableEmployees;
  final List<ShiftModel> existingShifts;
  final String storeId;
  final String shiftDate;

  const AvailableEmployeesDataModel({
    required this.availableEmployees,
    required this.existingShifts,
    required this.storeId,
    required this.shiftDate,
  });

  factory AvailableEmployeesDataModel.fromJson(Map<String, dynamic> json) {
    return AvailableEmployeesDataModel(
      availableEmployees: (json['available_employees'] as List<dynamic>?)
              ?.map((e) => EmployeeInfoModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      existingShifts: (json['existing_shifts'] as List<dynamic>?)
              ?.map((e) => ShiftModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      storeId: json['store_id'] as String? ?? '',
      shiftDate: json['shift_date'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'available_employees': availableEmployees.map((e) => e.toJson()).toList(),
      'existing_shifts': existingShifts.map((e) => e.toJson()).toList(),
      'store_id': storeId,
      'shift_date': shiftDate,
    };
  }

  AvailableEmployeesData toEntity() {
    return AvailableEmployeesData(
      availableEmployees: availableEmployees.map((e) => e.toEntity()).toList(),
      existingShifts: existingShifts.map((e) => e.toEntity()).toList(),
      storeId: storeId,
      shiftDate: shiftDate,
    );
  }

  factory AvailableEmployeesDataModel.fromEntity(AvailableEmployeesData entity) {
    return AvailableEmployeesDataModel(
      availableEmployees: entity.availableEmployees
          .map((e) => EmployeeInfoModel.fromEntity(e))
          .toList(),
      existingShifts: entity.existingShifts
          .map((e) => ShiftModel.fromEntity(e))
          .toList(),
      storeId: entity.storeId,
      shiftDate: entity.shiftDate,
    );
  }
}
