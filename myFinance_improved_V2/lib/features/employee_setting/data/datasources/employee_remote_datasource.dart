import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/value_objects/currency_identifier.dart';
import '../../domain/value_objects/employee_update_request.dart';
import '../../domain/value_objects/salary_update_request.dart';
import '../models/employee_setting_data_model.dart';
import '../models/shift_audit_log_model.dart';

/// Remote Data Source: Employee Remote Data Source
///
/// Handles all Supabase API calls for employee data.
/// This is the only place that knows about Supabase implementation details.
class EmployeeRemoteDataSource {
  final SupabaseClient _supabase;

  EmployeeRemoteDataSource(this._supabase);

  /// Update employee data (salary and/or role) in a single RPC call
  ///
  /// Uses RPC: employee_setting_update_employee (v1.1)
  /// This replaces multiple queries:
  /// - updateSalary: 3-4 queries → 1 RPC
  /// - updateUserRole: 2-4 queries → 1 RPC
  ///
  /// v1.1 Changes:
  /// - No permission check (page-level access control assumed)
  /// - SELF_MODIFY_ERROR → OWNER_MODIFY_ERROR
  ///
  /// Parameters:
  /// - [companyId]: Required. Company ID
  /// - [targetUserId]: Required. Employee's user ID (cannot be owner)
  /// - [salaryId]: Optional. Provide to update salary
  /// - [salaryAmount]: Optional. New salary amount
  /// - [salaryType]: Optional. Salary type (hourly, monthly, etc.)
  /// - [currencyId]: Optional. Currency UUID
  /// - [currencyCode]: Optional. Currency code (USD, VND, etc.)
  /// - [newRoleId]: Optional. New role ID to assign
  Future<EmployeeUpdateResult> updateEmployee(EmployeeUpdateRequest request) async {
    try {
      // Resolve currency code to UUID if needed
      String? currencyIdToUse = request.currencyId;
      String? currencyCodeToUse = request.currencyCode;

      // If currency is provided as code format, check if it needs resolution
      if (request.currencyId != null) {
        final identifier = CurrencyIdentifier(request.currencyId!);
        if (identifier.isCode) {
          // Pass as currency_code, let RPC resolve it
          currencyCodeToUse = request.currencyId;
          currencyIdToUse = null;
        }
      }

      final response = await _supabase.rpc<Map<String, dynamic>>(
        'employee_setting_update_employee',
        params: {
          'p_company_id': request.companyId,
          'p_target_user_id': request.targetUserId,
          'p_salary_id': request.salaryId,
          'p_salary_amount': request.salaryAmount,
          'p_salary_type': request.salaryType,
          'p_currency_id': currencyIdToUse,
          'p_currency_code': currencyCodeToUse,
          'p_new_role_id': request.newRoleId,
        },
      );

      if (response['success'] != true) {
        final error = response['error'] as String?;
        final message = response['message'] as String?;

        // Map error codes to user-friendly exceptions (v1.1)
        switch (error) {
          case 'COMPANY_NOT_FOUND':
            throw Exception('Company not found.');
          case 'OWNER_MODIFY_ERROR':
            throw Exception('Cannot modify owner data.');
          case 'SALARY_NOT_FOUND':
            throw Exception('Salary record not found for this employee.');
          case 'INVALID_CURRENCY':
            throw Exception(message ?? 'Invalid currency.');
          case 'INVALID_ROLE':
            throw Exception('Role not found in this company.');
          case 'OWNER_ASSIGN_ERROR':
            throw Exception('Cannot assign owner role to employee.');
          default:
            throw Exception(message ?? 'Failed to update employee.');
        }
      }

      final data = response['data'] as Map<String, dynamic>?;
      return EmployeeUpdateResult(
        salaryUpdated: data?['salary_updated'] as bool? ?? false,
        roleUpdated: data?['role_updated'] as bool? ?? false,
        targetUserId: data?['target_user_id'] as String?,
        newUserRoleId: data?['new_user_role_id'] as String?,
      );
    } catch (e) {
      if (e.toString().contains('Exception:')) {
        rethrow;
      }
      throw Exception('Failed to update employee: $e');
    }
  }

  /// Update employee salary information
  ///
  /// Uses RPC: employee_setting_update_employee (via updateEmployee)
  /// Now requires companyId and userId in request (no additional queries needed)
  Future<void> updateSalary(SalaryUpdateRequest request) async {
    await updateEmployee(
      EmployeeUpdateRequest.salary(
        companyId: request.companyId,
        targetUserId: request.userId,
        salaryId: request.salaryId,
        salaryAmount: request.salaryAmount,
        salaryType: request.salaryType,
        currencyId: request.currencyId,
      ),
    );
  }

  /// Validate employee deletion before executing
  /// Returns validation result with affected data summary
  ///
  /// Uses RPC: employee_setting_validate_employee_delete (v1.1)
  /// - No permission check (page-level access control assumed)
  /// - Self-deletion prevention (via auth.uid())
  /// - Comprehensive data impact summary (soft delete, preserved)
  /// - user_salaries in will_preserve (filtered by v_user_salary view)
  Future<Map<String, dynamic>> validateEmployeeDelete({
    required String companyId,
    required String employeeUserId,
  }) async {
    try {
      final response = await _supabase.rpc<Map<String, dynamic>>(
        'employee_setting_validate_employee_delete',
        params: {
          'p_company_id': companyId,
          'p_employee_user_id': employeeUserId,
        },
      );

      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'RPC_ERROR',
        'message': 'Failed to validate deletion: $e',
      };
    }
  }

  /// Delete employee from company (soft delete connections, preserve history)
  ///
  /// Uses RPC: employee_setting_delete_employee (v1.1)
  /// - No permission check (page-level access control assumed)
  /// - Soft deletes: user_companies, user_stores, user_roles
  /// - Preserves: user_salaries (filtered by v_user_salary view automatically)
  /// - Owner data protection (cannot delete company owner)
  /// - Self-deletion prevention (via auth.uid())
  Future<EmployeeDeleteResult> deleteEmployee({
    required String companyId,
    required String employeeUserId,
  }) async {
    try {
      final response = await _supabase.rpc<Map<String, dynamic>>(
        'employee_setting_delete_employee',
        params: {
          'p_company_id': companyId,
          'p_employee_user_id': employeeUserId,
        },
      );

      if (response['success'] != true) {
        final error = response['error'] as String?;
        final message = response['message'] as String?;

        // Map error codes to user-friendly exceptions (v1.1)
        switch (error) {
          case 'COMPANY_NOT_FOUND':
            throw Exception('Company not found.');
          case 'CANNOT_DELETE_OWNER':
            throw Exception('Cannot delete company owner.');
          case 'CANNOT_DELETE_SELF':
            throw Exception('Cannot delete yourself from the company.');
          case 'EMPLOYEE_NOT_FOUND':
            throw Exception('Employee not found in this company.');
          default:
            throw Exception(message ?? 'Failed to delete employee.');
        }
      }

      final data = response['data'] as Map<String, dynamic>?;
      final affected = data?['affected'] as Map<String, dynamic>?;

      return EmployeeDeleteResult(
        employeeId: data?['employee_id'] as String?,
        companyId: data?['company_id'] as String?,
        deletedAt: data?['deleted_at'] as String?,
        affectedUserCompanies: affected?['user_companies'] as int? ?? 0,
        affectedUserStores: affected?['user_stores'] as int? ?? 0,
        affectedUserRoles: affected?['user_roles'] as int? ?? 0,
      );
    } catch (e) {
      if (e.toString().contains('Exception:')) {
        rethrow;
      }
      throw Exception('Failed to delete employee: $e');
    }
  }

  /// Get employee shift audit logs with pagination
  ///
  /// Uses RPC: employee_setting_get_employee_shift_audit_logs (v1.1)
  /// - No permission check (page-level access control assumed)
  /// - Returns logs with pagination metadata (totalCount, hasMore)
  Future<ShiftAuditLogsResultModel> getEmployeeShiftAuditLogs({
    required String companyId,
    required String employeeUserId,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final response = await _supabase.rpc<Map<String, dynamic>>(
        'employee_setting_get_employee_shift_audit_logs',
        params: {
          'p_company_id': companyId,
          'p_employee_user_id': employeeUserId,
          'p_limit': limit,
          'p_offset': offset,
        },
      );

      if (response['success'] != true) {
        final error = response['error'] as String?;
        final message = response['message'] as String?;

        // Map error codes to user-friendly exceptions (v1.1)
        switch (error) {
          case 'COMPANY_NOT_FOUND':
            throw Exception('Company not found.');
          default:
            throw Exception(message ?? 'Failed to load shift audit logs.');
        }
      }

      final data = response['data'] as Map<String, dynamic>?;
      if (data == null) {
        return ShiftAuditLogsResultModel(
          logs: const [],
          pagination: ShiftAuditLogsPaginationModel(
            totalCount: 0,
            limit: limit,
            offset: offset,
            hasMore: false,
          ),
        );
      }

      return ShiftAuditLogsResultModel.fromJson(data);
    } catch (e) {
      if (e.toString().contains('Exception:')) {
        rethrow;
      }
      throw Exception('Failed to load shift audit logs: $e');
    }
  }

  /// Assign or unassign a work schedule template to an employee
  ///
  /// Uses RPC: employee_setting_assign_work_schedule_template (v1.1)
  /// - No permission check (page-level access control assumed)
  /// - Pass null for templateId to unassign the current template
  /// - Returns warning for non-monthly salary types
  Future<WorkScheduleAssignResult> assignWorkScheduleTemplate({
    required String companyId,
    required String employeeUserId,
    String? templateId,
  }) async {
    try {
      final response = await _supabase.rpc<Map<String, dynamic>>(
        'employee_setting_assign_work_schedule_template',
        params: {
          'p_company_id': companyId,
          'p_employee_user_id': employeeUserId,
          'p_template_id': templateId,
        },
      );

      if (response['success'] != true) {
        final error = response['error'] as String?;
        final message = response['message'] as String?;

        // Map error codes to user-friendly exceptions (v1.1)
        switch (error) {
          case 'COMPANY_NOT_FOUND':
            throw Exception('Company not found.');
          case 'EMPLOYEE_NOT_FOUND':
            throw Exception('Employee salary record not found in this company.');
          case 'TEMPLATE_NOT_FOUND':
            throw Exception('Template not found or does not belong to this company.');
          case 'UPDATE_FAILED':
            throw Exception('Failed to update employee record.');
          default:
            throw Exception(message ?? 'Failed to assign work schedule template.');
        }
      }

      final data = response['data'] as Map<String, dynamic>?;
      final warning = response['warning'] as String?;

      return WorkScheduleAssignResult(
        employeeUserId: data?['employee_user_id'] as String? ?? employeeUserId,
        templateId: data?['template_id'] as String?,
        templateName: data?['template_name'] as String?,
        salaryType: data?['salary_type'] as String? ?? '',
        action: data?['action'] as String? ?? 'unknown',
        warning: warning,
      );
    } catch (e) {
      if (e.toString().contains('Exception:')) {
        rethrow;
      }
      throw Exception('Failed to assign work schedule template: $e');
    }
  }

  /// Get all employee setting data in a single RPC call
  ///
  /// Uses RPC: employee_setting_employee_data
  /// This replaces 11 individual queries with one unified RPC
  /// Returns: employees, currencies, roles
  ///
  /// Note: No permission check - accessible to all authenticated users
  /// Use appState.isCurrentCompanyOwner for owner-only UI features
  Future<EmployeeSettingDataModel> getEmployeeSettingData({
    required String companyId,
    String? searchQuery,
    String? storeId,
  }) async {
    try {
      final response = await _supabase.rpc<Map<String, dynamic>>(
        'employee_setting_employee_data',
        params: {
          'p_company_id': companyId,
          'p_search_query': searchQuery,
          'p_store_id': storeId,
        },
      );

      return EmployeeSettingDataModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to load employee setting data: $e');
    }
  }
}
