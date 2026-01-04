import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../repositories/notification_repository.dart';
import 'fcm_service.dart';

/// Production-safe FCM token management service
/// Optimized for fast initialization and no duplicate registrations
class ProductionTokenService {
  static final ProductionTokenService _instance = ProductionTokenService._internal();
  factory ProductionTokenService() => _instance;
  ProductionTokenService._internal();

  final FcmService _fcmService = FcmService();
  final NotificationRepository _repository = NotificationRepository();
  final SupabaseClient _supabase = Supabase.instance.client;

  // State management
  bool _isInitialized = false;
  bool _isInitializing = false;
  bool _isRegistering = false; // 🔧 NEW: Prevent duplicate registration calls
  String? _currentToken;
  String? _lastRegisteredToken;
  String? _lastRegisteredUserId; // 🔧 NEW: Track which user we registered for
  StreamSubscription<AuthState>? _authSubscription; // 🔧 NEW: Track subscription
  final List<Completer<bool>> _pendingRegistrations = [];

  // Production monitoring
  final Map<String, dynamic> _stats = {
    'successful_registrations': 0,
    'failed_registrations': 0,
    'race_conditions_handled': 0,
    'duplicate_calls_prevented': 0,
    'fallback_recoveries': 0,
    'monthly_refreshes': 0,
    'logout_deactivations': 0,
  };

  // Monthly refresh tracking (Firebase recommends monthly token refresh)
  DateTime? _lastMonthlyRefresh;
  Timer? _monthlyRefreshTimer;

  /// Initialize the service - called once at app start
  /// 🔧 OPTIMIZED: Faster initialization, no blocking waits
  Future<void> initialize() async {
    if (_isInitialized || _isInitializing) return;

    _isInitializing = true;

    try {
      // 🔧 OPTIMIZED: Single initialization attempt, no retry loop
      await _fcmService.initialize();
      _currentToken = _fcmService.fcmToken;

      // Set up auth state monitoring (only once)
      _setupAuthStateMonitoring();

      _isInitialized = true;
      _isInitializing = false;

      // Complete any pending registrations
      _completePendingRegistrations(success: true);

      if (kDebugMode) {
        debugPrint('✅ ProductionTokenService initialized successfully');
      }

    } catch (e) {
      _isInitializing = false;
      _isInitialized = true; // 🔧 Mark as initialized even on failure to prevent infinite retries

      // Complete pending registrations with failure
      _completePendingRegistrations(success: false);

      if (kDebugMode) {
        debugPrint('❌ ProductionTokenService initialization failed: $e');
      }
    }
  }

  /// Set up auth state monitoring for automatic token registration
  /// 🔧 OPTIMIZED: Only listen once, prevent duplicate subscriptions
  void _setupAuthStateMonitoring() {
    // Cancel existing subscription if any
    _authSubscription?.cancel();

    _authSubscription = _supabase.auth.onAuthStateChange.listen((data) async {
      // 🔧 OPTIMIZED: Only handle signedIn, ignore other events
      if (data.event == AuthChangeEvent.signedIn && data.session?.user != null) {
        final userId = data.session!.user.id;

        // 🔧 OPTIMIZED: Skip if already registered for this user in this session
        if (_lastRegisteredUserId == userId && _lastRegisteredToken == _currentToken) {
          if (kDebugMode) {
            debugPrint('⏭️ Token already registered for user, skipping');
          }
          _stats['duplicate_calls_prevented'] = (_stats['duplicate_calls_prevented'] as int) + 1;
          return;
        }

        await _registerTokenInternal(userId);
      }
    });
  }

  /// Register token immediately after authentication - production-safe
  /// 🔧 OPTIMIZED: Deduplication and faster execution
  Future<bool> registerTokenAfterAuth() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return false;

    return await _registerTokenInternal(userId);
  }

  /// Internal registration with deduplication
  /// 🔧 NEW: Centralized registration logic with proper guards
  Future<bool> _registerTokenInternal(String userId) async {
    // 🔧 Prevent concurrent registration calls
    if (_isRegistering) {
      _stats['duplicate_calls_prevented'] = (_stats['duplicate_calls_prevented'] as int) + 1;
      if (kDebugMode) {
        debugPrint('⏭️ Registration already in progress, skipping duplicate call');
      }
      return true; // Return true as registration is happening
    }

    // 🔧 Skip if same token already registered for same user
    final currentToken = _fcmService.fcmToken;
    if (currentToken != null &&
        currentToken == _lastRegisteredToken &&
        userId == _lastRegisteredUserId) {
      _stats['duplicate_calls_prevented'] = (_stats['duplicate_calls_prevented'] as int) + 1;
      return true;
    }

    _isRegistering = true;

    try {
      return await _executeReliableTokenRegistration(userId);
    } catch (e) {
      _stats['failed_registrations'] = (_stats['failed_registrations'] as int) + 1;

      if (kDebugMode) {
        debugPrint('❌ Token registration failed: $e');
      }

      // Schedule background retry
      _scheduleBackgroundRetry();
      return false;
    } finally {
      _isRegistering = false;
    }
  }

  /// Execute reliable token registration
  /// 🔧 OPTIMIZED: Removed unnecessary delays and redundant checks
  Future<bool> _executeReliableTokenRegistration(String userId) async {
    // Step 1: Get current token (no retry loop needed)
    String? token = _fcmService.fcmToken;

    // Step 2: If no token available, try one refresh
    if (token == null) {
      if (_fcmService.isAvailable) {
        await _performTokenRefresh();
        token = _fcmService.fcmToken;
      }
    }

    if (token == null) {
      throw Exception('FCM token unavailable');
    }

    // 🔧 OPTIMIZED: Skip DB check if we know token is already registered
    if (token == _lastRegisteredToken && userId == _lastRegisteredUserId) {
      return true;
    }

    // Step 3: Store token directly (let DB handle upsert)
    final result = await _repository.storeOrUpdateFcmToken(
      userId: userId,
      token: token,
      platform: Platform.isIOS ? 'ios' : 'android',
      deviceId: 'device_${userId.hashCode}', // 🔧 Use stable device ID
      deviceModel: Platform.operatingSystem,
      appVersion: '1.0.0',
    );

    if (result != null && !(result.id?.startsWith('fallback_') ?? false)) {
      // Success - update state
      _lastRegisteredToken = token;
      _lastRegisteredUserId = userId;
      _currentToken = token;
      _stats['successful_registrations'] = (_stats['successful_registrations'] as int) + 1;

      if (kDebugMode) {
        debugPrint('✅ Token registered successfully: ${result.id}');
      }

      return true;
    } else {
      throw Exception('Token storage failed');
    }
  }

  /// Perform token refresh
  /// 🔧 OPTIMIZED: Reduced delay from 1000ms to 300ms
  Future<void> _performTokenRefresh() async {
    try {
      await _fcmService.deleteToken();
      await Future<void>.delayed(const Duration(milliseconds: 300));
      await _fcmService.initialize();
      _currentToken = _fcmService.fcmToken;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Token refresh failed: $e');
      }
      rethrow;
    }
  }

  /// Register token for login - handles race conditions
  /// 🔧 OPTIMIZED: Simpler logic, relies on internal deduplication
  Future<bool> registerTokenForLogin() async {
    // If service is not initialized yet, queue the registration
    if (!_isInitialized) {
      if (_isInitializing) {
        // Service is initializing - wait for completion
        final completer = Completer<bool>();
        _pendingRegistrations.add(completer);
        _stats['race_conditions_handled'] = (_stats['race_conditions_handled'] as int) + 1;
        return completer.future;
      } else {
        await initialize();
      }
    }

    return await registerTokenAfterAuth();
  }

  /// Complete all pending registrations
  void _completePendingRegistrations({required bool success}) {
    for (final completer in _pendingRegistrations) {
      if (!completer.isCompleted) {
        completer.complete(success);
      }
    }
    _pendingRegistrations.clear();
  }

  /// Schedule background retry for failed registrations
  void _scheduleBackgroundRetry() {
    Timer(const Duration(minutes: 2), () async {
      try {
        await registerTokenAfterAuth();
        _stats['fallback_recoveries'] = (_stats['fallback_recoveries'] as int) + 1;

        if (kDebugMode) {
          debugPrint('✅ Background token recovery successful');
        }
      } catch (e) {
        if (kDebugMode) {
          debugPrint('❌ Background token recovery failed: $e');
        }
      }
    });
  }
  
  /// Verify token is properly saved in Supabase
  Future<bool> verifyTokenSaved() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return false;
      
      final tokens = await _repository.getActiveFcmTokens(userId);
      final currentToken = _fcmService.fcmToken;
      
      if (currentToken == null) return false;
      
      final tokenExists = tokens.any((t) => t.token == currentToken);
      
      if (!tokenExists) {
        if (kDebugMode) {
          debugPrint('⚠️ Token verification failed - not found in Supabase');
        }
        
        // Attempt to register again
        return await registerTokenAfterAuth();
      }
      
      return true;
      
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Token verification error: $e');
      }
      return false;
    }
  }
  
  /// Get production statistics for monitoring
  Map<String, dynamic> getProductionStats() {
    return {
      'is_initialized': _isInitialized,
      'current_token_available': _currentToken != null,
      'last_registered_token': _lastRegisteredToken != null,
      'tokens_match': _currentToken == _lastRegisteredToken,
      'pending_registrations': _pendingRegistrations.length,
      'stats': Map<String, dynamic>.from(_stats),
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
  
  /// Force token refresh for emergency situations
  Future<bool> emergencyTokenRefresh() async {
    try {
      if (kDebugMode) {
        debugPrint('🚨 Emergency token refresh initiated');
      }

      await _performTokenRefresh();

      // Register the new token
      return await registerTokenAfterAuth();

    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Emergency token refresh failed: $e');
      }
      return false;
    }
  }
  
  /// Auto-recovery system - validates and recovers tokens periodically
  /// Also includes monthly token refresh (Firebase 2025 Best Practice)
  void startAutoRecoverySystem() {
    // Run token validation every 30 minutes in production
    Timer.periodic(const Duration(minutes: 30), (timer) async {
      await _performAutoRecovery();
    });

    // 🔧 NEW: Monthly token refresh (Firebase recommends)
    // Check every 24 hours if monthly refresh is needed
    _monthlyRefreshTimer?.cancel();
    _monthlyRefreshTimer = Timer.periodic(const Duration(hours: 24), (timer) async {
      await _performMonthlyTokenRefreshIfNeeded();
    });

    // Also check immediately on startup
    _performMonthlyTokenRefreshIfNeeded();
  }

  /// Firebase 2025 Best Practice: Monthly token refresh
  /// Refreshes FCM token once a month to prevent stale tokens
  Future<void> _performMonthlyTokenRefreshIfNeeded() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      // Check if 30 days have passed since last refresh
      final now = DateTime.now();
      if (_lastMonthlyRefresh != null) {
        final daysSinceRefresh = now.difference(_lastMonthlyRefresh!).inDays;
        if (daysSinceRefresh < 30) {
          if (kDebugMode) {
            debugPrint('📅 Monthly refresh not needed yet (${30 - daysSinceRefresh} days remaining)');
          }
          return;
        }
      }

      if (kDebugMode) {
        debugPrint('🔄 [FCM] Performing monthly token refresh...');
      }

      // Delete old token and get new one
      await _performTokenRefresh();

      // Register the new token
      final success = await registerTokenAfterAuth();

      if (success) {
        _lastMonthlyRefresh = now;
        _stats['monthly_refreshes'] = (_stats['monthly_refreshes'] as int) + 1;

        if (kDebugMode) {
          debugPrint('✅ [FCM] Monthly token refresh completed');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ [FCM] Monthly token refresh failed: $e');
      }
    }
  }
  
  /// Perform automatic recovery check
  Future<void> _performAutoRecovery() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;
      
      // Check if token is properly saved
      final isVerified = await verifyTokenSaved();
      
      if (!isVerified) {
        if (kDebugMode) {
          debugPrint('🔄 Auto-recovery: Token not verified, attempting registration');
        }
        
        // Attempt registration
        final success = await registerTokenAfterAuth();
        
        if (success) {
          _stats['fallback_recoveries'] = (_stats['fallback_recoveries'] as int) + 1;
          
          if (kDebugMode) {
            debugPrint('✅ Auto-recovery successful');
          }
        }
      }
      
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Auto-recovery failed: $e');
      }
    }
  }
  
  /// Comprehensive token health check for production monitoring
  Future<Map<String, dynamic>> performHealthCheck() async {
    final healthData = <String, dynamic>{};
    
    try {
      final userId = _supabase.auth.currentUser?.id;
      healthData['user_authenticated'] = userId != null;
      
      if (userId != null) {
        // Check FCM service health
        healthData['fcm_service_available'] = _fcmService.isAvailable;
        healthData['fcm_token_available'] = _fcmService.fcmToken != null;
        
        // Check Supabase connectivity
        final tokens = await _repository.getActiveFcmTokens(userId);
        healthData['supabase_accessible'] = true;
        healthData['tokens_in_database'] = tokens.length;
        
        // Check if current token is saved
        final currentToken = _fcmService.fcmToken;
        if (currentToken != null) {
          healthData['current_token_saved'] = tokens.any((t) => t.token == currentToken);
        }
        
        // Check repository table health
        final tableHealth = await _repository.verifyFcmTokenTable();
        healthData['table_health'] = tableHealth;
        
      }
      
      // Add service stats
      healthData['service_stats'] = getProductionStats();
      healthData['timestamp'] = DateTime.now().toIso8601String();
      healthData['health_status'] = 'healthy';
      
    } catch (e) {
      healthData['health_status'] = 'unhealthy';
      healthData['error'] = e.toString();
      healthData['timestamp'] = DateTime.now().toIso8601String();
    }
    
    return healthData;
  }
  
  /// Firebase 2025 Best Practice: Deactivate token on logout
  /// Instead of deleting, we set is_active = false
  /// This allows reactivation if user logs back in on same device
  Future<bool> deactivateTokenOnLogout() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        if (kDebugMode) {
          debugPrint('⚠️ [FCM] No user to deactivate token for');
        }
        return false;
      }

      if (kDebugMode) {
        debugPrint('🔒 [FCM] Deactivating FCM token on logout...');
      }

      // Deactivate the current token in database
      final success = await _repository.deactivateToken(
        userId: userId,
        token: _currentToken,
      );

      if (success) {
        // Clear local state
        _lastRegisteredToken = null;
        _lastRegisteredUserId = null;
        _stats['logout_deactivations'] = (_stats['logout_deactivations'] as int) + 1;

        if (kDebugMode) {
          debugPrint('✅ [FCM] Token deactivated on logout');
        }
      }

      // Cancel monthly refresh timer
      _monthlyRefreshTimer?.cancel();
      _monthlyRefreshTimer = null;
      _lastMonthlyRefresh = null;

      return success;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ [FCM] Token deactivation failed: $e');
      }
      return false;
    }
  }

  /// Production-safe token registration with comprehensive error handling
  Future<bool> productionSafeRegister() async {
    try {
      // Step 1: Validate prerequisites
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        if (kDebugMode) debugPrint('⚠️ No authenticated user for token registration');
        return false;
      }
      
      // Step 2: Ensure FCM service is properly initialized
      if (!_fcmService.isAvailable) {
        if (kDebugMode) debugPrint('⚠️ FCM service not available');
        return false;
      }
      
      // Step 3: Get or refresh token if needed
      String? token = _fcmService.fcmToken;
      if (token == null) {
        await _performTokenRefresh();
        token = _fcmService.fcmToken;
      }
      
      if (token == null) {
        if (kDebugMode) debugPrint('⚠️ Unable to obtain FCM token');
        return false;
      }
      
      // Step 4: Check if already registered
      final existingTokens = await _repository.getActiveFcmTokens(userId);
      if (existingTokens.any((t) => t.token == token)) {
        if (kDebugMode) debugPrint('✅ Token already registered');
        return true;
      }
      
      // Step 5: Register token with production-safe approach
      final result = await _repository.storeOrUpdateFcmToken(
        userId: userId,
        token: token,
        platform: Platform.isIOS ? 'ios' : 'android',
        deviceId: 'prod_device_${DateTime.now().millisecondsSinceEpoch}',
        deviceModel: Platform.operatingSystem,
        appVersion: '1.0.0',
      );
      
      // Step 6: Validate result
      if (result != null && (result.id?.startsWith('fallback_') ?? true) == false) {
        _currentToken = token;
        _lastRegisteredToken = token;
        _stats['successful_registrations'] = (_stats['successful_registrations'] as int) + 1;
        
        if (kDebugMode) {
          debugPrint('✅ Production token registration successful: ${result.id}');
        }
        
        return true;
      } else {
        if (kDebugMode) {
          debugPrint('⚠️ Token registration returned fallback result');
        }
        return false;
      }
      
    } catch (e) {
      _stats['failed_registrations'] = (_stats['failed_registrations'] as int) + 1;
      
      if (kDebugMode) {
        debugPrint('❌ Production token registration failed: $e');
      }
      
      return false;
    }
  }
}