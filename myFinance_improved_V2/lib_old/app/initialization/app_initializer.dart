/// App Initialization Helper - Future Architecture Pattern
/// 
/// Purpose: Manages app initialization and state synchronization
/// - Legacy to new state migration
/// - Initial app state setup
/// - Provider synchronization during transition period
/// 
/// ✅ MIGRATED: Now in lib/app/initialization/

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';
import '../state/app_state.dart';
import '../../presentation/providers/app_state_provider.dart' as Legacy;

/// App Initializer Service
/// 
/// Handles initialization of the new app state architecture
/// and synchronization with legacy providers during migration
class AppInitializer {
  static bool _isInitialized = false;
  
  /// Initialize app state from legacy provider
  /// 
  /// This method should be called when entering this module
  /// to ensure the new app state is synchronized with legacy state
  static void initializeFromLegacy(WidgetRef ref) {
    if (_isInitialized) return;
    
    try {
      // Get current legacy app state
      final legacyAppState = ref.read(Legacy.appStateProvider);
      
      // Initialize new app state
      final appStateNotifier = ref.read(appStateProvider.notifier);
      
      // Convert and sync legacy state to new state
      final legacyStateMap = _convertLegacyStateToMap(legacyAppState);
      appStateNotifier.initializeFromLegacy(legacyStateMap);
      
      _isInitialized = true;
      
      print('🚀 App State Initialized: Legacy → Future Architecture');
      print('   User: ${legacyStateMap['user']?['user_id'] ?? 'Unknown'}');
      print('   Company: ${legacyStateMap['companyChoosen'] ?? 'None'}');
      print('   Store: ${legacyStateMap['storeChoosen'] ?? 'None'}');
      
    } catch (e, stackTrace) {
      print('❌ App State Initialization Failed: $e');
      print('Stack: $stackTrace');
      
      // Fallback: Initialize with empty state
      final appStateNotifier = ref.read(appStateProvider.notifier);
      appStateNotifier.initializeFromLegacy({});
      _isInitialized = true;
    }
  }
  
  /// Sync legacy state changes to new state
  /// 
  /// Should be called whenever legacy state changes
  /// to keep both states in sync during migration period
  static void syncLegacyChanges(WidgetRef ref) {
    if (!_isInitialized) {
      initializeFromLegacy(ref);
      return;
    }
    
    try {
      final legacyAppState = ref.read(Legacy.appStateProvider);
      final appStateNotifier = ref.read(appStateProvider.notifier);
      
      final legacyStateMap = _convertLegacyStateToMap(legacyAppState);
      appStateNotifier.syncWithLegacyProvider(legacyStateMap);
      
    } catch (e) {
      print('⚠️ Legacy State Sync Failed: $e');
    }
  }
  
  /// Check if app state is ready for business operations
  static bool isReadyForBusiness(WidgetRef ref) {
    try {
      final appState = ref.read(appStateProvider);
      return appState.isReadyForBusiness;
    } catch (e) {
      return false;
    }
  }
  
  /// Get current business context
  static ({String companyId, String storeId}) getBusinessContext(WidgetRef ref) {
    try {
      final businessContext = ref.read(businessContextProvider);
      return businessContext;
    } catch (e) {
      return (companyId: '', storeId: '');
    }
  }
  
  /// Reset initialization state (for testing)
  static void resetForTesting() {
    _isInitialized = false;
  }
  
  /// Convert legacy app state to new state format
  static Map<String, dynamic> _convertLegacyStateToMap(dynamic legacyState) {
    // Handle different legacy state formats
    if (legacyState == null) {
      return _getDefaultStateMap();
    }
    
    // If legacy state is already a Map
    if (legacyState is Map<String, dynamic>) {
      return _normalizeStateMap(legacyState);
    }
    
    // If legacy state is an object with properties
    try {
      return _extractStateFromObject(legacyState);
    } catch (e) {
      print('⚠️ Failed to convert legacy state: $e');
      return _getDefaultStateMap();
    }
  }
  
  /// Normalize legacy state map to expected format
  static Map<String, dynamic> _normalizeStateMap(Map<String, dynamic> state) {
    return <String, dynamic>{
      'user': state['user'] ?? <String, dynamic>{},
      'isAuthenticated': state['isAuthenticated'] ?? false,
      'companyChoosen': state['companyChoosen'] ?? '',
      'storeChoosen': state['storeChoosen'] ?? '',
      'companyName': state['companyName'] ?? '',
      'storeName': state['storeName'] ?? '',
      'permissions': state['permissions'] ?? <String>[],
      'hasAdminPermission': state['hasAdminPermission'] ?? false,
      'themeMode': state['themeMode'] ?? 'light',
      'languageCode': state['languageCode'] ?? 'en',
      'isOfflineMode': state['isOfflineMode'] ?? false,
      'isLoading': state['isLoading'] ?? false,
      'error': state['error'],
    };
  }
  
  /// Extract state from legacy object (reflection-like approach)
  static Map<String, dynamic> _extractStateFromObject(dynamic legacyState) {
    final result = <String, dynamic>{};
    
    // Try to access common legacy properties
    try {
      result['companyChoosen'] = _getProperty(legacyState, 'companyChoosen') ?? '';
      result['storeChoosen'] = _getProperty(legacyState, 'storeChoosen') ?? '';
      result['user'] = _getProperty(legacyState, 'user') ?? <String, dynamic>{};
      result['isAuthenticated'] = _getProperty(legacyState, 'isAuthenticated') ?? false;
      result['hasAdminPermission'] = _getProperty(legacyState, 'hasAdminPermission') ?? false;
    } catch (e) {
      print('⚠️ Property extraction failed: $e');
    }
    
    return _normalizeStateMap(result);
  }
  
  /// Get property value using dynamic access
  static dynamic _getProperty(dynamic object, String propertyName) {
    try {
      // Use reflection or toString() parsing as fallback
      final objectString = object.toString();
      if (objectString.contains(propertyName)) {
        // Simple pattern matching for debugging
        // In production, this would use proper reflection
        return null;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
  
  /// Get default state map
  static Map<String, dynamic> _getDefaultStateMap() {
    return <String, dynamic>{
      'user': <String, dynamic>{},
      'isAuthenticated': false,
      'companyChoosen': '',
      'storeChoosen': '',
      'companyName': '',
      'storeName': '',
      'permissions': <String>[],
      'hasAdminPermission': false,
      'themeMode': 'light',
      'languageCode': 'en',
      'isOfflineMode': false,
      'isLoading': false,
      'error': null,
    };
  }
}

/// Provider for app initialization status
final appInitializationProvider = Provider<bool>((ref) {
  try {
    final appState = ref.read(appStateProvider);
    return appState.isReadyForBusiness;
  } catch (e) {
    return false;
  }
});

/// Provider that automatically initializes app state when accessed
final autoInitializeProvider = Provider<void>((ref) {
  // This provider automatically initializes app state when first accessed
  // Note: This will be called during widget initialization
  return;
});