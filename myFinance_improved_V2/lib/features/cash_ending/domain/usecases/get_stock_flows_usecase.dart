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
  ///
  /// Optimization: Cache parsed DateTime objects before sorting to avoid
  /// repeated parsing during sort comparisons (O(n log n) → O(n) parsing)
  List<ActualFlow> _sortFlows(List<ActualFlow> flows, bool descending) {
    if (flows.isEmpty) return flows;

    // Pre-parse all dates once for O(n) parsing instead of O(n log n)
    final flowsWithDates = <_FlowWithDate>[];
    for (final flow in flows) {
      DateTime? parsedDate;
      try {
        parsedDate = DateTime.parse(flow.createdAt);
      } catch (_) {
        // Use epoch for unparseable dates to maintain stable sort
        parsedDate = DateTime.fromMillisecondsSinceEpoch(0);
      }
      flowsWithDates.add(_FlowWithDate(flow, parsedDate));
    }

    // Sort using cached dates
    flowsWithDates.sort((a, b) =>
        descending ? b.date.compareTo(a.date) : a.date.compareTo(b.date));

    // Extract sorted flows
    return flowsWithDates.map((e) => e.flow).toList();
  }
}

/// Helper class for caching parsed dates during sort
class _FlowWithDate {
  final ActualFlow flow;
  final DateTime date;

  const _FlowWithDate(this.flow, this.date);
}
