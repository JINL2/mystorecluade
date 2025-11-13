import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/domain/entities/feature.dart';
import '../../domain/entities/category_with_features.dart';

part 'category_features_model.freezed.dart';
part 'category_features_model.g.dart';

/// Category Features Model - handles JSON serialization and domain conversion
///
/// Consolidates DTO and Mapper responsibilities:
/// - JSON serialization (via freezed + json_serializable)
/// - Conversion to/from domain entities
/// - Maps Supabase RPC response to domain CategoryWithFeatures entity
@freezed
class CategoryFeaturesModel with _$CategoryFeaturesModel {
  const CategoryFeaturesModel._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory CategoryFeaturesModel({
    required String categoryId,
    required String categoryName,
    @Default([]) List<FeatureItemModel> features,
  }) = _CategoryFeaturesModel;

  /// Create from JSON (Supabase RPC response)
  factory CategoryFeaturesModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryFeaturesModelFromJson(json);

  /// Convert Model to Domain Entity
  CategoryWithFeatures toEntity() {
    return CategoryWithFeatures(
      categoryId: categoryId,
      categoryName: categoryName,
      features: features
          .map((featureModel) => Feature(
                featureId: featureModel.featureId,
                featureName: featureModel.featureName,
                featureRoute: featureModel.route ?? '',
                featureIcon: featureModel.icon ?? '',
                iconKey: featureModel.iconKey,
                isShowMain: featureModel.isShowMain,
              ),)
          .toList(),
    );
  }

  /// Create Model from Domain Entity
  factory CategoryFeaturesModel.fromDomain(CategoryWithFeatures entity) {
    return CategoryFeaturesModel(
      categoryId: entity.categoryId,
      categoryName: entity.categoryName,
      features: entity.features
          .map((feature) => FeatureItemModel(
                featureId: feature.featureId,
                featureName: feature.featureName,
                route: feature.featureRoute,
                icon: feature.featureIcon,
                iconKey: feature.iconKey,
                isShowMain: feature.isShowMain,
              ),)
          .toList(),
    );
  }
}

/// Feature Item Model - nested model for feature details
@freezed
class FeatureItemModel with _$FeatureItemModel {
  const FeatureItemModel._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory FeatureItemModel({
    required String featureId,
    required String featureName,
    String? route,
    String? icon,
    String? iconKey,
    @Default(true) bool isShowMain,
  }) = _FeatureItemModel;

  /// Create from JSON
  factory FeatureItemModel.fromJson(Map<String, dynamic> json) =>
      _$FeatureItemModelFromJson(json);
}
