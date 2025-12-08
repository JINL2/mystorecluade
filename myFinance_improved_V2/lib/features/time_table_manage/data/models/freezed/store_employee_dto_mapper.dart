import '../../../domain/entities/employee_info.dart';
import '../../../domain/entities/store_employee.dart';
import 'store_employee_dto.dart';

/// Extension to map StoreEmployeeDto → Domain Entity
extension StoreEmployeeDtoMapper on StoreEmployeeDto {
  /// Convert to EmployeeInfo entity (for schedule display)
  EmployeeInfo toEmployeeInfo() {
    return EmployeeInfo(
      userId: userId,
      userName: fullName,
      profileImage: null, // Not provided in RPC response
      position: null, // Not provided in RPC response
      hourlyWage: null, // Not provided in RPC response
    );
  }

  /// Convert to StoreEmployee entity (for filtering)
  StoreEmployee toStoreEmployee() {
    return StoreEmployee(
      userId: userId,
      fullName: fullName,
      email: email.isEmpty ? null : email,
    );
  }
}
