import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:myfinance_improved/core/errors/failures.dart';
import 'package:myfinance_improved/core/utils/error_mapper.dart';
import 'package:myfinance_improved/features/homepage/domain/entities/join_result.dart';
import 'package:myfinance_improved/features/homepage/domain/repositories/join_repository.dart';
import 'package:myfinance_improved/features/homepage/data/datasources/join_remote_datasource.dart';

/// Implementation of JoinRepository
class JoinRepositoryImpl implements JoinRepository {
  const JoinRepositoryImpl(this.remoteDataSource);

  final JoinRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, JoinResult>> joinByCode({
    required String userId,
    required String code,
  }) async {
    try {
      // Call remote data source
      final model = await remoteDataSource.joinByCode(
        userId: userId,
        code: code,
      );

      // Check if join was successful
      if (!model.success) {
        // RPC returned success=false, usually means code not found
        return const Left(NotFoundFailure(
          message: 'Invalid code. Please check and try again.',
          code: 'INVALID_CODE',
        ));
      }

      // Convert model to entity
      return Right(model.toEntity());
    } on PostgrestException catch (e) {
      // Map Supabase errors to domain failures
      return Left(_mapPostgrestError(e));
    } on Exception catch (e) {
      // Handle other exceptions
      return Left(UnknownFailure(
        message: 'An unexpected error occurred: ${e.toString()}',
        code: 'UNKNOWN_ERROR',
      ));
    }
  }

  /// Map PostgrestException to domain Failure
  Failure _mapPostgrestError(PostgrestException e) {
    // Use shared error mapper
    final mappedFailure = SupabaseErrorMapper.mapPostgrestError(e);

    // Additional specific mapping for join operations
    if (e.message.toLowerCase().contains('code not found') ||
        e.message.toLowerCase().contains('invalid code')) {
      return const NotFoundFailure(
        message: 'Code not found. Please check and try again.',
        code: 'CODE_NOT_FOUND',
      );
    }

    if (e.message.toLowerCase().contains('already a member') ||
        e.message.toLowerCase().contains('already belongs')) {
      return const PermissionFailure(
        message: 'You are already a member of this company/store.',
        code: 'ALREADY_MEMBER',
      );
    }

    return mappedFailure;
  }
}
