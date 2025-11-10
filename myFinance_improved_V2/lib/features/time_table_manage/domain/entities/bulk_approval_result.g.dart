// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bulk_approval_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BulkApprovalResultImpl _$$BulkApprovalResultImplFromJson(
        Map<String, dynamic> json) =>
    _$BulkApprovalResultImpl(
      totalProcessed: (json['total_processed'] as num).toInt(),
      successCount: (json['success_count'] as num).toInt(),
      failureCount: (json['failure_count'] as num).toInt(),
      successfulIds: (json['successful_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      errors: (json['errors'] as List<dynamic>?)
              ?.map(
                  (e) => BulkApprovalError.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$$BulkApprovalResultImplToJson(
        _$BulkApprovalResultImpl instance) =>
    <String, dynamic>{
      'total_processed': instance.totalProcessed,
      'success_count': instance.successCount,
      'failure_count': instance.failureCount,
      'successful_ids': instance.successfulIds,
      'errors': instance.errors,
    };

_$BulkApprovalErrorImpl _$$BulkApprovalErrorImplFromJson(
        Map<String, dynamic> json) =>
    _$BulkApprovalErrorImpl(
      shiftRequestId: json['shift_request_id'] as String,
      errorMessage: json['error_message'] as String,
      errorCode: json['error_code'] as String?,
    );

Map<String, dynamic> _$$BulkApprovalErrorImplToJson(
        _$BulkApprovalErrorImpl instance) =>
    <String, dynamic>{
      'shift_request_id': instance.shiftRequestId,
      'error_message': instance.errorMessage,
      'error_code': instance.errorCode,
    };
