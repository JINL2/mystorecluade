import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/discrepancy_model.dart';

/// Discrepancy Analytics Remote DataSource
///
/// Handles Supabase RPC calls for inventory discrepancy analysis.
class DiscrepancyDatasource {
  final SupabaseClient _client;

  DiscrepancyDatasource(this._client);

  /// Get discrepancy overview data
  /// RPC: get_discrepancy_overview
  Future<DiscrepancyOverviewModel> getDiscrepancyOverview({
    required String companyId,
    String? period,
  }) async {
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
    );
  }

  /// Response handler helper
  T _handleResponse<T>(
    Map<String, dynamic> response,
    T Function(Map<String, dynamic>) parser,
  ) {
    // success wrapper pattern handling
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

    // direct data pattern
    return parser(response);
  }
}
