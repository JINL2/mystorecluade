import '../../../domain/entities/employee_info.dart';
import 'employee_info_dto.dart';

/// Extension to map EmployeeInfoDto → Domain Entity
extension EmployeeInfoDtoMapper on EmployeeInfoDto {
  EmployeeInfo toEntity() {
    return EmployeeInfo(
      userId: userId,
      userName: userName,
      profileImage: profileImage,
      position: position,
      hourlyWage: hourlyWage,
    );
  }
}
