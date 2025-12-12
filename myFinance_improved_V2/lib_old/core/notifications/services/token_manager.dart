import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../repositories/notification_repository.dart';
import 'fcm_service.dart';

/// Enhanced FCM Token Manager with best practices
/// Implements: Immediate registration, retry logic, deduplication, monitoring
class TokenManager {
  static final TokenManager _instance = TokenManager._internal();
  factory TokenManager() => _instance;
  TokenManager._internal();

  final _fcmService = FcmService();
  final _repository = NotificationRepository();
  final _supabase = Supabase.instance.client;
  
  // Timers and subscriptions
  Timer? _refreshTimer;
  Timer? _retryTimer;
  StreamSubscription? _connectivitySubscription;
  StreamSubscription? _authSubscription;
  
  // Token state
  String? _currentToken;
  String? _lastSavedToken;
  String? _lastTokenHash;
  DateTime? _lastTokenUpdate;
  DateTime? _lastValidation;
  
  // Retry management
  int _retryCount = 0;
  final List<_TokenUpdateRequest> _pendingUpdates = [];
  
  // Enhanced configuration
  static const Duration _tokenRefreshInterval = Duration(hours: 12); // More frequent
  static const Duration _validationInterval = Duration(hours: 6);
  static const int _maxRetries = 3;
  static const int _maxRetryDelaySeconds = 30;
  
  // Storage keys
  static const String _lastTokenKey = 'last_fcm_token';
  static const String _lastTokenHashKey = 'last_fcm_token_hash';
  static const String _lastTokenUpdateKey = 'last_fcm_token_update';
  static const String _lastValidationKey = 'last_fcm_token_validation';
  static const String _pendingUpdatesKey = 'pending_token_updates';
  
  // Monitoring
  final _TokenMonitor _monitor = _TokenMonitor();
  
  /// Initialize enhanced token manager with resilient features
  Future<void> initialize() async {
    try {
      _monitor.logEvent('initialization_started');
      
      // Load saved state including pending updates
      await _loadSavedState();
      
      // Process any pending updates from previous session
      await _processPendingUpdates();
      
      // Setup connectivity monitoring for resilient updates
      _setupConnectivityMonitoring();
      
      // Setup auth state monitoring with immediate response
      _setupEnhancedAuthMonitoring();
      
      // Validate and update token on startup
      await _validateAndUpdateToken();
      
      // Start periodic refresh with jitter to prevent thundering herd
      _startPeriodicRefreshWithJitter();
      
      _monitor.logEvent('initialization_completed', {
        'has_token': _currentToken != null,
        'pending_updates': _pendingUpdates.length,
      });
      
      // Token manager initialized (reduced logging)
    } catch (e, stack) {
      _monitor.logError('initialization_failed', e, stack);
      debugPrint('❌ Token Manager init failed: $e');
      // Don't rethrow - allow app to continue
    }
  }
  
  /// Load saved state including pending updates
  Future<void> _loadSavedState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _lastSavedToken = prefs.getString(_lastTokenKey);
      _lastTokenHash = prefs.getString(_lastTokenHashKey);
      
      final lastUpdateMillis = prefs.getInt(_lastTokenUpdateKey);
      if (lastUpdateMillis != null) {
        _lastTokenUpdate = DateTime.fromMillisecondsSinceEpoch(lastUpdateMillis);
      }
      
      final lastValidationMillis = prefs.getInt(_lastValidationKey);
      if (lastValidationMillis != null) {
        _lastValidation = DateTime.fromMillisecondsSinceEpoch(lastValidationMillis);
      }
      
      // Load pending updates
      final pendingJson = prefs.getString(_pendingUpdatesKey);
      if (pendingJson != null) {
        final List<dynamic> pending = jsonDecode(pendingJson);
        _pendingUpdates.clear();
        _pendingUpdates.addAll(
          pending.map((p) => _TokenUpdateRequest.fromJson(p)).toList(),
        );
      }
      
      _monitor.logEvent('state_loaded', {
        'has_token': _lastSavedToken != null,
        'pending': _pendingUpdates.length,
      });
    } catch (e, stack) {
      _monitor.logError('state_load_failed', e, stack);
    }
  }
  
  /// Save complete state to persistent storage
  Future<void> _saveState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      if (_lastSavedToken != null) {
        await prefs.setString(_lastTokenKey, _lastSavedToken!);
      }
      
      if (_lastTokenHash != null) {
        await prefs.setString(_lastTokenHashKey, _lastTokenHash!);
      }
      
      if (_lastTokenUpdate != null) {
        await prefs.setInt(_lastTokenUpdateKey, _lastTokenUpdate!.millisecondsSinceEpoch);
      }
      
      if (_lastValidation != null) {
        await prefs.setInt(_lastValidationKey, _lastValidation!.millisecondsSinceEpoch);
      }
      
      // Save pending updates
      if (_pendingUpdates.isNotEmpty) {
        final pendingJson = jsonEncode(
          _pendingUpdates.map((u) => u.toJson()).toList(),
        );
        await prefs.setString(_pendingUpdatesKey, pendingJson);
      } else {
        await prefs.remove(_pendingUpdatesKey);
      }
    } catch (e, stack) {
      _monitor.logError('state_save_failed', e, stack);
    }
  }
  
  /// Setup connectivity monitoring for resilient token updates
  void _setupConnectivityMonitoring() {
    _connectivitySubscription?.cancel();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(
      (List<ConnectivityResult> results) {
        // Check if any of the results indicate connectivity
        final hasConnection = results.isNotEmpty && 
            !results.every((result) => result == ConnectivityResult.none);
        
        if (hasConnection) {
          // Network available - process pending updates
          _processPendingUpdates();
        }
      },
    );
  }
  
  /// Setup enhanced auth state monitoring with immediate token registration
  void _setupEnhancedAuthMonitoring() {
    _authSubscription?.cancel();
    _authSubscription = _supabase.auth.onAuthStateChange.listen(
      (data) async {
        final event = data.event;
        
        switch (event) {
          case AuthChangeEvent.signedIn:
            // IMMEDIATE token registration (< 100ms target)
            _monitor.logEvent('auth_signed_in');
            await _immediateTokenRegistration();
            break;
            
          case AuthChangeEvent.tokenRefreshed:
            _monitor.logEvent('auth_token_refreshed');
            await _validateAndUpdateToken();
            break;
            
          case AuthChangeEvent.signedOut:
            _monitor.logEvent('auth_signed_out');
            await _clearTokenInfo();
            break;
            
          default:
            break;
        }
      },
    );
  }
  
  /// Immediate token registration after authentication (Best Practice #1)
  Future<void> _immediateTokenRegistration() async {
    final stopwatch = Stopwatch()..start();
    
    try {
      // Get current FCM token
      _currentToken = _fcmService.fcmToken;
      
      if (_currentToken == null) {
        // Try to get token if not available
        await _fcmService.initialize();
        _currentToken = _fcmService.fcmToken;
      }
      
      if (_currentToken != null) {
        // Update immediately without waiting
        await _updateTokenWithRetry(_currentToken!, immediate: true);
      }
      
      stopwatch.stop();
      _monitor.logEvent('immediate_registration', {
        'duration_ms': stopwatch.elapsedMilliseconds,
        'success': _currentToken != null,
      });
      
      if (kDebugMode && stopwatch.elapsedMilliseconds > 1000) {
        debugPrint('⚡ Token registered in ${stopwatch.elapsedMilliseconds}ms');
      }
    } catch (e, stack) {
      stopwatch.stop();
      _monitor.logError('immediate_registration_failed', e, stack);
      
      // Queue for retry
      if (_currentToken != null) {
        _queueTokenUpdate(_currentToken!);
      }
    }
  }
  
  /// Validate current token and update if necessary
  Future<void> _validateAndUpdateToken() async {
    try {
      // Check if validation is needed
      if (!_shouldValidate()) {
        return;
      }
      
      _monitor.logEvent('token_validation_started');
      
      // Get current token from FCM
      _currentToken = _fcmService.fcmToken;
      
      if (_currentToken == null) {
        _monitor.logEvent('token_null_reinitializing');
        // Token is null, try to reinitialize
        await _fcmService.initialize();
        _currentToken = _fcmService.fcmToken;
      }
      
      // Check if token has changed or needs refresh
      if (_shouldUpdateToken()) {
        await _updateTokenWithRetry(_currentToken!);
      }
      
      _lastValidation = DateTime.now();
      await _saveState();
      
      _monitor.logEvent('token_validation_completed', {
        'token_changed': _currentToken != _lastSavedToken,
        'token_updated': _shouldUpdateToken(),
      });
    } catch (e, stack) {
      _monitor.logError('token_validation_failed', e, stack);
    }
  }
  
  /// Check if validation is needed based on interval
  bool _shouldValidate() {
    if (_lastValidation == null) return true;
    
    final timeSinceValidation = DateTime.now().difference(_lastValidation!);
    return timeSinceValidation > _validationInterval;
  }
  
  /// Check if token should be updated (deduplication check)
  bool _shouldUpdateToken() {
    if (_currentToken == null) return false;
    
    // Check if token has changed using hash (Best Practice #2 - Deduplication)
    final currentHash = _generateTokenHash(_currentToken!);
    if (currentHash != _lastTokenHash) return true;
    
    // Check if refresh interval has passed
    if (_lastTokenUpdate == null) return true;
    
    final timeSinceUpdate = DateTime.now().difference(_lastTokenUpdate!);
    return timeSinceUpdate > _tokenRefreshInterval;
  }
  
  /// Generate hash for token deduplication
  String _generateTokenHash(String token) {
    final bytes = utf8.encode(token);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
  
  /// Update token with exponential backoff retry (Best Practice #3)
  Future<void> _updateTokenWithRetry(
    String token, {
    bool immediate = false,
    int retryCount = 0,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        _monitor.logEvent('update_skipped_no_user');
        return;
      }
      
      // Check for duplicate update using hash
      final tokenHash = _generateTokenHash(token);
      if (tokenHash == _lastTokenHash && !immediate) {
        _monitor.logEvent('update_skipped_duplicate');
        return;
      }
      
      // Prepare update data
      final platform = _getPlatform();
      final deviceInfo = await _getDeviceInfo();
      
      // Perform update
      final result = await _repository.storeOrUpdateFcmToken(
        userId: userId,
        token: token,
        platform: platform,
        deviceId: deviceInfo['device_id']!,
        deviceModel: deviceInfo['device_model']!,
        appVersion: deviceInfo['app_version']!,
      );
      
      if (result != null) {
        // Success - update state
        _lastSavedToken = token;
        _lastTokenHash = tokenHash;
        _lastTokenUpdate = DateTime.now();
        _currentToken = token;
        _retryCount = 0;
        
        await _saveState();
        
        _monitor.logEvent('token_update_success', {
          'immediate': immediate,
          'retry_count': retryCount,
          'token_id': result.id,
        });
        
        // Reduced logging - only log in debug mode
        if (kDebugMode) {
          debugPrint('✅ Token updated (${result.id})');
        }
      } else {
        throw Exception('Token update returned null - check if user_fcm_tokens table exists in Supabase');
      }
    } catch (e, stack) {
      _monitor.logError('token_update_failed', e, stack);
      
      // Implement exponential backoff retry
      if (retryCount < _maxRetries) {
        final delay = _calculateRetryDelay(retryCount);
        
        _monitor.logEvent('token_update_retry_scheduled', {
          'retry_count': retryCount + 1,
          'delay_seconds': delay.inSeconds,
        });
        
        debugPrint('⏳ Retrying in ${delay.inSeconds}s (attempt ${retryCount + 1}/$_maxRetries)');
        
        _retryTimer?.cancel();
        _retryTimer = Timer(delay, () {
          _updateTokenWithRetry(token, immediate: immediate, retryCount: retryCount + 1);
        });
      } else {
        // Max retries reached - queue for later
        _queueTokenUpdate(token);
        debugPrint('❌ Token update failed after $_maxRetries attempts - queued');
      }
    }
  }
  
  /// Calculate retry delay with exponential backoff and jitter
  Duration _calculateRetryDelay(int retryCount) {
    // Exponential backoff: 1s, 2s, 4s, 8s...
    final baseDelay = pow(2, retryCount).toInt();
    
    // Add jitter to prevent thundering herd
    final jitter = Random().nextInt(1000); // 0-1000ms jitter
    
    // Cap at maximum delay
    final totalDelayMs = min(baseDelay * 1000 + jitter, _maxRetryDelaySeconds * 1000);
    
    return Duration(milliseconds: totalDelayMs);
  }
  
  /// Queue token update for later processing
  void _queueTokenUpdate(String token) {
    if (token.isEmpty) return;
    
    final request = _TokenUpdateRequest(
      token: token,
      timestamp: DateTime.now(),
      attempts: 0,
    );
    
    // Avoid duplicate queued requests
    if (!_pendingUpdates.any((r) => r.token == token)) {
      _pendingUpdates.add(request);
      _saveState();
      
      _monitor.logEvent('token_update_queued', {
        'queue_size': _pendingUpdates.length,
      });
    }
  }
  
  /// Process pending token updates
  Future<void> _processPendingUpdates() async {
    if (_pendingUpdates.isEmpty) return;
    
    _monitor.logEvent('processing_pending_updates', {
      'count': _pendingUpdates.length,
    });
    
    final updates = List<_TokenUpdateRequest>.from(_pendingUpdates);
    _pendingUpdates.clear();
    
    for (final update in updates) {
      if (update.attempts < _maxRetries) {
        await _updateTokenWithRetry(
          update.token,
          retryCount: update.attempts,
        );
        
        // Wait between updates to avoid overwhelming the server
        await Future.delayed(const Duration(seconds: 1));
      }
    }
  }
  
  /// Start periodic refresh with jitter to prevent thundering herd
  void _startPeriodicRefreshWithJitter() {
    _refreshTimer?.cancel();
    
    // Add random jitter (0-60 minutes) to refresh interval
    final jitterMinutes = Random().nextInt(60);
    final refreshInterval = _tokenRefreshInterval + Duration(minutes: jitterMinutes);
    
    _monitor.logEvent('periodic_refresh_scheduled', {
      'interval_hours': refreshInterval.inHours,
      'jitter_minutes': jitterMinutes,
    });
    
    _refreshTimer = Timer.periodic(refreshInterval, (_) {
      _validateAndUpdateToken();
    });
  }
  
  /// Get platform identifier
  String _getPlatform() {
    if (Platform.isIOS) return 'ios';
    if (Platform.isAndroid) return 'android';
    if (kIsWeb) return 'web';
    return 'unknown';
  }
  
  /// Get device information
  Future<Map<String, String>> _getDeviceInfo() async {
    // In production, use device_info_plus package for real device info
    return {
      'device_id': 'device_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(9999)}',
      'device_model': '${Platform.operatingSystem}_${Platform.operatingSystemVersion}',
      'app_version': '1.0.0', // Should come from package_info_plus
    };
  }
  
  /// Public method to ensure token is registered after login
  Future<bool> ensureTokenRegistered() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return false;
      
      // Check if we have a valid token
      if (_currentToken == null) {
        await _fcmService.initialize();
        _currentToken = _fcmService.fcmToken;
      }
      
      // Check if token is registered in database
      final tokens = await _repository.getActiveFcmTokens(userId);
      final isRegistered = tokens.any((t) => t.token == _currentToken);
      
      if (!isRegistered && _currentToken != null) {
        // Register immediately
        await _immediateTokenRegistration();
        return true;
      }
      
      return isRegistered;
    } catch (e, stack) {
      _monitor.logError('ensure_token_registered_failed', e, stack);
      return false;
    }
  }
  
  /// Clear token information on logout
  Future<void> _clearTokenInfo() async {
    try {
      _currentToken = null;
      _lastSavedToken = null;
      _lastTokenHash = null;
      _lastTokenUpdate = null;
      _lastValidation = null;
      _pendingUpdates.clear();
      _retryCount = 0;
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_lastTokenKey);
      await prefs.remove(_lastTokenHashKey);
      await prefs.remove(_lastTokenUpdateKey);
      await prefs.remove(_lastValidationKey);
      await prefs.remove(_pendingUpdatesKey);
      
      _monitor.logEvent('token_data_cleared');
    } catch (e, stack) {
      _monitor.logError('token_clear_failed', e, stack);
    }
  }
  
  /// Handle app lifecycle state changes
  void handleAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _monitor.logEvent('app_resumed');
        // Validate token when app resumes
        _validateAndUpdateToken();
        // Process any pending updates
        _processPendingUpdates();
        break;
        
      case AppLifecycleState.paused:
        _monitor.logEvent('app_paused');
        // Save state when app goes to background
        _saveState();
        break;
        
      case AppLifecycleState.detached:
        _monitor.logEvent('app_detached');
        // Clean up resources
        dispose();
        break;
        
      default:
        break;
    }
  }
  
  /// Force token refresh (for manual refresh or error recovery)
  Future<void> forceRefresh() async {
    _monitor.logEvent('force_refresh_started');
    
    try {
      // Delete old token
      await _fcmService.deleteToken();
      
      // Clear saved hash to force update
      _lastTokenHash = null;
      
      // Wait briefly for token deletion
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Reinitialize FCM
      await _fcmService.initialize();
      
      // Get new token and update immediately
      _currentToken = _fcmService.fcmToken;
      
      if (_currentToken != null) {
        await _updateTokenWithRetry(_currentToken!, immediate: true);
      }
      
      _monitor.logEvent('force_refresh_completed', {
        'success': _currentToken != null,
      });
    } catch (e, stack) {
      _monitor.logError('force_refresh_failed', e, stack);
    }
  }
  
  /// Get comprehensive token status
  Map<String, dynamic> getTokenStatus() {
    final now = DateTime.now();
    
    return {
      'current_token': _currentToken,
      'fcm_token': _fcmService.fcmToken,
      'last_saved_token': _lastSavedToken,
      'tokens_match': _currentToken == _lastSavedToken,
      'last_update': _lastTokenUpdate?.toIso8601String(),
      'last_validation': _lastValidation?.toIso8601String(),
      'needs_validation': _shouldValidate(),
      'needs_update': _shouldUpdateToken(),
      'pending_updates': _pendingUpdates.length,
      'retry_count': _retryCount,
      'time_since_update': _lastTokenUpdate != null
          ? now.difference(_lastTokenUpdate!).inMinutes
          : null,
      'monitor_stats': _monitor.getStats(),
    };
  }
  
  /// Dispose resources
  void dispose() {
    _refreshTimer?.cancel();
    _retryTimer?.cancel();
    _connectivitySubscription?.cancel();
    _authSubscription?.cancel();
    _saveState();
  }
}

/// Token update request for queuing
class _TokenUpdateRequest {
  final String token;
  final DateTime timestamp;
  final int attempts;
  
  _TokenUpdateRequest({
    required this.token,
    required this.timestamp,
    this.attempts = 0,
  });
  
  Map<String, dynamic> toJson() => {
    'token': token,
    'timestamp': timestamp.toIso8601String(),
    'attempts': attempts,
  };
  
  factory _TokenUpdateRequest.fromJson(Map<String, dynamic> json) {
    return _TokenUpdateRequest(
      token: json['token'],
      timestamp: DateTime.parse(json['timestamp']),
      attempts: json['attempts'] ?? 0,
    );
  }
}

/// Token lifecycle monitoring
class _TokenMonitor {
  final Map<String, int> _eventCounts = {};
  final List<_TokenEvent> _events = [];
  final int _maxEvents = 100;
  
  void logEvent(String event, [Map<String, dynamic>? data]) {
    _eventCounts[event] = (_eventCounts[event] ?? 0) + 1;
    
    _events.add(_TokenEvent(
      name: event,
      timestamp: DateTime.now(),
      data: data,
    ));
    
    // Keep only recent events
    if (_events.length > _maxEvents) {
      _events.removeAt(0);
    }
    
    // Only log significant events to reduce console spam
    final significantEvents = [
      'initialization_completed',
      'token_update_success',
      'auth_signed_in',
      'auth_signed_out',
      'immediate_registration'
    ];
    
    if (kDebugMode && significantEvents.contains(event)) {
      debugPrint('📊 $event ${data ?? ''}');
    }
  }
  
  void logError(String event, dynamic error, StackTrace? stack) {
    logEvent('error_$event', {
      'error': error.toString(),
      'stack': kDebugMode ? stack?.toString() : null,
    });
    
    if (kDebugMode) {
      debugPrint('❌ Token Error [$event]: $error');
    }
  }
  
  Map<String, dynamic> getStats() {
    return {
      'event_counts': _eventCounts,
      'recent_events': _events.take(10).map((e) => e.toJson()).toList(),
      'total_events': _events.length,
    };
  }
}

/// Token event for monitoring
class _TokenEvent {
  final String name;
  final DateTime timestamp;
  final Map<String, dynamic>? data;
  
  _TokenEvent({
    required this.name,
    required this.timestamp,
    this.data,
  });
  
  Map<String, dynamic> toJson() => {
    'name': name,
    'timestamp': timestamp.toIso8601String(),
    'data': data,
  };
}