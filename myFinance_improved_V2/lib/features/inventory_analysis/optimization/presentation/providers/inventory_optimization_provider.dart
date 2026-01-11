import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/optimization_providers.dart';
import '../../domain/entities/inventory_optimization.dart';
import '../../domain/repositories/optimization_repository.dart';

/// Inventory Optimization State
class InventoryOptimizationState {
  final bool isLoading;
  final bool isRefreshing;
  final InventoryOptimization? dashboard;
  final List<ReorderProduct>? reorderList;
  final String? errorMessage;

  const InventoryOptimizationState({
    this.isLoading = false,
    this.isRefreshing = false,
    this.dashboard,
    this.reorderList,
    this.errorMessage,
  });

  InventoryOptimizationState copyWith({
    bool? isLoading,
    bool? isRefreshing,
    InventoryOptimization? dashboard,
    List<ReorderProduct>? reorderList,
    String? errorMessage,
  }) {
    return InventoryOptimizationState(
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      dashboard: dashboard ?? this.dashboard,
      reorderList: reorderList ?? this.reorderList,
      errorMessage: errorMessage,
    );
  }

  bool get hasData => dashboard != null;
  bool get hasError => errorMessage != null;
}

/// Inventory Optimization Provider
final inventoryOptimizationProvider = StateNotifierProvider.autoDispose<
    InventoryOptimizationNotifier, InventoryOptimizationState>(
  (ref) {
    final repository = ref.watch(optimizationRepositoryProvider);
    return InventoryOptimizationNotifier(repository);
  },
);

class InventoryOptimizationNotifier
    extends StateNotifier<InventoryOptimizationState> {
  final OptimizationRepository _repository;

  InventoryOptimizationNotifier(this._repository)
      : super(const InventoryOptimizationState());

  Future<void> loadData({
    required String companyId,
    String? priority,
  }) async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, errorMessage: null);

    final results = await Future.wait([
      _repository.getInventoryOptimizationDashboard(companyId: companyId),
      _repository.getReorderList(companyId: companyId, priority: priority),
    ]);

    final dashboardResult = results[0];
    final reorderResult = results[1];

    InventoryOptimization? dashboard;
    List<ReorderProduct>? reorderList;
    String? error;

    dashboardResult.fold(
      (failure) => error = failure.message,
      (data) => dashboard = data as InventoryOptimization,
    );

    reorderResult.fold(
      (failure) => error ??= failure.message,
      (data) => reorderList = data as List<ReorderProduct>,
    );

    state = state.copyWith(
      isLoading: false,
      dashboard: dashboard,
      reorderList: reorderList,
      errorMessage: error,
    );
  }

  Future<void> refresh({
    required String companyId,
    String? priority,
  }) async {
    if (state.isRefreshing) return;

    state = state.copyWith(isRefreshing: true);

    await loadData(companyId: companyId, priority: priority);

    state = state.copyWith(isRefreshing: false);
  }

  /// 우선순위 필터링
  Future<void> filterByPriority({
    required String companyId,
    required String? priority,
  }) async {
    final result = await _repository.getReorderList(
      companyId: companyId,
      priority: priority,
    );

    result.fold(
      (failure) => null,
      (data) => state = state.copyWith(reorderList: data),
    );
  }
}
