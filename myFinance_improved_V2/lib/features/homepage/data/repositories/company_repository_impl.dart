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
    // All validation is now handled by RPC (homepage_insert_company)
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
  Future<Either<Failure, (List<CompanyType>, List<Currency>)>> getCompanyCurrencyTypes() async {
    return executeWithErrorHandling(
      operation: () async {
        final (companyTypeModels, currencyModels) = await remoteDataSource.getCompanyCurrencyTypes();
        final companyTypes = companyTypeModels.map((model) => model.toEntity()).toList();
        final currencies = currencyModels.map((model) => model.toEntity()).toList();
        return (companyTypes, currencies);
      },
      errorContext: 'getCompanyCurrencyTypes',
      fallbackErrorMessage: 'Failed to load company types and currencies',
    );
  }
}
