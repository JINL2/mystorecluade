import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/utils/datetime_utils.dart';
import '../models/sales_product_model.dart';

/// Response containing products and pagination info
class SalesProductResponse {
  final List<SalesProductModel> products;
  final int totalCount;
  final bool hasNextPage;

  SalesProductResponse({
    required this.products,
    required this.totalCount,
    required this.hasNextPage,
  });
}

/// Remote data source for sales products
///
/// Handles communication with Supabase RPC functions
class SalesProductRemoteDataSource {
  final SupabaseClient _client;

  SalesProductRemoteDataSource(this._client);

  /// Get inventory products for sales
  ///
  /// Calls the `get_inventory_page_v3` RPC function
  Future<SalesProductResponse> getInventoryProducts({
    required String companyId,
    required String storeId,
    required int page,
    int limit = 15,
    String? search,
  }) async {
    final params = {
      'p_company_id': companyId,
      'p_store_id': storeId,
      'p_page': page,
      'p_limit': limit,
      'p_search': search,
      'p_timezone': DateTimeUtils.getLocalTimezone(),
    };

    final response = await _client.rpc<Map<String, dynamic>>(
      'get_inventory_page_v3',
      params: params,
    ).single();

    // Handle both success wrapper and direct data
    Map<String, dynamic> dataToProcess;

    if (response.containsKey('success')) {
      if (response['success'] == true) {
        dataToProcess = response['data'] as Map<String, dynamic>? ?? {};
      } else {
        throw Exception(response['error'] ?? 'Failed to load products');
      }
    } else {
      dataToProcess = response;
    }

    // Extract products array
    final productsJson = dataToProcess['products'] as List<dynamic>? ?? [];

    final products = productsJson
        .map((json) => SalesProductModel.fromJson(json as Map<String, dynamic>))
        .toList();

    // Extract pagination info (v3 provides has_next directly)
    final paginationJson = dataToProcess['pagination'] as Map<String, dynamic>? ?? {};
    final totalCount = (paginationJson['total'] ?? 0) as int;
    final hasNextPage = (paginationJson['has_next'] ?? false) as bool;

    return SalesProductResponse(
      products: products,
      totalCount: totalCount,
      hasNextPage: hasNextPage,
    );
  }
}
