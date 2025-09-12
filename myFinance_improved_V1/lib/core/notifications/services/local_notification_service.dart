import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:logger/logger.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import '../config/notification_config.dart';
import '../models/notification_payload.dart';

/// Service for managing local notifications
class LocalNotificationService {
  static final LocalNotificationService _instance = LocalNotificationService._internal();
  factory LocalNotificationService() => _instance;
  LocalNotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  // final Logger _logger = Logger();
  
  bool _isInitialized = false;
  
  /// Initialize local notifications
  Future<void> initialize({
    void Function(NotificationResponse)? onDidReceiveNotificationResponse,
    void Function(NotificationResponse)? onDidReceiveBackgroundNotificationResponse,
  }) async {
    if (_isInitialized) {
      // Local notifications already initialized
      return;
    }
    
    try {
      // Initializing local notifications
      
      // Initialize timezone
      tz_data.initializeTimeZones();
      
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
      // Local notifications initialized
      
    } catch (e) {
      // Failed to initialize local notifications: $e
      rethrow;
    }
  }
  
  /// Create notification channel for Android
  Future<void> _createNotificationChannel() async {
    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(NotificationConfig.androidChannel);
    
    // Android notification channel created
  }
  
  /// Request iOS permissions
  Future<void> _requestIOSPermissions() async {
    final iOS = _notifications
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    
    await iOS?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
    
    // iOS permissions requested
  }
  
  /// Show a local notification - DISABLED to prevent in-app notifications
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    String? category,
    NotificationDetails? details,
  }) async {
    // COMPLETELY DISABLED - We don't want ANY local notifications
    // Only badge counter updates through the database
    return;
    
    // Original code commented out to prevent any notifications
    /*
    if (!_isInitialized) {
      // Local notifications not initialized
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
      
      // Notification shown: $title
      
    } catch (e) {
      // Failed to show notification: $e
    }
    */
  }
  
  /// Show notification from payload - DISABLED
  Future<void> showNotificationFromPayload(NotificationPayload payload) async {
    // COMPLETELY DISABLED - We don't want ANY local notifications
    return;
    
    // Original code commented out
    /*
    // Use a safe ID by taking only the last 6 digits of hashCode to ensure it fits in 32-bit range
    final safeId = payload.id.hashCode.abs() % 999999;
    
    await showNotification(
      id: safeId,
      title: payload.title,
      body: payload.body,
      payload: jsonEncode(payload.toJson()),
      category: payload.category,
    );
    */
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
      // Local notifications not initialized
      return;
    }
    
    try {
      final notificationDetails = details ?? _getDefaultNotificationDetails(category);
      
      // Convert DateTime to TZDateTime
      final tzScheduledDate = tz.TZDateTime.from(scheduledDate, tz.local);
      
      await _notifications.zonedSchedule(
        id,
        title,
        body,
        tzScheduledDate,
        notificationDetails,
        payload: payload,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
      
      // Notification scheduled for: $scheduledDate
      
    } catch (e) {
      // Failed to schedule notification: $e
    }
  }
  
  /// Cancel a notification
  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
    // Notification cancelled: $id
  }
  
  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
    // All notifications cancelled
  }
  
  /// Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    final pending = await _notifications.pendingNotificationRequests();
    // Pending notifications: ${pending.length}
    return pending;
  }
  
  /// Get active notifications (Android only)
  Future<List<ActiveNotification>> getActiveNotifications() async {
    final android = _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    
    if (android != null) {
      final active = await android.getActiveNotifications();
      // Active notifications: ${active.length}
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
    // Notification response handled
    
    // Parse payload and handle navigation
    if (response.payload != null) {
      try {
        jsonDecode(response.payload!);
        // Handle navigation based on payload - implementation pending
      } catch (e) {
        // Failed to parse notification payload: $e
      }
    }
  }
  
  /// Update badge count (iOS)
  Future<void> updateBadgeCount(int count) async {
    // This is typically handled by the OS, but we can track it
    // Badge count updated: $count
  }
}