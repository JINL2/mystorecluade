import 'package:freezed_annotation/freezed_annotation.dart';
import 'shift_card_dto.dart';

part 'store_cards_dto.freezed.dart';
part 'store_cards_dto.g.dart';

/// Store Cards DTO
///
/// Maps to manager_shift_get_cards RPC field: stores (array element)
@freezed
class StoreCardsDto with _$StoreCardsDto {
  const factory StoreCardsDto({
    @JsonKey(name: 'store_id') String? storeId,
    @JsonKey(name: 'store_name') String? storeName,
    @JsonKey(name: 'request_count') @Default(0) int requestCount,
    @JsonKey(name: 'approved_count') @Default(0) int approvedCount,
    @JsonKey(name: 'problem_count') @Default(0) int problemCount,
    @JsonKey(name: 'cards') @Default([]) List<ShiftCardDto> cards,
  }) = _StoreCardsDto;

  factory StoreCardsDto.fromJson(Map<String, dynamic> json) =>
      _$StoreCardsDtoFromJson(json);
}
