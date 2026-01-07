import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/analytics_providers.dart';
import '../../domain/repositories/inventory_analytics_repository.dart';
import 'analytics_hub_state.dart';

/// Analytics Hub Provider
/// Hub 페이지의 전체 데이터를 관리
final analyticsHubProvider =
    StateNotifierProvider.autoDispose<AnalyticsHubNotifier, AnalyticsHubState>(
  (ref) {
    final repository = ref.watch(inventoryAnalyticsRepositoryProvider);
    return AnalyticsHubNotifier(repository);
  },
);

class AnalyticsHubNotifier extends StateNotifier<AnalyticsHubState> {
  final InventoryAnalyticsRepository _repository;

  AnalyticsHubNotifier(this._repository) : super(const AnalyticsHubState());

  /// Hub 데이터 로드
  Future<void> loadData({
    required String companyId,
    String? storeId,
  }) async {
    if (state.isLoading) return;

    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
    );

    final result = await _repository.getHubData(
      companyId: companyId,
      storeId: storeId,
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

  /// Pull-to-refresh
  Future<void> refresh({
    required String companyId,
    String? storeId,
  }) async {
    if (state.isRefreshing) return;

    state = state.copyWith(isRefreshing: true);

    final result = await _repository.getHubData(
      companyId: companyId,
      storeId: storeId,
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
