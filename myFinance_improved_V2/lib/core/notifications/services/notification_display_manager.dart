import 'dart:async';
import 'package:flutter/material.dart';
import '../config/notification_display_config.dart';
import '../models/notification_payload.dart';
// import '../../../presentation/widgets/notifications/smart_toast_notification.dart'; // TODO: File missing

/// Manages how notifications are displayed to prevent repetitive, annoying notifications
/// This service ensures notifications are shown only once and respects user preferences
class NotificationDisplayManager {
  static final NotificationDisplayManager _instance = NotificationDisplayManager._internal();
  factory NotificationDisplayManager() => _instance;
  NotificationDisplayManager._internal();

  // Track shown notifications to prevent repeats
  final Set<String> _shownNotificationIds = {};
  final Set<String> _autoMarkedAsRead = {};
  
  // Track last notification time to implement intelligent batching
  DateTime? _lastNotificationTime;
  
  // Queue for batching multiple notifications
  final List<NotificationPayload> _notificationQueue = [];
  Timer? _batchTimer;
  
  // Configuration
  late NotificationDisplayConfig _displayConfig;
  bool _isInitialized = false;
  
  /// Initialize the display manager
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    _displayConfig = NotificationDisplayConfig();
    await _displayConfig.initialize();
    _isInitialized = true;
    
    // Auto-migrate users to better notification experience
    if (_displayConfig.currentMode == NotificationMode.legacy) {
      await _displayConfig.migrateToAmbientMode();
    }
  }
  
  /// Process incoming notification with intelligent display logic
  Future<void> handleNotification(
    BuildContext? context,
    NotificationPayload payload, {
    bool forceShow = false,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }
    
    // CRITICAL FIX: Check if notification is stale (older than 30 minutes)
    // This prevents showing old, irrelevant notifications when user opens the app
    if (_isStaleNotification(payload)) {
      // Notification is too old to be relevant, don't display
      // Still mark as read to update badge counter
      if (_displayConfig.isAutoMarkAsReadEnabled) {
        _autoMarkAsRead(payload.id);
      }
      return;
    }
    
    // Check if we've already shown this notification
    if (_shownNotificationIds.contains(payload.id) && !forceShow) {
      // Already shown, don't repeat
      return;
    }
    
    // Check if we're in quiet hours
    if (!_displayConfig.shouldShowNotifications && !forceShow) {
      // In quiet hours, only update badge
      return;
    }
    
    // Mark as shown to prevent repeats
    _shownNotificationIds.add(payload.id);
    
    // Auto-mark as read if enabled to prevent "tap to mark as read" annoyance
    if (_displayConfig.isAutoMarkAsReadEnabled) {
      _autoMarkAsRead(payload.id);
    }
    
    // COMPLETE REMOVAL OF IN-APP NOTIFICATIONS
    // This is the permanent solution - NO notifications shown in the app UI
    // Only the badge counter is updated
    // Users check notifications when THEY want in the notification center
    
    // ALWAYS RETURN - Never show any in-app notifications
    return;
    
    // Original logic (disabled by forceAmbientMode)
    switch (_displayConfig.currentMode) {
      case NotificationMode.ambient:
        // Ambient mode: Badge only, no visual interruption
        // The badge counter will be updated automatically by the notification provider
        break;
        
      case NotificationMode.smartToast:
        // Smart toast mode: Show non-intrusive toast
        if (context != null && context.mounted) {
          _showSmartToast(context, payload);
        }
        break;
        
      case NotificationMode.hybrid:
        // Hybrid mode: Badge + smart toast for important notifications
        if (_isImportantNotification(payload) && context != null && context.mounted) {
          _showSmartToast(context, payload);
        }
        break;
        
      case NotificationMode.silent:
        // Silent mode: No visual notifications at all
        break;
        
      case NotificationMode.legacy:
        // Legacy mode: Deprecated, auto-migrate to ambient
        await _displayConfig.migrateToAmbientMode();
        break;
    }
    
    // Update last notification time for intelligent batching
    _lastNotificationTime = DateTime.now();
  }
  
  /// Check if notification is stale (too old to be relevant)
  bool _isStaleNotification(NotificationPayload payload) {
    // If notification doesn't have a timestamp, assume it's fresh
    final createdAt = payload.createdAt;
    if (createdAt == null) {
      // Check if we have a timestamp in the data field
      final timestampStr = payload.data?['timestamp'] as String?;
      if (timestampStr == null) {
        // No timestamp available, treat as fresh
        return false;
      }
      
      try {
        final timestamp = DateTime.parse(timestampStr);
        final age = DateTime.now().difference(timestamp);
        
        // Notifications older than 30 minutes are considered stale
        // This prevents showing old push notifications when user opens the app
        return age.inMinutes > 30;
      } catch (e) {
        // Can't parse timestamp, treat as fresh
        return false;
      }
    }
    
    // Check age of notification
    final age = DateTime.now().difference(createdAt);
    
    // Consider notifications older than 30 minutes as stale
    // Adjust this threshold based on your needs:
    // - Shift reminders: maybe 15 minutes
    // - Transaction alerts: maybe 1 hour
    // - General announcements: maybe 24 hours
    const staleThreshold = Duration(minutes: 30);
    
    return age > staleThreshold;
  }
  
  /// Show smart toast notification
  void _showSmartToast(BuildContext context, NotificationPayload payload) {
    // Check if we should batch notifications
    if (_shouldBatchNotifications()) {
      _addToQueue(payload);
    } else {
      // Show immediately
      // SmartToastNotification.showFromPayload(context, payload); // TODO: File missing
      debugPrint('[NotificationDisplayManager] Would show toast: ${payload.title}');
    }
  }
  
  /// Determine if notification is important enough for hybrid mode
  bool _isImportantNotification(NotificationPayload payload) {
    // Shift reminders are important
    if (payload.category == 'shift_reminder') return true;
    
    // Get priority from data field if available
    final priority = payload.data?['priority'] as String?;
    
    // Transaction alerts over certain amount
    if (payload.category == 'transaction' && priority == 'high') return true;
    
    // Security alerts
    if (payload.category == 'security') return true;
    
    // System critical alerts
    if (priority == 'critical') return true;
    
    return false;
  }
  
  /// Check if we should batch notifications
  bool _shouldBatchNotifications() {
    if (_lastNotificationTime == null) return false;
    
    // If last notification was within 2 seconds, batch them
    final timeSinceLastNotification = DateTime.now().difference(_lastNotificationTime!);
    return timeSinceLastNotification.inSeconds < 2;
  }
  
  /// Add notification to queue for batching
  void _addToQueue(NotificationPayload payload) {
    _notificationQueue.add(payload);
    
    // Cancel existing timer
    _batchTimer?.cancel();
    
    // Start new timer to show batched notifications
    _batchTimer = Timer(const Duration(seconds: 2), () {
      _showBatchedNotifications();
    });
  }
  
  /// Show batched notifications as a single toast
  void _showBatchedNotifications() {
    if (_notificationQueue.isEmpty) return;
    
    // Show summary toast
    // Note: Context would need to be passed here in real implementation
    
    // Clear queue
    _notificationQueue.clear();
  }
  
  /// Auto-mark notification as read
  void _autoMarkAsRead(String notificationId) {
    if (_autoMarkedAsRead.contains(notificationId)) return;
    
    _autoMarkedAsRead.add(notificationId);
    
    // Trigger mark as read in database after a short delay
    // This prevents the annoying "tap to mark as read" behavior
    Timer(const Duration(milliseconds: 500), () {
      // This would call the notification service to mark as read
      // NotificationService().markNotificationAsRead(notificationId);
    });
  }
  
  /// Clear shown notification tracking (call on app resume or after time period)
  void clearShownNotifications() {
    // Keep only recent notifications (last hour)
    final oneHourAgo = DateTime.now().subtract(const Duration(hours: 1));
    
    // In production, you'd want to track timestamps with notification IDs
    // For now, we'll clear all after an hour
    if (_lastNotificationTime != null && 
        _lastNotificationTime!.isBefore(oneHourAgo)) {
      _shownNotificationIds.clear();
      _autoMarkedAsRead.clear();
    }
  }
  
  /// Check if notification has been shown
  bool hasBeenShown(String notificationId) {
    return _shownNotificationIds.contains(notificationId);
  }
  
  /// Force clear all tracking (for testing or reset)
  void resetTracking() {
    _shownNotificationIds.clear();
    _autoMarkedAsRead.clear();
    _notificationQueue.clear();
    _batchTimer?.cancel();
    _lastNotificationTime = null;
  }
  
  /// Get display statistics for analytics
  Map<String, dynamic> getDisplayStatistics() {
    return {
      'shown_count': _shownNotificationIds.length,
      'auto_marked_read': _autoMarkedAsRead.length,
      'queued': _notificationQueue.length,
      'mode': _displayConfig.currentMode.toString(),
      'quiet_hours_enabled': _displayConfig.isQuietHoursEnabled,
      'auto_mark_read': _displayConfig.isAutoMarkAsReadEnabled,
    };
  }
}