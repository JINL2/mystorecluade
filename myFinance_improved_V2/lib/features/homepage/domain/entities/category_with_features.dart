import 'package:equatable/equatable.dart';

import '../../../../core/domain/entities/feature.dart';

/// Category with its associated features
///
/// Represents a feature category and the features that belong to it.
/// Used for displaying feature grid on homepage.
class CategoryWithFeatures extends Equatable {
  const CategoryWithFeatures({
    required this.categoryId,
    required this.categoryName,
    required this.features,
  });

  final String categoryId;
  final String categoryName;
  final List<Feature> features;

  /// Get number of features in this category
  int get featureCount => features.length;

  /// Check if category has any features
  bool get hasFeatures => features.isNotEmpty;

  @override
  List<Object?> get props => [categoryId, categoryName, features];

  @override
  String toString() {
    return 'CategoryWithFeatures(id: $categoryId, name: $categoryName, '
        'features: ${features.length})';
  }

  // ============================================
  // Mock Factory (for skeleton loading)
  // ============================================

  static CategoryWithFeatures mock() => CategoryWithFeatures(
        categoryId: 'mock-category-id',
        categoryName: 'Mock Category',
        features: Feature.mockList(4),
      );

  static List<CategoryWithFeatures> mockList([int count = 3]) =>
      List.generate(count, (i) => CategoryWithFeatures(
            categoryId: 'mock-category-id-$i',
            categoryName: 'Category $i',
            features: Feature.mockList(4),
          ));
}
