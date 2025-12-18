// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_stat_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MonthlyStatDtoImpl _$$MonthlyStatDtoImplFromJson(Map<String, dynamic> json) =>
    _$MonthlyStatDtoImpl(
      month: json['month'] as String? ?? '',
      totalRequests: (json['total_requests'] as num?)?.toInt() ?? 0,
      totalApproved: (json['total_approved'] as num?)?.toInt() ?? 0,
      totalPending: (json['total_pending'] as num?)?.toInt() ?? 0,
      totalProblems: (json['total_problems'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$MonthlyStatDtoImplToJson(
        _$MonthlyStatDtoImpl instance) =>
    <String, dynamic>{
      'month': instance.month,
      'total_requests': instance.totalRequests,
      'total_approved': instance.totalApproved,
      'total_pending': instance.totalPending,
      'total_problems': instance.totalProblems,
    };
