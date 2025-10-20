// lib/features/cash_ending/data/models/cash_ending_model.dart

import '../../../../core/utils/datetime_utils.dart';
import '../../domain/entities/cash_ending.dart';
import 'currency_model.dart';

/// Data Transfer Object for Cash Ending
/// Handles JSON serialization/deserialization
class CashEndingModel {
  final String? cashEndingId;
  final String companyId;
  final String userId;
  final String locationId;
  final String? storeId;
  final DateTime recordDate;
  final DateTime createdAt;
  final List<CurrencyModel> currencies;

  const CashEndingModel({
    this.cashEndingId,
    required this.companyId,
    required this.userId,
    required this.locationId,
    this.storeId,
    required this.recordDate,
    required this.createdAt,
    required this.currencies,
  });

  /// Create from JSON (from database)
  ///
  /// Converts UTC datetime from database to local time for display
  factory CashEndingModel.fromJson(Map<String, dynamic> json) {
    return CashEndingModel(
      cashEndingId: json['cash_ending_id']?.toString(),
      companyId: json['company_id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? json['created_by']?.toString() ?? '',
      locationId: json['location_id']?.toString() ?? '',
      storeId: json['store_id']?.toString(),
      recordDate: DateTimeUtils.toLocal(
        json['record_date']?.toString() ?? DateTimeUtils.nowUtc(),
      ),
      createdAt: DateTimeUtils.toLocal(
        json['created_at']?.toString() ?? DateTimeUtils.nowUtc(),
      ),
      currencies: (json['currencies'] as List<dynamic>?)
              ?.map((c) => CurrencyModel.fromJson(c as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  /// Convert to JSON for RPC call (Supabase format)
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
              },)
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

  /// Convert to JSON (standard format)
  Map<String, dynamic> toJson() {
    return {
      if (cashEndingId != null) 'cash_ending_id': cashEndingId,
      'company_id': companyId,
      'user_id': userId,
      'location_id': locationId,
      if (storeId != null) 'store_id': storeId,
      'record_date': recordDate.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'currencies': currencies.map((c) => c.toJson()).toList(),
    };
  }

  /// Convert to Domain Entity
  CashEnding toEntity() {
    return CashEnding(
      cashEndingId: cashEndingId,
      companyId: companyId,
      userId: userId,
      locationId: locationId,
      storeId: storeId,
      recordDate: recordDate,
      createdAt: createdAt,
      currencies: currencies.map((c) => c.toEntity()).toList(),
    );
  }

  /// Create from Domain Entity
  factory CashEndingModel.fromEntity(CashEnding entity) {
    return CashEndingModel(
      cashEndingId: entity.cashEndingId,
      companyId: entity.companyId,
      userId: entity.userId,
      locationId: entity.locationId,
      storeId: entity.storeId,
      recordDate: entity.recordDate,
      createdAt: entity.createdAt,
      currencies: entity.currencies
          .map((c) => CurrencyModel.fromEntity(c))
          .toList(),
    );
  }
}
