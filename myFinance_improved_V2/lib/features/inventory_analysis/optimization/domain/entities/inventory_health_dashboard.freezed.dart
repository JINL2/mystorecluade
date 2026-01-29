// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inventory_health_dashboard.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$InventoryHealthDashboard {
  /// 요약 통계
  HealthSummary get summary => throw _privateConstructorUsedError;

  /// 카테고리별 긴급도 (urgency_score 내림차순)
  List<HealthCategory> get categories => throw _privateConstructorUsedError;

  /// 긴급 재주문 필요 상품 (high sales velocity + low stock)
  List<HealthProduct> get urgentProducts => throw _privateConstructorUsedError;

  /// 일반 재주문 필요 상품 (low sales velocity + low stock)
  List<HealthProduct> get normalProducts => throw _privateConstructorUsedError;

  /// 과잉 재고 상품
  List<OverstockProduct> get overstockProducts =>
      throw _privateConstructorUsedError;

  /// 재고 실사 필요 상품 (negative stock)
  List<RecountProduct> get recountProducts =>
      throw _privateConstructorUsedError;

  /// Create a copy of InventoryHealthDashboard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InventoryHealthDashboardCopyWith<InventoryHealthDashboard> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InventoryHealthDashboardCopyWith<$Res> {
  factory $InventoryHealthDashboardCopyWith(InventoryHealthDashboard value,
          $Res Function(InventoryHealthDashboard) then) =
      _$InventoryHealthDashboardCopyWithImpl<$Res, InventoryHealthDashboard>;
  @useResult
  $Res call(
      {HealthSummary summary,
      List<HealthCategory> categories,
      List<HealthProduct> urgentProducts,
      List<HealthProduct> normalProducts,
      List<OverstockProduct> overstockProducts,
      List<RecountProduct> recountProducts});

  $HealthSummaryCopyWith<$Res> get summary;
}

/// @nodoc
class _$InventoryHealthDashboardCopyWithImpl<$Res,
        $Val extends InventoryHealthDashboard>
    implements $InventoryHealthDashboardCopyWith<$Res> {
  _$InventoryHealthDashboardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InventoryHealthDashboard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? summary = null,
    Object? categories = null,
    Object? urgentProducts = null,
    Object? normalProducts = null,
    Object? overstockProducts = null,
    Object? recountProducts = null,
  }) {
    return _then(_value.copyWith(
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as HealthSummary,
      categories: null == categories
          ? _value.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<HealthCategory>,
      urgentProducts: null == urgentProducts
          ? _value.urgentProducts
          : urgentProducts // ignore: cast_nullable_to_non_nullable
              as List<HealthProduct>,
      normalProducts: null == normalProducts
          ? _value.normalProducts
          : normalProducts // ignore: cast_nullable_to_non_nullable
              as List<HealthProduct>,
      overstockProducts: null == overstockProducts
          ? _value.overstockProducts
          : overstockProducts // ignore: cast_nullable_to_non_nullable
              as List<OverstockProduct>,
      recountProducts: null == recountProducts
          ? _value.recountProducts
          : recountProducts // ignore: cast_nullable_to_non_nullable
              as List<RecountProduct>,
    ) as $Val);
  }

  /// Create a copy of InventoryHealthDashboard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $HealthSummaryCopyWith<$Res> get summary {
    return $HealthSummaryCopyWith<$Res>(_value.summary, (value) {
      return _then(_value.copyWith(summary: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$InventoryHealthDashboardImplCopyWith<$Res>
    implements $InventoryHealthDashboardCopyWith<$Res> {
  factory _$$InventoryHealthDashboardImplCopyWith(
          _$InventoryHealthDashboardImpl value,
          $Res Function(_$InventoryHealthDashboardImpl) then) =
      __$$InventoryHealthDashboardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {HealthSummary summary,
      List<HealthCategory> categories,
      List<HealthProduct> urgentProducts,
      List<HealthProduct> normalProducts,
      List<OverstockProduct> overstockProducts,
      List<RecountProduct> recountProducts});

  @override
  $HealthSummaryCopyWith<$Res> get summary;
}

/// @nodoc
class __$$InventoryHealthDashboardImplCopyWithImpl<$Res>
    extends _$InventoryHealthDashboardCopyWithImpl<$Res,
        _$InventoryHealthDashboardImpl>
    implements _$$InventoryHealthDashboardImplCopyWith<$Res> {
  __$$InventoryHealthDashboardImplCopyWithImpl(
      _$InventoryHealthDashboardImpl _value,
      $Res Function(_$InventoryHealthDashboardImpl) _then)
      : super(_value, _then);

  /// Create a copy of InventoryHealthDashboard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? summary = null,
    Object? categories = null,
    Object? urgentProducts = null,
    Object? normalProducts = null,
    Object? overstockProducts = null,
    Object? recountProducts = null,
  }) {
    return _then(_$InventoryHealthDashboardImpl(
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as HealthSummary,
      categories: null == categories
          ? _value._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<HealthCategory>,
      urgentProducts: null == urgentProducts
          ? _value._urgentProducts
          : urgentProducts // ignore: cast_nullable_to_non_nullable
              as List<HealthProduct>,
      normalProducts: null == normalProducts
          ? _value._normalProducts
          : normalProducts // ignore: cast_nullable_to_non_nullable
              as List<HealthProduct>,
      overstockProducts: null == overstockProducts
          ? _value._overstockProducts
          : overstockProducts // ignore: cast_nullable_to_non_nullable
              as List<OverstockProduct>,
      recountProducts: null == recountProducts
          ? _value._recountProducts
          : recountProducts // ignore: cast_nullable_to_non_nullable
              as List<RecountProduct>,
    ));
  }
}

/// @nodoc

class _$InventoryHealthDashboardImpl extends _InventoryHealthDashboard {
  const _$InventoryHealthDashboardImpl(
      {required this.summary,
      required final List<HealthCategory> categories,
      required final List<HealthProduct> urgentProducts,
      required final List<HealthProduct> normalProducts,
      required final List<OverstockProduct> overstockProducts,
      required final List<RecountProduct> recountProducts})
      : _categories = categories,
        _urgentProducts = urgentProducts,
        _normalProducts = normalProducts,
        _overstockProducts = overstockProducts,
        _recountProducts = recountProducts,
        super._();

  /// 요약 통계
  @override
  final HealthSummary summary;

  /// 카테고리별 긴급도 (urgency_score 내림차순)
  final List<HealthCategory> _categories;

  /// 카테고리별 긴급도 (urgency_score 내림차순)
  @override
  List<HealthCategory> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  /// 긴급 재주문 필요 상품 (high sales velocity + low stock)
  final List<HealthProduct> _urgentProducts;

  /// 긴급 재주문 필요 상품 (high sales velocity + low stock)
  @override
  List<HealthProduct> get urgentProducts {
    if (_urgentProducts is EqualUnmodifiableListView) return _urgentProducts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_urgentProducts);
  }

  /// 일반 재주문 필요 상품 (low sales velocity + low stock)
  final List<HealthProduct> _normalProducts;

  /// 일반 재주문 필요 상품 (low sales velocity + low stock)
  @override
  List<HealthProduct> get normalProducts {
    if (_normalProducts is EqualUnmodifiableListView) return _normalProducts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_normalProducts);
  }

  /// 과잉 재고 상품
  final List<OverstockProduct> _overstockProducts;

  /// 과잉 재고 상품
  @override
  List<OverstockProduct> get overstockProducts {
    if (_overstockProducts is EqualUnmodifiableListView)
      return _overstockProducts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_overstockProducts);
  }

  /// 재고 실사 필요 상품 (negative stock)
  final List<RecountProduct> _recountProducts;

  /// 재고 실사 필요 상품 (negative stock)
  @override
  List<RecountProduct> get recountProducts {
    if (_recountProducts is EqualUnmodifiableListView) return _recountProducts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recountProducts);
  }

  @override
  String toString() {
    return 'InventoryHealthDashboard(summary: $summary, categories: $categories, urgentProducts: $urgentProducts, normalProducts: $normalProducts, overstockProducts: $overstockProducts, recountProducts: $recountProducts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InventoryHealthDashboardImpl &&
            (identical(other.summary, summary) || other.summary == summary) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            const DeepCollectionEquality()
                .equals(other._urgentProducts, _urgentProducts) &&
            const DeepCollectionEquality()
                .equals(other._normalProducts, _normalProducts) &&
            const DeepCollectionEquality()
                .equals(other._overstockProducts, _overstockProducts) &&
            const DeepCollectionEquality()
                .equals(other._recountProducts, _recountProducts));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      summary,
      const DeepCollectionEquality().hash(_categories),
      const DeepCollectionEquality().hash(_urgentProducts),
      const DeepCollectionEquality().hash(_normalProducts),
      const DeepCollectionEquality().hash(_overstockProducts),
      const DeepCollectionEquality().hash(_recountProducts));

  /// Create a copy of InventoryHealthDashboard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InventoryHealthDashboardImplCopyWith<_$InventoryHealthDashboardImpl>
      get copyWith => __$$InventoryHealthDashboardImplCopyWithImpl<
          _$InventoryHealthDashboardImpl>(this, _$identity);
}

abstract class _InventoryHealthDashboard extends InventoryHealthDashboard {
  const factory _InventoryHealthDashboard(
          {required final HealthSummary summary,
          required final List<HealthCategory> categories,
          required final List<HealthProduct> urgentProducts,
          required final List<HealthProduct> normalProducts,
          required final List<OverstockProduct> overstockProducts,
          required final List<RecountProduct> recountProducts}) =
      _$InventoryHealthDashboardImpl;
  const _InventoryHealthDashboard._() : super._();

  /// 요약 통계
  @override
  HealthSummary get summary;

  /// 카테고리별 긴급도 (urgency_score 내림차순)
  @override
  List<HealthCategory> get categories;

  /// 긴급 재주문 필요 상품 (high sales velocity + low stock)
  @override
  List<HealthProduct> get urgentProducts;

  /// 일반 재주문 필요 상품 (low sales velocity + low stock)
  @override
  List<HealthProduct> get normalProducts;

  /// 과잉 재고 상품
  @override
  List<OverstockProduct> get overstockProducts;

  /// 재고 실사 필요 상품 (negative stock)
  @override
  List<RecountProduct> get recountProducts;

  /// Create a copy of InventoryHealthDashboard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InventoryHealthDashboardImplCopyWith<_$InventoryHealthDashboardImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$HealthSummary {
  int get totalProducts => throw _privateConstructorUsedError;
  int get urgentCount => throw _privateConstructorUsedError;
  double get urgentPct => throw _privateConstructorUsedError;
  int get normalCount => throw _privateConstructorUsedError;
  double get normalPct => throw _privateConstructorUsedError;
  int get sufficientCount => throw _privateConstructorUsedError;
  double get sufficientPct => throw _privateConstructorUsedError;
  int get overstockCount => throw _privateConstructorUsedError;
  double get overstockPct => throw _privateConstructorUsedError;
  int get recountCount => throw _privateConstructorUsedError;
  double get recountPct => throw _privateConstructorUsedError;
  int get totalReorderNeeded => throw _privateConstructorUsedError;

  /// Create a copy of HealthSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HealthSummaryCopyWith<HealthSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HealthSummaryCopyWith<$Res> {
  factory $HealthSummaryCopyWith(
          HealthSummary value, $Res Function(HealthSummary) then) =
      _$HealthSummaryCopyWithImpl<$Res, HealthSummary>;
  @useResult
  $Res call(
      {int totalProducts,
      int urgentCount,
      double urgentPct,
      int normalCount,
      double normalPct,
      int sufficientCount,
      double sufficientPct,
      int overstockCount,
      double overstockPct,
      int recountCount,
      double recountPct,
      int totalReorderNeeded});
}

/// @nodoc
class _$HealthSummaryCopyWithImpl<$Res, $Val extends HealthSummary>
    implements $HealthSummaryCopyWith<$Res> {
  _$HealthSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HealthSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalProducts = null,
    Object? urgentCount = null,
    Object? urgentPct = null,
    Object? normalCount = null,
    Object? normalPct = null,
    Object? sufficientCount = null,
    Object? sufficientPct = null,
    Object? overstockCount = null,
    Object? overstockPct = null,
    Object? recountCount = null,
    Object? recountPct = null,
    Object? totalReorderNeeded = null,
  }) {
    return _then(_value.copyWith(
      totalProducts: null == totalProducts
          ? _value.totalProducts
          : totalProducts // ignore: cast_nullable_to_non_nullable
              as int,
      urgentCount: null == urgentCount
          ? _value.urgentCount
          : urgentCount // ignore: cast_nullable_to_non_nullable
              as int,
      urgentPct: null == urgentPct
          ? _value.urgentPct
          : urgentPct // ignore: cast_nullable_to_non_nullable
              as double,
      normalCount: null == normalCount
          ? _value.normalCount
          : normalCount // ignore: cast_nullable_to_non_nullable
              as int,
      normalPct: null == normalPct
          ? _value.normalPct
          : normalPct // ignore: cast_nullable_to_non_nullable
              as double,
      sufficientCount: null == sufficientCount
          ? _value.sufficientCount
          : sufficientCount // ignore: cast_nullable_to_non_nullable
              as int,
      sufficientPct: null == sufficientPct
          ? _value.sufficientPct
          : sufficientPct // ignore: cast_nullable_to_non_nullable
              as double,
      overstockCount: null == overstockCount
          ? _value.overstockCount
          : overstockCount // ignore: cast_nullable_to_non_nullable
              as int,
      overstockPct: null == overstockPct
          ? _value.overstockPct
          : overstockPct // ignore: cast_nullable_to_non_nullable
              as double,
      recountCount: null == recountCount
          ? _value.recountCount
          : recountCount // ignore: cast_nullable_to_non_nullable
              as int,
      recountPct: null == recountPct
          ? _value.recountPct
          : recountPct // ignore: cast_nullable_to_non_nullable
              as double,
      totalReorderNeeded: null == totalReorderNeeded
          ? _value.totalReorderNeeded
          : totalReorderNeeded // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HealthSummaryImplCopyWith<$Res>
    implements $HealthSummaryCopyWith<$Res> {
  factory _$$HealthSummaryImplCopyWith(
          _$HealthSummaryImpl value, $Res Function(_$HealthSummaryImpl) then) =
      __$$HealthSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int totalProducts,
      int urgentCount,
      double urgentPct,
      int normalCount,
      double normalPct,
      int sufficientCount,
      double sufficientPct,
      int overstockCount,
      double overstockPct,
      int recountCount,
      double recountPct,
      int totalReorderNeeded});
}

/// @nodoc
class __$$HealthSummaryImplCopyWithImpl<$Res>
    extends _$HealthSummaryCopyWithImpl<$Res, _$HealthSummaryImpl>
    implements _$$HealthSummaryImplCopyWith<$Res> {
  __$$HealthSummaryImplCopyWithImpl(
      _$HealthSummaryImpl _value, $Res Function(_$HealthSummaryImpl) _then)
      : super(_value, _then);

  /// Create a copy of HealthSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalProducts = null,
    Object? urgentCount = null,
    Object? urgentPct = null,
    Object? normalCount = null,
    Object? normalPct = null,
    Object? sufficientCount = null,
    Object? sufficientPct = null,
    Object? overstockCount = null,
    Object? overstockPct = null,
    Object? recountCount = null,
    Object? recountPct = null,
    Object? totalReorderNeeded = null,
  }) {
    return _then(_$HealthSummaryImpl(
      totalProducts: null == totalProducts
          ? _value.totalProducts
          : totalProducts // ignore: cast_nullable_to_non_nullable
              as int,
      urgentCount: null == urgentCount
          ? _value.urgentCount
          : urgentCount // ignore: cast_nullable_to_non_nullable
              as int,
      urgentPct: null == urgentPct
          ? _value.urgentPct
          : urgentPct // ignore: cast_nullable_to_non_nullable
              as double,
      normalCount: null == normalCount
          ? _value.normalCount
          : normalCount // ignore: cast_nullable_to_non_nullable
              as int,
      normalPct: null == normalPct
          ? _value.normalPct
          : normalPct // ignore: cast_nullable_to_non_nullable
              as double,
      sufficientCount: null == sufficientCount
          ? _value.sufficientCount
          : sufficientCount // ignore: cast_nullable_to_non_nullable
              as int,
      sufficientPct: null == sufficientPct
          ? _value.sufficientPct
          : sufficientPct // ignore: cast_nullable_to_non_nullable
              as double,
      overstockCount: null == overstockCount
          ? _value.overstockCount
          : overstockCount // ignore: cast_nullable_to_non_nullable
              as int,
      overstockPct: null == overstockPct
          ? _value.overstockPct
          : overstockPct // ignore: cast_nullable_to_non_nullable
              as double,
      recountCount: null == recountCount
          ? _value.recountCount
          : recountCount // ignore: cast_nullable_to_non_nullable
              as int,
      recountPct: null == recountPct
          ? _value.recountPct
          : recountPct // ignore: cast_nullable_to_non_nullable
              as double,
      totalReorderNeeded: null == totalReorderNeeded
          ? _value.totalReorderNeeded
          : totalReorderNeeded // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$HealthSummaryImpl implements _HealthSummary {
  const _$HealthSummaryImpl(
      {required this.totalProducts,
      required this.urgentCount,
      required this.urgentPct,
      required this.normalCount,
      required this.normalPct,
      required this.sufficientCount,
      required this.sufficientPct,
      required this.overstockCount,
      required this.overstockPct,
      required this.recountCount,
      required this.recountPct,
      required this.totalReorderNeeded});

  @override
  final int totalProducts;
  @override
  final int urgentCount;
  @override
  final double urgentPct;
  @override
  final int normalCount;
  @override
  final double normalPct;
  @override
  final int sufficientCount;
  @override
  final double sufficientPct;
  @override
  final int overstockCount;
  @override
  final double overstockPct;
  @override
  final int recountCount;
  @override
  final double recountPct;
  @override
  final int totalReorderNeeded;

  @override
  String toString() {
    return 'HealthSummary(totalProducts: $totalProducts, urgentCount: $urgentCount, urgentPct: $urgentPct, normalCount: $normalCount, normalPct: $normalPct, sufficientCount: $sufficientCount, sufficientPct: $sufficientPct, overstockCount: $overstockCount, overstockPct: $overstockPct, recountCount: $recountCount, recountPct: $recountPct, totalReorderNeeded: $totalReorderNeeded)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HealthSummaryImpl &&
            (identical(other.totalProducts, totalProducts) ||
                other.totalProducts == totalProducts) &&
            (identical(other.urgentCount, urgentCount) ||
                other.urgentCount == urgentCount) &&
            (identical(other.urgentPct, urgentPct) ||
                other.urgentPct == urgentPct) &&
            (identical(other.normalCount, normalCount) ||
                other.normalCount == normalCount) &&
            (identical(other.normalPct, normalPct) ||
                other.normalPct == normalPct) &&
            (identical(other.sufficientCount, sufficientCount) ||
                other.sufficientCount == sufficientCount) &&
            (identical(other.sufficientPct, sufficientPct) ||
                other.sufficientPct == sufficientPct) &&
            (identical(other.overstockCount, overstockCount) ||
                other.overstockCount == overstockCount) &&
            (identical(other.overstockPct, overstockPct) ||
                other.overstockPct == overstockPct) &&
            (identical(other.recountCount, recountCount) ||
                other.recountCount == recountCount) &&
            (identical(other.recountPct, recountPct) ||
                other.recountPct == recountPct) &&
            (identical(other.totalReorderNeeded, totalReorderNeeded) ||
                other.totalReorderNeeded == totalReorderNeeded));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalProducts,
      urgentCount,
      urgentPct,
      normalCount,
      normalPct,
      sufficientCount,
      sufficientPct,
      overstockCount,
      overstockPct,
      recountCount,
      recountPct,
      totalReorderNeeded);

  /// Create a copy of HealthSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HealthSummaryImplCopyWith<_$HealthSummaryImpl> get copyWith =>
      __$$HealthSummaryImplCopyWithImpl<_$HealthSummaryImpl>(this, _$identity);
}

abstract class _HealthSummary implements HealthSummary {
  const factory _HealthSummary(
      {required final int totalProducts,
      required final int urgentCount,
      required final double urgentPct,
      required final int normalCount,
      required final double normalPct,
      required final int sufficientCount,
      required final double sufficientPct,
      required final int overstockCount,
      required final double overstockPct,
      required final int recountCount,
      required final double recountPct,
      required final int totalReorderNeeded}) = _$HealthSummaryImpl;

  @override
  int get totalProducts;
  @override
  int get urgentCount;
  @override
  double get urgentPct;
  @override
  int get normalCount;
  @override
  double get normalPct;
  @override
  int get sufficientCount;
  @override
  double get sufficientPct;
  @override
  int get overstockCount;
  @override
  double get overstockPct;
  @override
  int get recountCount;
  @override
  double get recountPct;
  @override
  int get totalReorderNeeded;

  /// Create a copy of HealthSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HealthSummaryImplCopyWith<_$HealthSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$HealthCategory {
  String get categoryId => throw _privateConstructorUsedError;
  String get categoryName => throw _privateConstructorUsedError;
  int get totalProducts => throw _privateConstructorUsedError;
  int get urgentCount => throw _privateConstructorUsedError;
  int get normalCount => throw _privateConstructorUsedError;
  int get sufficientCount => throw _privateConstructorUsedError;
  int get overstockCount => throw _privateConstructorUsedError;
  int get recountCount => throw _privateConstructorUsedError;
  int get urgencyScore => throw _privateConstructorUsedError;
  String get urgencyLevel => throw _privateConstructorUsedError;

  /// Create a copy of HealthCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HealthCategoryCopyWith<HealthCategory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HealthCategoryCopyWith<$Res> {
  factory $HealthCategoryCopyWith(
          HealthCategory value, $Res Function(HealthCategory) then) =
      _$HealthCategoryCopyWithImpl<$Res, HealthCategory>;
  @useResult
  $Res call(
      {String categoryId,
      String categoryName,
      int totalProducts,
      int urgentCount,
      int normalCount,
      int sufficientCount,
      int overstockCount,
      int recountCount,
      int urgencyScore,
      String urgencyLevel});
}

/// @nodoc
class _$HealthCategoryCopyWithImpl<$Res, $Val extends HealthCategory>
    implements $HealthCategoryCopyWith<$Res> {
  _$HealthCategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HealthCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryId = null,
    Object? categoryName = null,
    Object? totalProducts = null,
    Object? urgentCount = null,
    Object? normalCount = null,
    Object? sufficientCount = null,
    Object? overstockCount = null,
    Object? recountCount = null,
    Object? urgencyScore = null,
    Object? urgencyLevel = null,
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
      totalProducts: null == totalProducts
          ? _value.totalProducts
          : totalProducts // ignore: cast_nullable_to_non_nullable
              as int,
      urgentCount: null == urgentCount
          ? _value.urgentCount
          : urgentCount // ignore: cast_nullable_to_non_nullable
              as int,
      normalCount: null == normalCount
          ? _value.normalCount
          : normalCount // ignore: cast_nullable_to_non_nullable
              as int,
      sufficientCount: null == sufficientCount
          ? _value.sufficientCount
          : sufficientCount // ignore: cast_nullable_to_non_nullable
              as int,
      overstockCount: null == overstockCount
          ? _value.overstockCount
          : overstockCount // ignore: cast_nullable_to_non_nullable
              as int,
      recountCount: null == recountCount
          ? _value.recountCount
          : recountCount // ignore: cast_nullable_to_non_nullable
              as int,
      urgencyScore: null == urgencyScore
          ? _value.urgencyScore
          : urgencyScore // ignore: cast_nullable_to_non_nullable
              as int,
      urgencyLevel: null == urgencyLevel
          ? _value.urgencyLevel
          : urgencyLevel // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HealthCategoryImplCopyWith<$Res>
    implements $HealthCategoryCopyWith<$Res> {
  factory _$$HealthCategoryImplCopyWith(_$HealthCategoryImpl value,
          $Res Function(_$HealthCategoryImpl) then) =
      __$$HealthCategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String categoryId,
      String categoryName,
      int totalProducts,
      int urgentCount,
      int normalCount,
      int sufficientCount,
      int overstockCount,
      int recountCount,
      int urgencyScore,
      String urgencyLevel});
}

/// @nodoc
class __$$HealthCategoryImplCopyWithImpl<$Res>
    extends _$HealthCategoryCopyWithImpl<$Res, _$HealthCategoryImpl>
    implements _$$HealthCategoryImplCopyWith<$Res> {
  __$$HealthCategoryImplCopyWithImpl(
      _$HealthCategoryImpl _value, $Res Function(_$HealthCategoryImpl) _then)
      : super(_value, _then);

  /// Create a copy of HealthCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryId = null,
    Object? categoryName = null,
    Object? totalProducts = null,
    Object? urgentCount = null,
    Object? normalCount = null,
    Object? sufficientCount = null,
    Object? overstockCount = null,
    Object? recountCount = null,
    Object? urgencyScore = null,
    Object? urgencyLevel = null,
  }) {
    return _then(_$HealthCategoryImpl(
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      categoryName: null == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String,
      totalProducts: null == totalProducts
          ? _value.totalProducts
          : totalProducts // ignore: cast_nullable_to_non_nullable
              as int,
      urgentCount: null == urgentCount
          ? _value.urgentCount
          : urgentCount // ignore: cast_nullable_to_non_nullable
              as int,
      normalCount: null == normalCount
          ? _value.normalCount
          : normalCount // ignore: cast_nullable_to_non_nullable
              as int,
      sufficientCount: null == sufficientCount
          ? _value.sufficientCount
          : sufficientCount // ignore: cast_nullable_to_non_nullable
              as int,
      overstockCount: null == overstockCount
          ? _value.overstockCount
          : overstockCount // ignore: cast_nullable_to_non_nullable
              as int,
      recountCount: null == recountCount
          ? _value.recountCount
          : recountCount // ignore: cast_nullable_to_non_nullable
              as int,
      urgencyScore: null == urgencyScore
          ? _value.urgencyScore
          : urgencyScore // ignore: cast_nullable_to_non_nullable
              as int,
      urgencyLevel: null == urgencyLevel
          ? _value.urgencyLevel
          : urgencyLevel // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$HealthCategoryImpl extends _HealthCategory {
  const _$HealthCategoryImpl(
      {required this.categoryId,
      required this.categoryName,
      required this.totalProducts,
      required this.urgentCount,
      required this.normalCount,
      required this.sufficientCount,
      required this.overstockCount,
      required this.recountCount,
      required this.urgencyScore,
      required this.urgencyLevel})
      : super._();

  @override
  final String categoryId;
  @override
  final String categoryName;
  @override
  final int totalProducts;
  @override
  final int urgentCount;
  @override
  final int normalCount;
  @override
  final int sufficientCount;
  @override
  final int overstockCount;
  @override
  final int recountCount;
  @override
  final int urgencyScore;
  @override
  final String urgencyLevel;

  @override
  String toString() {
    return 'HealthCategory(categoryId: $categoryId, categoryName: $categoryName, totalProducts: $totalProducts, urgentCount: $urgentCount, normalCount: $normalCount, sufficientCount: $sufficientCount, overstockCount: $overstockCount, recountCount: $recountCount, urgencyScore: $urgencyScore, urgencyLevel: $urgencyLevel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HealthCategoryImpl &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.totalProducts, totalProducts) ||
                other.totalProducts == totalProducts) &&
            (identical(other.urgentCount, urgentCount) ||
                other.urgentCount == urgentCount) &&
            (identical(other.normalCount, normalCount) ||
                other.normalCount == normalCount) &&
            (identical(other.sufficientCount, sufficientCount) ||
                other.sufficientCount == sufficientCount) &&
            (identical(other.overstockCount, overstockCount) ||
                other.overstockCount == overstockCount) &&
            (identical(other.recountCount, recountCount) ||
                other.recountCount == recountCount) &&
            (identical(other.urgencyScore, urgencyScore) ||
                other.urgencyScore == urgencyScore) &&
            (identical(other.urgencyLevel, urgencyLevel) ||
                other.urgencyLevel == urgencyLevel));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      categoryId,
      categoryName,
      totalProducts,
      urgentCount,
      normalCount,
      sufficientCount,
      overstockCount,
      recountCount,
      urgencyScore,
      urgencyLevel);

  /// Create a copy of HealthCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HealthCategoryImplCopyWith<_$HealthCategoryImpl> get copyWith =>
      __$$HealthCategoryImplCopyWithImpl<_$HealthCategoryImpl>(
          this, _$identity);
}

abstract class _HealthCategory extends HealthCategory {
  const factory _HealthCategory(
      {required final String categoryId,
      required final String categoryName,
      required final int totalProducts,
      required final int urgentCount,
      required final int normalCount,
      required final int sufficientCount,
      required final int overstockCount,
      required final int recountCount,
      required final int urgencyScore,
      required final String urgencyLevel}) = _$HealthCategoryImpl;
  const _HealthCategory._() : super._();

  @override
  String get categoryId;
  @override
  String get categoryName;
  @override
  int get totalProducts;
  @override
  int get urgentCount;
  @override
  int get normalCount;
  @override
  int get sufficientCount;
  @override
  int get overstockCount;
  @override
  int get recountCount;
  @override
  int get urgencyScore;
  @override
  String get urgencyLevel;

  /// Create a copy of HealthCategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HealthCategoryImplCopyWith<_$HealthCategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$HealthProduct {
  String get productId => throw _privateConstructorUsedError;
  String get productName => throw _privateConstructorUsedError;
  String? get sku => throw _privateConstructorUsedError;
  String? get variantId => throw _privateConstructorUsedError;
  String? get variantName => throw _privateConstructorUsedError;
  String get categoryName => throw _privateConstructorUsedError;
  String? get brandName => throw _privateConstructorUsedError;
  int get currentStock => throw _privateConstructorUsedError;
  double get avgDailySales => throw _privateConstructorUsedError;
  double get daysOfInventory => throw _privateConstructorUsedError;
  int get leadTimeDays => throw _privateConstructorUsedError;
  double get daysUntilStockout => throw _privateConstructorUsedError;
  DateTime? get estimatedStockoutDate => throw _privateConstructorUsedError;
  String get urgencyReason => throw _privateConstructorUsedError;

  /// 주문 수량 관련 필드 (v1.2)
  int get safetyStock => throw _privateConstructorUsedError;
  int get reorderPoint => throw _privateConstructorUsedError;
  int get targetStock => throw _privateConstructorUsedError;
  int get recommendedOrderQty => throw _privateConstructorUsedError;

  /// Create a copy of HealthProduct
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HealthProductCopyWith<HealthProduct> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HealthProductCopyWith<$Res> {
  factory $HealthProductCopyWith(
          HealthProduct value, $Res Function(HealthProduct) then) =
      _$HealthProductCopyWithImpl<$Res, HealthProduct>;
  @useResult
  $Res call(
      {String productId,
      String productName,
      String? sku,
      String? variantId,
      String? variantName,
      String categoryName,
      String? brandName,
      int currentStock,
      double avgDailySales,
      double daysOfInventory,
      int leadTimeDays,
      double daysUntilStockout,
      DateTime? estimatedStockoutDate,
      String urgencyReason,
      int safetyStock,
      int reorderPoint,
      int targetStock,
      int recommendedOrderQty});
}

/// @nodoc
class _$HealthProductCopyWithImpl<$Res, $Val extends HealthProduct>
    implements $HealthProductCopyWith<$Res> {
  _$HealthProductCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HealthProduct
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? productName = null,
    Object? sku = freezed,
    Object? variantId = freezed,
    Object? variantName = freezed,
    Object? categoryName = null,
    Object? brandName = freezed,
    Object? currentStock = null,
    Object? avgDailySales = null,
    Object? daysOfInventory = null,
    Object? leadTimeDays = null,
    Object? daysUntilStockout = null,
    Object? estimatedStockoutDate = freezed,
    Object? urgencyReason = null,
    Object? safetyStock = null,
    Object? reorderPoint = null,
    Object? targetStock = null,
    Object? recommendedOrderQty = null,
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
      sku: freezed == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String?,
      variantId: freezed == variantId
          ? _value.variantId
          : variantId // ignore: cast_nullable_to_non_nullable
              as String?,
      variantName: freezed == variantName
          ? _value.variantName
          : variantName // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryName: null == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String,
      brandName: freezed == brandName
          ? _value.brandName
          : brandName // ignore: cast_nullable_to_non_nullable
              as String?,
      currentStock: null == currentStock
          ? _value.currentStock
          : currentStock // ignore: cast_nullable_to_non_nullable
              as int,
      avgDailySales: null == avgDailySales
          ? _value.avgDailySales
          : avgDailySales // ignore: cast_nullable_to_non_nullable
              as double,
      daysOfInventory: null == daysOfInventory
          ? _value.daysOfInventory
          : daysOfInventory // ignore: cast_nullable_to_non_nullable
              as double,
      leadTimeDays: null == leadTimeDays
          ? _value.leadTimeDays
          : leadTimeDays // ignore: cast_nullable_to_non_nullable
              as int,
      daysUntilStockout: null == daysUntilStockout
          ? _value.daysUntilStockout
          : daysUntilStockout // ignore: cast_nullable_to_non_nullable
              as double,
      estimatedStockoutDate: freezed == estimatedStockoutDate
          ? _value.estimatedStockoutDate
          : estimatedStockoutDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      urgencyReason: null == urgencyReason
          ? _value.urgencyReason
          : urgencyReason // ignore: cast_nullable_to_non_nullable
              as String,
      safetyStock: null == safetyStock
          ? _value.safetyStock
          : safetyStock // ignore: cast_nullable_to_non_nullable
              as int,
      reorderPoint: null == reorderPoint
          ? _value.reorderPoint
          : reorderPoint // ignore: cast_nullable_to_non_nullable
              as int,
      targetStock: null == targetStock
          ? _value.targetStock
          : targetStock // ignore: cast_nullable_to_non_nullable
              as int,
      recommendedOrderQty: null == recommendedOrderQty
          ? _value.recommendedOrderQty
          : recommendedOrderQty // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HealthProductImplCopyWith<$Res>
    implements $HealthProductCopyWith<$Res> {
  factory _$$HealthProductImplCopyWith(
          _$HealthProductImpl value, $Res Function(_$HealthProductImpl) then) =
      __$$HealthProductImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String productId,
      String productName,
      String? sku,
      String? variantId,
      String? variantName,
      String categoryName,
      String? brandName,
      int currentStock,
      double avgDailySales,
      double daysOfInventory,
      int leadTimeDays,
      double daysUntilStockout,
      DateTime? estimatedStockoutDate,
      String urgencyReason,
      int safetyStock,
      int reorderPoint,
      int targetStock,
      int recommendedOrderQty});
}

/// @nodoc
class __$$HealthProductImplCopyWithImpl<$Res>
    extends _$HealthProductCopyWithImpl<$Res, _$HealthProductImpl>
    implements _$$HealthProductImplCopyWith<$Res> {
  __$$HealthProductImplCopyWithImpl(
      _$HealthProductImpl _value, $Res Function(_$HealthProductImpl) _then)
      : super(_value, _then);

  /// Create a copy of HealthProduct
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? productName = null,
    Object? sku = freezed,
    Object? variantId = freezed,
    Object? variantName = freezed,
    Object? categoryName = null,
    Object? brandName = freezed,
    Object? currentStock = null,
    Object? avgDailySales = null,
    Object? daysOfInventory = null,
    Object? leadTimeDays = null,
    Object? daysUntilStockout = null,
    Object? estimatedStockoutDate = freezed,
    Object? urgencyReason = null,
    Object? safetyStock = null,
    Object? reorderPoint = null,
    Object? targetStock = null,
    Object? recommendedOrderQty = null,
  }) {
    return _then(_$HealthProductImpl(
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      sku: freezed == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String?,
      variantId: freezed == variantId
          ? _value.variantId
          : variantId // ignore: cast_nullable_to_non_nullable
              as String?,
      variantName: freezed == variantName
          ? _value.variantName
          : variantName // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryName: null == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String,
      brandName: freezed == brandName
          ? _value.brandName
          : brandName // ignore: cast_nullable_to_non_nullable
              as String?,
      currentStock: null == currentStock
          ? _value.currentStock
          : currentStock // ignore: cast_nullable_to_non_nullable
              as int,
      avgDailySales: null == avgDailySales
          ? _value.avgDailySales
          : avgDailySales // ignore: cast_nullable_to_non_nullable
              as double,
      daysOfInventory: null == daysOfInventory
          ? _value.daysOfInventory
          : daysOfInventory // ignore: cast_nullable_to_non_nullable
              as double,
      leadTimeDays: null == leadTimeDays
          ? _value.leadTimeDays
          : leadTimeDays // ignore: cast_nullable_to_non_nullable
              as int,
      daysUntilStockout: null == daysUntilStockout
          ? _value.daysUntilStockout
          : daysUntilStockout // ignore: cast_nullable_to_non_nullable
              as double,
      estimatedStockoutDate: freezed == estimatedStockoutDate
          ? _value.estimatedStockoutDate
          : estimatedStockoutDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      urgencyReason: null == urgencyReason
          ? _value.urgencyReason
          : urgencyReason // ignore: cast_nullable_to_non_nullable
              as String,
      safetyStock: null == safetyStock
          ? _value.safetyStock
          : safetyStock // ignore: cast_nullable_to_non_nullable
              as int,
      reorderPoint: null == reorderPoint
          ? _value.reorderPoint
          : reorderPoint // ignore: cast_nullable_to_non_nullable
              as int,
      targetStock: null == targetStock
          ? _value.targetStock
          : targetStock // ignore: cast_nullable_to_non_nullable
              as int,
      recommendedOrderQty: null == recommendedOrderQty
          ? _value.recommendedOrderQty
          : recommendedOrderQty // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$HealthProductImpl implements _HealthProduct {
  const _$HealthProductImpl(
      {required this.productId,
      required this.productName,
      required this.sku,
      required this.variantId,
      required this.variantName,
      required this.categoryName,
      required this.brandName,
      required this.currentStock,
      required this.avgDailySales,
      required this.daysOfInventory,
      required this.leadTimeDays,
      required this.daysUntilStockout,
      required this.estimatedStockoutDate,
      required this.urgencyReason,
      required this.safetyStock,
      required this.reorderPoint,
      required this.targetStock,
      required this.recommendedOrderQty});

  @override
  final String productId;
  @override
  final String productName;
  @override
  final String? sku;
  @override
  final String? variantId;
  @override
  final String? variantName;
  @override
  final String categoryName;
  @override
  final String? brandName;
  @override
  final int currentStock;
  @override
  final double avgDailySales;
  @override
  final double daysOfInventory;
  @override
  final int leadTimeDays;
  @override
  final double daysUntilStockout;
  @override
  final DateTime? estimatedStockoutDate;
  @override
  final String urgencyReason;

  /// 주문 수량 관련 필드 (v1.2)
  @override
  final int safetyStock;
  @override
  final int reorderPoint;
  @override
  final int targetStock;
  @override
  final int recommendedOrderQty;

  @override
  String toString() {
    return 'HealthProduct(productId: $productId, productName: $productName, sku: $sku, variantId: $variantId, variantName: $variantName, categoryName: $categoryName, brandName: $brandName, currentStock: $currentStock, avgDailySales: $avgDailySales, daysOfInventory: $daysOfInventory, leadTimeDays: $leadTimeDays, daysUntilStockout: $daysUntilStockout, estimatedStockoutDate: $estimatedStockoutDate, urgencyReason: $urgencyReason, safetyStock: $safetyStock, reorderPoint: $reorderPoint, targetStock: $targetStock, recommendedOrderQty: $recommendedOrderQty)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HealthProductImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.variantId, variantId) ||
                other.variantId == variantId) &&
            (identical(other.variantName, variantName) ||
                other.variantName == variantName) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.brandName, brandName) ||
                other.brandName == brandName) &&
            (identical(other.currentStock, currentStock) ||
                other.currentStock == currentStock) &&
            (identical(other.avgDailySales, avgDailySales) ||
                other.avgDailySales == avgDailySales) &&
            (identical(other.daysOfInventory, daysOfInventory) ||
                other.daysOfInventory == daysOfInventory) &&
            (identical(other.leadTimeDays, leadTimeDays) ||
                other.leadTimeDays == leadTimeDays) &&
            (identical(other.daysUntilStockout, daysUntilStockout) ||
                other.daysUntilStockout == daysUntilStockout) &&
            (identical(other.estimatedStockoutDate, estimatedStockoutDate) ||
                other.estimatedStockoutDate == estimatedStockoutDate) &&
            (identical(other.urgencyReason, urgencyReason) ||
                other.urgencyReason == urgencyReason) &&
            (identical(other.safetyStock, safetyStock) ||
                other.safetyStock == safetyStock) &&
            (identical(other.reorderPoint, reorderPoint) ||
                other.reorderPoint == reorderPoint) &&
            (identical(other.targetStock, targetStock) ||
                other.targetStock == targetStock) &&
            (identical(other.recommendedOrderQty, recommendedOrderQty) ||
                other.recommendedOrderQty == recommendedOrderQty));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      productId,
      productName,
      sku,
      variantId,
      variantName,
      categoryName,
      brandName,
      currentStock,
      avgDailySales,
      daysOfInventory,
      leadTimeDays,
      daysUntilStockout,
      estimatedStockoutDate,
      urgencyReason,
      safetyStock,
      reorderPoint,
      targetStock,
      recommendedOrderQty);

  /// Create a copy of HealthProduct
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HealthProductImplCopyWith<_$HealthProductImpl> get copyWith =>
      __$$HealthProductImplCopyWithImpl<_$HealthProductImpl>(this, _$identity);
}

abstract class _HealthProduct implements HealthProduct {
  const factory _HealthProduct(
      {required final String productId,
      required final String productName,
      required final String? sku,
      required final String? variantId,
      required final String? variantName,
      required final String categoryName,
      required final String? brandName,
      required final int currentStock,
      required final double avgDailySales,
      required final double daysOfInventory,
      required final int leadTimeDays,
      required final double daysUntilStockout,
      required final DateTime? estimatedStockoutDate,
      required final String urgencyReason,
      required final int safetyStock,
      required final int reorderPoint,
      required final int targetStock,
      required final int recommendedOrderQty}) = _$HealthProductImpl;

  @override
  String get productId;
  @override
  String get productName;
  @override
  String? get sku;
  @override
  String? get variantId;
  @override
  String? get variantName;
  @override
  String get categoryName;
  @override
  String? get brandName;
  @override
  int get currentStock;
  @override
  double get avgDailySales;
  @override
  double get daysOfInventory;
  @override
  int get leadTimeDays;
  @override
  double get daysUntilStockout;
  @override
  DateTime? get estimatedStockoutDate;
  @override
  String get urgencyReason;

  /// 주문 수량 관련 필드 (v1.2)
  @override
  int get safetyStock;
  @override
  int get reorderPoint;
  @override
  int get targetStock;
  @override
  int get recommendedOrderQty;

  /// Create a copy of HealthProduct
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HealthProductImplCopyWith<_$HealthProductImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$OverstockProduct {
  String get productId => throw _privateConstructorUsedError;
  String get productName => throw _privateConstructorUsedError;
  String? get sku => throw _privateConstructorUsedError;
  String? get variantId => throw _privateConstructorUsedError;
  String? get variantName => throw _privateConstructorUsedError;
  String get categoryName => throw _privateConstructorUsedError;
  String? get brandName => throw _privateConstructorUsedError;
  int get currentStock => throw _privateConstructorUsedError;
  double get avgDailySales => throw _privateConstructorUsedError;
  double get daysOfInventory => throw _privateConstructorUsedError;
  double get monthsOfInventory => throw _privateConstructorUsedError;
  String get overstockReason => throw _privateConstructorUsedError;

  /// 주문 수량 관련 필드 (v1.2)
  int get safetyStock => throw _privateConstructorUsedError;
  int get targetStock => throw _privateConstructorUsedError;
  int get recommendedOrderQty => throw _privateConstructorUsedError;

  /// Create a copy of OverstockProduct
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OverstockProductCopyWith<OverstockProduct> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OverstockProductCopyWith<$Res> {
  factory $OverstockProductCopyWith(
          OverstockProduct value, $Res Function(OverstockProduct) then) =
      _$OverstockProductCopyWithImpl<$Res, OverstockProduct>;
  @useResult
  $Res call(
      {String productId,
      String productName,
      String? sku,
      String? variantId,
      String? variantName,
      String categoryName,
      String? brandName,
      int currentStock,
      double avgDailySales,
      double daysOfInventory,
      double monthsOfInventory,
      String overstockReason,
      int safetyStock,
      int targetStock,
      int recommendedOrderQty});
}

/// @nodoc
class _$OverstockProductCopyWithImpl<$Res, $Val extends OverstockProduct>
    implements $OverstockProductCopyWith<$Res> {
  _$OverstockProductCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OverstockProduct
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? productName = null,
    Object? sku = freezed,
    Object? variantId = freezed,
    Object? variantName = freezed,
    Object? categoryName = null,
    Object? brandName = freezed,
    Object? currentStock = null,
    Object? avgDailySales = null,
    Object? daysOfInventory = null,
    Object? monthsOfInventory = null,
    Object? overstockReason = null,
    Object? safetyStock = null,
    Object? targetStock = null,
    Object? recommendedOrderQty = null,
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
      sku: freezed == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String?,
      variantId: freezed == variantId
          ? _value.variantId
          : variantId // ignore: cast_nullable_to_non_nullable
              as String?,
      variantName: freezed == variantName
          ? _value.variantName
          : variantName // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryName: null == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String,
      brandName: freezed == brandName
          ? _value.brandName
          : brandName // ignore: cast_nullable_to_non_nullable
              as String?,
      currentStock: null == currentStock
          ? _value.currentStock
          : currentStock // ignore: cast_nullable_to_non_nullable
              as int,
      avgDailySales: null == avgDailySales
          ? _value.avgDailySales
          : avgDailySales // ignore: cast_nullable_to_non_nullable
              as double,
      daysOfInventory: null == daysOfInventory
          ? _value.daysOfInventory
          : daysOfInventory // ignore: cast_nullable_to_non_nullable
              as double,
      monthsOfInventory: null == monthsOfInventory
          ? _value.monthsOfInventory
          : monthsOfInventory // ignore: cast_nullable_to_non_nullable
              as double,
      overstockReason: null == overstockReason
          ? _value.overstockReason
          : overstockReason // ignore: cast_nullable_to_non_nullable
              as String,
      safetyStock: null == safetyStock
          ? _value.safetyStock
          : safetyStock // ignore: cast_nullable_to_non_nullable
              as int,
      targetStock: null == targetStock
          ? _value.targetStock
          : targetStock // ignore: cast_nullable_to_non_nullable
              as int,
      recommendedOrderQty: null == recommendedOrderQty
          ? _value.recommendedOrderQty
          : recommendedOrderQty // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OverstockProductImplCopyWith<$Res>
    implements $OverstockProductCopyWith<$Res> {
  factory _$$OverstockProductImplCopyWith(_$OverstockProductImpl value,
          $Res Function(_$OverstockProductImpl) then) =
      __$$OverstockProductImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String productId,
      String productName,
      String? sku,
      String? variantId,
      String? variantName,
      String categoryName,
      String? brandName,
      int currentStock,
      double avgDailySales,
      double daysOfInventory,
      double monthsOfInventory,
      String overstockReason,
      int safetyStock,
      int targetStock,
      int recommendedOrderQty});
}

/// @nodoc
class __$$OverstockProductImplCopyWithImpl<$Res>
    extends _$OverstockProductCopyWithImpl<$Res, _$OverstockProductImpl>
    implements _$$OverstockProductImplCopyWith<$Res> {
  __$$OverstockProductImplCopyWithImpl(_$OverstockProductImpl _value,
      $Res Function(_$OverstockProductImpl) _then)
      : super(_value, _then);

  /// Create a copy of OverstockProduct
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? productName = null,
    Object? sku = freezed,
    Object? variantId = freezed,
    Object? variantName = freezed,
    Object? categoryName = null,
    Object? brandName = freezed,
    Object? currentStock = null,
    Object? avgDailySales = null,
    Object? daysOfInventory = null,
    Object? monthsOfInventory = null,
    Object? overstockReason = null,
    Object? safetyStock = null,
    Object? targetStock = null,
    Object? recommendedOrderQty = null,
  }) {
    return _then(_$OverstockProductImpl(
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      sku: freezed == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String?,
      variantId: freezed == variantId
          ? _value.variantId
          : variantId // ignore: cast_nullable_to_non_nullable
              as String?,
      variantName: freezed == variantName
          ? _value.variantName
          : variantName // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryName: null == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String,
      brandName: freezed == brandName
          ? _value.brandName
          : brandName // ignore: cast_nullable_to_non_nullable
              as String?,
      currentStock: null == currentStock
          ? _value.currentStock
          : currentStock // ignore: cast_nullable_to_non_nullable
              as int,
      avgDailySales: null == avgDailySales
          ? _value.avgDailySales
          : avgDailySales // ignore: cast_nullable_to_non_nullable
              as double,
      daysOfInventory: null == daysOfInventory
          ? _value.daysOfInventory
          : daysOfInventory // ignore: cast_nullable_to_non_nullable
              as double,
      monthsOfInventory: null == monthsOfInventory
          ? _value.monthsOfInventory
          : monthsOfInventory // ignore: cast_nullable_to_non_nullable
              as double,
      overstockReason: null == overstockReason
          ? _value.overstockReason
          : overstockReason // ignore: cast_nullable_to_non_nullable
              as String,
      safetyStock: null == safetyStock
          ? _value.safetyStock
          : safetyStock // ignore: cast_nullable_to_non_nullable
              as int,
      targetStock: null == targetStock
          ? _value.targetStock
          : targetStock // ignore: cast_nullable_to_non_nullable
              as int,
      recommendedOrderQty: null == recommendedOrderQty
          ? _value.recommendedOrderQty
          : recommendedOrderQty // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$OverstockProductImpl implements _OverstockProduct {
  const _$OverstockProductImpl(
      {required this.productId,
      required this.productName,
      required this.sku,
      required this.variantId,
      required this.variantName,
      required this.categoryName,
      required this.brandName,
      required this.currentStock,
      required this.avgDailySales,
      required this.daysOfInventory,
      required this.monthsOfInventory,
      required this.overstockReason,
      required this.safetyStock,
      required this.targetStock,
      required this.recommendedOrderQty});

  @override
  final String productId;
  @override
  final String productName;
  @override
  final String? sku;
  @override
  final String? variantId;
  @override
  final String? variantName;
  @override
  final String categoryName;
  @override
  final String? brandName;
  @override
  final int currentStock;
  @override
  final double avgDailySales;
  @override
  final double daysOfInventory;
  @override
  final double monthsOfInventory;
  @override
  final String overstockReason;

  /// 주문 수량 관련 필드 (v1.2)
  @override
  final int safetyStock;
  @override
  final int targetStock;
  @override
  final int recommendedOrderQty;

  @override
  String toString() {
    return 'OverstockProduct(productId: $productId, productName: $productName, sku: $sku, variantId: $variantId, variantName: $variantName, categoryName: $categoryName, brandName: $brandName, currentStock: $currentStock, avgDailySales: $avgDailySales, daysOfInventory: $daysOfInventory, monthsOfInventory: $monthsOfInventory, overstockReason: $overstockReason, safetyStock: $safetyStock, targetStock: $targetStock, recommendedOrderQty: $recommendedOrderQty)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OverstockProductImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.variantId, variantId) ||
                other.variantId == variantId) &&
            (identical(other.variantName, variantName) ||
                other.variantName == variantName) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.brandName, brandName) ||
                other.brandName == brandName) &&
            (identical(other.currentStock, currentStock) ||
                other.currentStock == currentStock) &&
            (identical(other.avgDailySales, avgDailySales) ||
                other.avgDailySales == avgDailySales) &&
            (identical(other.daysOfInventory, daysOfInventory) ||
                other.daysOfInventory == daysOfInventory) &&
            (identical(other.monthsOfInventory, monthsOfInventory) ||
                other.monthsOfInventory == monthsOfInventory) &&
            (identical(other.overstockReason, overstockReason) ||
                other.overstockReason == overstockReason) &&
            (identical(other.safetyStock, safetyStock) ||
                other.safetyStock == safetyStock) &&
            (identical(other.targetStock, targetStock) ||
                other.targetStock == targetStock) &&
            (identical(other.recommendedOrderQty, recommendedOrderQty) ||
                other.recommendedOrderQty == recommendedOrderQty));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      productId,
      productName,
      sku,
      variantId,
      variantName,
      categoryName,
      brandName,
      currentStock,
      avgDailySales,
      daysOfInventory,
      monthsOfInventory,
      overstockReason,
      safetyStock,
      targetStock,
      recommendedOrderQty);

  /// Create a copy of OverstockProduct
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OverstockProductImplCopyWith<_$OverstockProductImpl> get copyWith =>
      __$$OverstockProductImplCopyWithImpl<_$OverstockProductImpl>(
          this, _$identity);
}

abstract class _OverstockProduct implements OverstockProduct {
  const factory _OverstockProduct(
      {required final String productId,
      required final String productName,
      required final String? sku,
      required final String? variantId,
      required final String? variantName,
      required final String categoryName,
      required final String? brandName,
      required final int currentStock,
      required final double avgDailySales,
      required final double daysOfInventory,
      required final double monthsOfInventory,
      required final String overstockReason,
      required final int safetyStock,
      required final int targetStock,
      required final int recommendedOrderQty}) = _$OverstockProductImpl;

  @override
  String get productId;
  @override
  String get productName;
  @override
  String? get sku;
  @override
  String? get variantId;
  @override
  String? get variantName;
  @override
  String get categoryName;
  @override
  String? get brandName;
  @override
  int get currentStock;
  @override
  double get avgDailySales;
  @override
  double get daysOfInventory;
  @override
  double get monthsOfInventory;
  @override
  String get overstockReason;

  /// 주문 수량 관련 필드 (v1.2)
  @override
  int get safetyStock;
  @override
  int get targetStock;
  @override
  int get recommendedOrderQty;

  /// Create a copy of OverstockProduct
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OverstockProductImplCopyWith<_$OverstockProductImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$RecountProduct {
  String get productId => throw _privateConstructorUsedError;
  String get productName => throw _privateConstructorUsedError;
  String? get sku => throw _privateConstructorUsedError;
  String? get variantId => throw _privateConstructorUsedError;
  String? get variantName => throw _privateConstructorUsedError;
  String get categoryName => throw _privateConstructorUsedError;
  String? get brandName => throw _privateConstructorUsedError;
  int get currentStock => throw _privateConstructorUsedError; // negative value
  String get recountReason => throw _privateConstructorUsedError;

  /// Create a copy of RecountProduct
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecountProductCopyWith<RecountProduct> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecountProductCopyWith<$Res> {
  factory $RecountProductCopyWith(
          RecountProduct value, $Res Function(RecountProduct) then) =
      _$RecountProductCopyWithImpl<$Res, RecountProduct>;
  @useResult
  $Res call(
      {String productId,
      String productName,
      String? sku,
      String? variantId,
      String? variantName,
      String categoryName,
      String? brandName,
      int currentStock,
      String recountReason});
}

/// @nodoc
class _$RecountProductCopyWithImpl<$Res, $Val extends RecountProduct>
    implements $RecountProductCopyWith<$Res> {
  _$RecountProductCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecountProduct
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? productName = null,
    Object? sku = freezed,
    Object? variantId = freezed,
    Object? variantName = freezed,
    Object? categoryName = null,
    Object? brandName = freezed,
    Object? currentStock = null,
    Object? recountReason = null,
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
      sku: freezed == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String?,
      variantId: freezed == variantId
          ? _value.variantId
          : variantId // ignore: cast_nullable_to_non_nullable
              as String?,
      variantName: freezed == variantName
          ? _value.variantName
          : variantName // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryName: null == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String,
      brandName: freezed == brandName
          ? _value.brandName
          : brandName // ignore: cast_nullable_to_non_nullable
              as String?,
      currentStock: null == currentStock
          ? _value.currentStock
          : currentStock // ignore: cast_nullable_to_non_nullable
              as int,
      recountReason: null == recountReason
          ? _value.recountReason
          : recountReason // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecountProductImplCopyWith<$Res>
    implements $RecountProductCopyWith<$Res> {
  factory _$$RecountProductImplCopyWith(_$RecountProductImpl value,
          $Res Function(_$RecountProductImpl) then) =
      __$$RecountProductImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String productId,
      String productName,
      String? sku,
      String? variantId,
      String? variantName,
      String categoryName,
      String? brandName,
      int currentStock,
      String recountReason});
}

/// @nodoc
class __$$RecountProductImplCopyWithImpl<$Res>
    extends _$RecountProductCopyWithImpl<$Res, _$RecountProductImpl>
    implements _$$RecountProductImplCopyWith<$Res> {
  __$$RecountProductImplCopyWithImpl(
      _$RecountProductImpl _value, $Res Function(_$RecountProductImpl) _then)
      : super(_value, _then);

  /// Create a copy of RecountProduct
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? productName = null,
    Object? sku = freezed,
    Object? variantId = freezed,
    Object? variantName = freezed,
    Object? categoryName = null,
    Object? brandName = freezed,
    Object? currentStock = null,
    Object? recountReason = null,
  }) {
    return _then(_$RecountProductImpl(
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      sku: freezed == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String?,
      variantId: freezed == variantId
          ? _value.variantId
          : variantId // ignore: cast_nullable_to_non_nullable
              as String?,
      variantName: freezed == variantName
          ? _value.variantName
          : variantName // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryName: null == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String,
      brandName: freezed == brandName
          ? _value.brandName
          : brandName // ignore: cast_nullable_to_non_nullable
              as String?,
      currentStock: null == currentStock
          ? _value.currentStock
          : currentStock // ignore: cast_nullable_to_non_nullable
              as int,
      recountReason: null == recountReason
          ? _value.recountReason
          : recountReason // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$RecountProductImpl implements _RecountProduct {
  const _$RecountProductImpl(
      {required this.productId,
      required this.productName,
      required this.sku,
      required this.variantId,
      required this.variantName,
      required this.categoryName,
      required this.brandName,
      required this.currentStock,
      required this.recountReason});

  @override
  final String productId;
  @override
  final String productName;
  @override
  final String? sku;
  @override
  final String? variantId;
  @override
  final String? variantName;
  @override
  final String categoryName;
  @override
  final String? brandName;
  @override
  final int currentStock;
// negative value
  @override
  final String recountReason;

  @override
  String toString() {
    return 'RecountProduct(productId: $productId, productName: $productName, sku: $sku, variantId: $variantId, variantName: $variantName, categoryName: $categoryName, brandName: $brandName, currentStock: $currentStock, recountReason: $recountReason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecountProductImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.variantId, variantId) ||
                other.variantId == variantId) &&
            (identical(other.variantName, variantName) ||
                other.variantName == variantName) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.brandName, brandName) ||
                other.brandName == brandName) &&
            (identical(other.currentStock, currentStock) ||
                other.currentStock == currentStock) &&
            (identical(other.recountReason, recountReason) ||
                other.recountReason == recountReason));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      productId,
      productName,
      sku,
      variantId,
      variantName,
      categoryName,
      brandName,
      currentStock,
      recountReason);

  /// Create a copy of RecountProduct
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecountProductImplCopyWith<_$RecountProductImpl> get copyWith =>
      __$$RecountProductImplCopyWithImpl<_$RecountProductImpl>(
          this, _$identity);
}

abstract class _RecountProduct implements RecountProduct {
  const factory _RecountProduct(
      {required final String productId,
      required final String productName,
      required final String? sku,
      required final String? variantId,
      required final String? variantName,
      required final String categoryName,
      required final String? brandName,
      required final int currentStock,
      required final String recountReason}) = _$RecountProductImpl;

  @override
  String get productId;
  @override
  String get productName;
  @override
  String? get sku;
  @override
  String? get variantId;
  @override
  String? get variantName;
  @override
  String get categoryName;
  @override
  String? get brandName;
  @override
  int get currentStock; // negative value
  @override
  String get recountReason;

  /// Create a copy of RecountProduct
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecountProductImplCopyWith<_$RecountProductImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
