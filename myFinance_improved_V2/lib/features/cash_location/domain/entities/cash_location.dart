// Domain Entity - Business Object
// This represents the core business concept, independent of data sources

import 'package:freezed_annotation/freezed_annotation.dart';

part 'cash_location.freezed.dart';
part 'cash_location.g.dart';

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
    @Default(false) bool isDeleted,
  }) = _CashLocation;

  // Business logic: Calculate error count or status
  bool get hasDiscrepancy => cashDifference.abs() > 0.01;

  double get discrepancyPercentage {
    if (totalJournalCashAmount == 0) return 0.0;
    return (cashDifference / totalJournalCashAmount) * 100;
  }

  factory CashLocation.fromJson(Map<String, dynamic> json) =>
      _$CashLocationFromJson(json);
}
