// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_delegation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RoleDelegationModelImpl _$$RoleDelegationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$RoleDelegationModelImpl(
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

Map<String, dynamic> _$$RoleDelegationModelImplToJson(
        _$RoleDelegationModelImpl instance) =>
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
