// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inventory_dashboard.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$InventoryDashboard {
  /// 건강도 요약
  InventoryHealth get health => throw _privateConstructorUsedError;

  /// 임계값 정보
  ThresholdInfo get thresholds => throw _privateConstructorUsedError;

  /// Top 카테고리 (최대 5개)
  List<CategorySummary> get topCategories => throw _privateConstructorUsedError;

  /// 긴급 상품 목록 (최대 10개)
  List<InventoryProduct> get urgentProducts =>
      throw _privateConstructorUsedError;

  /// 비정상 상품 목록 (최대 10개)
  List<InventoryProduct> get abnormalProducts =>
      throw _privateConstructorUsedError;

  /// Create a copy of InventoryDashboard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InventoryDashboardCopyWith<InventoryDashboard> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InventoryDashboardCopyWith<$Res> {
  factory $InventoryDashboardCopyWith(
          InventoryDashboard value, $Res Function(InventoryDashboard) then) =
      _$InventoryDashboardCopyWithImpl<$Res, InventoryDashboard>;
  @useResult
  $Res call(
      {InventoryHealth health,
      ThresholdInfo thresholds,
      List<CategorySummary> topCategories,
      List<InventoryProduct> urgentProducts,
      List<InventoryProduct> abnormalProducts});

  $InventoryHealthCopyWith<$Res> get health;
  $ThresholdInfoCopyWith<$Res> get thresholds;
}

/// @nodoc
class _$InventoryDashboardCopyWithImpl<$Res, $Val extends InventoryDashboard>
    implements $InventoryDashboardCopyWith<$Res> {
  _$InventoryDashboardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InventoryDashboard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? health = null,
    Object? thresholds = null,
    Object? topCategories = null,
    Object? urgentProducts = null,
    Object? abnormalProducts = null,
  }) {
    return _then(_value.copyWith(
      health: null == health
          ? _value.health
          : health // ignore: cast_nullable_to_non_nullable
              as InventoryHealth,
      thresholds: null == thresholds
          ? _value.thresholds
          : thresholds // ignore: cast_nullable_to_non_nullable
              as ThresholdInfo,
      topCategories: null == topCategories
          ? _value.topCategories
          : topCategories // ignore: cast_nullable_to_non_nullable
              as List<CategorySummary>,
      urgentProducts: null == urgentProducts
          ? _value.urgentProducts
          : urgentProducts // ignore: cast_nullable_to_non_nullable
              as List<InventoryProduct>,
      abnormalProducts: null == abnormalProducts
          ? _value.abnormalProducts
          : abnormalProducts // ignore: cast_nullable_to_non_nullable
              as List<InventoryProduct>,
    ) as $Val);
  }

  /// Create a copy of InventoryDashboard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $InventoryHealthCopyWith<$Res> get health {
    return $InventoryHealthCopyWith<$Res>(_value.health, (value) {
      return _then(_value.copyWith(health: value) as $Val);
    });
  }

  /// Create a copy of InventoryDashboard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ThresholdInfoCopyWith<$Res> get thresholds {
    return $ThresholdInfoCopyWith<$Res>(_value.thresholds, (value) {
      return _then(_value.copyWith(thresholds: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$InventoryDashboardImplCopyWith<$Res>
    implements $InventoryDashboardCopyWith<$Res> {
  factory _$$InventoryDashboardImplCopyWith(_$InventoryDashboardImpl value,
          $Res Function(_$InventoryDashboardImpl) then) =
      __$$InventoryDashboardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {InventoryHealth health,
      ThresholdInfo thresholds,
      List<CategorySummary> topCategories,
      List<InventoryProduct> urgentProducts,
      List<InventoryProduct> abnormalProducts});

  @override
  $InventoryHealthCopyWith<$Res> get health;
  @override
  $ThresholdInfoCopyWith<$Res> get thresholds;
}

/// @nodoc
class __$$InventoryDashboardImplCopyWithImpl<$Res>
    extends _$InventoryDashboardCopyWithImpl<$Res, _$InventoryDashboardImpl>
    implements _$$InventoryDashboardImplCopyWith<$Res> {
  __$$InventoryDashboardImplCopyWithImpl(_$InventoryDashboardImpl _value,
      $Res Function(_$InventoryDashboardImpl) _then)
      : super(_value, _then);

  /// Create a copy of InventoryDashboard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? health = null,
    Object? thresholds = null,
    Object? topCategories = null,
    Object? urgentProducts = null,
    Object? abnormalProducts = null,
  }) {
    return _then(_$InventoryDashboardImpl(
      health: null == health
          ? _value.health
          : health // ignore: cast_nullable_to_non_nullable
              as InventoryHealth,
      thresholds: null == thresholds
          ? _value.thresholds
          : thresholds // ignore: cast_nullable_to_non_nullable
              as ThresholdInfo,
      topCategories: null == topCategories
          ? _value._topCategories
          : topCategories // ignore: cast_nullable_to_non_nullable
              as List<CategorySummary>,
      urgentProducts: null == urgentProducts
          ? _value._urgentProducts
          : urgentProducts // ignore: cast_nullable_to_non_nullable
              as List<InventoryProduct>,
      abnormalProducts: null == abnormalProducts
          ? _value._abnormalProducts
          : abnormalProducts // ignore: cast_nullable_to_non_nullable
              as List<InventoryProduct>,
    ));
  }
}

/// @nodoc

class _$InventoryDashboardImpl extends _InventoryDashboard {
  const _$InventoryDashboardImpl(
      {required this.health,
      required this.thresholds,
      required final List<CategorySummary> topCategories,
      required final List<InventoryProduct> urgentProducts,
      required final List<InventoryProduct> abnormalProducts})
      : _topCategories = topCategories,
        _urgentProducts = urgentProducts,
        _abnormalProducts = abnormalProducts,
        super._();

  /// 건강도 요약
  @override
  final InventoryHealth health;

  /// 임계값 정보
  @override
  final ThresholdInfo thresholds;

  /// Top 카테고리 (최대 5개)
  final List<CategorySummary> _topCategories;

  /// Top 카테고리 (최대 5개)
  @override
  List<CategorySummary> get topCategories {
    if (_topCategories is EqualUnmodifiableListView) return _topCategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topCategories);
  }

  /// 긴급 상품 목록 (최대 10개)
  final List<InventoryProduct> _urgentProducts;

  /// 긴급 상품 목록 (최대 10개)
  @override
  List<InventoryProduct> get urgentProducts {
    if (_urgentProducts is EqualUnmodifiableListView) return _urgentProducts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_urgentProducts);
  }

  /// 비정상 상품 목록 (최대 10개)
  final List<InventoryProduct> _abnormalProducts;

  /// 비정상 상품 목록 (최대 10개)
  @override
  List<InventoryProduct> get abnormalProducts {
    if (_abnormalProducts is EqualUnmodifiableListView)
      return _abnormalProducts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_abnormalProducts);
  }

  @override
  String toString() {
    return 'InventoryDashboard(health: $health, thresholds: $thresholds, topCategories: $topCategories, urgentProducts: $urgentProducts, abnormalProducts: $abnormalProducts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InventoryDashboardImpl &&
            (identical(other.health, health) || other.health == health) &&
            (identical(other.thresholds, thresholds) ||
                other.thresholds == thresholds) &&
            const DeepCollectionEquality()
                .equals(other._topCategories, _topCategories) &&
            const DeepCollectionEquality()
                .equals(other._urgentProducts, _urgentProducts) &&
            const DeepCollectionEquality()
                .equals(other._abnormalProducts, _abnormalProducts));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      health,
      thresholds,
      const DeepCollectionEquality().hash(_topCategories),
      const DeepCollectionEquality().hash(_urgentProducts),
      const DeepCollectionEquality().hash(_abnormalProducts));

  /// Create a copy of InventoryDashboard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InventoryDashboardImplCopyWith<_$InventoryDashboardImpl> get copyWith =>
      __$$InventoryDashboardImplCopyWithImpl<_$InventoryDashboardImpl>(
          this, _$identity);
}

abstract class _InventoryDashboard extends InventoryDashboard {
  const factory _InventoryDashboard(
          {required final InventoryHealth health,
          required final ThresholdInfo thresholds,
          required final List<CategorySummary> topCategories,
          required final List<InventoryProduct> urgentProducts,
          required final List<InventoryProduct> abnormalProducts}) =
      _$InventoryDashboardImpl;
  const _InventoryDashboard._() : super._();

  /// 건강도 요약
  @override
  InventoryHealth get health;

  /// 임계값 정보
  @override
  ThresholdInfo get thresholds;

  /// Top 카테고리 (최대 5개)
  @override
  List<CategorySummary> get topCategories;

  /// 긴급 상품 목록 (최대 10개)
  @override
  List<InventoryProduct> get urgentProducts;

  /// 비정상 상품 목록 (최대 10개)
  @override
  List<InventoryProduct> get abnormalProducts;

  /// Create a copy of InventoryDashboard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InventoryDashboardImplCopyWith<_$InventoryDashboardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
