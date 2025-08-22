import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../repositories/notification_repository.dart';
import 'fcm_service.dart';

/// Manages FCM token lifecycle and automatic updates
class TokenManager {
  static final TokenManager _instance = TokenManager._internal();
  factory TokenManager() => _instance;
  TokenManager._internal();

  final _fcmService = FcmService();
  final _repository = NotificationRepository();
  final _supabase = Supabase.instance.client;
  
  Timer? _refreshTimer;
  String? _lastSavedToken;
  DateTime? _lastTokenUpdate;
  
  static const Duration _tokenRefreshInterval = Duration(hours: 24);
  static const String _lastTokenKey = 'last_fcm_token';
  static const String _lastTokenUpdateKey = 'last_fcm_token_update';
  
  /// Initialize token manager and start automatic management
  Future<void> initialize() async {
    debugPrint('🔄 TokenManager: Initializing...');
    
    // Load last saved token info
    await _loadLastTokenInfo();
    
    // Check and update token on startup
    await _checkAndUpdateToken();
    
    // Start periodic refresh timer
    _startPeriodicRefresh();
    
    // Listen to auth state changes
    _listenToAuthChanges();
  }
  
  /// Load last saved token information from local storage
  Future<void> _loadLastTokenInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _lastSavedToken = prefs.getString(_lastTokenKey);
      final lastUpdateMillis = prefs.getInt(_lastTokenUpdateKey);
      if (lastUpdateMillis != null) {
        _lastTokenUpdate = DateTime.fromMillisecondsSinceEpoch(lastUpdateMillis);
      }
      
      debugPrint('📱 Last token update: $_lastTokenUpdate');
    } catch (e) {
      debugPrint('❌ Error loading token info: $e');
    }
  }
  
  /// Save token information to local storage
  Future<void> _saveTokenInfo(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_lastTokenKey, token);
      await prefs.setInt(_lastTokenUpdateKey, DateTime.now().millisecondsSinceEpoch);
      _lastSavedToken = token;
      _lastTokenUpdate = DateTime.now();
    } catch (e) {
      debugPrint('❌ Error saving token info: $e');
    }
  }
  
  /// Check if token needs update and update if necessary
  Future<void> _checkAndUpdateToken({bool force = false}) async {
    try {
      final currentToken = _fcmService.fcmToken;
      final userId = _supabase.auth.currentUser?.id;
      
      if (currentToken == null || userId == null) {
        debugPrint('⚠️ TokenManager: No token or user not authenticated');
        return;
      }
      
      // Check if token needs update
      bool needsUpdate = force ||
          _lastSavedToken != currentToken ||
          _shouldRefreshByTime();
      
      if (needsUpdate) {
        debugPrint('🔄 TokenManager: Updating token...');
        await _updateTokenInSupabase(currentToken, userId);
      } else {
        debugPrint('✅ TokenManager: Token is up to date');
      }
    } catch (e) {
      debugPrint('❌ TokenManager: Error checking token: $e');
    }
  }
  
  /// Check if token should be refreshed based on time
  bool _shouldRefreshByTime() {
    if (_lastTokenUpdate == null) return true;
    
    final timeSinceLastUpdate = DateTime.now().difference(_lastTokenUpdate!);
    return timeSinceLastUpdate > _tokenRefreshInterval;
  }
  
  /// Update token in Supabase
  Future<void> _updateTokenInSupabase(String token, String userId) async {
    try {
      // Determine platform
      String platform = 'web';
      if (Platform.isIOS) platform = 'ios';
      else if (Platform.isAndroid) platform = 'android';
      
      // Get device info
      final deviceId = 'device_${DateTime.now().millisecondsSinceEpoch}';
      final deviceModel = Platform.operatingSystem;
      
      // Store or update token
      final result = await _repository.storeOrUpdateFcmToken(
        userId: userId,
        token: token,
        platform: platform,
        deviceId: deviceId,
        deviceModel: deviceModel,
        appVersion: '1.0.0',
      );
      
      if (result != null) {
        debugPrint('✅ TokenManager: Token updated in Supabase');
        await _saveTokenInfo(token);
      } else {
        debugPrint('❌ TokenManager: Failed to update token in Supabase');
      }
    } catch (e) {
      debugPrint('❌ TokenManager: Error updating token: $e');
    }
  }
  
  /// Start periodic token refresh
  void _startPeriodicRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(_tokenRefreshInterval, (_) {
      debugPrint('⏰ TokenManager: Periodic refresh triggered');
      _checkAndUpdateToken();
    });
  }
  
  /// Listen to authentication state changes
  void _listenToAuthChanges() {
    _supabase.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      debugPrint('🔐 TokenManager: Auth event - $event');
      
      switch (event) {
        case AuthChangeEvent.signedIn:
        case AuthChangeEvent.tokenRefreshed:
          // Update token when user signs in or token refreshes
          Future.delayed(const Duration(seconds: 2), () {
            _checkAndUpdateToken(force: true);
          });
          break;
        case AuthChangeEvent.signedOut:
          // Clear token info on logout
          _clearTokenInfo();
          break;
        default:
          break;
      }
    });
  }
  
  /// Clear token information on logout
  Future<void> _clearTokenInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_lastTokenKey);
      await prefs.remove(_lastTokenUpdateKey);
      _lastSavedToken = null;
      _lastTokenUpdate = null;
      debugPrint('🧹 TokenManager: Token info cleared');
    } catch (e) {
      debugPrint('❌ Error clearing token info: $e');
    }
  }
  
  /// Handle app lifecycle state changes
  void handleAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        // App came to foreground - check token
        debugPrint('📱 TokenManager: App resumed - checking token');
        _checkAndUpdateToken();
        break;
      case AppLifecycleState.paused:
        // App went to background
        debugPrint('📱 TokenManager: App paused');
        break;
      default:
        break;
    }
  }
  
  /// Force token refresh (for manual refresh)
  Future<void> forceRefresh() async {
    debugPrint('🔄 TokenManager: Force refresh requested');
    
    try {
      // Delete old token
      await _fcmService.deleteToken();
      
      // Wait a moment
      await Future.delayed(const Duration(seconds: 1));
      
      // Reinitialize FCM service
      await _fcmService.initialize();
      
      // Update token
      await _checkAndUpdateToken(force: true);
    } catch (e) {
      debugPrint('❌ TokenManager: Force refresh failed: $e');
    }
  }
  
  /// Get token status information
  Map<String, dynamic> getTokenStatus() {
    final currentToken = _fcmService.fcmToken;
    final isTokenFresh = !_shouldRefreshByTime();
    
    return {
      'current_token': currentToken,
      'last_saved_token': _lastSavedToken,
      'tokens_match': currentToken == _lastSavedToken,
      'last_update': _lastTokenUpdate?.toIso8601String(),
      'is_fresh': isTokenFresh,
      'needs_refresh': !isTokenFresh || currentToken != _lastSavedToken,
    };
  }
  
  /// Dispose resources
  void dispose() {
    _refreshTimer?.cancel();
  }
}