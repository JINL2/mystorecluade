// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TopBrand {
  String get brandId => throw _privateConstructorUsedError;
  String get brandName => throw _privateConstructorUsedError;
  num get revenue => throw _privateConstructorUsedError;
  num get marginRatePct => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;

  /// Create a copy of TopBrand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TopBrandCopyWith<TopBrand> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TopBrandCopyWith<$Res> {
  factory $TopBrandCopyWith(TopBrand value, $Res Function(TopBrand) then) =
      _$TopBrandCopyWithImpl<$Res, TopBrand>;
  @useResult
  $Res call(
      {String brandId,
      String brandName,
      num revenue,
      num marginRatePct,
      int quantity});
}

/// @nodoc
class _$TopBrandCopyWithImpl<$Res, $Val extends TopBrand>
    implements $TopBrandCopyWith<$Res> {
  _$TopBrandCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TopBrand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? brandId = null,
    Object? brandName = null,
    Object? revenue = null,
    Object? marginRatePct = null,
    Object? quantity = null,
  }) {
    return _then(_value.copyWith(
      brandId: null == brandId
          ? _value.brandId
          : brandId // ignore: cast_nullable_to_non_nullable
              as String,
      brandName: null == brandName
          ? _value.brandName
          : brandName // ignore: cast_nullable_to_non_nullable
              as String,
      revenue: null == revenue
          ? _value.revenue
          : revenue // ignore: cast_nullable_to_non_nullable
              as num,
      marginRatePct: null == marginRatePct
          ? _value.marginRatePct
          : marginRatePct // ignore: cast_nullable_to_non_nullable
              as num,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TopBrandImplCopyWith<$Res>
    implements $TopBrandCopyWith<$Res> {
  factory _$$TopBrandImplCopyWith(
          _$TopBrandImpl value, $Res Function(_$TopBrandImpl) then) =
      __$$TopBrandImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String brandId,
      String brandName,
      num revenue,
      num marginRatePct,
      int quantity});
}

/// @nodoc
class __$$TopBrandImplCopyWithImpl<$Res>
    extends _$TopBrandCopyWithImpl<$Res, _$TopBrandImpl>
    implements _$$TopBrandImplCopyWith<$Res> {
  __$$TopBrandImplCopyWithImpl(
      _$TopBrandImpl _value, $Res Function(_$TopBrandImpl) _then)
      : super(_value, _then);

  /// Create a copy of TopBrand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? brandId = null,
    Object? brandName = null,
    Object? revenue = null,
    Object? marginRatePct = null,
    Object? quantity = null,
  }) {
    return _then(_$TopBrandImpl(
      brandId: null == brandId
          ? _value.brandId
          : brandId // ignore: cast_nullable_to_non_nullable
              as String,
      brandName: null == brandName
          ? _value.brandName
          : brandName // ignore: cast_nullable_to_non_nullable
              as String,
      revenue: null == revenue
          ? _value.revenue
          : revenue // ignore: cast_nullable_to_non_nullable
              as num,
      marginRatePct: null == marginRatePct
          ? _value.marginRatePct
          : marginRatePct // ignore: cast_nullable_to_non_nullable
              as num,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$TopBrandImpl implements _TopBrand {
  const _$TopBrandImpl(
      {required this.brandId,
      required this.brandName,
      required this.revenue,
      required this.marginRatePct,
      required this.quantity});

  @override
  final String brandId;
  @override
  final String brandName;
  @override
  final num revenue;
  @override
  final num marginRatePct;
  @override
  final int quantity;

  @override
  String toString() {
    return 'TopBrand(brandId: $brandId, brandName: $brandName, revenue: $revenue, marginRatePct: $marginRatePct, quantity: $quantity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TopBrandImpl &&
            (identical(other.brandId, brandId) || other.brandId == brandId) &&
            (identical(other.brandName, brandName) ||
                other.brandName == brandName) &&
            (identical(other.revenue, revenue) || other.revenue == revenue) &&
            (identical(other.marginRatePct, marginRatePct) ||
                other.marginRatePct == marginRatePct) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, brandId, brandName, revenue, marginRatePct, quantity);

  /// Create a copy of TopBrand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TopBrandImplCopyWith<_$TopBrandImpl> get copyWith =>
      __$$TopBrandImplCopyWithImpl<_$TopBrandImpl>(this, _$identity);
}

abstract class _TopBrand implements TopBrand {
  const factory _TopBrand(
      {required final String brandId,
      required final String brandName,
      required final num revenue,
      required final num marginRatePct,
      required final int quantity}) = _$TopBrandImpl;

  @override
  String get brandId;
  @override
  String get brandName;
  @override
  num get revenue;
  @override
  num get marginRatePct;
  @override
  int get quantity;

  /// Create a copy of TopBrand
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TopBrandImplCopyWith<_$TopBrandImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ProblemProduct {
  String get productId => throw _privateConstructorUsedError;
  String get productName => throw _privateConstructorUsedError;
  int get currentStock => throw _privateConstructorUsedError;
  num get reorderPoint => throw _privateConstructorUsedError;
  num? get marginChange => throw _privateConstructorUsedError; // 전월 대비 마진 변화
  String get issueType => throw _privateConstructorUsedError;

  /// Create a copy of ProblemProduct
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProblemProductCopyWith<ProblemProduct> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProblemProductCopyWith<$Res> {
  factory $ProblemProductCopyWith(
          ProblemProduct value, $Res Function(ProblemProduct) then) =
      _$ProblemProductCopyWithImpl<$Res, ProblemProduct>;
  @useResult
  $Res call(
      {String productId,
      String productName,
      int currentStock,
      num reorderPoint,
      num? marginChange,
      String issueType});
}

/// @nodoc
class _$ProblemProductCopyWithImpl<$Res, $Val extends ProblemProduct>
    implements $ProblemProductCopyWith<$Res> {
  _$ProblemProductCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProblemProduct
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? productName = null,
    Object? currentStock = null,
    Object? reorderPoint = null,
    Object? marginChange = freezed,
    Object? issueType = null,
  }) {
    return _then(_value.copyWith(
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      currentStock: null == currentStock
          ? _value.currentStock
          : currentStock // ignore: cast_nullable_to_non_nullable
              as int,
      reorderPoint: null == reorderPoint
          ? _value.reorderPoint
          : reorderPoint // ignore: cast_nullable_to_non_nullable
              as num,
      marginChange: freezed == marginChange
          ? _value.marginChange
          : marginChange // ignore: cast_nullable_to_non_nullable
              as num?,
      issueType: null == issueType
          ? _value.issueType
          : issueType // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProblemProductImplCopyWith<$Res>
    implements $ProblemProductCopyWith<$Res> {
  factory _$$ProblemProductImplCopyWith(_$ProblemProductImpl value,
          $Res Function(_$ProblemProductImpl) then) =
      __$$ProblemProductImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String productId,
      String productName,
      int currentStock,
      num reorderPoint,
      num? marginChange,
      String issueType});
}

/// @nodoc
class __$$ProblemProductImplCopyWithImpl<$Res>
    extends _$ProblemProductCopyWithImpl<$Res, _$ProblemProductImpl>
    implements _$$ProblemProductImplCopyWith<$Res> {
  __$$ProblemProductImplCopyWithImpl(
      _$ProblemProductImpl _value, $Res Function(_$ProblemProductImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProblemProduct
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? productName = null,
    Object? currentStock = null,
    Object? reorderPoint = null,
    Object? marginChange = freezed,
    Object? issueType = null,
  }) {
    return _then(_$ProblemProductImpl(
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      currentStock: null == currentStock
          ? _value.currentStock
          : currentStock // ignore: cast_nullable_to_non_nullable
              as int,
      reorderPoint: null == reorderPoint
          ? _value.reorderPoint
          : reorderPoint // ignore: cast_nullable_to_non_nullable
              as num,
      marginChange: freezed == marginChange
          ? _value.marginChange
          : marginChange // ignore: cast_nullable_to_non_nullable
              as num?,
      issueType: null == issueType
          ? _value.issueType
          : issueType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ProblemProductImpl extends _ProblemProduct {
  const _$ProblemProductImpl(
      {required this.productId,
      required this.productName,
      required this.currentStock,
      required this.reorderPoint,
      required this.marginChange,
      required this.issueType})
      : super._();

  @override
  final String productId;
  @override
  final String productName;
  @override
  final int currentStock;
  @override
  final num reorderPoint;
  @override
  final num? marginChange;
// 전월 대비 마진 변화
  @override
  final String issueType;

  @override
  String toString() {
    return 'ProblemProduct(productId: $productId, productName: $productName, currentStock: $currentStock, reorderPoint: $reorderPoint, marginChange: $marginChange, issueType: $issueType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProblemProductImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.currentStock, currentStock) ||
                other.currentStock == currentStock) &&
            (identical(other.reorderPoint, reorderPoint) ||
                other.reorderPoint == reorderPoint) &&
            (identical(other.marginChange, marginChange) ||
                other.marginChange == marginChange) &&
            (identical(other.issueType, issueType) ||
                other.issueType == issueType));
  }

  @override
  int get hashCode => Object.hash(runtimeType, productId, productName,
      currentStock, reorderPoint, marginChange, issueType);

  /// Create a copy of ProblemProduct
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProblemProductImplCopyWith<_$ProblemProductImpl> get copyWith =>
      __$$ProblemProductImplCopyWithImpl<_$ProblemProductImpl>(
          this, _$identity);
}

abstract class _ProblemProduct extends ProblemProduct {
  const factory _ProblemProduct(
      {required final String productId,
      required final String productName,
      required final int currentStock,
      required final num reorderPoint,
      required final num? marginChange,
      required final String issueType}) = _$ProblemProductImpl;
  const _ProblemProduct._() : super._();

  @override
  String get productId;
  @override
  String get productName;
  @override
  int get currentStock;
  @override
  num get reorderPoint;
  @override
  num? get marginChange; // 전월 대비 마진 변화
  @override
  String get issueType;

  /// Create a copy of ProblemProduct
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProblemProductImplCopyWith<_$ProblemProductImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CategoryDetail {
  String get categoryId => throw _privateConstructorUsedError;
  String get categoryName => throw _privateConstructorUsedError;
  num get totalRevenue => throw _privateConstructorUsedError;
  num get totalMargin => throw _privateConstructorUsedError;
  num get marginRatePct => throw _privateConstructorUsedError;
  int get totalQuantity => throw _privateConstructorUsedError;
  num? get growthPct => throw _privateConstructorUsedError; // 전월 대비 성장률
  List<TopBrand> get topBrands => throw _privateConstructorUsedError;
  List<ProblemProduct> get problemProducts =>
      throw _privateConstructorUsedError;

  /// Create a copy of CategoryDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategoryDetailCopyWith<CategoryDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryDetailCopyWith<$Res> {
  factory $CategoryDetailCopyWith(
          CategoryDetail value, $Res Function(CategoryDetail) then) =
      _$CategoryDetailCopyWithImpl<$Res, CategoryDetail>;
  @useResult
  $Res call(
      {String categoryId,
      String categoryName,
      num totalRevenue,
      num totalMargin,
      num marginRatePct,
      int totalQuantity,
      num? growthPct,
      List<TopBrand> topBrands,
      List<ProblemProduct> problemProducts});
}

/// @nodoc
class _$CategoryDetailCopyWithImpl<$Res, $Val extends CategoryDetail>
    implements $CategoryDetailCopyWith<$Res> {
  _$CategoryDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CategoryDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryId = null,
    Object? categoryName = null,
    Object? totalRevenue = null,
    Object? totalMargin = null,
    Object? marginRatePct = null,
    Object? totalQuantity = null,
    Object? growthPct = freezed,
    Object? topBrands = null,
    Object? problemProducts = null,
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
      totalRevenue: null == totalRevenue
          ? _value.totalRevenue
          : totalRevenue // ignore: cast_nullable_to_non_nullable
              as num,
      totalMargin: null == totalMargin
          ? _value.totalMargin
          : totalMargin // ignore: cast_nullable_to_non_nullable
              as num,
      marginRatePct: null == marginRatePct
          ? _value.marginRatePct
          : marginRatePct // ignore: cast_nullable_to_non_nullable
              as num,
      totalQuantity: null == totalQuantity
          ? _value.totalQuantity
          : totalQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      growthPct: freezed == growthPct
          ? _value.growthPct
          : growthPct // ignore: cast_nullable_to_non_nullable
              as num?,
      topBrands: null == topBrands
          ? _value.topBrands
          : topBrands // ignore: cast_nullable_to_non_nullable
              as List<TopBrand>,
      problemProducts: null == problemProducts
          ? _value.problemProducts
          : problemProducts // ignore: cast_nullable_to_non_nullable
              as List<ProblemProduct>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CategoryDetailImplCopyWith<$Res>
    implements $CategoryDetailCopyWith<$Res> {
  factory _$$CategoryDetailImplCopyWith(_$CategoryDetailImpl value,
          $Res Function(_$CategoryDetailImpl) then) =
      __$$CategoryDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String categoryId,
      String categoryName,
      num totalRevenue,
      num totalMargin,
      num marginRatePct,
      int totalQuantity,
      num? growthPct,
      List<TopBrand> topBrands,
      List<ProblemProduct> problemProducts});
}

/// @nodoc
class __$$CategoryDetailImplCopyWithImpl<$Res>
    extends _$CategoryDetailCopyWithImpl<$Res, _$CategoryDetailImpl>
    implements _$$CategoryDetailImplCopyWith<$Res> {
  __$$CategoryDetailImplCopyWithImpl(
      _$CategoryDetailImpl _value, $Res Function(_$CategoryDetailImpl) _then)
      : super(_value, _then);

  /// Create a copy of CategoryDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryId = null,
    Object? categoryName = null,
    Object? totalRevenue = null,
    Object? totalMargin = null,
    Object? marginRatePct = null,
    Object? totalQuantity = null,
    Object? growthPct = freezed,
    Object? topBrands = null,
    Object? problemProducts = null,
  }) {
    return _then(_$CategoryDetailImpl(
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      categoryName: null == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String,
      totalRevenue: null == totalRevenue
          ? _value.totalRevenue
          : totalRevenue // ignore: cast_nullable_to_non_nullable
              as num,
      totalMargin: null == totalMargin
          ? _value.totalMargin
          : totalMargin // ignore: cast_nullable_to_non_nullable
              as num,
      marginRatePct: null == marginRatePct
          ? _value.marginRatePct
          : marginRatePct // ignore: cast_nullable_to_non_nullable
              as num,
      totalQuantity: null == totalQuantity
          ? _value.totalQuantity
          : totalQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      growthPct: freezed == growthPct
          ? _value.growthPct
          : growthPct // ignore: cast_nullable_to_non_nullable
              as num?,
      topBrands: null == topBrands
          ? _value._topBrands
          : topBrands // ignore: cast_nullable_to_non_nullable
              as List<TopBrand>,
      problemProducts: null == problemProducts
          ? _value._problemProducts
          : problemProducts // ignore: cast_nullable_to_non_nullable
              as List<ProblemProduct>,
    ));
  }
}

/// @nodoc

class _$CategoryDetailImpl extends _CategoryDetail {
  const _$CategoryDetailImpl(
      {required this.categoryId,
      required this.categoryName,
      required this.totalRevenue,
      required this.totalMargin,
      required this.marginRatePct,
      required this.totalQuantity,
      required this.growthPct,
      required final List<TopBrand> topBrands,
      required final List<ProblemProduct> problemProducts})
      : _topBrands = topBrands,
        _problemProducts = problemProducts,
        super._();

  @override
  final String categoryId;
  @override
  final String categoryName;
  @override
  final num totalRevenue;
  @override
  final num totalMargin;
  @override
  final num marginRatePct;
  @override
  final int totalQuantity;
  @override
  final num? growthPct;
// 전월 대비 성장률
  final List<TopBrand> _topBrands;
// 전월 대비 성장률
  @override
  List<TopBrand> get topBrands {
    if (_topBrands is EqualUnmodifiableListView) return _topBrands;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topBrands);
  }

  final List<ProblemProduct> _problemProducts;
  @override
  List<ProblemProduct> get problemProducts {
    if (_problemProducts is EqualUnmodifiableListView) return _problemProducts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_problemProducts);
  }

  @override
  String toString() {
    return 'CategoryDetail(categoryId: $categoryId, categoryName: $categoryName, totalRevenue: $totalRevenue, totalMargin: $totalMargin, marginRatePct: $marginRatePct, totalQuantity: $totalQuantity, growthPct: $growthPct, topBrands: $topBrands, problemProducts: $problemProducts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryDetailImpl &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.totalRevenue, totalRevenue) ||
                other.totalRevenue == totalRevenue) &&
            (identical(other.totalMargin, totalMargin) ||
                other.totalMargin == totalMargin) &&
            (identical(other.marginRatePct, marginRatePct) ||
                other.marginRatePct == marginRatePct) &&
            (identical(other.totalQuantity, totalQuantity) ||
                other.totalQuantity == totalQuantity) &&
            (identical(other.growthPct, growthPct) ||
                other.growthPct == growthPct) &&
            const DeepCollectionEquality()
                .equals(other._topBrands, _topBrands) &&
            const DeepCollectionEquality()
                .equals(other._problemProducts, _problemProducts));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      categoryId,
      categoryName,
      totalRevenue,
      totalMargin,
      marginRatePct,
      totalQuantity,
      growthPct,
      const DeepCollectionEquality().hash(_topBrands),
      const DeepCollectionEquality().hash(_problemProducts));

  /// Create a copy of CategoryDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryDetailImplCopyWith<_$CategoryDetailImpl> get copyWith =>
      __$$CategoryDetailImplCopyWithImpl<_$CategoryDetailImpl>(
          this, _$identity);
}

abstract class _CategoryDetail extends CategoryDetail {
  const factory _CategoryDetail(
          {required final String categoryId,
          required final String categoryName,
          required final num totalRevenue,
          required final num totalMargin,
          required final num marginRatePct,
          required final int totalQuantity,
          required final num? growthPct,
          required final List<TopBrand> topBrands,
          required final List<ProblemProduct> problemProducts}) =
      _$CategoryDetailImpl;
  const _CategoryDetail._() : super._();

  @override
  String get categoryId;
  @override
  String get categoryName;
  @override
  num get totalRevenue;
  @override
  num get totalMargin;
  @override
  num get marginRatePct;
  @override
  int get totalQuantity;
  @override
  num? get growthPct; // 전월 대비 성장률
  @override
  List<TopBrand> get topBrands;
  @override
  List<ProblemProduct> get problemProducts;

  /// Create a copy of CategoryDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoryDetailImplCopyWith<_$CategoryDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
