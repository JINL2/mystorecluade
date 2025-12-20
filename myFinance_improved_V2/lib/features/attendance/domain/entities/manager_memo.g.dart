// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manager_memo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ManagerMemoImpl _$$ManagerMemoImplFromJson(Map<String, dynamic> json) =>
    _$ManagerMemoImpl(
      id: json['id'] as String?,
      content: json['content'] as String? ?? '',
      createdAt: json['created_at'] as String?,
      createdBy: json['created_by'] as String?,
    );

Map<String, dynamic> _$$ManagerMemoImplToJson(_$ManagerMemoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'created_at': instance.createdAt,
      'created_by': instance.createdBy,
    };
