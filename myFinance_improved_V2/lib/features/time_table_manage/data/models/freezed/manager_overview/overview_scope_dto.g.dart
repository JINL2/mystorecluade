// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'overview_scope_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
