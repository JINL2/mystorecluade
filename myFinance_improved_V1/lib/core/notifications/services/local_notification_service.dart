import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';
import '../config/notification_config.dart';
import '../models/notification_payload.dart';

/// Service for managing local notifications
class LocalNotificationService {
  static final LocalNotificationService _instance = LocalNotificationService._internal();
  factory LocalNotificationService() => _instance;
  LocalNotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  final Logger _logger = Logger();
  
  bool _isInitialized = false;
  
  /// Initialize local notifications
  Future<void> initialize({
    void Function(NotificationResponse)? onDidReceiveNotificationResponse,
    void Function(NotificationResponse)? onDidReceiveBackgroundNotificationResponse,
  }) async {
    if (_isInitialized) {
      _logger.w('Local notifications already initialized');
      return;
    }
    
    try {
      _logger.d('🔔 Initializing local notifications...');
      
      // Initialize with settings
      await _notifications.initialize(
        NotificationConfig.initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse ??
            _defaultNotificationResponseHandler,
        onDidReceiveBackgroundNotificationResponse:
            onDidReceiveBackgroundNotificationResponse,
      );
      
      // Create notification channel for Android
      await _createNotificationChannel();
      
      // Request permissions for iOS
      await _requestIOSPermissions();
      
      _isInitialized = true;
      _logger.i('✅ Local notifications initialized');
      
    } catch (e, stackTrace) {
      _logger.e('Failed to initialize local notifications', 
                error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
  
  /// Create notification channel for Android
  Future<void> _createNotificationChannel() async {
    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(NotificationConfig.androidChannel);
    
    _logger.d('📱 Android notification channel created');
  }
  
  /// Request iOS permissions
  Future<void> _requestIOSPermissions() async {
    final iOS = _notifications
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    
    final granted = await iOS?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
    
    _logger.d('🍎 iOS permissions granted: $granted');
  }
  
  /// Show a local notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    String? category,
    NotificationDetails? details,
  }) async {
    if (!_isInitialized) {
      _logger.e('Local notifications not initialized');
      return;
    }
    
    try {
      final notificationDetails = details ?? _getDefaultNotificationDetails(category);
      
      await _notifications.show(
        id,
        title,
        body,
        notificationDetails,
        payload: payload,
      );
      
      _logger.d('📤 Notification shown: $title');
      
    } catch (e) {
      _logger.e('Failed to show notification', error: e);
    }
  }
  
  /// Show notification from payload
  Future<void> showNotificationFromPayload(NotificationPayload payload) async {
    await showNotification(
      id: payload.id.hashCode,
      title: payload.title,
      body: payload.body,
      payload: jsonEncode(payload.toJson()),
      category: payload.category,
    );
  }
  
  /// Schedule a notification
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
    String? category,
    NotificationDetails? details,
  }) async {
    if (!_isInitialized) {
      _logger.e('Local notifications not initialized');
      return;
    }
    
    try {
      final notificationDetails = details ?? _getDefaultNotificationDetails(category);
      
      await _notifications.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        notificationDetails,
        payload: payload,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
      
      _logger.d('⏰ Notification scheduled for: $scheduledDate');
      
    } catch (e) {
      _logger.e('Failed to schedule notification', error: e);
    }
  }
  
  /// Cancel a notification
  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
    _logger.d('❌ Notification cancelled: $id');
  }
  
  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
    _logger.d('❌ All notifications cancelled');
  }
  
  /// Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    final pending = await _notifications.pendingNotificationRequests();
    _logger.d('📋 Pending notifications: ${pending.length}');
    return pending;
  }
  
  /// Get active notifications (Android only)
  Future<List<ActiveNotification>> getActiveNotifications() async {
    final android = _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    
    if (android != null) {
      final active = await android.getActiveNotifications();
      _logger.d('📋 Active notifications: ${active.length}');
      return active;
    }
    
    return [];
  }
  
  /// Get default notification details based on category
  NotificationDetails _getDefaultNotificationDetails(String? category) {
    final categoryConfig = category != null
        ? NotificationConfig.categories[category]
        : null;
    
    final priority = _mapPriority(categoryConfig?.priority ?? NotificationPriority.medium);
    final importance = _mapImportance(categoryConfig?.priority ?? NotificationPriority.medium);
    
    return NotificationDetails(
      android: AndroidNotificationDetails(
        NotificationConfig.androidChannel.id,
        NotificationConfig.androidChannel.name,
        channelDescription: NotificationConfig.androidChannel.description,
        importance: importance,
        priority: priority,
        enableLights: true,
        enableVibration: true,
        playSound: true,
        icon: '@mipmap/ic_launcher',
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }
  
  /// Map custom priority to Android priority
  Priority _mapPriority(NotificationPriority priority) {
    switch (priority) {
      case NotificationPriority.min:
        return Priority.min;
      case NotificationPriority.low:
        return Priority.low;
      case NotificationPriority.medium:
        return Priority.defaultPriority;
      case NotificationPriority.high:
        return Priority.high;
      case NotificationPriority.max:
        return Priority.max;
    }
  }
  
  /// Map custom priority to Android importance
  Importance _mapImportance(NotificationPriority priority) {
    switch (priority) {
      case NotificationPriority.min:
        return Importance.min;
      case NotificationPriority.low:
        return Importance.low;
      case NotificationPriority.medium:
        return Importance.defaultImportance;
      case NotificationPriority.high:
        return Importance.high;
      case NotificationPriority.max:
        return Importance.max;
    }
  }
  
  /// Default notification response handler
  void _defaultNotificationResponseHandler(NotificationResponse response) {
    _logger.d('🔔 Notification response:');
    _logger.d('  Action: ${response.actionId}');
    _logger.d('  Payload: ${response.payload}');
    _logger.d('  Input: ${response.input}');
    
    // Parse payload and handle navigation
    if (response.payload != null) {
      try {
        final data = jsonDecode(response.payload!);
        // TODO: Handle navigation based on payload
      } catch (e) {
        _logger.e('Failed to parse notification payload', error: e);
      }
    }
  }
  
  /// Update badge count (iOS)
  Future<void> updateBadgeCount(int count) async {
    // This is typically handled by the OS, but we can track it
    _logger.d('🔢 Badge count updated: $count');
  }
}