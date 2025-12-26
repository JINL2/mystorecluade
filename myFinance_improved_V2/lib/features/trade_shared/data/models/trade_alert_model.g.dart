// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trade_alert_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TradeAlertModelImpl _$$TradeAlertModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TradeAlertModelImpl(
      id: json['alert_id'] as String,
      companyId: json['company_id'] as String,
      entityType: json['entity_type'] as String,
      entityId: json['entity_id'] as String,
      entityNumber: json['entity_number'] as String?,
      alertType: json['alert_type'] as String,
      title: json['title'] as String,
      message: json['message'] as String?,
      actionUrl: json['action_url'] as String?,
      dueDate: json['due_date'] == null
          ? null
          : DateTime.parse(json['due_date'] as String),
      daysBeforeDue: (json['days_before_due'] as num?)?.toInt(),
      priority: json['priority'] as String? ?? 'medium',
      isRead: json['is_read'] as bool? ?? false,
      isDismissed: json['is_dismissed'] as bool? ?? false,
      isResolved: json['is_resolved'] as bool? ?? false,
      isSystemGenerated: json['is_system_generated'] as bool? ?? true,
      assignedTo: json['assigned_to'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      readAt: json['read_at'] == null
          ? null
          : DateTime.parse(json['read_at'] as String),
      dismissedAt: json['dismissed_at'] == null
          ? null
          : DateTime.parse(json['dismissed_at'] as String),
      resolvedAt: json['resolved_at'] == null
          ? null
          : DateTime.parse(json['resolved_at'] as String),
    );

Map<String, dynamic> _$$TradeAlertModelImplToJson(
        _$TradeAlertModelImpl instance) =>
    <String, dynamic>{
      'alert_id': instance.id,
      'company_id': instance.companyId,
      'entity_type': instance.entityType,
      'entity_id': instance.entityId,
      'entity_number': instance.entityNumber,
      'alert_type': instance.alertType,
      'title': instance.title,
      'message': instance.message,
      'action_url': instance.actionUrl,
      'due_date': instance.dueDate?.toIso8601String(),
      'days_before_due': instance.daysBeforeDue,
      'priority': instance.priority,
      'is_read': instance.isRead,
      'is_dismissed': instance.isDismissed,
      'is_resolved': instance.isResolved,
      'is_system_generated': instance.isSystemGenerated,
      'assigned_to': instance.assignedTo,
      'created_at': instance.createdAt.toIso8601String(),
      'read_at': instance.readAt?.toIso8601String(),
      'dismissed_at': instance.dismissedAt?.toIso8601String(),
      'resolved_at': instance.resolvedAt?.toIso8601String(),
    };

_$PaginationInfoImpl _$$PaginationInfoImplFromJson(Map<String, dynamic> json) =>
    _$PaginationInfoImpl(
      page: (json['page'] as num?)?.toInt() ?? 1,
      pageSize: (json['page_size'] as num?)?.toInt() ?? 20,
      totalCount: (json['total_count'] as num?)?.toInt() ?? 0,
      totalPages: (json['total_pages'] as num?)?.toInt() ?? 0,
      hasNext: json['has_next'] as bool? ?? false,
      hasPrev: json['has_prev'] as bool? ?? false,
    );

Map<String, dynamic> _$$PaginationInfoImplToJson(
        _$PaginationInfoImpl instance) =>
    <String, dynamic>{
      'page': instance.page,
      'page_size': instance.pageSize,
      'total_count': instance.totalCount,
      'total_pages': instance.totalPages,
      'has_next': instance.hasNext,
      'has_prev': instance.hasPrev,
    };
