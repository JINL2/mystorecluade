// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'join_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$JoinResultModelImpl _$$JoinResultModelImplFromJson(
        Map<String, dynamic> json) =>
    _$JoinResultModelImpl(
      success: json['success'] as bool? ?? false,
      type: json['type'] as String?,
      message: json['message'] as String?,
      companyId: json['company_id'] as String?,
      companyName: json['company_name'] as String?,
      storeId: json['store_id'] as String?,
      storeName: json['store_name'] as String?,
      roleAssignedFlag: json['role_assigned'] as bool? ?? false,
    );

Map<String, dynamic> _$$JoinResultModelImplToJson(
        _$JoinResultModelImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'type': instance.type,
      'message': instance.message,
      'company_id': instance.companyId,
      'company_name': instance.companyName,
      'store_id': instance.storeId,
      'store_name': instance.storeName,
      'role_assigned': instance.roleAssignedFlag,
    };
