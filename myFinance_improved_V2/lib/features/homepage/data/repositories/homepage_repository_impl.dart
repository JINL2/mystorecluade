import '../../domain/entities/category_with_features.dart';
import '../../domain/entities/homepage_alert.dart';
import '../../domain/entities/revenue.dart';
import '../../domain/entities/top_feature.dart';
import '../../domain/entities/user_with_companies.dart';
import '../../domain/repositories/homepage_repository.dart';
import '../../domain/revenue_period.dart';
import '../datasources/homepage_data_source.dart';

/// Implementation of HomepageRepository using Supabase
///
/// Coordinates data fetching from Supabase via DataSource and converts
/// Models to domain entities (Model = DTO + Mapper consolidated).
class HomepageRepositoryImpl implements HomepageRepository {
  final HomepageDataSource _dataSource;

  HomepageRepositoryImpl({
    required HomepageDataSource dataSource,
  }) : _dataSource = dataSource;

  // === Revenue Operations ===

  @override
  Future<Revenue> getRevenue({
    required String companyId,
    String? storeId,
    required RevenuePeriod period,
  }) async {
    try {
      final revenueModel = await _dataSource.getRevenue(
        companyId: companyId,
        storeId: storeId,
        period: period.name, // Convert enum to string
      );

      final revenue = revenueModel.toEntity();
      return revenue;
    } catch (e) {
      throw Exception('Failed to fetch revenue: $e');
    }
  }

  // === User & Company Operations ===

  @override
  Future<UserWithCompanies> getUserCompanies(String userId) async {
    try {
      final userCompaniesModel = await _dataSource.getUserCompanies(userId);
      return userCompaniesModel.toEntity();
    } catch (e) {
      throw Exception('Failed to fetch user companies: $e');
    }
  }

  // === Feature Operations ===

  @override
  Future<List<CategoryWithFeatures>> getCategoriesWithFeatures() async {
    try {
      final categoriesModels = await _dataSource.getCategoriesWithFeatures();
      final categories = categoriesModels.map((model) => model.toEntity()).toList();
      return categories;
    } catch (e) {
      throw Exception('Failed to fetch categories with features: $e');
    }
  }

  @override
  Future<List<TopFeature>> getQuickAccessFeatures({
    required String userId,
    required String companyId,
  }) async {
    try {
      final topFeaturesModels = await _dataSource.getQuickAccessFeatures(
        userId: userId,
        companyId: companyId,
      );

      final features = topFeaturesModels.map((model) => model.toEntity()).toList();
      return features;
    } catch (e) {
      throw Exception('Failed to fetch quick access features: $e');
    }
  }

  // === Feature Click Tracking ===

  @override
  Future<void> logFeatureClick({
    required String featureId,
    required String featureName,
    required String companyId,
    String? categoryId,
  }) async {
    try {
      await _dataSource.logFeatureClick(
        featureId: featureId,
        featureName: featureName,
        companyId: companyId,
        categoryId: categoryId,
      );
    } catch (e) {
      // Silently fail - don't block user navigation
    }
  }

  // === Alert Operations ===

  @override
  Future<HomepageAlert> getHomepageAlert({required String userId}) async {
    try {
      final alertModel = await _dataSource.getHomepageAlert(userId: userId);
      return alertModel.toEntity();
    } catch (e) {
      // Return default (no alert) on error
      return const HomepageAlert(isShow: false, isChecked: false, content: null);
    }
  }

  @override
  Future<bool> responseHomepageAlert({
    required String userId,
    required bool isChecked,
  }) async {
    try {
      return await _dataSource.responseHomepageAlert(
        userId: userId,
        isChecked: isChecked,
      );
    } catch (e) {
      return false;
    }
  }

  // === App Version Check ===

  @override
  Future<bool> checkAppVersion() async {
    return await _dataSource.checkAppVersion();
  }
}
