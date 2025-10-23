// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delegatable_role_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DelegatableRoleModelImpl _$$DelegatableRoleModelImplFromJson(
        Map<String, dynamic> json) =>
    _$DelegatableRoleModelImpl(
      roleId: json['roleId'] as String,
      roleName: json['roleName'] as String,
      description: json['description'] as String,
      permissions: (json['permissions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      canDelegate: json['canDelegate'] as bool,
    );

Map<String, dynamic> _$$DelegatableRoleModelImplToJson(
        _$DelegatableRoleModelImpl instance) =>
    <String, dynamic>{
      'roleId': instance.roleId,
      'roleName': instance.roleName,
      'description': instance.description,
      'permissions': instance.permissions,
      'canDelegate': instance.canDelegate,
    };
