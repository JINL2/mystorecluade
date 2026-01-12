import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/bcg_category.dart';
import '../../domain/repositories/sales_repository.dart';
import '../models/sales_dashboard_model.dart';
import '../models/bcg_matrix_model.dart';
import '../models/category_detail_model.dart';
import '../models/sales_analytics_dto.dart';

/// Sales Analytics Remote DataSource
///
/// 수익률/매출 분석 관련 Supabase RPC 호출을 담당합니다.
class SalesDatasource {
  final SupabaseClient _client;

  SalesDatasource(this._client);

  /// 수익률 대시보드 데이터 조회
  /// RPC: get_sales_dashboard
  Future<SalesDashboardModel> getSalesDashboard({
    required String companyId,
    String? storeId,
  }) async {
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
    );
  }

  /// BCG Matrix 데이터 조회
  /// RPC: get_bcg_matrix
  Future<BcgMatrixModel> getBcgMatrix({
    required String companyId,
    DateTime? month,
    String? storeId,
  }) async {
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
    );
  }

  /// 카테고리 상세 데이터 조회
  /// RPC: get_category_detail
  Future<CategoryDetailModel> getCategoryDetail({
    required String companyId,
    required String categoryId,
    DateTime? month,
  }) async {
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
    );
  }

  /// 응답 처리 헬퍼
  T _handleResponse<T>(
    Map<String, dynamic> response,
    T Function(Map<String, dynamic>) parser,
  ) {
    // success wrapper 패턴 처리
    if (response.containsKey('success')) {
      if (response['success'] == true) {
        final data = response['data'];
        if (data is Map<String, dynamic>) {
          return parser(data);
        }
        throw Exception('Invalid data format');
      } else {
        throw Exception(response['error']?.toString() ?? 'Unknown error');
      }
    }

    // 직접 데이터 패턴
    return parser(response);
  }

  // ═══════════════════════════════════════════════════════════════
  // V2 Analytics Methods (2025)
  // ═══════════════════════════════════════════════════════════════

  /// Sales Analytics 조회 (V2)
  /// RPC: get_sales_analytics
  ///
  /// Timezone is automatically read from companies table in RPC.
  Future<SalesAnalyticsResponseDto> getSalesAnalytics(
    SalesAnalyticsParams params,
  ) async {
    final rpcParams = {
      'p_company_id': params.companyId,
      'p_start_date': _formatDate(params.startDate),
      'p_end_date': _formatDate(params.endDate),
      if (params.storeId != null) 'p_store_id': params.storeId,
      'p_group_by': params.groupBy,
      'p_dimension': params.dimension,
      'p_metric': params.metric,
      'p_compare_previous': params.comparePrevious,
      if (params.topN != null) 'p_top_n': params.topN,
      if (params.categoryId != null) 'p_category_id': params.categoryId,
    };

    final response = await _client.rpc<Map<String, dynamic>>(
      'get_sales_analytics',
      params: rpcParams,
    );

    return SalesAnalyticsResponseDto.fromJson(response);
  }

  /// Drill-down 조회 (V2)
  /// RPC: get_drill_down_analytics
  ///
  /// Timezone is automatically read from companies table in RPC.
  Future<DrillDownResponseDto> getDrillDownAnalytics(
    DrillDownParams params,
  ) async {
    final rpcParams = {
      'p_company_id': params.companyId,
      'p_start_date': _formatDate(params.startDate),
      'p_end_date': _formatDate(params.endDate),
      if (params.storeId != null) 'p_store_id': params.storeId,
      'p_level': params.level,
      if (params.parentId != null) 'p_parent_id': params.parentId,
    };

    final response = await _client.rpc<Map<String, dynamic>>(
      'get_drill_down_analytics',
      params: rpcParams,
    );

    return DrillDownResponseDto.fromJson(response);
  }

  /// BCG Matrix V2 조회
  /// RPC: get_bcg_matrix_v2
  ///
  /// Timezone is automatically read from companies table in RPC.
  Future<BcgMatrix> getBcgMatrixV2({
    required String companyId,
    required DateTime startDate,
    required DateTime endDate,
    String? storeId,
  }) async {
    final params = {
      'p_company_id': companyId,
      'p_start_date': _formatDate(startDate),
      'p_end_date': _formatDate(endDate),
      if (storeId != null) 'p_store_id': storeId,
    };

    final response = await _client.rpc<Map<String, dynamic>>(
      'get_bcg_matrix_v2',
      params: params,
    );

    if (response['success'] != true) {
      return const BcgMatrix(categories: []);
    }

    final List<BcgCategory> categories = [];

    for (final item in (response['star'] as List<dynamic>? ?? [])) {
      categories.add(_parseBcgCategory(item as Map<String, dynamic>, 'star'));
    }
    for (final item in (response['cash_cow'] as List<dynamic>? ?? [])) {
      categories.add(_parseBcgCategory(item as Map<String, dynamic>, 'cash_cow'));
    }
    for (final item in (response['problem_child'] as List<dynamic>? ?? [])) {
      categories.add(_parseBcgCategory(item as Map<String, dynamic>, 'problem_child'));
    }
    for (final item in (response['dog'] as List<dynamic>? ?? [])) {
      categories.add(_parseBcgCategory(item as Map<String, dynamic>, 'dog'));
    }

    return BcgMatrix(categories: categories);
  }

  /// 회사 통화 심볼 조회
  Future<String> getCurrencySymbol(String companyId) async {
    final response = await _client
        .from('companies')
        .select('currency_types(symbol)')
        .eq('company_id', companyId)
        .single();

    final currencyData = response['currency_types'] as Map<String, dynamic>?;
    return currencyData?['symbol'] as String? ?? '₫';
  }

  // ═══════════════════════════════════════════════════════════════
  // Private Helpers
  // ═══════════════════════════════════════════════════════════════

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  BcgCategory _parseBcgCategory(Map<String, dynamic> json, String quadrant) {
    return BcgCategory(
      categoryId: json['category_id'] as String? ?? '',
      categoryName: json['category_name'] as String? ?? '',
      totalRevenue: (json['total_revenue'] as num?) ?? 0,
      marginRatePct: (json['margin_rate_pct'] as num?) ?? 0,
      totalQuantity: (json['total_quantity'] as num?)?.toInt() ?? 0,
      revenuePct: (json['revenue_pct'] as num?) ?? 0,
      salesVolumePercentile: (json['sales_volume_percentile'] as num?) ?? 0,
      marginPercentile: (json['margin_percentile'] as num?) ?? 0,
      quadrant: quadrant,
    );
  }
}
