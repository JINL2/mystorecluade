// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_template_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DeleteTemplateResponseDtoImpl _$$DeleteTemplateResponseDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$DeleteTemplateResponseDtoImpl(
      success: json['success'] as bool,
      error: json['error'] as String?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : DeleteTemplateDataDto.fromJson(
              json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$DeleteTemplateResponseDtoImplToJson(
        _$DeleteTemplateResponseDtoImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'error': instance.error,
      'message': instance.message,
      'data': instance.data,
    };

_$DeleteTemplateDataDtoImpl _$$DeleteTemplateDataDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$DeleteTemplateDataDtoImpl(
      templateId: json['template_id'] as String,
      deletedAt: json['deleted_at'] as String?,
    );

Map<String, dynamic> _$$DeleteTemplateDataDtoImplToJson(
        _$DeleteTemplateDataDtoImpl instance) =>
    <String, dynamic>{
      'template_id': instance.templateId,
      'deleted_at': instance.deletedAt,
    };
