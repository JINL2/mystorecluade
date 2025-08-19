import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import '../config/notification_config.dart';
import '../models/notification_payload.dart';

/// Service for managing Firebase Cloud Messaging
class FcmService {
  static final FcmService _instance = FcmService._internal();
  factory FcmService() => _instance;
  FcmService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final Logger _logger = Logger();
  
  String? _fcmToken;
  String? _apnsToken;
  
  /// Initialize FCM service
  Future<void> initialize() async {
    try {
      if (NotificationConfig.debugMode) {
        _logger.d('🔥 Initializing FCM Service...');
      }
      
      // Request permissions
      final settings = await _requestPermissions();
      
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        _logger.i('✅ Notification permissions granted');
        
        // Get tokens
        await _getTokens();
        
        // Set up token refresh listener
        _setupTokenRefreshListener();
        
        // Configure message handlers
        await _configureMessageHandlers();
        
        if (NotificationConfig.debugMode) {
          _printDebugInfo();
        }
      } else {
        _logger.w('❌ Notification permissions denied');
      }
    } catch (e, stackTrace) {
      _logger.e('Failed to initialize FCM', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
  
  /// Request notification permissions
  Future<NotificationSettings> _requestPermissions() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    
    _logger.d('Permission status: ${settings.authorizationStatus}');
    return settings;
  }
  
  /// Get FCM and APNs tokens
  Future<void> _getTokens() async {
    try {
      // Get APNs token first (iOS only)
      if (Platform.isIOS) {
        _apnsToken = await _messaging.getAPNSToken();
        _logger.d('📱 APNs Token: $_apnsToken');
        
        if (_apnsToken == null) {
          _logger.w('⚠️ APNs token is null - waiting for registration');
          // Wait a bit for APNs registration
          await Future.delayed(const Duration(seconds: 2));
          _apnsToken = await _messaging.getAPNSToken();
        }
      }
      
      // Get FCM token
      _fcmToken = await _messaging.getToken();
      _logger.i('🔑 FCM Token: $_fcmToken');
      
      if (_fcmToken == null) {
        throw Exception('Failed to get FCM token');
      }
      
      // Detect environment
      _detectEnvironment();
      
    } catch (e) {
      _logger.e('Failed to get tokens', error: e);
      rethrow;
    }
  }
  
  /// Detect if we're in development or production environment
  void _detectEnvironment() {
    final bool isProduction = const bool.fromEnvironment('dart.vm.product');
    final bool isProfileMode = const bool.fromEnvironment('dart.vm.profile');
    
    String environment = 'unknown';
    if (isProduction) {
      environment = 'production';
    } else if (isProfileMode) {
      environment = 'profile';
    } else if (kDebugMode) {
      environment = 'debug';
    }
    
    _logger.i('🌍 Environment: $environment');
    _logger.i('📦 Package: ${kReleaseMode ? "Release" : "Debug"}');
    
    // Check for TestFlight/App Store
    if (Platform.isIOS) {
      _checkIosDistribution();
    }
  }
  
  /// Check iOS distribution method
  void _checkIosDistribution() {
    // Check for TestFlight
    final isTestFlight = Platform.environment['TESTFLIGHT'] == '1';
    final receiptUrl = Platform.environment['RECEIPT_URL'];
    
    if (isTestFlight || receiptUrl?.contains('sandbox') == true) {
      _logger.w('📲 Running on TestFlight (Production environment required)');
    } else if (receiptUrl?.contains('buy') == true) {
      _logger.i('🏪 Running on App Store');
    } else {
      _logger.d('🔨 Running in Development');
    }
  }
  
  /// Set up token refresh listener
  void _setupTokenRefreshListener() {
    _messaging.onTokenRefresh.listen((newToken) {
      _logger.i('🔄 FCM Token refreshed: $newToken');
      _fcmToken = newToken;
      // TODO: Update token in Supabase
      _updateTokenInBackend(newToken);
    }).onError((err) {
      _logger.e('Token refresh error', error: err);
    });
  }
  
  /// Configure message handlers
  Future<void> _configureMessageHandlers() async {
    // Foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    
    // Background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    
    // Message opened app
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
    
    // Check if app was opened from a notification
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleInitialMessage(initialMessage);
    }
  }
  
  /// Handle foreground messages
  void _handleForegroundMessage(RemoteMessage message) {
    _logger.d('📬 Foreground message received:');
    _logMessage(message);
    
    // TODO: Show local notification
    // TODO: Update app state
  }
  
  /// Handle when notification opens the app
  void _handleMessageOpenedApp(RemoteMessage message) {
    _logger.d('📱 App opened from notification:');
    _logMessage(message);
    
    // TODO: Navigate to appropriate screen
    // TODO: Track analytics
  }
  
  /// Handle initial message when app launches from notification
  void _handleInitialMessage(RemoteMessage message) {
    _logger.d('🚀 App launched from notification:');
    _logMessage(message);
    
    // TODO: Set initial route based on notification
  }
  
  /// Log message details for debugging
  void _logMessage(RemoteMessage message) {
    _logger.d('Message ID: ${message.messageId}');
    _logger.d('Title: ${message.notification?.title}');
    _logger.d('Body: ${message.notification?.body}');
    _logger.d('Data: ${message.data}');
    _logger.d('Category: ${message.category}');
    _logger.d('CollapseKey: ${message.collapseKey}');
    _logger.d('From: ${message.from}');
    _logger.d('SentTime: ${message.sentTime}');
  }
  
  /// Update token in backend (Supabase)
  Future<void> _updateTokenInBackend(String token) async {
    try {
      // TODO: Implement Supabase update
      _logger.d('📤 Updating token in Supabase...');
    } catch (e) {
      _logger.e('Failed to update token in backend', error: e);
    }
  }
  
  /// Print debug information
  void _printDebugInfo() {
    _logger.d('''
╔════════════════════════════════════════╗
║          FCM DEBUG INFORMATION         ║
╠════════════════════════════════════════╣
║ FCM Token: ${_fcmToken?.substring(0, 20)}...
║ APNs Token: ${_apnsToken?.substring(0, 20) ?? 'N/A'}...
║ Platform: ${Platform.operatingSystem}
║ Debug Mode: ${kDebugMode}
║ Release Mode: ${kReleaseMode}
║ Profile Mode: ${kProfileMode}
╚════════════════════════════════════════╝
    ''');
  }
  
  /// Send test notification (for debugging)
  Future<void> sendTestNotification() async {
    _logger.d('📤 Sending test notification...');
    // This would typically be done from your backend
    // but we can trigger a local notification for testing
  }
  
  /// Get current FCM token
  String? get fcmToken => _fcmToken;
  
  /// Get current APNs token (iOS only)
  String? get apnsToken => _apnsToken;
  
  /// Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
    _logger.d('📌 Subscribed to topic: $topic');
  }
  
  /// Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
    _logger.d('📌 Unsubscribed from topic: $topic');
  }
  
  /// Delete token (logout)
  Future<void> deleteToken() async {
    await _messaging.deleteToken();
    _fcmToken = null;
    _apnsToken = null;
    _logger.d('🗑️ FCM token deleted');
  }
}

/// Top-level function for background message handling
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('🔕 Background message received: ${message.messageId}');
  // Handle background message
}