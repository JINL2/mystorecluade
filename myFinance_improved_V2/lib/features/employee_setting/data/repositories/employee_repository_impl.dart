import '../../domain/entities/currency_type.dart';
import '../../domain/entities/employee_salary.dart';
import '../../domain/entities/shift_audit_log.dart';
import '../../domain/repositories/employee_repository.dart';
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
  Future<List<EmployeeSalary>> getEmployeeSalaries(String companyId) async {
    final models = await _remoteDataSource.getEmployeeSalaries(companyId);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<EmployeeSalary>> searchEmployees({
    required String companyId,
    String? searchQuery,
    String? storeId,
  }) async {
    final models = await _remoteDataSource.searchEmployees(
      companyId: companyId,
      searchQuery: searchQuery,
      storeId: storeId,
    );
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<CurrencyType>> getCurrencyTypes() async {
    final models = await _remoteDataSource.getCurrencyTypes();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> updateSalary(SalaryUpdateRequest request) async {
    await _remoteDataSource.updateSalary(request);
  }

  @override
  Stream<List<EmployeeSalary>> watchEmployeeSalaries(String companyId) {
    return _remoteDataSource
        .watchEmployeeSalaries(companyId)
        .map((models) => models.map((model) => model.toEntity()).toList());
  }

  @override
  Future<bool> isCurrentUserOwner(String companyId) async {
    return _remoteDataSource.isCurrentUserOwner(companyId);
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
  Future<Map<String, dynamic>> deleteEmployee({
    required String companyId,
    required String employeeUserId,
    bool deleteSalary = true,
  }) async {
    return _remoteDataSource.deleteEmployee(
      companyId: companyId,
      employeeUserId: employeeUserId,
      deleteSalary: deleteSalary,
    );
  }

  @override
  Future<List<ShiftAuditLog>> getEmployeeShiftAuditLogs({
    required String userId,
    required String companyId,
    int limit = 20,
    int offset = 0,
  }) async {
    final models = await _remoteDataSource.getEmployeeShiftAuditLogs(
      userId: userId,
      companyId: companyId,
      limit: limit,
      offset: offset,
    );
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Map<String, dynamic>> assignWorkScheduleTemplate({
    required String userId,
    required String companyId,
    String? templateId,
  }) async {
    return _remoteDataSource.assignWorkScheduleTemplate(
      userId: userId,
      companyId: companyId,
      templateId: templateId,
    );
  }
}
