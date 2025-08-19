import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_payload.freezed.dart';
part 'notification_payload.g.dart';

/// Model for notification payloads with comprehensive data structure
@freezed
class NotificationPayload with _$NotificationPayload {
  const factory NotificationPayload({
    required String id,
    required String title,
    required String body,
    String? category,
    Map<String, dynamic>? data,
    String? imageUrl,
    String? actionUrl,
    DateTime? scheduledTime,
    @Default(false) bool isRead,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _NotificationPayload;

  factory NotificationPayload.fromJson(Map<String, dynamic> json) =>
      _$NotificationPayloadFromJson(json);
}

/// Model for notification settings per user
@freezed
class NotificationSettings with _$NotificationSettings {
  const factory NotificationSettings({
    required String userId,
    @Default(true) bool pushEnabled,
    @Default(true) bool emailEnabled,
    @Default(true) bool transactionAlerts,
    @Default(true) bool reminders,
    @Default(true) bool marketingMessages,
    @Default('default') String soundPreference,
    @Default(true) bool vibrationEnabled,
    Map<String, bool>? categoryPreferences,
  }) = _NotificationSettings;

  factory NotificationSettings.fromJson(Map<String, dynamic> json) =>
      _$NotificationSettingsFromJson(json);
}

/// Model for FCM token management
@freezed
class FcmToken with _$FcmToken {
  const factory FcmToken({
    required String token,
    required String userId,
    required String platform,
    String? deviceId,
    String? deviceModel,
    String? appVersion,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastUsedAt,
    @Default(true) bool isActive,
  }) = _FcmToken;

  factory FcmToken.fromJson(Map<String, dynamic> json) =>
      _$FcmTokenFromJson(json);
}