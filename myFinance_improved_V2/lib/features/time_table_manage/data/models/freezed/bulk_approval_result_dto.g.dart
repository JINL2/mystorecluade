// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bulk_approval_result_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BulkApprovalResultDtoImpl _$$BulkApprovalResultDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$BulkApprovalResultDtoImpl(
      totalProcessed: (json['total_processed'] as num?)?.toInt() ?? 0,
      successCount: (json['success_count'] as num?)?.toInt() ?? 0,
      failureCount: (json['failure_count'] as num?)?.toInt() ?? 0,
      successfulIds: (json['successful_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      errors: (json['errors'] as List<dynamic>?)
              ?.map((e) =>
                  BulkApprovalErrorDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$BulkApprovalResultDtoImplToJson(
        _$BulkApprovalResultDtoImpl instance) =>
    <String, dynamic>{
      'total_processed': instance.totalProcessed,
      'success_count': instance.successCount,
      'failure_count': instance.failureCount,
      'successful_ids': instance.successfulIds,
      'errors': instance.errors,
    };

_$BulkApprovalErrorDtoImpl _$$BulkApprovalErrorDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$BulkApprovalErrorDtoImpl(
      shiftRequestId: json['shift_request_id'] as String? ?? '',
      errorMessage: json['error_message'] as String? ?? '',
      errorCode: json['error_code'] as String?,
    );

Map<String, dynamic> _$$BulkApprovalErrorDtoImplToJson(
        _$BulkApprovalErrorDtoImpl instance) =>
    <String, dynamic>{
      'shift_request_id': instance.shiftRequestId,
      'error_message': instance.errorMessage,
      'error_code': instance.errorCode,
    };
