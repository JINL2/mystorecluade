// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_approval_result_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShiftApprovalResultDtoImpl _$$ShiftApprovalResultDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ShiftApprovalResultDtoImpl(
      shiftRequestId: json['shift_request_id'] as String? ?? '',
      isApproved: json['is_approved'] as bool? ?? false,
      approvedAt: json['approved_at'] as String? ?? '',
      approvedBy: json['approved_by'] as String?,
      updatedRequest: ShiftRequestDto.fromJson(
          json['updated_request'] as Map<String, dynamic>),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$$ShiftApprovalResultDtoImplToJson(
        _$ShiftApprovalResultDtoImpl instance) =>
    <String, dynamic>{
      'shift_request_id': instance.shiftRequestId,
      'is_approved': instance.isApproved,
      'approved_at': instance.approvedAt,
      'approved_by': instance.approvedBy,
      'updated_request': instance.updatedRequest,
      'message': instance.message,
    };
