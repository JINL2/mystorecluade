// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter_party_filter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CounterPartyFilterImpl _$$CounterPartyFilterImplFromJson(
        Map<String, dynamic> json) =>
    _$CounterPartyFilterImpl(
      searchQuery: json['searchQuery'] as String?,
      types: (json['types'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$CounterPartyTypeEnumMap, e))
          .toList(),
      sortBy: $enumDecodeNullable(
              _$CounterPartySortOptionEnumMap, json['sortBy']) ??
          CounterPartySortOption.isInternal,
      ascending: json['ascending'] as bool? ?? false,
      isInternal: json['isInternal'] as bool?,
      createdAfter: json['createdAfter'] == null
          ? null
          : DateTime.parse(json['createdAfter'] as String),
      createdBefore: json['createdBefore'] == null
          ? null
          : DateTime.parse(json['createdBefore'] as String),
      includeDeleted: json['includeDeleted'] as bool? ?? true,
    );

Map<String, dynamic> _$$CounterPartyFilterImplToJson(
        _$CounterPartyFilterImpl instance) =>
    <String, dynamic>{
      'searchQuery': instance.searchQuery,
      'types':
          instance.types?.map((e) => _$CounterPartyTypeEnumMap[e]!).toList(),
      'sortBy': _$CounterPartySortOptionEnumMap[instance.sortBy]!,
      'ascending': instance.ascending,
      'isInternal': instance.isInternal,
      'createdAfter': instance.createdAfter?.toIso8601String(),
      'createdBefore': instance.createdBefore?.toIso8601String(),
      'includeDeleted': instance.includeDeleted,
    };

const _$CounterPartyTypeEnumMap = {
  CounterPartyType.myCompany: 'My Company',
  CounterPartyType.teamMember: 'Team Member',
  CounterPartyType.supplier: 'Suppliers',
  CounterPartyType.employee: 'Employees',
  CounterPartyType.customer: 'Customers',
  CounterPartyType.other: 'Others',
};

const _$CounterPartySortOptionEnumMap = {
  CounterPartySortOption.name: 'name',
  CounterPartySortOption.type: 'type',
  CounterPartySortOption.createdAt: 'createdAt',
  CounterPartySortOption.isInternal: 'isInternal',
};
