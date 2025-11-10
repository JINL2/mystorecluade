// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_approval_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShiftApprovalResultImpl _$$ShiftApprovalResultImplFromJson(
        Map<String, dynamic> json) =>
    _$ShiftApprovalResultImpl(
      shiftRequestId: json['shift_request_id'] as String,
      isApproved: json['is_approved'] as bool,
      approvedAt: DateTime.parse(json['approved_at'] as String),
      approvedBy: json['approved_by'] as String?,
      updatedRequest: ShiftRequest.fromJson(
          json['updated_request'] as Map<String, dynamic>),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$$ShiftApprovalResultImplToJson(
        _$ShiftApprovalResultImpl instance) =>
    <String, dynamic>{
      'shift_request_id': instance.shiftRequestId,
      'is_approved': instance.isApproved,
      'approved_at': instance.approvedAt.toIso8601String(),
      'approved_by': instance.approvedBy,
      'updated_request': instance.updatedRequest,
      'message': instance.message,
    };
