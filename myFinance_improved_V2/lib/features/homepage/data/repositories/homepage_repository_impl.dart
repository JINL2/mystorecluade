import 'package:flutter/foundation.dart';
import '../../domain/entities/category_with_features.dart';
import '../../domain/entities/revenue.dart';
import '../../domain/entities/top_feature.dart';
import '../../domain/entities/user_with_companies.dart';
import '../../domain/revenue_period.dart';
import '../../domain/repositories/homepage_repository.dart';
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

      final revenue = revenueModel.toDomain();
      return revenue;
    } catch (e, stack) {
      debugPrint('🔵 [Repository.getRevenue] ERROR: $e');
      debugPrint('🔵 [Repository.getRevenue] Stack: $stack');
      throw Exception('Failed to fetch revenue: $e');
    }
  }

  // === User & Company Operations ===

  @override
  Future<UserWithCompanies> getUserCompanies(String userId) async {
    try {
      final userCompaniesModel = await _dataSource.getUserCompanies(userId);
      return userCompaniesModel.toDomain();
    } catch (e) {
      throw Exception('Failed to fetch user companies: $e');
    }
  }

  // === Feature Operations ===

  @override
  Future<List<CategoryWithFeatures>> getCategoriesWithFeatures() async {
    debugPrint('🔵 [Repository.getCategoriesWithFeatures] Called');

    try {
      final categoriesModels = await _dataSource.getCategoriesWithFeatures();

      final categories = categoriesModels.map((model) => model.toDomain()).toList();
      return categories;
    } catch (e, stack) {
      debugPrint('🔵 [Repository.getCategoriesWithFeatures] ERROR: $e');
      debugPrint('🔵 [Repository.getCategoriesWithFeatures] Stack: $stack');
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

      final features = topFeaturesModels.map((model) => model.toDomain()).toList();
      return features;
    } catch (e, stack) {
      debugPrint('🔵 [Repository.getQuickAccessFeatures] ERROR: $e');
      debugPrint('🔵 [Repository.getQuickAccessFeatures] Stack: $stack');
      throw Exception('Failed to fetch quick access features: $e');
    }
  }
}
