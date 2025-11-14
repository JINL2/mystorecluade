// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manager_overview_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ManagerOverviewDtoImpl _$$ManagerOverviewDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ManagerOverviewDtoImpl(
      scope: OverviewScopeDto.fromJson(json['scope'] as Map<String, dynamic>),
      stores: (json['stores'] as List<dynamic>?)
              ?.map((e) => OverviewStoreDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ManagerOverviewDtoImplToJson(
        _$ManagerOverviewDtoImpl instance) =>
    <String, dynamic>{
      'scope': instance.scope,
      'stores': instance.stores,
    };

_$OverviewScopeDtoImpl _$$OverviewScopeDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$OverviewScopeDtoImpl(
      companyId: json['company_id'] as String? ?? '',
      companyName: json['company_name'] as String? ?? '',
      totalStores: (json['total_stores'] as num?)?.toInt() ?? 0,
      dateRange:
          DateRangeDto.fromJson(json['date_range'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$OverviewScopeDtoImplToJson(
        _$OverviewScopeDtoImpl instance) =>
    <String, dynamic>{
      'company_id': instance.companyId,
      'company_name': instance.companyName,
      'total_stores': instance.totalStores,
      'date_range': instance.dateRange,
    };

_$DateRangeDtoImpl _$$DateRangeDtoImplFromJson(Map<String, dynamic> json) =>
    _$DateRangeDtoImpl(
      startDate: json['start_date'] as String? ?? '',
      endDate: json['end_date'] as String? ?? '',
    );

Map<String, dynamic> _$$DateRangeDtoImplToJson(_$DateRangeDtoImpl instance) =>
    <String, dynamic>{
      'start_date': instance.startDate,
      'end_date': instance.endDate,
    };

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
