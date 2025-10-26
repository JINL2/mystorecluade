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
      startDate:
          const _DateTimeConverter().fromJson(json['startDate'] as String),
      endDate: const _DateTimeConverter().fromJson(json['endDate'] as String),
      isActive: json['isActive'] as bool,
      createdAt: const _NullableDateTimeConverter()
          .fromJson(json['createdAt'] as String?),
      updatedAt: const _NullableDateTimeConverter()
          .fromJson(json['updatedAt'] as String?),
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
      'startDate': const _DateTimeConverter().toJson(instance.startDate),
      'endDate': const _DateTimeConverter().toJson(instance.endDate),
      'isActive': instance.isActive,
      'createdAt':
          const _NullableDateTimeConverter().toJson(instance.createdAt),
      'updatedAt':
          const _NullableDateTimeConverter().toJson(instance.updatedAt),
    };
