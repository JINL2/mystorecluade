import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/value_objects/employee_update_request.dart';
import 'employee_remote_datasource.dart';

/// Remote Data Source: Role Remote Data Source
///
/// Handles all Supabase API calls for role data.
/// This is the only place that knows about Supabase implementation details.
class RoleRemoteDataSource {
  final EmployeeRemoteDataSource _employeeDataSource;

  RoleRemoteDataSource(SupabaseClient supabase)
      : _employeeDataSource = EmployeeRemoteDataSource(supabase);

  /// Update user role assignment
  ///
  /// Uses RPC: employee_setting_update_employee (via EmployeeRemoteDataSource)
  /// This replaces 2-4 individual queries with a single RPC call.
  Future<void> updateUserRole({
    required String companyId,
    required String userId,
    required String roleId,
  }) async {
    await _employeeDataSource.updateEmployee(
      EmployeeUpdateRequest.role(
        companyId: companyId,
        targetUserId: userId,
        newRoleId: roleId,
      ),
    );
  }
}
