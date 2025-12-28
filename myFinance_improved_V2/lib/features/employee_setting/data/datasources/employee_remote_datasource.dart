import 'package:myfinance_improved/core/utils/datetime_utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/value_objects/currency_identifier.dart';
import '../../domain/value_objects/salary_update_request.dart';
import '../models/currency_type_model.dart';
import '../models/employee_salary_model.dart';
import '../models/shift_audit_log_model.dart';

/// Remote Data Source: Employee Remote Data Source
///
/// Handles all Supabase API calls for employee data.
/// This is the only place that knows about Supabase implementation details.
class EmployeeRemoteDataSource {
  final SupabaseClient _supabase;

  EmployeeRemoteDataSource(this._supabase);

  /// Get all employees for a company
  Future<List<EmployeeSalaryModel>> getEmployeeSalaries(String companyId) async {
    try {
      if (companyId.isEmpty) {
        throw Exception('Company ID is required');
      }

      final response = await _supabase
          .from('v_user_salary')
          .select()
          .eq('company_id', companyId)
          .order('full_name', ascending: true);

      return (response as List)
          .map((json) {
            try {
              return EmployeeSalaryModel.fromJson(json as Map<String, dynamic>);
            } catch (e) {
              return null;
            }
          })
          .whereType<EmployeeSalaryModel>()
          .toList();
    } catch (e) {
      throw Exception('Failed to load employee salaries: $e');
    }
  }

  /// Search employees by query and optional filters
  Future<List<EmployeeSalaryModel>> searchEmployees({
    required String companyId,
    String? searchQuery,
    String? storeId,
  }) async {
    try {
      if (companyId.isEmpty) {
        throw Exception('Company ID is required');
      }

      var query = _supabase
          .from('v_user_salary')
          .select()
          .eq('company_id', companyId);

      if (searchQuery != null && searchQuery.isNotEmpty) {
        query = query.or(
          'full_name.ilike.%$searchQuery%,role_name.ilike.%$searchQuery%',
        );
      }

      if (storeId != null && storeId.isNotEmpty) {
        query = query.eq('store_id', storeId);
      }

      final response = await query.order('full_name', ascending: true);

      return (response as List)
          .map((json) {
            try {
              return EmployeeSalaryModel.fromJson(json as Map<String, dynamic>);
            } catch (e) {
              return null;
            }
          })
          .whereType<EmployeeSalaryModel>()
          .toList();
    } catch (e) {
      throw Exception('Failed to search employees: $e');
    }
  }

  /// Get available currency types
  Future<List<CurrencyTypeModel>> getCurrencyTypes() async {
    try {
      final response = await _supabase
          .from('currency_types')
          .select('*')
          .eq('is_active', true)
          .order('currency_name', ascending: true);

      if (response.isEmpty) {
        // Return default currencies if none found
        return _getDefaultCurrencies();
      }

      return (response as List)
          .map((json) {
            try {
              return CurrencyTypeModel.fromJson(json as Map<String, dynamic>);
            } catch (e) {
              return null;
            }
          })
          .whereType<CurrencyTypeModel>()
          .toList();
    } catch (e) {
      // Return default currencies on error
      return _getDefaultCurrencies();
    }
  }

  /// Update employee salary information
  Future<void> updateSalary(SalaryUpdateRequest request) async {
    try {
      // First, check if the record exists
      final existingRecord = await _supabase
          .from('user_salaries')
          .select('*')
          .eq('salary_id', request.salaryId)
          .maybeSingle();

      if (existingRecord == null) {
        throw Exception('No salary record found with salary_id: ${request.salaryId}');
      }

      // Resolve currency identifier to UUID
      final identifier = CurrencyIdentifier(request.currencyId);
      String currencyIdToUse = request.currencyId;

      // If it's a currency code (e.g., "USD", "VND"), look up the UUID
      if (identifier.isCode) {
        try {
          final currencyRecord = await _supabase
              .from('currency_types')
              .select('currency_id, currency_code, currency_name')
              .eq('currency_code', request.currencyId)
              .single();

          currencyIdToUse = currencyRecord['currency_id'] as String;
        } catch (e) {
          // Fallback: use the existing currency_id from the record
          currencyIdToUse = existingRecord['currency_id'] as String;
        }
      }

      // Update the user_salaries table
      final response = await _supabase
          .from('user_salaries')
          .update({
            'salary_amount': request.salaryAmount,
            'salary_type': request.salaryType,
            'currency_id': currencyIdToUse,
            'updated_at': DateTimeUtils.nowUtc(),
          })
          .eq('salary_id', request.salaryId)
          .select();

      if (response.isEmpty) {
        throw Exception('Update failed - no rows affected for salary_id: ${request.salaryId}');
      }
    } catch (e) {
      if (e.toString().contains('JWT') || e.toString().contains('auth')) {
        throw Exception('Authentication error. Please log in again.');
      } else if (e.toString().contains('RLS') || e.toString().contains('permission')) {
        throw Exception('Permission denied. You may not have access to update this salary.');
      } else if (e.toString().contains('column') && e.toString().contains('does not exist')) {
        throw Exception('Database schema error: ${e.toString()}');
      } else {
        throw Exception('Failed to update salary: $e');
      }
    }
  }

  /// Watch real-time updates for employee salaries
  Stream<List<EmployeeSalaryModel>> watchEmployeeSalaries(String companyId) {
    if (companyId.isEmpty) {
      return Stream.value([]);
    }

    return _supabase
        .from('v_user_salary')
        .stream(primaryKey: ['salary_id'])
        .eq('company_id', companyId)
        .order('full_name', ascending: true)
        .map(
          (data) => data
              .map((json) {
                try {
                  return EmployeeSalaryModel.fromJson(json);
                } catch (e) {
                  // Log parsing error but continue with other items
                  print('Warning: Failed to parse employee salary: $e');
                  return null;
                }
              })
              .whereType<EmployeeSalaryModel>()
              .toList(),
        )
        .handleError((Object error) {
          // Log stream error
          print('Error in employee salary stream: $error');
          // Return empty list on error but keep stream alive
          return <EmployeeSalaryModel>[];
        });
  }

  /// Check if the current user is the owner of the specified company
  Future<bool> isCurrentUserOwner(String companyId) async {
    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        return false;
      }

      final response = await _supabase
          .from('companies')
          .select('owner_id')
          .eq('company_id', companyId)
          .eq('is_deleted', false)
          .maybeSingle();

      if (response == null) {
        return false;
      }

      return response['owner_id'] == currentUserId;
    } catch (e) {
      return false;
    }
  }

  /// Validate employee deletion before executing
  /// Returns validation result with affected data summary
  Future<Map<String, dynamic>> validateEmployeeDelete({
    required String companyId,
    required String employeeUserId,
  }) async {
    try {
      final response = await _supabase.rpc<Map<String, dynamic>>(
        'validate_employee_delete',
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
  /// p_delete_salary: true to also delete salary info, false to preserve
  Future<Map<String, dynamic>> deleteEmployee({
    required String companyId,
    required String employeeUserId,
    bool deleteSalary = true,
  }) async {
    try {
      final response = await _supabase.rpc<Map<String, dynamic>>(
        'delete_employee',
        params: {
          'p_company_id': companyId,
          'p_employee_user_id': employeeUserId,
          'p_delete_salary': deleteSalary,
        },
      );

      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'DELETE_FAILED',
        'message': 'Failed to delete employee: $e',
      };
    }
  }

  /// Get employee shift audit logs with pagination
  Future<List<ShiftAuditLogModel>> getEmployeeShiftAuditLogs({
    required String userId,
    required String companyId,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final response = await _supabase.rpc(
        'get_employee_shift_audit_logs',
        params: {
          'p_user_id': userId,
          'p_company_id': companyId,
          'p_limit': limit,
          'p_offset': offset,
        },
      );

      if (response == null) {
        return [];
      }

      return (response as List)
          .map((json) {
            try {
              return ShiftAuditLogModel.fromJson(json as Map<String, dynamic>);
            } catch (e) {
              return null;
            }
          })
          .whereType<ShiftAuditLogModel>()
          .toList();
    } catch (e) {
      throw Exception('Failed to load shift audit logs: $e');
    }
  }

  /// Assign or unassign a work schedule template to an employee
  ///
  /// Uses RPC function 'assign_work_schedule_template'
  /// Pass null for templateId to unassign the current template
  Future<Map<String, dynamic>> assignWorkScheduleTemplate({
    required String userId,
    required String companyId,
    String? templateId,
  }) async {
    try {
      final response = await _supabase.rpc<Map<String, dynamic>>(
        'assign_work_schedule_template',
        params: {
          'p_user_id': userId,
          'p_company_id': companyId,
          'p_template_id': templateId,
        },
      );

      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'ASSIGN_FAILED',
        'message': 'Failed to assign work schedule template: $e',
      };
    }
  }

  /// Helper: Get default currencies
  List<CurrencyTypeModel> _getDefaultCurrencies() {
    return [
      const CurrencyTypeModel(
        currencyCode: 'USD',
        currencyName: 'US Dollar',
        symbol: '\$',
      ),
      const CurrencyTypeModel(
        currencyCode: 'EUR',
        currencyName: 'Euro',
        symbol: '€',
      ),
      const CurrencyTypeModel(
        currencyCode: 'VND',
        currencyName: 'Vietnamese Dong',
        symbol: '₫',
      ),
      const CurrencyTypeModel(
        currencyCode: 'KRW',
        currencyName: 'Korean Won',
        symbol: '₩',
      ),
    ];
  }
}
