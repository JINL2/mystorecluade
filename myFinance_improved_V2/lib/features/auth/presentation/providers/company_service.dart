import 'package:flutter_riverpod/flutter_riverpod.dart';

// Domain Layer
import '../../domain/entities/company_entity.dart';
import '../../domain/value_objects/create_company_command.dart';
import '../../domain/value_objects/company_type.dart';
import '../../domain/value_objects/currency.dart';

// Providers
import 'usecase_providers.dart';
import 'repository_providers.dart';

/// Company Service
///
/// Provides high-level company operations.
/// This service follows the legacy pattern of Provider<Service> for minimal
/// UI code changes during migration.
///
/// Responsibilities:
/// - Execute company-related UseCases
/// - Provide simple data queries (types, currencies)
/// - Coordinate business operations
///
/// Usage:
/// ```dart
/// final companyService = ref.read(companyServiceProvider);
/// final company = await companyService.createCompany(
///   name: 'My Business',
///   typeId: 'type-id',
///   currencyId: 'currency-id',
/// );
/// ```
class CompanyService {
  const CompanyService(this.ref);

  final Ref ref;

  /// Create a new company
  ///
  /// Performs the following operations:
  /// 1. Validates company data via CreateCompanyUseCase
  /// 2. Creates company in database
  /// 3. Creates owner association
  /// 4. Generates company code
  ///
  /// Returns the created [Company] entity.
  ///
  /// Throws:
  /// - [ValidationException] if validation fails
  /// - [DuplicateException] if company name already exists
  /// - [NetworkException] if network error occurs
  Future<Company> createCompany({
    required String name,
    required String ownerId,
    required String companyTypeId,
    required String currencyId,
    String? email,
    String? phone,
    String? address,
    String? businessNumber,
  }) async {
    try {
      final command = CreateCompanyCommand(
        name: name.trim(),
        ownerId: ownerId,
        companyTypeId: companyTypeId,
        currencyId: currencyId,
        email: email?.trim(),
        phone: phone?.trim(),
        address: address?.trim(),
        businessNumber: businessNumber?.trim(),
      );

      return await ref.read(createCompanyUseCaseProvider).execute(command);
    } catch (e) {
      rethrow;
    }
  }

  /// Get all available company types
  ///
  /// Simple data query - no UseCase needed.
  /// Returns list of company types for dropdown/selection.
  ///
  /// Example types:
  /// - Retail
  /// - Restaurant
  /// - Service
  /// - Manufacturing
  Future<List<CompanyType>> getCompanyTypes() async {
    try {
      final repository = ref.read(companyRepositoryProvider);
      return await repository.getCompanyTypes();
    } catch (e) {
      rethrow;
    }
  }

  /// Get all available currencies
  ///
  /// Simple data query - no UseCase needed.
  /// Returns list of currencies for dropdown/selection.
  ///
  /// Example currencies:
  /// - USD
  /// - EUR
  /// - GBP
  /// - KRW
  Future<List<Currency>> getCurrencies() async {
    try {
      final repository = ref.read(companyRepositoryProvider);
      return await repository.getCurrencies();
    } catch (e) {
      rethrow;
    }
  }

  /// Check if company name is available
  ///
  /// Validates that company name is not already taken by current user.
  ///
  /// Returns true if name is available, false otherwise.
  Future<bool> isCompanyNameAvailable(String name, String ownerId) async {
    try {
      final repository = ref.read(companyRepositoryProvider);
      final isDuplicate = await repository.nameExists(
        name: name.trim(),
        ownerId: ownerId,
      );
      return !isDuplicate;
    } catch (e) {
      rethrow;
    }
  }
}

/// Company Service Provider
///
/// Provides CompanyService instance with all dependencies injected.
final companyServiceProvider = Provider<CompanyService>((ref) {
  return CompanyService(ref);
});
