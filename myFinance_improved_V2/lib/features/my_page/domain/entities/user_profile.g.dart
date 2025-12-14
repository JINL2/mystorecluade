// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileImpl _$$UserProfileImplFromJson(Map<String, dynamic> json) =>
    _$UserProfileImpl(
      userId: json['user_id'] as String,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      email: json['email'] as String,
      phoneNumber: json['user_phone_number'] as String?,
      dateOfBirth: json['date_of_birth'] as String?,
      profileImage: json['profile_image'] as String?,
      bankName: json['bank_name'] as String?,
      bankAccountNumber: json['bank_account_number'] as String?,
      isDeleted: json['is_deleted'] as bool? ?? false,
      deletedAt: _dateTimeFromJsonNullable(json['deleted_at'] as String?),
      createdAt: _dateTimeFromJsonNullable(json['created_at'] as String?),
      updatedAt: _dateTimeFromJsonNullable(json['updated_at'] as String?),
      companyName: json['company_name'] as String?,
      storeName: json['store_name'] as String?,
      roleName: json['role_name'] as String?,
      subscriptionPlan: json['subscription_plan'] as String? ?? 'Free',
      subscriptionStatus: json['subscription_status'] as String? ?? 'active',
      subscriptionExpiresAt:
          _dateTimeFromJsonNullable(json['subscription_expires_at'] as String?),
    );

Map<String, dynamic> _$$UserProfileImplToJson(_$UserProfileImpl instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'email': instance.email,
      'user_phone_number': instance.phoneNumber,
      'date_of_birth': instance.dateOfBirth,
      'profile_image': instance.profileImage,
      'bank_name': instance.bankName,
      'bank_account_number': instance.bankAccountNumber,
      'is_deleted': instance.isDeleted,
      'deleted_at': _dateTimeToJsonNullable(instance.deletedAt),
      'created_at': _dateTimeToJsonNullable(instance.createdAt),
      'updated_at': _dateTimeToJsonNullable(instance.updatedAt),
      'company_name': instance.companyName,
      'store_name': instance.storeName,
      'role_name': instance.roleName,
      'subscription_plan': instance.subscriptionPlan,
      'subscription_status': instance.subscriptionStatus,
      'subscription_expires_at':
          _dateTimeToJsonNullable(instance.subscriptionExpiresAt),
    };
