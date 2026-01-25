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
        // Call remote data source (now uses join_business_by_code RPC)
        final model = await remoteDataSource.joinByCode(
          userId: userId,
          code: code,
        );

        // Check if join was successful
        if (!model.success) {
          // RPC returned success=false with error details
          if (model.isEmployeeLimitReached) {
            throw ValidationFailure(
              message:
                  'This company has reached its employee limit (${model.currentEmployees}/${model.maxEmployees}). Please ask the owner to upgrade their subscription.',
              code: 'EMPLOYEE_LIMIT_REACHED',
            );
          } else if (model.isAlreadyJoined) {
            throw ValidationFailure(
              message: 'You have already joined this company.',
              code: 'ALREADY_MEMBER',
            );
          } else if (model.isOwnerCannotJoin) {
            throw ValidationFailure(
              message: 'You cannot join your own business as an employee.',
              code: 'OWNER_CANNOT_JOIN',
            );
          } else if (model.isInvalidCode) {
            throw NotFoundFailure(
              message: 'Invalid code. Please check and try again.',
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
