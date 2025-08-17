import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:myfinance_improved/presentation/providers/auth_provider.dart';
import 'package:myfinance_improved/presentation/providers/app_state_provider.dart';
import '../models/delegate_role_models.dart';
import '../../../../core/utils/tag_validator.dart';

/// Provider for user data with companies (reuses app state)
final userCompaniesProvider = FutureProvider<dynamic>((ref) async {
  final user = ref.watch(authStateProvider);
  final appStateNotifier = ref.read(appStateProvider.notifier);
  final appState = ref.watch(appStateProvider);
  
  if (user == null) {
    throw UnauthorizedException();
  }
  
  // Check if we have cached data
  if (appStateNotifier.hasUserData) {
    return appState.user;
  }
  
  // Fetch fresh data from API using RPC function
  final supabase = Supabase.instance.client;
  final response = await supabase.rpc('get_user_companies_and_stores', params: {'p_user_id': user.id});
  
  // Save to app state for persistence
  await appStateNotifier.setUser(response);
  
  final companies = response['companies'] as List<dynamic>? ?? [];
  
  // Auto-select first company if none selected
  if (appState.companyChoosen.isEmpty && companies.isNotEmpty) {
    await appStateNotifier.setCompanyChoosen(companies.first['company_id']);
  }
  
  return response;
});

/// Force refresh provider - ALWAYS fetches from API
final forceRefreshUserCompaniesProvider = FutureProvider<dynamic>((ref) async {
  final user = ref.watch(authStateProvider);
  final appStateNotifier = ref.read(appStateProvider.notifier);
  
  if (user == null) {
    throw UnauthorizedException();
  }
  
  // ALWAYS fetch fresh data from API
  final supabase = Supabase.instance.client;
  final response = await supabase.rpc('get_user_companies_and_stores', params: {'p_user_id': user.id});
  
  // Save to app state for persistence
  await appStateNotifier.setUser(response);
  
  final companies = response['companies'] as List<dynamic>? ?? [];
  
  // Auto-select first company if none selected
  final appState = ref.read(appStateProvider);
  if (appState.companyChoosen.isEmpty && companies.isNotEmpty) {
    await appStateNotifier.setCompanyChoosen(companies.first['company_id']);
  }
  
  return response;
});

/// Provider for categories with features filtered by permissions
final categoriesWithFeaturesProvider = FutureProvider<dynamic>((ref) async {
  final appState = ref.watch(appStateProvider);
  final appStateNotifier = ref.read(appStateProvider.notifier);
  
  // Check if we have cached categories
  if (appStateNotifier.hasCategoryFeatures) {
    return appState.categoryFeatures;
  }
  
  // Get selected company from app state
  final selectedCompany = appStateNotifier.selectedCompany;
  
  if (selectedCompany == null) {
    return [];
  }
  
  final userRole = selectedCompany['role'];
  final permissions = userRole['permissions'] as List<dynamic>? ?? [];
  
  // Fetch all categories with features using RPC
  final supabase = Supabase.instance.client;
  final categories = await supabase.rpc('get_categories_with_features');
  
  // Filter features based on user permissions
  final filteredCategories = [];
  for (final category in categories) {
    final features = category['features'] as List<dynamic>? ?? [];
    final filteredFeatures = features.where((feature) {
      return permissions.contains(feature['feature_id']);
    }).toList();
    
    if (filteredFeatures.isNotEmpty) {
      filteredCategories.add({
        'category_id': category['category_id'],
        'category_name': category['category_name'],
        'features': filteredFeatures,
      });
    }
  }
  
  // Save to app state for caching
  await appStateNotifier.setCategoryFeatures(filteredCategories);
  
  return filteredCategories;
});

/// Force refresh provider for categories - ALWAYS fetches from API
final forceRefreshCategoriesProvider = FutureProvider<dynamic>((ref) async {
  final appStateNotifier = ref.read(appStateProvider.notifier);
  
  // Get selected company from app state
  final selectedCompany = appStateNotifier.selectedCompany;
  
  if (selectedCompany == null) {
    return [];
  }
  
  final userRole = selectedCompany['role'];
  final permissions = userRole['permissions'] as List<dynamic>? ?? [];
  
  // ALWAYS fetch fresh categories from API using RPC
  final supabase = Supabase.instance.client;
  final categories = await supabase.rpc('get_categories_with_features');
  
  // Filter features based on user permissions
  final filteredCategories = [];
  for (final category in categories) {
    final features = category['features'] as List<dynamic>? ?? [];
    final filteredFeatures = features.where((feature) {
      return permissions.contains(feature['feature_id']);
    }).toList();
    
    if (filteredFeatures.isNotEmpty) {
      filteredCategories.add({
        'category_id': category['category_id'],
        'category_name': category['category_name'],
        'features': filteredFeatures,
      });
    }
  }
  
  // Save to app state for caching
  await appStateNotifier.setCategoryFeatures(filteredCategories);
  
  return filteredCategories;
});

// Delegate Role specific providers

/// Provider for active role delegations
final activeDelegationsProvider = FutureProvider<List<RoleDelegation>>((ref) async {
  final user = ref.watch(authStateProvider);
  final appState = ref.watch(appStateProvider);
  
  if (user == null) {
    throw UnauthorizedException();
  }
  
  final selectedCompany = appState.companyChoosen;
  if (selectedCompany.isEmpty) {
    return [];
  }
  
  // Return empty list - delegation feature not implemented yet
  return [];
});

/// Provider for roles that the current user can delegate
final delegatableRolesProvider = FutureProvider<List<DelegatableRole>>((ref) async {
  final appState = ref.watch(appStateProvider);
  final selectedCompany = ref.read(appStateProvider.notifier).selectedCompany;
  
  if (selectedCompany == null) {
    return [];
  }
  
  final supabase = Supabase.instance.client;
  
  try {
    // Fetch all roles for the company
    final rolesResponse = await supabase
        .from('roles')
        .select('*')
        .eq('company_id', appState.companyChoosen);
    
    final roles = rolesResponse as List;
    
    // Get current user's role
    final userRole = selectedCompany['role'];
    final currentUserRoleName = userRole['role_name']?.toString().toLowerCase() ?? '';
    
    // Define delegation hierarchy
    // Owner can delegate all roles
    // Manager can delegate Employee roles
    // Others cannot delegate
    final canDelegateRoles = <DelegatableRole>[];
    
    for (final role in roles) {
      final roleId = role['role_id'] as String;
      final roleName = role['role_name'] as String;
      final roleType = role['role_type'] as String? ?? '';
      
      bool canDelegate = false;
      String description = '';
      
      // Determine if current user can delegate this role
      if (currentUserRoleName == 'owner') {
        canDelegate = true;
        description = 'Full delegation rights as Owner';
      } else if (currentUserRoleName == 'manager') {
        // Managers can only delegate to employees
        if (roleName.toLowerCase() == 'employee') {
          canDelegate = true;
          description = 'Can delegate Employee role';
        }
      }
      
      if (canDelegate) {
        // Get permissions for this role
        final permissionsResponse = await supabase
            .from('role_permissions')
            .select('feature_id')
            .eq('role_id', roleId);
        
        final permissions = (permissionsResponse as List)
            .map((p) => p['feature_id'] as String)
            .toList();
        
        canDelegateRoles.add(DelegatableRole(
          roleId: roleId,
          roleName: roleName,
          description: description.isEmpty ? 'Role type: $roleType' : description,
          permissions: permissions,
          canDelegate: canDelegate,
        ));
      }
    }
    
    return canDelegateRoles;
  } catch (e) {
    return [];
  }
});

/// Provider to delete a role
final deleteRoleProvider = Provider<Future<void> Function(String)>((ref) {
  return (String roleId) async {
    final supabase = Supabase.instance.client;
    final appState = ref.read(appStateProvider);
    
    try {
      // First, find a default role to reassign users to (e.g., Employee role)
      final defaultRolesResponse = await supabase
          .from('roles')
          .select('role_id')
          .eq('company_id', appState.companyChoosen)
          .eq('role_name', 'Employee')
          .limit(1);
      
      String? defaultRoleId;
      if (defaultRolesResponse.isNotEmpty) {
        defaultRoleId = defaultRolesResponse.first['role_id'];
      }
      
      // Get users currently assigned to this role
      final usersWithRole = await supabase
          .from('user_roles')
          .select('user_id')
          .eq('role_id', roleId);
      
      // Handle user reassignment
      if (usersWithRole.isNotEmpty) {
        if (defaultRoleId != null) {
          // Reassign users to Employee role
          for (final userRole in usersWithRole) {
            await supabase
                .from('user_roles')
                .update({'role_id': defaultRoleId})
                .eq('role_id', roleId)
                .eq('user_id', userRole['user_id']);
          }
        } else {
          // If no Employee role exists, remove user role assignments
          await supabase
              .from('user_roles')
              .delete()
              .eq('role_id', roleId);
        }
      }
      
      // Delete role permissions
      await supabase
          .from('role_permissions')
          .delete()
          .eq('role_id', roleId);
      
      // Delete the role
      await supabase
          .from('roles')
          .delete()
          .eq('role_id', roleId);
      
      // Invalidate the roles provider to refresh the list
      ref.invalidate(allCompanyRolesProvider);
    } catch (e) {
      throw Exception('Failed to delete role: $e');
    }
  };
});

/// Provider for delegation history (audit trail)
final delegationHistoryProvider = FutureProvider<List<DelegationAudit>>((ref) async {
  final user = ref.watch(authStateProvider);
  final appState = ref.watch(appStateProvider);
  
  if (user == null) {
    throw UnauthorizedException();
  }
  
  final selectedCompany = appState.companyChoosen;
  if (selectedCompany.isEmpty) {
    return [];
  }
  
  // Return empty list - audit feature not implemented yet
  return [];
});

/// Provider for company users (for delegation selection) using RPC function
final companyUsersProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final appState = ref.watch(appStateProvider);
  final selectedCompany = appState.companyChoosen;
  
  if (selectedCompany.isEmpty) {
    return [];
  }
  
  final supabase = Supabase.instance.client;
  
  // First, get the company owner information
  String? companyOwnerId;
  try {
    final companyResponse = await supabase
        .from('companies')
        .select('owner_id')
        .eq('company_id', selectedCompany)
        .limit(1);
    
    if (companyResponse.isNotEmpty) {
      companyOwnerId = companyResponse.first['owner_id'];
    }
  } catch (e) {
    // Silently handle error - owner detection will fall back to role-based logic
  }
  
  try {
    // Use RPC function for reliable role lookup
    final response = await supabase.rpc(
      'get_company_users_with_roles',
      params: {'p_company_id': selectedCompany},
    );
    
    final usersWithRoles = <Map<String, dynamic>>[];
    
    for (final item in response as List) {
      final firstName = item['first_name'] ?? '';
      final lastName = item['last_name'] ?? '';
      final fullName = '$firstName $lastName'.trim();
      final userId = item['user_id'];
      
      // Check if this user is the company owner
      String role = item['role_name'] ?? 'No Role';
      if (companyOwnerId == userId) {
        role = 'Owner'; // Company owners are always "Owner"
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
    
    // Get all users in the current company (fallback)
    final response = await supabase
        .from('user_companies')
        .select('''
          user:users!user_id(user_id, first_name, last_name, email)
        ''')
        .eq('company_id', selectedCompany)
        .eq('is_deleted', false);
    
    final usersWithRoles = <Map<String, dynamic>>[];
    
    for (final item in response as List) {
      final user = item['user'];
      final userId = user['user_id'];
      final firstName = user['first_name'] ?? '';
      final lastName = user['last_name'] ?? '';
      final fullName = '$firstName $lastName'.trim();
      
      // Get current role for this user (fallback logic)
      String currentRole = 'No Role';
      
      // Check if this user is the company owner first
      if (companyOwnerId == userId) {
        currentRole = 'Owner';
      } else {
        try {
          // Get user roles and filter by company on the Dart side
          final roleResponse = await supabase
              .from('user_roles')
              .select('''
                role:roles!role_id(role_name, company_id)
              ''')
              .eq('user_id', userId)
              .eq('is_deleted', false);
          
          // Filter for the current company and get the role name
          for (final roleData in roleResponse as List) {
            final role = roleData['role'];
            if (role != null && role['company_id'] == selectedCompany) {
              currentRole = role['role_name'] ?? 'No Role';
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
});

/// Provider for all company roles (for display in cards)
final allCompanyRolesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final appState = ref.watch(appStateProvider);
  final selectedCompany = ref.read(appStateProvider.notifier).selectedCompany;
  
  if (selectedCompany == null || appState.companyChoosen.isEmpty) {
    return [];
  }
  
  final supabase = Supabase.instance.client;
  
  try {
    // Fetch all roles for the company
    final rolesResponse = await supabase
        .from('roles')
        .select('*')
        .eq('company_id', appState.companyChoosen);
    
    final roles = rolesResponse as List;
    final rolesWithPermissions = <Map<String, dynamic>>[];
    
    // Get current user's role to determine edit permissions
    final userRole = selectedCompany['role'];
    final currentUserRoleName = userRole['role_name']?.toString().toLowerCase() ?? '';
    final canEditRoles = currentUserRoleName == 'owner'; // Only owners can edit roles
    
    for (final role in roles) {
      final roleId = role['role_id'] as String;
      final roleName = role['role_name'] as String;
      final description = role['description'] as String?;
      
      // Get permissions for this role
      final permissionsResponse = await supabase
          .from('role_permissions')
          .select('feature_id')
          .eq('role_id', roleId);
      
      final permissions = (permissionsResponse as List)
          .map((p) => p['feature_id'] as String)
          .toList();
      
      // Determine if current user can delegate this role
      bool canDelegate = false;
      if (currentUserRoleName == 'owner') {
        canDelegate = true;
      } else if (currentUserRoleName == 'manager' && roleName.toLowerCase() == 'employee') {
        canDelegate = true;
      }
      
      // Get member count for this role by counting users in user_roles table
      final memberCountResponse = await supabase
          .from('user_roles')
          .select('user_id')
          .eq('role_id', roleId)
          .eq('is_deleted', false);
      
      final memberCount = (memberCountResponse as List).length;

      rolesWithPermissions.add({
        'roleId': roleId,
        'roleName': roleName,
        'description': description,
        'tags': _parseTags(role['tags']), // Add tags parsing
        'permissions': permissions,
        'memberCount': memberCount,
        'canEdit': canEditRoles,
        'canDelegate': canDelegate,
      });
    }
    
    return rolesWithPermissions;
  } catch (e) {
    return [];
  }
});

/// Create delegation provider
final createDelegationProvider = Provider((ref) {
  return (CreateDelegationRequest request) async {
    final user = ref.read(authStateProvider);
    final appState = ref.read(appStateProvider);
    
    if (user == null) {
      throw UnauthorizedException();
    }
    
    final selectedCompany = appState.companyChoosen;
    if (selectedCompany.isEmpty) {
      throw Exception('No company selected');
    }
    
    // Delegation feature not implemented yet
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call
    
    // Invalidate the active delegations to refresh
    ref.invalidate(activeDelegationsProvider);
  };
});

/// Revoke delegation provider
final revokeDelegationProvider = Provider((ref) {
  return (String delegationId) async {
    final user = ref.read(authStateProvider);
    
    if (user == null) {
      throw UnauthorizedException();
    }
    
    // Delegation feature not implemented yet
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call
    
    // Invalidate the active delegations to refresh
    ref.invalidate(activeDelegationsProvider);
  };
});

/// Provider for all available features with categories (for permission management)
final allFeaturesWithCategoriesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = Supabase.instance.client;
  
  try {
    // Fetch all categories with features using RPC
    final categories = await supabase.rpc('get_categories_with_features');
    
    return (categories as List).cast<Map<String, dynamic>>();
  } catch (e) {
    return [];
  }
});

/// Provider for all available features (alias for compatibility)
final allFeaturesProvider = allFeaturesWithCategoriesProvider;

/// Provider for role permissions (for editing)
final rolePermissionsProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, roleId) async {
  final supabase = Supabase.instance.client;
  
  try {
    // Get current permissions for the role
    final permissionsResponse = await supabase
        .from('role_permissions')
        .select('feature_id')
        .eq('role_id', roleId);
    
    final currentPermissions = (permissionsResponse as List)
        .map((p) => p['feature_id'] as String)
        .toSet();
    
    // Get all features with categories
    final categories = await supabase.rpc('get_categories_with_features');
    
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
});

/// Provider for updating role permissions
final updateRolePermissionsProvider = Provider((ref) {
  return (String roleId, Set<String> newPermissions) async {
    final supabase = Supabase.instance.client;
    
    try {
      // First, delete all existing permissions for the role
      await supabase
          .from('role_permissions')
          .delete()
          .eq('role_id', roleId);
      
      // Then, insert the new permissions
      if (newPermissions.isNotEmpty) {
        final permissionInserts = newPermissions
            .map((featureId) => {
                  'role_id': roleId,
                  'feature_id': featureId,
                })
            .toList();
        
        await supabase
            .from('role_permissions')
            .insert(permissionInserts);
      }
      
      // Invalidate related providers to refresh data
      ref.invalidate(allCompanyRolesProvider);
      ref.invalidate(rolePermissionsProvider(roleId));
      
      return true;
    } catch (e) {
      throw e;
    }
  };
});

/// Provider for creating new roles
final createRoleProvider = Provider((ref) {
  return ({
    required String companyId,
    required String roleName,
    String? description,
    String roleType = 'custom',
    List<String>? tags,
  }) async {
    final supabase = Supabase.instance.client;
    
    try {
      // Validate tags if provided
      if (tags != null && tags.isNotEmpty) {
        final validation = TagValidator.validateTags(tags);
        if (!validation.isValid) {
          throw Exception('Invalid tags: ${validation.firstError}');
        }
      }
      
      // Insert the new role into the roles table
      final response = await supabase
          .from('roles')
          .insert({
            'company_id': companyId,
            'role_name': roleName,
            'role_type': roleType,
            'description': description,
            'tags': tags ?? [], // JSONB automatically converts Dart List to PostgreSQL array
          })
          .select()
          .single();
      
      // Invalidate the roles provider to refresh the list
      ref.invalidate(allCompanyRolesProvider);
      ref.invalidate(delegatableRolesProvider);
      
      return response['role_id'] as String;
    } on PostgrestException catch (e) {
      // Handle specific Supabase/PostgreSQL errors
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
  };
});

/// Provider for updating role details (name, description, and tags)
final updateRoleDetailsProvider = Provider((ref) {
  return ({
    required String roleId,
    required String roleName,
    String? description,
    List<String>? tags,
  }) async {
    final supabase = Supabase.instance.client;
    
    try {
      // Validate tags if provided
      if (tags != null && tags.isNotEmpty) {
        final validation = TagValidator.validateTags(tags);
        if (!validation.isValid) {
          throw Exception('Invalid tags: ${validation.firstError}');
        }
      }
      
      // Update the role in the roles table
      final updateData = <String, dynamic>{
        'role_name': roleName,
        'description': description,
        'updated_at': DateTime.now().toIso8601String(),
      };
      
      // Only update tags if provided (allows partial updates)
      if (tags != null) {
        updateData['tags'] = tags;
      }
      
      await supabase
          .from('roles')
          .update(updateData)
          .eq('role_id', roleId);
      
      // Invalidate the roles provider to refresh the list
      ref.invalidate(allCompanyRolesProvider);
      ref.invalidate(delegatableRolesProvider);
      
      return true;
    } on PostgrestException catch (e) {
      // Handle specific Supabase/PostgreSQL errors
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
  };
});

/// Helper function to parse tags from various formats
List<String> _parseTags(dynamic tagsData) {
  if (tagsData == null) return [];
  
  if (tagsData is List) {
    return tagsData.map((e) => e.toString()).toList();
  }
  
  // Handle legacy malformed data (Map format)
  if (tagsData is Map && tagsData.containsKey('tag1')) {
    // Legacy data format: {"tag1": "[Critical, Support, Management, Operations, Temporary]"}
    String tagString = tagsData['tag1'].toString();
    tagString = tagString.replaceAll('[', '').replaceAll(']', '');
    return tagString.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  }
  
  return [];
}

/// Exception class
class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException([this.message = 'User is not authenticated']);
}