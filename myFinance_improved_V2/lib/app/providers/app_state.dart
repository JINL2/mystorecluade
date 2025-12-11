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
    @Default(1) int maxStores,
    @Default(5) int maxEmployees,
    @Default(2) int aiDailyLimit,

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
      maxStores: (legacyState['maxStores'] as int?) ?? 1,
      maxEmployees: (legacyState['maxEmployees'] as int?) ?? 5,
      aiDailyLimit: (legacyState['aiDailyLimit'] as int?) ?? 2,
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

  /// Check if stores are unlimited (-1 means unlimited)
  bool get hasUnlimitedStores => maxStores == -1;

  /// Check if employees are unlimited (-1 means unlimited)
  bool get hasUnlimitedEmployees => maxEmployees == -1;

  /// Check if AI is unlimited (-1 means unlimited)
  bool get hasUnlimitedAI => aiDailyLimit == -1;

  /// Check if can add more stores (based on current store count)
  bool canAddStore(int currentStoreCount) {
    if (hasUnlimitedStores) return true;
    return currentStoreCount < maxStores;
  }

  /// Check if can add more employees
  bool canAddEmployee(int currentEmployeeCount) {
    if (hasUnlimitedEmployees) return true;
    return currentEmployeeCount < maxEmployees;
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
}
