// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manager_shift_cards.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ManagerShiftCardsImpl _$$ManagerShiftCardsImplFromJson(
        Map<String, dynamic> json) =>
    _$ManagerShiftCardsImpl(
      storeId: json['store_id'] as String? ?? '',
      startDate: json['start_date'] as String? ?? '',
      endDate: json['end_date'] as String? ?? '',
      cards: (json['cards'] as List<dynamic>?)
              ?.map((e) => ShiftCard.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$$ManagerShiftCardsImplToJson(
        _$ManagerShiftCardsImpl instance) =>
    <String, dynamic>{
      'store_id': instance.storeId,
      'start_date': instance.startDate,
      'end_date': instance.endDate,
      'cards': instance.cards,
    };
