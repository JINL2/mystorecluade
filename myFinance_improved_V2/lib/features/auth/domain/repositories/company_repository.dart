// lib/features/auth/domain/repositories/company_repository.dart

import '../entities/company_entity.dart' hide CompanyType, Currency;
import '../value_objects/company_type.dart' show CompanyType;
import '../value_objects/currency.dart' show Currency;

/// Company repository interface.
///
/// Defines operations for managing companies.
/// Implementation will be in the data layer.
///
/// YAGNI Principle Applied: Only contains methods actually used.
abstract class CompanyRepository {
  /// Create a new company
  ///
  /// Returns the created [Company].
  /// Throws [CompanyNameExistsException] if name already exists for this owner.
  /// Throws [ValidationException] if data is invalid.
  Future<Company> create(Company company);

  /// Check if company name exists for user
  ///
  /// Returns `true` if the name already exists for this owner.
  Future<bool> nameExists({
    required String name,
    required String ownerId,
  });

  /// Get company types
  ///
  /// Returns list of available company types (e.g., LLC, Corporation, etc.)
  Future<List<CompanyType>> getCompanyTypes();

  /// Get currencies
  ///
  /// Returns list of available currencies.
  Future<List<Currency>> getCurrencies();

  /// Join an existing company using company code
  ///
  /// Returns the [Company] that was joined.
  /// Throws [InvalidCompanyCodeException] if code is invalid.
  /// Throws [AlreadyMemberException] if user is already a member.
  /// Throws [NetworkException] for network errors.
  Future<Company> joinByCode({
    required String companyCode,
    required String userId,
  });
}
