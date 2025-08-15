import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/employee_salary.dart';
import '../models/currency_type.dart';
import '../models/salary_update_request.dart';

class SalaryService {
  final SupabaseClient _supabase;

  SalaryService(this._supabase);

  Future<List<EmployeeSalary>> getEmployeeSalaries(String companyId) async {
    try {
      if (companyId.isEmpty) {
        throw Exception('Company ID is required');
      }

      final response = await _supabase
          .from('v_user_salary')
          .select()
          .eq('company_id', companyId)
          .order('full_name', ascending: true);

      if (response == null) {
        return [];
      }

      return (response as List)
          .map((json) {
            try {
              return EmployeeSalary.fromJson(json as Map<String, dynamic>);
            } catch (e) {
              return null;
            }
          })
          .where((element) => element != null)
          .cast<EmployeeSalary>()
          .toList();
    } catch (e) {
      throw Exception('Failed to load employee salaries: $e');
    }
  }

  Future<List<EmployeeSalary>> searchEmployees({
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
            'full_name.ilike.%$searchQuery%,role_name.ilike.%$searchQuery%');
      }

      if (storeId != null && storeId.isNotEmpty) {
        query = query.eq('store_id', storeId);
      }

      final response = await query.order('full_name', ascending: true);

      if (response == null) {
        return [];
      }

      return (response as List)
          .map((json) {
            try {
              return EmployeeSalary.fromJson(json as Map<String, dynamic>);
            } catch (e) {
              return null;
            }
          })
          .where((element) => element != null)
          .cast<EmployeeSalary>()
          .toList();
    } catch (e) {
      throw Exception('Failed to search employees: $e');
    }
  }

  Future<List<CurrencyType>> getCurrencyTypes() async {
    try {
      final response = await _supabase
          .from('currency_types')
          .select('*')
          .eq('is_active', true)
          .order('currency_name', ascending: true);
      

      if (response == null) {
        // Return default currencies if none found (matching actual Supabase data)
        return [
          CurrencyType(currencyCode: 'USD', currencyName: 'US Dollar', symbol: '\$'),
          CurrencyType(currencyCode: 'EUR', currencyName: 'Euro', symbol: '€'),
          CurrencyType(currencyCode: 'VND', currencyName: 'Vietnamese Dong', symbol: '₫'),
          CurrencyType(currencyCode: 'KRW', currencyName: 'Korean Won', symbol: '₩'),
        ];
      }

      return (response as List)
          .map((json) {
            try {
              return CurrencyType.fromJson(json as Map<String, dynamic>);
            } catch (e) {
              return null;
            }
          })
          .where((element) => element != null)
          .cast<CurrencyType>()
          .toList();
    } catch (e) {
      // Return default currencies on error (matching actual Supabase data)
      return [
        CurrencyType(currencyCode: 'USD', currencyName: 'US Dollar', symbol: '\$'),
        CurrencyType(currencyCode: 'EUR', currencyName: 'Euro', symbol: '€'),
        CurrencyType(currencyCode: 'VND', currencyName: 'Vietnamese Dong', symbol: '₫'),
        CurrencyType(currencyCode: 'KRW', currencyName: 'Korean Won', symbol: '₩'),
      ];
    }
  }

  Future<void> updateSalary(SalaryUpdateRequest request) async {
    try {
      
      // First, let's check if the record exists by querying it
      final existingRecord = await _supabase
          .from('user_salaries')
          .select('*')
          .eq('salary_id', request.salaryId)
          .maybeSingle();
      
      
      if (existingRecord == null) {
        throw Exception('No salary record found with salary_id: ${request.salaryId}');
      }
      
      // The currency ID should already be correct from the dropdown
      // But let's add some validation
      String currencyIdToUse = request.currencyId;
      
      // The currency_id field in user_salaries expects a UUID
      // We need to look up the UUID from the currency_code
      if (request.currencyId.length < 10) { // If it's a code like "VND", "USD"
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
      } else {
        // Already a UUID, use as-is
        currencyIdToUse = request.currencyId;
      }
      
      
      // Update the user_salaries table using salary_id as primary key
      final response = await _supabase
          .from('user_salaries')
          .update({
            'salary_amount': request.salaryAmount,
            'salary_type': request.salaryType,
            'currency_id': currencyIdToUse,
            'updated_at': DateTime.now().toIso8601String(),
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

  Stream<List<EmployeeSalary>> watchEmployeeSalaries(String companyId) {
    if (companyId.isEmpty) {
      return Stream.value([]);
    }

    return _supabase
        .from('v_user_salary')
        .stream(primaryKey: ['salary_id'])
        .eq('company_id', companyId)
        .order('full_name', ascending: true)
        .map((data) => data
            .map((json) {
              try {
                return EmployeeSalary.fromJson(json as Map<String, dynamic>);
              } catch (e) {
                return null;
              }
            })
            .where((element) => element != null)
            .cast<EmployeeSalary>()
            .toList())
        .handleError((error) {
          return <EmployeeSalary>[];
        });
  }
}