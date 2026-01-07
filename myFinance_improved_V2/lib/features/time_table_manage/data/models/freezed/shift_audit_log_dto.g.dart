// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_audit_log_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShiftAuditLogDtoImpl _$$ShiftAuditLogDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ShiftAuditLogDtoImpl(
      auditId: json['audit_id'] as String? ?? '',
      shiftRequestId: json['shift_request_id'] as String? ?? '',
      operation: json['operation'] as String? ?? '',
      actionType: json['action_type'] as String? ?? '',
      eventType: json['event_type'] as String?,
      changedColumns: (json['changed_columns'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      changeDetails: json['change_details'] as Map<String, dynamic>?,
      changedBy: json['changed_by'] as String?,
      changedByName: json['changed_by_name'] as String?,
      changedByProfileImage: json['changed_by_profile_image'] as String?,
      changedAt: json['changed_at'] as String?,
      reason: json['reason'] as String?,
      newData: json['new_data'] as Map<String, dynamic>?,
      oldData: json['old_data'] as Map<String, dynamic>?,
      profiles: json['profiles'] as Map<String, dynamic>?,
      eventData: json['event_data'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$ShiftAuditLogDtoImplToJson(
        _$ShiftAuditLogDtoImpl instance) =>
    <String, dynamic>{
      'audit_id': instance.auditId,
      'shift_request_id': instance.shiftRequestId,
      'operation': instance.operation,
      'action_type': instance.actionType,
      'event_type': instance.eventType,
      'changed_columns': instance.changedColumns,
      'change_details': instance.changeDetails,
      'changed_by': instance.changedBy,
      'changed_by_name': instance.changedByName,
      'changed_by_profile_image': instance.changedByProfileImage,
      'changed_at': instance.changedAt,
      'reason': instance.reason,
      'new_data': instance.newData,
      'old_data': instance.oldData,
      'profiles': instance.profiles,
      'event_data': instance.eventData,
    };
