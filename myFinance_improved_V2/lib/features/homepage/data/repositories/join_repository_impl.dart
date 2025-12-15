import 'package:dartz/dartz.dart';
import 'package:myfinance_improved/core/errors/failures.dart';
import 'package:myfinance_improved/features/homepage/data/datasources/join_remote_datasource.dart';
import 'package:myfinance_improved/features/homepage/domain/entities/join_result.dart';
import 'package:myfinance_improved/features/homepage/domain/repositories/join_repository.dart';

import 'base_repository.dart';

/// Implementation of JoinRepository
/// Extends BaseRepository for centralized error handling and logging
class JoinRepositoryImpl extends BaseRepository implements JoinRepository {
  JoinRepositoryImpl(this.remoteDataSource);

  final JoinRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, JoinResult>> joinByCode({
    required String userId,
    required String code,
  }) async {
    return executeWithErrorHandling(
      operation: () async {
        // Call remote data source
        final model = await remoteDataSource.joinByCode(
          userId: userId,
          code: code,
        );

        // Check if join was successful
        if (!model.success) {
          // RPC returned success=false with error details
          if (model.isAlreadyJoined) {
            throw NotFoundFailure(
              message: model.errorMessage,
              code: 'ALREADY_JOINED',
            );
          } else if (model.isInvalidCode) {
            throw NotFoundFailure(
              message: model.errorMessage,
              code: 'INVALID_CODE',
            );
          } else {
            throw NotFoundFailure(
              message: model.errorMessage,
              code: 'JOIN_FAILED',
            );
          }
        }

        // Convert model to entity
        return model.toEntity();
      },
      errorContext: 'joinByCode',
      fallbackErrorMessage: 'Failed to join. Please try again.',
    );
  }
}
