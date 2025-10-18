import 'package:dartz/dartz.dart';
import 'package:myfinance_improved/core/errors/failures.dart';
import 'package:myfinance_improved/features/homepage/domain/entities/store.dart';

/// Repository interface for store operations
/// Defines the contract that the data layer must implement
abstract class StoreRepository {
  /// Create a new store with optional operational settings
  ///
  /// Performs the following operations:
  /// 1. Verify user permission (Owner OR store_management feature)
  /// 2. Check duplicate store name in company
  /// 3. INSERT stores (auto-generates store_code)
  /// 4. Verify/CREATE user_stores (links user)
  ///
  /// Returns [Right<Store>] on success
  /// Returns [Left<Failure>] on error
  Future<Either<Failure, Store>> createStore({
    required String storeName,
    required String companyId,
    String? storeAddress,
    String? storePhone,
    int? huddleTime,
    int? paymentTime,
    int? allowedDistance,
  });
}
