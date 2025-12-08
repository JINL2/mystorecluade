// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TemplateDtoImpl _$$TemplateDtoImplFromJson(Map<String, dynamic> json) =>
    _$TemplateDtoImpl(
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

Map<String, dynamic> _$$TemplateDtoImplToJson(_$TemplateDtoImpl instance) =>
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
