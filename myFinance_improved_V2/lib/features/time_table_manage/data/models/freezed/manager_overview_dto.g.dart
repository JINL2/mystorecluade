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
