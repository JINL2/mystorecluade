// Data Layer - Vault Real Models (DTOs) with Mappers

import '../../domain/entities/bank_real_entry.dart' as bank_domain;
import '../../domain/entities/vault_real_entry.dart' as domain;

/// Vault Real Entry Model - DTO
class VaultRealEntryModel {
  final String recordDate;
  final String locationId;
  final String locationName;
  final String locationType;
  final List<VaultCurrencySummaryModel> currencySummary;

  VaultRealEntryModel({
    required this.recordDate,
    required this.locationId,
    required this.locationName,
    required this.locationType,
    required this.currencySummary,
  });

  /// From JSON → Model
  factory VaultRealEntryModel.fromJson(Map<String, dynamic> json) {
    return VaultRealEntryModel(
      recordDate: json['record_date'] as String? ?? '',
      locationId: json['location_id'] as String? ?? '',
      locationName: json['location_name'] as String? ?? '',
      locationType: json['location_type'] as String? ?? '',
      currencySummary: (json['currency_summary'] as List? ?? [])
          .map((cs) => VaultCurrencySummaryModel.fromJson(cs as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Model → Domain Entity
  domain.VaultRealEntry toEntity() {
    // Use record_date as createdAt since vault doesn't have separate createdAt
    final createdAt = recordDate;
    final totalAmount = currencySummary.fold(0.0, (sum, cs) => sum + cs.totalValue);

    return domain.VaultRealEntry(
      createdAt: createdAt,
      recordDate: recordDate,
      locationId: locationId,
      locationName: locationName,
      totalAmount: totalAmount,
      currencySummary: currencySummary.map((cs) => cs.toEntity()).toList(),
    );
  }
}

/// Vault Currency Summary Model - DTO
class VaultCurrencySummaryModel {
  final String currencyId;
  final String currencyCode;
  final String currencyName;
  final String symbol;
  final double totalValue;
  final List<VaultDenominationModel> denominations;

  VaultCurrencySummaryModel({
    required this.currencyId,
    required this.currencyCode,
    required this.currencyName,
    required this.symbol,
    required this.totalValue,
    required this.denominations,
  });

  factory VaultCurrencySummaryModel.fromJson(Map<String, dynamic> json) {
    return VaultCurrencySummaryModel(
      currencyId: json['currency_id'] as String? ?? '',
      currencyCode: json['currency_code'] as String? ?? '',
      currencyName: json['currency_name'] as String? ?? '',
      symbol: json['symbol'] as String? ?? '',
      totalValue: (json['total_value'] as num?)?.toDouble() ?? 0.0,
      denominations: (json['denominations'] as List? ?? [])
          .map((d) => VaultDenominationModel.fromJson(d as Map<String, dynamic>))
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

/// Vault Denomination Model - DTO
class VaultDenominationModel {
  final double denominationValue;
  final int dailyChange;
  final int runningQuantity;
  final double runningTotal;

  VaultDenominationModel({
    required this.denominationValue,
    required this.dailyChange,
    required this.runningQuantity,
    required this.runningTotal,
  });

  factory VaultDenominationModel.fromJson(Map<String, dynamic> json) {
    return VaultDenominationModel(
      denominationValue: (json['denomination_value'] as num?)?.toDouble() ?? 0.0,
      dailyChange: json['daily_change'] as int? ?? 0,
      runningQuantity: json['running_quantity'] as int? ?? 0,
      runningTotal: (json['running_total'] as num?)?.toDouble() ?? 0.0,
    );
  }

  bank_domain.Denomination toEntity() {
    // Map vault denomination to domain denomination
    // Vault has different structure, so we adapt it
    return bank_domain.Denomination(
      denominationId: '', // Vault doesn't have ID
      denominationType: 'vault',
      denominationValue: denominationValue,
      quantity: runningQuantity,
      subtotal: runningTotal,
    );
  }
}
