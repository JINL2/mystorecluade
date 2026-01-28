// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template_list_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TemplateListResponseDtoImpl _$$TemplateListResponseDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$TemplateListResponseDtoImpl(
      success: json['success'] as bool,
      data: json['data'] == null
          ? null
          : TemplateListDataDto.fromJson(json['data'] as Map<String, dynamic>),
      error: json['error'] as String?,
    );

Map<String, dynamic> _$$TemplateListResponseDtoImplToJson(
        _$TemplateListResponseDtoImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
      'error': instance.error,
    };

_$TemplateListDataDtoImpl _$$TemplateListDataDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$TemplateListDataDtoImpl(
      templates: (json['templates'] as List<dynamic>?)
              ?.map((e) =>
                  TemplateListItemDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      totalCount: (json['total_count'] as num?)?.toInt() ?? 0,
      hasMore: json['has_more'] as bool? ?? false,
    );

Map<String, dynamic> _$$TemplateListDataDtoImplToJson(
        _$TemplateListDataDtoImpl instance) =>
    <String, dynamic>{
      'templates': instance.templates,
      'total_count': instance.totalCount,
      'has_more': instance.hasMore,
    };

_$TemplateListItemDtoImpl _$$TemplateListItemDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$TemplateListItemDtoImpl(
      templateId: json['template_id'] as String,
      name: json['name'] as String,
      templateDescription: json['template_description'] as String?,
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
      tags: json['tags'] as Map<String, dynamic>? ?? const {},
      visibilityLevel: json['visibility_level'] as String,
      permission: json['permission'] as String,
      companyId: json['company_id'] as String,
      storeId: json['store_id'] as String?,
      counterpartyId: json['counterparty_id'] as String?,
      counterpartyCashLocationId:
          json['counterparty_cash_location_id'] as String?,
      createdBy: json['created_by'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      updatedBy: json['updated_by'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      requiredAttachment: json['required_attachment'] as bool? ?? false,
    );

Map<String, dynamic> _$$TemplateListItemDtoImplToJson(
        _$TemplateListItemDtoImpl instance) =>
    <String, dynamic>{
      'template_id': instance.templateId,
      'name': instance.name,
      'template_description': instance.templateDescription,
      'data': instance.data,
      'tags': instance.tags,
      'visibility_level': instance.visibilityLevel,
      'permission': instance.permission,
      'company_id': instance.companyId,
      'store_id': instance.storeId,
      'counterparty_id': instance.counterpartyId,
      'counterparty_cash_location_id': instance.counterpartyCashLocationId,
      'created_by': instance.createdBy,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'updated_by': instance.updatedBy,
      'is_active': instance.isActive,
      'required_attachment': instance.requiredAttachment,
    };
