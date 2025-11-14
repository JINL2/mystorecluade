// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_info_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EmployeeInfoDtoImpl _$$EmployeeInfoDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$EmployeeInfoDtoImpl(
      userId: json['user_id'] as String? ?? '',
      userName: json['user_name'] as String? ?? '',
      profileImage: json['profile_image'] as String?,
      position: json['position'] as String?,
      hourlyWage: (json['hourly_wage'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$EmployeeInfoDtoImplToJson(
        _$EmployeeInfoDtoImpl instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'user_name': instance.userName,
      'profile_image': instance.profileImage,
      'position': instance.position,
      'hourly_wage': instance.hourlyWage,
    };
