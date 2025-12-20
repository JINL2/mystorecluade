import '../entities/category_with_features.dart';
import '../entities/homepage_alert.dart';
import '../entities/revenue.dart';
import '../entities/top_feature.dart';
import '../entities/user_with_companies.dart';
import '../revenue_period.dart';

/// Repository interface for homepage data operations
///
/// Defines the contract for fetching homepage-related data.
/// Implementation should be in the data layer.
abstract class HomepageRepository {
  // === Revenue Operations ===

  /// Fetch revenue data for a company or store
  Future<Revenue> getRevenue({
    required String companyId,
    String? storeId,
    required RevenuePeriod period,
  });

  // === User & Company Operations ===

  /// Fetch user with all their companies and stores
  Future<UserWithCompanies> getUserCompanies(String userId);

  // === Feature Operations ===

  /// Fetch all categories with their features
  Future<List<CategoryWithFeatures>> getCategoriesWithFeatures();

  /// Fetch user's frequently used features (Quick Access)
  Future<List<TopFeature>> getQuickAccessFeatures({
    required String userId,
    required String companyId,
  });

  // === Feature Click Tracking ===

  /// Log feature click for analytics
  Future<void> logFeatureClick({
    required String featureId,
    required String featureName,
    required String companyId,
    String? categoryId,
  });

  // === Alert Operations ===

  /// Fetch homepage alert for user
  Future<HomepageAlert> getHomepageAlert({required String userId});

  /// Update user's alert response (is_checked)
  Future<bool> responseHomepageAlert({
    required String userId,
    required bool isChecked,
  });

  // === App Version Check ===

  /// Check if app version matches server version
  /// Returns true if up to date, false if update required
  Future<bool> checkAppVersion();

  // === User Salary Operations ===

  /// Fetch user salary data for homepage
  /// Returns salary info with company_total and by_store breakdown
  Future<Map<String, dynamic>> getUserSalary({
    required String userId,
    required String companyId,
    required String timezone,
  });

  // === Revenue Chart Operations ===

  /// Fetch revenue chart data for dashboard visualization
  /// Returns chart data with revenue, gross_profit, net_income time series
  Future<Map<String, dynamic>> getRevenueChartData({
    required String companyId,
    required String timeFilter,
    required String timezone,
    String? storeId,
  });
}
