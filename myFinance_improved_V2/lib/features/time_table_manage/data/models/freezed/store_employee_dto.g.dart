// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_employee_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StoreEmployeeDtoImpl _$$StoreEmployeeDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$StoreEmployeeDtoImpl(
      userId: json['user_id'] as String? ?? '',
      fullName: json['full_name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      displayName: json['display_name'] as String? ?? '',
    );

Map<String, dynamic> _$$StoreEmployeeDtoImplToJson(
        _$StoreEmployeeDtoImpl instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'full_name': instance.fullName,
      'email': instance.email,
      'display_name': instance.displayName,
    };
