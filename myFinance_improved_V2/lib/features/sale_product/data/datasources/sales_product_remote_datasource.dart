import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/utils/datetime_utils.dart';
import '../models/sales_product_model.dart';

/// Response containing products and pagination info
/// Updated for get_inventory_page_v6 with variant support
class SalesProductResponse {
  final List<SalesProductModel> products;
  final int totalCount;
  final bool hasNextPage;
  // v6 additional fields
  final double? totalValue;
  final int? filteredCount;
  final String? currencyCode;
  final String? currencySymbol;

  SalesProductResponse({
    required this.products,
    required this.totalCount,
    required this.hasNextPage,
    this.totalValue,
    this.filteredCount,
    this.currencyCode,
    this.currencySymbol,
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
  /// Calls the `get_inventory_page_v6` RPC function
  /// v6 supports variant products - variants are expanded as separate items
  Future<SalesProductResponse> getInventoryProducts({
    required String companyId,
    required String storeId,
    required int page,
    int limit = 15,
    String? search,
    String? availability,
    String? brandId,
    String? categoryId,
  }) async {
    final params = {
      'p_company_id': companyId,
      'p_store_id': storeId,
      'p_page': page,
      'p_limit': limit,
      'p_search': search,
      'p_availability': availability,
      'p_brand_id': brandId,
      'p_category_id': categoryId,
      'p_timezone': DateTimeUtils.getLocalTimezone(),
    };

    final response = await _client.rpc<Map<String, dynamic>>(
      'get_inventory_page_v6',
      params: params,
    ).single();

    // Handle success wrapper
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

    // v6 uses 'items' instead of 'products'
    final productsJson = dataToProcess['items'] as List<dynamic>? ?? [];

    final products = productsJson
        .map((json) => SalesProductModel.fromJson(json as Map<String, dynamic>))
        .toList();

    // Extract pagination info
    final paginationJson = dataToProcess['pagination'] as Map<String, dynamic>? ?? {};
    final totalCount = (paginationJson['total'] as num?)?.toInt() ?? 0;
    final hasNextPage = (paginationJson['has_next'] as bool?) ?? false;

    // Extract summary info (v6)
    final summaryJson = dataToProcess['summary'] as Map<String, dynamic>? ?? {};
    final totalValue = (summaryJson['total_value'] as num?)?.toDouble();
    final filteredCount = (summaryJson['filtered_count'] as num?)?.toInt();

    // Extract currency info (v6)
    final currencyJson = dataToProcess['currency'] as Map<String, dynamic>? ?? {};
    final currencyCode = currencyJson['code'] as String?;
    final currencySymbol = currencyJson['symbol'] as String?;

    return SalesProductResponse(
      products: products,
      totalCount: totalCount,
      hasNextPage: hasNextPage,
      totalValue: totalValue,
      filteredCount: filteredCount,
      currencyCode: currencyCode,
      currencySymbol: currencySymbol,
    );
  }
}
