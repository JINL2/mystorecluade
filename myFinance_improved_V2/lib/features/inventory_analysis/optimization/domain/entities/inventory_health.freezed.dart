// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inventory_health.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$InventoryHealth {
  /// 전체 상품 수
  int get totalProducts => throw _privateConstructorUsedError;

  /// 품절 수
  int get stockoutCount => throw _privateConstructorUsedError;

  /// 품절률 (%)
  double get stockoutRate => throw _privateConstructorUsedError;

  /// 긴급 수 (P10 이하)
  int get criticalCount => throw _privateConstructorUsedError;

  /// 긴급률 (%)
  double get criticalRate => throw _privateConstructorUsedError;

  /// 주의 수 (P10~P25)
  int get warningCount => throw _privateConstructorUsedError;

  /// 주의율 (%)
  double get warningRate => throw _privateConstructorUsedError;

  /// 재주문 필요 수 (품절 제외)
  int get reorderNeededCount => throw _privateConstructorUsedError;

  /// 과잉 재고 수
  int get overstockCount => throw _privateConstructorUsedError;

  /// 과잉률 (%)
  double get overstockRate => throw _privateConstructorUsedError;

  /// Dead Stock 수 (90일간 판매 없음)
  int get deadStockCount => throw _privateConstructorUsedError;

  /// Dead Stock률 (%)
  double get deadStockRate => throw _privateConstructorUsedError;

  /// 비정상 수 (음수 재고)
  int get abnormalCount => throw _privateConstructorUsedError;

  /// 정상 수
  int get normalCount => throw _privateConstructorUsedError;

  /// Create a copy of InventoryHealth
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InventoryHealthCopyWith<InventoryHealth> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InventoryHealthCopyWith<$Res> {
  factory $InventoryHealthCopyWith(
          InventoryHealth value, $Res Function(InventoryHealth) then) =
      _$InventoryHealthCopyWithImpl<$Res, InventoryHealth>;
  @useResult
  $Res call(
      {int totalProducts,
      int stockoutCount,
      double stockoutRate,
      int criticalCount,
      double criticalRate,
      int warningCount,
      double warningRate,
      int reorderNeededCount,
      int overstockCount,
      double overstockRate,
      int deadStockCount,
      double deadStockRate,
      int abnormalCount,
      int normalCount});
}

/// @nodoc
class _$InventoryHealthCopyWithImpl<$Res, $Val extends InventoryHealth>
    implements $InventoryHealthCopyWith<$Res> {
  _$InventoryHealthCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InventoryHealth
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalProducts = null,
    Object? stockoutCount = null,
    Object? stockoutRate = null,
    Object? criticalCount = null,
    Object? criticalRate = null,
    Object? warningCount = null,
    Object? warningRate = null,
    Object? reorderNeededCount = null,
    Object? overstockCount = null,
    Object? overstockRate = null,
    Object? deadStockCount = null,
    Object? deadStockRate = null,
    Object? abnormalCount = null,
    Object? normalCount = null,
  }) {
    return _then(_value.copyWith(
      totalProducts: null == totalProducts
          ? _value.totalProducts
          : totalProducts // ignore: cast_nullable_to_non_nullable
              as int,
      stockoutCount: null == stockoutCount
          ? _value.stockoutCount
          : stockoutCount // ignore: cast_nullable_to_non_nullable
              as int,
      stockoutRate: null == stockoutRate
          ? _value.stockoutRate
          : stockoutRate // ignore: cast_nullable_to_non_nullable
              as double,
      criticalCount: null == criticalCount
          ? _value.criticalCount
          : criticalCount // ignore: cast_nullable_to_non_nullable
              as int,
      criticalRate: null == criticalRate
          ? _value.criticalRate
          : criticalRate // ignore: cast_nullable_to_non_nullable
              as double,
      warningCount: null == warningCount
          ? _value.warningCount
          : warningCount // ignore: cast_nullable_to_non_nullable
              as int,
      warningRate: null == warningRate
          ? _value.warningRate
          : warningRate // ignore: cast_nullable_to_non_nullable
              as double,
      reorderNeededCount: null == reorderNeededCount
          ? _value.reorderNeededCount
          : reorderNeededCount // ignore: cast_nullable_to_non_nullable
              as int,
      overstockCount: null == overstockCount
          ? _value.overstockCount
          : overstockCount // ignore: cast_nullable_to_non_nullable
              as int,
      overstockRate: null == overstockRate
          ? _value.overstockRate
          : overstockRate // ignore: cast_nullable_to_non_nullable
              as double,
      deadStockCount: null == deadStockCount
          ? _value.deadStockCount
          : deadStockCount // ignore: cast_nullable_to_non_nullable
              as int,
      deadStockRate: null == deadStockRate
          ? _value.deadStockRate
          : deadStockRate // ignore: cast_nullable_to_non_nullable
              as double,
      abnormalCount: null == abnormalCount
          ? _value.abnormalCount
          : abnormalCount // ignore: cast_nullable_to_non_nullable
              as int,
      normalCount: null == normalCount
          ? _value.normalCount
          : normalCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InventoryHealthImplCopyWith<$Res>
    implements $InventoryHealthCopyWith<$Res> {
  factory _$$InventoryHealthImplCopyWith(_$InventoryHealthImpl value,
          $Res Function(_$InventoryHealthImpl) then) =
      __$$InventoryHealthImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int totalProducts,
      int stockoutCount,
      double stockoutRate,
      int criticalCount,
      double criticalRate,
      int warningCount,
      double warningRate,
      int reorderNeededCount,
      int overstockCount,
      double overstockRate,
      int deadStockCount,
      double deadStockRate,
      int abnormalCount,
      int normalCount});
}

/// @nodoc
class __$$InventoryHealthImplCopyWithImpl<$Res>
    extends _$InventoryHealthCopyWithImpl<$Res, _$InventoryHealthImpl>
    implements _$$InventoryHealthImplCopyWith<$Res> {
  __$$InventoryHealthImplCopyWithImpl(
      _$InventoryHealthImpl _value, $Res Function(_$InventoryHealthImpl) _then)
      : super(_value, _then);

  /// Create a copy of InventoryHealth
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalProducts = null,
    Object? stockoutCount = null,
    Object? stockoutRate = null,
    Object? criticalCount = null,
    Object? criticalRate = null,
    Object? warningCount = null,
    Object? warningRate = null,
    Object? reorderNeededCount = null,
    Object? overstockCount = null,
    Object? overstockRate = null,
    Object? deadStockCount = null,
    Object? deadStockRate = null,
    Object? abnormalCount = null,
    Object? normalCount = null,
  }) {
    return _then(_$InventoryHealthImpl(
      totalProducts: null == totalProducts
          ? _value.totalProducts
          : totalProducts // ignore: cast_nullable_to_non_nullable
              as int,
      stockoutCount: null == stockoutCount
          ? _value.stockoutCount
          : stockoutCount // ignore: cast_nullable_to_non_nullable
              as int,
      stockoutRate: null == stockoutRate
          ? _value.stockoutRate
          : stockoutRate // ignore: cast_nullable_to_non_nullable
              as double,
      criticalCount: null == criticalCount
          ? _value.criticalCount
          : criticalCount // ignore: cast_nullable_to_non_nullable
              as int,
      criticalRate: null == criticalRate
          ? _value.criticalRate
          : criticalRate // ignore: cast_nullable_to_non_nullable
              as double,
      warningCount: null == warningCount
          ? _value.warningCount
          : warningCount // ignore: cast_nullable_to_non_nullable
              as int,
      warningRate: null == warningRate
          ? _value.warningRate
          : warningRate // ignore: cast_nullable_to_non_nullable
              as double,
      reorderNeededCount: null == reorderNeededCount
          ? _value.reorderNeededCount
          : reorderNeededCount // ignore: cast_nullable_to_non_nullable
              as int,
      overstockCount: null == overstockCount
          ? _value.overstockCount
          : overstockCount // ignore: cast_nullable_to_non_nullable
              as int,
      overstockRate: null == overstockRate
          ? _value.overstockRate
          : overstockRate // ignore: cast_nullable_to_non_nullable
              as double,
      deadStockCount: null == deadStockCount
          ? _value.deadStockCount
          : deadStockCount // ignore: cast_nullable_to_non_nullable
              as int,
      deadStockRate: null == deadStockRate
          ? _value.deadStockRate
          : deadStockRate // ignore: cast_nullable_to_non_nullable
              as double,
      abnormalCount: null == abnormalCount
          ? _value.abnormalCount
          : abnormalCount // ignore: cast_nullable_to_non_nullable
              as int,
      normalCount: null == normalCount
          ? _value.normalCount
          : normalCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$InventoryHealthImpl extends _InventoryHealth {
  const _$InventoryHealthImpl(
      {required this.totalProducts,
      required this.stockoutCount,
      required this.stockoutRate,
      required this.criticalCount,
      required this.criticalRate,
      required this.warningCount,
      required this.warningRate,
      required this.reorderNeededCount,
      required this.overstockCount,
      required this.overstockRate,
      required this.deadStockCount,
      required this.deadStockRate,
      required this.abnormalCount,
      required this.normalCount})
      : super._();

  /// 전체 상품 수
  @override
  final int totalProducts;

  /// 품절 수
  @override
  final int stockoutCount;

  /// 품절률 (%)
  @override
  final double stockoutRate;

  /// 긴급 수 (P10 이하)
  @override
  final int criticalCount;

  /// 긴급률 (%)
  @override
  final double criticalRate;

  /// 주의 수 (P10~P25)
  @override
  final int warningCount;

  /// 주의율 (%)
  @override
  final double warningRate;

  /// 재주문 필요 수 (품절 제외)
  @override
  final int reorderNeededCount;

  /// 과잉 재고 수
  @override
  final int overstockCount;

  /// 과잉률 (%)
  @override
  final double overstockRate;

  /// Dead Stock 수 (90일간 판매 없음)
  @override
  final int deadStockCount;

  /// Dead Stock률 (%)
  @override
  final double deadStockRate;

  /// 비정상 수 (음수 재고)
  @override
  final int abnormalCount;

  /// 정상 수
  @override
  final int normalCount;

  @override
  String toString() {
    return 'InventoryHealth(totalProducts: $totalProducts, stockoutCount: $stockoutCount, stockoutRate: $stockoutRate, criticalCount: $criticalCount, criticalRate: $criticalRate, warningCount: $warningCount, warningRate: $warningRate, reorderNeededCount: $reorderNeededCount, overstockCount: $overstockCount, overstockRate: $overstockRate, deadStockCount: $deadStockCount, deadStockRate: $deadStockRate, abnormalCount: $abnormalCount, normalCount: $normalCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InventoryHealthImpl &&
            (identical(other.totalProducts, totalProducts) ||
                other.totalProducts == totalProducts) &&
            (identical(other.stockoutCount, stockoutCount) ||
                other.stockoutCount == stockoutCount) &&
            (identical(other.stockoutRate, stockoutRate) ||
                other.stockoutRate == stockoutRate) &&
            (identical(other.criticalCount, criticalCount) ||
                other.criticalCount == criticalCount) &&
            (identical(other.criticalRate, criticalRate) ||
                other.criticalRate == criticalRate) &&
            (identical(other.warningCount, warningCount) ||
                other.warningCount == warningCount) &&
            (identical(other.warningRate, warningRate) ||
                other.warningRate == warningRate) &&
            (identical(other.reorderNeededCount, reorderNeededCount) ||
                other.reorderNeededCount == reorderNeededCount) &&
            (identical(other.overstockCount, overstockCount) ||
                other.overstockCount == overstockCount) &&
            (identical(other.overstockRate, overstockRate) ||
                other.overstockRate == overstockRate) &&
            (identical(other.deadStockCount, deadStockCount) ||
                other.deadStockCount == deadStockCount) &&
            (identical(other.deadStockRate, deadStockRate) ||
                other.deadStockRate == deadStockRate) &&
            (identical(other.abnormalCount, abnormalCount) ||
                other.abnormalCount == abnormalCount) &&
            (identical(other.normalCount, normalCount) ||
                other.normalCount == normalCount));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalProducts,
      stockoutCount,
      stockoutRate,
      criticalCount,
      criticalRate,
      warningCount,
      warningRate,
      reorderNeededCount,
      overstockCount,
      overstockRate,
      deadStockCount,
      deadStockRate,
      abnormalCount,
      normalCount);

  /// Create a copy of InventoryHealth
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InventoryHealthImplCopyWith<_$InventoryHealthImpl> get copyWith =>
      __$$InventoryHealthImplCopyWithImpl<_$InventoryHealthImpl>(
          this, _$identity);
}

abstract class _InventoryHealth extends InventoryHealth {
  const factory _InventoryHealth(
      {required final int totalProducts,
      required final int stockoutCount,
      required final double stockoutRate,
      required final int criticalCount,
      required final double criticalRate,
      required final int warningCount,
      required final double warningRate,
      required final int reorderNeededCount,
      required final int overstockCount,
      required final double overstockRate,
      required final int deadStockCount,
      required final double deadStockRate,
      required final int abnormalCount,
      required final int normalCount}) = _$InventoryHealthImpl;
  const _InventoryHealth._() : super._();

  /// 전체 상품 수
  @override
  int get totalProducts;

  /// 품절 수
  @override
  int get stockoutCount;

  /// 품절률 (%)
  @override
  double get stockoutRate;

  /// 긴급 수 (P10 이하)
  @override
  int get criticalCount;

  /// 긴급률 (%)
  @override
  double get criticalRate;

  /// 주의 수 (P10~P25)
  @override
  int get warningCount;

  /// 주의율 (%)
  @override
  double get warningRate;

  /// 재주문 필요 수 (품절 제외)
  @override
  int get reorderNeededCount;

  /// 과잉 재고 수
  @override
  int get overstockCount;

  /// 과잉률 (%)
  @override
  double get overstockRate;

  /// Dead Stock 수 (90일간 판매 없음)
  @override
  int get deadStockCount;

  /// Dead Stock률 (%)
  @override
  double get deadStockRate;

  /// 비정상 수 (음수 재고)
  @override
  int get abnormalCount;

  /// 정상 수
  @override
  int get normalCount;

  /// Create a copy of InventoryHealth
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InventoryHealthImplCopyWith<_$InventoryHealthImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
