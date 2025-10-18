import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:myfinance_improved/core/errors/failures.dart';
import 'package:myfinance_improved/features/homepage/domain/entities/store.dart';
import 'package:myfinance_improved/features/homepage/domain/repositories/store_repository.dart';
import 'package:myfinance_improved/features/homepage/data/datasources/store_remote_datasource.dart';

/// Implementation of StoreRepository
/// Implements the domain contract and handles error mapping
class StoreRepositoryImpl implements StoreRepository {
  const StoreRepositoryImpl(this.remoteDataSource);

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
    try {
      // Verify company exists
      final companyExists =
          await remoteDataSource.verifyCompanyExists(companyId);
      if (!companyExists) {
        return const Left(NotFoundFailure(
          message: 'Selected company no longer exists',
          code: 'COMPANY_NOT_FOUND',
        ));
      }

      // Verify user has permission to create stores
      final hasPermission =
          await remoteDataSource.verifyStoreCreationPermission(companyId);
      if (!hasPermission) {
        return const Left(PermissionFailure(
          message: 'You do not have permission to create stores for this company',
          code: 'INSUFFICIENT_PERMISSIONS',
        ));
      }

      // Check for duplicate store name
      final isDuplicate =
          await remoteDataSource.checkDuplicateStoreName(storeName, companyId);
      if (isDuplicate) {
        return const Left(ValidationFailure(
          message: 'A store with this name already exists in your company',
          code: 'DUPLICATE_STORE_NAME',
        ));
      }

      // Create store
      final storeModel = await remoteDataSource.createStore(
        storeName: storeName,
        companyId: companyId,
        storeAddress: storeAddress,
        storePhone: storePhone,
        huddleTime: huddleTime,
        paymentTime: paymentTime,
        allowedDistance: allowedDistance,
      );

      return Right(storeModel.toEntity());
    } on PostgrestException catch (e) {
      return Left(_mapPostgrestError(e));
    } on Exception catch (e) {
      if (e.toString().contains('not authenticated')) {
        return const Left(AuthFailure(
          message: 'Please log in to create a store',
          code: 'AUTH_REQUIRED',
        ));
      }
      if (e.toString().contains('Company not found')) {
        return const Left(NotFoundFailure(
          message: 'Selected company no longer exists',
          code: 'COMPANY_NOT_FOUND',
        ));
      }
      return Left(UnknownFailure(
        message: e.toString(),
        code: 'UNKNOWN_ERROR',
      ));
    } catch (e) {
      return Left(UnknownFailure(
        message: 'An unexpected error occurred. Please try again.',
        code: 'UNKNOWN_ERROR',
      ));
    }
  }

  /// Map Supabase errors to domain failures
  Failure _mapPostgrestError(PostgrestException e) {
    switch (e.code) {
      case '23505': // Unique constraint violation
        if (e.message.contains('store_name')) {
          return const ServerFailure(
            message: 'A store with this name already exists in your company',
            code: 'DUPLICATE_STORE_NAME',
          );
        }
        return const ServerFailure(
          message: 'This information is already in use',
          code: 'DUPLICATE_ERROR',
        );
      case '23503': // Foreign key constraint violation
        if (e.message.contains('company_id')) {
          return const NotFoundFailure(
            message: 'Selected company no longer exists',
            code: 'COMPANY_NOT_FOUND',
          );
        }
        return const ServerFailure(
          message: 'Invalid reference data. Please refresh and try again',
          code: 'FOREIGN_KEY_ERROR',
        );
      case '23514': // Check constraint violation
        return const ServerFailure(
          message: 'Invalid data format. Please check your input',
          code: 'CHECK_CONSTRAINT_ERROR',
        );
      case 'PGRST116': // No rows returned
        return const NotFoundFailure(
          message: 'Required information not found',
          code: 'NOT_FOUND',
        );
      default:
        return ServerFailure(
          message: 'A database error occurred. Please try again',
          code: e.code ?? 'DATABASE_ERROR',
        );
    }
  }
}
