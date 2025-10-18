import '../../../../core/domain/entities/feature.dart';

/// Category with its associated features
///
/// Represents a feature category and the features that belong to it.
/// Used for displaying feature grid on homepage.
class CategoryWithFeatures {
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
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryWithFeatures &&
          runtimeType == other.runtimeType &&
          categoryId == other.categoryId &&
          categoryName == other.categoryName;

  @override
  int get hashCode => categoryId.hashCode ^ categoryName.hashCode;

  @override
  String toString() {
    return 'CategoryWithFeatures(id: $categoryId, name: $categoryName, '
        'features: ${features.length})';
  }
}
