// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter_party_stats_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CounterPartyStatsDtoImpl _$$CounterPartyStatsDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$CounterPartyStatsDtoImpl(
      total: (json['total'] as num).toInt(),
      suppliers: (json['suppliers'] as num).toInt(),
      customers: (json['customers'] as num).toInt(),
      employees: (json['employees'] as num).toInt(),
      teamMembers: (json['teamMembers'] as num).toInt(),
      myCompanies: (json['myCompanies'] as num).toInt(),
      others: (json['others'] as num).toInt(),
      activeCount: (json['activeCount'] as num).toInt(),
      inactiveCount: (json['inactiveCount'] as num).toInt(),
      recentAdditions: (json['recent_additions'] as List<dynamic>)
          .map((e) => CounterPartyDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$CounterPartyStatsDtoImplToJson(
        _$CounterPartyStatsDtoImpl instance) =>
    <String, dynamic>{
      'total': instance.total,
      'suppliers': instance.suppliers,
      'customers': instance.customers,
      'employees': instance.employees,
      'teamMembers': instance.teamMembers,
      'myCompanies': instance.myCompanies,
      'others': instance.others,
      'activeCount': instance.activeCount,
      'inactiveCount': instance.inactiveCount,
      'recent_additions': instance.recentAdditions,
    };
