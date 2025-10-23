import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/value_objects/debt_filter.dart';

/// Debt filter state provider
/// Manages the current filter state for debt list
final debtFilterProvider =
    StateNotifierProvider<DebtFilterNotifier, DebtFilter>(
  (ref) => DebtFilterNotifier(),
);

class DebtFilterNotifier extends StateNotifier<DebtFilter> {
  DebtFilterNotifier() : super(const DebtFilter());

  /// Update counterparty type filter
  void setCounterpartyType(String type) {
    state = state.copyWith(counterpartyType: type);
  }

  /// Update risk category filter
  void setRiskCategory(String category) {
    state = state.copyWith(riskCategory: category);
  }

  /// Update payment status filter
  void setPaymentStatus(String status) {
    state = state.copyWith(paymentStatus: status);
  }

  /// Update search query
  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  /// Update date range
  void setDateRange(DateTime? from, DateTime? to) {
    state = state.copyWith(fromDate: from, toDate: to);
  }

  /// Reset all filters
  void reset() {
    state = const DebtFilter();
  }

  /// Apply multiple filters at once
  void applyFilters({
    String? counterpartyType,
    String? riskCategory,
    String? paymentStatus,
    String? searchQuery,
    DateTime? fromDate,
    DateTime? toDate,
  }) {
    state = state.copyWith(
      counterpartyType: counterpartyType ?? state.counterpartyType,
      riskCategory: riskCategory ?? state.riskCategory,
      paymentStatus: paymentStatus ?? state.paymentStatus,
      searchQuery: searchQuery ?? state.searchQuery,
      fromDate: fromDate ?? state.fromDate,
      toDate: toDate ?? state.toDate,
    );
  }
}
