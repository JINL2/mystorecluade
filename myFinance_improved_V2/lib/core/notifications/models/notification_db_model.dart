import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_db_model.freezed.dart';
part 'notification_db_model.g.dart';

/// Database model for notifications table
@freezed
class NotificationDbModel with _$NotificationDbModel {
  const factory NotificationDbModel({
    String? id,
    @JsonKey(name: 'user_id') String? userId,
    String? title,
    String? body,
    String? category,
    Map<String, dynamic>? data,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'action_url') String? actionUrl,
    @Default(false) @JsonKey(name: 'is_read') bool isRead,
    @JsonKey(name: 'scheduled_time') DateTime? scheduledTime,
    @JsonKey(name: 'sent_at') DateTime? sentAt,
    @JsonKey(name: 'read_at') DateTime? readAt,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _NotificationDbModel;

  factory NotificationDbModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationDbModelFromJson(json);
}

/// Database model for user_fcm_tokens table
@freezed
class UserFcmTokenModel with _$UserFcmTokenModel {
  const factory UserFcmTokenModel({
    String? id,
    @JsonKey(name: 'user_id') String? userId,
    String? token,
    String? platform, // ios/android/web
    @JsonKey(name: 'device_id') String? deviceId,
    @JsonKey(name: 'device_model') String? deviceModel,
    @JsonKey(name: 'app_version') String? appVersion,
    @Default(true) @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'last_used_at') DateTime? lastUsedAt,
  }) = _UserFcmTokenModel;

  factory UserFcmTokenModel.fromJson(Map<String, dynamic> json) =>
      _$UserFcmTokenModelFromJson(json);
}

/// Database model for user_notification_settings table
@freezed
class UserNotificationSettingsModel with _$UserNotificationSettingsModel {
  const factory UserNotificationSettingsModel({
    String? id,
    @JsonKey(name: 'user_id') String? userId,
    @Default(true) @JsonKey(name: 'push_enabled') bool pushEnabled,
    @Default(true) @JsonKey(name: 'email_enabled') bool emailEnabled,
    @Default(true) @JsonKey(name: 'transaction_alerts') bool transactionAlerts,
    @Default(true) bool reminders,
    @Default(true) @JsonKey(name: 'marketing_messages') bool marketingMessages,
    @Default('default') @JsonKey(name: 'sound_preference') String soundPreference,
    @Default(true) @JsonKey(name: 'vibration_enabled') bool vibrationEnabled,
    @Default({}) @JsonKey(name: 'category_preferences') Map<String, dynamic> categoryPreferences,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _UserNotificationSettingsModel;

  factory UserNotificationSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$UserNotificationSettingsModelFromJson(json);
}

