// Domain Entity - Business Object
// This represents the core business concept, independent of data sources

class CashLocation {
  final String locationId;
  final String locationName;
  final String locationType;
  final double totalJournalCashAmount;
  final double totalRealCashAmount;
  final double cashDifference;
  final String companyId;
  final String? storeId;
  final String currencySymbol;
  final bool isDeleted;

  const CashLocation({
    required this.locationId,
    required this.locationName,
    required this.locationType,
    required this.totalJournalCashAmount,
    required this.totalRealCashAmount,
    required this.cashDifference,
    required this.companyId,
    required this.currencySymbol,
    this.storeId,
    this.isDeleted = false,
  });

  // Business logic: Calculate error count or status
  bool get hasDiscrepancy => cashDifference.abs() > 0.01;

  double get discrepancyPercentage {
    if (totalJournalCashAmount == 0) return 0.0;
    return (cashDifference / totalJournalCashAmount) * 100;
  }

  // Copy with method for immutability
  CashLocation copyWith({
    String? locationId,
    String? locationName,
    String? locationType,
    double? totalJournalCashAmount,
    double? totalRealCashAmount,
    double? cashDifference,
    String? companyId,
    String? storeId,
    String? currencySymbol,
    bool? isDeleted,
  }) {
    return CashLocation(
      locationId: locationId ?? this.locationId,
      locationName: locationName ?? this.locationName,
      locationType: locationType ?? this.locationType,
      totalJournalCashAmount: totalJournalCashAmount ?? this.totalJournalCashAmount,
      totalRealCashAmount: totalRealCashAmount ?? this.totalRealCashAmount,
      cashDifference: cashDifference ?? this.cashDifference,
      companyId: companyId ?? this.companyId,
      storeId: storeId ?? this.storeId,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CashLocation &&
          runtimeType == other.runtimeType &&
          locationId == other.locationId &&
          companyId == other.companyId;

  @override
  int get hashCode => locationId.hashCode ^ companyId.hashCode;
}
