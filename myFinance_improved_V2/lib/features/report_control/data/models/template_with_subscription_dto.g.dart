// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template_with_subscription_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TemplateWithSubscriptionDtoImpl _$$TemplateWithSubscriptionDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$TemplateWithSubscriptionDtoImpl(
      templateId: json['template_id'] as String,
      templateName: json['template_name'] as String,
      templateCode: json['template_code'] as String,
      description: json['description'] as String?,
      frequency: json['frequency'] as String,
      icon: json['icon'] as String?,
      displayOrder: (json['display_order'] as num?)?.toInt(),
      defaultScheduleTime: json['default_schedule_time'] as String?,
      defaultScheduleDays: (json['default_schedule_days'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      defaultMonthlyDay: (json['default_monthly_day'] as num?)?.toInt(),
      categoryId: json['category_id'] as String?,
      categoryName: json['category_name'] as String?,
      isSubscribed: json['is_subscribed'] as bool,
      subscriptionId: json['subscription_id'] as String?,
      subscriptionEnabled: json['subscription_enabled'] as bool?,
      subscriptionScheduleTime: json['subscription_schedule_time'] as String?,
      subscriptionScheduleDays:
          (json['subscription_schedule_days'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList(),
      subscriptionMonthlySendDay:
          (json['subscription_monthly_send_day'] as num?)?.toInt(),
      subscriptionTimezone: json['subscription_timezone'] as String?,
      subscriptionLastSentAt: json['subscription_last_sent_at'] == null
          ? null
          : DateTime.parse(json['subscription_last_sent_at'] as String),
      subscriptionNextScheduledAt: json['subscription_next_scheduled_at'] ==
              null
          ? null
          : DateTime.parse(json['subscription_next_scheduled_at'] as String),
      subscriptionCreatedAt: json['subscription_created_at'] == null
          ? null
          : DateTime.parse(json['subscription_created_at'] as String),
      storeId: json['store_id'] as String?,
      storeName: json['store_name'] as String?,
      recentReportsCount: (json['recent_reports_count'] as num?)?.toInt() ?? 0,
      lastReportDate: json['last_report_date'] == null
          ? null
          : DateTime.parse(json['last_report_date'] as String),
      lastReportStatus: json['last_report_status'] as String?,
    );

Map<String, dynamic> _$$TemplateWithSubscriptionDtoImplToJson(
        _$TemplateWithSubscriptionDtoImpl instance) =>
    <String, dynamic>{
      'template_id': instance.templateId,
      'template_name': instance.templateName,
      'template_code': instance.templateCode,
      'description': instance.description,
      'frequency': instance.frequency,
      'icon': instance.icon,
      'display_order': instance.displayOrder,
      'default_schedule_time': instance.defaultScheduleTime,
      'default_schedule_days': instance.defaultScheduleDays,
      'default_monthly_day': instance.defaultMonthlyDay,
      'category_id': instance.categoryId,
      'category_name': instance.categoryName,
      'is_subscribed': instance.isSubscribed,
      'subscription_id': instance.subscriptionId,
      'subscription_enabled': instance.subscriptionEnabled,
      'subscription_schedule_time': instance.subscriptionScheduleTime,
      'subscription_schedule_days': instance.subscriptionScheduleDays,
      'subscription_monthly_send_day': instance.subscriptionMonthlySendDay,
      'subscription_timezone': instance.subscriptionTimezone,
      'subscription_last_sent_at':
          instance.subscriptionLastSentAt?.toIso8601String(),
      'subscription_next_scheduled_at':
          instance.subscriptionNextScheduledAt?.toIso8601String(),
      'subscription_created_at':
          instance.subscriptionCreatedAt?.toIso8601String(),
      'store_id': instance.storeId,
      'store_name': instance.storeName,
      'recent_reports_count': instance.recentReportsCount,
      'last_report_date': instance.lastReportDate?.toIso8601String(),
      'last_report_status': instance.lastReportStatus,
    };
