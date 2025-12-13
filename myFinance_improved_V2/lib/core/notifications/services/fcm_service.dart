import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// import 'package:logger/logger.dart';
import '../config/notification_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../repositories/notification_repository.dart';

/// Service for managing Firebase Cloud Messaging
class FcmService {
  static final FcmService _instance = FcmService._internal();
  factory FcmService() => _instance;
  FcmService._internal();

  FirebaseMessaging? _messaging;
  // final Logger _logger = Logger();
  bool _isAvailable = false;
  
  String? _fcmToken;
  String? _apnsToken;
  
  /// Initialize FCM service
  Future<void> initialize() async {
    try {
      // Check if Firebase is available
      if (Firebase.apps.isEmpty) {
        // Firebase not initialized - FCM service unavailable
        _isAvailable = false;
        return;
      }
      
      // Initialize Firebase Messaging
      _messaging = FirebaseMessaging.instance;
      _isAvailable = true;
      
      // Initialize FCM Service
      
      // Request permissions
      final settings = await _requestPermissions();
      
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        // Notification permissions granted
        
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
        // Notification permissions denied
      }
    } catch (e) {
      // Failed to initialize FCM
      rethrow;
    }
  }
  
  /// Request notification permissions
  Future<NotificationSettings> _requestPermissions() async {
    if (_messaging == null) {
      throw Exception('Firebase Messaging not available');
    }
    final settings = await _messaging!.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    
    // Permission status: ${settings.authorizationStatus}
    return settings;
  }
  
  /// Get FCM and APNs tokens
  Future<void> _getTokens() async {
    try {
      // Get APNs token first (iOS only) - skip on simulator
      if (Platform.isIOS && !kDebugMode) {
        try {
          _apnsToken = await _messaging?.getAPNSToken();
          // APNs Token obtained
          
          if (_apnsToken == null) {
            // APNs token pending registration
            // Wait a bit for APNs registration
            await Future.delayed(const Duration(seconds: 2));
            _apnsToken = await _messaging?.getAPNSToken();
          }
        } catch (e) {
          // APNs token unavailable on simulator
        }
      } else if (Platform.isIOS && kDebugMode) {
        // Simulator detected - APNs token not available
      }
      
      // Get FCM token
      try {
        _fcmToken = await _messaging?.getToken();
      } catch (e) {
        // FCM token unavailable on simulator
        // On simulator, we can't get real tokens, but we can continue
        _fcmToken = 'simulator-token-${DateTime.now().millisecondsSinceEpoch}';
      }
      // FCM Token obtained
      
      if (_fcmToken == null) {
        throw Exception('Failed to get FCM token');
      }
      
      // Detect environment
      _detectEnvironment();
      
    } catch (e) {
      // Failed to get tokens
      rethrow;
    }
  }
  
  /// Detect if we're in development or production environment
  void _detectEnvironment() {
    const bool isProduction = bool.fromEnvironment('dart.vm.product');
    const bool isProfileMode = bool.fromEnvironment('dart.vm.profile');
    
    if (isProduction) {
      // production
    } else if (isProfileMode) {
      // profile
    } else if (kDebugMode) {
      // debug
    }
    
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
      // Running on TestFlight
    } else if (receiptUrl?.contains('buy') == true) {
      // Running on App Store
    } else {
      // Running in Development
    }
  }
  
  /// Set up token refresh listener
  void _setupTokenRefreshListener() {
    _messaging?.onTokenRefresh.listen((newToken) {
      // FCM Token refreshed
      _fcmToken = newToken;
      _updateTokenInBackend(newToken);
    }).onError((err) {
      // Token refresh error
    });
  }
  
  /// Configure message handlers
  Future<void> _configureMessageHandlers() async {
    // CRITICAL: Configure iOS to NOT show notifications when app is in foreground
    // This prevents the annoying notification banner from appearing
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: false,  // Don't show the notification banner
      badge: true,   // Update the badge counter
      sound: false,  // Don't play sound
    );
    // Foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    
    // Background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    
    // Message opened app
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
    
    // Check if app was opened from a notification
    final initialMessage = await _messaging?.getInitialMessage();
    if (initialMessage != null) {
      _handleInitialMessage(initialMessage);
    }
  }
  
  /// Handle foreground messages
  void _handleForegroundMessage(RemoteMessage message) {
    // Foreground message received
    
    // Handle foreground message - implementation pending
  }
  
  /// Handle when notification opens the app
  void _handleMessageOpenedApp(RemoteMessage message) {
    // App opened from notification
    
    // Handle notification navigation - implementation pending
  }
  
  /// Handle initial message when app launches from notification
  void _handleInitialMessage(RemoteMessage message) {
    // App launched from notification
    
    // Handle initial navigation - implementation pending
  }
  
  
  /// Update token in backend (Supabase)
  Future<void> _updateTokenInBackend(String token) async {
    try {
      // Token refresh detected
      
      // Import required dependencies
      final supabase = Supabase.instance.client;
      final userId = supabase.auth.currentUser?.id;
      
      if (userId == null) {
        return;
      }
      
      // Update token in database using repository
      final repository = NotificationRepository();
      final result = await repository.storeOrUpdateFcmToken(
        userId: userId,
        token: token,
        platform: Platform.operatingSystem,
        deviceId: 'device_${DateTime.now().millisecondsSinceEpoch}',
        deviceModel: Platform.operatingSystem,
        appVersion: '1.0.0',
      );
      
      if (result != null) {
      } else {
      }
    } catch (e) {
      // Failed to update token in backend
    }
  }
  
  /// Print debug information
  void _printDebugInfo() {
    // Debug info available in debugMode only
  }
  
  /// Send test notification (for debugging)
  Future<void> sendTestNotification() async {
    // Test notification handled by NotificationService
  }
  
  /// Get current FCM token
  String? get fcmToken => _fcmToken;
  
  /// Get current APNs token (iOS only)
  String? get apnsToken => _apnsToken;
  
  /// Check if FCM service is available
  bool get isAvailable => _isAvailable;
  
  /// Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    if (_messaging == null) {
      // Cannot subscribe to topic - Firebase not available
      return;
    }
    await _messaging!.subscribeToTopic(topic);
    // Subscribed to topic: $topic
  }
  
  /// Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    if (_messaging == null) {
      // Cannot unsubscribe from topic - Firebase not available
      return;
    }
    await _messaging!.unsubscribeFromTopic(topic);
    // Unsubscribed from topic: $topic
  }
  
  /// Delete token (logout)
  Future<void> deleteToken() async {
    if (_messaging == null) {
      // Cannot delete token - Firebase not available
      return;
    }
    await _messaging!.deleteToken();
    _fcmToken = null;
    _apnsToken = null;
    // FCM token deleted
  }
}

/// Top-level function for background message handling
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // Background message received: ${message.messageId}
  // Handle background message
}