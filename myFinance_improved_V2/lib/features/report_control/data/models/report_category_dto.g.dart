// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_category_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReportCategoryDtoImpl _$$ReportCategoryDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ReportCategoryDtoImpl(
      categoryId: json['category_id'] as String,
      categoryName: json['category_name'] as String,
      categoryIcon: json['category_icon'] as String?,
      templateCount: (json['template_count'] as num).toInt(),
      reportCount: (json['report_count'] as num).toInt(),
      unreadCount: (json['unread_count'] as num).toInt(),
      latestReportDate: json['latest_report_date'] == null
          ? null
          : DateTime.parse(json['latest_report_date'] as String),
    );

Map<String, dynamic> _$$ReportCategoryDtoImplToJson(
        _$ReportCategoryDtoImpl instance) =>
    <String, dynamic>{
      'category_id': instance.categoryId,
      'category_name': instance.categoryName,
      'category_icon': instance.categoryIcon,
      'template_count': instance.templateCount,
      'report_count': instance.reportCount,
      'unread_count': instance.unreadCount,
      'latest_report_date': instance.latestReportDate?.toIso8601String(),
    };
