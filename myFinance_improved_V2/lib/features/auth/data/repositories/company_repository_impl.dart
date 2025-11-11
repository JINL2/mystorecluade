// lib/features/auth/data/repositories/company_repository_impl.dart

import '../../domain/entities/company_entity.dart';
import '../../domain/value_objects/company_type.dart';
import '../../domain/value_objects/currency.dart';
import '../../domain/repositories/company_repository.dart';
import '../../domain/exceptions/auth_exceptions.dart';
import '../datasources/supabase_company_datasource.dart';
import '../models/freezed/company_dto.dart';
import '../models/freezed/company_dto_mapper.dart';
import 'base_repository.dart';

/// Company Repository Implementation
///
/// 📜 계약 이행자 - Domain Repository Interface를 구현
///
/// 책임:
/// - Domain 계약 준수
/// - DataSource 호출
/// - Model ↔ Entity 변환
/// - Exception 처리 및 변환
///
/// 이 계층은 Domain과 Data 사이의 변환을 담당합니다.
class CompanyRepositoryImpl extends BaseRepository implements CompanyRepository {
  final CompanyDataSource _dataSource;

  CompanyRepositoryImpl(this._dataSource);

  @override
  Future<Company> create(Company company) {
    return execute(() async {
      // Convert Entity to insert map (without ID)
      final insertMap = company.toInsertMap();

      // Call DataSource
      final createdDto = await _dataSource.createCompany(insertMap);

      // Convert DTO back to Entity
      return createdDto.toEntity();
    });
  }

  @override
  Future<Company?> findById(String companyId) {
    return executeNullable(() async {
      final model = await _dataSource.getCompanyById(companyId);
      return model?.toEntity();
    });
  }

  @override
  Future<List<Company>> findByOwner(String ownerId) {
    return execute(() async {
      final models = await _dataSource.getCompaniesByOwnerId(ownerId);
      return models.map((m) => m.toEntity()).toList();
    });
  }

  @override
  Future<Company?> findByCode(String companyCode) async {
    throw UnimplementedError(
      'findByCode requires additional database query method',
    );
  }

  @override
  Future<bool> nameExists({
    required String name,
    required String ownerId,
  }) {
    return execute(() async {
      return await _dataSource.isCompanyNameExists(
        name: name,
        ownerId: ownerId,
      );
    });
  }

  @override
  Future<Company> update(Company company) {
    return execute(() async {
      final updateData = {
        'company_name': company.name,
        'company_type_id': company.companyTypeId,
        'base_currency_id': company.currencyId,
      };

      final updatedDto = await _dataSource.updateCompany(
        company.id,
        updateData,
      );

      return updatedDto.toEntity();
    });
  }

  @override
  Future<void> delete(String companyId) {
    return execute(() async {
      await _dataSource.deleteCompany(companyId);
    });
  }

  @override
  Future<List<CompanyType>> getCompanyTypes() async {
    return execute(() async {
      final models = await _dataSource.getCompanyTypes();
      return models.map((m) => m.toValueObject()).toList();
    });
  }

  @override
  Future<List<Currency>> getCurrencies() async {
    return execute(() async {
      final models = await _dataSource.getCurrencies();
      return models.map((m) => m.toValueObject()).toList();
    });
  }

  @override
  Future<Company> joinByCode({
    required String companyCode,
    required String userId,
  }) {
    return execute(() async {
      try {
        final companyModel = await _dataSource.joinCompanyByCode(
          companyCode: companyCode,
          userId: userId,
        );
        return companyModel.toEntity();
      } catch (e) {
        // Map specific errors
        if (e.toString().contains('INVALID_CODE') ||
            e.toString().contains('Invalid company code')) {
          throw InvalidCompanyCodeException();
        } else if (e.toString().contains('ALREADY_MEMBER') ||
                   e.toString().contains('already a member')) {
          throw AlreadyMemberException();
        }
        rethrow;
      }
    });
  }
}
