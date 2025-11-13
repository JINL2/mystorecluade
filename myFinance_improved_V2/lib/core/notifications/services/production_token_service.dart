import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../repositories/notification_repository.dart';
import 'fcm_service.dart';

/// Production-safe FCM token management service
/// Handles race conditions, initialization timing, and reliable token saving
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
  String? _currentToken;
  String? _lastRegisteredToken;
  final List<Completer<bool>> _pendingRegistrations = [];
  
  // Production monitoring
  final Map<String, dynamic> _stats = {
    'successful_registrations': 0,
    'failed_registrations': 0,
    'race_conditions_handled': 0,
    'fallback_recoveries': 0,
  };
  
  /// Initialize the service - called once at app start
  Future<void> initialize() async {
    if (_isInitialized || _isInitializing) return;
    
    _isInitializing = true;
    
    try {
      // Wait for FCM service to be ready
      await _waitForFcmServiceReady();
      
      // Get current token
      _currentToken = _fcmService.fcmToken;
      
      // Set up auth state monitoring
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
      
      // Complete pending registrations with failure
      _completePendingRegistrations(success: false);
      
      if (kDebugMode) {
        debugPrint('❌ ProductionTokenService initialization failed: $e');
      }
    }
  }
  
  /// Wait for FCM service to be ready with timeout
  Future<void> _waitForFcmServiceReady() async {
    const maxAttempts = 10;
    const delayBetweenAttempts = Duration(milliseconds: 200);
    
    for (int attempt = 0; attempt < maxAttempts; attempt++) {
      try {
        await _fcmService.initialize();
        
        // Check if token is available
        if (_fcmService.fcmToken != null) {
          return;
        }
        
        // Token not ready yet, wait a bit
        if (attempt < maxAttempts - 1) {
          await Future.delayed(delayBetweenAttempts);
        }
      } catch (e) {
        if (attempt == maxAttempts - 1) rethrow;
        await Future.delayed(delayBetweenAttempts);
      }
    }
  }
  
  /// Set up auth state monitoring for automatic token registration
  void _setupAuthStateMonitoring() {
    _supabase.auth.onAuthStateChange.listen((data) async {
      if (data.event == AuthChangeEvent.signedIn) {
        // User signed in - immediately register token
        await registerTokenAfterAuth();
      }
    });
  }
  
  /// Register token immediately after authentication - production-safe
  Future<bool> registerTokenAfterAuth() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return false;
      
      // Use the debug page's successful pattern
      return await _executeReliableTokenRegistration(userId);
      
    } catch (e) {
      _stats['failed_registrations'] = (_stats['failed_registrations'] as int) + 1;
      
      if (kDebugMode) {
        debugPrint('❌ Token registration after auth failed: $e');
      }
      
      // Schedule background retry
      _scheduleBackgroundRetry();
      return false;
    }
  }
  
  /// Execute reliable token registration using debug page pattern
  Future<bool> _executeReliableTokenRegistration(String userId) async {
    try {
      // Step 1: Ensure FCM service is ready
      if (!_fcmService.isAvailable) {
        await _fcmService.initialize();
      }
      
      // Step 2: Get current token (similar to debug page approach)
      String? token = _fcmService.fcmToken;
      
      // Step 3: If no token, try refresh approach from debug page
      if (token == null) {
        // Use debug page's successful refresh pattern
        await _performTokenRefreshLikeDebugPage();
        token = _fcmService.fcmToken;
      }
      
      if (token == null) {
        throw Exception('Unable to obtain FCM token after refresh');
      }
      
      // Step 4: Check if token is already registered
      final existingTokens = await _repository.getActiveFcmTokens(userId);
      final alreadyRegistered = existingTokens.any((t) => t.token == token);
      
      if (alreadyRegistered) {
        _lastRegisteredToken = token;
        _currentToken = token;
        return true;
      }
      
      // Step 5: Store token using debug page's successful approach
      final result = await _repository.storeOrUpdateFcmToken(
        userId: userId,
        token: token,
        platform: Platform.isIOS ? 'ios' : 'android',
        deviceId: 'device_${DateTime.now().millisecondsSinceEpoch}',
        deviceModel: Platform.operatingSystem,
        appVersion: '1.0.0',
      );
      
      if (result != null && result.id != 'fallback_') {
        // Success - update our state
        _lastRegisteredToken = token;
        _currentToken = token;
        _stats['successful_registrations'] = (_stats['successful_registrations'] as int) + 1;
        
        if (kDebugMode) {
          debugPrint('✅ Token registered successfully in production: ${result.id}');
        }
        
        return true;
      } else {
        throw Exception('Token storage returned fallback result - indicates Supabase save failure');
      }
      
    } catch (e) {
      _stats['failed_registrations'] = (_stats['failed_registrations'] as int) + 1;
      
      if (kDebugMode) {
        debugPrint('❌ Reliable token registration failed: $e');
      }
      
      rethrow;
    }
  }
  
  /// Perform token refresh using the debug page's successful pattern
  Future<void> _performTokenRefreshLikeDebugPage() async {
    try {
      // Debug page pattern: delete -> wait -> reinitialize -> get new token
      
      // Step 1: Delete current token (from debug page line 265)
      await _fcmService.deleteToken();
      
      // Step 2: Wait briefly (from debug page line 268)
      await Future.delayed(const Duration(seconds: 1));
      
      // Step 3: Reinitialize FCM service (from debug page line 271)
      await _fcmService.initialize();
      
      // Step 4: Token should now be available
      _currentToken = _fcmService.fcmToken;
      
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Token refresh pattern failed: $e');
      }
      rethrow;
    }
  }
  
  /// Register token for login - handles race conditions
  Future<bool> registerTokenForLogin() async {
    // If service is not initialized yet, queue the registration
    if (!_isInitialized) {
      if (_isInitializing) {
        // Service is initializing - wait for completion
        final completer = Completer<bool>();
        _pendingRegistrations.add(completer);
        _stats['race_conditions_handled'] = (_stats['race_conditions_handled'] as int) + 1;
        
        if (kDebugMode) {
          debugPrint('⚠️ Token registration queued - service initializing');
        }
        
        return completer.future;
      } else {
        // Service not started - initialize now
        await initialize();
      }
    }
    
    // Service ready - proceed with registration
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
      
      // Use debug page's proven refresh pattern
      await _performTokenRefreshLikeDebugPage();
      
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
  void startAutoRecoverySystem() {
    // Run token validation every 30 minutes in production
    Timer.periodic(const Duration(minutes: 30), (timer) async {
      await _performAutoRecovery();
    });
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
      
      // Step 3: Get or refresh token using debug page pattern if needed
      String? token = _fcmService.fcmToken;
      if (token == null) {
        await _performTokenRefreshLikeDebugPage();
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