/// Global Application State Notifier - Clean Architecture Pattern
///
/// Purpose: Manages global app state with clean business logic
/// - Handles user authentication state
/// - Manages company/store selection
/// - Controls permission state
/// - Provides reactive state updates
///
/// ✅ LOCATION: lib/app/providers/app_state_notifier.dart
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_state.dart';

/// Global App State Notifier
///
/// Manages all app-level state transitions and business logic
class AppStateNotifier extends StateNotifier<AppState> {
  AppStateNotifier() : super(AppState.initial());

  // SharedPreferences keys
  static const String _keyLastCompanyId = 'last_selected_company_id';
  static const String _keyLastStoreId = 'last_selected_store_id';
  static const String _keyLastCompanyName = 'last_selected_company_name';
  static const String _keyLastStoreName = 'last_selected_store_name';

  /// Load last selected company and store from cache
  Future<Map<String, String?>> loadLastSelection() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return {
        'companyId': prefs.getString(_keyLastCompanyId),
        'storeId': prefs.getString(_keyLastStoreId),
        'companyName': prefs.getString(_keyLastCompanyName),
        'storeName': prefs.getString(_keyLastStoreName),
      };
    } catch (e) {
      print('⚠️ [AppState] Failed to load last selection: $e');
      return {};
    }
  }

  /// Save last selected company and store to cache
  Future<void> _saveLastSelection() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyLastCompanyId, state.companyChoosen);
      await prefs.setString(_keyLastStoreId, state.storeChoosen);
      await prefs.setString(_keyLastCompanyName, state.companyName);
      await prefs.setString(_keyLastStoreName, state.storeName);
      print('💾 [AppState] Saved selection: ${state.companyName} / ${state.storeName}');
    } catch (e) {
      print('⚠️ [AppState] Failed to save last selection: $e');
    }
  }

  /// Clear cached selection (called on logout)
  Future<void> clearLastSelection() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyLastCompanyId);
      await prefs.remove(_keyLastStoreId);
      await prefs.remove(_keyLastCompanyName);
      await prefs.remove(_keyLastStoreName);
      print('🗑️ [AppState] Cleared last selection cache');
    } catch (e) {
      print('⚠️ [AppState] Failed to clear last selection: $e');
    }
  }

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
    Map<String, dynamic>? subscription,
  }) {
    // Use plan_name instead of plan_type because:
    // - plan_type in DB is 'free' or 'paid' (billing category)
    // - plan_name is 'free', 'basic', 'pro' (actual plan tier)
    final planName = (subscription?['plan_name'] as String?) ?? state.planType;

    state = state.copyWith(
      companyChoosen: companyId,
      storeChoosen: storeId,
      companyName: companyName ?? state.companyName,
      storeName: storeName ?? state.storeName,
      currentSubscription: subscription ?? state.currentSubscription,
      planType: planName,
      maxStores: (subscription?['max_stores'] as int?) ?? state.maxStores,
      maxEmployees: (subscription?['max_employees'] as int?) ?? state.maxEmployees,
      aiDailyLimit: (subscription?['ai_daily_limit'] as int?) ?? state.aiDailyLimit,
    );

    // Save to cache
    _saveLastSelection();
  }

  /// Update subscription context
  void updateSubscription(Map<String, dynamic> subscription) {
    // ⚠️ Use plan_name instead of plan_type (see updateBusinessContext comment)
    state = state.copyWith(
      currentSubscription: subscription,
      planType: (subscription['plan_name'] as String?) ?? 'free',  // ✅ Use plan_name
      maxStores: (subscription['max_stores'] as int?) ?? 1,
      maxEmployees: (subscription['max_employees'] as int?) ?? 5,
      aiDailyLimit: (subscription['ai_daily_limit'] as int?) ?? 2,
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
    // Save to cache
    _saveLastSelection();
  }

  /// Update store selection
  void selectStore(String storeId, {String? storeName}) {
    state = state.copyWith(
      storeChoosen: storeId,
      storeName: storeName ?? '',
    );
    // Save to cache
    _saveLastSelection();
  }

  /// Update category features (menu permissions)
  void updateCategoryFeatures(List<dynamic> features) {
    state = state.copyWith(categoryFeatures: features);
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

  /// Add newly created company to user's companies list
  ///
  /// This updates the user.companies array in AppState immediately,
  /// providing instant UI feedback without waiting for API refresh.
  void addNewCompanyToUser({
    required String companyId,
    required String companyName,
    String? companyCode,
    Map<String, dynamic>? role,
  }) {
    print('🟢 [AppState] addNewCompanyToUser called');
    print('🟢 [AppState] companyId: $companyId');
    print('🟢 [AppState] companyName: $companyName');
    print('🟢 [AppState] companyCode: $companyCode');

    final userCopy = Map<String, dynamic>.from(state.user);
    final companiesList = List<dynamic>.from(userCopy['companies'] as List<dynamic>? ?? []);

    print('🟢 [AppState] Current companies count: ${companiesList.length}');

    // Add new company to the list
    companiesList.insert(0, {
      'company_id': companyId,
      'company_name': companyName,
      'company_code': companyCode ?? '',
      'stores': <dynamic>[],
      'role': role ?? {'role_name': 'Owner', 'permissions': []},
    });

    print('🟢 [AppState] New companies count: ${companiesList.length}');

    userCopy['companies'] = companiesList;

    state = state.copyWith(user: userCopy);
    print('✅ [AppState] AppState updated with new company');
  }

  /// Add newly created store to company's stores list
  ///
  /// This updates the specific company's stores array in AppState immediately,
  /// providing instant UI feedback without waiting for API refresh.
  void addNewStoreToCompany({
    required String companyId,
    required String storeId,
    required String storeName,
    String? storeCode,
  }) {
    final userCopy = Map<String, dynamic>.from(state.user);
    final companiesList = List<dynamic>.from(userCopy['companies'] as List<dynamic>? ?? []);

    // Find the company and add store to it
    final companyIndex = companiesList.indexWhere(
      (company) => (company as Map<String, dynamic>)['company_id'] == companyId,
    );

    if (companyIndex != -1) {
      final companyCopy = Map<String, dynamic>.from(companiesList[companyIndex] as Map<String, dynamic>);
      final storesList = List<dynamic>.from(companyCopy['stores'] as List<dynamic>? ?? []);

      // Add new store to the list
      storesList.insert(0, {
        'store_id': storeId,
        'store_name': storeName,
        'store_code': storeCode ?? '',
      });

      companyCopy['stores'] = storesList;
      companiesList[companyIndex] = companyCopy;
      userCopy['companies'] = companiesList;

      state = state.copyWith(user: userCopy);
    }
  }

  /// Sign out user
  ///
  /// Clears all user-related state and resets to initial state.
  /// Note: This only handles app state memory. Cache and storage cleanup
  /// should be handled by the logout service.
  void signOut() {
    state = AppState.initial();
    clearLastSelection(); // Clear cached selection on logout
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
