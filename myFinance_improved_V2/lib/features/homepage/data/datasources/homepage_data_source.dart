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


      if (response == null) {
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

      return model;
    } catch (e) {
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

    final response = await _supabaseService.client.rpc(
      'get_user_companies_and_stores',
      params: {
        'p_user_id': userId,
      },
    );


    if (response == null) {
      throw Exception('No user companies data returned from database');
    }

    try {
      final data = response as Map<String, dynamic>;

      // ✅ Filter out deleted companies and stores
      if (data['companies'] != null && data['companies'] is List) {
        final companies = data['companies'] as List<dynamic>;

        // Filter deleted companies and their deleted stores
        final filteredCompanies = companies.where((company) {
          final isDeleted = company['is_deleted'] == true;
          return !isDeleted;
        }).map((company) {
          // Also filter deleted stores within each company
          if (company['stores'] != null && company['stores'] is List) {
            final stores = company['stores'] as List<dynamic>;
            final filteredStores = stores.where((store) {
              final isDeleted = store['is_deleted'] == true;
              return !isDeleted;
            }).toList();

            company['stores'] = filteredStores;
            company['store_count'] = filteredStores.length;
          }
          return company;
        }).toList();

        data['companies'] = filteredCompanies;
        data['company_count'] = filteredCompanies.length;
      }

      final model = UserCompaniesModel.fromJson(data);
      return model;
    } catch (e) {
      rethrow;
    }
  }

  // === Feature Operations ===

  /// Fetch all categories with features via get_categories_with_features RPC
  ///
  /// Calls: rpc('get_categories_with_features')
  /// Returns: List of categories with their features
  Future<List<CategoryFeaturesModel>> getCategoriesWithFeatures() async {
    try {
      final response = await _supabaseService.client.rpc(
        'get_categories_with_features',
      );

      if (response == null || response is! List) {
        throw Exception('Invalid categories data returned from database');
      }

      final models = (response)
          .map((json) {
            return CategoryFeaturesModel.fromJson(json as Map<String, dynamic>);
          })
          .toList();

      return models;
    } catch (e) {
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
    try {
      final response = await _supabaseService.client.rpc(
        'get_user_quick_access_features',
        params: {
          'p_user_id': userId,
          'p_company_id': companyId,
        },
      );

      if (response == null || response is! List) {
        throw Exception('Invalid quick access features data returned from database');
      }

      final models = (response)
          .map((json) {
            return TopFeatureModel.fromJson(json as Map<String, dynamic>);
          })
          .toList();

      return models;
    } catch (e) {
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
