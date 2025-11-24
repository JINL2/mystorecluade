// lib/features/cash_ending/domain/usecases/get_stock_flows_usecase.dart

import '../entities/stock_flow.dart';
import '../repositories/stock_flow_repository.dart';

/// Parameters for GetStockFlowsUseCase
class GetStockFlowsParams {
  final String companyId;
  final String storeId;
  final String locationId;
  final int offset;
  final int limit;
  final bool sortDescending;
  final List<ActualFlow> existingFlows;

  const GetStockFlowsParams({
    required this.companyId,
    required this.storeId,
    required this.locationId,
    this.offset = 0,
    this.limit = 20,
    this.sortDescending = true,
    this.existingFlows = const [],
  });
}

/// UseCase: Get stock flows with business logic
///
/// Business Logic:
/// - Load stock flows for a location
/// - Sort by date (newest first by default)
/// - Handle pagination
///
/// NOTE: Sorting logic moved from Data layer to Domain layer
/// This is a business rule, not a data access concern
class GetStockFlowsUseCase {
  final StockFlowRepository _repository;

  GetStockFlowsUseCase(this._repository);

  /// Execute the use case
  ///
  /// [params] - Parameters including location, pagination, and sort order
  ///
  /// Returns sorted stock flows with pagination info
  Future<StockFlowResult> execute(GetStockFlowsParams params) async {
    // Fetch data from repository (unsorted)
    final result = await _repository.getLocationStockFlow(
      companyId: params.companyId,
      storeId: params.storeId,
      cashLocationId: params.locationId,
      offset: params.offset,
      limit: params.limit,
    );

    // Business Rule: Sort stock flows by creation date
    // This was previously in the Data layer, but sorting order is a business concern
    final sortedFlows = _sortFlows(result.actualFlows, params.sortDescending);

    // Business Rule: Merge with existing flows for pagination
    // Use efficient list concatenation for better performance
    final mergedFlows = params.existingFlows.isNotEmpty
        ? (List<ActualFlow>.of(params.existingFlows)..addAll(sortedFlows))
        : sortedFlows;

    return StockFlowResult(
      success: result.success,
      locationSummary: result.locationSummary,
      actualFlows: mergedFlows,
      pagination: result.pagination,
    );
  }

  /// Sort flows by created date
  ///
  /// Business Rule: Default to descending (newest first) for better UX
  List<ActualFlow> _sortFlows(List<ActualFlow> flows, bool descending) {
    final sortedFlows = List<ActualFlow>.from(flows);

    sortedFlows.sort((a, b) {
      try {
        final dateA = DateTime.parse(a.createdAt);
        final dateB = DateTime.parse(b.createdAt);
        return descending ? dateB.compareTo(dateA) : dateA.compareTo(dateB);
      } catch (e) {
        // If date parsing fails, maintain original order
        return 0;
      }
    });

    return sortedFlows;
  }
}
