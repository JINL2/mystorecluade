import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import '../../core/notifications/models/notification_payload.dart';
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
  final Logger _logger = Logger();
  
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
      
      _logger.i('✅ Notifications initialized in provider');
      
    } catch (e, stackTrace) {
      _logger.e('Failed to initialize notifications', 
                error: e, stackTrace: stackTrace);
      
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
      
      _logger.d('📤 Test notification sent');
      
    } catch (e) {
      _logger.e('Failed to send test notification', error: e);
      state = state.copyWith(error: e.toString());
    }
  }
  
  /// Update notification settings
  Future<void> updateSettings(NotificationSettings settings) async {
    state = state.copyWith(isLoading: true);
    
    try {
      await _notificationService.updateNotificationSettings(settings);
      
      state = state.copyWith(
        settings: settings,
        isLoading: false,
        error: null,
      );
      
      _logger.i('✅ Notification settings updated');
      
    } catch (e) {
      _logger.e('Failed to update notification settings', error: e);
      
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
  
  /// Toggle push notifications
  Future<void> togglePushNotifications(bool enabled) async {
    final currentSettings = state.settings;
    
    if (currentSettings == null) return;
    
    final updatedSettings = currentSettings.copyWith(
      pushEnabled: enabled,
    );
    
    await updateSettings(updatedSettings);
  }
  
  /// Toggle notification category
  Future<void> toggleCategory(String category, bool enabled) async {
    final currentSettings = state.settings;
    
    if (currentSettings == null) return;
    
    final categoryPreferences = Map<String, bool>.from(
      currentSettings.categoryPreferences ?? {},
    );
    categoryPreferences[category] = enabled;
    
    final updatedSettings = currentSettings.copyWith(
      categoryPreferences: categoryPreferences,
    );
    
    await updateSettings(updatedSettings);
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
    _logger.d('🧹 Notification logs cleared');
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
      
      _logger.i('✅ Tokens refreshed');
      
    } catch (e) {
      _logger.e('Failed to refresh tokens', error: e);
      
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
  final NotificationSettings? settings;
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
    NotificationSettings? settings,
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