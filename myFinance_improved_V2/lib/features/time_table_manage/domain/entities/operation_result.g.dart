// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operation_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OperationResultImpl _$$OperationResultImplFromJson(
        Map<String, dynamic> json) =>
    _$OperationResultImpl(
      success: json['success'] as bool,
      message: json['message'] as String?,
      errorCode: json['error_code'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>? ?? {},
    );

Map<String, dynamic> _$$OperationResultImplToJson(
        _$OperationResultImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'error_code': instance.errorCode,
      'metadata': instance.metadata,
    };
