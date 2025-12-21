// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_mapping_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AccountMappingImpl _$$AccountMappingImplFromJson(Map<String, dynamic> json) =>
    _$AccountMappingImpl(
      mappingId: json['mapping_id'] as String,
      myCompanyId: json['my_company_id'] as String,
      myAccountId: json['my_account_id'] as String,
      counterpartyId: json['counterparty_id'] as String,
      linkedCompanyId: json['linked_company_id'] as String,
      linkedAccountId: json['linked_account_id'] as String,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      myCompanyName: json['my_company_name'] as String?,
      myAccountName: json['my_account_name'] as String?,
      counterpartyName: json['counterparty_name'] as String?,
      linkedCompanyName: json['linked_company_name'] as String?,
      linkedAccountName: json['linked_account_name'] as String?,
    );

Map<String, dynamic> _$$AccountMappingImplToJson(
        _$AccountMappingImpl instance) =>
    <String, dynamic>{
      'mapping_id': instance.mappingId,
      'my_company_id': instance.myCompanyId,
      'my_account_id': instance.myAccountId,
      'counterparty_id': instance.counterpartyId,
      'linked_company_id': instance.linkedCompanyId,
      'linked_account_id': instance.linkedAccountId,
      'is_active': instance.isActive,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      if (instance.myCompanyName case final value?) 'my_company_name': value,
      if (instance.myAccountName case final value?) 'my_account_name': value,
      if (instance.counterpartyName case final value?)
        'counterparty_name': value,
      if (instance.linkedCompanyName case final value?)
        'linked_company_name': value,
      if (instance.linkedAccountName case final value?)
        'linked_account_name': value,
    };

_$AccountMappingFormDataImpl _$$AccountMappingFormDataImplFromJson(
        Map<String, dynamic> json) =>
    _$AccountMappingFormDataImpl(
      mappingId: json['mappingId'] as String?,
      myCompanyId: json['myCompanyId'] as String,
      myAccountId: json['myAccountId'] as String?,
      counterpartyId: json['counterpartyId'] as String?,
      linkedCompanyId: json['linkedCompanyId'] as String?,
      linkedAccountId: json['linkedAccountId'] as String?,
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$$AccountMappingFormDataImplToJson(
        _$AccountMappingFormDataImpl instance) =>
    <String, dynamic>{
      'mappingId': instance.mappingId,
      'myCompanyId': instance.myCompanyId,
      'myAccountId': instance.myAccountId,
      'counterpartyId': instance.counterpartyId,
      'linkedCompanyId': instance.linkedCompanyId,
      'linkedAccountId': instance.linkedAccountId,
      'isActive': instance.isActive,
    };

_$AccountInfoImpl _$$AccountInfoImplFromJson(Map<String, dynamic> json) =>
    _$AccountInfoImpl(
      accountId: json['account_id'] as String,
      accountName: json['account_name'] as String,
      accountType: json['account_type'] as String?,
      expenseNature: json['expense_nature'] as String?,
      categoryTag: json['category_tag'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$AccountInfoImplToJson(_$AccountInfoImpl instance) =>
    <String, dynamic>{
      'account_id': instance.accountId,
      'account_name': instance.accountName,
      'account_type': instance.accountType,
      'expense_nature': instance.expenseNature,
      'category_tag': instance.categoryTag,
      if (instance.description case final value?) 'description': value,
    };

_$CompanyInfoImpl _$$CompanyInfoImplFromJson(Map<String, dynamic> json) =>
    _$CompanyInfoImpl(
      companyId: json['company_id'] as String,
      companyName: json['company_name'] as String,
      companyCode: json['company_code'] as String?,
      isActive: json['is_active'] as bool? ?? true,
    );

Map<String, dynamic> _$$CompanyInfoImplToJson(_$CompanyInfoImpl instance) =>
    <String, dynamic>{
      'company_id': instance.companyId,
      'company_name': instance.companyName,
      'company_code': instance.companyCode,
      'is_active': instance.isActive,
    };

_$AccountMappingResponseSuccessImpl
    _$$AccountMappingResponseSuccessImplFromJson(Map<String, dynamic> json) =>
        _$AccountMappingResponseSuccessImpl(
          data: AccountMapping.fromJson(json['data'] as Map<String, dynamic>),
          message: json['message'] as String?,
          $type: json['runtimeType'] as String?,
        );

Map<String, dynamic> _$$AccountMappingResponseSuccessImplToJson(
        _$AccountMappingResponseSuccessImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
      'message': instance.message,
      'runtimeType': instance.$type,
    };

_$AccountMappingResponseErrorImpl _$$AccountMappingResponseErrorImplFromJson(
        Map<String, dynamic> json) =>
    _$AccountMappingResponseErrorImpl(
      message: json['message'] as String,
      code: json['code'] as String?,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$AccountMappingResponseErrorImplToJson(
        _$AccountMappingResponseErrorImpl instance) =>
    <String, dynamic>{
      'message': instance.message,
      'code': instance.code,
      'runtimeType': instance.$type,
    };
