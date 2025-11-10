// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TagImpl _$$TagImplFromJson(Map<String, dynamic> json) => _$TagImpl(
      tagId: json['tag_id'] as String,
      cardId: json['card_id'] as String,
      tagType: json['tag_type'] as String,
      tagContent: json['tag_content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      createdBy: json['created_by'] as String,
    );

Map<String, dynamic> _$$TagImplToJson(_$TagImpl instance) => <String, dynamic>{
      'tag_id': instance.tagId,
      'card_id': instance.cardId,
      'tag_type': instance.tagType,
      'tag_content': instance.tagContent,
      'created_at': instance.createdAt.toIso8601String(),
      'created_by': instance.createdBy,
    };
