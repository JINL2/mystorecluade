import '../revenue_period.dart';

/// Revenue domain entity
///
/// Represents revenue data for a specific company/store and time period.
/// This is a pure domain entity without any UI state (no isLoading, errorMessage).
class Revenue {
  const Revenue({
    required this.amount,
    required this.currencyCode,
    required this.period,
    required this.previousAmount,
    required this.lastUpdated,
    this.storeId,
    this.companyId,
  });

  /// Current revenue amount
  final double amount;

  /// Currency code (e.g., 'USD', 'KRW')
  final String currencyCode;

  /// Time period for this revenue data
  final RevenuePeriod period;

  /// Previous period's revenue amount for comparison
  final double previousAmount;

  /// Last time this data was updated
  final DateTime lastUpdated;

  /// Optional store ID (null means company-level revenue)
  final String? storeId;

  /// Optional company ID
  final String? companyId;

  /// Calculate growth percentage
  double get growthPercentage {
    if (previousAmount <= 0) return 0.0;
    return ((amount - previousAmount) / previousAmount) * 100;
  }

  /// Check if revenue increased
  bool get isIncreased => amount >= previousAmount;

  /// Get absolute growth amount
  double get growthAmount => amount - previousAmount;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Revenue &&
          runtimeType == other.runtimeType &&
          amount == other.amount &&
          currencyCode == other.currencyCode &&
          period == other.period &&
          previousAmount == other.previousAmount &&
          storeId == other.storeId &&
          companyId == other.companyId;

  @override
  int get hashCode =>
      amount.hashCode ^
      currencyCode.hashCode ^
      period.hashCode ^
      previousAmount.hashCode ^
      storeId.hashCode ^
      companyId.hashCode;

  @override
  String toString() {
    return 'Revenue(amount: $amount, currency: $currencyCode, period: ${period.name}, '
        'previous: $previousAmount, growth: ${growthPercentage.toStringAsFixed(1)}%)';
  }
}
