import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/analytics_providers.dart';
import '../../domain/entities/supply_chain_status.dart';
import '../../domain/repositories/inventory_analytics_repository.dart';

/// Supply Chain State
class SupplyChainState {
  final bool isLoading;
  final bool isRefreshing;
  final SupplyChainStatus? data;
  final String? errorMessage;

  const SupplyChainState({
    this.isLoading = false,
    this.isRefreshing = false,
    this.data,
    this.errorMessage,
  });

  SupplyChainState copyWith({
    bool? isLoading,
    bool? isRefreshing,
    SupplyChainStatus? data,
    String? errorMessage,
  }) {
    return SupplyChainState(
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      data: data ?? this.data,
      errorMessage: errorMessage,
    );
  }

  bool get hasData => data != null;
  bool get hasError => errorMessage != null;
}

/// Supply Chain Provider
final supplyChainProvider =
    StateNotifierProvider.autoDispose<SupplyChainNotifier, SupplyChainState>(
  (ref) {
    final repository = ref.watch(inventoryAnalyticsRepositoryProvider);
    return SupplyChainNotifier(repository);
  },
);

class SupplyChainNotifier extends StateNotifier<SupplyChainState> {
  final InventoryAnalyticsRepository _repository;

  SupplyChainNotifier(this._repository) : super(const SupplyChainState());

  Future<void> loadData({
    required String companyId,
  }) async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _repository.getSupplyChainStatus(
      companyId: companyId,
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

    final result = await _repository.getSupplyChainStatus(
      companyId: companyId,
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
}
