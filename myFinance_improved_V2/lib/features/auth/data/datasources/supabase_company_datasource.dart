// lib/features/auth/data/datasources/supabase_company_datasource.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/company_entity.dart';
import '../../domain/exceptions/auth_exceptions.dart';
import '../../domain/value_objects/company_type.dart';
import '../../domain/value_objects/currency.dart';

/// Supabase Company DataSource
///
/// 🚚 Data Layer - Supabase와 직접 통신하는 계층
///
/// 책임:
/// - Supabase API 호출
/// - JSON → Domain Entity/ValueObject 변환
/// - 네트워크 에러 처리
///
/// ✅ Clean Architecture 준수:
/// - Data Layer가 Domain Layer에 의존 (정상)
/// - Domain ValueObject를 직접 반환 (Model 없이)
abstract class CompanyDataSource {
  /// Create a new company
  Future<Company> createCompany(Map<String, dynamic> companyData);

  /// Get company by ID
  Future<Company?> getCompanyById(String companyId);

  /// Get companies by owner ID
  Future<List<Company>> getCompaniesByOwnerId(String ownerId);

  /// Check if company name exists
  Future<bool> isCompanyNameExists({
    required String name,
    required String ownerId,
  });

  /// Update company
  Future<Company> updateCompany(String companyId, Map<String, dynamic> updateData);

  /// Delete company (soft delete)
  Future<void> deleteCompany(String companyId);

  /// Get all company types
  ///
  /// ✅ Improvement: Returns CompanyType directly (no Model layer)
  Future<List<CompanyType>> getCompanyTypes();

  /// Get all currencies
  ///
  /// ✅ Improvement: Returns Currency directly (no Model layer)
  Future<List<Currency>> getCurrencies();

  /// Join company by code using RPC
  Future<Company> joinCompanyByCode({
    required String companyCode,
    required String userId,
  });
}

/// Supabase implementation of CompanyDataSource
class SupabaseCompanyDataSource implements CompanyDataSource {
  final SupabaseClient _client;

  SupabaseCompanyDataSource(this._client);

  @override
  Future<Company> createCompany(Map<String, dynamic> companyData) async {
    try {
      final createdData = await _client
          .from('companies')
          .insert(companyData)
          .select()
          .single();

      return Company.fromJson(createdData);
    } on PostgrestException catch (e) {
      if (e.code == '23505') {
        throw CompanyNameExistsException(name: companyData['company_name'] as String?);
      }
      rethrow;
    }
  }

  @override
  Future<Company?> getCompanyById(String companyId) async {
    try {
      final companyData = await _client
          .from('companies')
          .select()
          .eq('company_id', companyId)
          .eq('is_deleted', false)
          .maybeSingle();

      if (companyData == null) return null;

      return Company.fromJson(companyData);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Company>> getCompaniesByOwnerId(String ownerId) async {
    try {
      final companiesData = await _client
          .from('companies')
          .select()
          .eq('owner_id', ownerId)
          .eq('is_deleted', false);

      return companiesData
          .map((data) => Company.fromJson(data))
          .toList();
    } catch (e) {
      rethrow;
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
      rethrow;
    }
  }

  @override
  Future<Company> updateCompany(
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

      return Company.fromJson(updatedData);
    } catch (e) {
      rethrow;
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
      rethrow;
    }
  }

  @override
  Future<List<CompanyType>> getCompanyTypes() async {
    try {
      final typesData = await _client.from('company_types').select();

      // ✅ Direct conversion to Domain ValueObject
      return typesData
          .map((data) => CompanyType.fromJson(data))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Currency>> getCurrencies() async {
    try {
      final currenciesData = await _client.from('currency_types').select();

      // ✅ Direct conversion to Domain ValueObject
      return currenciesData
          .map((data) => Currency.fromJson(data))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Company> joinCompanyByCode({
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

      // Check RPC success
      final success = result['success'] as bool?;
      if (success != true) {
        // Handle RPC errors
        final errorCode = result['error_code'] as String?;
        final errorMessage = result['error'] as String? ?? 'Failed to join company';

        if (errorCode == 'INVALID_CODE') {
          throw InvalidCompanyCodeException();
        } else if (errorCode == 'ALREADY_MEMBER') {
          throw AlreadyMemberException();
        } else if (errorCode == 'COMPANY_NOT_FOUND') {
          throw CompanyNotFoundException();
        }

        throw NetworkException(details: errorMessage);
      }

      // Parse Company data from RPC response
      return Company(
        id: result['company_id'] as String,
        name: result['company_name'] as String,
        companyCode: companyCode,
        ownerId: result['owner_id'] as String,
        companyTypeId: result['company_type_id'] as String? ?? '',
        currencyId: result['base_currency_id'] as String? ?? '',
        createdAt: result['created_at'] != null
            ? DateTime.parse(result['created_at'] as String)
            : DateTime.now(),
        updatedAt: result['updated_at'] != null
            ? DateTime.parse(result['updated_at'] as String)
            : null,
      );
    } catch (e) {
      rethrow;
    }
  }
}
