// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template_rpc_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TemplateRpcResultSuccessImpl _$$TemplateRpcResultSuccessImplFromJson(
        Map<String, dynamic> json) =>
    _$TemplateRpcResultSuccessImpl(
      journalId: json['journalId'] as String,
      message: json['message'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$TemplateRpcResultSuccessImplToJson(
        _$TemplateRpcResultSuccessImpl instance) =>
    <String, dynamic>{
      'journalId': instance.journalId,
      'message': instance.message,
      'createdAt': instance.createdAt?.toIso8601String(),
      'runtimeType': instance.$type,
    };

_$TemplateRpcResultFailureImpl _$$TemplateRpcResultFailureImplFromJson(
        Map<String, dynamic> json) =>
    _$TemplateRpcResultFailureImpl(
      errorCode: json['errorCode'] as String,
      errorMessage: json['errorMessage'] as String,
      fieldErrors: (json['fieldErrors'] as List<dynamic>?)
              ?.map((e) => FieldError.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      isRecoverable: json['isRecoverable'] as bool? ?? true,
      technicalDetails: json['technicalDetails'] as String?,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$TemplateRpcResultFailureImplToJson(
        _$TemplateRpcResultFailureImpl instance) =>
    <String, dynamic>{
      'errorCode': instance.errorCode,
      'errorMessage': instance.errorMessage,
      'fieldErrors': instance.fieldErrors,
      'isRecoverable': instance.isRecoverable,
      'technicalDetails': instance.technicalDetails,
      'runtimeType': instance.$type,
    };

_$FieldErrorImpl _$$FieldErrorImplFromJson(Map<String, dynamic> json) =>
    _$FieldErrorImpl(
      fieldName: json['fieldName'] as String,
      message: json['message'] as String,
      invalidValue: json['invalidValue'] as String?,
      suggestion: json['suggestion'] as String?,
    );

Map<String, dynamic> _$$FieldErrorImplToJson(_$FieldErrorImpl instance) =>
    <String, dynamic>{
      'fieldName': instance.fieldName,
      'message': instance.message,
      'invalidValue': instance.invalidValue,
      'suggestion': instance.suggestion,
    };
