/// App-level Providers - Future Architecture Pattern
/// 
/// Purpose: Global providers that manage app-wide state and services
/// - App state management (user, company, permissions)
/// - Cross-cutting concerns providers
/// - Legacy provider bridge for smooth migration
/// 
/// ✅ MIGRATED: Now in lib/app/providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'state/app_state.dart';
import 'state/app_state_notifier.dart';

// =============================================================================
// App State Providers (Future Architecture)
// =============================================================================

/// Global App State Provider - Future Architecture
/// 
/// This will be the main app state provider in the future structure.
/// Currently serves as a bridge between legacy and future architecture.
final appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>((ref) {
  return AppStateNotifier();
});

/// Legacy App State Provider Bridge
/// 
/// Provides backward compatibility with existing appStateProvider
/// during migration period. This allows gradual transition.
final legacyAppStateProvider = Provider<Map<String, dynamic>>((ref) {
  final appState = ref.watch(appStateProvider);
  
  // Convert new AppState back to legacy format for compatibility
  return {
    'user': appState.user,
    'isAuthenticated': appState.isAuthenticated,
    'companyChoosen': appState.companyChoosen,
    'storeChoosen': appState.storeChoosen,
    'companyName': appState.companyName,
    'storeName': appState.storeName,
    'permissions': appState.permissions.toList(),
    'hasAdminPermission': appState.hasAdminPermission,
    'themeMode': appState.themeMode,
    'languageCode': appState.languageCode,
    'isOfflineMode': appState.isOfflineMode,
    'isLoading': appState.isLoading,
    'error': appState.error,
  };
});

// =============================================================================
// Computed App State Providers
// =============================================================================

/// Current User Provider
final currentUserProvider = Provider<Map<String, dynamic>>((ref) {
  return ref.watch(appStateProvider.select((state) => state.user));
});

/// Current User ID Provider
final currentUserIdProvider = Provider<String>((ref) {
  return ref.watch(appStateProvider.select((state) => state.userId));
});

/// Business Context Provider
final businessContextProvider = Provider<({String companyId, String storeId})>((ref) {
  final appState = ref.watch(appStateProvider);
  return (
    companyId: appState.companyChoosen,
    storeId: appState.storeChoosen,
  );
});

/// Company Context Provider
final companyContextProvider = Provider<String>((ref) {
  return ref.watch(appStateProvider.select((state) => state.companyChoosen));
});

/// Store Context Provider  
final storeContextProvider = Provider<String>((ref) {
  return ref.watch(appStateProvider.select((state) => state.storeChoosen));
});

/// Admin Permission Provider
final hasAdminPermissionProvider = Provider<bool>((ref) {
  return ref.watch(appStateProvider.select((state) => state.hasAdminPermission));
});

/// Specific Permission Provider
final hasPermissionProvider = Provider.family<bool, String>((ref, permission) {
  final permissions = ref.watch(appStateProvider.select((state) => state.permissions));
  return permissions.contains(permission);
});

/// App Ready State Provider
final isAppReadyProvider = Provider<bool>((ref) {
  return ref.watch(appStateProvider.select((state) => state.isReadyForBusiness));
});

/// Business Context Ready Provider
final hasBusinessContextProvider = Provider<bool>((ref) {
  return ref.watch(appStateProvider.select((state) => state.hasBusinessContext));
});

// =============================================================================
// Migration Helper Providers
// =============================================================================

/// Legacy Migration Helper
/// 
/// Helps synchronize between legacy appStateProvider and new app state
/// during migration period. This ensures both systems stay in sync.
final migrationSyncProvider = Provider<void>((ref) {
  // This provider can be used to sync legacy state with new state
  // Will be removed after full migration
  return;
});

/// Backward Compatibility Provider
/// 
/// Provides the exact same interface as the original appStateProvider
/// but backed by the new architecture. This allows existing code to work
/// without changes during migration.
class BackwardCompatibilityAppState {
  final AppState _appState;
  
  BackwardCompatibilityAppState(this._appState);
  
  // Legacy interface compatibility
  String get companyChoosen => _appState.companyChoosen;
  String get storeChoosen => _appState.storeChoosen;
  Map<String, dynamic> get user => _appState.user;
  bool get isAuthenticated => _appState.isAuthenticated;
  bool get hasAdminPermission => _appState.hasAdminPermission;
  
  // Additional convenience methods
  String get userId => _appState.userId;
  Set<String> get permissions => _appState.permissions;
  bool get isReady => _appState.isReadyForBusiness;
}

final backwardCompatibilityProvider = Provider<BackwardCompatibilityAppState>((ref) {
  final appState = ref.watch(appStateProvider);
  return BackwardCompatibilityAppState(appState);
});

// =============================================================================
// Future Migration Notes
// =============================================================================

/// MIGRATION PLAN:
/// 
/// Phase 1 (Current): 
/// - Create app/state/ structure within transaction_template_refectore
/// - Bridge existing providers with new architecture
/// - Test compatibility and functionality
/// 
/// Phase 2 (Future):
/// - Move app/ folder to lib/app/
/// - Update all import paths
/// - Remove legacy compatibility layers
/// - Full migration to new architecture
/// 
/// Phase 3 (Final):
/// - All features use lib/app/state/ for global context
/// - Remove all legacy app state providers
/// - Clean up migration helpers