/// Global Application State - Clean Architecture Pattern
///
/// Purpose: Centralized app-level state management (user, company, permissions)
/// - Replaces scattered global providers with unified state
/// - Enables clean Feature → App state references
/// - Maintains cross-cutting concerns in dedicated location
///
/// ✅ LOCATION: lib/app/providers/app_state.dart
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_state.freezed.dart';

/// Global Application State
///
/// Contains all app-wide context that features might need:
/// - User authentication context
/// - Business context (company/store selection)
/// - Permission context
/// - App configuration context
@freezed
class AppState with _$AppState {
  const factory AppState({
    // User Context
    @Default({}) Map<String, dynamic> user,
    @Default('') String userId,
    @Default(false) bool isAuthenticated,

    // Business Context
    @Default('') String companyChoosen,
    @Default('') String storeChoosen,
    @Default('') String companyName,
    @Default('') String storeName,

    // Subscription Context (for currently selected company)
    @Default({}) Map<String, dynamic> currentSubscription,
    @Default('free') String planType,  // 'free', 'basic', 'pro'
    @Default(1) int maxCompanies,
    @Default(1) int maxStores,
    @Default(5) int maxEmployees,
    @Default(2) int aiDailyLimit,

    // Current Usage Counts (for subscription limit checks)
    @Default(0) int currentCompanyCount,
    @Default(0) int currentStoreCount,
    @Default(0) int currentEmployeeCount,
    @Default(0) int totalStoreCount,      // 전체 가게 수 (모든 회사)
    @Default(0) int totalEmployeeCount,   // 전체 직원 수 (모든 회사)

    // Menu & Features Context (from get_categories_with_features RPC)
    @Default([]) List<dynamic> categoryFeatures,

    // Permission Context
    @Default({}) Set<String> permissions,
    @Default(false) bool hasAdminPermission,

    // App Configuration Context
    @Default('light') String themeMode,
    @Default('en') String languageCode,
    @Default(false) bool isOfflineMode,

    // Loading States
    @Default(false) bool isLoading,
    @Default(null) String? error,
  }) = _AppState;

  /// Factory constructor for initial state
  factory AppState.initial() => const AppState();

  /// Factory constructor from legacy app state
  factory AppState.fromLegacyProvider(Map<String, dynamic> legacyState) {
    return AppState(
      user: (legacyState['user'] as Map<String, dynamic>?) ?? <String, dynamic>{},
      userId: ((legacyState['user'] as Map<String, dynamic>?) ?? <String, dynamic>{})['user_id'] as String? ?? '',
      isAuthenticated: (legacyState['isAuthenticated'] as bool?) ?? false,
      companyChoosen: (legacyState['companyChoosen'] as String?) ?? '',
      storeChoosen: (legacyState['storeChoosen'] as String?) ?? '',
      companyName: (legacyState['companyName'] as String?) ?? '',
      storeName: (legacyState['storeName'] as String?) ?? '',
      currentSubscription: (legacyState['currentSubscription'] as Map<String, dynamic>?) ?? <String, dynamic>{},
      planType: (legacyState['planType'] as String?) ?? 'free',
      maxCompanies: (legacyState['maxCompanies'] as int?) ?? 1,
      maxStores: (legacyState['maxStores'] as int?) ?? 1,
      maxEmployees: (legacyState['maxEmployees'] as int?) ?? 5,
      aiDailyLimit: (legacyState['aiDailyLimit'] as int?) ?? 2,
      currentCompanyCount: (legacyState['currentCompanyCount'] as int?) ?? 0,
      currentStoreCount: (legacyState['currentStoreCount'] as int?) ?? 0,
      currentEmployeeCount: (legacyState['currentEmployeeCount'] as int?) ?? 0,
      totalStoreCount: (legacyState['totalStoreCount'] as int?) ?? 0,
      totalEmployeeCount: (legacyState['totalEmployeeCount'] as int?) ?? 0,
      categoryFeatures: (legacyState['categoryFeatures'] as List<dynamic>?) ?? <dynamic>[],
      permissions: Set<String>.from((legacyState['permissions'] as List<dynamic>?) ?? <String>[]),
      hasAdminPermission: (legacyState['hasAdminPermission'] as bool?) ?? false,
      themeMode: (legacyState['themeMode'] as String?) ?? 'light',
      languageCode: (legacyState['languageCode'] as String?) ?? 'en',
      isOfflineMode: (legacyState['isOfflineMode'] as bool?) ?? false,
      isLoading: (legacyState['isLoading'] as bool?) ?? false,
      error: legacyState['error'] as String?,
    );
  }
}

/// App State Extensions for convenience
extension AppStateExtensions on AppState {
  /// Check if required business context is available
  bool get hasBusinessContext =>
    companyChoosen.isNotEmpty && storeChoosen.isNotEmpty;

  /// Check if user context is complete
  bool get hasUserContext =>
    userId.isNotEmpty && isAuthenticated;

  /// Check if app is ready for business operations
  bool get isReadyForBusiness =>
    hasUserContext && hasBusinessContext && !isLoading;

  /// Get user display name
  String get userDisplayName =>
    (user['display_name'] as String?) ?? (user['email'] as String?) ?? (user['username'] as String?) ?? 'Unknown User';

  /// Check specific permission
  bool hasPermission(String permission) => permissions.contains(permission);

  /// Get business context as map (for backward compatibility)
  Map<String, String> get businessContext => {
    'companyId': companyChoosen,
    'storeId': storeChoosen,
    'companyName': companyName,
    'storeName': storeName,
  };

  // === Subscription-related convenience methods ===

  /// Check if on free plan
  bool get isFreePlan => planType == 'free';

  /// Check if on basic plan
  bool get isBasicPlan => planType == 'basic';

  /// Check if on pro plan
  bool get isProPlan => planType == 'pro';

  /// Check if on paid plan (basic or pro)
  bool get isPaidPlan => planType != 'free';

  /// Check if companies are unlimited (null in DB means unlimited for Pro)
  bool get hasUnlimitedCompanies => maxCompanies == -1;

  /// Check if stores are unlimited (-1 means unlimited)
  bool get hasUnlimitedStores => maxStores == -1;

  /// Check if employees are unlimited (-1 means unlimited)
  bool get hasUnlimitedEmployees => maxEmployees == -1;

  /// Check if AI is unlimited (-1 means unlimited)
  bool get hasUnlimitedAI => aiDailyLimit == -1;

  /// Check if can add more companies
  bool get canAddCompany {
    if (hasUnlimitedCompanies) return true;
    return currentCompanyCount < maxCompanies;
  }

  /// Check if can add more stores (uses cached currentStoreCount)
  bool get canAddStore {
    if (hasUnlimitedStores) return true;
    return currentStoreCount < maxStores;
  }

  /// Check if can add more employees (uses cached currentEmployeeCount)
  bool get canAddEmployee {
    if (hasUnlimitedEmployees) return true;
    return currentEmployeeCount < maxEmployees;
  }

  /// Legacy: Check if can add more stores (with explicit count parameter)
  bool canAddStoreWithCount(int storeCount) {
    if (hasUnlimitedStores) return true;
    return storeCount < maxStores;
  }

  /// Legacy: Check if can add more employees (with explicit count parameter)
  bool canAddEmployeeWithCount(int employeeCount) {
    if (hasUnlimitedEmployees) return true;
    return employeeCount < maxEmployees;
  }

  /// Check if AI request is allowed today
  bool canUseAI(int usedToday) {
    if (hasUnlimitedAI) return true;
    return usedToday < aiDailyLimit;
  }

  /// Get subscription plan display name
  String get planDisplayName {
    switch (planType) {
      case 'basic':
        return 'Basic';
      case 'pro':
        return 'Pro';
      default:
        return 'Free';
    }
  }

  // === Role-related convenience methods ===

  /// Get current company's role name from AppState
  ///
  /// Returns the role name (e.g., "Owner", "Manager", "Cashier") for the
  /// currently selected company. Falls back to 'Employee' if not found.
  /// Data comes from get_user_companies_with_salary RPC loaded at app start.
  String get currentCompanyRoleName {
    if (companyChoosen.isEmpty) return 'Employee';

    final companies = user['companies'] as List<dynamic>?;
    if (companies == null || companies.isEmpty) return 'Employee';

    try {
      final currentCompany = companies.firstWhere(
        (c) => (c as Map<String, dynamic>)['company_id'] == companyChoosen,
      ) as Map<String, dynamic>;

      final role = currentCompany['role'] as Map<String, dynamic>?;
      if (role == null) return 'Employee';

      return (role['role_name'] as String?) ?? 'Employee';
    } catch (_) {
      return 'Employee';
    }
  }

  /// Check if user is owner of current selected company
  ///
  /// Returns true if user's role in the currently selected company is 'Owner'.
  /// Used to show/hide owner-only features like subscription management.
  bool get isCurrentCompanyOwner {
    return currentCompanyRoleName.toLowerCase() == 'owner';
  }

}
