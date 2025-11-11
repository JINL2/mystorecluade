// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_balance_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BankBalanceDtoImpl _$$BankBalanceDtoImplFromJson(Map<String, dynamic> json) =>
    _$BankBalanceDtoImpl(
      balanceId: json['bank_amount_id'] as String?,
      companyId: json['company_id'] as String,
      storeId: json['store_id'] as String?,
      locationId: json['location_id'] as String,
      currencyId: json['currency_id'] as String,
      totalAmount: (json['total_amount'] as num).toInt(),
      userId: json['created_by'] as String,
      recordDate: DateTime.parse(json['record_date'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$BankBalanceDtoImplToJson(
        _$BankBalanceDtoImpl instance) =>
    <String, dynamic>{
      'bank_amount_id': instance.balanceId,
      'company_id': instance.companyId,
      'store_id': instance.storeId,
      'location_id': instance.locationId,
      'currency_id': instance.currencyId,
      'total_amount': instance.totalAmount,
      'created_by': instance.userId,
      'record_date': instance.recordDate.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
    };
