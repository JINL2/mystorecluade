import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/inventory_optimization_model.dart';

/// Optimization Remote DataSource
///
/// 재고 최적화 분석 관련 Supabase RPC 호출을 담당합니다.
class OptimizationDatasource {
  final SupabaseClient _client;

  OptimizationDatasource(this._client);

  /// 재고 최적화 대시보드 데이터 조회
  /// RPC: get_inventory_optimization_dashboard
  Future<InventoryOptimizationModel> getInventoryOptimizationDashboard({
    required String companyId,
  }) async {
    final params = {
      'p_company_id': companyId,
    };

    final response = await _client
        .rpc<Map<String, dynamic>>('get_inventory_optimization_dashboard', params: params)
        .single();

    return _handleResponse(
      response,
      (data) => InventoryOptimizationModel.fromJson(data),
    );
  }

  /// 재주문 목록 조회
  /// RPC: get_inventory_reorder_list
  Future<List<ReorderProductModel>> getReorderList({
    required String companyId,
    String? priority,
    int? limit,
  }) async {
    final params = {
      'p_company_id': companyId,
      if (priority != null) 'p_priority': priority,
      if (limit != null) 'p_limit': limit,
    };

    final response = await _client
        .rpc<List<dynamic>>('get_inventory_reorder_list', params: params);

    return _handleListResponse(
      response,
      (data) => ReorderProductModel.fromJson(data as Map<String, dynamic>),
    );
  }

  /// 응답 처리 헬퍼 (단일 객체)
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

  /// 응답 처리 헬퍼 (리스트)
  List<T> _handleListResponse<T>(
    List<dynamic> response,
    T Function(dynamic) parser,
  ) {
    return response.map((item) => parser(item)).toList();
  }
}
