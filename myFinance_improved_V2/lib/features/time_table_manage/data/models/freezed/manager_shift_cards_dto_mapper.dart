import '../../../domain/entities/manager_shift_cards.dart';
import 'manager_shift_cards_dto.dart';
import 'shift_card_dto_mapper.dart';

/// Extension to map ManagerShiftCardsDto → Domain Entity
extension ManagerShiftCardsDtoMapper on ManagerShiftCardsDto {
  ManagerShiftCards toEntity({
    required String storeId,
    required String startDate,
    required String endDate,
  }) {
    // If multiple stores, combine all cards from all stores
    final allCards = stores.expand((store) => store.cards).toList();

    return ManagerShiftCards(
      storeId: storeId,
      startDate: startDate,
      endDate: endDate,
      cards: allCards.map((c) => c.toEntity()).toList(),
    );
  }
}
