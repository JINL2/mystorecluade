// lib/features/cash_ending/data/repositories/stock_flow_repository_impl.dart

import '../../../../core/data/base_repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/types/result.dart' as result_type;
import '../../domain/entities/stock_flow.dart';
import '../../domain/repositories/stock_flow_repository.dart';
import '../datasources/stock_flow_remote_datasource.dart';

/// Repository Implementation for Stock Flow (Data Layer)
///
/// Implements the domain repository interface.
/// Coordinates between datasource (Supabase) and domain entities.
///
/// ✅ Refactored with:
/// - BaseRepository (unified error handling)
/// - Safe error recovery pattern
class StockFlowRepositoryImpl extends BaseRepository implements StockFlowRepository {
  final StockFlowRemoteDataSource _remoteDataSource;

  StockFlowRepositoryImpl(this._remoteDataSource);

  @override
  Future<result_type.Result<StockFlowResult, Failure>> getLocationStockFlow({
    required String companyId,
    required String storeId,
    required String cashLocationId,
    int offset = 0,
    int limit = 20,
  }) {
    return executeFetchWithResult(
      () async {
        // Fetch raw JSON from remote data source
        final response = await _remoteDataSource.getLocationStockFlow(
          companyId: companyId,
          storeId: storeId,
          cashLocationId: cashLocationId,
          offset: offset,
          limit: limit,
        );

        // Parse JSON directly to domain entities
        final success = (response['success'] as bool?) ?? false;

        final locationSummary = response['data']?['location_summary'] != null
            ? LocationSummary.fromJson(response['data']['location_summary'] as Map<String, dynamic>)
            : null;

        final actualFlowsJson = response['data']?['actual_flows'] as List<dynamic>?;
        final actualFlows = actualFlowsJson
                ?.map((e) => ActualFlow.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [];

        final pagination = response['pagination'] != null
            ? PaginationInfo.fromJson(response['pagination'] as Map<String, dynamic>)
            : null;

        // Sort actualFlows by createdAt date in descending order (latest first)
        actualFlows.sort((a, b) {
          try {
            final dateA = DateTime.parse(a.createdAt);
            final dateB = DateTime.parse(b.createdAt);
            return dateB.compareTo(dateA); // Descending order
          } catch (e) {
            return 0;
          }
        });

        return StockFlowResult(
          success: success,
          locationSummary: locationSummary,
          actualFlows: actualFlows,
          pagination: pagination,
        );
      },
      operationName: 'location stock flow',
    );
  }
}
