import '../entities/category_with_features.dart';
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
}
