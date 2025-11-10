// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_shift_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MonthlyShiftStatusImpl _$$MonthlyShiftStatusImplFromJson(
        Map<String, dynamic> json) =>
    _$MonthlyShiftStatusImpl(
      month: json['month'] as String,
      dailyShifts: (json['daily_shifts'] as List<dynamic>?)
              ?.map((e) => DailyShiftData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      statistics: json['statistics'] as Map<String, dynamic>? ?? {},
    );

Map<String, dynamic> _$$MonthlyShiftStatusImplToJson(
        _$MonthlyShiftStatusImpl instance) =>
    <String, dynamic>{
      'month': instance.month,
      'daily_shifts': instance.dailyShifts,
      'statistics': instance.statistics,
    };
