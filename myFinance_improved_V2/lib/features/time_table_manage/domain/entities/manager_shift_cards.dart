import 'shift_card.dart';

/// Manager Shift Cards Entity
///
/// Contains a collection of shift cards for a specific store and date range.
/// Used by managers to view and manage all shift assignments.
class ManagerShiftCards {
  /// The store ID these cards belong to
  final String storeId;

  /// Start date of the range (yyyy-MM-dd format)
  final String startDate;

  /// End date of the range (yyyy-MM-dd format)
  final String endDate;

  /// List of all shift cards in the date range
  final List<ShiftCard> cards;

  const ManagerShiftCards({
    required this.storeId,
    required this.startDate,
    required this.endDate,
    required this.cards,
  });

  /// Get total number of cards
  int get totalCards => cards.length;

  /// Check if there are any cards
  bool get hasCards => cards.isNotEmpty;

  /// Get approved cards
  List<ShiftCard> get approvedCards {
    return cards.where((card) => card.isApproved).toList();
  }

  /// Get pending cards
  List<ShiftCard> get pendingCards {
    return cards.where((card) => card.isPending).toList();
  }

  /// Get cards with problems
  List<ShiftCard> get problemCards {
    return cards.where((card) => card.hasProblem).toList();
  }

  /// Get cards with bonus
  List<ShiftCard> get bonusCards {
    return cards.where((card) => card.hasBonus).toList();
  }

  /// Get count of approved cards
  int get approvedCount => approvedCards.length;

  /// Get count of pending cards
  int get pendingCount => pendingCards.length;

  /// Get count of problem cards
  int get problemCount => problemCards.length;

  /// Get count of bonus cards
  int get bonusCount => bonusCards.length;

  /// Calculate total bonus amount
  double get totalBonusAmount {
    return bonusCards.fold<double>(
      0.0,
      (sum, card) => sum + (card.bonusAmount ?? 0.0),
    );
  }

  /// Calculate approval rate as percentage
  double get approvalRate {
    if (totalCards == 0) return 0.0;
    return (approvedCount / totalCards) * 100;
  }

  /// Get cards for a specific date
  List<ShiftCard> getCardsByDate(String date) {
    return cards.where((card) => card.requestDate == date).toList();
  }

  /// Get cards for a specific employee
  List<ShiftCard> getCardsByEmployeeId(String userId) {
    return cards.where((card) => card.employee.userId == userId).toList();
  }

  /// Get card by shift request ID
  ShiftCard? getCardById(String shiftRequestId) {
    try {
      return cards.firstWhere((card) => card.shiftRequestId == shiftRequestId);
    } catch (_) {
      return null;
    }
  }

  /// Filter cards by status
  List<ShiftCard> filterByStatus(String? status) {
    if (status == null || status.isEmpty || status == 'all') {
      return cards;
    }

    switch (status.toLowerCase()) {
      case 'approved':
        return approvedCards;
      case 'pending':
        return pendingCards;
      case 'problem':
        return problemCards;
      case 'bonus':
        return bonusCards;
      default:
        return cards;
    }
  }

  /// Group cards by date
  Map<String, List<ShiftCard>> groupByDate() {
    final Map<String, List<ShiftCard>> grouped = {};

    for (final card in cards) {
      if (!grouped.containsKey(card.requestDate)) {
        grouped[card.requestDate] = [];
      }
      grouped[card.requestDate]!.add(card);
    }

    return grouped;
  }

  /// Copy with method for immutability
  ManagerShiftCards copyWith({
    String? storeId,
    String? startDate,
    String? endDate,
    List<ShiftCard>? cards,
  }) {
    return ManagerShiftCards(
      storeId: storeId ?? this.storeId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      cards: cards ?? this.cards,
    );
  }

  @override
  String toString() {
    return 'ManagerShiftCards(store: $storeId, period: $startDate to $endDate, cards: $totalCards)';
  }
}
