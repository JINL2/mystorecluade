import 'package:myfinance_improved/core/monitoring/sentry_config.dart';
import 'package:myfinance_improved/core/utils/datetime_utils.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/value_objects/role_priority.dart';
import '../models/role_model.dart';

/// Remote data source for Role management
/// Handles all Supabase RPC calls and table queries
class RoleRemoteDataSource {
  final SupabaseClient _supabase;

  RoleRemoteDataSource(this._supabase);

  /// Get all roles for a company using optimized RPC
  /// RPC: get_company_roles_optimized
  /// Performance: 95% query reduction (1 RPC vs 1 + 2N queries)
  Future<List<RoleModel>> getAllCompanyRoles(
    String companyId,
    String? currentUserId,
  ) async {
    try {
      final response = await _supabase.rpc<List<dynamic>>(
        'get_company_roles_optimized',
        params: {
          'p_company_id': companyId,
          'p_current_user_id': currentUserId,
        },
      );

      // RPC returns a list of roles directly
      final rolesData = response ?? <dynamic>[];
      return rolesData.map((role) => RoleModel.fromJson(role as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('Failed to get company roles: $e');
    }
  }

  // getRoleById removed - data already available from get_company_roles_optimized RPC
  // All callers now receive companyId directly via widget parameters

  /// Create a new role using RPC
  /// RPC: delegate_role_manage_role (action: 'create')
  /// Replaces: 1 INSERT query
  Future<String> createRole({
    required String companyId,
    required String roleName,
    String? description,
    String roleType = 'custom',
    List<String>? tags,
  }) async {
    try {
      final result = await _supabase.rpc<Map<String, dynamic>>(
        'delegate_role_manage_role',
        params: {
          'p_action': 'create',
          'p_company_id': companyId,
          'p_role_name': roleName,
          'p_role_type': roleType,
          'p_description': description,
          'p_tags': tags ?? [],
        },
      );
      if (result['success'] == true) {
        return result['role_id'] as String;
      } else {
        throw Exception(result['message'] ?? 'Failed to create role');
      }
    } catch (e) {
      throw Exception('Failed to create role: $e');
    }
  }

  /// Update role details (name, description, tags) using RPC
  /// RPC: delegate_role_manage_role (action: 'update')
  /// Replaces: 1 UPDATE query
  Future<void> updateRoleDetails({
    required String roleId,
    required String roleName,
    String? description,
    List<String>? tags,
  }) async {
    try {
      final result = await _supabase.rpc<Map<String, dynamic>>(
        'delegate_role_manage_role',
        params: {
          'p_action': 'update',
          'p_role_id': roleId,
          'p_role_name': roleName,
          'p_description': description,
          if (tags != null) 'p_tags': tags,
        },
      );

      if (result['success'] != true) {
        throw Exception(result['message'] ?? 'Failed to update role');
      }
    } catch (e) {
      throw Exception('Failed to update role details: $e');
    }
  }

  /// Delete a role using RPC (soft delete)
  /// RPC: delegate_role_manage_role (action: 'delete')
  /// Replaces: 5 queries (Employee lookup, user_roles select, user reassignment, permissions delete, role delete)
  /// v2.0: Now requires deletedBy for audit trail
  Future<void> deleteRole({
    required String roleId,
    required String companyId,
    required String deletedBy,
  }) async {
    try {
      final result = await _supabase.rpc<Map<String, dynamic>>(
        'delegate_role_manage_role',
        params: {
          'p_action': 'delete',
          'p_role_id': roleId,
          'p_company_id': companyId,
          'p_deleted_by': deletedBy,
        },
      );

      if (result['success'] != true) {
        throw Exception(result['message'] ?? 'Failed to delete role');
      }
    } catch (e) {
      throw Exception('Failed to delete role: $e');
    }
  }

  /// Get role permissions with all available features categorized
  /// RPC: delegate_role_get_role_permissions
  /// Replaces: 2 calls (role_permissions SELECT + get_categories_with_features RPC)
  /// Performance: Single RPC returns both current permissions and all categories
  Future<Map<String, dynamic>> getRolePermissions(String roleId) async {
    try {
      final result = await _supabase.rpc<Map<String, dynamic>>(
        'delegate_role_get_role_permissions',
        params: {'p_role_id': roleId},
      );

      // Extract current permissions as Set<String> for O(1) lookup
      final permissionsList =
          (result['current_permissions'] as List<dynamic>?) ?? <dynamic>[];
      final currentPermissions =
          permissionsList.map((p) => p.toString()).toSet();

      return {
        'currentPermissions': currentPermissions,
        'categories': result['categories'] ?? <dynamic>[],
      };
    } catch (e) {
      return {
        'currentPermissions': <String>{},
        'categories': <dynamic>[],
      };
    }
  }

  /// Update role permissions using RPC
  /// RPC: delegate_role_update_permissions
  /// Replaces: 2 queries (DELETE + INSERT)
  Future<void> updateRolePermissions(
    String roleId,
    Set<String> newPermissions,
  ) async {
    try {
      final result = await _supabase.rpc<Map<String, dynamic>>(
        'delegate_role_update_permissions',
        params: {
          'p_role_id': roleId,
          'p_permissions': newPermissions.toList(),
        },
      );

      if (result['success'] != true) {
        throw Exception(result['message'] ?? 'Failed to update permissions');
      }
    } catch (e) {
      throw Exception('Failed to update role permissions: $e');
    }
  }

  /// Get role members using RPC
  /// RPC: delegate_role_get_members
  /// Replaces: 2 queries (user_roles SELECT + users SELECT)
  Future<List<Map<String, dynamic>>> getRoleMembers(String roleId) async {
    try {
      final response = await _supabase.rpc<List<dynamic>>(
        'delegate_role_get_members',
        params: {'p_role_id': roleId},
      );

      return response.map((dynamic item) {
        final data = item as Map<String, dynamic>;
        final firstName = data['first_name'] as String? ?? '';
        final lastName = data['last_name'] as String? ?? '';
        final fullName = '$firstName $lastName'.trim();

        // Convert assigned_at from UTC to local time
        final assignedAtUtc = data['assigned_at'] as String?;
        final assignedAtLocal = assignedAtUtc != null
            ? DateTimeUtils.toLocalSafe(assignedAtUtc)
            : null;

        return {
          'user_id': data['user_id'] as String,
          'name': fullName.isEmpty ? 'Unknown User' : fullName,
          'email': data['email'] as String? ?? 'No email',
          'created_at': assignedAtLocal?.toIso8601String(),
        };
      }).toList();
    } catch (e, stackTrace) {
      // Log error to Sentry for production monitoring
      await SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'DataSource: Failed to get role members',
        extra: {
          'role_id': roleId,
          'layer': 'data_source',
          'method': 'getRoleMembers',
        },
        level: SentryLevel.error,
      );
      return [];
    }
  }

  /// Assign user to role using RPC
  /// RPC: delegate_role_assign_user
  /// Replaces: 5 queries (role lookup, duplicate check, company roles, existing roles, insert)
  Future<void> assignUserToRole({
    required String userId,
    required String roleId,
    required String companyId,
  }) async {
    try {
      final result = await _supabase.rpc<Map<String, dynamic>>(
        'delegate_role_assign_user',
        params: {
          'p_user_id': userId,
          'p_role_id': roleId,
          'p_company_id': companyId,
        },
      );

      if (result['success'] != true) {
        throw Exception(result['message'] ?? 'Failed to assign user to role');
      }
    } catch (e) {
      throw Exception('Failed to assign user to role: $e');
    }
  }

  /// Get company users with roles using RPC
  /// RPC: delegate_role_get_company_users_with_roles
  /// Replaces: 2 queries (company owner lookup + get_company_users_with_roles)
  /// Performance: Single RPC returns all data including is_owner flag
  Future<List<Map<String, dynamic>>> getCompanyUsersWithRoles(
    String companyId,
  ) async {
    try {
      // Single RPC returns all user data including owner status
      final response = await _supabase.rpc<List<dynamic>>(
        'delegate_role_get_company_users_with_roles',
        params: {'p_company_id': companyId},
      );

      final usersWithRoles = <Map<String, dynamic>>[];
      final seenUsers = <String>{}; // Track unique users

      for (final item in response) {
        final userId = item['user_id'] as String;

        // Skip duplicate users
        if (seenUsers.contains(userId)) {
          continue;
        }
        seenUsers.add(userId);

        final firstName = item['first_name'] as String? ?? '';
        final lastName = item['last_name'] as String? ?? '';
        final fullName = '$firstName $lastName'.trim();
        final isOwner = item['is_owner'] as bool? ?? false;

        // Determine role - Owner flag comes directly from RPC
        String role;
        if (isOwner) {
          role = 'Owner';
        } else {
          final roleNames = (item['role_name'] as String?) ?? 'No Role';
          if (roleNames.contains(',')) {
            // Multiple roles - use domain RolePriority to get highest priority
            final roles = roleNames.split(',').map((r) => r.trim()).toList();
            role = RolePriority.getHighestPriority(roles) ?? roles.first;
          } else {
            role = roleNames;
          }
        }

        usersWithRoles.add({
          'id': userId,
          'name': fullName.isEmpty ? 'Unknown User' : fullName,
          'email': item['email'] ?? '',
          'role': role,
        });
      }

      return usersWithRoles;
    } catch (e) {
      // Fallback to original logic if RPC function doesn't exist or fails
      return _getCompanyUsersWithRolesFallback(companyId);
    }
  }

  /// Fallback method for getting company users if RPC fails
  Future<List<Map<String, dynamic>>> _getCompanyUsersWithRolesFallback(
    String companyId,
  ) async {
    // Get company owner first
    String? companyOwnerId;
    try {
      final companyResponse = await _supabase
          .from('companies')
          .select('owner_id')
          .eq('company_id', companyId)
          .limit(1);

      if (companyResponse.isNotEmpty) {
        companyOwnerId = companyResponse.first['owner_id'] as String?;
      }
    } catch (e) {
      // Continue without owner info
    }

    // Get all users in the current company (fallback)
    final response = await _supabase
        .from('user_companies')
        .select('''
          user:users!user_id(user_id, first_name, last_name, email)
        ''')
        .eq('company_id', companyId)
        .eq('is_deleted', false);

    final usersWithRoles = <Map<String, dynamic>>[];
    final seenUsers = <String>{}; // Track unique users

    for (final item in response as List) {
      final user = item['user'];
      final userId = user['user_id'] as String;

      // Skip duplicate users
      if (seenUsers.contains(userId)) {
        continue;
      }
      seenUsers.add(userId);

      final firstName = (user['first_name'] as String?) ?? '';
      final lastName = (user['last_name'] as String?) ?? '';
      final fullName = '$firstName $lastName'.trim();

      // Get current role for this user (fallback logic)
      String currentRole = 'No Role';

      // Check if this user is the company owner first
      if (companyOwnerId == userId) {
        currentRole = 'Owner';
      } else {
        try {
          // Get user roles and filter by company on the Dart side
          final roleResponse = await _supabase
              .from('user_roles')
              .select('''
                role:roles!role_id(role_name, company_id)
              ''')
              .eq('user_id', userId as Object)
              .eq('is_deleted', false);

          // Filter for the current company and get the role name
          for (final roleData in roleResponse as List) {
            final role = roleData['role'];
            if (role != null && role['company_id'] == companyId) {
              currentRole = (role['role_name'] as String?) ?? 'No Role';
              break; // Take the first matching role for this company
            }
          }
        } catch (e) {
          // Silently handle role lookup errors
        }
      }

      usersWithRoles.add({
        'id': userId,
        'name': fullName.isEmpty ? 'Unknown User' : fullName,
        'email': user['email'] ?? '',
        'role': currentRole,
      });
    }

    return usersWithRoles;
  }

  /// Get all features with categories using RPC
  /// RPC: get_categories_with_features
  Future<List<Map<String, dynamic>>> getAllFeaturesWithCategories() async {
    try {
      final categories = await _supabase.rpc<List<dynamic>>('get_categories_with_features');
      return categories.cast<Map<String, dynamic>>();
    } catch (e) {
      return [];
    }
  }
}
