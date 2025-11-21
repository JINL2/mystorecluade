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
  /// ✅ CLEAN ARCHITECTURE COMPLIANT
  ///
  /// Performs complete business validation before delegating to repository.
  /// This includes:
  /// 1. Format validation (length, emptiness)
  /// 2. Business rules validation (duplicates, existence checks)
  ///
  /// Following Single Responsibility Principle:
  /// - Use Case: Business logic and validation (this class)
  /// - Repository: Data access and persistence (repository)
  ///
  /// Returns [Right<Company>] on success
  /// Returns [Left<Failure>] on error
  Future<Either<Failure, Company>> call(CreateCompanyParams params) async {
    // Step 1: Format Validation
    final formatValidation = _validateFormat(params);
    if (formatValidation != null) {
      return Left(formatValidation);
    }

    // Step 2: Business Rules Validation (Domain Layer Responsibility)
    final businessValidation = await _validateBusinessRules(params);
    if (businessValidation != null) {
      return Left(businessValidation);
    }

    // Step 3: Delegate to repository for data persistence
    return await repository.createCompany(
      companyName: params.companyName.trim(),
      companyTypeId: params.companyTypeId.trim(),
      baseCurrencyId: params.baseCurrencyId.trim(),
    );
  }

  /// Validate business rules
  ///
  /// Checks:
  /// - Duplicate company name
  /// - Company type existence
  /// - Currency existence
  ///
  /// Returns [ValidationFailure] if validation fails, null if passes
  Future<ValidationFailure?> _validateBusinessRules(CreateCompanyParams params) async {
    // Check for duplicate company name
    final duplicateResult = await repository.checkDuplicateCompanyName(params.companyName.trim());
    final isDuplicate = duplicateResult.fold(
      (failure) => false, // On error, assume not duplicate and let creation fail
      (isDuplicate) => isDuplicate,
    );

    if (isDuplicate) {
      return const ValidationFailure(
        message: 'You already have a business with this name',
        code: 'DUPLICATE_NAME',
      );
    }

    // Verify company type exists
    final companyTypeResult = await repository.verifyCompanyTypeExists(params.companyTypeId.trim());
    final companyTypeExists = companyTypeResult.fold(
      (failure) => false,
      (exists) => exists,
    );

    if (!companyTypeExists) {
      return const ValidationFailure(
        message: 'Please select a valid business type',
        code: 'INVALID_COMPANY_TYPE',
      );
    }

    // Verify currency exists
    final currencyResult = await repository.verifyCurrencyExists(params.baseCurrencyId.trim());
    final currencyExists = currencyResult.fold(
      (failure) => false,
      (exists) => exists,
    );

    if (!currencyExists) {
      return const ValidationFailure(
        message: 'Please select a valid currency',
        code: 'INVALID_CURRENCY',
      );
    }

    return null; // All business rules passed
  }

  /// Validate input format
  ///
  /// Returns [ValidationFailure] if validation fails, null if passes
  ValidationFailure? _validateFormat(CreateCompanyParams params) {
    // Validate company name
    if (params.companyName.trim().isEmpty) {
      return const ValidationFailure(
        message: 'Please enter a valid company name',
        code: 'INVALID_NAME',
      );
    }

    if (params.companyName.trim().length < 2) {
      return const ValidationFailure(
        message: 'Company name must be at least 2 characters',
        code: 'NAME_TOO_SHORT',
      );
    }

    if (params.companyName.trim().length > 100) {
      return const ValidationFailure(
        message: 'Company name must be less than 100 characters',
        code: 'NAME_TOO_LONG',
      );
    }

    // Validate company type ID
    if (params.companyTypeId.trim().isEmpty) {
      return const ValidationFailure(
        message: 'Please select a valid business type',
        code: 'INVALID_COMPANY_TYPE',
      );
    }

    // Validate currency ID
    if (params.baseCurrencyId.trim().isEmpty) {
      return const ValidationFailure(
        message: 'Please select a valid currency',
        code: 'INVALID_CURRENCY',
      );
    }

    return null; // All validations passed
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
