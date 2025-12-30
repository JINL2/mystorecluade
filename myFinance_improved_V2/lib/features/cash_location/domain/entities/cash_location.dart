// Domain Entity - Business Object
// This represents the core business concept, independent of data sources
// Note: JSON serialization is handled by data/models layer

import 'package:freezed_annotation/freezed_annotation.dart';

part 'cash_location.freezed.dart';

@freezed
class CashLocation with _$CashLocation {
  const CashLocation._();

  const factory CashLocation({
    required String locationId,
    required String locationName,
    required String locationType,
    required double totalJournalCashAmount,
    required double totalRealCashAmount,
    required double cashDifference,
    required String companyId,
    String? storeId,
    required String currencySymbol,
    String? currencyCode,
    @Default(false) bool isDeleted,
    // Bank-specific fields
    String? bankName,
    String? bankAccount,
    String? beneficiaryName,
    String? bankAddress,
    String? swiftCode,
    String? bankBranch,
    String? accountType,
  }) = _CashLocation;

  // Business logic: Calculate error count or status
  bool get hasDiscrepancy => cashDifference.abs() > 0.01;

  double get discrepancyPercentage {
    if (totalJournalCashAmount == 0) return 0.0;
    return (cashDifference / totalJournalCashAmount) * 100;
  }
}
