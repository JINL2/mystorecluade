import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app_state_provider.dart';

// User role info model
class UserRoleInfo {
  final String userRoleId;
  final String userId;
  final String roleId;
  final String roleName;
  final String companyId;
  final String fullName;
  final String email;
  final String? profileImage;
  final String? storeId;
  final String? storeName;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isDeleted;
  final String? roleType;

  UserRoleInfo({
    required this.userRoleId,
    required this.userId,
    required this.roleId,
    required this.roleName,
    required this.companyId,
    required this.fullName,
    required this.email,
    this.profileImage,
    this.storeId,
    this.storeName,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
    this.roleType,
  });

  String get displayName => fullName.isNotEmpty ? fullName : email.split('@').first;
  String get initials {
    if (fullName.isEmpty) return email[0].toUpperCase();
    final parts = fullName.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return fullName[0].toUpperCase();
  }
  bool get hasProfileImage => profileImage != null && profileImage!.isNotEmpty;
  bool get canEditRole => roleType != 'owner';
}

// Provider for user roles
final companyUserRolesProvider = FutureProvider.family<List<UserRoleInfo>, String>((ref, companyId) async {
  try {
    final supabase = Supabase.instance.client;
    
    // First, try to fetch from view if it exists
    try {
      final viewResponse = await supabase
          .from('v_user_role_info')
          .select()
          .eq('company_id', companyId)
          .eq('is_deleted', false)
          .order('role_name')
          .order('full_name');
      
      print('Delegate Role: Successfully fetched ${viewResponse.length} user roles from view');
      
      // Convert response to UserRoleInfo entities
      return viewResponse.map<UserRoleInfo>((json) => UserRoleInfo(
        userRoleId: json['user_role_id'] as String,
        userId: json['user_id'] as String,
        roleId: json['role_id'] as String,
        roleName: json['role_name'] as String,
        roleType: json['role_type'] as String?,
        companyId: json['company_id'] as String,
        fullName: json['full_name'] as String? ?? '',
        email: json['email'] as String? ?? '',
        profileImage: json['profile_image'] as String?,
        storeId: json['store_id'] as String?,
        storeName: json['store_name'] as String?,
        createdAt: DateTime.parse(json['created_at'] as String),
        updatedAt: json['updated_at'] != null 
            ? DateTime.parse(json['updated_at'] as String) 
            : DateTime.parse(json['created_at'] as String),
        isDeleted: json['is_deleted'] as bool? ?? false,
      )).toList();
    } catch (viewError) {
      print('Delegate Role: View not found, falling back to manual joins: $viewError');
      
      // Fallback: Get all users in the company
      final userCompaniesResponse = await supabase
          .from('user_companies')
          .select('''
            user_id,
            company_id,
            is_deleted,
            created_at,
            users!inner(
              user_id,
              first_name,
              last_name,
              email,
              profile_image
            )
          ''')
          .eq('company_id', companyId)
          .eq('is_deleted', false);
      
      print('Delegate Role: Found ${userCompaniesResponse.length} users in company');
      
      final List<UserRoleInfo> userRoles = [];
      
      for (final userCompany in userCompaniesResponse) {
        final userData = userCompany['users'];
        final userId = userCompany['user_id'] as String;
        
        // Get user's role
        String roleId = '';
        String roleName = 'No Role';
        String? roleType;
        String userRoleId = '';
        
        try {
          final roleResponse = await supabase
              .from('user_roles')
              .select('''
                user_role_id,
                role_id,
                created_at,
                updated_at,
                roles!inner(
                  role_id,
                  role_name,
                  role_type
                )
              ''')
              .eq('user_id', userId)
              .eq('company_id', companyId)
              .eq('is_deleted', false)
              .maybeSingle();
              
          if (roleResponse != null) {
            userRoleId = roleResponse['user_role_id'] as String;
            roleId = roleResponse['role_id'] as String;
            roleName = roleResponse['roles']['role_name'] as String;
            roleType = roleResponse['roles']['role_type'] as String?;
          }
        } catch (e) {
          print('No role found for user $userId: $e');
        }
        
        // Get user's store info
        String? storeId;
        String? storeName;
        
        try {
          final storeResponse = await supabase
              .from('user_stores')
              .select('store_id, stores!inner(store_name)')
              .eq('user_id', userId)
              .eq('is_deleted', false)
              .maybeSingle();
              
          if (storeResponse != null) {
            storeId = storeResponse['store_id'];
            storeName = storeResponse['stores']['store_name'];
          }
        } catch (e) {
          print('No store found for user $userId: $e');
        }
        
        final firstName = userData['first_name'] ?? '';
        final lastName = userData['last_name'] ?? '';
        final fullName = '$firstName $lastName'.trim();
        
        userRoles.add(UserRoleInfo(
          userRoleId: userRoleId.isEmpty ? 'temp_${userId}_${companyId}' : userRoleId,
          userId: userId,
          roleId: roleId,
          roleName: roleName,
          roleType: roleType,
          companyId: companyId,
          fullName: fullName.isEmpty ? userData['email'] : fullName,
          email: userData['email'] as String,
          profileImage: userData['profile_image'] as String?,
          storeId: storeId,
          storeName: storeName,
          createdAt: DateTime.parse(userCompany['created_at'] as String),
          updatedAt: DateTime.parse(userCompany['created_at'] as String),
          isDeleted: false,
        ));
      }
      
      return userRoles;
    }
  } catch (e) {
    print('Delegate Role Error: Failed to fetch user roles - $e');
    throw Exception('Failed to fetch user roles: $e');
  }
});

// Available roles provider (excluding owner role)
final availableRolesProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, companyId) async {
  try {
    final supabase = Supabase.instance.client;
    
    // Fetch available roles from roles table
    final response = await supabase
        .from('roles')
        .select()
        .eq('company_id', companyId)
        .order('role_name');
    
    return List<Map<String, dynamic>>.from(response);
  } catch (e) {
    print('Delegate Role Error: Failed to fetch available roles - $e');
    throw Exception('Failed to fetch available roles: $e');
  }
});

// Search query provider
final userSearchProvider = StateNotifierProvider<UserSearchNotifier, String>((ref) {
  return UserSearchNotifier();
});

class UserSearchNotifier extends StateNotifier<String> {
  UserSearchNotifier() : super('');

  void updateQuery(String query) {
    state = query;
  }

  void clear() {
    state = '';
  }
}

// Role filter provider
final selectedRoleFilterProvider = StateNotifierProvider<SelectedRoleFilterNotifier, String?>((ref) {
  return SelectedRoleFilterNotifier();
});

class SelectedRoleFilterNotifier extends StateNotifier<String?> {
  SelectedRoleFilterNotifier() : super(null);

  void selectRole(String? roleId) {
    state = roleId;
  }

  void clear() {
    state = null;
  }
}

// Filtered user roles provider
final filteredUserRolesProvider = FutureProvider.family<List<UserRoleInfo>, String>((ref, companyId) async {
  final allUsers = await ref.watch(companyUserRolesProvider(companyId).future);
  final searchQuery = ref.watch(userSearchProvider).toLowerCase();
  final selectedRoleFilter = ref.watch(selectedRoleFilterProvider);

  return allUsers.where((user) {
    // Apply search filter
    if (searchQuery.isNotEmpty) {
      final matchesSearch = user.displayName.toLowerCase().contains(searchQuery) ||
                          user.email.toLowerCase().contains(searchQuery) ||
                          user.roleName.toLowerCase().contains(searchQuery);
      if (!matchesSearch) return false;
    }

    // Apply role filter
    if (selectedRoleFilter != null && user.roleId != selectedRoleFilter) {
      return false;
    }

    return true;
  }).toList();
});

// Selected users for bulk actions
final selectedUsersProvider = StateNotifierProvider<SelectedUsersNotifier, Set<String>>((ref) {
  return SelectedUsersNotifier();
});

class SelectedUsersNotifier extends StateNotifier<Set<String>> {
  SelectedUsersNotifier() : super({});

  void toggleUser(String userRoleId) {
    if (state.contains(userRoleId)) {
      state = {...state}..remove(userRoleId);
    } else {
      state = {...state}..add(userRoleId);
    }
  }

  void clearSelection() {
    state = {};
  }
}

// Role update loading state
final roleUpdateLoadingProvider = StateProvider<Set<String>>((ref) => {});

// Current user ID provider
final currentUserIdProvider = Provider<String?>((ref) {
  final appState = ref.watch(appStateProvider);
  if (appState.user is Map) {
    return appState.user['user_id'] as String?;
  }
  return null;
});

// Can edit roles provider
final canEditRolesProvider = FutureProvider.family<bool, (String, String)>((ref, params) async {
  final (userId, companyId) = params;
  
  try {
    final supabase = Supabase.instance.client;
    
    // Check if user has owner or admin role in the company
    final response = await supabase
        .from('user_roles')
        .select('''
          role_id,
          roles!inner(
            role_type
          )
        ''')
        .eq('user_id', userId)
        .eq('company_id', companyId)
        .eq('is_deleted', false)
        .single();
    
    final roleType = response['roles']['role_type'] as String?;
    return roleType == 'owner' || roleType == 'admin';
  } catch (e) {
    print('Error checking edit permission: $e');
    return false;
  }
});

// Available stores provider
final availableStoresProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, companyId) async {
  try {
    final supabase = Supabase.instance.client;
    
    // Fetch available stores from stores table
    final response = await supabase
        .from('stores')
        .select('store_id, store_name')
        .eq('company_id', companyId)
        .eq('is_deleted', false)
        .order('store_name');
    
    print('Delegate Role: Fetched ${response.length} available stores for company $companyId');
    
    return response;
  } catch (e) {
    print('Delegate Role Error: Failed to fetch available stores - $e');
    throw Exception('Failed to fetch available stores: $e');
  }
});

// Multi-select role filter provider
final selectedRoleFiltersProvider = StateNotifierProvider<SelectedRoleFiltersNotifier, List<String>>((ref) {
  return SelectedRoleFiltersNotifier();
});

class SelectedRoleFiltersNotifier extends StateNotifier<List<String>> {
  SelectedRoleFiltersNotifier() : super([]);

  void toggleRole(String roleId) {
    if (state.contains(roleId)) {
      state = [...state]..remove(roleId);
    } else {
      state = [...state, roleId];
    }
  }

  void clearFilters() {
    state = [];
  }
}

// Multi-select store filter provider
final selectedStoreFiltersProvider = StateNotifierProvider<SelectedStoreFiltersNotifier, List<String>>((ref) {
  return SelectedStoreFiltersNotifier();
});

class SelectedStoreFiltersNotifier extends StateNotifier<List<String>> {
  SelectedStoreFiltersNotifier() : super([]);

  void toggleStore(String storeId) {
    if (state.contains(storeId)) {
      state = [...state]..remove(storeId);
    } else {
      state = [...state, storeId];
    }
  }

  void clearFilters() {
    state = [];
  }
}

// Updated filtered provider to use multi-select
final filteredUserRolesWithMultiSelectProvider = FutureProvider.family<List<UserRoleInfo>, String>((ref, companyId) async {
  final users = await ref.watch(companyUserRolesProvider(companyId).future);
  final searchQuery = ref.watch(userSearchProvider);
  final selectedRoleIds = ref.watch(selectedRoleFiltersProvider);
  final selectedStoreIds = ref.watch(selectedStoreFiltersProvider);

  var filteredUsers = users;

  // Apply role filters if selected
  if (selectedRoleIds.isNotEmpty) {
    filteredUsers = filteredUsers.where((user) => 
      selectedRoleIds.contains(user.roleId)
    ).toList();
  }

  // Apply store filters if selected
  if (selectedStoreIds.isNotEmpty) {
    filteredUsers = filteredUsers.where((user) => 
      user.storeId != null && selectedStoreIds.contains(user.storeId)
    ).toList();
  }

  // Apply search filter if query exists
  if (searchQuery.isNotEmpty) {
    final query = searchQuery.toLowerCase();
    filteredUsers = filteredUsers.where((user) {
      return user.fullName.toLowerCase().contains(query) ||
             user.email.toLowerCase().contains(query) ||
             user.roleName.toLowerCase().contains(query);
    }).toList();
  }

  return filteredUsers;
});