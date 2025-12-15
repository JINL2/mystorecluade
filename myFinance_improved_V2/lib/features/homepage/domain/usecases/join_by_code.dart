import 'package:dartz/dartz.dart';
import 'package:myfinance_improved/core/errors/failures.dart';
import 'package:myfinance_improved/features/homepage/domain/entities/join_result.dart';
import 'package:myfinance_improved/features/homepage/domain/repositories/join_repository.dart';

/// Use case for joining a company or store by code
///
/// Validates the input code and calls the repository
/// The server determines whether it's a company or store code
class JoinByCode {
  const JoinByCode(this.repository);

  final JoinRepository repository;

  /// Execute the use case
  ///
  /// Validates:
  /// - Code is not empty
  /// - Code format is valid (alphanumeric, 5-20 characters)
  ///
  /// Returns Either<Failure, JoinResult>
  Future<Either<Failure, JoinResult>> call(JoinByCodeParams params) async {
    // Validate code is not empty
    // Keep original case - DB stores codes in lowercase
    final code = params.code.trim();

    if (code.isEmpty) {
      return const Left(ValidationFailure(
        message: 'Please enter a valid code',
        code: 'EMPTY_CODE',
      ),);
    }

    // Validate code format (alphanumeric, 5-20 characters, case insensitive)
    final codeRegex = RegExp(r'^[a-zA-Z0-9]{5,20}$');
    if (!codeRegex.hasMatch(code)) {
      return const Left(ValidationFailure(
        message: 'Code must be 5-20 alphanumeric characters',
        code: 'INVALID_CODE_FORMAT',
      ),);
    }

    // Call repository with lowercase code (DB stores codes in lowercase)
    return await repository.joinByCode(
      userId: params.userId,
      code: code.toLowerCase(),
    );
  }
}

/// Parameters for JoinByCode use case
class JoinByCodeParams {
  const JoinByCodeParams({
    required this.userId,
    required this.code,
  });

  final String userId;
  final String code;
}
