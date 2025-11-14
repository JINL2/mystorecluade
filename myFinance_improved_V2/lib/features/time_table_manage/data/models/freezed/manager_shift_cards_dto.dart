import 'package:freezed_annotation/freezed_annotation.dart';
import 'available_content_dto.dart';
import 'store_cards_dto.dart';

part 'manager_shift_cards_dto.freezed.dart';
part 'manager_shift_cards_dto.g.dart';

/// Manager Shift Cards DTO
///
/// Maps to RPC: manager_shift_get_cards
@freezed
class ManagerShiftCardsDto with _$ManagerShiftCardsDto {
  const factory ManagerShiftCardsDto({
    @JsonKey(name: 'available_contents') @Default([]) List<AvailableContentDto> availableContents,
    @JsonKey(name: 'stores') @Default([]) List<StoreCardsDto> stores,
  }) = _ManagerShiftCardsDto;

  factory ManagerShiftCardsDto.fromJson(Map<String, dynamic> json) =>
      _$ManagerShiftCardsDtoFromJson(json);
}
