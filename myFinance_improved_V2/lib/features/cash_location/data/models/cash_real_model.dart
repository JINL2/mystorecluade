// Data Layer - Cash Real Models (DTOs) with Mappers

import '../../../../core/utils/datetime_utils.dart';
import '../../domain/entities/bank_real_entry.dart' as bank_domain;
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
    // Convert UTC datetime string from database to local time ISO8601 string
    final createdAtUtc = json['created_at'] as String? ?? '';

    return CashRealEntryModel(
      createdAt: createdAtUtc.isNotEmpty ? DateTimeUtils.toLocal(createdAtUtc).toIso8601String() : '',
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

  bank_domain.CurrencySummary toEntity() {
    return bank_domain.CurrencySummary(
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

  bank_domain.Denomination toEntity() {
    return bank_domain.Denomination(
      denominationId: denominationId,
      denominationType: denominationType,
      denominationValue: denominationValue,
      quantity: quantity,
      subtotal: subtotal,
    );
  }
}
