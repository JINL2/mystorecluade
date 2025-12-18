// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_summary_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DailySummaryDtoImpl _$$DailySummaryDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$DailySummaryDtoImpl(
      date: json['date'] as String? ?? '',
      totalRequired: (json['total_required'] as num?)?.toInt() ?? 0,
      totalApproved: (json['total_approved'] as num?)?.toInt() ?? 0,
      totalPending: (json['total_pending'] as num?)?.toInt() ?? 0,
      hasProblem: json['has_problem'] as bool? ?? false,
      fillRate: (json['fill_rate'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$DailySummaryDtoImplToJson(
        _$DailySummaryDtoImpl instance) =>
    <String, dynamic>{
      'date': instance.date,
      'total_required': instance.totalRequired,
      'total_approved': instance.totalApproved,
      'total_pending': instance.totalPending,
      'has_problem': instance.hasProblem,
      'fill_rate': instance.fillRate,
    };
