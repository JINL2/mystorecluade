// lib/features/auth/data/datasources/supabase_company_datasource.dart

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/exceptions/auth_exceptions.dart';
import '../models/company_type_model.dart';
import '../models/currency_model.dart';
import '../models/freezed/company_dto.dart';

/// Supabase Company DataSource
///
/// 🚚 배달 기사 - Supabase와 직접 통신하는 계층
///
/// 책임:
/// - Supabase API 호출
/// - JSON → Model 변환
/// - 네트워크 에러 처리
///
/// 이 계층은 Supabase에 대한 모든 지식을 가지고 있습니다.
abstract class CompanyDataSource {
  /// Create a new company
  Future<CompanyDto> createCompany(Map<String, dynamic> companyData);

  /// Get company by ID
  Future<CompanyDto?> getCompanyById(String companyId);

  /// Get companies by owner ID
  Future<List<CompanyDto>> getCompaniesByOwnerId(String ownerId);

  /// Check if company name exists
  Future<bool> isCompanyNameExists({
    required String name,
    required String ownerId,
  });

  /// Update company
  Future<CompanyDto> updateCompany(String companyId, Map<String, dynamic> updateData);

  /// Delete company (soft delete)
  Future<void> deleteCompany(String companyId);

  /// Get all company types
  Future<List<CompanyTypeModel>> getCompanyTypes();

  /// Get all currencies
  Future<List<CurrencyModel>> getCurrencies();

  /// Join company by code using RPC
  Future<CompanyDto> joinCompanyByCode({
    required String companyCode,
    required String userId,
  });
}

/// Supabase implementation of CompanyDataSource
class SupabaseCompanyDataSource implements CompanyDataSource {
  final SupabaseClient _client;

  SupabaseCompanyDataSource(this._client);

  @override
  Future<CompanyDto> createCompany(Map<String, dynamic> companyData) async {
    try {
      // DataSource는 단순히 데이터만 저장
      // Validation은 UseCase/Domain layer에서 처리됨
      final createdData = await _client
          .from('companies')
          .insert(companyData)
          .select()
          .single();

      return CompanyDto.fromJson(createdData);
    } catch (e) {
      throw Exception('Failed to create company: $e');
    }
  }

  @override
  Future<CompanyDto?> getCompanyById(String companyId) async {
    try {
      final companyData = await _client
          .from('companies')
          .select()
          .eq('company_id', companyId)
          .eq('is_deleted', false)
          .maybeSingle();

      if (companyData == null) return null;

      return CompanyDto.fromJson(companyData);
    } catch (e) {
      throw Exception('Failed to get company: $e');
    }
  }

  @override
  Future<List<CompanyDto>> getCompaniesByOwnerId(String ownerId) async {
    try {
      final companiesData = await _client
          .from('companies')
          .select()
          .eq('owner_id', ownerId)
          .eq('is_deleted', false);

      return companiesData
          .map((data) => CompanyDto.fromJson(data))
          .toList();
    } catch (e) {
      throw Exception('Failed to get companies: $e');
    }
  }

  @override
  Future<bool> isCompanyNameExists({
    required String name,
    required String ownerId,
  }) async {
    try {
      final duplicates = await _client
          .from('companies')
          .select('company_id')
          .eq('owner_id', ownerId)
          .ilike('company_name', name.trim())
          .eq('is_deleted', false);

      return duplicates.isNotEmpty;
    } catch (e) {
      throw Exception('Failed to check company name: $e');
    }
  }

  @override
  Future<CompanyDto> updateCompany(
    String companyId,
    Map<String, dynamic> updateData,
  ) async {
    try {
      final updatedData = await _client
          .from('companies')
          .update({
            ...updateData,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('company_id', companyId)
          .select()
          .single();

      return CompanyDto.fromJson(updatedData);
    } catch (e) {
      throw Exception('Failed to update company: $e');
    }
  }

  @override
  Future<void> deleteCompany(String companyId) async {
    try {
      await _client.from('companies').update({
        'is_deleted': true,
        'deleted_at': DateTime.now().toIso8601String(),
      }).eq('company_id', companyId);
    } catch (e) {
      throw Exception('Failed to delete company: $e');
    }
  }

  @override
  Future<List<CompanyTypeModel>> getCompanyTypes() async {
    try {
      final typesData = await _client.from('company_types').select();
      return typesData
          .map((data) => CompanyTypeModel.fromJson(data))
          .toList();
    } catch (e) {
      throw Exception('Failed to get company types: $e');
    }
  }

  @override
  Future<List<CurrencyModel>> getCurrencies() async {
    try {
      final currenciesData = await _client.from('currency_types').select();
      return currenciesData
          .map((data) => CurrencyModel.fromJson(data))
          .toList();
    } catch (e) {
      throw Exception('Failed to get currencies: $e');
    }
  }

  @override
  Future<CompanyDto> joinCompanyByCode({
    required String companyCode,
    required String userId,
  }) async {
    try {
      // Call the join_business_by_code RPC function
      final response = await _client.rpc(
        'join_business_by_code',
        params: {
          'p_user_id': userId,
          'p_business_code': companyCode,
        },
      );

      final result = response as Map<String, dynamic>;

      if (result['success'] == true) {
        // Fetch the full company data after joining
        final companyId = result['company_id'] as String;
        final companyData = await _client
            .from('companies')
            .select()
            .eq('company_id', companyId)
            .single();

        return CompanyDto.fromJson(companyData);
      } else {
        // RPC returned an error - throw specific exceptions based on error code
        final errorCode = result['error_code'] ?? 'UNKNOWN_ERROR';

        switch (errorCode) {
          case 'EMPLOYEE_LIMIT_REACHED':
            throw EmployeeLimitReachedException(
              maxEmployees: (result['max_employees'] as int?) ?? 0,
              currentEmployees: (result['current_employees'] as int?) ?? 0,
            );
          case 'INVALID_COMPANY_CODE':
          case 'BUSINESS_NOT_FOUND':
            throw const InvalidCompanyCodeException();
          case 'ALREADY_MEMBER':
            throw const AlreadyMemberException();
          case 'OWNER_CANNOT_JOIN':
            throw const OwnerCannotJoinException();
          default:
            final errorMessage = result['error'] ?? 'Failed to join company';
            throw Exception('$errorCode: $errorMessage');
        }
      }
    } on EmployeeLimitReachedException {
      rethrow;
    } on InvalidCompanyCodeException {
      rethrow;
    } on AlreadyMemberException {
      rethrow;
    } on OwnerCannotJoinException {
      rethrow;
    } catch (e) {
      throw Exception('Failed to join company: $e');
    }
  }
}
