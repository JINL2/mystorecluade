// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'overview_store_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OverviewStoreDtoImpl _$$OverviewStoreDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$OverviewStoreDtoImpl(
      storeId: json['store_id'] as String? ?? '',
      storeName: json['store_name'] as String? ?? '',
      dailySummary: (json['daily_summary'] as List<dynamic>?)
              ?.map((e) => DailySummaryDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      monthlyStats: (json['monthly_stats'] as List<dynamic>?)
              ?.map((e) => MonthlyStatDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$OverviewStoreDtoImplToJson(
        _$OverviewStoreDtoImpl instance) =>
    <String, dynamic>{
      'store_id': instance.storeId,
      'store_name': instance.storeName,
      'daily_summary': instance.dailySummary,
      'monthly_stats': instance.monthlyStats,
    };
