import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Configuration constants and settings for the notification system
class NotificationConfig {
  NotificationConfig._();

  // Channel configurations for Android
  static const androidChannel = AndroidNotificationChannel(
    'myfinance_channel', // Channel ID
    'MyFinance Notifications', // Channel name
    description: 'Notifications for MyFinance app',
    importance: Importance.high,
    enableLights: true,
    enableVibration: true,
    playSound: true,
  );

  // iOS notification settings
  static const iosSettings = DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
    defaultPresentAlert: true,
    defaultPresentBadge: true,
    defaultPresentSound: true,
  );

  // Android notification settings
  static const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

  // Combined initialization settings
  static const initializationSettings = InitializationSettings(
    android: androidSettings,
    iOS: iosSettings,
  );

  // Notification categories for different types
  static const Map<String, NotificationCategory> categories = {
    'transaction': NotificationCategory(
      id: 'transaction',
      displayName: 'Transactions',
      icon: '💰',
      priority: NotificationPriority.high,
    ),
    'reminder': NotificationCategory(
      id: 'reminder',
      displayName: 'Reminders',
      icon: '⏰',
      priority: NotificationPriority.medium,
    ),
    'alert': NotificationCategory(
      id: 'alert',
      displayName: 'Alerts',
      icon: '🚨',
      priority: NotificationPriority.max,
    ),
    'update': NotificationCategory(
      id: 'update',
      displayName: 'Updates',
      icon: '📢',
      priority: NotificationPriority.low,
    ),
  };

  // Supabase table configurations
  static const String supabaseTokenTable = 'user_fcm_tokens';
  static const String supabaseNotificationTable = 'notifications';
  
  // Debug mode flag - automatically determined based on build mode
  static bool get debugMode => kDebugMode && !const bool.fromEnvironment('dart.vm.product');
  
  // Retry configuration
  static const int maxRetryAttempts = 3;
  static const Duration retryDelay = Duration(seconds: 5);
}

/// Represents a notification category with its properties
class NotificationCategory {
  final String id;
  final String displayName;
  final String icon;
  final NotificationPriority priority;

  const NotificationCategory({
    required this.id,
    required this.displayName,
    required this.icon,
    required this.priority,
  });
}

/// Priority levels for notifications
enum NotificationPriority {
  min,
  low,
  medium,
  high,
  max,
}