import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/inventory_optimization.dart';

/// Optimization Repository Interface
///
/// Clean Architecture's Domain Layer에 위치하며,
/// 재고 최적화 분석 관련 데이터 조회를 담당합니다.
abstract class OptimizationRepository {
  /// 재고 최적화 대시보드 데이터 조회
  /// RPC: get_inventory_optimization_dashboard
  ///
  /// [companyId] 회사 ID (필수)
  Future<Either<Failure, InventoryOptimization>> getInventoryOptimizationDashboard({
    required String companyId,
  });

  /// 재주문 목록 조회
  /// RPC: get_inventory_reorder_list
  ///
  /// [companyId] 회사 ID (필수)
  /// [priority] 우선순위 필터 (선택, 'critical', 'warning', 'normal')
  /// [limit] 최대 조회 개수 (선택)
  Future<Either<Failure, List<ReorderProduct>>> getReorderList({
    required String companyId,
    String? priority,
    int? limit,
  });
}
