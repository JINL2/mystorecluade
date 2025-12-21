// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_bank_account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserBankAccountImpl _$$UserBankAccountImplFromJson(
        Map<String, dynamic> json) =>
    _$UserBankAccountImpl(
      id: (json['id'] as num?)?.toInt(),
      userId: json['user_id'] as String,
      companyId: json['company_id'] as String,
      userBankName: json['user_bank_name'] as String?,
      userAccountNumber: json['user_account_number'] as String?,
      description: json['description'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$UserBankAccountImplToJson(
        _$UserBankAccountImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'company_id': instance.companyId,
      'user_bank_name': instance.userBankName,
      'user_account_number': instance.userAccountNumber,
      'description': instance.description,
      'is_active': instance.isActive,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
