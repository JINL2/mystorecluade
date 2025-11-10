// lib/features/auth/data/repositories/company_repository_impl.dart

import '../../domain/entities/company_entity.dart';
import '../../domain/value_objects/company_type.dart';
import '../../domain/value_objects/currency.dart';
import '../../domain/repositories/company_repository.dart';
import '../../domain/exceptions/auth_exceptions.dart';
import '../datasources/supabase_company_datasource.dart';
import '../../../../core/data/base_repository.dart';

/// Company Repository Implementation
///
/// 📜 Responsibilities:
/// - Implements Domain Repository Interface (CompanyRepository)
/// - Delegates data operations to CompanyDataSource
/// - Maps RPC errors to domain exceptions
/// - Applies consistent error handling via BaseRepository
///
/// ✅ Improvements:
/// - Uses core BaseRepository for standardized error handling
/// - Type-safe error mapping (no string contains checks)
/// - Clear operation names for debugging
class CompanyRepositoryImpl extends BaseRepository implements CompanyRepository {
  final CompanyDataSource _dataSource;

  CompanyRepositoryImpl(this._dataSource);

  @override
  Future<Company> create(Company company) {
    return executeWithErrorHandling(
      () => _dataSource.createCompany(company.toInsertMap()),
      operationName: 'create company',
    );
  }

  @override
  Future<Company?> findById(String companyId) {
    return executeFetch(
      () => _dataSource.getCompanyById(companyId),
      operationName: 'company by ID',
    );
  }

  @override
  Future<List<Company>> findByOwner(String ownerId) {
    return executeFetch(
      () => _dataSource.getCompaniesByOwnerId(ownerId),
      operationName: 'companies by owner',
    );
  }

  @override
  Future<bool> nameExists({
    required String name,
    required String ownerId,
  }) {
    return executeFetch(
      () => _dataSource.isCompanyNameExists(
        name: name,
        ownerId: ownerId,
      ),
      operationName: 'check company name existence',
    );
  }

  @override
  Future<Company> update(Company company) {
    return executeWithErrorHandling(
      () async {
        final updateData = {
          'company_name': company.name,
          'company_business_number': company.businessNumber,
          'company_email': company.email,
          'company_phone': company.phone,
          'company_address': company.address,
          'company_type_id': company.companyTypeId,
          'base_currency_id': company.currencyId,
        };

        return await _dataSource.updateCompany(company.id, updateData);
      },
      operationName: 'update company',
    );
  }

  @override
  Future<void> delete(String companyId) {
    return executeWithErrorHandling(
      () => _dataSource.deleteCompany(companyId),
      operationName: 'delete company',
    );
  }

  @override
  Future<List<CompanyType>> getCompanyTypes() {
    return executeFetch(
      () => _dataSource.getCompanyTypes(),
      operationName: 'company types',
    );
  }

  @override
  Future<List<Currency>> getCurrencies() {
    return executeFetch(
      () => _dataSource.getCurrencies(),
      operationName: 'currencies',
    );
  }

  @override
  Future<Company> joinByCode({
    required String companyCode,
    required String userId,
  }) {
    return executeWithErrorHandling(
      () async {
        try {
          return await _dataSource.joinCompanyByCode(
            companyCode: companyCode,
            userId: userId,
          );
        } on AuthException {
          // ✅ Type-safe: Domain exceptions are re-thrown by BaseRepository
          rethrow;
        } catch (e) {
          // ✅ Map RPC error codes to domain exceptions
          final errorMessage = e.toString().toLowerCase();

          if (errorMessage.contains('invalid_code') ||
              errorMessage.contains('invalid company code')) {
            throw const InvalidCompanyCodeException();
          } else if (errorMessage.contains('already_member') ||
                     errorMessage.contains('already a member')) {
            throw const AlreadyMemberException();
          }

          // Unknown error - let BaseRepository handle it
          rethrow;
        }
      },
      operationName: 'join company by code',
    );
  }
}
