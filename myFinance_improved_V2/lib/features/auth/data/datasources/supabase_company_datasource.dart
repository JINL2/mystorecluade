// lib/features/auth/data/datasources/supabase_company_datasource.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/company_model.dart';
import '../models/company_type_model.dart';
import '../models/currency_model.dart';

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
  Future<CompanyModel> createCompany(Map<String, dynamic> companyData);

  /// Get company by ID
  Future<CompanyModel?> getCompanyById(String companyId);

  /// Get companies by owner ID
  Future<List<CompanyModel>> getCompaniesByOwnerId(String ownerId);

  /// Check if company name exists
  Future<bool> isCompanyNameExists({
    required String name,
    required String ownerId,
  });

  /// Update company
  Future<CompanyModel> updateCompany(String companyId, Map<String, dynamic> updateData);

  /// Delete company (soft delete)
  Future<void> deleteCompany(String companyId);

  /// Get all company types
  Future<List<CompanyTypeModel>> getCompanyTypes();

  /// Get all currencies
  Future<List<CurrencyModel>> getCurrencies();

  /// Join company by code using RPC
  Future<CompanyModel> joinCompanyByCode({
    required String companyCode,
    required String userId,
  });
}

/// Supabase implementation of CompanyDataSource
class SupabaseCompanyDataSource implements CompanyDataSource {
  final SupabaseClient _client;

  SupabaseCompanyDataSource(this._client);

  @override
  Future<CompanyModel> createCompany(Map<String, dynamic> companyData) async {
    try {
      // DataSource는 단순히 데이터만 저장
      // Validation은 UseCase/Domain layer에서 처리됨
      final createdData = await _client
          .from('companies')
          .insert(companyData)
          .select()
          .single();

      return CompanyModel.fromJson(createdData);
    } catch (e) {
      throw Exception('Failed to create company: $e');
    }
  }

  @override
  Future<CompanyModel?> getCompanyById(String companyId) async {
    try {
      final companyData = await _client
          .from('companies')
          .select()
          .eq('company_id', companyId)
          .eq('is_deleted', false)
          .maybeSingle();

      if (companyData == null) return null;

      return CompanyModel.fromJson(companyData);
    } catch (e) {
      throw Exception('Failed to get company: $e');
    }
  }

  @override
  Future<List<CompanyModel>> getCompaniesByOwnerId(String ownerId) async {
    try {
      final companiesData = await _client
          .from('companies')
          .select()
          .eq('owner_id', ownerId)
          .eq('is_deleted', false);

      return companiesData
          .map((data) => CompanyModel.fromJson(data))
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
  Future<CompanyModel> updateCompany(
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

      return CompanyModel.fromJson(updatedData);
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
  Future<CompanyModel> joinCompanyByCode({
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
        // Return company model with the data from RPC
        return CompanyModel(
          companyId: result['company_id'] as String,
          companyName: result['company_name'] as String? ??
                       result['business_name'] as String? ??
                       'Unknown Company',
          companyCode: companyCode,
          ownerId: result['owner_id'] as String? ?? userId,
          companyTypeId: result['company_type_id'] as String? ?? '',
          baseCurrencyId: result['base_currency_id'] as String? ?? '',
          createdAt: result['created_at'] as String? ?? DateTime.now().toIso8601String(),
          updatedAt: result['updated_at'] as String? ?? DateTime.now().toIso8601String(),
        );
      } else {
        // RPC returned an error
        final errorCode = result['error_code'] ?? 'UNKNOWN_ERROR';
        final errorMessage = result['error'] ?? 'Failed to join company';
        throw Exception('$errorCode: $errorMessage');
      }
    } catch (e) {
      throw Exception('Failed to join company: $e');
    }
  }
}
