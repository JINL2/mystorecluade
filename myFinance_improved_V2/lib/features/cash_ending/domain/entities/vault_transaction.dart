// lib/features/cash_ending/domain/entities/vault_transaction.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/utils/datetime_utils.dart';
import 'currency.dart';

part 'vault_transaction.freezed.dart';

/// Domain entity representing a vault transaction (in/out)
///
/// Uses Freezed for:
/// - Immutability guarantee
/// - Auto-generated copyWith, ==, hashCode
/// - Type-safe constructors
@freezed
class VaultTransaction with _$VaultTransaction {
  // Private constructor for custom methods
  const VaultTransaction._();

  /// Factory constructor with validation assertions
  ///
  /// Business rule: transaction must be either credit OR debit, not both or neither
  const factory VaultTransaction({
    String? vaultTransactionId,
    required String companyId,
    required String userId,
    required String locationId,
    String? storeId,
    required String currencyId,
    required bool isCredit,
    required bool isDebit,
    required DateTime recordDate,
    required DateTime createdAt,
    required Currency currency,
  }) = _VaultTransaction;

  /// Create from JSON (from database)
  ///
  /// Handles custom field mappings and default values
  factory VaultTransaction.fromJson(Map<String, dynamic> json) {
    final userId = json['user_id']?.toString() ??
                   json['created_by']?.toString() ??
                   '';

    // Parse currency
    final Currency currency;
    if (json['currency'] != null) {
      currency = Currency.fromJson(json['currency'] as Map<String, dynamic>);
    } else {
      // Fallback: create empty currency
      currency = Currency(
        currencyId: json['currency_id']?.toString() ?? '',
        currencyCode: '',
        currencyName: '',
        symbol: '',
        denominations: const [],
      );
    }

    return VaultTransaction(
      vaultTransactionId: json['vault_transaction_id']?.toString(),
      companyId: json['company_id']?.toString() ?? '',
      userId: userId,
      locationId: json['location_id']?.toString() ?? '',
      storeId: json['store_id']?.toString(),
      currencyId: json['currency_id']?.toString() ?? '',
      isCredit: json['credit'] as bool? ?? false,
      isDebit: json['debit'] as bool? ?? false,
      recordDate: json['record_date'] != null
          ? DateTimeUtils.toLocal(json['record_date'].toString())
          : DateTime.now(),
      createdAt: json['created_at'] != null
          ? DateTimeUtils.toLocal(json['created_at'].toString())
          : DateTime.now(),
      currency: currency,
    );
  }

  /// Convert to JSON (standard format)
  Map<String, dynamic> toJson() {
    return {
      if (vaultTransactionId != null) 'vault_transaction_id': vaultTransactionId,
      'company_id': companyId,
      'user_id': userId,
      'location_id': locationId,
      if (storeId != null) 'store_id': storeId,
      'currency_id': currencyId,
      'credit': isCredit,
      'debit': isDebit,
      'record_date': recordDate.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'currency': currency.toJson(),
    };
  }

  /// Convert to RPC parameters for Supabase
  ///
  /// This matches the format expected by vault_amount_insert RPC
  Map<String, dynamic> toRpcParams() {
    // Build vault_amount_line_json with denomination details
    final List<Map<String, dynamic>> vaultAmountLineJson = [];

    for (final denom in currency.denominations) {
      if (denom.quantity > 0) {
        vaultAmountLineJson.add({
          'quantity': denom.quantity.toString(),
          'denomination_id': denom.denominationId,
          'denomination_value': denom.value.toString(),
          'denomination_type': 'BILL', // Default type
        });
      }
    }

    return {
      'p_location_id': locationId,
      'p_company_id': companyId,
      'p_created_at': DateTimeUtils.toRpcFormat(createdAt),
      'p_created_by': userId,
      'p_credit': isCredit,
      'p_debit': isDebit,
      'p_currency_id': currencyId,
      'p_record_date': DateTimeUtils.toDateOnly(recordDate),
      'p_store_id': (storeId == null || storeId == 'headquarter') ? null : storeId,
      'p_vault_amount_line_json': vaultAmountLineJson,
    };
  }

  /// Get transaction type as string
  String get transactionType => isCredit ? 'credit' : 'debit';

  /// Calculate total amount from currency denominations
  double get totalAmount => currency.totalAmount;

  /// Check if this is for headquarter location
  bool get isHeadquarter => storeId == null || storeId == 'headquarter';
}
