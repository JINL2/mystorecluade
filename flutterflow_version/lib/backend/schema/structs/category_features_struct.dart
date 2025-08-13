// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CategoryFeaturesStruct extends BaseStruct {
  CategoryFeaturesStruct({
    String? categoryId,
    String? categoryName,
    List<FeaturesStruct>? features,
  })  : _categoryId = categoryId,
        _categoryName = categoryName,
        _features = features;

  // "category_id" field.
  String? _categoryId;
  String get categoryId => _categoryId ?? '';
  set categoryId(String? val) => _categoryId = val;

  bool hasCategoryId() => _categoryId != null;

  // "category_name" field.
  String? _categoryName;
  String get categoryName => _categoryName ?? '';
  set categoryName(String? val) => _categoryName = val;

  bool hasCategoryName() => _categoryName != null;

  // "features" field.
  List<FeaturesStruct>? _features;
  List<FeaturesStruct> get features => _features ?? const [];
  set features(List<FeaturesStruct>? val) => _features = val;

  void updateFeatures(Function(List<FeaturesStruct>) updateFn) {
    updateFn(_features ??= []);
  }

  bool hasFeatures() => _features != null;

  static CategoryFeaturesStruct fromMap(Map<String, dynamic> data) =>
      CategoryFeaturesStruct(
        categoryId: data['category_id'] as String?,
        categoryName: data['category_name'] as String?,
        features: getStructList(
          data['features'],
          FeaturesStruct.fromMap,
        ),
      );

  static CategoryFeaturesStruct? maybeFromMap(dynamic data) => data is Map
      ? CategoryFeaturesStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'category_id': _categoryId,
        'category_name': _categoryName,
        'features': _features?.map((e) => e.toMap()).toList(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'category_id': serializeParam(
          _categoryId,
          ParamType.String,
        ),
        'category_name': serializeParam(
          _categoryName,
          ParamType.String,
        ),
        'features': serializeParam(
          _features,
          ParamType.DataStruct,
          isList: true,
        ),
      }.withoutNulls;

  static CategoryFeaturesStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      CategoryFeaturesStruct(
        categoryId: deserializeParam(
          data['category_id'],
          ParamType.String,
          false,
        ),
        categoryName: deserializeParam(
          data['category_name'],
          ParamType.String,
          false,
        ),
        features: deserializeStructParam<FeaturesStruct>(
          data['features'],
          ParamType.DataStruct,
          true,
          structBuilder: FeaturesStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'CategoryFeaturesStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is CategoryFeaturesStruct &&
        categoryId == other.categoryId &&
        categoryName == other.categoryName &&
        listEquality.equals(features, other.features);
  }

  @override
  int get hashCode =>
      const ListEquality().hash([categoryId, categoryName, features]);
}

CategoryFeaturesStruct createCategoryFeaturesStruct({
  String? categoryId,
  String? categoryName,
}) =>
    CategoryFeaturesStruct(
      categoryId: categoryId,
      categoryName: categoryName,
    );
