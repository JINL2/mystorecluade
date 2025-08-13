// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class FeaturesStruct extends BaseStruct {
  FeaturesStruct({
    String? featureId,
    String? featureName,
    String? icon,

    /// route
    String? route,
  })  : _featureId = featureId,
        _featureName = featureName,
        _icon = icon,
        _route = route;

  // "feature_id" field.
  String? _featureId;
  String get featureId => _featureId ?? '';
  set featureId(String? val) => _featureId = val;

  bool hasFeatureId() => _featureId != null;

  // "feature_name" field.
  String? _featureName;
  String get featureName => _featureName ?? '';
  set featureName(String? val) => _featureName = val;

  bool hasFeatureName() => _featureName != null;

  // "icon" field.
  String? _icon;
  String get icon => _icon ?? '';
  set icon(String? val) => _icon = val;

  bool hasIcon() => _icon != null;

  // "route" field.
  String? _route;
  String get route => _route ?? '';
  set route(String? val) => _route = val;

  bool hasRoute() => _route != null;

  static FeaturesStruct fromMap(Map<String, dynamic> data) => FeaturesStruct(
        featureId: data['feature_id'] as String?,
        featureName: data['feature_name'] as String?,
        icon: data['icon'] as String?,
        route: data['route'] as String?,
      );

  static FeaturesStruct? maybeFromMap(dynamic data) =>
      data is Map ? FeaturesStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'feature_id': _featureId,
        'feature_name': _featureName,
        'icon': _icon,
        'route': _route,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'feature_id': serializeParam(
          _featureId,
          ParamType.String,
        ),
        'feature_name': serializeParam(
          _featureName,
          ParamType.String,
        ),
        'icon': serializeParam(
          _icon,
          ParamType.String,
        ),
        'route': serializeParam(
          _route,
          ParamType.String,
        ),
      }.withoutNulls;

  static FeaturesStruct fromSerializableMap(Map<String, dynamic> data) =>
      FeaturesStruct(
        featureId: deserializeParam(
          data['feature_id'],
          ParamType.String,
          false,
        ),
        featureName: deserializeParam(
          data['feature_name'],
          ParamType.String,
          false,
        ),
        icon: deserializeParam(
          data['icon'],
          ParamType.String,
          false,
        ),
        route: deserializeParam(
          data['route'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'FeaturesStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is FeaturesStruct &&
        featureId == other.featureId &&
        featureName == other.featureName &&
        icon == other.icon &&
        route == other.route;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([featureId, featureName, icon, route]);
}

FeaturesStruct createFeaturesStruct({
  String? featureId,
  String? featureName,
  String? icon,
  String? route,
}) =>
    FeaturesStruct(
      featureId: featureId,
      featureName: featureName,
      icon: icon,
      route: route,
    );
