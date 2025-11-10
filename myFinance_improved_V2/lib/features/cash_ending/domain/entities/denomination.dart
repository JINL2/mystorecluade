// lib/features/cash_ending/domain/entities/denomination.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'denomination.freezed.dart';
part 'denomination.g.dart';

/// Domain entity representing a single denomination (coin/bill)
///
/// Uses Freezed for:
/// - Immutability guarantee
/// - Auto-generated copyWith, ==, hashCode
/// - JSON serialization support
@freezed
class Denomination with _$Denomination {
  const Denomination._();

  @Assert('value > 0', 'Denomination value must be positive')
  @Assert('quantity >= 0', 'Quantity cannot be negative')
  const factory Denomination({
    @JsonKey(name: 'denomination_id') required String denominationId,
    @JsonKey(name: 'currency_id') required String currencyId,
    required double value,
    @Default(0) int quantity,
  }) = _Denomination;

  /// Create from JSON (from database)
  factory Denomination.fromJson(Map<String, dynamic> json) => _$DenominationFromJson(json);

  /// Calculate total amount for this denomination
  double get totalAmount => value * quantity;

  /// Check if denomination has quantity entered
  bool get hasQuantity => quantity > 0;
}
