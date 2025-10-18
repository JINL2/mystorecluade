// lib/features/auth/domain/usecases/join_company_usecase.dart

import '../entities/company_entity.dart';
import '../exceptions/auth_exceptions.dart';
import '../exceptions/validation_exception.dart';
import '../repositories/company_repository.dart';

/// Join company use case.
///
/// Handles joining an existing company using a company code.
/// Throws exceptions for error cases - no Result pattern wrapper.
class JoinCompanyUseCase {
  final CompanyRepository _companyRepository;

  const JoinCompanyUseCase({
    required CompanyRepository companyRepository,
  }) : _companyRepository = companyRepository;

  /// Execute join company
  ///
  /// Returns [Company] if successful.
  /// Throws exceptions for error cases:
  /// - [ValidationException] for invalid company code format
  /// - [InvalidCompanyCodeException] if code doesn't exist
  /// - [AlreadyMemberException] if user is already a member
  /// - [NetworkException] for network errors
  Future<Company> execute({
    required String companyCode,
    required String userId,
  }) async {
    // Step 1: Validate company code format
    final trimmedCode = companyCode.trim().toUpperCase();

    if (trimmedCode.isEmpty) {
      throw ValidationException('Company code is required');
    }

    if (trimmedCode.length < 6) {
      throw ValidationException('Company code must be at least 6 characters');
    }

    // Step 2: Join company via repository
    final company = await _companyRepository.joinByCode(
      companyCode: trimmedCode,
      userId: userId,
    );

    return company;
  }
}
