// Data Layer - Bank Real Models (DTOs) with Mappers

import '../../../../core/utils/datetime_utils.dart';
import '../../domain/entities/bank_real_entry.dart' as domain;

/// Bank Real Entry Model - DTO
class BankRealEntryModel {
  final String bankAmountId;
  final String createdAt;
  final String recordDate;
  final String locationId;
  final String locationName;
  final String locationType;
  final String currencyId;
  final String currencyCode;
  final String currencyName;
  final String symbol;
  final double totalAmount;

  BankRealEntryModel({
    required this.bankAmountId,
    required this.createdAt,
    required this.recordDate,
    required this.locationId,
    required this.locationName,
    required this.locationType,
    required this.currencyId,
    required this.currencyCode,
    required this.currencyName,
    required this.symbol,
    required this.totalAmount,
  });

  /// From JSON → Model
  factory BankRealEntryModel.fromJson(Map<String, dynamic> json) {
    // Convert UTC datetime string from database to local time ISO8601 string
    final createdAtUtc = json['created_at'] as String? ?? '';

    return BankRealEntryModel(
      bankAmountId: json['bank_amount_id'] as String? ?? '',
      createdAt: createdAtUtc.isNotEmpty ? DateTimeUtils.toLocal(createdAtUtc).toIso8601String() : '',
      recordDate: json['record_date'] as String? ?? '',
      locationId: json['location_id'] as String? ?? '',
      locationName: json['location_name'] as String? ?? '',
      locationType: json['location_type'] as String? ?? '',
      currencyId: json['currency_id'] as String? ?? '',
      currencyCode: json['currency_code'] as String? ?? '',
      currencyName: json['currency_name'] as String? ?? '',
      symbol: json['symbol'] as String? ?? '',
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// Model → Domain Entity
  domain.BankRealEntry toEntity() {
    // Create a single CurrencySummary from the flat structure
    final currencySummary = domain.CurrencySummary(
      currencyId: currencyId,
      currencyCode: currencyCode,
      currencyName: currencyName,
      symbol: symbol,
      totalValue: totalAmount,
      denominations: [], // Bank entries don't have denomination breakdown
    );

    return domain.BankRealEntry(
      createdAt: createdAt,
      recordDate: recordDate,
      locationId: locationId,
      locationName: locationName,
      totalAmount: totalAmount,
      currencySummary: [currencySummary],
    );
  }
}
