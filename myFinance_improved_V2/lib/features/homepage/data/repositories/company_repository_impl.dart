import 'package:dartz/dartz.dart';
import 'package:myfinance_improved/core/errors/failures.dart';
import 'package:myfinance_improved/features/homepage/data/datasources/company_remote_datasource.dart';
import 'package:myfinance_improved/features/homepage/domain/entities/company.dart';
import 'package:myfinance_improved/features/homepage/domain/entities/company_type.dart';
import 'package:myfinance_improved/features/homepage/domain/entities/currency.dart';
import 'package:myfinance_improved/features/homepage/domain/repositories/company_repository.dart';

import 'base_repository.dart';

/// Implementation of CompanyRepository
/// Extends BaseRepository for centralized error handling and logging
class CompanyRepositoryImpl extends BaseRepository implements CompanyRepository {
  CompanyRepositoryImpl(this.remoteDataSource);

  final CompanyRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, Company>> createCompany({
    required String companyName,
    required String companyTypeId,
    required String baseCurrencyId,
  }) async {
    // Validation checks (returns early on failure)
    final isDuplicate =
        await remoteDataSource.checkDuplicateCompanyName(companyName);
    if (isDuplicate) {
      return const Left(ValidationFailure(
        message: 'You already have a business with this name',
        code: 'DUPLICATE_NAME',
      ),);
    }

    final companyTypeExists =
        await remoteDataSource.verifyCompanyTypeExists(companyTypeId);
    if (!companyTypeExists) {
      return const Left(ValidationFailure(
        message: 'Please select a valid business type',
        code: 'INVALID_COMPANY_TYPE',
      ),);
    }

    final currencyExists =
        await remoteDataSource.verifyCurrencyExists(baseCurrencyId);
    if (!currencyExists) {
      return const Left(ValidationFailure(
        message: 'Please select a valid currency',
        code: 'INVALID_CURRENCY',
      ),);
    }

    // Execute with automatic error handling
    return executeWithErrorHandling(
      operation: () async {
        final companyModel = await remoteDataSource.createCompany(
          companyName: companyName,
          companyTypeId: companyTypeId,
          baseCurrencyId: baseCurrencyId,
        );
        return companyModel.toEntity();
      },
      errorContext: 'createCompany',
      fallbackErrorMessage: 'Failed to create company. Please try again.',
    );
  }

  @override
  Future<Either<Failure, List<CompanyType>>> getCompanyTypes() async {
    return executeWithErrorHandling(
      operation: () async {
        final companyTypeModels = await remoteDataSource.getCompanyTypes();
        return companyTypeModels.map((model) => model.toEntity()).toList();
      },
      errorContext: 'getCompanyTypes',
      fallbackErrorMessage: 'Failed to load company types',
    );
  }

  @override
  Future<Either<Failure, List<Currency>>> getCurrencies() async {
    return executeWithErrorHandling(
      operation: () async {
        final currencyModels = await remoteDataSource.getCurrencies();
        return currencyModels.map((model) => model.toEntity()).toList();
      },
      errorContext: 'getCurrencies',
      fallbackErrorMessage: 'Failed to load currencies',
    );
  }
}
