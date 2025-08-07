// lib/data/repositories/employee_repository.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/employee_detail.dart';

class EmployeeRepository {
  final SupabaseClient supabase;

  EmployeeRepository({required this.supabase});

  Stream<List<EmployeeDetail>> streamEmployees(String companyId) {
    return supabase
        .from('user_companies')
        .stream(primaryKey: ['user_id', 'company_id'])
        .eq('company_id', companyId)
        .asyncMap((data) async {
          final filtered = data.where((item) => item['is_deleted'] == false).toList();
          return await _processEmployeeData(filtered, companyId);
        });
  }

  Future<List<EmployeeDetail>> _processEmployeeData(List<Map<String, dynamic>> userCompanies, String companyId) async {
    final List<EmployeeDetail> employees = [];
    
    for (final record in userCompanies) {
      try {
        final userId = record['user_id'];
        
        // Fetch user details
        final userResponse = await supabase
            .from('users')
            .select('*')
            .eq('user_id', userId)
            .single();
        
        // Fetch role - same pattern as delegate role and role permission pages
        String? roleId;
        String? roleName;
        try {
          
          // Fetch all roles for the user and filter by company
          final rolesResponse = await supabase
              .from('user_roles')
              .select('''
                user_role_id,
                role_id,
                is_deleted,
                roles!inner(
                  role_id,
                  role_name,
                  role_type,
                  company_id
                )
              ''')
              .eq('user_id', userId)
              .eq('is_deleted', false);
                
          
          // Find the role for the current company
          for (final roleData in rolesResponse) {
            if (roleData['roles'] != null && roleData['roles']['company_id'] == companyId) {
              roleId = roleData['role_id'];
              roleName = roleData['roles']['role_name'];
              break;
            }
          }
          
        } catch (e) {
        }
        
        // Fetch salary
        Map<String, dynamic>? salaryData;
        try {
          final salaryResponse = await supabase
              .from('user_salaries')
              .select('*')
              .eq('user_id', userId)
              .eq('company_id', companyId)
              .order('created_at', ascending: false)
              .limit(1)
              .maybeSingle();
          salaryData = salaryResponse;
        } catch (e) {
          print('Error fetching salary for user $userId: $e');
        }
        
        // Fetch stores
        List<Map<String, dynamic>> stores = [];
        try {
          final storesResponse = await supabase
              .from('user_stores')
              .select('store_id, stores!inner(store_id, store_name)')
              .eq('user_id', userId)
              .eq('is_deleted', false);
          stores = List<Map<String, dynamic>>.from(storesResponse);
        } catch (e) {
          print('Error fetching stores for user $userId: $e');
        }
        
        final employee = EmployeeDetail(
          userId: userId,
          fullName: '${userResponse['first_name'] ?? ''} ${userResponse['last_name'] ?? ''}'.trim(),
          email: userResponse['email'],
          profileImage: userResponse['profile_image'],
          roleId: roleId,
          roleName: roleName,
          companyId: companyId,
          salaryId: salaryData?['salary_id'],
          salaryAmount: salaryData?['salary_amount']?.toDouble(),
          salaryType: salaryData?['salary_type'],
          currencyId: salaryData?['currency_id'],
          currencySymbol: '\$', // Default to USD for now
          hireDate: record['created_at'] != null ? DateTime.parse(record['created_at']) : null,
          isActive: true,
          createdAt: userResponse['created_at'] != null ? DateTime.parse(userResponse['created_at']) : null,
          updatedAt: userResponse['updated_at'] != null ? DateTime.parse(userResponse['updated_at']) : null,
          firstName: userResponse['first_name'],
          lastName: userResponse['last_name'],
          storeId: stores.isNotEmpty ? stores.first['store_id'] : null,
          storeName: stores.isNotEmpty ? stores.first['stores']['store_name'] : null,
          phoneNumber: userResponse['phone_number'],
          dateOfBirth: userResponse['date_of_birth'] != null ? DateTime.parse(userResponse['date_of_birth']) : null,
        );
        
        employees.add(employee);
      } catch (e) {
        print('Error processing employee data: $e');
      }
    }
    
    return employees;
  }

  Future<Map<String, dynamic>> getEmployeeAttendance(String userId) async {
    // Mock attendance data for now since attendance system is not in current database
    return {
      'attendanceRate': 95,
      'lateCount': 3,
      'overtimeHours': 12,
      'totalShifts': 20,
    };
  }

  Future<List<Map<String, dynamic>>> getCurrencies() async {
    try {
      final response = await supabase
          .from('currencies')
          .select('*')
          .order('currency_code');
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching currencies: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getCompanyRoles(String companyId) async {
    try {
      final response = await supabase
          .from('roles')
          .select('*')
          .eq('company_id', companyId)
          .order('role_name');
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching company roles: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getCompanyStores(String companyId) async {
    try {
      final response = await supabase
          .from('stores')
          .select('*')
          .eq('company_id', companyId)
          .eq('is_deleted', false)
          .order('store_name');
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching company stores: $e');
      return [];
    }
  }
}