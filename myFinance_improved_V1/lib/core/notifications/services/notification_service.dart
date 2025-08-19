import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/notification_config.dart';
import '../models/notification_payload.dart';
import '../utils/notification_logger.dart';
import 'fcm_service.dart';
import 'local_notification_service.dart';

/// Main notification service that coordinates all notification functionality
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FcmService _fcmService = FcmService();
  final LocalNotificationService _localNotificationService = LocalNotificationService();
  final NotificationLogger _notificationLogger = NotificationLogger();
  final Logger _logger = Logger();
  final SupabaseClient _supabase = Supabase.instance.client;
  
  bool _isInitialized = false;
  StreamSubscription? _notificationSubscription;
  
  /// Initialize the complete notification system
  Future<void> initialize() async {
    if (_isInitialized) {
      _logger.w('Notification service already initialized');
      return;
    }
    
    try {
      _logger.i('🚀 Initializing Notification Service...');
      
      // Initialize FCM
      await _fcmService.initialize();
      
      // Initialize local notifications
      await _localNotificationService.initialize(
        onDidReceiveNotificationResponse: _handleNotificationResponse,
      );
      
      // Initialize notification logger for debugging
      if (NotificationConfig.debugMode) {
        await _notificationLogger.initialize();
      }
      
      // Set up message handlers
      _setupMessageHandlers();
      
      // Store FCM token in Supabase
      await _storeFcmToken();
      
      // Subscribe to Supabase notifications
      await _subscribeToSupabaseNotifications();
      
      _isInitialized = true;
      _logger.i('✅ Notification Service initialized successfully');
      
      // Show initialization success notification in debug mode
      if (NotificationConfig.debugMode) {
        await _showDebugNotification(
          'Notification System Ready',
          'Push notifications are now active!',
        );
      }
      
    } catch (e, stackTrace) {
      _logger.e('Failed to initialize notification service', 
                error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
  
  /// Set up FCM message handlers
  void _setupMessageHandlers() {
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      _logger.d('📬 Foreground message received');
      _notificationLogger.logNotification(message);
      
      // Show local notification for foreground messages
      await _showNotificationFromRemoteMessage(message);
      
      // Handle data payload
      _handleDataPayload(message.data);
    });
    
    // Handle notification tap when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _logger.d('📱 App opened from background notification');
      _notificationLogger.logNotification(message);
      
      // Handle navigation
      _handleNotificationNavigation(message);
    });
  }
  
  /// Show notification from remote message
  Future<void> _showNotificationFromRemoteMessage(RemoteMessage message) async {
    final notification = message.notification;
    
    if (notification != null) {
      await _localNotificationService.showNotification(
        id: message.hashCode,
        title: notification.title ?? 'MyFinance',
        body: notification.body ?? '',
        payload: jsonEncode(message.data),
        category: message.data['category'],
      );
    }
  }
  
  /// Handle notification response (tap)
  void _handleNotificationResponse(NotificationResponse response) {
    _logger.d('🔔 Notification tapped');
    
    if (response.payload != null) {
      try {
        final data = jsonDecode(response.payload!);
        _handleNotificationNavigation(null, data: data);
      } catch (e) {
        _logger.e('Failed to parse notification payload', error: e);
      }
    }
  }
  
  /// Handle navigation based on notification data
  void _handleNotificationNavigation(RemoteMessage? message, {Map<String, dynamic>? data}) {
    final payload = data ?? message?.data ?? {};
    
    _logger.d('🧭 Handling navigation with payload: $payload');
    
    // Extract navigation data
    final screen = payload['screen'] as String?;
    final id = payload['id'] as String?;
    final type = payload['type'] as String?;
    
    // TODO: Implement navigation logic based on your app's routing
    switch (type) {
      case 'transaction':
        // Navigate to transaction detail
        _logger.d('Navigate to transaction: $id');
        break;
      case 'reminder':
        // Navigate to reminders
        _logger.d('Navigate to reminders');
        break;
      case 'alert':
        // Navigate to alerts
        _logger.d('Navigate to alerts');
        break;
      default:
        // Navigate to home or notifications list
        _logger.d('Navigate to home');
    }
  }
  
  /// Handle data payload from notification
  void _handleDataPayload(Map<String, dynamic> data) {
    _logger.d('📦 Handling data payload: $data');
    
    // Process based on notification type
    final type = data['type'] as String?;
    
    switch (type) {
      case 'sync':
        // Trigger data sync
        _logger.d('Triggering data sync');
        break;
      case 'update':
        // Check for app updates
        _logger.d('Checking for updates');
        break;
      default:
        // General data processing
        _logger.d('Processing general data');
    }
  }
  
  /// Store FCM token in Supabase
  Future<void> _storeFcmToken() async {
    try {
      final token = _fcmService.fcmToken;
      final userId = _supabase.auth.currentUser?.id;
      
      if (token == null || userId == null) {
        _logger.w('Cannot store FCM token: token=$token, userId=$userId');
        return;
      }
      
      final tokenData = FcmToken(
        token: token,
        userId: userId,
        platform: Platform.operatingSystem,
        deviceId: await _getDeviceId(),
        deviceModel: await _getDeviceModel(),
        appVersion: await _getAppVersion(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      await _supabase.from(NotificationConfig.supabaseTokenTable).upsert(
        tokenData.toJson(),
        onConflict: 'user_id,token',
      );
      
      _logger.i('✅ FCM token stored in Supabase');
      
    } catch (e) {
      _logger.e('Failed to store FCM token', error: e);
    }
  }
  
  /// Subscribe to Supabase notification events
  Future<void> _subscribeToSupabaseNotifications() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      
      if (userId == null) {
        _logger.w('Cannot subscribe to notifications: user not authenticated');
        return;
      }
      
      _notificationSubscription = _supabase
          .from(NotificationConfig.supabaseNotificationTable)
          .stream(primaryKey: ['id'])
          .eq('user_id', userId)
          .eq('is_read', false)
          .listen((List<Map<String, dynamic>> data) {
            _logger.d('📨 New Supabase notification: ${data.length} items');
            
            for (final item in data) {
              _handleSupabaseNotification(item);
            }
          });
      
      _logger.i('✅ Subscribed to Supabase notifications');
      
    } catch (e) {
      _logger.e('Failed to subscribe to Supabase notifications', error: e);
    }
  }
  
  /// Handle notification from Supabase
  void _handleSupabaseNotification(Map<String, dynamic> data) {
    try {
      final payload = NotificationPayload.fromJson(data);
      
      _localNotificationService.showNotificationFromPayload(payload);
      
    } catch (e) {
      _logger.e('Failed to handle Supabase notification', error: e);
    }
  }
  
  /// Send test notification
  Future<void> sendTestNotification() async {
    _logger.d('📤 Sending test notification...');
    
    await _localNotificationService.showNotification(
      id: DateTime.now().millisecondsSinceEpoch,
      title: 'Test Notification',
      body: 'This is a test notification from MyFinance app',
      category: 'update',
    );
    
    // Log test notification
    _notificationLogger.logTestNotification();
  }
  
  /// Show debug notification
  Future<void> _showDebugNotification(String title, String body) async {
    await _localNotificationService.showNotification(
      id: DateTime.now().millisecondsSinceEpoch,
      title: '🔧 Debug: $title',
      body: body,
      category: 'update',
    );
  }
  
  /// Get device ID
  Future<String> _getDeviceId() async {
    // TODO: Implement device ID retrieval
    return 'device_${DateTime.now().millisecondsSinceEpoch}';
  }
  
  /// Get device model
  Future<String> _getDeviceModel() async {
    // TODO: Implement device model retrieval
    return Platform.operatingSystem;
  }
  
  /// Get app version
  Future<String> _getAppVersion() async {
    // TODO: Implement app version retrieval
    return '1.0.0';
  }
  
  /// Update notification settings
  Future<void> updateNotificationSettings(NotificationSettings settings) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      
      if (userId == null) return;
      
      await _supabase.from('user_notification_settings').upsert(
        settings.toJson(),
        onConflict: 'user_id',
      );
      
      _logger.i('✅ Notification settings updated');
      
    } catch (e) {
      _logger.e('Failed to update notification settings', error: e);
    }
  }
  
  /// Get notification settings
  Future<NotificationSettings?> getNotificationSettings() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      
      if (userId == null) return null;
      
      final response = await _supabase
          .from('user_notification_settings')
          .select()
          .eq('user_id', userId)
          .single();
      
      return NotificationSettings.fromJson(response);
      
    } catch (e) {
      _logger.e('Failed to get notification settings', error: e);
      return null;
    }
  }
  
  /// Clean up resources
  Future<void> dispose() async {
    await _notificationSubscription?.cancel();
    await _fcmService.deleteToken();
    await _localNotificationService.cancelAllNotifications();
    _isInitialized = false;
    _logger.d('🧹 Notification service disposed');
  }
  
  /// Get debug information
  Map<String, dynamic> getDebugInfo() {
    return {
      'initialized': _isInitialized,
      'fcm_token': _fcmService.fcmToken,
      'apns_token': _fcmService.apnsToken,
      'platform': Platform.operatingSystem,
      'debug_mode': NotificationConfig.debugMode,
      'user_id': _supabase.auth.currentUser?.id,
    };
  }
}