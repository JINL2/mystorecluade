// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delegation_audit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DelegationAuditModelImpl _$$DelegationAuditModelImplFromJson(
        Map<String, dynamic> json) =>
    _$DelegationAuditModelImpl(
      id: json['id'] as String,
      delegationId: json['delegationId'] as String,
      action: json['action'] as String,
      performedBy: json['performedBy'] as String,
      performedByUser: json['performedByUser'] as Map<String, dynamic>,
      details: json['details'] as Map<String, dynamic>,
      timestamp:
          const _DateTimeConverter().fromJson(json['timestamp'] as String),
    );

Map<String, dynamic> _$$DelegationAuditModelImplToJson(
        _$DelegationAuditModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'delegationId': instance.delegationId,
      'action': instance.action,
      'performedBy': instance.performedBy,
      'performedByUser': instance.performedByUser,
      'details': instance.details,
      'timestamp': const _DateTimeConverter().toJson(instance.timestamp),
    };
