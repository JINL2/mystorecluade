// lib/features/cash_ending/data/repositories/stock_flow_repository_impl.dart

import '../../domain/repositories/stock_flow_repository.dart';
import '../datasources/stock_flow_remote_datasource.dart';
import 'base_repository.dart';

/// Implementation of [StockFlowRepository]
/// Handles the conversion between data models and domain entities
/// Uses BaseRepository for unified error handling
class StockFlowRepositoryImpl extends BaseRepository
    implements StockFlowRepository {
  final StockFlowRemoteDataSource _remoteDataSource;

  StockFlowRepositoryImpl(this._remoteDataSource);

  @override
  Future<StockFlowResult> getLocationStockFlow({
    required String companyId,
    required String storeId,
    required String cashLocationId,
    int offset = 0,
    int limit = 20,
  }) async {
    return executeWithErrorHandling(
      () async {
        // Fetch data from remote data source
        final response = await _remoteDataSource.getLocationStockFlow(
          companyId: companyId,
          storeId: storeId,
          cashLocationId: cashLocationId,
          offset: offset,
          limit: limit,
        );

        // Convert models to domain entities
        final locationSummary = response.data?.locationSummary?.toEntity();
        final actualFlows = response.data?.actualFlows
                .map((model) => model.toEntity())
                .toList() ??
            [];
        final pagination = response.pagination?.toEntity();

        // NOTE: Sorting logic removed from Data layer
        // Sorting is a business concern and should be handled in Domain UseCase
        // See: GetStockFlowsUseCase for sorting implementation

        return StockFlowResult(
          success: response.success,
          locationSummary: locationSummary,
          actualFlows: actualFlows,
          pagination: pagination,
        );
      },
      operationName: 'getLocationStockFlow',
    );
  }
}
