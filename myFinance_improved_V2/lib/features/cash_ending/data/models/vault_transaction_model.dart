// lib/features/cash_ending/data/models/vault_transaction_model.dart

import 'package:intl/intl.dart';
import '../../domain/entities/vault_transaction.dart';
import 'denomination_model.dart';

/// Data Transfer Object for Vault Transaction
/// Handles JSON serialization/deserialization and RPC parameter formatting
class VaultTransactionModel {
  final String? transactionId;
  final String companyId;
  final String? storeId;
  final String locationId;
  final String currencyId;
  final String userId;
  final DateTime recordDate;
  final DateTime createdAt;
  final bool isCredit;
  final List<DenominationModel> denominations;

  const VaultTransactionModel({
    this.transactionId,
    required this.companyId,
    this.storeId,
    required this.locationId,
    required this.currencyId,
    required this.userId,
    required this.recordDate,
    required this.createdAt,
    required this.isCredit,
    required this.denominations,
  });

  /// Convert to RPC parameters for Supabase (vault_amount_insert)
  ///
  /// This matches the exact format expected by the stored procedure
  Map<String, dynamic> toRpcParams() {
    // Format dates as required by RPC
    final recordDateStr = DateFormat('yyyy-MM-dd').format(recordDate);
    final createdAtStr = '${DateFormat('yyyy-MM-dd HH:mm:ss').format(createdAt)}'
        '.${createdAt.microsecond.toString().padLeft(6, '0')}';

    // Build vault_amount_line_json with denomination details
    final List<Map<String, dynamic>> vaultAmountLineJson = [];

    for (final denom in denominations) {
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
      'p_created_at': createdAtStr,
      'p_created_by': userId,
      'p_credit': isCredit,
      'p_debit': !isCredit,
      'p_currency_id': currencyId,
      'p_record_date': recordDateStr,
      'p_store_id': (storeId == null || storeId == 'headquarter') ? null : storeId,
      'p_vault_amount_line_json': vaultAmountLineJson,
    };
  }

  /// Convert to Domain Entity
  VaultTransaction toEntity() {
    return VaultTransaction(
      transactionId: transactionId,
      companyId: companyId,
      storeId: storeId,
      locationId: locationId,
      currencyId: currencyId,
      userId: userId,
      recordDate: recordDate,
      createdAt: createdAt,
      isCredit: isCredit,
      denominations: denominations.map((d) => d.toEntity()).toList(),
    );
  }

  /// Create from Domain Entity
  factory VaultTransactionModel.fromEntity(VaultTransaction entity) {
    return VaultTransactionModel(
      transactionId: entity.transactionId,
      companyId: entity.companyId,
      storeId: entity.storeId,
      locationId: entity.locationId,
      currencyId: entity.currencyId,
      userId: entity.userId,
      recordDate: entity.recordDate,
      createdAt: entity.createdAt,
      isCredit: entity.isCredit,
      denominations: entity.denominations
          .map((d) => DenominationModel.fromEntity(d))
          .toList(),
    );
  }

  /// Create from JSON (from database)
  factory VaultTransactionModel.fromJson(Map<String, dynamic> json) {
    return VaultTransactionModel(
      transactionId: json['transaction_id']?.toString(),
      companyId: json['company_id']?.toString() ?? '',
      storeId: json['store_id']?.toString(),
      locationId: json['location_id']?.toString() ?? '',
      currencyId: json['currency_id']?.toString() ?? '',
      userId: json['created_by']?.toString() ?? '',
      recordDate: json['record_date'] != null
          ? DateTime.parse(json['record_date'].toString())
          : DateTime.now(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : DateTime.now(),
      isCredit: json['credit'] as bool? ?? false,
      denominations: (json['denominations'] as List<dynamic>?)
              ?.map((d) => DenominationModel.fromJson(d as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      if (transactionId != null) 'transaction_id': transactionId,
      'company_id': companyId,
      if (storeId != null) 'store_id': storeId,
      'location_id': locationId,
      'currency_id': currencyId,
      'created_by': userId,
      'record_date': recordDate.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'credit': isCredit,
      'debit': !isCredit,
      'denominations': denominations.map((d) => d.toJson()).toList(),
    };
  }
}
