import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app_state_provider.dart';

// Role model
class Role {
  final String roleId;
  final String companyId;
  final String roleName;
  final String? roleType;
  final String? description;
  final Map<String, dynamic>? tags;
  final List<Map<String, dynamic>> permissions;
  final int userCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  Role({
    required this.roleId,
    required this.companyId,
    required this.roleName,
    this.roleType,
    this.description,
    this.tags,
    required this.permissions,
    required this.userCount,
    required this.createdAt,
    required this.updatedAt,
  });

  int get permissionCount => permissions.length;

  factory Role.fromMap(Map<String, dynamic> map) {
    return Role(
      roleId: map['role_id'] ?? '',
      companyId: map['company_id'] ?? '',
      roleName: map['role_name'] ?? '',
      roleType: map['role_type'],
      description: map['role_description'],
      tags: map['tags'],
      permissions: List<Map<String, dynamic>>.from(map['permissions'] ?? []),
      userCount: map['user_count'] ?? 0,
      createdAt: DateTime.parse(map['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(map['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }
}

// Provider to fetch roles for the selected company
final companyRolesProvider = FutureProvider<List<Role>>((ref) async {
  final selectedCompany = ref.watch(selectedCompanyProvider);
  
  if (selectedCompany == null) {
    print('Role Provider: No selected company');
    return [];
  }

  final supabase = Supabase.instance.client;
  
  try {
    print('Role Provider: Fetching roles for company: ${selectedCompany['company_id']}');
    
    // First, fetch basic role information
    final response = await supabase
        .from('roles')
        .select('*')
        .eq('company_id', selectedCompany['company_id'])
        .order('role_type', ascending: true)
        .order('role_name', ascending: true);

    print('Role Provider: Fetched ${response.length} roles');
    
    final List<Role> roles = [];
    
    for (final roleData in response as List<dynamic>) {
      // Count users with this role
      int userCount = 0;
      try {
        final userCountResponse = await supabase
            .from('user_roles')
            .select('user_id')
            .eq('role_id', roleData['role_id'])
            .eq('is_deleted', false);
        
        userCount = (userCountResponse as List).length;
      } catch (e) {
        print('Warning: Error counting users for role ${roleData['role_id']}: $e');
      }
      
      // For now, we'll use empty permissions array to avoid join issues
      final permissions = <Map<String, dynamic>>[];
      
      final role = Role(
        roleId: roleData['role_id'] ?? '',
        companyId: roleData['company_id'] ?? '',
        roleName: roleData['role_name'] ?? '',
        roleType: roleData['role_type'],
        description: roleData['description'] ?? roleData['role_description'],
        tags: roleData['tags'],
        permissions: permissions,
        userCount: userCount,
        createdAt: roleData['created_at'] != null 
            ? DateTime.parse(roleData['created_at']) 
            : DateTime.now(),
        updatedAt: roleData['updated_at'] != null 
            ? DateTime.parse(roleData['updated_at']) 
            : DateTime.now(),
      );
      
      roles.add(role);
    }
    
    print('Role Provider: Returning ${roles.length} roles');
    return roles;
  } catch (e) {
    print('Role Provider Error: $e');
    print('Stack trace: ${StackTrace.current}');
    throw Exception('Failed to load roles: $e');
  }
});

// Provider to fetch all features
final featuresProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = Supabase.instance.client;
  
  try {
    final response = await supabase
        .from('features')
        .select('feature_id, feature_name, category_id')
        .order('feature_name');

    return List<Map<String, dynamic>>.from(response as List);
  } catch (e) {
    print('Error fetching features: $e');
    return [];
  }
});

// Provider to fetch categories
final categoriesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = Supabase.instance.client;
  
  try {
    final response = await supabase
        .from('categories')
        .select('category_id, name')
        .order('name');

    return List<Map<String, dynamic>>.from(response as List);
  } catch (e) {
    print('Error fetching categories: $e');
    return [];
  }
});

// Provider to fetch users in a specific role
final usersInRoleProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, roleId) async {
  final supabase = Supabase.instance.client;
  
  try {
    final response = await supabase
        .from('user_roles')
        .select('''
          user_id,
          created_at,
          users!inner(
            user_id,
            first_name,
            last_name,
            email,
            profile_image
          )
        ''')
        .eq('role_id', roleId)
        .eq('is_deleted', false);

    return (response as List<dynamic>).map((record) {
      final userData = record['users'];
      return {
        'user_id': userData['user_id'],
        'first_name': userData['first_name'] ?? '',
        'last_name': userData['last_name'] ?? '',
        'email': userData['email'] ?? '',
        'profile_image': userData['profile_image'],
        'created_at': record['created_at'],
        'full_name': '${userData['first_name'] ?? ''} ${userData['last_name'] ?? ''}'.trim(),
        'initials': _getInitials('${userData['first_name'] ?? ''} ${userData['last_name'] ?? ''}'),
      };
    }).toList();
  } catch (e) {
    print('Error fetching users in role: $e');
    return [];
  }
});

String _getInitials(String name) {
  if (name.isEmpty) return '?';
  final parts = name.trim().split(' ');
  if (parts.length >= 2) {
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
  return name[0].toUpperCase();
}

// Role service for CRUD operations
class RoleService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<bool> createRole({
    required String companyId,
    required String roleName,
    required List<String> featureIds,
    String? description,
    Map<String, dynamic>? tags,
  }) async {
    try {
      // Create the role
      final roleResponse = await _supabase
          .from('roles')
          .insert({
            'company_id': companyId,
            'role_name': roleName,
            'role_type': 'custom',
            'description': description,  // Changed from role_description
            'is_deletable': true,  // Added from old version
            'tags': tags,
          })
          .select()
          .single();

      final roleId = roleResponse['role_id'];

      // Add permissions
      if (featureIds.isNotEmpty) {
        final permissions = featureIds.map((featureId) => {
          'role_id': roleId,
          'feature_id': featureId,
          'can_access': true,  // Added from old version
        }).toList();

        await _supabase.from('role_permissions').insert(permissions);
      }

      return true;
    } catch (e) {
      print('Error creating role: $e');
      return false;
    }
  }

  Future<bool> updateRole({
    required String roleId,
    required String roleName,
    required List<String> featureIds,
    String? description,
    Map<String, dynamic>? tags,
  }) async {
    try {
      // Update role info
      await _supabase
          .from('roles')
          .update({
            'role_name': roleName,
            'description': description,  // Changed from role_description
            'tags': tags,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('role_id', roleId);

      // Delete existing permissions
      await _supabase
          .from('role_permissions')
          .delete()
          .eq('role_id', roleId);

      // Add new permissions
      if (featureIds.isNotEmpty) {
        final permissions = featureIds.map((featureId) => {
          'role_id': roleId,
          'feature_id': featureId,
          'can_access': true,  // Added from old version
        }).toList();

        await _supabase.from('role_permissions').insert(permissions);
      }

      return true;
    } catch (e) {
      print('Error updating role: $e');
      return false;
    }
  }

  Future<bool> deleteRole(String roleId) async {
    try {
      await _supabase
          .from('roles')
          .delete()
          .eq('role_id', roleId);

      return true;
    } catch (e) {
      print('Error deleting role: $e');
      return false;
    }
  }
}

// Provider for role service
final roleServiceProvider = Provider<RoleService>((ref) => RoleService());