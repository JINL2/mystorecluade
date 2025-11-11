import '../../../domain/entities/employee_info.dart';
import 'store_employee_dto.dart';

/// Extension to map StoreEmployeeDto → Domain Entity
extension StoreEmployeeDtoMapper on StoreEmployeeDto {
  EmployeeInfo toEntity() {
    return EmployeeInfo(
      userId: userId,
      userName: fullName,
      profileImage: null, // Not provided in RPC response
      position: null, // Not provided in RPC response
      hourlyWage: null, // Not provided in RPC response
    );
  }
}
