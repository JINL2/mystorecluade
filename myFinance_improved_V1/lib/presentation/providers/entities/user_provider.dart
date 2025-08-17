// =====================================================
// USER ENTITY RIVERPOD PROVIDERS
// Autonomous data providers for user selectors
// =====================================================

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/models/selector_entities.dart';
import '../../data/services/supabase_service.dart';
import '../app_state_provider.dart';

part 'user_provider.g.dart';

// =====================================================
// USER LIST PROVIDER
// Base provider that fetches company users from RPC
// =====================================================
@riverpod
class UserList extends _$UserList {
  @override
  Future<List<UserData>> build(String companyId) async {
    final supabase = ref.read(supabaseServiceProvider);
    
    try {
      final response = await supabase.client.rpc(
        'get_company_users',
        params: {
          'p_company_id': companyId,
        },
      );

      if (response == null) return [];

      final List<dynamic> data = response as List<dynamic>;
      return data.map((json) => UserData.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      // Log error but don't throw to prevent UI crashes
      print('Error fetching users: $e');
      return [];
    }
  }
}

// =====================================================
// AUTO-CONTEXT USER PROVIDERS
// Automatically watch app state and refresh data
// =====================================================

/// Current company users based on selected company
@riverpod
Future<List<UserData>> currentUsers(CurrentUsersRef ref) async {
  final appState = ref.watch(appStateProvider);
  final companyId = appState.selectedCompany?['company_id'] as String?;
  
  if (companyId == null) return [];
  
  return ref.watch(userListProvider(companyId).future);
}

/// Current users with transaction count filter (active users only)
@riverpod
Future<List<UserData>> currentActiveUsers(CurrentActiveUsersRef ref) async {
  final users = await ref.watch(currentUsersProvider.future);
  return users.where((user) => user.transactionCount > 0).toList();
}

/// Current users sorted by name
@riverpod
Future<List<UserData>> currentUsersSorted(CurrentUsersSortedRef ref) async {
  final users = await ref.watch(currentUsersProvider.future);
  final sortedUsers = List<UserData>.from(users);
  sortedUsers.sort((a, b) => a.displayName.compareTo(b.displayName));
  return sortedUsers;
}

// =====================================================
// USER SELECTION STATE PROVIDERS
// Manage selected user state
// =====================================================

/// Single user selection state
@riverpod
class SelectedUser extends _$SelectedUser {
  @override
  String? build() => null;

  void select(String? userId) {
    state = userId;
  }

  void clear() {
    state = null;
  }
}

/// Multiple user selection state
@riverpod
class SelectedUsers extends _$SelectedUsers {
  @override
  List<String> build() => [];

  void select(List<String> userIds) {
    state = userIds;
  }

  void add(String userId) {
    if (!state.contains(userId)) {
      state = [...state, userId];
    }
  }

  void remove(String userId) {
    state = state.where((id) => id != userId).toList();
  }

  void toggle(String userId) {
    if (state.contains(userId)) {
      remove(userId);
    } else {
      add(userId);
    }
  }

  void clear() {
    state = [];
  }
}

// =====================================================
// USER DATA HELPERS
// Helper providers for finding specific users
// =====================================================

/// Find user by ID
@riverpod
Future<UserData?> userById(
  UserByIdRef ref,
  String userId,
) async {
  final users = await ref.watch(currentUsersProvider.future);
  try {
    return users.firstWhere((user) => user.id == userId);
  } catch (e) {
    return null;
  }
}

/// Find users by IDs
@riverpod
Future<List<UserData>> usersByIds(
  UsersByIdsRef ref,
  List<String> userIds,
) async {
  final users = await ref.watch(currentUsersProvider.future);
  return users.where((user) => userIds.contains(user.id)).toList();
}

/// Search users by name or email
@riverpod
Future<List<UserData>> searchUsers(
  SearchUsersRef ref,
  String searchQuery,
) async {
  final users = await ref.watch(currentUsersProvider.future);
  if (searchQuery.isEmpty) return users;
  
  final queryLower = searchQuery.toLowerCase();
  return users.where((user) {
    return user.displayName.toLowerCase().contains(queryLower) ||
           (user.email?.toLowerCase().contains(queryLower) ?? false) ||
           (user.firstName?.toLowerCase().contains(queryLower) ?? false) ||
           (user.lastName?.toLowerCase().contains(queryLower) ?? false);
  }).toList();
}

/// Get current logged-in user
@riverpod
Future<UserData?> currentLoggedInUser(CurrentLoggedInUserRef ref) async {
  final supabase = ref.read(supabaseServiceProvider);
  final currentUser = supabase.client.auth.currentUser;
  
  if (currentUser == null) return null;
  
  final users = await ref.watch(currentUsersProvider.future);
  try {
    return users.firstWhere((user) => user.email == currentUser.email);
  } catch (e) {
    return null;
  }
}