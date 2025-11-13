import 'package:myfinance_improved/core/utils/datetime_utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/role_model.dart';

/// Remote Data Source: Role Remote Data Source
///
/// Handles all Supabase API calls for role data.
/// This is the only place that knows about Supabase implementation details.
class RoleRemoteDataSource {
  final SupabaseClient _supabase;

  RoleRemoteDataSource(this._supabase);

  /// Fetch all roles from the database
  Future<List<RoleModel>> getAllRoles() async {
    try {
      final response = await _supabase
          .from('roles')
          .select('*')
          .order('role_name', ascending: true);

      return (response as List)
          .map((json) {
            try {
              return RoleModel.fromJson(json as Map<String, dynamic>);
            } catch (e) {
              return null;
            }
          })
          .whereType<RoleModel>()
          .toList();
    } catch (e) {
      throw Exception('Failed to load roles: $e');
    }
  }

  /// Fetch roles for a specific company
  Future<List<RoleModel>> getRolesByCompany(String companyId) async {
    try {
      final response = await _supabase
          .from('roles')
          .select('*')
          .or('company_id.eq.$companyId,company_id.is.null') // Include company-specific and global roles
          .order('role_name', ascending: true);

      final roles = <RoleModel>[];
      for (final json in response as List) {
        try {
          final role = RoleModel.fromJson(json as Map<String, dynamic>);
          roles.add(role);
        } catch (e) {
          // Skip invalid records
        }
      }

      return roles;
    } catch (e) {
      throw Exception('Failed to load company roles: $e');
    }
  }

  /// Update user role in user_roles table
  Future<void> updateUserRole(String userId, String roleId) async {
    try {
      // Check if user_role record exists (handle multiple records)
      final existingRecords = await _supabase
          .from('user_roles')
          .select('*')
          .eq('user_id', userId)
          .or('is_deleted.is.null,is_deleted.eq.false') // Only get non-deleted records
          .order('updated_at', ascending: false); // Get latest first

      if (existingRecords.isNotEmpty) {
        // Use the most recent record
        final latestRecord = existingRecords.first;

        // If there are multiple records, mark the older ones as deleted
        if (existingRecords.length > 1) {
          for (int i = 1; i < existingRecords.length; i++) {
            await _supabase
                .from('user_roles')
                .update({
                  'is_deleted': true,
                  'deleted_at': DateTimeUtils.nowUtc(),
                  'updated_at': DateTimeUtils.nowUtc(),
                })
                .eq('user_role_id', existingRecords[i]['user_role_id'] as Object);
          }
        }

        // Update the latest record
        await _supabase
            .from('user_roles')
            .update({
              'role_id': roleId,
              'updated_at': DateTimeUtils.nowUtc(),
            })
            .eq('user_role_id', latestRecord['user_role_id'] as Object)
            .select();
      } else {
        // Insert new record
        await _supabase
            .from('user_roles')
            .insert({
              'user_id': userId,
              'role_id': roleId,
              'created_at': DateTimeUtils.nowUtc(),
              'updated_at': DateTimeUtils.nowUtc(),
            })
            .select();
      }
    } catch (e) {
      if (e.toString().contains('JWT') || e.toString().contains('auth')) {
        throw Exception('Authentication error. Please log in again.');
      } else if (e.toString().contains('RLS') || e.toString().contains('permission')) {
        throw Exception('Permission denied. You may not have access to update user roles.');
      } else {
        throw Exception('Failed to update user role: $e');
      }
    }
  }

  /// Get role by ID
  Future<RoleModel?> getRoleById(String roleId) async {
    try {
      final response = await _supabase
          .from('roles')
          .select('*')
          .eq('role_id', roleId)
          .maybeSingle();

      if (response == null) {
        return null;
      }

      return RoleModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  /// Get role by name
  Future<RoleModel?> getRoleByName(String roleName) async {
    try {
      final response = await _supabase
          .from('roles')
          .select('*')
          .eq('role_name', roleName)
          .maybeSingle();

      if (response == null) {
        return null;
      }

      return RoleModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }
}
