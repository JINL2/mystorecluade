// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_notification_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReportNotificationDtoImpl _$$ReportNotificationDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ReportNotificationDtoImpl(
      notificationId: json['notification_id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      isRead: json['is_read'] as bool,
      sentAt: json['sent_at'] == null
          ? null
          : DateTime.parse(json['sent_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      reportDate: DateTime.parse(json['report_date'] as String),
      sessionId: json['session_id'] as String?,
      templateId: json['template_id'] as String?,
      subscriptionId: json['subscription_id'] as String?,
      templateName: json['template_name'] as String?,
      templateCode: json['template_code'] as String?,
      templateIcon: json['template_icon'] as String?,
      templateFrequency: json['template_frequency'] as String?,
      categoryId: json['category_id'] as String?,
      categoryName: json['category_name'] as String?,
      sessionStatus: json['session_status'] as String?,
      sessionStartedAt: json['session_started_at'] == null
          ? null
          : DateTime.parse(json['session_started_at'] as String),
      sessionCompletedAt: json['session_completed_at'] == null
          ? null
          : DateTime.parse(json['session_completed_at'] as String),
      sessionErrorMessage: json['session_error_message'] as String?,
      processingTimeMs: (json['processing_time_ms'] as num?)?.toInt(),
      subscriptionEnabled: json['subscription_enabled'] as bool?,
      subscriptionScheduleTime: json['subscription_schedule_time'] as String?,
      subscriptionScheduleDays:
          (json['subscription_schedule_days'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList(),
      storeId: json['store_id'] as String?,
      storeName: json['store_name'] as String?,
    );

Map<String, dynamic> _$$ReportNotificationDtoImplToJson(
        _$ReportNotificationDtoImpl instance) =>
    <String, dynamic>{
      'notification_id': instance.notificationId,
      'title': instance.title,
      'body': instance.body,
      'is_read': instance.isRead,
      'sent_at': instance.sentAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'report_date': instance.reportDate.toIso8601String(),
      'session_id': instance.sessionId,
      'template_id': instance.templateId,
      'subscription_id': instance.subscriptionId,
      'template_name': instance.templateName,
      'template_code': instance.templateCode,
      'template_icon': instance.templateIcon,
      'template_frequency': instance.templateFrequency,
      'category_id': instance.categoryId,
      'category_name': instance.categoryName,
      'session_status': instance.sessionStatus,
      'session_started_at': instance.sessionStartedAt?.toIso8601String(),
      'session_completed_at': instance.sessionCompletedAt?.toIso8601String(),
      'session_error_message': instance.sessionErrorMessage,
      'processing_time_ms': instance.processingTimeMs,
      'subscription_enabled': instance.subscriptionEnabled,
      'subscription_schedule_time': instance.subscriptionScheduleTime,
      'subscription_schedule_days': instance.subscriptionScheduleDays,
      'store_id': instance.storeId,
      'store_name': instance.storeName,
    };
