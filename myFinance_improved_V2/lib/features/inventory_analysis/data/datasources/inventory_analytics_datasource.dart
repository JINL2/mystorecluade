import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/exceptions/analytics_exceptions.dart';
import '../models/analytics_models.dart';

/// Inventory Analytics Remote DataSource
///
/// 재고 분석 관련 Supabase RPC 호출을 담당합니다.
/// 7개의 RPC 함수를 호출:
/// - get_sales_dashboard
/// - get_bcg_matrix
/// - get_category_detail
/// - get_supply_chain_status
/// - get_discrepancy_overview
/// - get_inventory_optimization_dashboard
/// - get_inventory_reorder_list
class InventoryAnalyticsDatasource {
  final SupabaseClient _client;

  InventoryAnalyticsDatasource(this._client);

  /// 수익률 대시보드 데이터 조회
  /// RPC: get_sales_dashboard
  Future<SalesDashboardModel> getSalesDashboard({
    required String companyId,
    String? storeId,
  }) async {
    try {
      final params = {
        'p_company_id': companyId,
        if (storeId != null) 'p_store_id': storeId,
      };

      final response = await _client
          .rpc<Map<String, dynamic>>('get_sales_dashboard', params: params)
          .single();

      return _handleResponse(
        response,
        (data) => SalesDashboardModel.fromJson(data),
        'Failed to fetch sales dashboard',
      );
    } on PostgrestException catch (e) {
      throw AnalyticsConnectionException(
        message: 'Database error: ${e.message}',
        details: {'code': e.code, 'details': e.details},
      );
    } catch (e) {
      if (e is AnalyticsException) rethrow;
      throw AnalyticsRepositoryException(
        message: 'Failed to fetch sales dashboard: $e',
        details: e,
      );
    }
  }

  /// BCG Matrix 데이터 조회
  /// RPC: get_bcg_matrix
  Future<BcgMatrixModel> getBcgMatrix({
    required String companyId,
    DateTime? month,
    String? storeId,
  }) async {
    try {
      final params = {
        'p_company_id': companyId,
        if (month != null) 'p_month': month.toIso8601String().substring(0, 10),
        if (storeId != null) 'p_store_id': storeId,
      };

      final response = await _client
          .rpc<Map<String, dynamic>>('get_bcg_matrix', params: params)
          .single();

      return _handleResponse(
        response,
        (data) => BcgMatrixModel.fromJson(data),
        'Failed to fetch BCG matrix',
      );
    } on PostgrestException catch (e) {
      throw AnalyticsConnectionException(
        message: 'Database error: ${e.message}',
        details: {'code': e.code, 'details': e.details},
      );
    } catch (e) {
      if (e is AnalyticsException) rethrow;
      throw AnalyticsRepositoryException(
        message: 'Failed to fetch BCG matrix: $e',
        details: e,
      );
    }
  }

  /// 카테고리 상세 데이터 조회
  /// RPC: get_category_detail
  Future<CategoryDetailModel> getCategoryDetail({
    required String companyId,
    required String categoryId,
    DateTime? month,
  }) async {
    try {
      final params = {
        'p_company_id': companyId,
        'p_category_id': categoryId,
        if (month != null) 'p_month': month.toIso8601String().substring(0, 10),
      };

      final response = await _client
          .rpc<Map<String, dynamic>>('get_category_detail', params: params)
          .single();

      return _handleResponse(
        response,
        (data) => CategoryDetailModel.fromJson(data),
        'Failed to fetch category detail',
      );
    } on PostgrestException catch (e) {
      throw AnalyticsConnectionException(
        message: 'Database error: ${e.message}',
        details: {'code': e.code, 'details': e.details},
      );
    } catch (e) {
      if (e is AnalyticsException) rethrow;
      throw AnalyticsRepositoryException(
        message: 'Failed to fetch category detail: $e',
        details: e,
      );
    }
  }

  /// 공급망 상태 조회
  /// RPC: get_supply_chain_status
  Future<SupplyChainStatusModel> getSupplyChainStatus({
    required String companyId,
  }) async {
    try {
      final params = {
        'p_company_id': companyId,
      };

      final response = await _client
          .rpc<Map<String, dynamic>>('get_supply_chain_status', params: params)
          .single();

      return _handleResponse(
        response,
        (data) => SupplyChainStatusModel.fromJson(data),
        'Failed to fetch supply chain status',
      );
    } on PostgrestException catch (e) {
      throw AnalyticsConnectionException(
        message: 'Database error: ${e.message}',
        details: {'code': e.code, 'details': e.details},
      );
    } catch (e) {
      if (e is AnalyticsException) rethrow;
      throw AnalyticsRepositoryException(
        message: 'Failed to fetch supply chain status: $e',
        details: e,
      );
    }
  }

  /// 재고 불일치 개요 조회
  /// RPC: get_discrepancy_overview
  Future<DiscrepancyOverviewModel> getDiscrepancyOverview({
    required String companyId,
    String? period,
  }) async {
    try {
      final params = {
        'p_company_id': companyId,
        if (period != null) 'p_period': period,
      };

      final response = await _client
          .rpc<Map<String, dynamic>>('get_discrepancy_overview', params: params)
          .single();

      return _handleResponse(
        response,
        (data) => DiscrepancyOverviewModel.fromJson(data),
        'Failed to fetch discrepancy overview',
      );
    } on PostgrestException catch (e) {
      throw AnalyticsConnectionException(
        message: 'Database error: ${e.message}',
        details: {'code': e.code, 'details': e.details},
      );
    } catch (e) {
      if (e is AnalyticsException) rethrow;
      throw AnalyticsRepositoryException(
        message: 'Failed to fetch discrepancy overview: $e',
        details: e,
      );
    }
  }

  /// 재고 최적화 대시보드 조회
  /// RPC: get_inventory_optimization_dashboard
  Future<InventoryOptimizationModel> getInventoryOptimizationDashboard({
    required String companyId,
  }) async {
    try {
      final params = {
        'p_company_id': companyId,
      };

      final response = await _client
          .rpc<Map<String, dynamic>>('get_inventory_optimization_dashboard', params: params)
          .single();

      return _handleResponse(
        response,
        (data) => InventoryOptimizationModel.fromJson(data),
        'Failed to fetch inventory optimization dashboard',
      );
    } on PostgrestException catch (e) {
      throw AnalyticsConnectionException(
        message: 'Database error: ${e.message}',
        details: {'code': e.code, 'details': e.details},
      );
    } catch (e) {
      if (e is AnalyticsException) rethrow;
      throw AnalyticsRepositoryException(
        message: 'Failed to fetch inventory optimization dashboard: $e',
        details: e,
      );
    }
  }

  /// 재주문 필요 제품 리스트 조회
  /// RPC: get_inventory_reorder_list
  Future<List<ReorderProductModel>> getReorderList({
    required String companyId,
    String? priority,
    int? limit,
  }) async {
    try {
      final params = {
        'p_company_id': companyId,
        if (priority != null) 'p_priority': priority,
        if (limit != null) 'p_limit': limit,
      };

      final response = await _client
          .rpc<List<dynamic>>('get_inventory_reorder_list', params: params);

      return response
          .map((item) => ReorderProductModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw AnalyticsConnectionException(
        message: 'Database error: ${e.message}',
        details: {'code': e.code, 'details': e.details},
      );
    } catch (e) {
      if (e is AnalyticsException) rethrow;
      throw AnalyticsRepositoryException(
        message: 'Failed to fetch reorder list: $e',
        details: e,
      );
    }
  }

  /// 응답 처리 헬퍼
  /// success wrapper 패턴과 직접 데이터 패턴 모두 처리
  T _handleResponse<T>(
    Map<String, dynamic> response,
    T Function(Map<String, dynamic>) parser,
    String errorMessage,
  ) {
    // success wrapper 패턴 처리
    if (response.containsKey('success')) {
      if (response['success'] == true) {
        final data = response['data'];
        if (data is Map<String, dynamic>) {
          return parser(data);
        }
        throw AnalyticsRepositoryException(
          message: '$errorMessage: Invalid data format',
          details: response,
        );
      } else {
        throw AnalyticsRepositoryException(
          message: response['error']?.toString() ?? errorMessage,
          details: response['error'],
        );
      }
    }

    // 직접 데이터 패턴
    return parser(response);
  }
}
