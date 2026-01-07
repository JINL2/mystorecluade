// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inventory_optimization.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ReorderProduct {
  String get productId => throw _privateConstructorUsedError;
  String get productName => throw _privateConstructorUsedError;
  String? get categoryName => throw _privateConstructorUsedError;
  num get currentStock => throw _privateConstructorUsedError;
  num get reorderPoint => throw _privateConstructorUsedError;
  num get orderQty => throw _privateConstructorUsedError;
  num get avgDailyDemand => throw _privateConstructorUsedError;
  num get daysLeft => throw _privateConstructorUsedError; // 버틸 일수 (음수 가능)
  String get priority => throw _privateConstructorUsedError;

  /// Create a copy of ReorderProduct
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReorderProductCopyWith<ReorderProduct> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReorderProductCopyWith<$Res> {
  factory $ReorderProductCopyWith(
          ReorderProduct value, $Res Function(ReorderProduct) then) =
      _$ReorderProductCopyWithImpl<$Res, ReorderProduct>;
  @useResult
  $Res call(
      {String productId,
      String productName,
      String? categoryName,
      num currentStock,
      num reorderPoint,
      num orderQty,
      num avgDailyDemand,
      num daysLeft,
      String priority});
}

/// @nodoc
class _$ReorderProductCopyWithImpl<$Res, $Val extends ReorderProduct>
    implements $ReorderProductCopyWith<$Res> {
  _$ReorderProductCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReorderProduct
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? productName = null,
    Object? categoryName = freezed,
    Object? currentStock = null,
    Object? reorderPoint = null,
    Object? orderQty = null,
    Object? avgDailyDemand = null,
    Object? daysLeft = null,
    Object? priority = null,
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
      categoryName: freezed == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String?,
      currentStock: null == currentStock
          ? _value.currentStock
          : currentStock // ignore: cast_nullable_to_non_nullable
              as num,
      reorderPoint: null == reorderPoint
          ? _value.reorderPoint
          : reorderPoint // ignore: cast_nullable_to_non_nullable
              as num,
      orderQty: null == orderQty
          ? _value.orderQty
          : orderQty // ignore: cast_nullable_to_non_nullable
              as num,
      avgDailyDemand: null == avgDailyDemand
          ? _value.avgDailyDemand
          : avgDailyDemand // ignore: cast_nullable_to_non_nullable
              as num,
      daysLeft: null == daysLeft
          ? _value.daysLeft
          : daysLeft // ignore: cast_nullable_to_non_nullable
              as num,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReorderProductImplCopyWith<$Res>
    implements $ReorderProductCopyWith<$Res> {
  factory _$$ReorderProductImplCopyWith(_$ReorderProductImpl value,
          $Res Function(_$ReorderProductImpl) then) =
      __$$ReorderProductImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String productId,
      String productName,
      String? categoryName,
      num currentStock,
      num reorderPoint,
      num orderQty,
      num avgDailyDemand,
      num daysLeft,
      String priority});
}

/// @nodoc
class __$$ReorderProductImplCopyWithImpl<$Res>
    extends _$ReorderProductCopyWithImpl<$Res, _$ReorderProductImpl>
    implements _$$ReorderProductImplCopyWith<$Res> {
  __$$ReorderProductImplCopyWithImpl(
      _$ReorderProductImpl _value, $Res Function(_$ReorderProductImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReorderProduct
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? productName = null,
    Object? categoryName = freezed,
    Object? currentStock = null,
    Object? reorderPoint = null,
    Object? orderQty = null,
    Object? avgDailyDemand = null,
    Object? daysLeft = null,
    Object? priority = null,
  }) {
    return _then(_$ReorderProductImpl(
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      categoryName: freezed == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String?,
      currentStock: null == currentStock
          ? _value.currentStock
          : currentStock // ignore: cast_nullable_to_non_nullable
              as num,
      reorderPoint: null == reorderPoint
          ? _value.reorderPoint
          : reorderPoint // ignore: cast_nullable_to_non_nullable
              as num,
      orderQty: null == orderQty
          ? _value.orderQty
          : orderQty // ignore: cast_nullable_to_non_nullable
              as num,
      avgDailyDemand: null == avgDailyDemand
          ? _value.avgDailyDemand
          : avgDailyDemand // ignore: cast_nullable_to_non_nullable
              as num,
      daysLeft: null == daysLeft
          ? _value.daysLeft
          : daysLeft // ignore: cast_nullable_to_non_nullable
              as num,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ReorderProductImpl extends _ReorderProduct {
  const _$ReorderProductImpl(
      {required this.productId,
      required this.productName,
      required this.categoryName,
      required this.currentStock,
      required this.reorderPoint,
      required this.orderQty,
      required this.avgDailyDemand,
      required this.daysLeft,
      required this.priority})
      : super._();

  @override
  final String productId;
  @override
  final String productName;
  @override
  final String? categoryName;
  @override
  final num currentStock;
  @override
  final num reorderPoint;
  @override
  final num orderQty;
  @override
  final num avgDailyDemand;
  @override
  final num daysLeft;
// 버틸 일수 (음수 가능)
  @override
  final String priority;

  @override
  String toString() {
    return 'ReorderProduct(productId: $productId, productName: $productName, categoryName: $categoryName, currentStock: $currentStock, reorderPoint: $reorderPoint, orderQty: $orderQty, avgDailyDemand: $avgDailyDemand, daysLeft: $daysLeft, priority: $priority)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReorderProductImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.currentStock, currentStock) ||
                other.currentStock == currentStock) &&
            (identical(other.reorderPoint, reorderPoint) ||
                other.reorderPoint == reorderPoint) &&
            (identical(other.orderQty, orderQty) ||
                other.orderQty == orderQty) &&
            (identical(other.avgDailyDemand, avgDailyDemand) ||
                other.avgDailyDemand == avgDailyDemand) &&
            (identical(other.daysLeft, daysLeft) ||
                other.daysLeft == daysLeft) &&
            (identical(other.priority, priority) ||
                other.priority == priority));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      productId,
      productName,
      categoryName,
      currentStock,
      reorderPoint,
      orderQty,
      avgDailyDemand,
      daysLeft,
      priority);

  /// Create a copy of ReorderProduct
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReorderProductImplCopyWith<_$ReorderProductImpl> get copyWith =>
      __$$ReorderProductImplCopyWithImpl<_$ReorderProductImpl>(
          this, _$identity);
}

abstract class _ReorderProduct extends ReorderProduct {
  const factory _ReorderProduct(
      {required final String productId,
      required final String productName,
      required final String? categoryName,
      required final num currentStock,
      required final num reorderPoint,
      required final num orderQty,
      required final num avgDailyDemand,
      required final num daysLeft,
      required final String priority}) = _$ReorderProductImpl;
  const _ReorderProduct._() : super._();

  @override
  String get productId;
  @override
  String get productName;
  @override
  String? get categoryName;
  @override
  num get currentStock;
  @override
  num get reorderPoint;
  @override
  num get orderQty;
  @override
  num get avgDailyDemand;
  @override
  num get daysLeft; // 버틸 일수 (음수 가능)
  @override
  String get priority;

  /// Create a copy of ReorderProduct
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReorderProductImplCopyWith<_$ReorderProductImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$OptimizationMetrics {
  num get stockoutRate => throw _privateConstructorUsedError; // 품절률 (%)
  num get overstockRate => throw _privateConstructorUsedError; // 과잉재고율 (%)
  num get avgTurnover => throw _privateConstructorUsedError; // 평균 재고회전율
  int get reorderNeeded => throw _privateConstructorUsedError;

  /// Create a copy of OptimizationMetrics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OptimizationMetricsCopyWith<OptimizationMetrics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OptimizationMetricsCopyWith<$Res> {
  factory $OptimizationMetricsCopyWith(
          OptimizationMetrics value, $Res Function(OptimizationMetrics) then) =
      _$OptimizationMetricsCopyWithImpl<$Res, OptimizationMetrics>;
  @useResult
  $Res call(
      {num stockoutRate,
      num overstockRate,
      num avgTurnover,
      int reorderNeeded});
}

/// @nodoc
class _$OptimizationMetricsCopyWithImpl<$Res, $Val extends OptimizationMetrics>
    implements $OptimizationMetricsCopyWith<$Res> {
  _$OptimizationMetricsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OptimizationMetrics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stockoutRate = null,
    Object? overstockRate = null,
    Object? avgTurnover = null,
    Object? reorderNeeded = null,
  }) {
    return _then(_value.copyWith(
      stockoutRate: null == stockoutRate
          ? _value.stockoutRate
          : stockoutRate // ignore: cast_nullable_to_non_nullable
              as num,
      overstockRate: null == overstockRate
          ? _value.overstockRate
          : overstockRate // ignore: cast_nullable_to_non_nullable
              as num,
      avgTurnover: null == avgTurnover
          ? _value.avgTurnover
          : avgTurnover // ignore: cast_nullable_to_non_nullable
              as num,
      reorderNeeded: null == reorderNeeded
          ? _value.reorderNeeded
          : reorderNeeded // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OptimizationMetricsImplCopyWith<$Res>
    implements $OptimizationMetricsCopyWith<$Res> {
  factory _$$OptimizationMetricsImplCopyWith(_$OptimizationMetricsImpl value,
          $Res Function(_$OptimizationMetricsImpl) then) =
      __$$OptimizationMetricsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {num stockoutRate,
      num overstockRate,
      num avgTurnover,
      int reorderNeeded});
}

/// @nodoc
class __$$OptimizationMetricsImplCopyWithImpl<$Res>
    extends _$OptimizationMetricsCopyWithImpl<$Res, _$OptimizationMetricsImpl>
    implements _$$OptimizationMetricsImplCopyWith<$Res> {
  __$$OptimizationMetricsImplCopyWithImpl(_$OptimizationMetricsImpl _value,
      $Res Function(_$OptimizationMetricsImpl) _then)
      : super(_value, _then);

  /// Create a copy of OptimizationMetrics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stockoutRate = null,
    Object? overstockRate = null,
    Object? avgTurnover = null,
    Object? reorderNeeded = null,
  }) {
    return _then(_$OptimizationMetricsImpl(
      stockoutRate: null == stockoutRate
          ? _value.stockoutRate
          : stockoutRate // ignore: cast_nullable_to_non_nullable
              as num,
      overstockRate: null == overstockRate
          ? _value.overstockRate
          : overstockRate // ignore: cast_nullable_to_non_nullable
              as num,
      avgTurnover: null == avgTurnover
          ? _value.avgTurnover
          : avgTurnover // ignore: cast_nullable_to_non_nullable
              as num,
      reorderNeeded: null == reorderNeeded
          ? _value.reorderNeeded
          : reorderNeeded // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$OptimizationMetricsImpl extends _OptimizationMetrics {
  const _$OptimizationMetricsImpl(
      {required this.stockoutRate,
      required this.overstockRate,
      required this.avgTurnover,
      required this.reorderNeeded})
      : super._();

  @override
  final num stockoutRate;
// 품절률 (%)
  @override
  final num overstockRate;
// 과잉재고율 (%)
  @override
  final num avgTurnover;
// 평균 재고회전율
  @override
  final int reorderNeeded;

  @override
  String toString() {
    return 'OptimizationMetrics(stockoutRate: $stockoutRate, overstockRate: $overstockRate, avgTurnover: $avgTurnover, reorderNeeded: $reorderNeeded)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OptimizationMetricsImpl &&
            (identical(other.stockoutRate, stockoutRate) ||
                other.stockoutRate == stockoutRate) &&
            (identical(other.overstockRate, overstockRate) ||
                other.overstockRate == overstockRate) &&
            (identical(other.avgTurnover, avgTurnover) ||
                other.avgTurnover == avgTurnover) &&
            (identical(other.reorderNeeded, reorderNeeded) ||
                other.reorderNeeded == reorderNeeded));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, stockoutRate, overstockRate, avgTurnover, reorderNeeded);

  /// Create a copy of OptimizationMetrics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OptimizationMetricsImplCopyWith<_$OptimizationMetricsImpl> get copyWith =>
      __$$OptimizationMetricsImplCopyWithImpl<_$OptimizationMetricsImpl>(
          this, _$identity);
}

abstract class _OptimizationMetrics extends OptimizationMetrics {
  const factory _OptimizationMetrics(
      {required final num stockoutRate,
      required final num overstockRate,
      required final num avgTurnover,
      required final int reorderNeeded}) = _$OptimizationMetricsImpl;
  const _OptimizationMetrics._() : super._();

  @override
  num get stockoutRate; // 품절률 (%)
  @override
  num get overstockRate; // 과잉재고율 (%)
  @override
  num get avgTurnover; // 평균 재고회전율
  @override
  int get reorderNeeded;

  /// Create a copy of OptimizationMetrics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OptimizationMetricsImplCopyWith<_$OptimizationMetricsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$InventoryOptimization {
  int get overallScore => throw _privateConstructorUsedError; // 0-100
  OptimizationMetrics get metrics => throw _privateConstructorUsedError;
  List<ReorderProduct> get urgentOrders => throw _privateConstructorUsedError;

  /// Create a copy of InventoryOptimization
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InventoryOptimizationCopyWith<InventoryOptimization> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InventoryOptimizationCopyWith<$Res> {
  factory $InventoryOptimizationCopyWith(InventoryOptimization value,
          $Res Function(InventoryOptimization) then) =
      _$InventoryOptimizationCopyWithImpl<$Res, InventoryOptimization>;
  @useResult
  $Res call(
      {int overallScore,
      OptimizationMetrics metrics,
      List<ReorderProduct> urgentOrders});

  $OptimizationMetricsCopyWith<$Res> get metrics;
}

/// @nodoc
class _$InventoryOptimizationCopyWithImpl<$Res,
        $Val extends InventoryOptimization>
    implements $InventoryOptimizationCopyWith<$Res> {
  _$InventoryOptimizationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InventoryOptimization
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? overallScore = null,
    Object? metrics = null,
    Object? urgentOrders = null,
  }) {
    return _then(_value.copyWith(
      overallScore: null == overallScore
          ? _value.overallScore
          : overallScore // ignore: cast_nullable_to_non_nullable
              as int,
      metrics: null == metrics
          ? _value.metrics
          : metrics // ignore: cast_nullable_to_non_nullable
              as OptimizationMetrics,
      urgentOrders: null == urgentOrders
          ? _value.urgentOrders
          : urgentOrders // ignore: cast_nullable_to_non_nullable
              as List<ReorderProduct>,
    ) as $Val);
  }

  /// Create a copy of InventoryOptimization
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OptimizationMetricsCopyWith<$Res> get metrics {
    return $OptimizationMetricsCopyWith<$Res>(_value.metrics, (value) {
      return _then(_value.copyWith(metrics: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$InventoryOptimizationImplCopyWith<$Res>
    implements $InventoryOptimizationCopyWith<$Res> {
  factory _$$InventoryOptimizationImplCopyWith(
          _$InventoryOptimizationImpl value,
          $Res Function(_$InventoryOptimizationImpl) then) =
      __$$InventoryOptimizationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int overallScore,
      OptimizationMetrics metrics,
      List<ReorderProduct> urgentOrders});

  @override
  $OptimizationMetricsCopyWith<$Res> get metrics;
}

/// @nodoc
class __$$InventoryOptimizationImplCopyWithImpl<$Res>
    extends _$InventoryOptimizationCopyWithImpl<$Res,
        _$InventoryOptimizationImpl>
    implements _$$InventoryOptimizationImplCopyWith<$Res> {
  __$$InventoryOptimizationImplCopyWithImpl(_$InventoryOptimizationImpl _value,
      $Res Function(_$InventoryOptimizationImpl) _then)
      : super(_value, _then);

  /// Create a copy of InventoryOptimization
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? overallScore = null,
    Object? metrics = null,
    Object? urgentOrders = null,
  }) {
    return _then(_$InventoryOptimizationImpl(
      overallScore: null == overallScore
          ? _value.overallScore
          : overallScore // ignore: cast_nullable_to_non_nullable
              as int,
      metrics: null == metrics
          ? _value.metrics
          : metrics // ignore: cast_nullable_to_non_nullable
              as OptimizationMetrics,
      urgentOrders: null == urgentOrders
          ? _value._urgentOrders
          : urgentOrders // ignore: cast_nullable_to_non_nullable
              as List<ReorderProduct>,
    ));
  }
}

/// @nodoc

class _$InventoryOptimizationImpl extends _InventoryOptimization {
  const _$InventoryOptimizationImpl(
      {required this.overallScore,
      required this.metrics,
      required final List<ReorderProduct> urgentOrders})
      : _urgentOrders = urgentOrders,
        super._();

  @override
  final int overallScore;
// 0-100
  @override
  final OptimizationMetrics metrics;
  final List<ReorderProduct> _urgentOrders;
  @override
  List<ReorderProduct> get urgentOrders {
    if (_urgentOrders is EqualUnmodifiableListView) return _urgentOrders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_urgentOrders);
  }

  @override
  String toString() {
    return 'InventoryOptimization(overallScore: $overallScore, metrics: $metrics, urgentOrders: $urgentOrders)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InventoryOptimizationImpl &&
            (identical(other.overallScore, overallScore) ||
                other.overallScore == overallScore) &&
            (identical(other.metrics, metrics) || other.metrics == metrics) &&
            const DeepCollectionEquality()
                .equals(other._urgentOrders, _urgentOrders));
  }

  @override
  int get hashCode => Object.hash(runtimeType, overallScore, metrics,
      const DeepCollectionEquality().hash(_urgentOrders));

  /// Create a copy of InventoryOptimization
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InventoryOptimizationImplCopyWith<_$InventoryOptimizationImpl>
      get copyWith => __$$InventoryOptimizationImplCopyWithImpl<
          _$InventoryOptimizationImpl>(this, _$identity);
}

abstract class _InventoryOptimization extends InventoryOptimization {
  const factory _InventoryOptimization(
          {required final int overallScore,
          required final OptimizationMetrics metrics,
          required final List<ReorderProduct> urgentOrders}) =
      _$InventoryOptimizationImpl;
  const _InventoryOptimization._() : super._();

  @override
  int get overallScore; // 0-100
  @override
  OptimizationMetrics get metrics;
  @override
  List<ReorderProduct> get urgentOrders;

  /// Create a copy of InventoryOptimization
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InventoryOptimizationImplCopyWith<_$InventoryOptimizationImpl>
      get copyWith => throw _privateConstructorUsedError;
}
