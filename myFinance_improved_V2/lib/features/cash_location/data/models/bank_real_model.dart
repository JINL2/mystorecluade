// Data Layer - Bank Real Models (DTOs) with Mappers

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
    return BankRealEntryModel(
      bankAmountId: json['bank_amount_id'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
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

/// Display model for the UI (Presentation layer concern)
class BankRealDisplay {
  final String date;
  final String time;
  final String title;
  final String locationName;
  final double amount;
  final String currencySymbol;
  final domain.BankRealEntry realEntry;

  BankRealDisplay({
    required this.date,
    required this.time,
    required this.title,
    required this.locationName,
    required this.amount,
    required this.currencySymbol,
    required this.realEntry,
  });
}

/// Parameters for the provider
class BankRealParams {
  final String companyId;
  final String storeId;
  final int offset;
  final int limit;

  BankRealParams({
    required this.companyId,
    required this.storeId,
    this.offset = 0,
    this.limit = 20,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BankRealParams &&
          runtimeType == other.runtimeType &&
          companyId == other.companyId &&
          storeId == other.storeId &&
          offset == other.offset &&
          limit == other.limit;

  @override
  int get hashCode =>
      companyId.hashCode ^
      storeId.hashCode ^
      offset.hashCode ^
      limit.hashCode;
}
