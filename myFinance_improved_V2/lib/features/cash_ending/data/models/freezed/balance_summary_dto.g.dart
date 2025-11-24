// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'balance_summary_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BalanceSummaryDtoImpl _$$BalanceSummaryDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$BalanceSummaryDtoImpl(
      success: json['success'] as bool,
      locationId: json['location_id'] as String,
      locationName: json['location_name'] as String,
      locationType: json['location_type'] as String,
      totalJournal: (json['total_journal'] as num).toDouble(),
      totalReal: (json['total_real'] as num).toDouble(),
      difference: (json['difference'] as num).toDouble(),
      isBalanced: json['is_balanced'] as bool,
      hasShortage: json['has_shortage'] as bool,
      hasSurplus: json['has_surplus'] as bool,
      currencySymbol: json['currency_symbol'] as String,
      currencyCode: json['currency_code'] as String,
      lastUpdated: json['last_updated'] == null
          ? null
          : DateTime.parse(json['last_updated'] as String),
      error: json['error'] as String?,
    );

Map<String, dynamic> _$$BalanceSummaryDtoImplToJson(
        _$BalanceSummaryDtoImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'location_id': instance.locationId,
      'location_name': instance.locationName,
      'location_type': instance.locationType,
      'total_journal': instance.totalJournal,
      'total_real': instance.totalReal,
      'difference': instance.difference,
      'is_balanced': instance.isBalanced,
      'has_shortage': instance.hasShortage,
      'has_surplus': instance.hasSurplus,
      'currency_symbol': instance.currencySymbol,
      'currency_code': instance.currencyCode,
      'last_updated': instance.lastUpdated?.toIso8601String(),
      'error': instance.error,
    };
