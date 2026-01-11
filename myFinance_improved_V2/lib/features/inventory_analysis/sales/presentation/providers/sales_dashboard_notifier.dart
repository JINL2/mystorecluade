import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/bcg_category.dart';
import '../../domain/entities/category_detail.dart';
import '../../domain/entities/sales_dashboard.dart';
import '../../domain/repositories/sales_repository.dart';
import 'sales_di_provider.dart';

part 'sales_dashboard_notifier.freezed.dart';
part 'sales_dashboard_notifier.g.dart';

/// Sales Dashboard State (freezed)
@freezed
class SalesDashboardState with _$SalesDashboardState {
  const SalesDashboardState._();

  const factory SalesDashboardState({
    @Default(false) bool isLoading,
    @Default(false) bool isRefreshing,
    SalesDashboard? data,
    BcgMatrix? bcgMatrix,
    String? errorMessage,
  }) = _SalesDashboardState;

  bool get hasData => data != null;
  bool get hasError => errorMessage != null;
}

/// Sales Dashboard Notifier (2025 @riverpod)
@riverpod
class SalesDashboardNotifier extends _$SalesDashboardNotifier {
  SalesRepository get _repository => ref.read(salesRepositoryProvider);

  @override
  SalesDashboardState build() {
    return const SalesDashboardState();
  }

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
      (d) => dashboard = d as SalesDashboard,
    );

    bcgResult.fold(
      (failure) => error ??= failure.message,
      (d) => bcg = d as BcgMatrix,
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
