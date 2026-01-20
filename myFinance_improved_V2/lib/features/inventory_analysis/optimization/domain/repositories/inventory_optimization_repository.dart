import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/category_summary.dart';
import '../entities/inventory_dashboard.dart';
import '../entities/paginated_products.dart';

/// Inventory Optimization Repository Interface
///
/// Clean Architecture의 Domain Layer에 위치하며,
/// 재고 최적화 분석 관련 데이터 조회를 담당합니다.
abstract class InventoryOptimizationRepository {
  /// 재고 건강도 대시보드 데이터 조회
  /// RPC: get_inventory_health_dashboard
  ///
  /// [companyId] 회사 ID (필수)
  Future<Either<Failure, InventoryDashboard>> getDashboard({
    required String companyId,
  });

  /// 카테고리별 재고 현황 조회
  /// RPC: get_reorder_by_category
  ///
  /// [companyId] 회사 ID (필수)
  Future<Either<Failure, List<CategorySummary>>> getCategorySummaries({
    required String companyId,
  });

  /// 상품 목록 조회 (페이지네이션)
  /// RPC: get_reorder_products_paged
  ///
  /// [companyId] 회사 ID (필수)
  /// [categoryId] 카테고리 ID (선택)
  /// [statusFilter] 상태 필터 (선택: 'critical', 'warning', 'stockout', etc.)
  /// [page] 페이지 번호 (0-indexed)
  /// [pageSize] 페이지 크기 (기본 20)
  Future<Either<Failure, PaginatedProducts>> getProductsPaged({
    required String companyId,
    String? categoryId,
    String? statusFilter,
    int page = 0,
    int pageSize = 20,
  });

  /// Materialized View 새로고침
  /// RPC: refresh_inventory_optimization_views
  Future<Either<Failure, void>> refreshViews();
}
