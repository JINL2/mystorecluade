import 'package:dartz/dartz.dart';
import 'package:myfinance_improved/core/errors/failures.dart';
import 'package:myfinance_improved/features/homepage/data/datasources/store_remote_datasource.dart';
import 'package:myfinance_improved/features/homepage/domain/entities/store.dart';
import 'package:myfinance_improved/features/homepage/domain/repositories/store_repository.dart';

import 'base_repository.dart';

/// Implementation of StoreRepository
/// Extends BaseRepository for centralized error handling and logging
class StoreRepositoryImpl extends BaseRepository implements StoreRepository {
  StoreRepositoryImpl(this.remoteDataSource);

  final StoreRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, Store>> createStore({
    required String storeName,
    required String companyId,
    String? storeAddress,
    String? storePhone,
    int? huddleTime,
    int? paymentTime,
    int? allowedDistance,
  }) async {
    // Note: Permission checks are handled by the create_store RPC
    // The RPC validates company ownership and permissions internally

    // Execute with automatic error handling
    return executeWithErrorHandling(
      operation: () async {
        final storeModel = await remoteDataSource.createStore(
          storeName: storeName,
          companyId: companyId,
          storeAddress: storeAddress,
          storePhone: storePhone,
          huddleTime: huddleTime,
          paymentTime: paymentTime,
          allowedDistance: allowedDistance,
        );
        return storeModel.toEntity();
      },
      errorContext: 'createStore',
      fallbackErrorMessage: 'Failed to create store. Please try again.',
    );
  }
}
