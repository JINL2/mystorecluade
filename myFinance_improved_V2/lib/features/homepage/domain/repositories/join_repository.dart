import 'package:dartz/dartz.dart';
import 'package:myfinance_improved/core/errors/failures.dart';
import 'package:myfinance_improved/features/homepage/domain/entities/join_result.dart';

/// Repository interface for joining companies/stores by code
///
/// This is a unified interface that handles both company and store joins
/// The server-side RPC determines whether the code is a company or store code
abstract class JoinRepository {
  /// Join a company or store by code
  ///
  /// The [code] can be either:
  /// - A company code (e.g., "COMP12345")
  /// - A store code (e.g., "STORE67890")
  ///
  /// The server automatically determines the code type and:
  /// - For company code: Adds user to company with Member role
  /// - For store code: Adds user to store and parent company
  ///
  /// Returns [JoinResult] with:
  /// - companyId: Always present (joined company or store's parent company)
  /// - storeId: Present only if joined a store
  /// - roleAssigned: Role given to user (e.g., "Member", "Employee")
  ///
  /// Throws [ValidationFailure] if code is empty or invalid format
  /// Throws [NotFoundFailure] if code doesn't exist
  /// Throws [PermissionFailure] if user already belongs to company/store
  /// Throws [ServerFailure] for other errors
  Future<Either<Failure, JoinResult>> joinByCode({
    required String userId,
    required String code,
  });
}
