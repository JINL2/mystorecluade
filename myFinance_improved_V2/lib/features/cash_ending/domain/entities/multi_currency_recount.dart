// lib/features/cash_ending/domain/entities/multi_currency_recount.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import 'vault_recount.dart';

part 'multi_currency_recount.freezed.dart';

/// Domain entity for multi-currency vault recount
///
/// Represents a single recount operation across multiple currencies
/// More efficient than individual recounts because it creates a single
/// cash_amount_entry for all currencies
@freezed
class MultiCurrencyRecount with _$MultiCurrencyRecount {
  const factory MultiCurrencyRecount({
    required String companyId,
    required String locationId,
    required String userId,
    String? storeId,
    required DateTime recordDate,
    required List<VaultRecount> currencyRecounts,
  }) = _MultiCurrencyRecount;

  const MultiCurrencyRecount._();

  /// Calculate total amount across all currencies (in their respective currencies)
  ///
  /// Note: This is NOT converted to base currency, just a sum of all amounts
  double get totalAmount {
    return currencyRecounts.fold(
      0.0,
      (sum, recount) => sum + recount.totalAmount,
    );
  }

  /// Get only recounts that have data
  List<VaultRecount> get activeRecounts {
    return currencyRecounts.where((r) => r.totalAmount > 0).toList();
  }

  /// Check if this recount has any data
  bool get hasData {
    return currencyRecounts.any((r) => r.totalAmount > 0);
  }

  /// Validate business rules
  String? validate() {
    if (companyId.isEmpty) return 'Company ID is required';
    if (locationId.isEmpty) return 'Location ID is required';
    if (userId.isEmpty) return 'User ID is required';
    if (currencyRecounts.isEmpty) return 'At least one currency recount is required';
    if (!hasData) return 'At least one currency must have data';
    return null;
  }
}
