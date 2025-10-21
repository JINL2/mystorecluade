// Data Layer - Cash Real Models (DTOs) with Mappers

import '../../domain/entities/cash_real_entry.dart' as domain;

/// Cash Real Entry Model - DTO
class CashRealEntryModel {
  final String createdAt;
  final String recordDate;
  final String locationId;
  final String locationName;
  final String locationType;
  final double totalAmount;
  final List<CurrencySummaryModel> currencySummary;

  CashRealEntryModel({
    required this.createdAt,
    required this.recordDate,
    required this.locationId,
    required this.locationName,
    required this.locationType,
    required this.totalAmount,
    required this.currencySummary,
  });

  /// From JSON → Model
  factory CashRealEntryModel.fromJson(Map<String, dynamic> json) {
    return CashRealEntryModel(
      createdAt: json['created_at'] as String? ?? '',
      recordDate: json['record_date'] as String? ?? '',
      locationId: json['location_id'] as String? ?? '',
      locationName: json['location_name'] as String? ?? '',
      locationType: json['location_type'] as String? ?? '',
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
      currencySummary: (json['currency_summary'] as List? ?? [])
          .map((cs) => CurrencySummaryModel.fromJson(cs as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Model → Domain Entity
  domain.CashRealEntry toEntity() {
    return domain.CashRealEntry(
      createdAt: createdAt,
      recordDate: recordDate,
      locationId: locationId,
      locationName: locationName,
      locationType: locationType,
      totalAmount: totalAmount,
      currencySummary: currencySummary.map((cs) => cs.toEntity()).toList(),
    );
  }
}

/// Currency Summary Model - DTO
class CurrencySummaryModel {
  final String currencyId;
  final String currencyCode;
  final String currencyName;
  final String symbol;
  final double totalValue;
  final List<DenominationModel> denominations;

  CurrencySummaryModel({
    required this.currencyId,
    required this.currencyCode,
    required this.currencyName,
    required this.symbol,
    required this.totalValue,
    required this.denominations,
  });

  factory CurrencySummaryModel.fromJson(Map<String, dynamic> json) {
    return CurrencySummaryModel(
      currencyId: json['currency_id'] as String? ?? '',
      currencyCode: json['currency_code'] as String? ?? '',
      currencyName: json['currency_name'] as String? ?? '',
      symbol: json['symbol'] as String? ?? '',
      totalValue: (json['total_value'] as num?)?.toDouble() ?? 0.0,
      denominations: (json['denominations'] as List? ?? [])
          .map((d) => DenominationModel.fromJson(d as Map<String, dynamic>))
          .toList(),
    );
  }

  domain.CurrencySummary toEntity() {
    return domain.CurrencySummary(
      currencyId: currencyId,
      currencyCode: currencyCode,
      currencyName: currencyName,
      symbol: symbol,
      totalValue: totalValue,
      denominations: denominations.map((d) => d.toEntity()).toList(),
    );
  }
}

/// Denomination Model - DTO
class DenominationModel {
  final String denominationId;
  final String denominationType;
  final double denominationValue;
  final int quantity;
  final double subtotal;

  DenominationModel({
    required this.denominationId,
    required this.denominationType,
    required this.denominationValue,
    required this.quantity,
    required this.subtotal,
  });

  factory DenominationModel.fromJson(Map<String, dynamic> json) {
    return DenominationModel(
      denominationId: json['denomination_id'] as String? ?? '',
      denominationType: json['denomination_type'] as String? ?? '',
      denominationValue: (json['denomination_value'] as num?)?.toDouble() ?? 0.0,
      quantity: json['quantity'] as int? ?? 0,
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
    );
  }

  domain.Denomination toEntity() {
    return domain.Denomination(
      denominationId: denominationId,
      denominationType: denominationType,
      denominationValue: denominationValue,
      quantity: quantity,
      subtotal: subtotal,
    );
  }
}

/// Display model for the UI (Presentation layer concern, keep in model for backward compatibility)
class CashRealDisplay {
  final String date;
  final String time;
  final String title;
  final String locationName;
  final double amount;
  final domain.CashRealEntry realEntry;

  CashRealDisplay({
    required this.date,
    required this.time,
    required this.title,
    required this.locationName,
    required this.amount,
    required this.realEntry,
  });
}

/// Parameters for the provider
class CashRealParams {
  final String companyId;
  final String storeId;
  final String locationType;
  final int offset;
  final int limit;

  CashRealParams({
    required this.companyId,
    required this.storeId,
    required this.locationType,
    this.offset = 0,
    this.limit = 20,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CashRealParams &&
          runtimeType == other.runtimeType &&
          companyId == other.companyId &&
          storeId == other.storeId &&
          locationType == other.locationType &&
          offset == other.offset &&
          limit == other.limit;

  @override
  int get hashCode =>
      companyId.hashCode ^
      storeId.hashCode ^
      locationType.hashCode ^
      offset.hashCode ^
      limit.hashCode;
}
