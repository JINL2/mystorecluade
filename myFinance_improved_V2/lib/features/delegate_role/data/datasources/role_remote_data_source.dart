import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:myfinance_improved/core/utils/datetime_utils.dart';
import '../models/delegatable_role_model.dart';
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

  /// Get a single role by ID
  Future<RoleModel> getRoleById(String roleId) async {
    try {
      final response = await _supabase
          .from('roles')
          .select('*')
          .eq('role_id', roleId)
          .single();

      return RoleModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to get role: $e');
    }
  }

  /// Create a new role
  Future<String> createRole({
    required String companyId,
    required String roleName,
    String? description,
    String roleType = 'custom',
    List<String>? tags,
  }) async {
    try {
      final response = await _supabase
          .from('roles')
          .insert({
            'company_id': companyId,
            'role_name': roleName,
            'role_type': roleType,
            'description': description,
            'tags': tags ?? [],
          })
          .select()
          .single();

      return response['role_id'] as String;
    } on PostgrestException catch (e) {
      if (e.message.contains('jsonb')) {
        throw Exception('Failed to save tags: Invalid tag format');
      } else if (e.message.contains('duplicate')) {
        throw Exception('Role name already exists');
      } else {
        throw Exception('Database error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to create role: $e');
    }
  }

  /// Update role details (name, description, tags)
  Future<void> updateRoleDetails({
    required String roleId,
    required String roleName,
    String? description,
    List<String>? tags,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'role_name': roleName,
        'description': description,
        'updated_at': DateTimeUtils.nowUtc(),
      };

      if (tags != null) {
        updateData['tags'] = tags;
      }

      await _supabase.from('roles').update(updateData).eq('role_id', roleId);
    } on PostgrestException catch (e) {
      if (e.message.contains('jsonb')) {
        throw Exception('Failed to save tags: Invalid tag format');
      } else if (e.message.contains('duplicate')) {
        throw Exception('Role name already exists');
      } else {
        throw Exception('Database error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to update role details: $e');
    }
  }

  /// Delete a role
  Future<void> deleteRole(String roleId, String companyId) async {
    try {
      // First, find a default role to reassign users to (e.g., Employee role)
      final defaultRolesResponse = await _supabase
          .from('roles')
          .select('role_id')
          .eq('company_id', companyId)
          .eq('role_name', 'Employee')
          .limit(1);

      String? defaultRoleId;
      if (defaultRolesResponse.isNotEmpty) {
        defaultRoleId = defaultRolesResponse.first['role_id'] as String?;
      }

      // Get users currently assigned to this role
      final usersWithRole = await _supabase
          .from('user_roles')
          .select('user_id')
          .eq('role_id', roleId);

      // Handle user reassignment
      if (usersWithRole.isNotEmpty) {
        if (defaultRoleId != null) {
          // Reassign users to Employee role
          for (final userRole in usersWithRole) {
            await _supabase
                .from('user_roles')
                .update({'role_id': defaultRoleId})
                .eq('role_id', roleId)
                .eq('user_id', userRole['user_id'] as Object);
          }
        } else {
          // If no Employee role exists, remove user role assignments
          await _supabase.from('user_roles').delete().eq('role_id', roleId);
        }
      }

      // Delete role permissions
      await _supabase.from('role_permissions').delete().eq('role_id', roleId);

      // Delete the role
      await _supabase.from('roles').delete().eq('role_id', roleId);
    } catch (e) {
      throw Exception('Failed to delete role: $e');
    }
  }

  /// Get role permissions with all available features categorized
  Future<Map<String, dynamic>> getRolePermissions(String roleId) async {
    try {
      // Get current permissions for the role
      final permissionsResponse = await _supabase
          .from('role_permissions')
          .select('feature_id')
          .eq('role_id', roleId);

      final currentPermissions = (permissionsResponse as List)
          .map((p) => p['feature_id'] as String)
          .toSet();

      // Get all features with categories using RPC
      final categories = await _supabase.rpc<List<dynamic>>('get_categories_with_features');

      return {
        'currentPermissions': currentPermissions,
        'categories': categories,
      };
    } catch (e) {
      return {
        'currentPermissions': <String>{},
        'categories': [],
      };
    }
  }

  /// Update role permissions
  Future<void> updateRolePermissions(
    String roleId,
    Set<String> newPermissions,
  ) async {
    try {
      // First, delete all existing permissions for the role
      await _supabase.from('role_permissions').delete().eq('role_id', roleId);

      // Then, insert the new permissions
      if (newPermissions.isNotEmpty) {
        final permissionInserts = newPermissions
            .map((featureId) => {
                  'role_id': roleId,
                  'feature_id': featureId,
                })
            .toList();

        await _supabase.from('role_permissions').insert(permissionInserts);
      }
    } catch (e) {
      throw Exception('Failed to update role permissions: $e');
    }
  }

  /// Get roles that can be delegated by current user
  Future<List<DelegatableRoleModel>> getDelegatableRoles(
    String companyId,
    String currentUserRole,
  ) async {
    try {
      // Fetch all roles for the company
      final rolesResponse =
          await _supabase.from('roles').select('*').eq('company_id', companyId);

      final roles = rolesResponse as List;
      final canDelegateRoles = <DelegatableRoleModel>[];

      final normalizedCurrentRole = currentUserRole.toLowerCase();

      for (final role in roles) {
        final roleId = role['role_id'] as String;
        final roleName = role['role_name'] as String;
        final roleType = role['role_type'] as String? ?? '';

        bool canDelegate = false;
        String description = '';

        // Determine if current user can delegate this role
        if (normalizedCurrentRole == 'owner') {
          canDelegate = true;
          description = 'Full delegation rights as Owner';
        } else if (normalizedCurrentRole == 'manager') {
          // Managers can only delegate to employees
          if (roleName.toLowerCase() == 'employee') {
            canDelegate = true;
            description = 'Can delegate Employee role';
          }
        }

        if (canDelegate) {
          // Get permissions for this role
          final permissionsResponse = await _supabase
              .from('role_permissions')
              .select('feature_id')
              .eq('role_id', roleId);

          final permissions = (permissionsResponse as List)
              .map((p) => p['feature_id'] as String)
              .toList();

          canDelegateRoles.add(DelegatableRoleModel(
            roleId: roleId,
            roleName: roleName,
            description: description.isEmpty
                ? 'Role type: $roleType'
                : description,
            permissions: permissions,
            canDelegate: canDelegate,
          ));
        }
      }

      return canDelegateRoles;
    } catch (e) {
      return [];
    }
  }

  /// Get role members
  Future<List<Map<String, dynamic>>> getRoleMembers(String roleId) async {
    try {
      // Get user IDs from user_roles table
      final userRolesResponse = await _supabase
          .from('user_roles')
          .select('user_id, created_at')
          .eq('role_id', roleId)
          .eq('is_deleted', false);

      if (userRolesResponse.isEmpty) {
        return [];
      }

      // Extract user IDs
      final userIds =
          (userRolesResponse as List).map((item) => item['user_id']).toList();

      // Get user details from users table
      final usersResponse = await _supabase
          .from('users')
          .select('user_id, first_name, last_name, email')
          .inFilter('user_id', userIds);

      final members = <Map<String, dynamic>>[];

      for (final user in usersResponse as List) {
        // Find the corresponding user_role entry to get created_at
        final userRole = (userRolesResponse as List).firstWhere(
          (role) => role['user_id'] == user['user_id'],
          orElse: () => {'created_at': null},
        );

        final firstName = user['first_name'] ?? '';
        final lastName = user['last_name'] ?? '';
        final fullName = '$firstName $lastName'.trim();

        // Convert created_at from UTC to local time
        final createdAtUtc = userRole['created_at'] as String?;
        final createdAtLocal = createdAtUtc != null
            ? DateTimeUtils.toLocalSafe(createdAtUtc)
            : null;

        members.add({
          'user_id': user['user_id'],
          'name': fullName.isEmpty ? 'Unknown User' : fullName,
          'email': user['email'] ?? 'No email',
          'created_at': createdAtLocal?.toIso8601String(),
        });
      }

      return members;
    } catch (e) {
      return [];
    }
  }

  /// Assign user to role
  Future<void> assignUserToRole({
    required String userId,
    required String roleId,
    required String companyId,
  }) async {
    try {
      // Get the company_id for this role
      final roleData = await _supabase
          .from('roles')
          .select('company_id')
          .eq('role_id', roleId)
          .single()
          .timeout(const Duration(seconds: 10));

      final roleCompanyId = roleData['company_id'] as String;

      // Check if user already has this exact role
      final existingExactRole = await _supabase
          .from('user_roles')
          .select('user_role_id')
          .eq('user_id', userId)
          .eq('role_id', roleId as Object)
          .eq('is_deleted', false)
          .timeout(const Duration(seconds: 10));

      if (existingExactRole.isNotEmpty) {
        throw Exception('User is already assigned to this role');
      }

      // Get all roles for this company to find any existing role
      final companyRoles = await _supabase
          .from('roles')
          .select('role_id')
          .eq('company_id', roleCompanyId as Object)
          .timeout(const Duration(seconds: 10));

      final roleIds = companyRoles.map((r) => r['role_id']).toList();

      // Check if user has any role in this company
      final existingUserRoles = await _supabase
          .from('user_roles')
          .select('user_role_id, role_id')
          .eq('user_id', userId)
          .inFilter('role_id', roleIds)
          .eq('is_deleted', false)
          .timeout(const Duration(seconds: 10));

      // Insert new role (trigger will handle deactivating old role if exists)
      await _supabase.from('user_roles').insert({
        'user_id': userId,
        'role_id': roleId,
        'created_at': DateTimeUtils.nowUtc(),
        'updated_at': DateTimeUtils.nowUtc(),
        'is_deleted': false,
      }).timeout(const Duration(seconds: 15));
    } catch (e) {
      throw Exception('Failed to assign user to role: $e');
    }
  }

  /// Get company users with roles using RPC
  /// RPC: get_company_users_with_roles
  Future<List<Map<String, dynamic>>> getCompanyUsersWithRoles(
    String companyId,
  ) async {
    try {
      // First, get the company owner information
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
        // Silently handle error - owner detection will fall back to role-based logic
      }

      // Use RPC function for reliable role lookup
      final response = await _supabase.rpc<List<dynamic>>(
        'get_company_users_with_roles',
        params: {'p_company_id': companyId},
      );

      final usersWithRoles = <Map<String, dynamic>>[];
      final seenUsers = <String>{}; // Track unique users

      for (final item in response as List) {
        final firstName = item['first_name'] as String? ?? '';
        final lastName = item['last_name'] as String? ?? '';
        final fullName = '$firstName $lastName'.trim();
        final userId = item['user_id'] as String;

        // Skip duplicate users
        if (seenUsers.contains(userId)) {
          continue;
        }
        seenUsers.add(userId);

        // Handle comma-separated role names from STRING_AGG
        String roleNames = (item['role_name'] as String?) ?? 'No Role';
        String role = roleNames;

        // If user is company owner, always show as Owner
        if (companyOwnerId == userId) {
          role = 'Owner';
        } else if (roleNames.contains(',')) {
          // Multiple roles - take the highest priority role
          final roles = roleNames.split(',').map((r) => r.trim()).toList();
          if (roles.contains('Owner')) {
            role = 'Owner';
          } else if (roles.contains('Manager')) {
            role = 'Manager';
          } else if (roles.contains('Employee')) {
            role = 'Employee';
          } else {
            role = roles.first; // Take first role if no priority match
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
      final categories = await _supabase.rpc('get_categories_with_features');
      return (categories as List).cast<Map<String, dynamic>>();
    } catch (e) {
      return [];
    }
  }
}
