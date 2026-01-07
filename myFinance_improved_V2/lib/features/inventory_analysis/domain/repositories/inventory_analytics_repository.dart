import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/analytics_entities.dart';

/// Inventory Analytics Repository Interface
///
/// Clean Architecture의 Domain Layer에 위치하며,
/// Data Layer의 구현체와 분리된 추상화를 제공합니다.
abstract class InventoryAnalyticsRepository {
  /// 수익률 대시보드 데이터 조회
  /// RPC: get_sales_dashboard
  ///
  /// [companyId] 회사 ID (필수)
  /// [storeId] 매장 ID (선택, null이면 전체 매장)
  Future<Either<Failure, SalesDashboard>> getSalesDashboard({
    required String companyId,
    String? storeId,
  });

  /// BCG Matrix 데이터 조회
  /// RPC: get_bcg_matrix
  ///
  /// [companyId] 회사 ID (필수)
  /// [month] 기준 월 (선택, null이면 현재 월)
  /// [storeId] 매장 ID (선택, null이면 전체 매장)
  Future<Either<Failure, BcgMatrix>> getBcgMatrix({
    required String companyId,
    DateTime? month,
    String? storeId,
  });

  /// 카테고리 상세 데이터 조회
  /// RPC: get_category_detail
  ///
  /// [companyId] 회사 ID (필수)
  /// [categoryId] 카테고리 ID (필수)
  /// [month] 기준 월 (선택, null이면 현재 월)
  Future<Either<Failure, CategoryDetail>> getCategoryDetail({
    required String companyId,
    required String categoryId,
    DateTime? month,
  });

  /// 공급망 상태 조회
  /// RPC: get_supply_chain_status
  ///
  /// [companyId] 회사 ID (필수)
  Future<Either<Failure, SupplyChainStatus>> getSupplyChainStatus({
    required String companyId,
  });

  /// 재고 불일치 개요 조회
  /// RPC: get_discrepancy_overview
  ///
  /// [companyId] 회사 ID (필수)
  /// [period] 기간 ('7d', '30d', 'all') (선택, 기본 'all')
  Future<Either<Failure, DiscrepancyOverview>> getDiscrepancyOverview({
    required String companyId,
    String? period,
  });

  /// 재고 최적화 대시보드 조회
  /// RPC: get_inventory_optimization_dashboard
  ///
  /// [companyId] 회사 ID (필수)
  Future<Either<Failure, InventoryOptimization>> getInventoryOptimizationDashboard({
    required String companyId,
  });

  /// 재주문 필요 제품 리스트 조회
  /// RPC: get_inventory_reorder_list
  ///
  /// [companyId] 회사 ID (필수)
  /// [priority] 우선순위 필터 ('critical', 'warning', 'all') (선택, 기본 'all')
  /// [limit] 조회 개수 제한 (선택, 기본 50)
  Future<Either<Failure, List<ReorderProduct>>> getReorderList({
    required String companyId,
    String? priority,
    int? limit,
  });

  /// Hub 페이지용 전체 데이터 조회 (병렬)
  ///
  /// 4개의 RPC를 병렬로 호출하여 Hub 데이터를 구성합니다.
  /// 개별 실패는 null로 처리하고 전체 결과를 반환합니다.
  Future<Either<Failure, AnalyticsHubData>> getHubData({
    required String companyId,
    String? storeId,
  });
}
