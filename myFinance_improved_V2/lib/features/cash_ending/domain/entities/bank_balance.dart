// lib/features/cash_ending/domain/entities/bank_balance.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/utils/datetime_utils.dart';

part 'bank_balance.freezed.dart';

/// Domain entity representing a bank balance record
///
/// Uses Freezed for:
/// - Immutability guarantee
/// - Auto-generated copyWith, ==, hashCode
/// - Type-safe constructors
@freezed
class BankBalance with _$BankBalance {
  // Private constructor for custom methods
  const BankBalance._();

  /// Factory constructor with validation assertions
  const factory BankBalance({
    String? bankBalanceId,
    required String companyId,
    required String userId,
    required String locationId,
    String? storeId,
    required String currencyId,
    required int totalAmount,
    required DateTime recordDate,
    required DateTime createdAt,
  }) = _BankBalance;

  /// Create from JSON (from database)
  ///
  /// Handles custom field mappings and default values
  factory BankBalance.fromJson(Map<String, dynamic> json) {
    // Handle alternative field names and defaults
    final userId = json['user_id']?.toString() ??
                   json['created_by']?.toString() ??
                   '';

    return BankBalance(
      bankBalanceId: json['bank_balance_id']?.toString(),
      companyId: json['company_id']?.toString() ?? '',
      userId: userId,
      locationId: json['location_id']?.toString() ?? '',
      storeId: json['store_id']?.toString(),
      currencyId: json['currency_id']?.toString() ?? '',
      totalAmount: json['total_amount'] as int? ?? 0,
      recordDate: json['record_date'] != null
          ? DateTimeUtils.toLocal(json['record_date'].toString())
          : DateTime.now(),
      createdAt: json['created_at'] != null
          ? DateTimeUtils.toLocal(json['created_at'].toString())
          : DateTime.now(),
    );
  }

  /// Convert to JSON (standard format)
  Map<String, dynamic> toJson() {
    return {
      if (bankBalanceId != null) 'bank_balance_id': bankBalanceId,
      'company_id': companyId,
      'user_id': userId,
      'location_id': locationId,
      if (storeId != null) 'store_id': storeId,
      'currency_id': currencyId,
      'total_amount': totalAmount,
      'record_date': recordDate.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Convert to RPC parameters for Supabase
  ///
  /// This matches the format expected by bank_amount_insert_v2 RPC
  Map<String, dynamic> toRpcParams() {
    return {
      'p_company_id': companyId,
      'p_store_id': (storeId == null || storeId == 'headquarter') ? null : storeId,
      'p_record_date': DateTimeUtils.toDateOnly(recordDate),
      'p_location_id': locationId,
      'p_currency_id': currencyId,
      'p_total_amount': totalAmount,
      'p_created_by': userId,
      'p_created_at': DateTimeUtils.toRpcFormat(createdAt),
    };
  }

  /// Check if this is for headquarter location
  bool get isHeadquarter => storeId == null || storeId == 'headquarter';
}
