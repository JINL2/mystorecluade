// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manager_overview.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ManagerOverviewImpl _$$ManagerOverviewImplFromJson(
        Map<String, dynamic> json) =>
    _$ManagerOverviewImpl(
      month: json['month'] as String,
      totalShifts: (json['total_shifts'] as num).toInt(),
      totalApprovedRequests: (json['total_approved_requests'] as num).toInt(),
      totalPendingRequests: (json['total_pending_requests'] as num).toInt(),
      totalEmployees: (json['total_employees'] as num).toInt(),
      totalEstimatedCost: (json['total_estimated_cost'] as num).toDouble(),
      additionalStats: json['additional_stats'] as Map<String, dynamic>? ?? {},
    );

Map<String, dynamic> _$$ManagerOverviewImplToJson(
        _$ManagerOverviewImpl instance) =>
    <String, dynamic>{
      'month': instance.month,
      'total_shifts': instance.totalShifts,
      'total_approved_requests': instance.totalApprovedRequests,
      'total_pending_requests': instance.totalPendingRequests,
      'total_employees': instance.totalEmployees,
      'total_estimated_cost': instance.totalEstimatedCost,
      'additional_stats': instance.additionalStats,
    };
