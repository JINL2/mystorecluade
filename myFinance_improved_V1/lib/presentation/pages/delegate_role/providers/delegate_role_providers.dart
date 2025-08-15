import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:myfinance_improved/presentation/providers/auth_provider.dart';
import 'package:myfinance_improved/presentation/providers/app_state_provider.dart';
import '../models/delegate_role_models.dart';

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
  
  // For now, return empty list since we don't have delegation tables yet
  // In production, you would either:
  // 1. Create the role_delegations table in Supabase
  // 2. Use user_roles with additional metadata
  // 3. Implement using a different approach
  
  return [];
  
  // TODO: Implement when delegation tables are created
  // final supabase = Supabase.instance.client;
  // final response = await supabase
  //     .from('role_delegations')
  //     .select('''
  //       *,
  //       delegate:users!delegate_id(id, name, email),
  //       role:roles(id, name)
  //     ''')
  //     .eq('delegator_id', user.id)
  //     .eq('company_id', selectedCompany)
  //     .eq('is_active', true)
  //     .gte('end_date', DateTime.now().toIso8601String())
  //     .order('created_at', ascending: false);
  
  // return (response as List)
  //     .map((json) => RoleDelegation.fromJson({
  //       ...json,
  //       'delegateUser': json['delegate'],
  //       'roleName': json['role']['name'],
  //     }))
  //     .toList();
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
    print('Error fetching delegatable roles: $e');
    return [];
  }
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
  
  // Return empty list for now
  return [];
  
  // TODO: Implement when audit tables are created
  // final supabase = Supabase.instance.client;
  // final response = await supabase
  //     .from('delegation_audit')
  //     .select('''
  //       *,
  //       performer:users!performed_by(id, name, email)
  //     ''')
  //     .eq('company_id', selectedCompany)
  //     .order('timestamp', ascending: false)
  //     .limit(50);
  
  // return (response as List)
  //     .map((json) => DelegationAudit.fromJson({
  //       ...json,
  //       'performedByUser': json['performer'],
  //     }))
  //     .toList();
});

/// Provider for company users (for delegation selection)
final companyUsersProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final appState = ref.watch(appStateProvider);
  final selectedCompany = appState.companyChoosen;
  
  if (selectedCompany.isEmpty) {
    return [];
  }
  
  final supabase = Supabase.instance.client;
  
  // Get all users in the current company using user_companies table
  final response = await supabase
      .from('user_companies')
      .select('''
        user:users!user_id(user_id, name, email),
        company:companies!company_id(company_id, company_name)
      ''')
      .eq('company_id', selectedCompany)
      .eq('is_deleted', false);
  
  return (response as List).map((item) => {
    'id': item['user']['user_id'],
    'name': item['user']['name'] ?? 'Unknown User',
    'email': item['user']['email'] ?? '',
    'role': 'Employee', // Default role text
  }).toList();
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
        'permissions': permissions,
        'memberCount': memberCount,
        'canEdit': canEditRoles,
        'canDelegate': canDelegate,
      });
    }
    
    return rolesWithPermissions;
  } catch (e) {
    print('Error fetching all company roles: $e');
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
    
    // TODO: Implement when delegation tables are created
    // For now, just show success message
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call
    
    // final supabase = Supabase.instance.client;
    // await supabase.from('role_delegations').insert({
    //   'delegator_id': user.id,
    //   'delegate_id': request.delegateId,
    //   'company_id': selectedCompany,
    //   'role_id': request.roleId,
    //   'permissions': request.permissions,
    //   'start_date': request.startDate.toIso8601String(),
    //   'end_date': request.endDate.toIso8601String(),
    //   'is_active': true,
    // });
    
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
    
    // TODO: Implement when delegation tables are created
    // For now, just show success message
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call
    
    // final supabase = Supabase.instance.client;
    // await supabase
    //     .from('role_delegations')
    //     .update({'is_active': false})
    //     .eq('id', delegationId);
    
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
    print('Error fetching features with categories: $e');
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
    print('Error fetching role permissions: $e');
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
      print('Error updating role permissions: $e');
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
  }) async {
    final supabase = Supabase.instance.client;
    
    try {
      // Insert the new role into the roles table
      final response = await supabase
          .from('roles')
          .insert({
            'company_id': companyId,
            'role_name': roleName,
            'role_type': roleType,
            'description': description,
          })
          .select()
          .single();
      
      // Invalidate the roles provider to refresh the list
      ref.invalidate(allCompanyRolesProvider);
      ref.invalidate(delegatableRolesProvider);
      
      return response['role_id'] as String;
    } catch (e) {
      print('Error creating role: $e');
      throw Exception('Failed to create role: $e');
    }
  };
});

/// Provider for updating role details (name and description)
final updateRoleDetailsProvider = Provider((ref) {
  return ({
    required String roleId,
    required String roleName,
    String? description,
  }) async {
    final supabase = Supabase.instance.client;
    
    try {
      // Update the role in the roles table
      await supabase
          .from('roles')
          .update({
            'role_name': roleName,
            'description': description,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('role_id', roleId);
      
      // Invalidate the roles provider to refresh the list
      ref.invalidate(allCompanyRolesProvider);
      ref.invalidate(delegatableRolesProvider);
      
      return true;
    } catch (e) {
      print('Error updating role details: $e');
      throw Exception('Failed to update role details: $e');
    }
  };
});

/// Exception class
class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException([this.message = 'User is not authenticated']);
}