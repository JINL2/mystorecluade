// lib/features/cash_ending/domain/entities/denomination.dart

/// Domain entity representing a single denomination (coin/bill)
class Denomination {
  final String denominationId;
  final String currencyId;
  final double value;
  final int quantity;

  Denomination({
    required this.denominationId,
    required this.currencyId,
    required this.value,
    this.quantity = 0,
  }) {
    // Simple validation
    if (value <= 0) {
      throw ArgumentError('Denomination value must be positive: $value');
    }
    if (quantity < 0) {
      throw ArgumentError('Quantity cannot be negative: $quantity');
    }
  }

  /// Calculate total amount for this denomination
  double get totalAmount => value * quantity;

  /// Check if denomination has quantity entered
  bool get hasQuantity => quantity > 0;

  /// Create a copy with updated quantity
  Denomination copyWith({
    String? denominationId,
    String? currencyId,
    double? value,
    int? quantity,
  }) {
    return Denomination(
      denominationId: denominationId ?? this.denominationId,
      currencyId: currencyId ?? this.currencyId,
      value: value ?? this.value,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Denomination &&
        other.denominationId == denominationId &&
        other.currencyId == currencyId &&
        other.value == value &&
        other.quantity == quantity;
  }

  @override
  int get hashCode {
    return Object.hash(
      denominationId,
      currencyId,
      value,
      quantity,
    );
  }
}
