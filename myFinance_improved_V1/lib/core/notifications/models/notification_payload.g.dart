// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationPayloadImpl _$$NotificationPayloadImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationPayloadImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      category: json['category'] as String?,
      data: json['data'] as Map<String, dynamic>?,
      imageUrl: json['imageUrl'] as String?,
      actionUrl: json['actionUrl'] as String?,
      scheduledTime: json['scheduledTime'] == null
          ? null
          : DateTime.parse(json['scheduledTime'] as String),
      isRead: json['isRead'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$NotificationPayloadImplToJson(
        _$NotificationPayloadImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'category': instance.category,
      'data': instance.data,
      'imageUrl': instance.imageUrl,
      'actionUrl': instance.actionUrl,
      'scheduledTime': instance.scheduledTime?.toIso8601String(),
      'isRead': instance.isRead,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$NotificationSettingsImpl _$$NotificationSettingsImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationSettingsImpl(
      userId: json['userId'] as String,
      pushEnabled: json['pushEnabled'] as bool? ?? true,
      emailEnabled: json['emailEnabled'] as bool? ?? true,
      transactionAlerts: json['transactionAlerts'] as bool? ?? true,
      reminders: json['reminders'] as bool? ?? true,
      marketingMessages: json['marketingMessages'] as bool? ?? true,
      soundPreference: json['soundPreference'] as String? ?? 'default',
      vibrationEnabled: json['vibrationEnabled'] as bool? ?? true,
      categoryPreferences:
          (json['categoryPreferences'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as bool),
      ),
    );

Map<String, dynamic> _$$NotificationSettingsImplToJson(
        _$NotificationSettingsImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'pushEnabled': instance.pushEnabled,
      'emailEnabled': instance.emailEnabled,
      'transactionAlerts': instance.transactionAlerts,
      'reminders': instance.reminders,
      'marketingMessages': instance.marketingMessages,
      'soundPreference': instance.soundPreference,
      'vibrationEnabled': instance.vibrationEnabled,
      'categoryPreferences': instance.categoryPreferences,
    };

_$FcmTokenImpl _$$FcmTokenImplFromJson(Map<String, dynamic> json) =>
    _$FcmTokenImpl(
      token: json['token'] as String,
      userId: json['userId'] as String,
      platform: json['platform'] as String,
      deviceId: json['deviceId'] as String?,
      deviceModel: json['deviceModel'] as String?,
      appVersion: json['appVersion'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      lastUsedAt: json['lastUsedAt'] == null
          ? null
          : DateTime.parse(json['lastUsedAt'] as String),
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$$FcmTokenImplToJson(_$FcmTokenImpl instance) =>
    <String, dynamic>{
      'token': instance.token,
      'userId': instance.userId,
      'platform': instance.platform,
      'deviceId': instance.deviceId,
      'deviceModel': instance.deviceModel,
      'appVersion': instance.appVersion,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'lastUsedAt': instance.lastUsedAt?.toIso8601String(),
      'isActive': instance.isActive,
    };
