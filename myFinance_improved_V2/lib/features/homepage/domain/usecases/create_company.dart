import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:myfinance_improved/core/errors/failures.dart';
import 'package:myfinance_improved/features/homepage/domain/entities/company.dart';
import 'package:myfinance_improved/features/homepage/domain/repositories/company_repository.dart';

/// Use case for creating a new company
///
/// Encapsulates the business logic for company creation
/// Follows Clean Architecture's dependency inversion principle
class CreateCompany {
  const CreateCompany(this.repository);

  final CompanyRepository repository;

  /// Execute the use case
  ///
  /// Validates inputs and delegates to repository
  /// Returns [Right<Company>] on success
  /// Returns [Left<Failure>] on error
  Future<Either<Failure, Company>> call(CreateCompanyParams params) async {
    // Validate company name
    if (params.companyName.trim().isEmpty) {
      return const Left(ValidationFailure(
        message: 'Please enter a valid company name',
        code: 'INVALID_NAME',
      ),);
    }

    if (params.companyName.trim().length < 2) {
      return const Left(ValidationFailure(
        message: 'Company name must be at least 2 characters',
        code: 'NAME_TOO_SHORT',
      ),);
    }

    if (params.companyName.trim().length > 100) {
      return const Left(ValidationFailure(
        message: 'Company name must be less than 100 characters',
        code: 'NAME_TOO_LONG',
      ),);
    }

    // Validate company type ID
    if (params.companyTypeId.trim().isEmpty) {
      return const Left(ValidationFailure(
        message: 'Please select a valid business type',
        code: 'INVALID_COMPANY_TYPE',
      ),);
    }

    // Validate currency ID
    if (params.baseCurrencyId.trim().isEmpty) {
      return const Left(ValidationFailure(
        message: 'Please select a valid currency',
        code: 'INVALID_CURRENCY',
      ),);
    }

    // Delegate to repository
    return await repository.createCompany(
      companyName: params.companyName.trim(),
      companyTypeId: params.companyTypeId.trim(),
      baseCurrencyId: params.baseCurrencyId.trim(),
    );
  }
}

/// Parameters for creating a company
class CreateCompanyParams extends Equatable {
  const CreateCompanyParams({
    required this.companyName,
    required this.companyTypeId,
    required this.baseCurrencyId,
  });

  final String companyName;
  final String companyTypeId;
  final String baseCurrencyId;

  @override
  List<Object?> get props => [companyName, companyTypeId, baseCurrencyId];
}
