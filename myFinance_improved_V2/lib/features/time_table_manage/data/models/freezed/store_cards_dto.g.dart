// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_cards_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StoreCardsDtoImpl _$$StoreCardsDtoImplFromJson(Map<String, dynamic> json) =>
    _$StoreCardsDtoImpl(
      storeId: json['store_id'] as String?,
      storeName: json['store_name'] as String?,
      requestCount: (json['request_count'] as num?)?.toInt() ?? 0,
      approvedCount: (json['approved_count'] as num?)?.toInt() ?? 0,
      problemCount: (json['problem_count'] as num?)?.toInt() ?? 0,
      cards: (json['cards'] as List<dynamic>?)
              ?.map((e) => ShiftCardDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$StoreCardsDtoImplToJson(_$StoreCardsDtoImpl instance) =>
    <String, dynamic>{
      'store_id': instance.storeId,
      'store_name': instance.storeName,
      'request_count': instance.requestCount,
      'approved_count': instance.approvedCount,
      'problem_count': instance.problemCount,
      'cards': instance.cards,
    };
