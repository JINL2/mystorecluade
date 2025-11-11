import 'package:dartz/dartz.dart';
import 'package:myfinance_improved/core/errors/failures.dart';
import 'package:myfinance_improved/features/homepage/domain/entities/store.dart';
import 'package:myfinance_improved/features/homepage/domain/repositories/store_repository.dart';
import 'package:myfinance_improved/features/homepage/data/datasources/store_remote_datasource.dart';
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
    // Validation checks (returns early on failure)
    final companyExists =
        await remoteDataSource.verifyCompanyExists(companyId);
    if (!companyExists) {
      return const Left(NotFoundFailure(
        message: 'Selected company no longer exists',
        code: 'COMPANY_NOT_FOUND',
      ));
    }

    final hasPermission =
        await remoteDataSource.verifyStoreCreationPermission(companyId);
    if (!hasPermission) {
      return const Left(PermissionFailure(
        message: 'You do not have permission to create stores for this company',
        code: 'INSUFFICIENT_PERMISSIONS',
      ));
    }

    final isDuplicate =
        await remoteDataSource.checkDuplicateStoreName(storeName, companyId);
    if (isDuplicate) {
      return const Left(ValidationFailure(
        message: 'A store with this name already exists in your company',
        code: 'DUPLICATE_STORE_NAME',
      ));
    }

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
