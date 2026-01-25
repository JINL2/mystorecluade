import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/cache/auth_data_cache.dart';
import '../../../../core/services/supabase_service.dart';
import '../models/category_features_model.dart';
import '../models/homepage_alert_model.dart';
import '../models/top_feature_model.dart';
import '../models/user_companies_model.dart';

/// Data source for homepage data operations
///
/// Handles all Supabase RPC calls for homepage features.
/// Uses Models (DTO + Mapper consolidated) for data serialization.
///
/// Revenue Data:
/// - Uses get_dashboard_revenue_v3 RPC for ALL revenue data (totals + chart)
/// - v1 and v2 RPCs are deprecated and should be removed from Supabase
class HomepageDataSource {
  final SupabaseService _supabaseService;

  HomepageDataSource(this._supabaseService);

  // === User & Company Operations ===

  /// Fetch user companies and stores via get_user_companies_with_salary RPC
  ///
  /// Calls: rpc('get_user_companies_with_salary', {...})
  /// Returns: User with companies, stores, subscription, and salary info
  ///
  /// ✅ Uses new RPC that includes subscription data for each company
  /// ✅ Includes salary info (salary_type, currency_code, currency_symbol)
  /// ✅ Filters out deleted companies and stores before parsing
  Future<UserCompaniesModel> getUserCompanies(String userId) async {

    final response = await _supabaseService.client.rpc(
      'get_user_companies_with_salary',
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
        // Note: DO NOT override company_count here!
        // RPC returns company_count as OWNED companies count (for subscription limit)
        // filteredCompanies.length is ALL companies user has access to
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

  // === Feature Click Tracking ===

  /// Log feature click to user_preferences table via log_feature_click RPC
  ///
  /// Calls: rpc('log_feature_click', {...})
  /// Purpose: Track which features users click most frequently for analytics
  Future<void> logFeatureClick({
    required String featureId,
    required String featureName,
    required String companyId,
    String? categoryId,
  }) async {
    try {
      await _supabaseService.client.rpc(
        'log_feature_click',
        params: {
          'p_feature_id': featureId,
          'p_feature_name': featureName,
          'p_company_id': companyId,
          'p_category_id': categoryId,
        },
      );
    } catch (e) {
      // Don't throw - logging clicks should not block user navigation
      // Just silently fail
    }
  }

  // === Alert Operations ===

  /// Fetch homepage alert via homepage_get_alert RPC
  ///
  /// Calls: rpc('homepage_get_alert', {p_user_id: userId})
  /// Returns: Alert with is_show, is_checked flag and content
  ///
  /// Uses 6-hour cache to prevent excessive API calls.
  /// Cache is reset on app restart or pull-to-refresh.
  Future<HomepageAlertModel> getHomepageAlert({required String userId}) async {
    try {
      final response = await AuthDataCache.instance.deduplicate<Map<String, dynamic>>(
        'homepage_get_alert_$userId',
        () => _supabaseService.client.rpc<Map<String, dynamic>>(
          'homepage_get_alert',
          params: {'p_user_id': userId},
        ),
        customTimeout: const Duration(hours: 6),
      );
      return HomepageAlertModel.fromJson(response);
    } catch (e) {
      // Return default (no alert) on error to not block homepage
      return const HomepageAlertModel(isShow: false, isChecked: false, content: null);
    }
  }

  /// Force refresh homepage alert by invalidating cache
  void invalidateHomepageAlertCache(String userId) {
    AuthDataCache.instance.invalidate('homepage_get_alert_$userId');
  }

  /// Update user's alert response (is_checked) via homepage_response_alert RPC
  ///
  /// Calls: rpc('homepage_response_alert', {p_user_id: userId, p_is_checked: isChecked})
  /// Returns: {status: 'success', is_checked: bool} or {status: 'error', message: string}
  Future<bool> responseHomepageAlert({
    required String userId,
    required bool isChecked,
  }) async {
    try {
      final response = await _supabaseService.client.rpc<Map<String, dynamic>>(
        'homepage_response_alert',
        params: {
          'p_user_id': userId,
          'p_is_checked': isChecked,
        },
      );

      final status = response['status'] as String?;
      if (status == 'success') {
        // Invalidate cache so next fetch gets updated is_checked value
        invalidateHomepageAlertCache(userId);
        return true;
      }
      return false;
    } catch (e) {
      // Silently fail - don't block user
      return false;
    }
  }

  // === User Salary Operations ===

  /// Fetch user salary data via homepage_user_salary RPC
  ///
  /// Calls: rpc('homepage_user_salary', {...})
  /// Returns: Salary data with company_total and by_store breakdown
  ///
  /// Response structure:
  /// {
  ///   "salary_info": { salary_type, salary_amount, currency_code, currency_symbol },
  ///   "by_store": [ { store_id, store_name, today, this_week, this_month, ... } ],
  ///   "company_total": { today, this_week, this_month, last_month, this_year }
  /// }
  Future<Map<String, dynamic>> getUserSalary({
    required String userId,
    required String companyId,
    required String timezone,
  }) async {
    try {
      final response = await _supabaseService.client.rpc<Map<String, dynamic>>(
        'homepage_user_salary',
        params: {
          'p_user_id': userId,
          'p_company_id': companyId,
          'p_request_time': DateTime.now().toIso8601String(),
          'p_timezone': timezone,
        },
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // === App Version Check ===

  /// Check app version via check_app_version RPC
  ///
  /// Calls: rpc('check_app_version')
  /// Returns: {version: "1.0.0"} or {version: null}
  ///
  /// Compares server version with current app version.
  /// Returns true if versions match (app is up to date).
  /// Returns false if versions don't match (update required).
  Future<bool> checkAppVersion() async {
    try {
      final response = await _supabaseService.client.rpc<Map<String, dynamic>>(
        'check_app_version',
      );

      final serverVersion = response['version'] as String?;

      if (serverVersion == null) {
        // No version set on server - allow app to continue
        return true;
      }

      // Get current app version
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      // Compare versions
      return serverVersion == currentVersion;
    } catch (e) {
      // On error, allow app to continue (don't block users)
      return true;
    }
  }

  // === Revenue Chart Operations ===

  /// Fetch revenue chart data via get_dashboard_revenue_v3 RPC
  ///
  /// Calls: rpc('get_dashboard_revenue_v3', {...})
  /// Returns: Chart data with revenue, gross_profit, net_income time series
  ///
  /// Time filter options:
  /// - today: Single day total
  /// - yesterday: Previous day total
  /// - past_7_days: Daily data for rolling 7 days (today - 6 days)
  /// - this_month: Daily data 1st~Today
  /// - last_month: Daily data for full previous month
  /// - this_year: Monthly data Jan~Current month
  Future<Map<String, dynamic>> getRevenueChartData({
    required String companyId,
    required String timeFilter,
    required String timezone,
    String? storeId,
  }) async {
    try {
      // Build ISO8601 string with timezone offset for accurate date calculation
      final now = DateTime.now();
      final offset = now.timeZoneOffset;
      final offsetSign = offset.isNegative ? '-' : '+';
      final offsetHours = offset.inHours.abs().toString().padLeft(2, '0');
      final offsetMinutes = (offset.inMinutes.abs() % 60).toString().padLeft(2, '0');
      final timeWithOffset = '${now.toIso8601String()}$offsetSign$offsetHours:$offsetMinutes';

      final response = await _supabaseService.client.rpc<Map<String, dynamic>>(
        'get_dashboard_revenue_v3',
        params: {
          'p_company_id': companyId,
          'p_time': timeWithOffset,
          'p_timezone': timezone,
          'p_time_filter': timeFilter,
          'p_store_id': storeId,
        },
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }
}
