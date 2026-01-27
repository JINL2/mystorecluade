import 'package:myfinance_improved/features/homepage/core/homepage_logger.dart';
import 'package:myfinance_improved/features/homepage/data/models/company_model.dart';
import 'package:myfinance_improved/features/homepage/data/models/company_type_model.dart';
import 'package:myfinance_improved/features/homepage/data/models/currency_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Remote data source for company operations
/// Handles all direct Supabase communication for company feature
abstract class CompanyRemoteDataSource {
  /// Create a new company via RPC
  ///
  /// Calls 'homepage_insert_company' RPC which handles:
  /// - Input validation
  /// - Company creation with auto-generated company_code
  /// - DB triggers handle: user_companies, roles, permissions, user_roles, company_currency
  ///
  /// Returns [CompanyModel] on success
  /// Throws exception on error
  Future<CompanyModel> createCompany({
    required String companyName,
    required String companyTypeId,
    required String baseCurrencyId,
  });

  /// Get all company types and currencies from database via single RPC
  /// Used for dropdown population in company creation form
  /// Returns tuple of (companyTypes, currencies)
  Future<(List<CompanyTypeModel>, List<CurrencyModel>)> getCompanyCurrencyTypes();

  /// Check if company name already exists for this user
  /// Used for duplicate validation
  Future<bool> checkDuplicateCompanyName(String companyName);
}

class CompanyRemoteDataSourceImpl implements CompanyRemoteDataSource {
  CompanyRemoteDataSourceImpl(this.supabaseClient);

  final SupabaseClient supabaseClient;

  @override
  Future<CompanyModel> createCompany({
    required String companyName,
    required String companyTypeId,
    required String baseCurrencyId,
  }) async {
    homepageLogger.i('Starting company creation - companyName: $companyName, companyTypeId: $companyTypeId, baseCurrencyId: $baseCurrencyId');

    final userId = supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      homepageLogger.e('User not authenticated');
      throw Exception('User not authenticated');
    }

    homepageLogger.d('userId: $userId');

    final response = await supabaseClient.rpc<Map<String, dynamic>>(
      'homepage_insert_company',
      params: {
        'p_user_id': userId,
        'p_company_name': companyName,
        'p_company_type_id': companyTypeId,
        'p_base_currency_id': baseCurrencyId,
        'p_timezone': DateTime.now().timeZoneName,
      },
    );

    if (response['success'] != true) {
      final message = response['message'] as String? ?? 'Failed to create company';
      homepageLogger.e('RPC failed: $message');
      throw Exception(message);
    }

    final data = response['data'] as Map<String, dynamic>;
    homepageLogger.i('Company created successfully: ${data['company_name']}');

    return CompanyModel(
      id: data['company_id'] as String,
      name: data['company_name'] as String,
      code: data['company_code'] as String,
      companyTypeId: companyTypeId,
      baseCurrencyId: baseCurrencyId,
    );
  }

  @override
  Future<(List<CompanyTypeModel>, List<CurrencyModel>)> getCompanyCurrencyTypes() async {
    final response = await supabaseClient.rpc<Map<String, dynamic>>(
      'homepage_get_company_currency_types',
    );

    final companyTypes = (response['company_types'] as List)
        .map((json) => CompanyTypeModel.fromJson(json as Map<String, dynamic>))
        .toList();

    final currencies = (response['currency_types'] as List)
        .map((json) => CurrencyModel.fromJson(json as Map<String, dynamic>))
        .toList();

    return (companyTypes, currencies);
  }

  @override
  Future<bool> checkDuplicateCompanyName(String companyName) async {
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    final response = await supabaseClient.rpc<Map<String, dynamic>>(
      'homepage_validate_company_name',
      params: {
        'p_user_id': userId,
        'p_company_name': companyName,
      },
    );

    return response['is_duplicate'] as bool;
  }
}
