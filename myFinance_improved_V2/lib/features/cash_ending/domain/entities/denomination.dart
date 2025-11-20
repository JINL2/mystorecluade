// lib/features/cash_ending/domain/entities/denomination.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'denomination.freezed.dart';

/// Domain entity representing a single denomination (coin/bill)
///
/// Maps to `currency_denominations` table in database.
/// DB columns: denomination_id (uuid), currency_id (uuid), value (numeric), type (text)
@freezed
class Denomination with _$Denomination {
  const factory Denomination({
    required String denominationId,
    required String currencyId,
    required double value,
    @Default(0) int quantity,
  }) = _Denomination;

  const Denomination._();

  /// Calculate total amount for this denomination
  double get totalAmount => value * quantity;

  /// Check if denomination has quantity entered
  bool get hasQuantity => quantity > 0;
}
