import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Notification display modes (moved outside class to fix compilation error)
enum NotificationMode {
  legacy,        // Old intrusive overlay system (deprecated)
  ambient,       // Badge only, no interruptions (recommended)
  smartToast,    // Non-blocking auto-dismissing toasts
  hybrid,        // Badge + smart toasts for critical notifications
  silent,        // Badge only, no visual notifications
}

/// Notification display configuration for managing how notifications appear
/// This provides a delicate transition from intrusive overlays to ambient notifications
class NotificationDisplayConfig {
  static final NotificationDisplayConfig _instance = NotificationDisplayConfig._internal();
  factory NotificationDisplayConfig() => _instance;
  NotificationDisplayConfig._internal();

  // Feature flags for gradual rollout
  static const String _keyInAppOverlayEnabled = 'in_app_overlay_enabled';
  static const String _keySmartToastEnabled = 'smart_toast_enabled';
  static const String _keyBadgeAnimationEnabled = 'badge_animation_enabled';
  static const String _keyAutoMarkAsRead = 'auto_mark_as_read';
  static const String _keyNotificationMode = 'notification_mode';
  static const String _keyToastDuration = 'toast_duration_seconds';
  static const String _keyQuietHoursEnabled = 'quiet_hours_enabled';
  static const String _keyQuietHoursStart = 'quiet_hours_start';
  static const String _keyQuietHoursEnd = 'quiet_hours_end';

  late SharedPreferences _prefs;
  bool _isInitialized = false;

  // Default configuration (optimized for user experience)
  // IMPORTANT: We default to silent mode - NO in-app notifications at all
  NotificationMode _currentMode = NotificationMode.silent;
  bool _inAppOverlayEnabled = false;  // PERMANENTLY DISABLED
  bool _smartToastEnabled = false;  // DISABLED - No toasts
  bool _badgeAnimationEnabled = true;  // Keep badge animation
  bool _autoMarkAsRead = true;  // Auto-mark notifications as read when viewed
  int _toastDurationSeconds = 3;
  bool _quietHoursEnabled = false;
  TimeOfDay _quietHoursStart = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _quietHoursEnd = const TimeOfDay(hour: 7, minute: 0);

  // Callbacks for UI updates
  final List<VoidCallback> _listeners = [];

  Future<void> initialize() async {
    if (_isInitialized) return;

    _prefs = await SharedPreferences.getInstance();
    await _loadConfiguration();
    _isInitialized = true;
  }

  Future<void> _loadConfiguration() async {
    // FORCE SILENT MODE - Complete removal of in-app notifications
    // Always default to silent mode regardless of stored preference
    _currentMode = NotificationMode.silent;
    
    // Override any stored preferences - NO IN-APP NOTIFICATIONS
    _inAppOverlayEnabled = false;  // Force disabled
    _smartToastEnabled = false;     // Force disabled
    _badgeAnimationEnabled = _prefs.getBool(_keyBadgeAnimationEnabled) ?? true;
    _autoMarkAsRead = _prefs.getBool(_keyAutoMarkAsRead) ?? true;
    _toastDurationSeconds = _prefs.getInt(_keyToastDuration) ?? 3;
    _quietHoursEnabled = _prefs.getBool(_keyQuietHoursEnabled) ?? false;

    // Load quiet hours
    final startHour = _prefs.getInt(_keyQuietHoursStart) ?? 22;
    final endHour = _prefs.getInt(_keyQuietHoursEnd) ?? 7;
    _quietHoursStart = TimeOfDay(hour: startHour, minute: 0);
    _quietHoursEnd = TimeOfDay(hour: endHour, minute: 0);
  }

  // Getters
  NotificationMode get currentMode => _currentMode;
  bool get isInAppOverlayEnabled => _inAppOverlayEnabled && _currentMode == NotificationMode.legacy;
  bool get isSmartToastEnabled => _smartToastEnabled && 
    (_currentMode == NotificationMode.smartToast || _currentMode == NotificationMode.hybrid);
  bool get isBadgeAnimationEnabled => _badgeAnimationEnabled;
  bool get isAutoMarkAsReadEnabled => _autoMarkAsRead;
  int get toastDurationSeconds => _toastDurationSeconds;
  bool get isQuietHoursEnabled => _quietHoursEnabled;
  bool get shouldShowNotifications => !_isInQuietHours();

  // Check if current time is within quiet hours
  bool _isInQuietHours() {
    if (!_quietHoursEnabled) return false;

    final now = TimeOfDay.now();
    final nowMinutes = now.hour * 60 + now.minute;
    final startMinutes = _quietHoursStart.hour * 60 + _quietHoursStart.minute;
    final endMinutes = _quietHoursEnd.hour * 60 + _quietHoursEnd.minute;

    if (startMinutes <= endMinutes) {
      return nowMinutes >= startMinutes && nowMinutes < endMinutes;
    } else {
      // Quiet hours span midnight
      return nowMinutes >= startMinutes || nowMinutes < endMinutes;
    }
  }

  // Setters with persistence
  Future<void> setNotificationMode(NotificationMode mode) async {
    _currentMode = mode;
    await _prefs.setInt(_keyNotificationMode, mode.index);
    
    // Automatically adjust related settings for better UX
    if (mode == NotificationMode.ambient || mode == NotificationMode.silent) {
      await setInAppOverlayEnabled(false);
    }
    
    _notifyListeners();
  }

  Future<void> setInAppOverlayEnabled(bool enabled) async {
    _inAppOverlayEnabled = enabled;
    await _prefs.setBool(_keyInAppOverlayEnabled, enabled);
    _notifyListeners();
  }

  Future<void> setSmartToastEnabled(bool enabled) async {
    _smartToastEnabled = enabled;
    await _prefs.setBool(_keySmartToastEnabled, enabled);
    _notifyListeners();
  }

  Future<void> setBadgeAnimationEnabled(bool enabled) async {
    _badgeAnimationEnabled = enabled;
    await _prefs.setBool(_keyBadgeAnimationEnabled, enabled);
    _notifyListeners();
  }

  Future<void> setAutoMarkAsRead(bool enabled) async {
    _autoMarkAsRead = enabled;
    await _prefs.setBool(_keyAutoMarkAsRead, enabled);
    _notifyListeners();
  }

  Future<void> setToastDuration(int seconds) async {
    _toastDurationSeconds = seconds.clamp(1, 10);
    await _prefs.setInt(_keyToastDuration, _toastDurationSeconds);
    _notifyListeners();
  }

  Future<void> setQuietHours({
    required bool enabled,
    TimeOfDay? start,
    TimeOfDay? end,
  }) async {
    _quietHoursEnabled = enabled;
    if (start != null) _quietHoursStart = start;
    if (end != null) _quietHoursEnd = end;

    await _prefs.setBool(_keyQuietHoursEnabled, enabled);
    await _prefs.setInt(_keyQuietHoursStart, _quietHoursStart.hour);
    await _prefs.setInt(_keyQuietHoursEnd, _quietHoursEnd.hour);
    
    _notifyListeners();
  }

  // Migration helper - gradually move users to better notification experience
  Future<void> migrateToAmbientMode() async {
    // This method helps transition users from intrusive to ambient notifications
    if (_currentMode == NotificationMode.legacy) {
      await setNotificationMode(NotificationMode.ambient);
      await setInAppOverlayEnabled(false);
      await setSmartToastEnabled(true);
      await setBadgeAnimationEnabled(true);
      await setAutoMarkAsRead(true);
    }
  }

  // Listener management for reactive UI updates
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  void _notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }
  }

  // Analytics helper to track notification interaction patterns
  Map<String, dynamic> getAnalyticsData() {
    return {
      'mode': _currentMode.toString(),
      'in_app_overlay': _inAppOverlayEnabled,
      'smart_toast': _smartToastEnabled,
      'badge_animation': _badgeAnimationEnabled,
      'auto_mark_read': _autoMarkAsRead,
      'quiet_hours': _quietHoursEnabled,
      'toast_duration': _toastDurationSeconds,
    };
  }
}