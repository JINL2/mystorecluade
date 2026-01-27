import '../../domain/entities/employee_setting_data.dart';
import '../../domain/entities/shift_audit_log.dart';
import '../../domain/repositories/employee_repository.dart';
import '../../domain/value_objects/employee_update_request.dart';
import '../../domain/value_objects/salary_update_request.dart';
import '../datasources/employee_remote_datasource.dart';

/// Repository Implementation: Employee Repository
///
/// Implements the domain repository interface using the remote data source.
/// This layer converts between data models and domain entities.
class EmployeeRepositoryImpl implements EmployeeRepository {
  final EmployeeRemoteDataSource _remoteDataSource;

  EmployeeRepositoryImpl(this._remoteDataSource);

  @override
  Future<void> updateSalary(SalaryUpdateRequest request) async {
    await _remoteDataSource.updateSalary(request);
  }

  @override
  Future<Map<String, dynamic>> validateEmployeeDelete({
    required String companyId,
    required String employeeUserId,
  }) async {
    return _remoteDataSource.validateEmployeeDelete(
      companyId: companyId,
      employeeUserId: employeeUserId,
    );
  }

  @override
  Future<EmployeeDeleteResult> deleteEmployee({
    required String companyId,
    required String employeeUserId,
  }) async {
    return _remoteDataSource.deleteEmployee(
      companyId: companyId,
      employeeUserId: employeeUserId,
    );
  }

  @override
  Future<ShiftAuditLogsResult> getEmployeeShiftAuditLogs({
    required String companyId,
    required String employeeUserId,
    int limit = 20,
    int offset = 0,
  }) async {
    final model = await _remoteDataSource.getEmployeeShiftAuditLogs(
      companyId: companyId,
      employeeUserId: employeeUserId,
      limit: limit,
      offset: offset,
    );
    return model.toEntity();
  }

  @override
  Future<WorkScheduleAssignResult> assignWorkScheduleTemplate({
    required String companyId,
    required String employeeUserId,
    String? templateId,
  }) async {
    return _remoteDataSource.assignWorkScheduleTemplate(
      companyId: companyId,
      employeeUserId: employeeUserId,
      templateId: templateId,
    );
  }

  @override
  Future<EmployeeSettingData> getEmployeeSettingData({
    required String companyId,
    String? searchQuery,
    String? storeId,
  }) async {
    final model = await _remoteDataSource.getEmployeeSettingData(
      companyId: companyId,
      searchQuery: searchQuery,
      storeId: storeId,
    );
    return model.toEntity();
  }
}
