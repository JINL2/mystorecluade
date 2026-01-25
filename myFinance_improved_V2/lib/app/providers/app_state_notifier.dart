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

import '../../core/cache/hive_cache_service.dart';
import '../../core/subscription/entities/subscription_state.dart';
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
    } catch (_) {
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
    } catch (_) {
      // Cache save failure is not critical
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
    } catch (_) {
      // Cache clear failure is not critical
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
  ///
  /// NOTE: Subscription data is passed here for backward compatibility.
  /// New code should watch `subscriptionStateNotifierProvider` directly.
  /// See: lib/core/subscription/providers/subscription_state_notifier.dart
  void updateBusinessContext({
    required String companyId,
    required String storeId,
    String? companyName,
    String? storeName,
    Map<String, dynamic>? subscription,
    int? storeCount,
    int? employeeCount,
  }) {
    // Use plan_name instead of plan_type because:
    // - plan_type in DB is 'free' or 'paid' (billing category)
    // - plan_name is 'free', 'basic', 'pro' (actual plan tier)
    final planName = (subscription?['plan_name'] as String?) ?? state.planType;

    // Handle null max values from DB (Pro plan = unlimited = -1 in app)
    final maxCompanies = subscription?['max_companies'];
    final maxStores = subscription?['max_stores'];
    final maxEmployees = subscription?['max_employees'];
    final convertedMaxEmployees = maxEmployees == null ? -1 : (maxEmployees as int);

    state = state.copyWith(
      companyChoosen: companyId,
      storeChoosen: storeId,
      companyName: companyName ?? state.companyName,
      storeName: storeName ?? state.storeName,
      currentSubscription: subscription ?? state.currentSubscription,
      planType: planName,
      maxCompanies: maxCompanies == null ? -1 : (maxCompanies as int),
      maxStores: maxStores == null ? -1 : (maxStores as int),
      maxEmployees: convertedMaxEmployees,
      aiDailyLimit: (subscription?['ai_daily_limit'] as int?) ?? state.aiDailyLimit,
      // Update current usage counts
      currentStoreCount: storeCount ?? state.currentStoreCount,
      currentEmployeeCount: employeeCount ?? state.currentEmployeeCount,
    );

    // Save to cache
    _saveLastSelection();
  }

  /// Update subscription context
  ///
  /// @deprecated Use `syncFromSubscriptionState` instead.
  /// New code should watch `subscriptionStateNotifierProvider` directly.
  void updateSubscription(Map<String, dynamic> subscription) {
    // Use plan_name instead of plan_type (see updateBusinessContext comment)
    // Handle null max values from DB (Pro plan = unlimited = -1 in app)
    final maxCompanies = subscription['max_companies'];
    final maxStores = subscription['max_stores'];
    final maxEmployees = subscription['max_employees'];
    final convertedMaxEmployees = maxEmployees == null ? -1 : (maxEmployees as int);

    state = state.copyWith(
      currentSubscription: subscription,
      planType: (subscription['plan_name'] as String?) ?? 'free',  // ✅ Use plan_name
      maxCompanies: maxCompanies == null ? -1 : (maxCompanies as int),
      maxStores: maxStores == null ? -1 : (maxStores as int),
      maxEmployees: convertedMaxEmployees,
      aiDailyLimit: (subscription['ai_daily_limit'] as int?) ?? 2,
    );
  }

  /// Update company selection
  ///
  /// Automatically updates usage counts (storeCount, employeeCount) from
  /// the company data stored in AppState.user['companies'].
  /// This ensures subscription_section displays correct data after company switch.
  void selectCompany(String companyId, {String? companyName}) {
    // Find the company data from user's companies list
    final companies = state.user['companies'] as List<dynamic>? ?? [];
    Map<String, dynamic>? selectedCompany;

    for (final company in companies) {
      if ((company as Map<String, dynamic>)['company_id'] == companyId) {
        selectedCompany = company;
        break;
      }
    }

    // Extract usage counts from company data
    final stores = selectedCompany?['stores'] as List<dynamic>? ?? [];
    final employeeCount = selectedCompany?['employee_count'] as int? ?? 0;

    state = state.copyWith(
      companyChoosen: companyId,
      companyName: companyName ?? '',
      // Reset store when company changes
      storeChoosen: '',
      storeName: '',
      // ✅ Update usage counts from selected company's data
      currentStoreCount: stores.length,
      currentEmployeeCount: employeeCount,
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

  /// Update usage counts from get_user_companies_with_subscription RPC response
  ///
  /// Call this after loading user companies data to update all usage counts.
  /// The RPC now returns: company_count, total_store_count, total_employee_count
  /// and per-company: store_count, employee_count
  void updateUsageCounts({
    required int companyCount,
    required int totalStoreCount,
    required int totalEmployeeCount,
    int? currentStoreCount,
    int? currentEmployeeCount,
  }) {
    state = state.copyWith(
      currentCompanyCount: companyCount,
      totalStoreCount: totalStoreCount,
      totalEmployeeCount: totalEmployeeCount,
      // Update current (selected company's) counts if provided
      currentStoreCount: currentStoreCount ?? state.currentStoreCount,
      currentEmployeeCount: currentEmployeeCount ?? state.currentEmployeeCount,
    );
  }

  /// Update current company's usage counts (after selecting a company)
  void updateCurrentCompanyUsage({
    required int storeCount,
    required int employeeCount,
  }) {
    state = state.copyWith(
      currentStoreCount: storeCount,
      currentEmployeeCount: employeeCount,
    );
  }

  /// Increment store count (after creating a new store)
  void incrementStoreCount() {
    state = state.copyWith(
      currentStoreCount: state.currentStoreCount + 1,
      totalStoreCount: state.totalStoreCount + 1,
    );
  }

  /// Increment employee count (after adding a new employee)
  void incrementEmployeeCount() {
    state = state.copyWith(
      currentEmployeeCount: state.currentEmployeeCount + 1,
      totalEmployeeCount: state.totalEmployeeCount + 1,
    );
  }

  /// Increment company count (after creating a new company)
  void incrementCompanyCount() {
    state = state.copyWith(
      currentCompanyCount: state.currentCompanyCount + 1,
    );
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
  /// Also syncs to Hive cache for persistence across app restarts.
  void addNewCompanyToUser({
    required String companyId,
    required String companyName,
    String? companyCode,
    Map<String, dynamic>? role,
  }) {
    final userCopy = Map<String, dynamic>.from(state.user);
    final companiesList = List<dynamic>.from(userCopy['companies'] as List<dynamic>? ?? []);

    // Add new company to the list
    companiesList.insert(0, {
      'company_id': companyId,
      'company_name': companyName,
      'company_code': companyCode ?? '',
      'stores': <dynamic>[],
      'role': role ?? {'role_name': 'Owner', 'permissions': []},
    });

    userCopy['companies'] = companiesList;

    state = state.copyWith(user: userCopy);

    // Sync to Hive cache (fire-and-forget)
    _syncUserToHiveCache(userCopy);
  }

  /// Add newly created store to company's stores list
  ///
  /// This updates the specific company's stores array in AppState immediately,
  /// providing instant UI feedback without waiting for API refresh.
  /// Also syncs to Hive cache for persistence across app restarts.
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

      // Sync to Hive cache (fire-and-forget)
      _syncUserToHiveCache(userCopy);
    }
  }

  /// Sync user data to Hive cache
  ///
  /// Called after adding new company/store to ensure persistence.
  /// Fire-and-forget - doesn't block UI.
  Future<void> _syncUserToHiveCache(Map<String, dynamic> userData) async {
    try {
      final userId = userData['user_id'] as String?;
      if (userId != null && userId.isNotEmpty) {
        await HiveCacheService.instance.saveUserCompanies(userId, userData);
      }
    } catch (_) {
      // Cache sync failure is not critical - data is already in AppState
    }
  }

  /// Sign out user
  ///
  /// Clears all user-related state and resets to initial state.
  /// Note: This only handles app state memory. Cache and storage cleanup
  /// should be handled by the logout service.
  void signOut() {
    state = AppState.initial();
    clearLastSelection();
  }

  // ============================================================================
  // SubscriptionState Integration (2026 Subscription Workflow)
  // ============================================================================

  /// Sync subscription data from SubscriptionStateNotifier
  ///
  /// Called when SubscriptionStateNotifier updates to keep AppState in sync.
  /// This enables existing code that reads subscription from AppState to
  /// continue working while we migrate to the new SubscriptionStateNotifier.
  ///
  /// ## Data Flow (2026 Architecture)
  /// ```
  /// RevenueCat SDK ──┐
  ///                  ├──▶ SubscriptionStateNotifier ──▶ UI (직접 watch)
  /// Supabase Realtime┘              │
  ///                                 ▼
  ///                       AppState (backward compat)
  /// ```
  ///
  /// ## Value Conversion
  /// - SubscriptionState uses NULL for unlimited
  /// - AppState uses -1 for unlimited
  ///
  /// @deprecated New code should watch `subscriptionStateNotifierProvider` directly.
  void syncFromSubscriptionState(SubscriptionState subState) {
    // Build subscription map for backward compatibility with code that reads
    // from AppState.currentSubscription
    final newSubscription = {
      'plan_id': subState.planId,
      'plan_name': subState.planName,
      'display_name': subState.displayName,
      'plan_type': subState.planType,
      'max_companies': subState.maxCompaniesForDomain,
      'max_stores': subState.maxStoresForDomain,
      'max_employees': subState.maxEmployeesForDomain,
      'ai_daily_limit': subState.aiDailyLimitForDomain,
      'features': subState.features,
      'status': subState.status,
    };

    // NOTE: We no longer update user['companies'] here.
    // UI components should watch subscriptionStateNotifierProvider directly
    // for real-time subscription updates (e.g., company_store_list.dart).

    state = state.copyWith(
      planType: subState.planName,
      // Convert null → -1 for unlimited (AppState uses -1, SubscriptionState uses null)
      maxCompanies: subState.maxCompaniesForDomain,
      maxStores: subState.maxStoresForDomain,
      maxEmployees: subState.maxEmployeesForDomain,
      aiDailyLimit: subState.aiDailyLimitForDomain,
      // Update subscription map for backward compatibility
      currentSubscription: newSubscription,
    );
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
