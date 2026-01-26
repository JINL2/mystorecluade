import 'package:freezed_annotation/freezed_annotation.dart';

part 'role_permission_info.freezed.dart';

/// Feature category for permission grouping
@freezed
class FeatureCategory with _$FeatureCategory {
  const FeatureCategory._();

  const factory FeatureCategory({
    required String categoryId,
    required String categoryName,
    String? description,
    required List<Feature> features,
  }) = _FeatureCategory;

  // Business logic
  int get featureCount => features.length;
  bool get hasFeatures => features.isNotEmpty;
}

/// Individual feature/permission
@freezed
class Feature with _$Feature {
  const Feature._();

  const factory Feature({
    required String featureId,
    required String featureName,
    String? description,
  }) = _Feature;
}

/// RolePermissionInfo domain entity
/// Contains current permissions and available feature categories
@freezed
class RolePermissionInfo with _$RolePermissionInfo {
  const RolePermissionInfo._();

  const factory RolePermissionInfo({
    required Set<String> currentPermissions,
    required List<FeatureCategory> categories,
  }) = _RolePermissionInfo;

  // Business logic methods
  bool hasPermission(String featureId) => currentPermissions.contains(featureId);

  int get totalFeatureCount =>
      categories.fold(0, (sum, cat) => sum + cat.featureCount);

  int get grantedPermissionCount => currentPermissions.length;

  double get permissionCoverage =>
      totalFeatureCount > 0 ? grantedPermissionCount / totalFeatureCount : 0;
}
