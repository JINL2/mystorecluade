// Domain Entity - Vault Real Entry Business Object

class VaultRealEntry {
  final String createdAt;
  final String recordDate;
  final String locationId;
  final String locationName;
  final double totalAmount;
  final List<CurrencySummary> currencySummary;

  const VaultRealEntry({
    required this.createdAt,
    required this.recordDate,
    required this.locationId,
    required this.locationName,
    required this.totalAmount,
    required this.currencySummary,
  });

  // Business logic methods
  String getFormattedTime() {
    try {
      final dateTime = DateTime.parse(createdAt);
      final hour = dateTime.hour.toString().padLeft(2, '0');
      final minute = dateTime.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    } catch (e) {
      return '';
    }
  }

  String getCurrencySymbol() {
    if (currencySummary.isNotEmpty) {
      return currencySummary.first.symbol;
    }
    return '';
  }

  String getTransactionType() {
    if (totalAmount == 0) {
      return 'Error';
    } else if (totalAmount < 0) {
      return 'Shortage';
    } else {
      return 'Vault';
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VaultRealEntry &&
          runtimeType == other.runtimeType &&
          createdAt == other.createdAt &&
          locationId == other.locationId;

  @override
  int get hashCode => createdAt.hashCode ^ locationId.hashCode;
}

// Re-use CurrencySummary and Denomination
class CurrencySummary {
  final String currencyId;
  final String currencyCode;
  final String currencyName;
  final String symbol;
  final double totalValue;
  final List<Denomination> denominations;

  const CurrencySummary({
    required this.currencyId,
    required this.currencyCode,
    required this.currencyName,
    required this.symbol,
    required this.totalValue,
    required this.denominations,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrencySummary &&
          runtimeType == other.runtimeType &&
          currencyId == other.currencyId;

  @override
  int get hashCode => currencyId.hashCode;
}

class Denomination {
  final String denominationId;
  final String denominationType;
  final double denominationValue;
  final int quantity;
  final double subtotal;

  const Denomination({
    required this.denominationId,
    required this.denominationType,
    required this.denominationValue,
    required this.quantity,
    required this.subtotal,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Denomination &&
          runtimeType == other.runtimeType &&
          denominationId == other.denominationId;

  @override
  int get hashCode => denominationId.hashCode;
}
