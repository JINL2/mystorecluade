// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selector_entities.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SelectorEntityImpl _$$SelectorEntityImplFromJson(Map<String, dynamic> json) =>
    _$SelectorEntityImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String?,
      transactionCount: (json['transactionCount'] as num?)?.toInt() ?? 0,
      additionalData: json['additionalData'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$SelectorEntityImplToJson(
        _$SelectorEntityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'transactionCount': instance.transactionCount,
      'additionalData': instance.additionalData,
    };

_$AccountDataImpl _$$AccountDataImplFromJson(Map<String, dynamic> json) =>
    _$AccountDataImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      categoryTag: json['categoryTag'] as String?,
      expenseNature: json['expenseNature'] as String?,
      transactionCount: (json['transactionCount'] as num?)?.toInt() ?? 0,
      additionalData: json['additionalData'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$AccountDataImplToJson(_$AccountDataImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'categoryTag': instance.categoryTag,
      'expenseNature': instance.expenseNature,
      'transactionCount': instance.transactionCount,
      'additionalData': instance.additionalData,
    };

_$QuickAccessAccountImpl _$$QuickAccessAccountImplFromJson(
        Map<String, dynamic> json) =>
    _$QuickAccessAccountImpl(
      accountId: json['account_id'] as String,
      accountName: json['account_name'] as String,
      accountType: json['account_type'] as String,
      usageCount: (json['usage_count'] as num).toInt(),
      lastUsed: DateTime.parse(json['last_used'] as String),
      usageScore: (json['usage_score'] as num).toDouble(),
      existsInSystem: json['exists_in_system'] as bool? ?? true,
    );

Map<String, dynamic> _$$QuickAccessAccountImplToJson(
        _$QuickAccessAccountImpl instance) =>
    <String, dynamic>{
      'account_id': instance.accountId,
      'account_name': instance.accountName,
      'account_type': instance.accountType,
      'usage_count': instance.usageCount,
      'last_used': instance.lastUsed.toIso8601String(),
      'usage_score': instance.usageScore,
      'exists_in_system': instance.existsInSystem,
    };

_$CashLocationDataImpl _$$CashLocationDataImplFromJson(
        Map<String, dynamic> json) =>
    _$CashLocationDataImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      storeId: json['storeId'] as String?,
      companyId: json['companyId'] as String?,
      isCompanyWide: json['isCompanyWide'] as bool? ?? false,
      isDeleted: json['isDeleted'] as bool? ?? false,
      currencyCode: json['currencyCode'] as String?,
      bankAccount: json['bankAccount'] as String?,
      bankName: json['bankName'] as String?,
      locationInfo: json['locationInfo'] as String?,
      transactionCount: (json['transactionCount'] as num?)?.toInt() ?? 0,
      additionalData: json['additionalData'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$CashLocationDataImplToJson(
        _$CashLocationDataImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'storeId': instance.storeId,
      'companyId': instance.companyId,
      'isCompanyWide': instance.isCompanyWide,
      'isDeleted': instance.isDeleted,
      'currencyCode': instance.currencyCode,
      'bankAccount': instance.bankAccount,
      'bankName': instance.bankName,
      'locationInfo': instance.locationInfo,
      'transactionCount': instance.transactionCount,
      'additionalData': instance.additionalData,
    };

_$CounterpartyDataImpl _$$CounterpartyDataImplFromJson(
        Map<String, dynamic> json) =>
    _$CounterpartyDataImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      isInternal: json['isInternal'] as bool? ?? false,
      transactionCount: (json['transactionCount'] as num?)?.toInt() ?? 0,
      additionalData: json['additionalData'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$CounterpartyDataImplToJson(
        _$CounterpartyDataImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'email': instance.email,
      'phone': instance.phone,
      'isInternal': instance.isInternal,
      'transactionCount': instance.transactionCount,
      'additionalData': instance.additionalData,
    };

_$StoreDataImpl _$$StoreDataImplFromJson(Map<String, dynamic> json) =>
    _$StoreDataImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      address: json['address'] as String?,
      phone: json['phone'] as String?,
      transactionCount: (json['transactionCount'] as num?)?.toInt() ?? 0,
      additionalData: json['additionalData'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$StoreDataImplToJson(_$StoreDataImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'code': instance.code,
      'address': instance.address,
      'phone': instance.phone,
      'transactionCount': instance.transactionCount,
      'additionalData': instance.additionalData,
    };

_$UserDataImpl _$$UserDataImplFromJson(Map<String, dynamic> json) =>
    _$UserDataImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email'] as String?,
      transactionCount: (json['transactionCount'] as num?)?.toInt() ?? 0,
      additionalData: json['additionalData'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$UserDataImplToJson(_$UserDataImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'transactionCount': instance.transactionCount,
      'additionalData': instance.additionalData,
    };

_$SelectorItemImpl _$$SelectorItemImplFromJson(Map<String, dynamic> json) =>
    _$SelectorItemImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String?,
      iconPath: json['iconPath'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      isSelected: json['isSelected'] as bool?,
      data: json['data'],
    );

Map<String, dynamic> _$$SelectorItemImplToJson(_$SelectorItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'iconPath': instance.iconPath,
      'avatarUrl': instance.avatarUrl,
      'isSelected': instance.isSelected,
      'data': instance.data,
    };
