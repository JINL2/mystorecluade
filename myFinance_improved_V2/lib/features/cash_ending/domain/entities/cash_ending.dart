// lib/features/cash_ending/domain/entities/cash_ending.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/utils/datetime_utils.dart';
import 'currency.dart';

part 'cash_ending.freezed.dart';

/// Domain entity representing a cash ending record
///
/// This is the aggregate root for the cash ending feature.
///
/// Uses Freezed for:
/// - Immutability guarantee
/// - Auto-generated copyWith, ==, hashCode
/// - Compile-time validation with @Assert
///
/// ✅ Refactored with:
/// - Freezed (107 lines → ~60 actual code)
/// - @Assert for validation
/// - Private constructor for custom methods
@freezed
class CashEnding with _$CashEnding {
  const CashEnding._();

  const factory CashEnding({
    String? cashEndingId, // null for new records
    required String companyId,
    required String userId,
    required String locationId,
    String? storeId,
    required DateTime recordDate,
    required DateTime createdAt,
    required List<Currency> currencies,
  }) = _CashEnding;

  /// Custom fromJson factory for database deserialization
  factory CashEnding.fromJson(Map<String, dynamic> json) {
    // Parse currencies from nested JSON
    final List<Currency> currenciesList = [];
    if (json['currencies'] != null) {
      final currenciesData = json['currencies'] as List;
      for (var currencyJson in currenciesData) {
        currenciesList.add(Currency.fromJson(currencyJson as Map<String, dynamic>));
      }
    }

    return CashEnding(
      cashEndingId: json['cash_ending_id']?.toString(),
      companyId: json['company_id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? json['created_by']?.toString() ?? '',
      locationId: json['cash_location_id']?.toString() ?? '',
      storeId: json['store_id']?.toString(),
      recordDate: json['record_date'] != null
          ? DateTime.parse(json['record_date'].toString())
          : DateTime.now(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : DateTime.now(),
      currencies: currenciesList,
    );
  }

  /// Convert to JSON for database storage
  Map<String, dynamic> toJson() {
    return {
      'cash_ending_id': cashEndingId,
      'company_id': companyId,
      'user_id': userId,
      'cash_location_id': locationId,
      'store_id': storeId,
      'record_date': recordDate.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'currencies': currencies.map((c) => c.toJson()).toList(),
    };
  }

  /// Convert to RPC parameters for Supabase function call
  ///
  /// This matches the format expected by insert_cashier_amount_lines RPC
  /// Converts local datetime to UTC for database storage
  Map<String, dynamic> toRpcParams() {
    // Build currencies array for RPC
    // Note: Include currencies even if all denominations are 0 (cash can be 0)
    final currenciesJson = currencies.map((currency) {
      // Include all denominations with their quantities (including 0)
      final denominationsJson = currency.denominations
          .map((d) => {
                'denomination_id': d.denominationId,
                'quantity': d.quantity,
              })
          .toList();

      return {
        'currency_id': currency.currencyId,
        'denominations': denominationsJson,
      };
    }).toList();

    return {
      'p_company_id': companyId,
      'p_location_id': locationId,
      'p_record_date': DateTimeUtils.toDateOnly(recordDate), // Date only, no timezone conversion
      'p_created_by': userId,
      'p_currencies': currenciesJson,
      'p_created_at': DateTimeUtils.toRpcFormat(createdAt), // Convert to UTC for RPC
      'p_store_id': (storeId == null || storeId == 'headquarter') ? null : storeId,
    };
  }

  /// Calculate grand total across all currencies
  double get grandTotal {
    return currencies.fold(
      0.0,
      (sum, currency) => sum + currency.totalAmount,
    );
  }

  /// Get only currencies that have data (denominations with quantities)
  List<Currency> get activeCurrencies {
    return currencies.where((currency) => currency.hasData).toList();
  }

  /// Check if this cash ending has any data
  bool get hasData {
    return currencies.any((currency) => currency.hasData);
  }

  /// Check if this is for headquarter location
  bool get isHeadquarter => storeId == null || storeId == 'headquarter';
}
