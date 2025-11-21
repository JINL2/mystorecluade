import 'package:dartz/dartz.dart';
import 'package:myfinance_improved/core/errors/failures.dart';
import 'package:myfinance_improved/features/homepage/domain/entities/company.dart';
import 'package:myfinance_improved/features/homepage/domain/entities/company_type.dart';
import 'package:myfinance_improved/features/homepage/domain/entities/currency.dart';

/// Repository interface for company operations
/// Defines the contract that the data layer must implement
abstract class CompanyRepository {
  /// Create a new company with all associated data
  ///
  /// Performs the following operations:
  /// 1. INSERT companies (auto-generates company_code)
  /// 2. INSERT user_companies (links user)
  /// 3. INSERT/GET roles (Owner role)
  /// 4. INSERT role_permissions (all features)
  /// 5. INSERT user_roles (assign Owner)
  /// 6. INSERT company_currency (base currency)
  ///
  /// Returns [Right<Company>] on success
  /// Returns [Left<Failure>] on error
  Future<Either<Failure, Company>> createCompany({
    required String companyName,
    required String companyTypeId,
    required String baseCurrencyId,
  });

  /// Get all available company types from database
  /// Used for populating the company type dropdown
  ///
  /// Returns [Right<List<CompanyType>>] on success
  /// Returns [Left<Failure>] on error
  Future<Either<Failure, List<CompanyType>>> getCompanyTypes();

  /// Get all available currencies from database
  /// Used for populating the currency dropdown
  ///
  /// Returns [Right<List<Currency>>] on success
  /// Returns [Left<Failure>] on error
  Future<Either<Failure, List<Currency>>> getCurrencies();

  /// Check if a company name already exists for the current user
  /// Used for duplicate validation in business logic
  ///
  /// Returns [Right<bool>] - true if duplicate exists, false otherwise
  /// Returns [Left<Failure>] on error
  Future<Either<Failure, bool>> checkDuplicateCompanyName(String companyName);

  /// Verify that a company type ID exists in the database
  /// Used for referential integrity validation in business logic
  ///
  /// Returns [Right<bool>] - true if exists, false otherwise
  /// Returns [Left<Failure>] on error
  Future<Either<Failure, bool>> verifyCompanyTypeExists(String companyTypeId);

  /// Verify that a currency ID exists in the database
  /// Used for referential integrity validation in business logic
  ///
  /// Returns [Right<bool>] - true if exists, false otherwise
  /// Returns [Left<Failure>] on error
  Future<Either<Failure, bool>> verifyCurrencyExists(String currencyId);
}
