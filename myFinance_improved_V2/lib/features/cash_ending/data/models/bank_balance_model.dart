// lib/features/cash_ending/data/models/bank_balance_model.dart

import 'package:intl/intl.dart';
import '../../domain/entities/bank_balance.dart';

/// Data Transfer Object for Bank Balance
/// Handles JSON serialization/deserialization and RPC parameter formatting
class BankBalanceModel {
  final String? balanceId;
  final String companyId;
  final String? storeId;
  final String locationId;
  final String currencyId;
  final int totalAmount;
  final String userId;
  final DateTime recordDate;
  final DateTime createdAt;

  const BankBalanceModel({
    this.balanceId,
    required this.companyId,
    this.storeId,
    required this.locationId,
    required this.currencyId,
    required this.totalAmount,
    required this.userId,
    required this.recordDate,
    required this.createdAt,
  });

  /// Convert to RPC parameters for Supabase (bank_amount_insert_v2)
  ///
  /// This matches the exact format expected by the stored procedure
  Map<String, dynamic> toRpcParams() {
    // Format dates as required by RPC
    final recordDateStr = DateFormat('yyyy-MM-dd').format(recordDate);
    final createdAtStr = DateFormat('yyyy-MM-dd HH:mm:ss').format(createdAt) +
        '.${createdAt.microsecond.toString().padLeft(6, '0')}';

    return {
      'p_company_id': companyId,
      'p_store_id': (storeId == null || storeId == 'headquarter') ? null : storeId,
      'p_record_date': recordDateStr,
      'p_location_id': locationId,
      'p_currency_id': currencyId,
      'p_total_amount': totalAmount,
      'p_created_by': userId,
      'p_created_at': createdAtStr,
    };
  }

  /// Convert to Domain Entity
  BankBalance toEntity() {
    return BankBalance(
      balanceId: balanceId,
      companyId: companyId,
      storeId: storeId,
      locationId: locationId,
      currencyId: currencyId,
      totalAmount: totalAmount,
      userId: userId,
      recordDate: recordDate,
      createdAt: createdAt,
    );
  }

  /// Create from Domain Entity
  factory BankBalanceModel.fromEntity(BankBalance entity) {
    return BankBalanceModel(
      balanceId: entity.balanceId,
      companyId: entity.companyId,
      storeId: entity.storeId,
      locationId: entity.locationId,
      currencyId: entity.currencyId,
      totalAmount: entity.totalAmount,
      userId: entity.userId,
      recordDate: entity.recordDate,
      createdAt: entity.createdAt,
    );
  }

  /// Create from JSON (from database)
  factory BankBalanceModel.fromJson(Map<String, dynamic> json) {
    return BankBalanceModel(
      balanceId: json['balance_id']?.toString(),
      companyId: json['company_id']?.toString() ?? '',
      storeId: json['store_id']?.toString(),
      locationId: json['location_id']?.toString() ?? '',
      currencyId: json['currency_id']?.toString() ?? '',
      totalAmount: (json['total_amount'] as num?)?.toInt() ?? 0,
      userId: json['created_by']?.toString() ?? '',
      recordDate: json['record_date'] != null
          ? DateTime.parse(json['record_date'].toString())
          : DateTime.now(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : DateTime.now(),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      if (balanceId != null) 'balance_id': balanceId,
      'company_id': companyId,
      if (storeId != null) 'store_id': storeId,
      'location_id': locationId,
      'currency_id': currencyId,
      'total_amount': totalAmount,
      'created_by': userId,
      'record_date': recordDate.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}
