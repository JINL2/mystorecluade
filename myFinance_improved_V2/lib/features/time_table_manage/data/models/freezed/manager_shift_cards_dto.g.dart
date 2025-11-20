// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manager_shift_cards_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ManagerShiftCardsDtoImpl _$$ManagerShiftCardsDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ManagerShiftCardsDtoImpl(
      availableContents: (json['available_contents'] as List<dynamic>?)
              ?.map((e) =>
                  AvailableContentDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      stores: (json['stores'] as List<dynamic>?)
              ?.map((e) => StoreCardsDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ManagerShiftCardsDtoImplToJson(
        _$ManagerShiftCardsDtoImpl instance) =>
    <String, dynamic>{
      'available_contents': instance.availableContents,
      'stores': instance.stores,
    };
