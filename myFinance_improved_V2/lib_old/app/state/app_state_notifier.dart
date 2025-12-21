/// Global Application State Notifier - Future Architecture Pattern
/// 
/// Purpose: Manages global app state with clean business logic
/// - Handles user authentication state
/// - Manages company/store selection
/// - Controls permission state
/// - Provides reactive state updates
/// 
/// ✅ MIGRATED: Now in lib/app/state/app_state_notifier.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_state.dart';

/// Global App State Notifier
/// 
/// Manages all app-level state transitions and business logic
class AppStateNotifier extends StateNotifier<AppState> {
  AppStateNotifier() : super(AppState.initial());
  
  /// Initialize app state from legacy provider
  void initializeFromLegacy(Map<String, dynamic> legacyState) {
    state = AppState.fromLegacyProvider(legacyState);
  }
  
  /// Update user context
  void updateUser({
    required Map<String, dynamic> user,
    required bool isAuthenticated,
  }) {
    state = state.copyWith(
      user: user,
      userId: (user['user_id'] as String?) ?? '',
      isAuthenticated: isAuthenticated,
      hasAdminPermission: _checkAdminPermission(user),
      permissions: _extractPermissions(user),
    );
  }
  
  /// Update business context (company/store selection)
  void updateBusinessContext({
    required String companyId,
    required String storeId,
    String? companyName,
    String? storeName,
  }) {
    state = state.copyWith(
      companyChoosen: companyId,
      storeChoosen: storeId,
      companyName: companyName ?? state.companyName,
      storeName: storeName ?? state.storeName,
    );
  }
  
  /// Update company selection
  void selectCompany(String companyId, {String? companyName}) {
    state = state.copyWith(
      companyChoosen: companyId,
      companyName: companyName ?? '',
      // Reset store when company changes
      storeChoosen: '',
      storeName: '',
    );
  }
  
  /// Update store selection  
  void selectStore(String storeId, {String? storeName}) {
    state = state.copyWith(
      storeChoosen: storeId,
      storeName: storeName ?? '',
    );
  }
  
  /// Update permissions
  void updatePermissions(Set<String> permissions) {
    state = state.copyWith(
      permissions: permissions,
      hasAdminPermission: permissions.contains('admin') || 
                          permissions.contains('super_admin'),
    );
  }
  
  /// Set loading state
  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }
  
  /// Set error state
  void setError(String? error) {
    state = state.copyWith(error: error);
  }
  
  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
  
  /// Update app configuration
  void updateConfiguration({
    String? themeMode,
    String? languageCode,
    bool? isOfflineMode,
  }) {
    state = state.copyWith(
      themeMode: themeMode ?? state.themeMode,
      languageCode: languageCode ?? state.languageCode,
      isOfflineMode: isOfflineMode ?? state.isOfflineMode,
    );
  }
  
  /// Sign out user
  void signOut() {
    state = AppState.initial();
  }
  
  /// Sync with legacy app state provider
  void syncWithLegacyProvider(Map<String, dynamic> legacyState) {
    // This method allows seamless transition from legacy appStateProvider
    // during migration period
    final newState = AppState.fromLegacyProvider(legacyState);
    if (newState != state) {
      state = newState;
    }
  }
  
  /// Private helper: Check admin permission
  bool _checkAdminPermission(Map<String, dynamic> user) {
    // TODO: Implement actual admin permission logic
    // For now, use simple role check
    final role = (user['role'] as String?) ?? '';
    final permissions = (user['permissions'] as List<dynamic>?) ?? <String>[];
    
    return role == 'admin' || 
           role == 'super_admin' ||
           permissions.contains('admin') ||
           permissions.contains('super_admin');
  }
  
  /// Private helper: Extract permissions from user
  Set<String> _extractPermissions(Map<String, dynamic> user) {
    final permissions = (user['permissions'] as List<dynamic>?) ?? <String>[];
    final role = (user['role'] as String?) ?? '';
    
    final permissionSet = Set<String>.from(permissions);
    if (role.isNotEmpty) {
      permissionSet.add(role);
    }
    
    return permissionSet;
  }
}