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
    debugPrint('🔵 [Repository.getRevenue] Called with: companyId=$companyId, storeId=$storeId, period=${period.name}');

    try {
      final revenueModel = await _dataSource.getRevenue(
        companyId: companyId,
        storeId: storeId,
        period: period.name, // Convert enum to string
      );

      debugPrint('🔵 [Repository.getRevenue] Model fetched, converting to domain...');
      final revenue = revenueModel.toDomain();
      debugPrint('🔵 [Repository.getRevenue] Successfully converted to domain: amount=${revenue.amount}');
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
      debugPrint('🔵 [Repository.getCategoriesWithFeatures] Fetched ${categoriesModels.length} models, converting to domain...');

      final categories = categoriesModels.map((model) => model.toDomain()).toList();
      debugPrint('🔵 [Repository.getCategoriesWithFeatures] Successfully converted ${categories.length} categories');
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
    debugPrint('🔵 [Repository.getQuickAccessFeatures] Called with: userId=$userId, companyId=$companyId');

    try {
      final topFeaturesModels = await _dataSource.getQuickAccessFeatures(
        userId: userId,
        companyId: companyId,
      );

      debugPrint('🔵 [Repository.getQuickAccessFeatures] Fetched ${topFeaturesModels.length} models, converting to domain...');
      final features = topFeaturesModels.map((model) => model.toDomain()).toList();
      debugPrint('🔵 [Repository.getQuickAccessFeatures] Successfully converted ${features.length} features');
      return features;
    } catch (e, stack) {
      debugPrint('🔵 [Repository.getQuickAccessFeatures] ERROR: $e');
      debugPrint('🔵 [Repository.getQuickAccessFeatures] Stack: $stack');
      throw Exception('Failed to fetch quick access features: $e');
    }
  }
}
