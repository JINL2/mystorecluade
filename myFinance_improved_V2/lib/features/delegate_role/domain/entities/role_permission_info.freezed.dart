// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'role_permission_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$FeatureCategory {
  String get categoryId => throw _privateConstructorUsedError;
  String get categoryName => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  List<Feature> get features => throw _privateConstructorUsedError;

  /// Create a copy of FeatureCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FeatureCategoryCopyWith<FeatureCategory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeatureCategoryCopyWith<$Res> {
  factory $FeatureCategoryCopyWith(
          FeatureCategory value, $Res Function(FeatureCategory) then) =
      _$FeatureCategoryCopyWithImpl<$Res, FeatureCategory>;
  @useResult
  $Res call(
      {String categoryId,
      String categoryName,
      String? description,
      List<Feature> features});
}

/// @nodoc
class _$FeatureCategoryCopyWithImpl<$Res, $Val extends FeatureCategory>
    implements $FeatureCategoryCopyWith<$Res> {
  _$FeatureCategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FeatureCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryId = null,
    Object? categoryName = null,
    Object? description = freezed,
    Object? features = null,
  }) {
    return _then(_value.copyWith(
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      categoryName: null == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      features: null == features
          ? _value.features
          : features // ignore: cast_nullable_to_non_nullable
              as List<Feature>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FeatureCategoryImplCopyWith<$Res>
    implements $FeatureCategoryCopyWith<$Res> {
  factory _$$FeatureCategoryImplCopyWith(_$FeatureCategoryImpl value,
          $Res Function(_$FeatureCategoryImpl) then) =
      __$$FeatureCategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String categoryId,
      String categoryName,
      String? description,
      List<Feature> features});
}

/// @nodoc
class __$$FeatureCategoryImplCopyWithImpl<$Res>
    extends _$FeatureCategoryCopyWithImpl<$Res, _$FeatureCategoryImpl>
    implements _$$FeatureCategoryImplCopyWith<$Res> {
  __$$FeatureCategoryImplCopyWithImpl(
      _$FeatureCategoryImpl _value, $Res Function(_$FeatureCategoryImpl) _then)
      : super(_value, _then);

  /// Create a copy of FeatureCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryId = null,
    Object? categoryName = null,
    Object? description = freezed,
    Object? features = null,
  }) {
    return _then(_$FeatureCategoryImpl(
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      categoryName: null == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      features: null == features
          ? _value._features
          : features // ignore: cast_nullable_to_non_nullable
              as List<Feature>,
    ));
  }
}

/// @nodoc

class _$FeatureCategoryImpl extends _FeatureCategory {
  const _$FeatureCategoryImpl(
      {required this.categoryId,
      required this.categoryName,
      this.description,
      required final List<Feature> features})
      : _features = features,
        super._();

  @override
  final String categoryId;
  @override
  final String categoryName;
  @override
  final String? description;
  final List<Feature> _features;
  @override
  List<Feature> get features {
    if (_features is EqualUnmodifiableListView) return _features;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_features);
  }

  @override
  String toString() {
    return 'FeatureCategory(categoryId: $categoryId, categoryName: $categoryName, description: $description, features: $features)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeatureCategoryImpl &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._features, _features));
  }

  @override
  int get hashCode => Object.hash(runtimeType, categoryId, categoryName,
      description, const DeepCollectionEquality().hash(_features));

  /// Create a copy of FeatureCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FeatureCategoryImplCopyWith<_$FeatureCategoryImpl> get copyWith =>
      __$$FeatureCategoryImplCopyWithImpl<_$FeatureCategoryImpl>(
          this, _$identity);
}

abstract class _FeatureCategory extends FeatureCategory {
  const factory _FeatureCategory(
      {required final String categoryId,
      required final String categoryName,
      final String? description,
      required final List<Feature> features}) = _$FeatureCategoryImpl;
  const _FeatureCategory._() : super._();

  @override
  String get categoryId;
  @override
  String get categoryName;
  @override
  String? get description;
  @override
  List<Feature> get features;

  /// Create a copy of FeatureCategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FeatureCategoryImplCopyWith<_$FeatureCategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Feature {
  String get featureId => throw _privateConstructorUsedError;
  String get featureName => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  /// Create a copy of Feature
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FeatureCopyWith<Feature> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeatureCopyWith<$Res> {
  factory $FeatureCopyWith(Feature value, $Res Function(Feature) then) =
      _$FeatureCopyWithImpl<$Res, Feature>;
  @useResult
  $Res call({String featureId, String featureName, String? description});
}

/// @nodoc
class _$FeatureCopyWithImpl<$Res, $Val extends Feature>
    implements $FeatureCopyWith<$Res> {
  _$FeatureCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Feature
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? featureId = null,
    Object? featureName = null,
    Object? description = freezed,
  }) {
    return _then(_value.copyWith(
      featureId: null == featureId
          ? _value.featureId
          : featureId // ignore: cast_nullable_to_non_nullable
              as String,
      featureName: null == featureName
          ? _value.featureName
          : featureName // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FeatureImplCopyWith<$Res> implements $FeatureCopyWith<$Res> {
  factory _$$FeatureImplCopyWith(
          _$FeatureImpl value, $Res Function(_$FeatureImpl) then) =
      __$$FeatureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String featureId, String featureName, String? description});
}

/// @nodoc
class __$$FeatureImplCopyWithImpl<$Res>
    extends _$FeatureCopyWithImpl<$Res, _$FeatureImpl>
    implements _$$FeatureImplCopyWith<$Res> {
  __$$FeatureImplCopyWithImpl(
      _$FeatureImpl _value, $Res Function(_$FeatureImpl) _then)
      : super(_value, _then);

  /// Create a copy of Feature
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? featureId = null,
    Object? featureName = null,
    Object? description = freezed,
  }) {
    return _then(_$FeatureImpl(
      featureId: null == featureId
          ? _value.featureId
          : featureId // ignore: cast_nullable_to_non_nullable
              as String,
      featureName: null == featureName
          ? _value.featureName
          : featureName // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$FeatureImpl extends _Feature {
  const _$FeatureImpl(
      {required this.featureId, required this.featureName, this.description})
      : super._();

  @override
  final String featureId;
  @override
  final String featureName;
  @override
  final String? description;

  @override
  String toString() {
    return 'Feature(featureId: $featureId, featureName: $featureName, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeatureImpl &&
            (identical(other.featureId, featureId) ||
                other.featureId == featureId) &&
            (identical(other.featureName, featureName) ||
                other.featureName == featureName) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, featureId, featureName, description);

  /// Create a copy of Feature
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FeatureImplCopyWith<_$FeatureImpl> get copyWith =>
      __$$FeatureImplCopyWithImpl<_$FeatureImpl>(this, _$identity);
}

abstract class _Feature extends Feature {
  const factory _Feature(
      {required final String featureId,
      required final String featureName,
      final String? description}) = _$FeatureImpl;
  const _Feature._() : super._();

  @override
  String get featureId;
  @override
  String get featureName;
  @override
  String? get description;

  /// Create a copy of Feature
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FeatureImplCopyWith<_$FeatureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$RolePermissionInfo {
  Set<String> get currentPermissions => throw _privateConstructorUsedError;
  List<FeatureCategory> get categories => throw _privateConstructorUsedError;

  /// Create a copy of RolePermissionInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RolePermissionInfoCopyWith<RolePermissionInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RolePermissionInfoCopyWith<$Res> {
  factory $RolePermissionInfoCopyWith(
          RolePermissionInfo value, $Res Function(RolePermissionInfo) then) =
      _$RolePermissionInfoCopyWithImpl<$Res, RolePermissionInfo>;
  @useResult
  $Res call({Set<String> currentPermissions, List<FeatureCategory> categories});
}

/// @nodoc
class _$RolePermissionInfoCopyWithImpl<$Res, $Val extends RolePermissionInfo>
    implements $RolePermissionInfoCopyWith<$Res> {
  _$RolePermissionInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RolePermissionInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentPermissions = null,
    Object? categories = null,
  }) {
    return _then(_value.copyWith(
      currentPermissions: null == currentPermissions
          ? _value.currentPermissions
          : currentPermissions // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      categories: null == categories
          ? _value.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<FeatureCategory>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RolePermissionInfoImplCopyWith<$Res>
    implements $RolePermissionInfoCopyWith<$Res> {
  factory _$$RolePermissionInfoImplCopyWith(_$RolePermissionInfoImpl value,
          $Res Function(_$RolePermissionInfoImpl) then) =
      __$$RolePermissionInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Set<String> currentPermissions, List<FeatureCategory> categories});
}

/// @nodoc
class __$$RolePermissionInfoImplCopyWithImpl<$Res>
    extends _$RolePermissionInfoCopyWithImpl<$Res, _$RolePermissionInfoImpl>
    implements _$$RolePermissionInfoImplCopyWith<$Res> {
  __$$RolePermissionInfoImplCopyWithImpl(_$RolePermissionInfoImpl _value,
      $Res Function(_$RolePermissionInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of RolePermissionInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentPermissions = null,
    Object? categories = null,
  }) {
    return _then(_$RolePermissionInfoImpl(
      currentPermissions: null == currentPermissions
          ? _value._currentPermissions
          : currentPermissions // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      categories: null == categories
          ? _value._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<FeatureCategory>,
    ));
  }
}

/// @nodoc

class _$RolePermissionInfoImpl extends _RolePermissionInfo {
  const _$RolePermissionInfoImpl(
      {required final Set<String> currentPermissions,
      required final List<FeatureCategory> categories})
      : _currentPermissions = currentPermissions,
        _categories = categories,
        super._();

  final Set<String> _currentPermissions;
  @override
  Set<String> get currentPermissions {
    if (_currentPermissions is EqualUnmodifiableSetView)
      return _currentPermissions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_currentPermissions);
  }

  final List<FeatureCategory> _categories;
  @override
  List<FeatureCategory> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  @override
  String toString() {
    return 'RolePermissionInfo(currentPermissions: $currentPermissions, categories: $categories)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RolePermissionInfoImpl &&
            const DeepCollectionEquality()
                .equals(other._currentPermissions, _currentPermissions) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_currentPermissions),
      const DeepCollectionEquality().hash(_categories));

  /// Create a copy of RolePermissionInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RolePermissionInfoImplCopyWith<_$RolePermissionInfoImpl> get copyWith =>
      __$$RolePermissionInfoImplCopyWithImpl<_$RolePermissionInfoImpl>(
          this, _$identity);
}

abstract class _RolePermissionInfo extends RolePermissionInfo {
  const factory _RolePermissionInfo(
          {required final Set<String> currentPermissions,
          required final List<FeatureCategory> categories}) =
      _$RolePermissionInfoImpl;
  const _RolePermissionInfo._() : super._();

  @override
  Set<String> get currentPermissions;
  @override
  List<FeatureCategory> get categories;

  /// Create a copy of RolePermissionInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RolePermissionInfoImplCopyWith<_$RolePermissionInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
