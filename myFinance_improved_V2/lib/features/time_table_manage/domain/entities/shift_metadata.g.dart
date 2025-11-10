// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShiftMetadataImpl _$$ShiftMetadataImplFromJson(Map<String, dynamic> json) =>
    _$ShiftMetadataImpl(
      availableTags: (json['available_tags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      settings: json['settings'] as Map<String, dynamic>? ?? {},
      lastUpdated: json['last_updated'] == null
          ? null
          : DateTime.parse(json['last_updated'] as String),
    );

Map<String, dynamic> _$$ShiftMetadataImplToJson(_$ShiftMetadataImpl instance) =>
    <String, dynamic>{
      'available_tags': instance.availableTags,
      'settings': instance.settings,
      'last_updated': instance.lastUpdated?.toIso8601String(),
    };
