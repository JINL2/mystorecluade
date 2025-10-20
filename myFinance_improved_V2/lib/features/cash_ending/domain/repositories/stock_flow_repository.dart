// lib/features/cash_ending/domain/repositories/stock_flow_repository.dart

import '../entities/stock_flow.dart';

/// Abstract repository interface for stock flow operations
/// Defines the contract for fetching location stock flow data
abstract class StockFlowRepository {
  /// Fetch location stock flow data
  ///
  /// Parameters:
  /// - [companyId]: Company ID
  /// - [storeId]: Store ID
  /// - [cashLocationId]: Cash location ID
  /// - [offset]: Pagination offset (default: 0)
  /// - [limit]: Number of records to fetch (default: 20)
  ///
  /// Returns a [Future] containing:
  /// - success: Boolean indicating if the request was successful
  /// - locationSummary: Location summary information
  /// - actualFlows: List of actual cash flows
  /// - pagination: Pagination information
  Future<StockFlowResult> getLocationStockFlow({
    required String companyId,
    required String storeId,
    required String cashLocationId,
    int offset = 0,
    int limit = 20,
  });
}

/// Result object for stock flow operations
class StockFlowResult {
  final bool success;
  final LocationSummary? locationSummary;
  final List<ActualFlow> actualFlows;
  final PaginationInfo? pagination;

  const StockFlowResult({
    required this.success,
    this.locationSummary,
    required this.actualFlows,
    this.pagination,
  });
}
