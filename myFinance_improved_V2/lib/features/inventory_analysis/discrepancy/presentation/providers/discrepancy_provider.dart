import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/discrepancy_providers.dart';
import '../../domain/entities/discrepancy_overview.dart';
import '../../domain/repositories/discrepancy_repository.dart';

/// Discrepancy State
class DiscrepancyState {
  final bool isLoading;
  final bool isRefreshing;
  final DiscrepancyOverview? data;
  final String? errorMessage;
  final String selectedPeriod;

  const DiscrepancyState({
    this.isLoading = false,
    this.isRefreshing = false,
    this.data,
    this.errorMessage,
    this.selectedPeriod = 'all',
  });

  DiscrepancyState copyWith({
    bool? isLoading,
    bool? isRefreshing,
    DiscrepancyOverview? data,
    String? errorMessage,
    String? selectedPeriod,
  }) {
    return DiscrepancyState(
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      data: data ?? this.data,
      errorMessage: errorMessage,
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
    );
  }

  bool get hasData => data != null;
  bool get hasError => errorMessage != null;
}

/// Discrepancy Provider
final discrepancyProvider =
    StateNotifierProvider.autoDispose<DiscrepancyNotifier, DiscrepancyState>(
  (ref) {
    final repository = ref.watch(discrepancyRepositoryProvider);
    return DiscrepancyNotifier(repository);
  },
);

class DiscrepancyNotifier extends StateNotifier<DiscrepancyState> {
  final DiscrepancyRepository _repository;

  DiscrepancyNotifier(this._repository) : super(const DiscrepancyState());

  Future<void> loadData({
    required String companyId,
    String? period,
  }) async {
    if (state.isLoading) return;

    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      selectedPeriod: period ?? state.selectedPeriod,
    );

    final result = await _repository.getDiscrepancyOverview(
      companyId: companyId,
      period: period ?? state.selectedPeriod,
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (data) {
        state = state.copyWith(
          isLoading: false,
          data: data,
        );
      },
    );
  }

  Future<void> refresh({
    required String companyId,
  }) async {
    if (state.isRefreshing) return;

    state = state.copyWith(isRefreshing: true);

    final result = await _repository.getDiscrepancyOverview(
      companyId: companyId,
      period: state.selectedPeriod,
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          isRefreshing: false,
          errorMessage: failure.message,
        );
      },
      (data) {
        state = state.copyWith(
          isRefreshing: false,
          data: data,
          errorMessage: null,
        );
      },
    );
  }

  void changePeriod({
    required String companyId,
    required String period,
  }) {
    loadData(companyId: companyId, period: period);
  }
}
