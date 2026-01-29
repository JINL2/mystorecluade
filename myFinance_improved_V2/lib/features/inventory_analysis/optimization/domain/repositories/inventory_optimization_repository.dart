import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/category_summary.dart';
import '../entities/inventory_dashboard.dart';
import '../entities/inventory_health_dashboard.dart';
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

  /// 재고 건강도 대시보드 조회 (V2)
  /// RPC: inventory_analysis_get_inventory_health_dashboard
  ///
  /// [companyId] 회사 ID (필수)
  /// [storeId] 매장 ID (선택, null이면 전체 회사)
  /// [urgentThreshold] 긴급 기준 일 평균 판매량 (기본 1.0)
  /// [limit] 각 섹션별 상품 조회 수 (기본 10, 최대 50)
  Future<Either<Failure, InventoryHealthDashboard>> getHealthDashboard({
    required String companyId,
    String? storeId,
    double urgentThreshold = 1.0,
    int limit = 10,
  });
}
