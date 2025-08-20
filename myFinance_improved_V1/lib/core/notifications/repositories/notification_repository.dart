import 'dart:io';
// import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/notification_db_model.dart';

/// Repository for managing notification data in Supabase
class NotificationRepository {
  static final NotificationRepository _instance = NotificationRepository._internal();
  factory NotificationRepository() => _instance;
  NotificationRepository._internal();

  final SupabaseClient _supabase = Supabase.instance.client;
  // final Logger _logger = Logger();

  // Table names
  static const String _notificationsTable = 'notifications';
  static const String _fcmTokensTable = 'user_fcm_tokens';
  static const String _settingsTable = 'user_notification_settings';

  /// Store notification in database
  Future<NotificationDbModel?> storeNotification({
    required String userId,
    required String title,
    required String body,
    String? category,
    Map<String, dynamic>? data,
    String? imageUrl,
    String? actionUrl,
    DateTime? scheduledTime,
  }) async {
    try {
      final now = DateTime.now().toUtc();
      
      final notificationData = {
        'user_id': userId,
        'title': title,
        'body': body,
        'category': category,
        'data': data,
        'image_url': imageUrl,
        'action_url': actionUrl,
        'scheduled_time': scheduledTime?.toUtc().toIso8601String(),
        'sent_at': now.toIso8601String(),
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      };

      final response = await _supabase
          .from(_notificationsTable)
          .insert(notificationData)
          .select()
          .single();

      // Notification stored in database
      return NotificationDbModel.fromJson(response);
      
    } catch (e, stackTrace) {
      // Failed to store notification: $e
      return null;
    }
  }

  /// Get user notifications with pagination
  Future<List<NotificationDbModel>> getUserNotifications({
    required String userId,
    int limit = 50,
    int offset = 0,
    bool? isRead,
  }) async {
    try {
      final queryBuilder = _supabase
          .from(_notificationsTable)
          .select()
          .eq('user_id', userId);

      final finalQuery = isRead != null 
          ? queryBuilder.eq('is_read', isRead)
          : queryBuilder;

      final response = await finalQuery
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);
      
      return response
          .map((json) => NotificationDbModel.fromJson(json))
          .toList();
          
    } catch (e) {
      // Failed to get user notifications: $e
      return [];
    }
  }

  /// Mark notification as read
  Future<bool> markAsRead(String notificationId) async {
    try {
      final now = DateTime.now().toUtc();
      await _supabase
          .from(_notificationsTable)
          .update({
            'is_read': true,
            'read_at': now.toIso8601String(),
            'updated_at': now.toIso8601String(),
          })
          .eq('id', notificationId);

      // Notification marked as read
      return true;
      
    } catch (e) {
      // Failed to mark notification as read: $e
      return false;
    }
  }

  /// Get unread notification count
  Future<int> getUnreadCount(String userId) async {
    try {
      final response = await _supabase
          .from(_notificationsTable)
          .select('id')
          .eq('user_id', userId)
          .eq('is_read', false)
          .count();

      return response.count ?? 0;
      
    } catch (e) {
      // Failed to get unread count: $e
      return 0;
    }
  }

  /// Store or update FCM token
  Future<UserFcmTokenModel?> storeOrUpdateFcmToken({
    required String userId,
    required String token,
    required String platform,
    String? deviceId,
    String? deviceModel,
    String? appVersion,
  }) async {
    try {
      final now = DateTime.now();
      
      // First, deactivate old tokens for this user/platform
      await _supabase
          .from(_fcmTokensTable)
          .update({
            'is_active': false,
            'updated_at': now.toIso8601String(),
          })
          .eq('user_id', userId)
          .eq('platform', platform);

      // Insert new token
      final tokenData = {
        'user_id': userId,
        'token': token,
        'platform': platform,
        'device_id': deviceId ?? 'unknown_${DateTime.now().millisecondsSinceEpoch}',
        'device_model': deviceModel ?? Platform.operatingSystem,
        'app_version': appVersion ?? '1.0.0',
        'is_active': true,
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
        'last_used_at': now.toIso8601String(),
      };

      final response = await _supabase
          .from(_fcmTokensTable)
          .insert(tokenData)
          .select()
          .single();

      // FCM token stored
      return UserFcmTokenModel.fromJson(response);
      
    } catch (e, stackTrace) {
      // Failed to store FCM token: $e
      return null;
    }
  }

  /// Update token last used time
  Future<bool> updateTokenLastUsed(String token) async {
    try {
      await _supabase
          .from(_fcmTokensTable)
          .update({
            'last_used_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('token', token)
          .eq('is_active', true);

      return true;
      
    } catch (e) {
      // Failed to update token last used: $e
      return false;
    }
  }

  /// Get active FCM tokens for user
  Future<List<UserFcmTokenModel>> getActiveFcmTokens(String userId) async {
    try {
      final response = await _supabase
          .from(_fcmTokensTable)
          .select()
          .eq('user_id', userId)
          .eq('is_active', true)
          .order('last_used_at', ascending: false);

      return response
          .map((json) => UserFcmTokenModel.fromJson(json))
          .toList();
          
    } catch (e) {
      // Failed to get active FCM tokens: $e
      return [];
    }
  }

  /// Get or create user notification settings
  Future<UserNotificationSettingsModel?> getUserSettings(String userId) async {
    try {
      // Try to get existing settings
      final response = await _supabase
          .from(_settingsTable)
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (response != null) {
        return UserNotificationSettingsModel.fromJson(response);
      }

      // Create default settings if none exist
      return await _createDefaultSettings(userId);
      
    } catch (e) {
      // Failed to get user settings: $e
      return null;
    }
  }

  /// Create default notification settings for user
  Future<UserNotificationSettingsModel?> _createDefaultSettings(String userId) async {
    try {
      final now = DateTime.now();
      
      final defaultSettings = {
        'user_id': userId,
        'push_enabled': true,
        'email_enabled': true,
        'transaction_alerts': true,
        'reminders': true,
        'marketing_messages': true,
        'sound_preference': 'default',
        'vibration_enabled': true,
        'category_preferences': <String, dynamic>{},
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      };

      final response = await _supabase
          .from(_settingsTable)
          .insert(defaultSettings)
          .select()
          .single();

      // Default notification settings created
      return UserNotificationSettingsModel.fromJson(response);
      
    } catch (e, stackTrace) {
      // Failed to create default settings: $e
      return null;
    }
  }

  /// Update user notification settings
  Future<UserNotificationSettingsModel?> updateUserSettings({
    required String userId,
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
      final updateData = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (pushEnabled != null) updateData['push_enabled'] = pushEnabled;
      if (emailEnabled != null) updateData['email_enabled'] = emailEnabled;
      if (transactionAlerts != null) updateData['transaction_alerts'] = transactionAlerts;
      if (reminders != null) updateData['reminders'] = reminders;
      if (marketingMessages != null) updateData['marketing_messages'] = marketingMessages;
      if (soundPreference != null) updateData['sound_preference'] = soundPreference;
      if (vibrationEnabled != null) updateData['vibration_enabled'] = vibrationEnabled;
      if (categoryPreferences != null) updateData['category_preferences'] = categoryPreferences;

      final response = await _supabase
          .from(_settingsTable)
          .update(updateData)
          .eq('user_id', userId)
          .select()
          .single();

      // Notification settings updated
      return UserNotificationSettingsModel.fromJson(response);
      
    } catch (e, stackTrace) {
      // Failed to update user settings: $e
      return null;
    }
  }

  /// Delete old inactive tokens (cleanup)
  Future<bool> cleanupOldTokens({int daysOld = 30}) async {
    try {
      final cutoffDate = DateTime.now().subtract(Duration(days: daysOld));
      
      await _supabase
          .from(_fcmTokensTable)
          .delete()
          .eq('is_active', false)
          .lt('updated_at', cutoffDate.toIso8601String());

      // Cleaned up old FCM tokens
      return true;
      
    } catch (e) {
      // Failed to cleanup old tokens: $e
      return false;
    }
  }

  /// Get notification statistics for user
  Future<Map<String, dynamic>> getNotificationStats(String userId) async {
    try {
      final totalResponse = await _supabase
          .from(_notificationsTable)
          .select('id')
          .eq('user_id', userId)
          .count();

      final unreadResponse = await _supabase
          .from(_notificationsTable)
          .select('id')
          .eq('user_id', userId)
          .eq('is_read', false)
          .count();

      final todayStart = DateTime.now().copyWith(hour: 0, minute: 0, second: 0);
      final todayResponse = await _supabase
          .from(_notificationsTable)
          .select('id')
          .eq('user_id', userId)
          .gte('created_at', todayStart.toIso8601String())
          .count();

      return {
        'total': totalResponse.count ?? 0,
        'unread': unreadResponse.count ?? 0,
        'today': todayResponse.count ?? 0,
      };
      
    } catch (e) {
      // Failed to get notification stats: $e
      return {
        'total': 0,
        'unread': 0,
        'today': 0,
      };
    }
  }
}