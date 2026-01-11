import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/supply_chain_model.dart';

/// Supply Chain Remote DataSource
///
/// 공급망 분석 관련 Supabase RPC 호출을 담당합니다.
class SupplyChainDatasource {
  final SupabaseClient _client;

  SupplyChainDatasource(this._client);

  /// 공급망 상태 데이터 조회
  /// RPC: get_supply_chain_status
  Future<SupplyChainStatusModel> getSupplyChainStatus({
    required String companyId,
  }) async {
    final params = {
      'p_company_id': companyId,
    };

    final response = await _client
        .rpc<Map<String, dynamic>>('get_supply_chain_status', params: params)
        .single();

    return _handleResponse(
      response,
      (data) => SupplyChainStatusModel.fromJson(data),
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
}
