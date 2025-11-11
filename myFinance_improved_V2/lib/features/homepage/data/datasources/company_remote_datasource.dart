import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:myfinance_improved/features/homepage/data/models/company_model.dart';
import 'package:myfinance_improved/features/homepage/data/models/company_type_model.dart';
import 'package:myfinance_improved/features/homepage/data/models/currency_model.dart';
import 'package:myfinance_improved/features/homepage/core/homepage_logger.dart';

/// Remote data source for company operations
/// Handles all direct Supabase communication for company feature
abstract class CompanyRemoteDataSource {
  /// Create a new company with 6-step process
  ///
  /// Steps:
  /// 1. INSERT companies (auto-generates company_code)
  /// 2. INSERT user_companies (links user)
  /// 3. INSERT/GET roles (Owner role)
  /// 4. INSERT role_permissions (all features)
  /// 5. INSERT user_roles (assign Owner)
  /// 6. INSERT company_currency (base currency)
  ///
  /// Returns [CompanyModel] on success
  /// Throws exception on error (PostgrestException, etc.)
  Future<CompanyModel> createCompany({
    required String companyName,
    required String companyTypeId,
    required String baseCurrencyId,
  });

  /// Get all company types from database
  /// Used for dropdown population
  Future<List<CompanyTypeModel>> getCompanyTypes();

  /// Get all currencies from database
  /// Used for dropdown population
  Future<List<CurrencyModel>> getCurrencies();

  /// Check if company name already exists for this user
  /// Used for duplicate validation
  Future<bool> checkDuplicateCompanyName(String companyName);

  /// Verify company type exists in database
  Future<bool> verifyCompanyTypeExists(String companyTypeId);

  /// Verify currency exists in database
  Future<bool> verifyCurrencyExists(String currencyId);
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
    String? companyId;

    try {
      // Step 1: Create the company
      homepageLogger.d('Step 1: Creating company...');
      final companyResponse = await supabaseClient
          .from('companies')
          .insert({
            'company_name': companyName,
            'company_type_id': companyTypeId,
            'owner_id': userId,
            'base_currency_id': baseCurrencyId,
          })
          .select('company_id, company_code, company_name')
          .single();

      companyId = companyResponse['company_id'] as String;
      final companyCode = companyResponse['company_code'] as String;
      homepageLogger.i('Step 1 SUCCESS: companyId=$companyId, companyCode=$companyCode');

      // Step 2: Add user to company
      homepageLogger.d('Step 2: Adding user to company...');
      await supabaseClient.from('user_companies').insert({
        'user_id': userId,
        'company_id': companyId,
      });
      homepageLogger.i('Step 2 SUCCESS: User added to company');

      // Note: All remaining steps (role creation, permissions, user_roles, company_currency)
      // are handled automatically by database triggers

      // Return created company
      homepageLogger.i('ALL STEPS SUCCESSFUL! Returning company model');
      return CompanyModel(
        id: companyId,
        name: companyName,
        code: companyCode,
        companyTypeId: companyTypeId,
        baseCurrencyId: baseCurrencyId,
      );
    } catch (e) {
      homepageLogger.e('ERROR CAUGHT: $e (Type: ${e.runtimeType})');

      // Rollback: Clean up created company if something fails
      if (companyId != null) {
        homepageLogger.w('Attempting rollback for companyId: $companyId');
        try {
          await supabaseClient
              .from('companies')
              .delete()
              .eq('company_id', companyId);
          homepageLogger.i('Rollback successful');
        } catch (rollbackError) {
          homepageLogger.e('Rollback FAILED: $rollbackError');
          // Log rollback error but don't throw
        }
      }

      homepageLogger.e('Rethrowing error...');
      rethrow;
    }
  }

  @override
  Future<List<CompanyTypeModel>> getCompanyTypes() async {
    final response = await supabaseClient
        .from('company_types')
        .select('company_type_id, type_name')
        .order('type_name');

    return (response as List)
        .map((json) => CompanyTypeModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<CurrencyModel>> getCurrencies() async {
    final response = await supabaseClient
        .from('currency_types')
        .select('currency_id, currency_code, currency_name, symbol')
        .order('currency_name');

    return (response as List)
        .map((json) => CurrencyModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<bool> checkDuplicateCompanyName(String companyName) async {
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    final response = await supabaseClient
        .from('companies')
        .select('company_id')
        .eq('owner_id', userId)
        .eq('company_name', companyName)  // Changed from .ilike() to .eq() for exact match
        .eq('is_deleted', false);

    return (response as List).isNotEmpty;
  }

  @override
  Future<bool> verifyCompanyTypeExists(String companyTypeId) async {
    final response = await supabaseClient
        .from('company_types')
        .select('company_type_id')
        .eq('company_type_id', companyTypeId)
        .maybeSingle();

    return response != null;
  }

  @override
  Future<bool> verifyCurrencyExists(String currencyId) async {
    final response = await supabaseClient
        .from('currency_types')
        .select('currency_id')
        .eq('currency_id', currencyId)
        .maybeSingle();

    return response != null;
  }
}
