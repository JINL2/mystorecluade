// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserDtoImpl _$$UserDtoImplFromJson(Map<String, dynamic> json) =>
    _$UserDtoImpl(
      userId: json['user_id'] as String,
      email: json['email'] as String,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      userPhoneNumber: json['user_phone_number'] as String?,
      profileImage: json['profile_image'] as String?,
      preferredTimezone: json['preferred_timezone'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String?,
      isDeleted: json['is_deleted'] as bool? ?? false,
      isEmailVerified: json['is_email_verified'] as bool? ?? false,
      lastLoginAt: json['last_login_at'] as String?,
    );

Map<String, dynamic> _$$UserDtoImplToJson(_$UserDtoImpl instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'email': instance.email,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'user_phone_number': instance.userPhoneNumber,
      'profile_image': instance.profileImage,
      'preferred_timezone': instance.preferredTimezone,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'is_deleted': instance.isDeleted,
      'is_email_verified': instance.isEmailVerified,
      'last_login_at': instance.lastLoginAt,
    };
