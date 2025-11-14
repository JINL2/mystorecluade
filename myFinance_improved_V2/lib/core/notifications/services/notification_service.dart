import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/notification_config.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import '../firebase_stub.dart';
import '../models/notification_db_model.dart';
import '../models/notification_payload.dart';
import '../repositories/notification_repository.dart';
import '../utils/notification_logger.dart';
import 'fcm_service.dart';
import 'local_notification_service.dart';
import 'notification_display_manager.dart';
import 'token_manager.dart';

/// Main notification service that coordinates all notification functionality
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FcmService _fcmService = FcmService();
  final LocalNotificationService _localNotificationService = LocalNotificationService();
  final NotificationLogger _notificationLogger = NotificationLogger();
  final NotificationRepository _repository = NotificationRepository();
  final TokenManager _tokenManager = TokenManager();
  final NotificationDisplayManager _displayManager = NotificationDisplayManager();
  // final Logger _logger = Logger();
  final SupabaseClient _supabase = Supabase.instance.client;
  
  bool _isInitialized = false;
  StreamSubscription? _notificationSubscription;
  
  /// Initialize the complete notification system
  Future<void> initialize() async {
    if (_isInitialized) {
      // Notification service already initialized
      return;
    }
    
    try {
      // Initializing Notification Service
      
      // Try to initialize FCM (will fail gracefully if Firebase is not available)
      await _fcmService.initialize();
      
      // Check if FCM is available
      if (_fcmService.isAvailable) {
        // FCM service available - push notifications enabled
      } else {
        // FCM service unavailable - only local notifications available
      }
      
      // Initialize local notifications (always available)
      await _localNotificationService.initialize(
        onDidReceiveNotificationResponse: _handleNotificationResponse,
      );
      
      // Initialize notification logger for debugging
      if (NotificationConfig.debugMode) {
        await _notificationLogger.initialize();
      }
      
      // Set up message handlers
      _setupMessageHandlers();
      
      // Initialize token manager for automatic token management
      await _tokenManager.initialize();
      
      // Initialize display manager to handle notification display intelligently
      await _displayManager.initialize();
      
      // Subscribe to database notifications
      await _subscribeToSupabaseNotifications();
      
      _isInitialized = true;
      // Notification Service initialized successfully
      
      // Initialization complete
      
    } catch (e) {
      // Failed to initialize notification service
      rethrow;
    }
  }
  
  /// Set up FCM message handlers
  void _setupMessageHandlers() {
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      // Foreground message received
      _notificationLogger.logNotification(message);
      
      // IMPORTANT: We're NOT showing in-app notifications anymore
      // Only update the badge counter through the database
      // The user can see notifications in the notification center when they want
      
      // Store in database to update badge counter
      await _storeNotificationInDatabase(
        title: message.notification?.title ?? 'MyFinance',
        body: message.notification?.body ?? '',
        category: message.data['category'],
        data: message.data,
        imageUrl: message.notification?.android?.imageUrl ?? message.notification?.apple?.imageUrl,
      );
      
      // Handle data payload silently
      _handleDataPayload(message.data);
      
      // We're intentionally NOT calling _showNotificationFromRemoteMessage
      // to prevent any in-app display of notifications
    });
    
    // Handle notification tap when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // App opened from background notification
      _notificationLogger.logNotification(message);
      
      // Handle navigation
      _handleNotificationNavigation(message);
    });
  }
  
  
  /// Handle notification response (tap)
  void _handleNotificationResponse(NotificationResponse response) {
    // Notification tapped
    
    if (response.payload != null) {
      try {
        final data = jsonDecode(response.payload!);
        _handleNotificationNavigation(null, data: data);
      } catch (e) {
        // Failed to parse notification payload
      }
    }
  }
  
  /// Handle navigation based on notification data
  void _handleNotificationNavigation(RemoteMessage? message, {Map<String, dynamic>? data}) {
    final payload = data ?? message?.data ?? {};
    
    // Handling navigation with payload
    
    // Extract navigation data
    final type = payload['type'] as String?;
    
    // Navigation logic based on app's routing - implementation pending
    switch (type) {
      case 'transaction':
        // Navigate to transaction detail
        // Navigate to transaction: $id
        break;
      case 'reminder':
        // Navigate to reminders
        // Navigate to reminders
        break;
      case 'alert':
        // Navigate to alerts
        // Navigate to alerts
        break;
      default:
        // Navigate to home or notifications list
        // Navigate to home
    }
  }
  
  /// Handle data payload from notification
  void _handleDataPayload(Map<String, dynamic> data) {
    // Handling data payload
    
    // Process based on notification type
    final type = data['type'] as String?;
    
    switch (type) {
      case 'sync':
        // Trigger data sync
        // Triggering data sync
        break;
      case 'update':
        // Check for app updates
        // Checking for updates
        break;
      default:
        // General data processing
        // Processing general data
    }
  }
  
  
  /// Subscribe to database notification events
  Future<void> _subscribeToSupabaseNotifications() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      
      if (userId == null) {
        // Cannot subscribe to notifications: user not authenticated
        return;
      }
      
      _notificationSubscription = _supabase
          .from('notifications')
          .stream(primaryKey: ['id'])
          .listen(
            (List<Map<String, dynamic>> data) {
              // New database notification: ${data.length} items
              
              // Filter for user's unread notifications
              final userNotifications = data.where((item) => 
                item['user_id'] == userId && item['is_read'] == false,
              ).toList();
              
              for (final item in userNotifications) {
                _handleDatabaseNotification(item);
              }
            },
            onError: (error) {
              // Handle realtime subscription error
              print('Realtime subscription error: $error');
              // Attempt to reconnect after delay
              _scheduleReconnection();
            },
            cancelOnError: false,
          );
      
      // Subscribed to database notifications
      
    } catch (e) {
      // Failed to subscribe to database notifications
      _scheduleReconnection();
    }
  }

  /// Schedule reconnection with exponential backoff
  int _reconnectionAttempts = 0;
  Timer? _reconnectionTimer;

  void _scheduleReconnection() {
    // Cancel existing timer
    _reconnectionTimer?.cancel();
    
    // Calculate delay with exponential backoff (max 30 seconds)
    final delay = Duration(seconds: (2 * _reconnectionAttempts).clamp(1, 30));
    _reconnectionAttempts++;
    
    _reconnectionTimer = Timer(delay, () async {
      try {
        // Cancel existing subscription
        await _notificationSubscription?.cancel();
        
        // Attempt to reconnect
        await _subscribeToSupabaseNotifications();
        
        // Reset attempts on successful connection
        _reconnectionAttempts = 0;
        
      } catch (e) {
        // Reconnection failed, will retry
        if (_reconnectionAttempts < 5) {
          _scheduleReconnection();
        } else {
          // Max attempts reached, stop trying
          _reconnectionAttempts = 0;
        }
      }
    });
  }
  
  /// Handle notification from database
  void _handleDatabaseNotification(Map<String, dynamic> data) {
    try {
      final dbNotification = NotificationDbModel.fromJson(data);
      
      // Convert to payload format for local notification
      final payload = NotificationPayload(
        id: dbNotification.id ?? '',
        title: dbNotification.title ?? 'Notification',
        body: dbNotification.body ?? '',
        data: dbNotification.data ?? {},
        category: dbNotification.category,
        isRead: dbNotification.isRead,
        createdAt: dbNotification.createdAt,
      );
      
      _localNotificationService.showNotificationFromPayload(payload);
      
    } catch (e) {
      // Failed to handle database notification
    }
  }
  
  /// Send test notification
  Future<void> sendTestNotification() async {
    // Sending test notification
    
    // Use a safe ID by taking modulo to ensure it fits in 32-bit range
    final safeId = DateTime.now().millisecondsSinceEpoch % 999999;
    
    // Store test notification in database
    await _storeNotificationInDatabase(
      title: 'Test Notification',
      body: 'This is a test notification from MyFinance app',
      category: 'test',
      data: {'test': true, 'timestamp': DateTime.now().toIso8601String()},
    );
    
    await _localNotificationService.showNotification(
      id: safeId,
      title: 'Test Notification',
      body: 'This is a test notification from MyFinance app',
      category: 'test',
    );
    
    // Log test notification
    _notificationLogger.logTestNotification();
  }
  
  
  
  /// Store notification in database
  Future<NotificationDbModel?> _storeNotificationInDatabase({
    required String title,
    required String body,
    String? category,
    Map<String, dynamic>? data,
    String? imageUrl,
    String? actionUrl,
    DateTime? scheduledTime,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        // Cannot store notification: user not authenticated
        return null;
      }
      
      final result = await _repository.storeNotification(
        userId: userId,
        title: title,
        body: body,
        category: category,
        data: data,
        imageUrl: imageUrl,
        actionUrl: actionUrl,
        scheduledTime: scheduledTime,
      );
      
      if (result != null) {
        // Notification stored in database
        return result;
      } else {
        // Failed to store notification in database
        return null;
      }
      
    } catch (e) {
      // Failed to store notification in database
      return null;
    }
  }
  
  /// Get user notifications
  Future<List<NotificationDbModel>> getUserNotifications({
    int limit = 50,
    int offset = 0,
    bool? isRead,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        // Cannot get notifications: user not authenticated
        return [];
      }
      
      final notifications = await _repository.getUserNotifications(
        userId: userId,
        limit: limit,
        offset: offset,
        isRead: isRead,
      );
      
      // Retrieved ${notifications.length} notifications
      return notifications;
      
    } catch (e) {
      // Failed to get user notifications
      return [];
    }
  }
  
  /// Mark notification as read
  Future<bool> markNotificationAsRead(String notificationId) async {
    try {
      final result = await _repository.markAsRead(notificationId);
      
      if (result) {
        // Notification marked as read
      }
      
      return result;
      
    } catch (e) {
      // Failed to mark notification as read
      return false;
    }
  }
  
  /// Get unread notification count
  Future<int> getUnreadNotificationCount() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        return 0;
      }
      
      return await _repository.getUnreadCount(userId);
      
    } catch (e) {
      // Failed to get unread notification count
      return 0;
    }
  }
  
  /// Get notification statistics
  Future<Map<String, dynamic>> getNotificationStats() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        return {};
      }
      
      return await _repository.getNotificationStats(userId);
      
    } catch (e) {
      // Failed to get notification statistics
      return {};
    }
  }
  
  /// Update notification settings
  Future<void> updateNotificationSettings({
    bool? pushEnabled,
    bool? emailEnabled,
    bool? transactionAlerts,
    bool? reminders,
    bool? marketingMessages,
    String? soundPreference,
    bool? vibrationEnabled,
    Map<String, dynamic>? categoryPreferences,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      
      if (userId == null) return;
      
      final result = await _repository.updateUserSettings(
        userId: userId,
        pushEnabled: pushEnabled,
        emailEnabled: emailEnabled,
        transactionAlerts: transactionAlerts,
        reminders: reminders,
        marketingMessages: marketingMessages,
        soundPreference: soundPreference,
        vibrationEnabled: vibrationEnabled,
        categoryPreferences: categoryPreferences,
      );
      
      if (result != null) {
        // Notification settings updated
      } else {
        // Failed to update notification settings
      }
      
    } catch (e) {
      // Failed to update notification settings
    }
  }
  
  /// Get notification settings
  Future<UserNotificationSettingsModel?> getNotificationSettings() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      
      if (userId == null) return null;
      
      return await _repository.getUserSettings(userId);
      
    } catch (e) {
      // Failed to get notification settings
      return null;
    }
  }
  
  /// Clean up resources
  Future<void> dispose() async {
    _reconnectionTimer?.cancel();
    await _notificationSubscription?.cancel();
    await _fcmService.deleteToken();
    await _localNotificationService.cancelAllNotifications();
    _isInitialized = false;
    // Notification service disposed
  }
  
  /// Get debug information
  Map<String, dynamic> getDebugInfo() {
    final currentUser = _supabase.auth.currentUser;
    return {
      'initialized': _isInitialized,
      'fcm_token': _fcmService.fcmToken,
      'apns_token': _fcmService.apnsToken,
      'platform': Platform.operatingSystem,
      'debug_mode': NotificationConfig.debugMode,
      'supabase_connected': true, // Supabase client is initialized
      'auth_user_exists': currentUser != null,
      'user_id': currentUser?.id,
      'user_email': currentUser?.email,
      'user_role': currentUser?.role,
      'auth_session_exists': _supabase.auth.currentSession != null,
    };
  }
}