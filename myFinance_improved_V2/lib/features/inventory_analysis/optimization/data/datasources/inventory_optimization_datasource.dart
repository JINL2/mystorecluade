import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/category_summary_dto.dart';
import '../models/inventory_dashboard_dto.dart';
import '../models/inventory_health_dashboard_dto.dart';
import '../models/paginated_products_dto.dart';

/// Inventory Optimization DataSource
/// Supabase RPC 호출을 담당합니다.
class InventoryOptimizationDatasource {
  final SupabaseClient _client;

  InventoryOptimizationDatasource(this._client);

  /// 대시보드 데이터 조회
  /// RPC: get_inventory_health_dashboard
  Future<InventoryDashboardDto> getDashboard({
    required String companyId,
  }) async {
    final response = await _client.rpc<Map<String, dynamic>>(
      'get_inventory_health_dashboard',
      params: {'p_company_id': companyId},
    );

    return InventoryDashboardDto.fromJson(response);
  }

  /// 카테고리별 재고 현황 조회
  /// RPC: get_reorder_by_category
  Future<List<CategorySummaryDto>> getCategorySummaries({
    required String companyId,
  }) async {
    final response = await _client.rpc<List<dynamic>>(
      'get_reorder_by_category',
      params: {'p_company_id': companyId},
    );

    return response
        .whereType<Map<String, dynamic>>()
        .map((e) => CategorySummaryDto.fromJson(e))
        .toList();
  }

  /// 상품 목록 조회 (페이지네이션)
  /// RPC: get_reorder_products_paged
  Future<PaginatedProductsDto> getProductsPaged({
    required String companyId,
    String? categoryId,
    String? statusFilter,
    int page = 0,
    int pageSize = 20,
  }) async {
    final params = <String, dynamic>{
      'p_company_id': companyId,
      'p_page': page,
      'p_page_size': pageSize,
    };

    if (categoryId != null) {
      params['p_category_id'] = categoryId;
    }

    if (statusFilter != null) {
      params['p_status_filter'] = statusFilter;
    }

    final response = await _client.rpc<Map<String, dynamic>>(
      'get_reorder_products_paged',
      params: params,
    );

    return PaginatedProductsDto.fromJson(response);
  }

  /// Materialized View 새로고침
  /// RPC: refresh_inventory_optimization_views
  Future<void> refreshViews() async {
    await _client.rpc<void>('refresh_inventory_optimization_views');
  }

  /// 재고 건강도 대시보드 조회 (V2)
  /// RPC: inventory_analysis_get_inventory_health_dashboard
  Future<InventoryHealthDashboardDto> getHealthDashboard({
    required String companyId,
    String? storeId,
    double urgentThreshold = 1.0,
    int limit = 10,
  }) async {
    final params = <String, dynamic>{
      'p_company_id': companyId,
      'p_urgent_threshold': urgentThreshold,
      'p_limit': limit,
    };

    if (storeId != null) {
      params['p_store_id'] = storeId;
    }

    final response = await _client.rpc<Map<String, dynamic>>(
      'inventory_analysis_get_inventory_health_dashboard',
      params: params,
    );

    return InventoryHealthDashboardDto.fromJson(response);
  }
}
