import 'package:flutter_riverpod/flutter_riverpod.dart';

// Domain Layer
import '../../domain/entities/company_entity.dart';
import '../../domain/repositories/company_repository.dart';
import '../../domain/usecases/create_company_usecase.dart';
import '../../domain/value_objects/company_type.dart';
import '../../domain/value_objects/currency.dart';
import '../../domain/value_objects/create_company_command.dart';

// Providers
import '../../infrastructure/providers/repository_providers.dart';
import 'usecase_providers.dart';

/// Company Service
///
/// Provides high-level company operations.
/// This service follows the Facade pattern to simplify UI interactions.
///
/// Responsibilities:
/// - Execute company-related UseCases
/// - Provide simple data queries (types, currencies)
/// - Abstract complexity from UI layer
///
/// Usage:
/// ```dart
/// final companyService = ref.read(companyServiceProvider);
/// final company = await companyService.createCompany(...);
/// ```
class CompanyService {
  final CreateCompanyUseCase _createCompanyUseCase;
  final CompanyRepository _companyRepository;

  const CompanyService({
    required CreateCompanyUseCase createCompanyUseCase,
    required CompanyRepository companyRepository,
  })  : _createCompanyUseCase = createCompanyUseCase,
        _companyRepository = companyRepository;

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
    return await _createCompanyUseCase.execute(
      CreateCompanyCommand(
        name: name.trim(),
        ownerId: ownerId,
        companyTypeId: companyTypeId,
        currencyId: currencyId,
        email: email?.trim(),
        phone: phone?.trim(),
        address: address?.trim(),
        businessNumber: businessNumber?.trim(),
      ),
    );
  }

  /// Get all available company types
  ///
  /// Simple data query - no UseCase needed.
  /// Returns list of company types for dropdown/selection.
  Future<List<CompanyType>> getCompanyTypes() {
    return _companyRepository.getCompanyTypes();
  }

  /// Get all available currencies
  ///
  /// Simple data query - no UseCase needed.
  /// Returns list of currencies for dropdown/selection.
  Future<List<Currency>> getCurrencies() {
    return _companyRepository.getCurrencies();
  }

  /// Check if company name is available
  ///
  /// Validates that company name is not already taken by current user.
  /// Returns true if name is available, false otherwise.
  Future<bool> isCompanyNameAvailable(String name, String ownerId) async {
    final isDuplicate = await _companyRepository.nameExists(
      name: name.trim(),
      ownerId: ownerId,
    );
    return !isDuplicate;
  }
}

/// Company Service Provider
///
/// Provides CompanyService instance with all dependencies injected.
final companyServiceProvider = Provider<CompanyService>((ref) {
  return CompanyService(
    createCompanyUseCase: ref.watch(createCompanyUseCaseProvider),
    companyRepository: ref.watch(companyRepositoryProvider),
  );
});
