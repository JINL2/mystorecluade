// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cash_ending_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CashEndingDtoImpl _$$CashEndingDtoImplFromJson(Map<String, dynamic> json) =>
    _$CashEndingDtoImpl(
      cashEndingId: json['cash_ending_id'] as String?,
      companyId: json['company_id'] as String,
      userId: json['user_id'] as String?,
      createdBy: json['created_by'] as String?,
      locationId: json['location_id'] as String,
      storeId: json['store_id'] as String?,
      recordDate: DateTime.parse(json['record_date'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      currencies: (json['currencies'] as List<dynamic>?)
              ?.map((e) => CurrencyDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$CashEndingDtoImplToJson(_$CashEndingDtoImpl instance) =>
    <String, dynamic>{
      'cash_ending_id': instance.cashEndingId,
      'company_id': instance.companyId,
      'user_id': instance.userId,
      'created_by': instance.createdBy,
      'location_id': instance.locationId,
      'store_id': instance.storeId,
      'record_date': instance.recordDate.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'currencies': instance.currencies,
    };
