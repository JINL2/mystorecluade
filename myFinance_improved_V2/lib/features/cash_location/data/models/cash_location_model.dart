// Data Layer - Models (DTOs) with Mappers
// These are Data Transfer Objects that map between API/Database and Domain

import '../../domain/entities/cash_location.dart' as domain;

/// Cash Location Model - DTO
class CashLocationModel {
  final String locationId;
  final String locationName;
  final String locationType;
  final double totalJournalCashAmount;
  final double totalRealCashAmount;
  final double cashDifference;
  final String companyId;
  final String? storeId;
  final String currencySymbol;
  final String? currencyCode;
  final bool isDeleted;
  // Bank-specific fields
  final String? bankName;
  final String? bankAccount;
  final String? beneficiaryName;
  final String? bankAddress;
  final String? swiftCode;
  final String? bankBranch;
  final String? accountType;

  CashLocationModel({
    required this.locationId,
    required this.locationName,
    required this.locationType,
    required this.totalJournalCashAmount,
    required this.totalRealCashAmount,
    required this.cashDifference,
    required this.companyId,
    required this.currencySymbol,
    this.currencyCode,
    this.storeId,
    this.isDeleted = false,
    this.bankName,
    this.bankAccount,
    this.beneficiaryName,
    this.bankAddress,
    this.swiftCode,
    this.bankBranch,
    this.accountType,
  });

  /// From JSON (API/Database) → Model
  factory CashLocationModel.fromJson(Map<String, dynamic> json) {
    // Check both possible field names for location ID
    final locationId = json['cash_location_id'] as String? ??
                      json['location_id'] as String? ?? '';

    return CashLocationModel(
      locationId: locationId,
      locationName: json['location_name'] as String? ?? '',
      locationType: json['location_type'] as String? ?? '',
      totalJournalCashAmount: (json['total_journal_cash_amount'] as num?)?.toDouble() ?? 0.0,
      totalRealCashAmount: (json['total_real_cash_amount'] as num?)?.toDouble() ?? 0.0,
      cashDifference: (json['cash_difference'] as num?)?.toDouble() ?? 0.0,
      companyId: json['company_id'] as String? ?? '',
      storeId: json['store_id'] as String?,
      currencySymbol: json['primary_currency_symbol'] as String? ?? '',
      currencyCode: json['primary_currency_code'] as String?,
      isDeleted: json['is_deleted'] as bool? ?? false,
      // Bank-specific fields
      bankName: json['bank_name'] as String?,
      bankAccount: json['bank_account'] as String?,
      beneficiaryName: json['beneficiary_name'] as String?,
      bankAddress: json['bank_address'] as String?,
      swiftCode: json['swift_code'] as String?,
      bankBranch: json['bank_branch'] as String?,
      accountType: json['account_type'] as String?,
    );
  }

  /// Model → Domain Entity
  domain.CashLocation toEntity() {
    return domain.CashLocation(
      locationId: locationId,
      locationName: locationName,
      locationType: locationType,
      totalJournalCashAmount: totalJournalCashAmount,
      totalRealCashAmount: totalRealCashAmount,
      cashDifference: cashDifference,
      companyId: companyId,
      storeId: storeId,
      currencySymbol: currencySymbol,
      currencyCode: currencyCode,
      isDeleted: isDeleted,
      bankName: bankName,
      bankAccount: bankAccount,
      beneficiaryName: beneficiaryName,
      bankAddress: bankAddress,
      swiftCode: swiftCode,
      bankBranch: bankBranch,
      accountType: accountType,
    );
  }

  /// Domain Entity → Model (for when we need to send data back)
  factory CashLocationModel.fromEntity(domain.CashLocation entity) {
    return CashLocationModel(
      locationId: entity.locationId,
      locationName: entity.locationName,
      locationType: entity.locationType,
      totalJournalCashAmount: entity.totalJournalCashAmount,
      totalRealCashAmount: entity.totalRealCashAmount,
      cashDifference: entity.cashDifference,
      companyId: entity.companyId,
      storeId: entity.storeId,
      currencySymbol: entity.currencySymbol,
      currencyCode: entity.currencyCode,
      isDeleted: entity.isDeleted,
      bankName: entity.bankName,
      bankAccount: entity.bankAccount,
      beneficiaryName: entity.beneficiaryName,
      bankAddress: entity.bankAddress,
      swiftCode: entity.swiftCode,
      bankBranch: entity.bankBranch,
      accountType: entity.accountType,
    );
  }
}
