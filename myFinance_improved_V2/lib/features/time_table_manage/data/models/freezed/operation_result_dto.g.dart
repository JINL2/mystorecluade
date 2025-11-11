// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operation_result_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OperationResultDtoImpl _$$OperationResultDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$OperationResultDtoImpl(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
      errorCode: json['error_code'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$OperationResultDtoImplToJson(
        _$OperationResultDtoImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'error_code': instance.errorCode,
      'metadata': instance.metadata,
    };
