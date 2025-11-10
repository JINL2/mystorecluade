// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      id: json['user_id'] as String,
      email: json['email'] as String,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      lastLoginAt: json['last_login_at'] == null
          ? null
          : DateTime.parse(json['last_login_at'] as String),
      isEmailVerified: json['is_email_verified'] as bool? ?? false,
      phoneNumber: json['user_phone_number'] as String?,
      profileImage: json['profile_image'] as String?,
      timezone: json['preferred_timezone'] as String?,
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      isDeleted: json['is_deleted'] as bool? ?? false,
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'user_id': instance.id,
      'email': instance.email,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'created_at': instance.createdAt.toIso8601String(),
      'last_login_at': instance.lastLoginAt?.toIso8601String(),
      'is_email_verified': instance.isEmailVerified,
      'user_phone_number': instance.phoneNumber,
      'profile_image': instance.profileImage,
      'preferred_timezone': instance.timezone,
      'updated_at': instance.updatedAt?.toIso8601String(),
      'is_deleted': instance.isDeleted,
    };
