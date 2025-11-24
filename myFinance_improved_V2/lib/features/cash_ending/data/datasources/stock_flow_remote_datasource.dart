// lib/features/cash_ending/data/datasources/stock_flow_remote_datasource.dart

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/constants.dart';
import '../models/freezed/stock_flow_dto.dart';

/// Remote data source for stock flow operations
/// Handles API calls to Supabase RPC functions
class StockFlowRemoteDataSource {
  final SupabaseClient _client;

  StockFlowRemoteDataSource({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  /// Fetch location stock flow data from Supabase RPC
  ///
  /// Calls the 'get_location_stock_flow' RPC function with the following parameters:
  /// - p_company_id: Company ID
  /// - p_store_id: Store ID
  /// - p_cash_location_id: Cash location ID
  /// - p_offset: Pagination offset (default: 0)
  /// - p_limit: Number of records to fetch (default: 20)
  ///
  /// Returns [StockFlowResponseDto] containing:
  /// - success: Boolean indicating if the request was successful
  /// - data: Contains locationSummary and actualFlows list
  /// - pagination: Pagination information (offset, limit, hasMore)
  Future<StockFlowResponseDto> getLocationStockFlow({
    required String companyId,
    required String storeId,
    required String cashLocationId,
    int offset = 0,
    int limit = 20,
  }) async {
    try {
      // Validate required parameters
      if (cashLocationId.isEmpty) {
        throw Exception(
          'Cash location ID is required for fetching stock flow. '
          'Company: $companyId, Store: $storeId',
        );
      }
      if (companyId.isEmpty) {
        throw Exception(
          'Company ID is required for fetching stock flow. '
          'Location: $cashLocationId, Store: $storeId',
        );
      }
      if (storeId.isEmpty) {
        throw Exception(
          'Store ID is required for fetching stock flow. '
          'Company: $companyId, Location: $cashLocationId',
        );
      }

      // Call Supabase RPC function
      final response = await _client.rpc<Map<String, dynamic>>(
        CashEndingConstants.rpcGetLocationStockFlow,
        params: {
          'p_company_id': companyId,
          'p_store_id': storeId,
          'p_cash_location_id': cashLocationId,
          'p_offset': offset,
          'p_limit': limit,
        },
      );

      // Parse response into model
      return StockFlowResponseDto.fromJson(response);
    } catch (e) {
      throw Exception(
        'Failed to fetch stock flow data for location $cashLocationId '
        '(Company: $companyId, Store: $storeId, Offset: $offset, Limit: $limit): $e',
      );
    }
  }
}
