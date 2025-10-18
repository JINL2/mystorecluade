import 'package:flutter/foundation.dart';
import '../../../../core/services/supabase_service.dart';
import '../models/category_features_model.dart';
import '../models/revenue_model.dart';
import '../models/top_feature_model.dart';
import '../models/user_companies_model.dart';

/// Data source for homepage data operations
///
/// Handles all Supabase RPC calls for homepage features.
/// Uses Models (DTO + Mapper consolidated) for data serialization.
class HomepageDataSource {
  final SupabaseService _supabaseService;

  HomepageDataSource(this._supabaseService);

  /// Filter deleted companies and stores from RPC response
  ///
  /// ✅ Removes companies where is_deleted = true
  /// ✅ Removes stores where is_deleted = true within each company
  /// ✅ Updates company_count and store_count after filtering
  ///
  /// This should be called on raw JSON before parsing into models.
  static Map<String, dynamic> filterDeletedCompaniesAndStores(Map<String, dynamic> data) {
    if (data['companies'] == null || data['companies'] is! List) {
      return data;
    }

    final companies = data['companies'] as List<dynamic>;
    debugPrint('🔵 [DataSource.filterDeleted] Total companies before filter: ${companies.length}');

    // Filter deleted companies and their deleted stores
    final filteredCompanies = companies.where((company) {
      final isDeleted = company['is_deleted'] == true;
      if (isDeleted) {
        debugPrint('🔵 [DataSource.filterDeleted] ❌ Filtering out deleted company: ${company['company_name']}');
      }
      return !isDeleted;
    }).map((company) {
      // Also filter deleted stores within each company
      if (company['stores'] != null && company['stores'] is List) {
        final stores = company['stores'] as List<dynamic>;
        final filteredStores = stores.where((store) {
          final isDeleted = store['is_deleted'] == true;
          if (isDeleted) {
            debugPrint('🔵 [DataSource.filterDeleted] ❌ Filtering out deleted store: ${store['store_name']} in company ${company['company_name']}');
          }
          return !isDeleted;
        }).toList();

        company['stores'] = filteredStores;
        company['store_count'] = filteredStores.length;
      }
      return company;
    }).toList();

    data['companies'] = filteredCompanies;
    data['company_count'] = filteredCompanies.length;

    debugPrint('🔵 [DataSource.filterDeleted] ✅ Total companies after filter: ${filteredCompanies.length}');
    return data;
  }

  // === Revenue Operations ===

  /// Fetch revenue data via get_dashboard_revenue RPC
  ///
  /// Calls: rpc('get_dashboard_revenue', {...})
  /// Returns: Single revenue record
  Future<RevenueModel> getRevenue({
    required String companyId,
    String? storeId,
    required String period,
  }) async {
    debugPrint('🔵 [DataSource.getRevenue] Calling RPC: get_dashboard_revenue');
    debugPrint('🔵 [DataSource.getRevenue] Params: companyId=$companyId, storeId=$storeId, period=$period');

    // Convert period to date for RPC
    final date = _periodToDate(period);

    try {
      final response = await _supabaseService.client.rpc(
        'get_dashboard_revenue',
        params: {
          'p_company_id': companyId,
          'p_store_id': storeId,
          'p_date': date,  // Changed from p_period to p_date
        },
      );

      debugPrint('🔵 [DataSource.getRevenue] Response type: ${response.runtimeType}');
      debugPrint('🔵 [DataSource.getRevenue] Response: $response');

      if (response == null) {
        debugPrint('🔵 [DataSource.getRevenue] ERROR: No revenue data returned');
        throw Exception('No revenue data returned from database');
      }

      // Manually map RPC response to model
      // RPC returns: total_today, total_yesterday, currency_code, currency_symbol
      // Model expects: amount, currencySymbol, period, comparisonAmount
      final data = response as Map<String, dynamic>;

      // Determine which totals to use based on period
      double currentAmount = 0.0;
      double previousAmount = 0.0;

      switch (period.toLowerCase()) {
        case 'today':
          currentAmount = (data['total_today'] as num?)?.toDouble() ?? 0.0;
          previousAmount = (data['total_yesterday'] as num?)?.toDouble() ?? 0.0;
          break;
        case 'month':
          currentAmount = (data['total_this_month'] as num?)?.toDouble() ?? 0.0;
          previousAmount = (data['total_last_month'] as num?)?.toDouble() ?? 0.0;
          break;
        case 'year':
          currentAmount = (data['total_this_year'] as num?)?.toDouble() ?? 0.0;
          previousAmount = 0.0; // No previous year data in current RPC
          break;
        default:
          currentAmount = (data['total_today'] as num?)?.toDouble() ?? 0.0;
          previousAmount = (data['total_yesterday'] as num?)?.toDouble() ?? 0.0;
      }

      final model = RevenueModel(
        amount: currentAmount,
        currencySymbol: (data['currency_symbol'] as String?) ?? '\$',
        period: period,
        comparisonAmount: previousAmount,
        comparisonPeriod: period == 'today' ? 'yesterday' : 'previous $period',
        lastUpdated: DateTime.now(),
        storeId: storeId,
        companyId: companyId,
      );

      debugPrint('🔵 [DataSource.getRevenue] Successfully parsed model: amount=${model.amount}, previous=${model.comparisonAmount}');
      return model;
    } catch (e, stack) {
      debugPrint('🔵 [DataSource.getRevenue] ERROR: $e');
      debugPrint('🔵 [DataSource.getRevenue] Stack: $stack');
      rethrow;
    }
  }

  // === User & Company Operations ===

  /// Fetch user companies and stores via get_user_companies_and_stores RPC
  ///
  /// Calls: rpc('get_user_companies_and_stores', {...})
  /// Returns: User with companies and stores
  ///
  /// ✅ Filters out deleted companies and stores before parsing
  Future<UserCompaniesModel> getUserCompanies(String userId) async {
    debugPrint('🔵 [DataSource.getUserCompanies] Calling RPC: get_user_companies_and_stores');
    debugPrint('🔵 [DataSource.getUserCompanies] userId: $userId');

    final response = await _supabaseService.client.rpc(
      'get_user_companies_and_stores',
      params: {
        'p_user_id': userId,
      },
    );

    debugPrint('🔵 [DataSource.getUserCompanies] Response type: ${response.runtimeType}');

    if (response == null) {
      throw Exception('No user companies data returned from database');
    }

    try {
      final data = response as Map<String, dynamic>;

      // ✅ Filter out deleted companies and stores using static helper
      final filteredData = filterDeletedCompaniesAndStores(data);

      final model = UserCompaniesModel.fromJson(filteredData);
      debugPrint('🔵 [DataSource.getUserCompanies] Successfully parsed user companies');
      return model;
    } catch (e, stack) {
      debugPrint('🔵 [DataSource.getUserCompanies] ERROR parsing response: $e');
      debugPrint('🔵 [DataSource.getUserCompanies] Stack: $stack');
      debugPrint('🔵 [DataSource.getUserCompanies] Response data: $response');
      rethrow;
    }
  }

  // === Feature Operations ===

  /// Fetch all categories with features via get_categories_with_features RPC
  ///
  /// Calls: rpc('get_categories_with_features')
  /// Returns: List of categories with their features
  Future<List<CategoryFeaturesModel>> getCategoriesWithFeatures() async {
    debugPrint('🔵 [DataSource.getCategoriesWithFeatures] Calling RPC: get_categories_with_features');

    try {
      final response = await _supabaseService.client.rpc(
        'get_categories_with_features',
      );

      debugPrint('🔵 [DataSource.getCategoriesWithFeatures] Response type: ${response.runtimeType}');
      debugPrint('🔵 [DataSource.getCategoriesWithFeatures] Response length: ${response is List ? response.length : "not a list"}');

      if (response == null || response is! List) {
        debugPrint('🔵 [DataSource.getCategoriesWithFeatures] ERROR: Invalid data returned');
        throw Exception('Invalid categories data returned from database');
      }

      final models = (response as List<dynamic>)
          .map((json) {
            debugPrint('🔵 [DataSource.getCategoriesWithFeatures]   Parsing category: ${json['category_name']}');
            return CategoryFeaturesModel.fromJson(json as Map<String, dynamic>);
          })
          .toList();

      debugPrint('🔵 [DataSource.getCategoriesWithFeatures] Successfully parsed ${models.length} categories');
      return models;
    } catch (e, stack) {
      debugPrint('🔵 [DataSource.getCategoriesWithFeatures] ERROR: $e');
      debugPrint('🔵 [DataSource.getCategoriesWithFeatures] Stack: $stack');
      rethrow;
    }
  }

  /// Fetch user's frequently used features via get_user_quick_access_features RPC
  ///
  /// Calls: rpc('get_user_quick_access_features', {...})
  /// Returns: List of top features ordered by usage
  Future<List<TopFeatureModel>> getQuickAccessFeatures({
    required String userId,
    required String companyId,
  }) async {
    debugPrint('🔵 [DataSource.getQuickAccessFeatures] Calling RPC: get_user_quick_access_features');
    debugPrint('🔵 [DataSource.getQuickAccessFeatures] Params: userId=$userId, companyId=$companyId');

    try {
      final response = await _supabaseService.client.rpc(
        'get_user_quick_access_features',
        params: {
          'p_user_id': userId,
          'p_company_id': companyId,
        },
      );

      debugPrint('🔵 [DataSource.getQuickAccessFeatures] Response type: ${response.runtimeType}');
      debugPrint('🔵 [DataSource.getQuickAccessFeatures] Response length: ${response is List ? response.length : "not a list"}');

      if (response == null || response is! List) {
        debugPrint('🔵 [DataSource.getQuickAccessFeatures] ERROR: Invalid data returned');
        throw Exception('Invalid quick access features data returned from database');
      }

      final models = (response as List<dynamic>)
          .map((json) {
            final model = TopFeatureModel.fromJson(json as Map<String, dynamic>);
            debugPrint('🔵 [DataSource.getQuickAccessFeatures]   Feature: ${model.featureName}, iconKey: "${model.iconKey}", icon: "${model.icon}"');
            return model;
          })
          .toList();

      debugPrint('🔵 [DataSource.getQuickAccessFeatures] Successfully parsed ${models.length} features');
      return models;
    } catch (e, stack) {
      debugPrint('🔵 [DataSource.getQuickAccessFeatures] ERROR: $e');
      debugPrint('🔵 [DataSource.getQuickAccessFeatures] Stack: $stack');
      rethrow;
    }
  }

  /// Convert period string to date string for RPC
  ///
  /// Converts: 'today', 'week', 'month', 'year' → '2025-01-16'
  String _periodToDate(String period) {
    final now = DateTime.now();

    switch (period.toLowerCase()) {
      case 'today':
        return _formatDate(now);
      case 'week':
        return _formatDate(now.subtract(const Duration(days: 7)));
      case 'month':
        return _formatDate(DateTime(now.year, now.month - 1, now.day));
      case 'year':
        return _formatDate(DateTime(now.year - 1, now.month, now.day));
      default:
        return _formatDate(now);
    }
  }

  /// Format DateTime to YYYY-MM-DD
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
