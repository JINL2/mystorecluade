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
    // ✅ Pure data operation - no business logic
    // Business validation is handled in Domain layer (Use Case)
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
  Future<Either<Failure, bool>> checkDuplicateCompanyName(String companyName) async {
    return executeWithErrorHandling(
      operation: () async {
        return await remoteDataSource.checkDuplicateCompanyName(companyName);
      },
      errorContext: 'checkDuplicateCompanyName',
      fallbackErrorMessage: 'Failed to check company name',
    );
  }

  @override
  Future<Either<Failure, bool>> verifyCompanyTypeExists(String companyTypeId) async {
    return executeWithErrorHandling(
      operation: () async {
        return await remoteDataSource.verifyCompanyTypeExists(companyTypeId);
      },
      errorContext: 'verifyCompanyTypeExists',
      fallbackErrorMessage: 'Failed to verify company type',
    );
  }

  @override
  Future<Either<Failure, bool>> verifyCurrencyExists(String currencyId) async {
    return executeWithErrorHandling(
      operation: () async {
        return await remoteDataSource.verifyCurrencyExists(currencyId);
      },
      errorContext: 'verifyCurrencyExists',
      fallbackErrorMessage: 'Failed to verify currency',
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
