// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_db_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationDbModelImpl _$$NotificationDbModelImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationDbModelImpl(
      id: json['id'] as String?,
      userId: json['user_id'] as String?,
      title: json['title'] as String?,
      body: json['body'] as String?,
      category: json['category'] as String?,
      data: json['data'] as Map<String, dynamic>?,
      imageUrl: json['image_url'] as String?,
      actionUrl: json['action_url'] as String?,
      isRead: json['is_read'] as bool? ?? false,
      scheduledTime: json['scheduled_time'] == null
          ? null
          : DateTime.parse(json['scheduled_time'] as String),
      sentAt: json['sent_at'] == null
          ? null
          : DateTime.parse(json['sent_at'] as String),
      readAt: json['read_at'] == null
          ? null
          : DateTime.parse(json['read_at'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$NotificationDbModelImplToJson(
        _$NotificationDbModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'title': instance.title,
      'body': instance.body,
      'category': instance.category,
      'data': instance.data,
      'image_url': instance.imageUrl,
      'action_url': instance.actionUrl,
      'is_read': instance.isRead,
      'scheduled_time': instance.scheduledTime?.toIso8601String(),
      'sent_at': instance.sentAt?.toIso8601String(),
      'read_at': instance.readAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

_$UserFcmTokenModelImpl _$$UserFcmTokenModelImplFromJson(
        Map<String, dynamic> json) =>
    _$UserFcmTokenModelImpl(
      id: json['id'] as String?,
      userId: json['user_id'] as String?,
      token: json['token'] as String?,
      platform: json['platform'] as String?,
      deviceId: json['device_id'] as String?,
      deviceModel: json['device_model'] as String?,
      appVersion: json['app_version'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      lastUsedAt: json['last_used_at'] == null
          ? null
          : DateTime.parse(json['last_used_at'] as String),
    );

Map<String, dynamic> _$$UserFcmTokenModelImplToJson(
        _$UserFcmTokenModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'token': instance.token,
      'platform': instance.platform,
      'device_id': instance.deviceId,
      'device_model': instance.deviceModel,
      'app_version': instance.appVersion,
      'is_active': instance.isActive,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'last_used_at': instance.lastUsedAt?.toIso8601String(),
    };

_$UserNotificationSettingsModelImpl
    _$$UserNotificationSettingsModelImplFromJson(Map<String, dynamic> json) =>
        _$UserNotificationSettingsModelImpl(
          id: json['id'] as String?,
          userId: json['user_id'] as String?,
          pushEnabled: json['push_enabled'] as bool? ?? true,
          emailEnabled: json['email_enabled'] as bool? ?? true,
          transactionAlerts: json['transaction_alerts'] as bool? ?? true,
          reminders: json['reminders'] as bool? ?? true,
          marketingMessages: json['marketing_messages'] as bool? ?? true,
          soundPreference: json['sound_preference'] as String? ?? 'default',
          vibrationEnabled: json['vibration_enabled'] as bool? ?? true,
          categoryPreferences:
              json['category_preferences'] as Map<String, dynamic>? ?? const {},
          createdAt: json['created_at'] == null
              ? null
              : DateTime.parse(json['created_at'] as String),
          updatedAt: json['updated_at'] == null
              ? null
              : DateTime.parse(json['updated_at'] as String),
        );

Map<String, dynamic> _$$UserNotificationSettingsModelImplToJson(
        _$UserNotificationSettingsModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'push_enabled': instance.pushEnabled,
      'email_enabled': instance.emailEnabled,
      'transaction_alerts': instance.transactionAlerts,
      'reminders': instance.reminders,
      'marketing_messages': instance.marketingMessages,
      'sound_preference': instance.soundPreference,
      'vibration_enabled': instance.vibrationEnabled,
      'category_preferences': instance.categoryPreferences,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
