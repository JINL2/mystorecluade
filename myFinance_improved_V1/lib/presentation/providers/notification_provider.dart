import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:logger/logger.dart';
import '../../core/notifications/models/notification_payload.dart';
import '../../core/notifications/models/notification_db_model.dart';
import '../../core/notifications/services/notification_service.dart';
import '../../core/notifications/utils/notification_logger.dart';

/// Provider for notification service
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

/// Provider for notification logger
final notificationLoggerProvider = Provider<NotificationLogger>((ref) {
  return NotificationLogger();
});

/// State notifier for notification management
class NotificationNotifier extends StateNotifier<NotificationState> {
  final NotificationService _notificationService;
  final NotificationLogger _notificationLogger;
  // final Logger _logger = Logger();
  
  NotificationNotifier({
    required NotificationService notificationService,
    required NotificationLogger notificationLogger,
  })  : _notificationService = notificationService,
        _notificationLogger = notificationLogger,
        super(const NotificationState());
  
  /// Initialize notifications
  Future<void> initialize() async {
    state = state.copyWith(isLoading: true);
    
    try {
      await _notificationService.initialize();
      
      // Get notification settings
      final settings = await _notificationService.getNotificationSettings();
      
      // Get debug info
      final debugInfo = _notificationService.getDebugInfo();
      
      state = state.copyWith(
        isInitialized: true,
        isLoading: false,
        settings: settings,
        fcmToken: debugInfo['fcm_token'] as String?,
        apnsToken: debugInfo['apns_token'] as String?,
        error: null,
      );
      
      // Notifications initialized in provider
      
    } catch (e, stackTrace) {
      // Failed to initialize notifications
      
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
  
  /// Send test notification
  Future<void> sendTestNotification() async {
    try {
      await _notificationService.sendTestNotification();
      
      state = state.copyWith(
        lastTestNotificationTime: DateTime.now(),
      );
      
      // Test notification sent
      
    } catch (e) {
      // Failed to send test notification
      state = state.copyWith(error: e.toString());
    }
  }
  
  /// Update notification settings
  Future<void> updateSettings({
    bool? pushEnabled,
    bool? emailEnabled,
    bool? transactionAlerts,
    bool? reminders,
    bool? marketingMessages,
    String? soundPreference,
    bool? vibrationEnabled,
    Map<String, dynamic>? categoryPreferences,
  }) async {
    state = state.copyWith(isLoading: true);
    
    try {
      await _notificationService.updateNotificationSettings(
        pushEnabled: pushEnabled,
        emailEnabled: emailEnabled,
        transactionAlerts: transactionAlerts,
        reminders: reminders,
        marketingMessages: marketingMessages,
        soundPreference: soundPreference,
        vibrationEnabled: vibrationEnabled,
        categoryPreferences: categoryPreferences,
      );
      
      // Refresh settings after update
      final updatedSettings = await _notificationService.getNotificationSettings();
      
      state = state.copyWith(
        settings: updatedSettings,
        isLoading: false,
        error: null,
      );
      
      // Notification settings updated
      
    } catch (e) {
      // Failed to update notification settings
      
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
  
  /// Toggle push notifications
  Future<void> togglePushNotifications(bool enabled) async {
    await updateSettings(pushEnabled: enabled);
  }
  
  /// Toggle notification category
  Future<void> toggleCategory(String category, bool enabled) async {
    final currentSettings = state.settings;
    
    if (currentSettings == null) return;
    
    final categoryPreferences = Map<String, dynamic>.from(
      currentSettings.categoryPreferences,
    );
    categoryPreferences[category] = enabled;
    
    await updateSettings(categoryPreferences: categoryPreferences);
  }
  
  /// Get notification logs
  List<NotificationLog> getNotificationLogs() {
    return _notificationLogger.getLogs();
  }
  
  /// Get notification statistics
  Map<String, dynamic> getStatistics() {
    return _notificationLogger.getStatistics();
  }
  
  /// Clear notification logs
  Future<void> clearLogs() async {
    await _notificationLogger.clearLogs();
    // Notification logs cleared
  }
  
  /// Export logs
  String exportLogs() {
    return _notificationLogger.exportLogsToJson();
  }
  
  /// Refresh tokens
  Future<void> refreshTokens() async {
    state = state.copyWith(isLoading: true);
    
    try {
      // Reinitialize to refresh tokens
      await _notificationService.initialize();
      
      final debugInfo = _notificationService.getDebugInfo();
      
      state = state.copyWith(
        isLoading: false,
        fcmToken: debugInfo['fcm_token'] as String?,
        apnsToken: debugInfo['apns_token'] as String?,
        error: null,
      );
      
      // Tokens refreshed
      
    } catch (e) {
      // Failed to refresh tokens
      
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
  
  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Notification state model
class NotificationState {
  final bool isInitialized;
  final bool isLoading;
  final String? error;
  final UserNotificationSettingsModel? settings;
  final String? fcmToken;
  final String? apnsToken;
  final DateTime? lastTestNotificationTime;
  
  const NotificationState({
    this.isInitialized = false,
    this.isLoading = false,
    this.error,
    this.settings,
    this.fcmToken,
    this.apnsToken,
    this.lastTestNotificationTime,
  });
  
  NotificationState copyWith({
    bool? isInitialized,
    bool? isLoading,
    String? error,
    UserNotificationSettingsModel? settings,
    String? fcmToken,
    String? apnsToken,
    DateTime? lastTestNotificationTime,
  }) {
    return NotificationState(
      isInitialized: isInitialized ?? this.isInitialized,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      settings: settings ?? this.settings,
      fcmToken: fcmToken ?? this.fcmToken,
      apnsToken: apnsToken ?? this.apnsToken,
      lastTestNotificationTime: lastTestNotificationTime ?? this.lastTestNotificationTime,
    );
  }
}

/// Provider for notification state
final notificationProvider = StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
  final notificationService = ref.watch(notificationServiceProvider);
  final notificationLogger = ref.watch(notificationLoggerProvider);
  
  return NotificationNotifier(
    notificationService: notificationService,
    notificationLogger: notificationLogger,
  );
});

/// Provider for unread notification count
final unreadNotificationCountProvider = FutureProvider.autoDispose<int>((ref) async {
  final notificationService = ref.watch(notificationServiceProvider);
  return await notificationService.getUnreadNotificationCount();
});

/// Provider that can be used to refresh the unread count
final refreshUnreadCountProvider = StateProvider<int>((ref) => 0);