import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/analytics_providers.dart';
import '../../domain/entities/analytics_entities.dart';
import '../../domain/repositories/inventory_analytics_repository.dart';

/// Sales Dashboard State
class SalesDashboardState {
  final bool isLoading;
  final bool isRefreshing;
  final SalesDashboard? data;
  final BcgMatrix? bcgMatrix;
  final String? errorMessage;

  const SalesDashboardState({
    this.isLoading = false,
    this.isRefreshing = false,
    this.data,
    this.bcgMatrix,
    this.errorMessage,
  });

  SalesDashboardState copyWith({
    bool? isLoading,
    bool? isRefreshing,
    SalesDashboard? data,
    BcgMatrix? bcgMatrix,
    String? errorMessage,
  }) {
    return SalesDashboardState(
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      data: data ?? this.data,
      bcgMatrix: bcgMatrix ?? this.bcgMatrix,
      errorMessage: errorMessage,
    );
  }

  bool get hasData => data != null;
  bool get hasError => errorMessage != null;
}

/// Sales Dashboard Provider
final salesDashboardProvider = StateNotifierProvider.autoDispose<
    SalesDashboardNotifier, SalesDashboardState>(
  (ref) {
    final repository = ref.watch(inventoryAnalyticsRepositoryProvider);
    return SalesDashboardNotifier(repository);
  },
);

class SalesDashboardNotifier extends StateNotifier<SalesDashboardState> {
  final InventoryAnalyticsRepository _repository;

  SalesDashboardNotifier(this._repository)
      : super(const SalesDashboardState());

  Future<void> loadData({
    required String companyId,
    String? storeId,
    DateTime? month,
  }) async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, errorMessage: null);

    // 병렬로 두 가지 데이터 로드
    final results = await Future.wait([
      _repository.getSalesDashboard(companyId: companyId, storeId: storeId),
      _repository.getBcgMatrix(companyId: companyId, month: month, storeId: storeId),
    ]);

    final dashboardResult = results[0];
    final bcgResult = results[1];

    SalesDashboard? dashboard;
    BcgMatrix? bcg;
    String? error;

    dashboardResult.fold(
      (failure) => error = failure.message,
      (data) => dashboard = data as SalesDashboard,
    );

    bcgResult.fold(
      (failure) => error ??= failure.message,
      (data) => bcg = data as BcgMatrix,
    );

    state = state.copyWith(
      isLoading: false,
      data: dashboard,
      bcgMatrix: bcg,
      errorMessage: error,
    );
  }

  Future<void> refresh({
    required String companyId,
    String? storeId,
    DateTime? month,
  }) async {
    if (state.isRefreshing) return;

    state = state.copyWith(isRefreshing: true);

    await loadData(
      companyId: companyId,
      storeId: storeId,
      month: month,
    );

    state = state.copyWith(isRefreshing: false);
  }

  /// 카테고리 상세 조회
  Future<CategoryDetail?> getCategoryDetail({
    required String companyId,
    required String categoryId,
    DateTime? month,
  }) async {
    final result = await _repository.getCategoryDetail(
      companyId: companyId,
      categoryId: categoryId,
      month: month,
    );

    return result.fold(
      (failure) => null,
      (data) => data,
    );
  }
}
