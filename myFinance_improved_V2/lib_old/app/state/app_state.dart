/// Global Application State - Future Architecture Pattern
/// 
/// Purpose: Centralized app-level state management (user, company, permissions)
/// - Replaces scattered global providers with unified state
/// - Enables clean Feature → App state references
/// - Prepares for future app/ folder migration
/// - Maintains cross-cutting concerns in dedicated location
/// 
/// ✅ MIGRATED: Now in lib/app/state/app_state.dart

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
}