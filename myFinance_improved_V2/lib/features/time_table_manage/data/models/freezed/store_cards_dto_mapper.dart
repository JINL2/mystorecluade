import 'shift_card_dto_mapper.dart';
import 'store_cards_dto.dart';

/// Extension to map StoreCardsDto → Map with cards
///
/// Note: This DTO doesn't have a direct domain entity counterpart.
/// It contains ShiftCards which are mapped individually.
extension StoreCardsDtoMapper on StoreCardsDto {
  Map<String, dynamic> toMap() {
    return {
      'storeId': storeId ?? '',
      'storeName': storeName ?? '',
      'requestCount': requestCount,
      'approvedCount': approvedCount,
      'problemCount': problemCount,
      'cards': cards.map((c) => c.toEntity()).toList(),
    };
  }
}
