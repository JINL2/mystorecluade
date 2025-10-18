import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:myfinance_improved/core/errors/failures.dart';
import 'package:myfinance_improved/features/homepage/domain/entities/company.dart';
import 'package:myfinance_improved/features/homepage/domain/entities/company_type.dart';
import 'package:myfinance_improved/features/homepage/domain/entities/currency.dart';
import 'package:myfinance_improved/features/homepage/domain/repositories/company_repository.dart';
import 'package:myfinance_improved/features/homepage/data/datasources/company_remote_datasource.dart';

/// Implementation of CompanyRepository
/// Implements the domain contract and handles error mapping
class CompanyRepositoryImpl implements CompanyRepository {
  const CompanyRepositoryImpl(this.remoteDataSource);

  final CompanyRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, Company>> createCompany({
    required String companyName,
    required String companyTypeId,
    required String baseCurrencyId,
  }) async {
    try {
      // Check for duplicate company name
      final isDuplicate =
          await remoteDataSource.checkDuplicateCompanyName(companyName);
      if (isDuplicate) {
        return const Left(ValidationFailure(
          message: 'You already have a business with this name',
          code: 'DUPLICATE_NAME',
        ));
      }

      // Verify company type exists
      final companyTypeExists =
          await remoteDataSource.verifyCompanyTypeExists(companyTypeId);
      if (!companyTypeExists) {
        return const Left(ValidationFailure(
          message: 'Please select a valid business type',
          code: 'INVALID_COMPANY_TYPE',
        ));
      }

      // Verify currency exists
      final currencyExists =
          await remoteDataSource.verifyCurrencyExists(baseCurrencyId);
      if (!currencyExists) {
        return const Left(ValidationFailure(
          message: 'Please select a valid currency',
          code: 'INVALID_CURRENCY',
        ));
      }

      // Create company
      final companyModel = await remoteDataSource.createCompany(
        companyName: companyName,
        companyTypeId: companyTypeId,
        baseCurrencyId: baseCurrencyId,
      );

      return Right(companyModel.toEntity());
    } on PostgrestException catch (e) {
      return Left(_mapPostgrestError(e));
    } on Exception catch (e) {
      if (e.toString().contains('not authenticated')) {
        return const Left(AuthFailure(
          message: 'Please log in to create a business',
          code: 'AUTH_REQUIRED',
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

  @override
  Future<Either<Failure, List<CompanyType>>> getCompanyTypes() async {
    try {
      final companyTypeModels = await remoteDataSource.getCompanyTypes();
      final companyTypes =
          companyTypeModels.map((model) => model.toEntity()).toList();
      return Right(companyTypes);
    } on PostgrestException catch (e) {
      return Left(_mapPostgrestError(e));
    } catch (e) {
      return Left(ServerFailure(
        message: 'Failed to load company types',
        code: 'FETCH_COMPANY_TYPES_ERROR',
      ));
    }
  }

  @override
  Future<Either<Failure, List<Currency>>> getCurrencies() async {
    try {
      final currencyModels = await remoteDataSource.getCurrencies();
      final currencies =
          currencyModels.map((model) => model.toEntity()).toList();
      return Right(currencies);
    } on PostgrestException catch (e) {
      return Left(_mapPostgrestError(e));
    } catch (e) {
      return Left(ServerFailure(
        message: 'Failed to load currencies',
        code: 'FETCH_CURRENCIES_ERROR',
      ));
    }
  }

  /// Map Supabase errors to domain failures
  Failure _mapPostgrestError(PostgrestException e) {
    switch (e.code) {
      case '23505': // Unique constraint violation
        if (e.message.contains('company_name')) {
          return const ServerFailure(
            message: 'A business with this name already exists',
            code: 'DUPLICATE_NAME',
          );
        }
        return const ServerFailure(
          message: 'This information is already in use',
          code: 'DUPLICATE_ERROR',
        );
      case '23503': // Foreign key constraint violation
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
