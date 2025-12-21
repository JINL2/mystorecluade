// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delegate_role_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RoleDelegationImpl _$$RoleDelegationImplFromJson(Map<String, dynamic> json) =>
    _$RoleDelegationImpl(
      id: json['id'] as String,
      delegatorId: json['delegatorId'] as String,
      delegateId: json['delegateId'] as String,
      companyId: json['companyId'] as String,
      roleId: json['roleId'] as String,
      roleName: json['roleName'] as String,
      delegateUser: json['delegateUser'] as Map<String, dynamic>,
      permissions: (json['permissions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      isActive: json['isActive'] as bool,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$RoleDelegationImplToJson(
        _$RoleDelegationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'delegatorId': instance.delegatorId,
      'delegateId': instance.delegateId,
      'companyId': instance.companyId,
      'roleId': instance.roleId,
      'roleName': instance.roleName,
      'delegateUser': instance.delegateUser,
      'permissions': instance.permissions,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'isActive': instance.isActive,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$DelegationAuditImpl _$$DelegationAuditImplFromJson(
        Map<String, dynamic> json) =>
    _$DelegationAuditImpl(
      id: json['id'] as String,
      delegationId: json['delegationId'] as String,
      action: json['action'] as String,
      performedBy: json['performedBy'] as String,
      performedByUser: json['performedByUser'] as Map<String, dynamic>,
      details: json['details'] as Map<String, dynamic>,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$DelegationAuditImplToJson(
        _$DelegationAuditImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'delegationId': instance.delegationId,
      'action': instance.action,
      'performedBy': instance.performedBy,
      'performedByUser': instance.performedByUser,
      'details': instance.details,
      'timestamp': instance.timestamp.toIso8601String(),
    };

_$DelegatableRoleImpl _$$DelegatableRoleImplFromJson(
        Map<String, dynamic> json) =>
    _$DelegatableRoleImpl(
      roleId: json['roleId'] as String,
      roleName: json['roleName'] as String,
      description: json['description'] as String,
      permissions: (json['permissions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      canDelegate: json['canDelegate'] as bool,
    );

Map<String, dynamic> _$$DelegatableRoleImplToJson(
        _$DelegatableRoleImpl instance) =>
    <String, dynamic>{
      'roleId': instance.roleId,
      'roleName': instance.roleName,
      'description': instance.description,
      'permissions': instance.permissions,
      'canDelegate': instance.canDelegate,
    };

_$CreateDelegationRequestImpl _$$CreateDelegationRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateDelegationRequestImpl(
      delegateId: json['delegateId'] as String,
      roleId: json['roleId'] as String,
      permissions: (json['permissions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
    );

Map<String, dynamic> _$$CreateDelegationRequestImplToJson(
        _$CreateDelegationRequestImpl instance) =>
    <String, dynamic>{
      'delegateId': instance.delegateId,
      'roleId': instance.roleId,
      'permissions': instance.permissions,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
    };
