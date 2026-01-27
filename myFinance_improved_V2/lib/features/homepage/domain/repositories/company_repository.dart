import 'package:dartz/dartz.dart';
import 'package:myfinance_improved/core/errors/failures.dart';
import 'package:myfinance_improved/features/homepage/domain/entities/company.dart';
import 'package:myfinance_improved/features/homepage/domain/entities/company_type.dart';
import 'package:myfinance_improved/features/homepage/domain/entities/currency.dart';

/// Repository interface for company operations
/// Defines the contract that the data layer must implement
abstract class CompanyRepository {
  /// Create a new company via RPC
  ///
  /// Calls 'homepage_insert_company' RPC which handles:
  /// - Input validation (duplicate name, company type, currency)
  /// - Company creation with auto-generated company_code
  /// - DB triggers handle: user_companies, roles, permissions, user_roles, company_currency
  ///
  /// Returns [Right<Company>] on success
  /// Returns [Left<Failure>] on error
  Future<Either<Failure, Company>> createCompany({
    required String companyName,
    required String companyTypeId,
    required String baseCurrencyId,
  });

  /// Get all available company types and currencies from database via single RPC
  /// Used for populating dropdowns in company creation form
  ///
  /// Returns [Right<(List<CompanyType>, List<Currency>)>] on success
  /// Returns [Left<Failure>] on error
  Future<Either<Failure, (List<CompanyType>, List<Currency>)>> getCompanyCurrencyTypes();
}
