// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upsert_template_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UpsertTemplateResponseDtoImpl _$$UpsertTemplateResponseDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$UpsertTemplateResponseDtoImpl(
      success: json['success'] as bool,
      data: json['data'] == null
          ? null
          : UpsertTemplateDataDto.fromJson(
              json['data'] as Map<String, dynamic>),
      error: json['error'] as String?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$$UpsertTemplateResponseDtoImplToJson(
        _$UpsertTemplateResponseDtoImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
      'error': instance.error,
      'message': instance.message,
    };

_$UpsertTemplateDataDtoImpl _$$UpsertTemplateDataDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$UpsertTemplateDataDtoImpl(
      templateId: json['template_id'] as String,
      name: json['name'] as String,
      templateDescription: json['template_description'] as String?,
      visibilityLevel: json['visibility_level'] as String,
      permission: json['permission'] as String,
      companyId: json['company_id'] as String,
      storeId: json['store_id'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      requiredAttachment: json['required_attachment'] as bool? ?? false,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      createdBy: json['created_by'] as String?,
      updatedBy: json['updated_by'] as String?,
    );

Map<String, dynamic> _$$UpsertTemplateDataDtoImplToJson(
        _$UpsertTemplateDataDtoImpl instance) =>
    <String, dynamic>{
      'template_id': instance.templateId,
      'name': instance.name,
      'template_description': instance.templateDescription,
      'visibility_level': instance.visibilityLevel,
      'permission': instance.permission,
      'company_id': instance.companyId,
      'store_id': instance.storeId,
      'is_active': instance.isActive,
      'required_attachment': instance.requiredAttachment,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'created_by': instance.createdBy,
      'updated_by': instance.updatedBy,
    };
