import '../../domain/entities/manager_shift_cards.dart';
import 'shift_card_model.dart';

/// Manager Shift Cards Model (DTO + Mapper)
class ManagerShiftCardsModel {
  final String storeId;
  final String startDate;
  final String endDate;
  final List<ShiftCardModel> cards;

  const ManagerShiftCardsModel({
    required this.storeId,
    required this.startDate,
    required this.endDate,
    required this.cards,
  });

  factory ManagerShiftCardsModel.fromJson(Map<String, dynamic> json) {
    // Handle both direct cards array and nested structure from RPC
    List<ShiftCardModel> cardsList = [];

    if (json['cards'] != null) {
      final rawCards = json['cards'] as List<dynamic>;

      cardsList = rawCards
          .map((e) => ShiftCardModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else if (json['stores'] != null) {
      // Handle RPC response structure: { stores: [{ cards: [...] }] }
      final stores = json['stores'] as List<dynamic>;

      if (stores.isNotEmpty) {
        final storeData = stores.first as Map<String, dynamic>;

        cardsList = (storeData['cards'] as List<dynamic>?)
                ?.map((e) => ShiftCardModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [];
      }
    }

    final model = ManagerShiftCardsModel(
      storeId: json['store_id'] as String? ?? '',
      startDate: json['start_date'] as String? ?? '',
      endDate: json['end_date'] as String? ?? '',
      cards: cardsList,
    );

    return model;
  }

  Map<String, dynamic> toJson() {
    return {
      'store_id': storeId,
      'start_date': startDate,
      'end_date': endDate,
      'cards': cards.map((e) => e.toJson()).toList(),
    };
  }

  ManagerShiftCards toEntity() {
    return ManagerShiftCards(
      storeId: storeId,
      startDate: startDate,
      endDate: endDate,
      cards: cards.map((e) => e.toEntity()).toList(),
    );
  }

  factory ManagerShiftCardsModel.fromEntity(ManagerShiftCards entity) {
    return ManagerShiftCardsModel(
      storeId: entity.storeId,
      startDate: entity.startDate,
      endDate: entity.endDate,
      cards: entity.cards.map((e) => ShiftCardModel.fromEntity(e)).toList(),
    );
  }
}
