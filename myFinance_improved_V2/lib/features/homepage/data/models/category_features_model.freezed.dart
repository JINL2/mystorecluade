// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_features_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CategoryFeaturesModel _$CategoryFeaturesModelFromJson(
    Map<String, dynamic> json) {
  return _CategoryFeaturesModel.fromJson(json);
}

/// @nodoc
mixin _$CategoryFeaturesModel {
  String get categoryId => throw _privateConstructorUsedError;
  String get categoryName => throw _privateConstructorUsedError;
  List<FeatureItemModel> get features => throw _privateConstructorUsedError;

  /// Serializes this CategoryFeaturesModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CategoryFeaturesModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategoryFeaturesModelCopyWith<CategoryFeaturesModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryFeaturesModelCopyWith<$Res> {
  factory $CategoryFeaturesModelCopyWith(CategoryFeaturesModel value,
          $Res Function(CategoryFeaturesModel) then) =
      _$CategoryFeaturesModelCopyWithImpl<$Res, CategoryFeaturesModel>;
  @useResult
  $Res call(
      {String categoryId,
      String categoryName,
      List<FeatureItemModel> features});
}

/// @nodoc
class _$CategoryFeaturesModelCopyWithImpl<$Res,
        $Val extends CategoryFeaturesModel>
    implements $CategoryFeaturesModelCopyWith<$Res> {
  _$CategoryFeaturesModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CategoryFeaturesModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryId = null,
    Object? categoryName = null,
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
      features: null == features
          ? _value.features
          : features // ignore: cast_nullable_to_non_nullable
              as List<FeatureItemModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CategoryFeaturesModelImplCopyWith<$Res>
    implements $CategoryFeaturesModelCopyWith<$Res> {
  factory _$$CategoryFeaturesModelImplCopyWith(
          _$CategoryFeaturesModelImpl value,
          $Res Function(_$CategoryFeaturesModelImpl) then) =
      __$$CategoryFeaturesModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String categoryId,
      String categoryName,
      List<FeatureItemModel> features});
}

/// @nodoc
class __$$CategoryFeaturesModelImplCopyWithImpl<$Res>
    extends _$CategoryFeaturesModelCopyWithImpl<$Res,
        _$CategoryFeaturesModelImpl>
    implements _$$CategoryFeaturesModelImplCopyWith<$Res> {
  __$$CategoryFeaturesModelImplCopyWithImpl(_$CategoryFeaturesModelImpl _value,
      $Res Function(_$CategoryFeaturesModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of CategoryFeaturesModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryId = null,
    Object? categoryName = null,
    Object? features = null,
  }) {
    return _then(_$CategoryFeaturesModelImpl(
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      categoryName: null == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String,
      features: null == features
          ? _value._features
          : features // ignore: cast_nullable_to_non_nullable
              as List<FeatureItemModel>,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$CategoryFeaturesModelImpl extends _CategoryFeaturesModel {
  const _$CategoryFeaturesModelImpl(
      {required this.categoryId,
      required this.categoryName,
      final List<FeatureItemModel> features = const []})
      : _features = features,
        super._();

  factory _$CategoryFeaturesModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategoryFeaturesModelImplFromJson(json);

  @override
  final String categoryId;
  @override
  final String categoryName;
  final List<FeatureItemModel> _features;
  @override
  @JsonKey()
  List<FeatureItemModel> get features {
    if (_features is EqualUnmodifiableListView) return _features;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_features);
  }

  @override
  String toString() {
    return 'CategoryFeaturesModel(categoryId: $categoryId, categoryName: $categoryName, features: $features)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryFeaturesModelImpl &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            const DeepCollectionEquality().equals(other._features, _features));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, categoryId, categoryName,
      const DeepCollectionEquality().hash(_features));

  /// Create a copy of CategoryFeaturesModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryFeaturesModelImplCopyWith<_$CategoryFeaturesModelImpl>
      get copyWith => __$$CategoryFeaturesModelImplCopyWithImpl<
          _$CategoryFeaturesModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CategoryFeaturesModelImplToJson(
      this,
    );
  }
}

abstract class _CategoryFeaturesModel extends CategoryFeaturesModel {
  const factory _CategoryFeaturesModel(
      {required final String categoryId,
      required final String categoryName,
      final List<FeatureItemModel> features}) = _$CategoryFeaturesModelImpl;
  const _CategoryFeaturesModel._() : super._();

  factory _CategoryFeaturesModel.fromJson(Map<String, dynamic> json) =
      _$CategoryFeaturesModelImpl.fromJson;

  @override
  String get categoryId;
  @override
  String get categoryName;
  @override
  List<FeatureItemModel> get features;

  /// Create a copy of CategoryFeaturesModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoryFeaturesModelImplCopyWith<_$CategoryFeaturesModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

FeatureItemModel _$FeatureItemModelFromJson(Map<String, dynamic> json) {
  return _FeatureItemModel.fromJson(json);
}

/// @nodoc
mixin _$FeatureItemModel {
  String get featureId => throw _privateConstructorUsedError;
  String get featureName => throw _privateConstructorUsedError;
  String? get featureDescription => throw _privateConstructorUsedError;
  String? get route => throw _privateConstructorUsedError;
  String? get icon => throw _privateConstructorUsedError;
  String? get iconKey => throw _privateConstructorUsedError;
  bool get isShowMain => throw _privateConstructorUsedError;

  /// Serializes this FeatureItemModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FeatureItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FeatureItemModelCopyWith<FeatureItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeatureItemModelCopyWith<$Res> {
  factory $FeatureItemModelCopyWith(
          FeatureItemModel value, $Res Function(FeatureItemModel) then) =
      _$FeatureItemModelCopyWithImpl<$Res, FeatureItemModel>;
  @useResult
  $Res call(
      {String featureId,
      String featureName,
      String? featureDescription,
      String? route,
      String? icon,
      String? iconKey,
      bool isShowMain});
}

/// @nodoc
class _$FeatureItemModelCopyWithImpl<$Res, $Val extends FeatureItemModel>
    implements $FeatureItemModelCopyWith<$Res> {
  _$FeatureItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FeatureItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? featureId = null,
    Object? featureName = null,
    Object? featureDescription = freezed,
    Object? route = freezed,
    Object? icon = freezed,
    Object? iconKey = freezed,
    Object? isShowMain = null,
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
      featureDescription: freezed == featureDescription
          ? _value.featureDescription
          : featureDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      route: freezed == route
          ? _value.route
          : route // ignore: cast_nullable_to_non_nullable
              as String?,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      iconKey: freezed == iconKey
          ? _value.iconKey
          : iconKey // ignore: cast_nullable_to_non_nullable
              as String?,
      isShowMain: null == isShowMain
          ? _value.isShowMain
          : isShowMain // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FeatureItemModelImplCopyWith<$Res>
    implements $FeatureItemModelCopyWith<$Res> {
  factory _$$FeatureItemModelImplCopyWith(_$FeatureItemModelImpl value,
          $Res Function(_$FeatureItemModelImpl) then) =
      __$$FeatureItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String featureId,
      String featureName,
      String? featureDescription,
      String? route,
      String? icon,
      String? iconKey,
      bool isShowMain});
}

/// @nodoc
class __$$FeatureItemModelImplCopyWithImpl<$Res>
    extends _$FeatureItemModelCopyWithImpl<$Res, _$FeatureItemModelImpl>
    implements _$$FeatureItemModelImplCopyWith<$Res> {
  __$$FeatureItemModelImplCopyWithImpl(_$FeatureItemModelImpl _value,
      $Res Function(_$FeatureItemModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of FeatureItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? featureId = null,
    Object? featureName = null,
    Object? featureDescription = freezed,
    Object? route = freezed,
    Object? icon = freezed,
    Object? iconKey = freezed,
    Object? isShowMain = null,
  }) {
    return _then(_$FeatureItemModelImpl(
      featureId: null == featureId
          ? _value.featureId
          : featureId // ignore: cast_nullable_to_non_nullable
              as String,
      featureName: null == featureName
          ? _value.featureName
          : featureName // ignore: cast_nullable_to_non_nullable
              as String,
      featureDescription: freezed == featureDescription
          ? _value.featureDescription
          : featureDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      route: freezed == route
          ? _value.route
          : route // ignore: cast_nullable_to_non_nullable
              as String?,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      iconKey: freezed == iconKey
          ? _value.iconKey
          : iconKey // ignore: cast_nullable_to_non_nullable
              as String?,
      isShowMain: null == isShowMain
          ? _value.isShowMain
          : isShowMain // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$FeatureItemModelImpl extends _FeatureItemModel {
  const _$FeatureItemModelImpl(
      {required this.featureId,
      required this.featureName,
      this.featureDescription,
      this.route,
      this.icon,
      this.iconKey,
      this.isShowMain = true})
      : super._();

  factory _$FeatureItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FeatureItemModelImplFromJson(json);

  @override
  final String featureId;
  @override
  final String featureName;
  @override
  final String? featureDescription;
  @override
  final String? route;
  @override
  final String? icon;
  @override
  final String? iconKey;
  @override
  @JsonKey()
  final bool isShowMain;

  @override
  String toString() {
    return 'FeatureItemModel(featureId: $featureId, featureName: $featureName, featureDescription: $featureDescription, route: $route, icon: $icon, iconKey: $iconKey, isShowMain: $isShowMain)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeatureItemModelImpl &&
            (identical(other.featureId, featureId) ||
                other.featureId == featureId) &&
            (identical(other.featureName, featureName) ||
                other.featureName == featureName) &&
            (identical(other.featureDescription, featureDescription) ||
                other.featureDescription == featureDescription) &&
            (identical(other.route, route) || other.route == route) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.iconKey, iconKey) || other.iconKey == iconKey) &&
            (identical(other.isShowMain, isShowMain) ||
                other.isShowMain == isShowMain));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, featureId, featureName,
      featureDescription, route, icon, iconKey, isShowMain);

  /// Create a copy of FeatureItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FeatureItemModelImplCopyWith<_$FeatureItemModelImpl> get copyWith =>
      __$$FeatureItemModelImplCopyWithImpl<_$FeatureItemModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FeatureItemModelImplToJson(
      this,
    );
  }
}

abstract class _FeatureItemModel extends FeatureItemModel {
  const factory _FeatureItemModel(
      {required final String featureId,
      required final String featureName,
      final String? featureDescription,
      final String? route,
      final String? icon,
      final String? iconKey,
      final bool isShowMain}) = _$FeatureItemModelImpl;
  const _FeatureItemModel._() : super._();

  factory _FeatureItemModel.fromJson(Map<String, dynamic> json) =
      _$FeatureItemModelImpl.fromJson;

  @override
  String get featureId;
  @override
  String get featureName;
  @override
  String? get featureDescription;
  @override
  String? get route;
  @override
  String? get icon;
  @override
  String? get iconKey;
  @override
  bool get isShowMain;

  /// Create a copy of FeatureItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FeatureItemModelImplCopyWith<_$FeatureItemModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
