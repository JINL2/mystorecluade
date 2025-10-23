import 'package:freezed_annotation/freezed_annotation.dart';

part 'debt_filter.freezed.dart';

/// Filter criteria for debt list filtering
@freezed
class DebtFilter with _$DebtFilter {
  const factory DebtFilter({
    @Default('all') String counterpartyType,
    @Default('all') String riskCategory,
    @Default('all') String paymentStatus,
    @Default(0) int minDaysOverdue,
    @Default(0.0) double minAmount,
    @Default(false) bool hasPaymentPlan,
    @Default(false) bool isDisputed,
    DateTime? fromDate,
    DateTime? toDate,
    String? searchQuery,
  }) = _DebtFilter;

  const DebtFilter._();

  /// Check if filter is active (not default)
  bool get isActive =>
      counterpartyType != 'all' ||
      riskCategory != 'all' ||
      paymentStatus != 'all' ||
      minDaysOverdue > 0 ||
      minAmount > 0 ||
      hasPaymentPlan ||
      isDisputed ||
      fromDate != null ||
      toDate != null ||
      (searchQuery != null && searchQuery!.isNotEmpty);

  /// Get active filter count
  int get activeFilterCount {
    int count = 0;
    if (counterpartyType != 'all') count++;
    if (riskCategory != 'all') count++;
    if (paymentStatus != 'all') count++;
    if (minDaysOverdue > 0) count++;
    if (minAmount > 0) count++;
    if (hasPaymentPlan) count++;
    if (isDisputed) count++;
    if (fromDate != null) count++;
    if (toDate != null) count++;
    if (searchQuery != null && searchQuery!.isNotEmpty) count++;
    return count;
  }

  /// Reset to default filter
  DebtFilter reset() => const DebtFilter();
}
