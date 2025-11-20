import 'package:freezed_annotation/freezed_annotation.dart';
import '../revenue_period.dart';

part 'revenue.freezed.dart';

/// Revenue domain entity
///
/// Represents revenue data for a specific company/store and time period.
/// This is a pure domain entity without any UI state (no isLoading, errorMessage).
@freezed
class Revenue with _$Revenue {
  const Revenue._();

  const factory Revenue({
    required double amount,
    required String currencyCode,
    required RevenuePeriod period,
    required double previousAmount,
    required DateTime lastUpdated,
    String? storeId,
    String? companyId,
  }) = _Revenue;

  /// Calculate growth percentage
  double get growthPercentage {
    if (previousAmount <= 0) return 0.0;
    return ((amount - previousAmount) / previousAmount) * 100;
  }

  /// Check if revenue increased
  bool get isIncreased => amount >= previousAmount;

  /// Get absolute growth amount
  double get growthAmount => amount - previousAmount;
}
