import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/sales_dashboard.dart';
import '../entities/bcg_category.dart';
import '../entities/sales_analytics.dart';

/// Sales Analytics V2 Query Parameters
class SalesAnalyticsParams {
  final String companyId;
  final String? storeId;
  final DateTime startDate;
  final DateTime endDate;
  final String groupBy;
  final String dimension;
  final String metric;
  final int? topN;
  final bool comparePrevious;
  final String? categoryId;

  const SalesAnalyticsParams({
    required this.companyId,
    this.storeId,
    required this.startDate,
    required this.endDate,
    required this.groupBy,
    required this.dimension,
    required this.metric,
    this.topN,
    this.comparePrevious = true,
    this.categoryId,
  });
}

/// Drill Down Query Parameters
class DrillDownParams {
  final String companyId;
  final String? storeId;
  final DateTime startDate;
  final DateTime endDate;
  final String level;
  final String? parentId;

  const DrillDownParams({
    required this.companyId,
    this.storeId,
    required this.startDate,
    required this.endDate,
    required this.level,
    this.parentId,
  });
}

/// Sales Analytics Repository Interface
///
/// Clean Architecture의 Domain Layer에 위치하며,
/// 수익률/매출 분석 관련 데이터 조회를 담당합니다.
abstract class SalesRepository {
  /// 수익률 대시보드 데이터 조회
  /// RPC: inventory_analysis_get_sales_dashboard
  ///
  /// [companyId] 회사 ID (필수)
  /// [storeId] 매장 ID (선택, null이면 전체 매장)
  Future<Either<Failure, SalesDashboard>> getSalesDashboard({
    required String companyId,
    String? storeId,
  });

  // ═══════════════════════════════════════════════════════════════
  // V2 Analytics Methods (2025)
  // ═══════════════════════════════════════════════════════════════

  /// Sales Analytics 데이터 조회
  /// RPC: inventory_analysis_get_sales_analytics
  Future<Either<Failure, SalesAnalyticsResponse>> getSalesAnalytics(
    SalesAnalyticsParams params,
  );

  /// Drill-down 데이터 조회
  /// RPC: inventory_analysis_get_drill_down_analytics
  Future<Either<Failure, DrillDownResponse>> getDrillDownAnalytics(
    DrillDownParams params,
  );

  /// BCG Matrix V2 데이터 조회
  /// RPC: inventory_analysis_get_bcg_matrix
  Future<Either<Failure, BcgMatrix>> getBcgMatrixV2({
    required String companyId,
    required DateTime startDate,
    required DateTime endDate,
    String? storeId,
  });

  /// 회사 통화 심볼 조회
  Future<Either<Failure, String>> getCurrencySymbol({
    required String companyId,
  });
}
