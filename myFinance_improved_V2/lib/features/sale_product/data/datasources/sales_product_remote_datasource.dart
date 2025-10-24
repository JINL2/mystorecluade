import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/sales_product_model.dart';

/// Remote data source for sales products
///
/// Handles communication with Supabase RPC functions
class SalesProductRemoteDataSource {
  final SupabaseClient _client;

  SalesProductRemoteDataSource(this._client);

  /// Get inventory products for sales
  ///
  /// Calls the `get_inventory_page` RPC function
  Future<List<SalesProductModel>> getInventoryProducts({
    required String companyId,
    required String storeId,
    required int page,
    int limit = 100,
    String? search,
  }) async {
    try {
      print('🔍 [SALES_DATASOURCE] Loading products');
      print('📋 [SALES_DATASOURCE] Params: company=$companyId, store=$storeId, page=$page, limit=$limit, search=$search');

      final params = {
        'p_company_id': companyId,
        'p_store_id': storeId,
        'p_page': page,
        'p_limit': limit,
        'p_search': search ?? '',
      };

      final response = await _client.rpc<Map<String, dynamic>>(
        'get_inventory_page',
        params: params,
      ).single();

      print('📥 [SALES_DATASOURCE] Response received');

      // Handle both success wrapper and direct data
      Map<String, dynamic> dataToProcess;

      if (response.containsKey('success')) {
        if (response['success'] == true) {
          dataToProcess = response['data'] as Map<String, dynamic>? ?? {};
        } else {
          print('❌ [SALES_DATASOURCE] API returned success=false');
          throw Exception(response['error'] ?? 'Failed to load products');
        }
      } else {
        dataToProcess = response;
      }

      // Extract products array
      final productsJson = dataToProcess['products'] as List<dynamic>? ?? [];

      print('✅ [SALES_DATASOURCE] Products loaded: ${productsJson.length}');

      return productsJson
          .map((json) => SalesProductModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e, stackTrace) {
      print('❌ [SALES_DATASOURCE] Error: $e');
      print('📋 [SALES_DATASOURCE] Stack: $stackTrace');
      rethrow;
    }
  }
}
