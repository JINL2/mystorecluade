// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_real_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BankRealEntryImpl _$$BankRealEntryImplFromJson(Map<String, dynamic> json) =>
    _$BankRealEntryImpl(
      createdAt: json['createdAt'] as String,
      recordDate: json['recordDate'] as String,
      locationId: json['locationId'] as String,
      locationName: json['locationName'] as String,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      currencySummary: (json['currencySummary'] as List<dynamic>)
          .map((e) => CurrencySummary.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$BankRealEntryImplToJson(_$BankRealEntryImpl instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'recordDate': instance.recordDate,
      'locationId': instance.locationId,
      'locationName': instance.locationName,
      'totalAmount': instance.totalAmount,
      'currencySummary': instance.currencySummary,
    };

_$CurrencySummaryImpl _$$CurrencySummaryImplFromJson(
        Map<String, dynamic> json) =>
    _$CurrencySummaryImpl(
      currencyId: json['currencyId'] as String,
      currencyCode: json['currencyCode'] as String,
      currencyName: json['currencyName'] as String,
      symbol: json['symbol'] as String,
      totalValue: (json['totalValue'] as num).toDouble(),
      denominations: (json['denominations'] as List<dynamic>)
          .map((e) => Denomination.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$CurrencySummaryImplToJson(
        _$CurrencySummaryImpl instance) =>
    <String, dynamic>{
      'currencyId': instance.currencyId,
      'currencyCode': instance.currencyCode,
      'currencyName': instance.currencyName,
      'symbol': instance.symbol,
      'totalValue': instance.totalValue,
      'denominations': instance.denominations,
    };

_$DenominationImpl _$$DenominationImplFromJson(Map<String, dynamic> json) =>
    _$DenominationImpl(
      denominationId: json['denominationId'] as String,
      denominationType: json['denominationType'] as String,
      denominationValue: (json['denominationValue'] as num).toDouble(),
      quantity: (json['quantity'] as num).toInt(),
      subtotal: (json['subtotal'] as num).toDouble(),
    );

Map<String, dynamic> _$$DenominationImplToJson(_$DenominationImpl instance) =>
    <String, dynamic>{
      'denominationId': instance.denominationId,
      'denominationType': instance.denominationType,
      'denominationValue': instance.denominationValue,
      'quantity': instance.quantity,
      'subtotal': instance.subtotal,
    };
