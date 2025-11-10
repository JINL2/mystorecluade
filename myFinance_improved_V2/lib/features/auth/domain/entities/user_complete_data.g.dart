// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_complete_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserCompleteDataImpl _$$UserCompleteDataImplFromJson(
        Map<String, dynamic> json) =>
    _$UserCompleteDataImpl(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      companies: (json['companies'] as List<dynamic>?)
              ?.map((e) => Company.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      stores: (json['stores'] as List<dynamic>?)
              ?.map((e) => Store.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$UserCompleteDataImplToJson(
        _$UserCompleteDataImpl instance) =>
    <String, dynamic>{
      'user': instance.user,
      'companies': instance.companies,
      'stores': instance.stores,
    };
