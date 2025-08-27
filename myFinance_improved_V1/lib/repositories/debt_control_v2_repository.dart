import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/debt_control_v2_models.dart';

class DebtControlV2Repository {
  final SupabaseClient _client;

  DebtControlV2Repository(this._client);

  /// Fetches both company and store perspectives in one call
  Future<DebtControlV2Response> getDebtControlData({
    required String companyId,
    String? storeId,
    String filter = 'all',
    bool showAll = false,
  }) async {
    try {
      // Validate filter
      if (!['all', 'internal', 'external'].contains(filter)) {
        throw ArgumentError('Invalid filter: $filter');
      }
      
      final response = await _client.rpc(
        'get_debt_control_data_v2',
        params: {
          'p_company_id': companyId,
          'p_store_id': storeId,
          'p_filter': filter,
          'p_show_all': showAll,
        },
      );

      if (response == null) {
        throw Exception('No response from server');
      }

      return DebtControlV2Response.fromJson(response as Map<String, dynamic>);
      
    } catch (e) {
      print('DebtControlV2Repository Error: $e');
      throw Exception('Failed to fetch debt control data: $e');
    }
  }
}