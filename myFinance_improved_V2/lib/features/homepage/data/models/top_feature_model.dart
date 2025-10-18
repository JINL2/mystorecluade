import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/top_feature.dart';

part 'top_feature_model.freezed.dart';
part 'top_feature_model.g.dart';

/// Top Feature Model - handles JSON serialization and domain conversion
///
/// Consolidates DTO and Mapper responsibilities:
/// - JSON serialization (via freezed + json_serializable)
/// - Conversion to/from domain entities
/// - Maps Supabase RPC response to domain TopFeature entity
@freezed
class TopFeatureModel with _$TopFeatureModel {
  const TopFeatureModel._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory TopFeatureModel({
    required String featureId,
    String? featureName,
    String? categoryId,
    int? clickCount,
    DateTime? lastClicked,
    String? icon,
    String? route,
    String? iconKey,
  }) = _TopFeatureModel;

  /// Create from JSON (Supabase RPC response)
  factory TopFeatureModel.fromJson(Map<String, dynamic> json) =>
      _$TopFeatureModelFromJson(json);

  /// Convert Model to Domain Entity
  TopFeature toDomain() {
    return TopFeature(
      featureId: featureId,
      featureName: featureName ?? '',
      categoryId: categoryId,
      clickCount: clickCount ?? 0,
      lastClicked: lastClicked ?? DateTime.now(),
      icon: icon ?? '',
      route: route ?? '',
      iconKey: iconKey,
    );
  }

  /// Create Model from Domain Entity
  factory TopFeatureModel.fromDomain(TopFeature entity) {
    return TopFeatureModel(
      featureId: entity.featureId,
      featureName: entity.featureName,
      categoryId: entity.categoryId,
      clickCount: entity.clickCount,
      lastClicked: entity.lastClicked,
      icon: entity.icon,
      route: entity.route,
      iconKey: entity.iconKey,
    );
  }
}
