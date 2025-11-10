// lib/features/cash_ending/domain/repositories/stock_flow_repository.dart

import '../../../../core/errors/failures.dart';
import '../../../../core/types/result.dart' as result_type;
import '../entities/stock_flow.dart';

/// Abstract repository interface for stock flow operations
/// Defines the contract for fetching location stock flow data
///
/// ✅ Strong Typing:
/// - Uses Result<T, Failure> for type-safe error handling
/// - Compile-time guarantee of error handling
/// - Clear distinction between success and failure cases
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
  /// Returns:
  /// - Success<StockFlowResult>: Stock flow data with location summary, flows, and pagination
  /// - Failure<NetworkFailure>: Network connection issues
  /// - Failure<ServerFailure>: Database/server errors
  /// - Failure<ValidationFailure>: Invalid parameters
  Future<result_type.Result<StockFlowResult, Failure>> getLocationStockFlow({
    required String companyId,
    required String storeId,
    required String cashLocationId,
    int offset = 0,
    int limit = 20,
  });
}
