// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inventory_product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$InventoryProduct {
  /// 상품 ID
  String get productId => throw _privateConstructorUsedError;

  /// 상품명
  String get productName => throw _privateConstructorUsedError;

  /// 카테고리 ID
  String? get categoryId => throw _privateConstructorUsedError;

  /// 카테고리명
  String? get categoryName => throw _privateConstructorUsedError;

  /// 브랜드명
  String? get brandName => throw _privateConstructorUsedError;

  /// 현재 재고
  int get currentStock => throw _privateConstructorUsedError;

  /// 재주문점
  int get reorderPoint => throw _privateConstructorUsedError;

  /// 일평균 판매량
  double get avgDailyDemand => throw _privateConstructorUsedError;

  /// 남은 재고일
  double get daysOfInventory => throw _privateConstructorUsedError;

  /// 상태 라벨 (abnormal, critical, warning, etc.)
  String get statusLabel => throw _privateConstructorUsedError;

  /// 우선순위
  int get priorityRank => throw _privateConstructorUsedError;

  /// 비정상 여부 (음수 재고)
  bool get isAbnormal => throw _privateConstructorUsedError;

  /// 품절 여부
  bool get isStockout => throw _privateConstructorUsedError;

  /// 긴급 여부
  bool get isCritical => throw _privateConstructorUsedError;

  /// 주의 여부
  bool get isWarning => throw _privateConstructorUsedError;

  /// 재주문 필요 여부
  bool get isReorderNeeded => throw _privateConstructorUsedError;

  /// 과잉 여부
  bool get isOverstock => throw _privateConstructorUsedError;

  /// Dead Stock 여부
  bool get isDeadStock => throw _privateConstructorUsedError;

  /// Create a copy of InventoryProduct
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InventoryProductCopyWith<InventoryProduct> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InventoryProductCopyWith<$Res> {
  factory $InventoryProductCopyWith(
          InventoryProduct value, $Res Function(InventoryProduct) then) =
      _$InventoryProductCopyWithImpl<$Res, InventoryProduct>;
  @useResult
  $Res call(
      {String productId,
      String productName,
      String? categoryId,
      String? categoryName,
      String? brandName,
      int currentStock,
      int reorderPoint,
      double avgDailyDemand,
      double daysOfInventory,
      String statusLabel,
      int priorityRank,
      bool isAbnormal,
      bool isStockout,
      bool isCritical,
      bool isWarning,
      bool isReorderNeeded,
      bool isOverstock,
      bool isDeadStock});
}

/// @nodoc
class _$InventoryProductCopyWithImpl<$Res, $Val extends InventoryProduct>
    implements $InventoryProductCopyWith<$Res> {
  _$InventoryProductCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InventoryProduct
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? productName = null,
    Object? categoryId = freezed,
    Object? categoryName = freezed,
    Object? brandName = freezed,
    Object? currentStock = null,
    Object? reorderPoint = null,
    Object? avgDailyDemand = null,
    Object? daysOfInventory = null,
    Object? statusLabel = null,
    Object? priorityRank = null,
    Object? isAbnormal = null,
    Object? isStockout = null,
    Object? isCritical = null,
    Object? isWarning = null,
    Object? isReorderNeeded = null,
    Object? isOverstock = null,
    Object? isDeadStock = null,
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
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryName: freezed == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String?,
      brandName: freezed == brandName
          ? _value.brandName
          : brandName // ignore: cast_nullable_to_non_nullable
              as String?,
      currentStock: null == currentStock
          ? _value.currentStock
          : currentStock // ignore: cast_nullable_to_non_nullable
              as int,
      reorderPoint: null == reorderPoint
          ? _value.reorderPoint
          : reorderPoint // ignore: cast_nullable_to_non_nullable
              as int,
      avgDailyDemand: null == avgDailyDemand
          ? _value.avgDailyDemand
          : avgDailyDemand // ignore: cast_nullable_to_non_nullable
              as double,
      daysOfInventory: null == daysOfInventory
          ? _value.daysOfInventory
          : daysOfInventory // ignore: cast_nullable_to_non_nullable
              as double,
      statusLabel: null == statusLabel
          ? _value.statusLabel
          : statusLabel // ignore: cast_nullable_to_non_nullable
              as String,
      priorityRank: null == priorityRank
          ? _value.priorityRank
          : priorityRank // ignore: cast_nullable_to_non_nullable
              as int,
      isAbnormal: null == isAbnormal
          ? _value.isAbnormal
          : isAbnormal // ignore: cast_nullable_to_non_nullable
              as bool,
      isStockout: null == isStockout
          ? _value.isStockout
          : isStockout // ignore: cast_nullable_to_non_nullable
              as bool,
      isCritical: null == isCritical
          ? _value.isCritical
          : isCritical // ignore: cast_nullable_to_non_nullable
              as bool,
      isWarning: null == isWarning
          ? _value.isWarning
          : isWarning // ignore: cast_nullable_to_non_nullable
              as bool,
      isReorderNeeded: null == isReorderNeeded
          ? _value.isReorderNeeded
          : isReorderNeeded // ignore: cast_nullable_to_non_nullable
              as bool,
      isOverstock: null == isOverstock
          ? _value.isOverstock
          : isOverstock // ignore: cast_nullable_to_non_nullable
              as bool,
      isDeadStock: null == isDeadStock
          ? _value.isDeadStock
          : isDeadStock // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InventoryProductImplCopyWith<$Res>
    implements $InventoryProductCopyWith<$Res> {
  factory _$$InventoryProductImplCopyWith(_$InventoryProductImpl value,
          $Res Function(_$InventoryProductImpl) then) =
      __$$InventoryProductImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String productId,
      String productName,
      String? categoryId,
      String? categoryName,
      String? brandName,
      int currentStock,
      int reorderPoint,
      double avgDailyDemand,
      double daysOfInventory,
      String statusLabel,
      int priorityRank,
      bool isAbnormal,
      bool isStockout,
      bool isCritical,
      bool isWarning,
      bool isReorderNeeded,
      bool isOverstock,
      bool isDeadStock});
}

/// @nodoc
class __$$InventoryProductImplCopyWithImpl<$Res>
    extends _$InventoryProductCopyWithImpl<$Res, _$InventoryProductImpl>
    implements _$$InventoryProductImplCopyWith<$Res> {
  __$$InventoryProductImplCopyWithImpl(_$InventoryProductImpl _value,
      $Res Function(_$InventoryProductImpl) _then)
      : super(_value, _then);

  /// Create a copy of InventoryProduct
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? productName = null,
    Object? categoryId = freezed,
    Object? categoryName = freezed,
    Object? brandName = freezed,
    Object? currentStock = null,
    Object? reorderPoint = null,
    Object? avgDailyDemand = null,
    Object? daysOfInventory = null,
    Object? statusLabel = null,
    Object? priorityRank = null,
    Object? isAbnormal = null,
    Object? isStockout = null,
    Object? isCritical = null,
    Object? isWarning = null,
    Object? isReorderNeeded = null,
    Object? isOverstock = null,
    Object? isDeadStock = null,
  }) {
    return _then(_$InventoryProductImpl(
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryName: freezed == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String?,
      brandName: freezed == brandName
          ? _value.brandName
          : brandName // ignore: cast_nullable_to_non_nullable
              as String?,
      currentStock: null == currentStock
          ? _value.currentStock
          : currentStock // ignore: cast_nullable_to_non_nullable
              as int,
      reorderPoint: null == reorderPoint
          ? _value.reorderPoint
          : reorderPoint // ignore: cast_nullable_to_non_nullable
              as int,
      avgDailyDemand: null == avgDailyDemand
          ? _value.avgDailyDemand
          : avgDailyDemand // ignore: cast_nullable_to_non_nullable
              as double,
      daysOfInventory: null == daysOfInventory
          ? _value.daysOfInventory
          : daysOfInventory // ignore: cast_nullable_to_non_nullable
              as double,
      statusLabel: null == statusLabel
          ? _value.statusLabel
          : statusLabel // ignore: cast_nullable_to_non_nullable
              as String,
      priorityRank: null == priorityRank
          ? _value.priorityRank
          : priorityRank // ignore: cast_nullable_to_non_nullable
              as int,
      isAbnormal: null == isAbnormal
          ? _value.isAbnormal
          : isAbnormal // ignore: cast_nullable_to_non_nullable
              as bool,
      isStockout: null == isStockout
          ? _value.isStockout
          : isStockout // ignore: cast_nullable_to_non_nullable
              as bool,
      isCritical: null == isCritical
          ? _value.isCritical
          : isCritical // ignore: cast_nullable_to_non_nullable
              as bool,
      isWarning: null == isWarning
          ? _value.isWarning
          : isWarning // ignore: cast_nullable_to_non_nullable
              as bool,
      isReorderNeeded: null == isReorderNeeded
          ? _value.isReorderNeeded
          : isReorderNeeded // ignore: cast_nullable_to_non_nullable
              as bool,
      isOverstock: null == isOverstock
          ? _value.isOverstock
          : isOverstock // ignore: cast_nullable_to_non_nullable
              as bool,
      isDeadStock: null == isDeadStock
          ? _value.isDeadStock
          : isDeadStock // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$InventoryProductImpl extends _InventoryProduct {
  const _$InventoryProductImpl(
      {required this.productId,
      required this.productName,
      this.categoryId,
      this.categoryName,
      this.brandName,
      required this.currentStock,
      required this.reorderPoint,
      required this.avgDailyDemand,
      required this.daysOfInventory,
      required this.statusLabel,
      required this.priorityRank,
      this.isAbnormal = false,
      this.isStockout = false,
      this.isCritical = false,
      this.isWarning = false,
      this.isReorderNeeded = false,
      this.isOverstock = false,
      this.isDeadStock = false})
      : super._();

  /// 상품 ID
  @override
  final String productId;

  /// 상품명
  @override
  final String productName;

  /// 카테고리 ID
  @override
  final String? categoryId;

  /// 카테고리명
  @override
  final String? categoryName;

  /// 브랜드명
  @override
  final String? brandName;

  /// 현재 재고
  @override
  final int currentStock;

  /// 재주문점
  @override
  final int reorderPoint;

  /// 일평균 판매량
  @override
  final double avgDailyDemand;

  /// 남은 재고일
  @override
  final double daysOfInventory;

  /// 상태 라벨 (abnormal, critical, warning, etc.)
  @override
  final String statusLabel;

  /// 우선순위
  @override
  final int priorityRank;

  /// 비정상 여부 (음수 재고)
  @override
  @JsonKey()
  final bool isAbnormal;

  /// 품절 여부
  @override
  @JsonKey()
  final bool isStockout;

  /// 긴급 여부
  @override
  @JsonKey()
  final bool isCritical;

  /// 주의 여부
  @override
  @JsonKey()
  final bool isWarning;

  /// 재주문 필요 여부
  @override
  @JsonKey()
  final bool isReorderNeeded;

  /// 과잉 여부
  @override
  @JsonKey()
  final bool isOverstock;

  /// Dead Stock 여부
  @override
  @JsonKey()
  final bool isDeadStock;

  @override
  String toString() {
    return 'InventoryProduct(productId: $productId, productName: $productName, categoryId: $categoryId, categoryName: $categoryName, brandName: $brandName, currentStock: $currentStock, reorderPoint: $reorderPoint, avgDailyDemand: $avgDailyDemand, daysOfInventory: $daysOfInventory, statusLabel: $statusLabel, priorityRank: $priorityRank, isAbnormal: $isAbnormal, isStockout: $isStockout, isCritical: $isCritical, isWarning: $isWarning, isReorderNeeded: $isReorderNeeded, isOverstock: $isOverstock, isDeadStock: $isDeadStock)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InventoryProductImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.brandName, brandName) ||
                other.brandName == brandName) &&
            (identical(other.currentStock, currentStock) ||
                other.currentStock == currentStock) &&
            (identical(other.reorderPoint, reorderPoint) ||
                other.reorderPoint == reorderPoint) &&
            (identical(other.avgDailyDemand, avgDailyDemand) ||
                other.avgDailyDemand == avgDailyDemand) &&
            (identical(other.daysOfInventory, daysOfInventory) ||
                other.daysOfInventory == daysOfInventory) &&
            (identical(other.statusLabel, statusLabel) ||
                other.statusLabel == statusLabel) &&
            (identical(other.priorityRank, priorityRank) ||
                other.priorityRank == priorityRank) &&
            (identical(other.isAbnormal, isAbnormal) ||
                other.isAbnormal == isAbnormal) &&
            (identical(other.isStockout, isStockout) ||
                other.isStockout == isStockout) &&
            (identical(other.isCritical, isCritical) ||
                other.isCritical == isCritical) &&
            (identical(other.isWarning, isWarning) ||
                other.isWarning == isWarning) &&
            (identical(other.isReorderNeeded, isReorderNeeded) ||
                other.isReorderNeeded == isReorderNeeded) &&
            (identical(other.isOverstock, isOverstock) ||
                other.isOverstock == isOverstock) &&
            (identical(other.isDeadStock, isDeadStock) ||
                other.isDeadStock == isDeadStock));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      productId,
      productName,
      categoryId,
      categoryName,
      brandName,
      currentStock,
      reorderPoint,
      avgDailyDemand,
      daysOfInventory,
      statusLabel,
      priorityRank,
      isAbnormal,
      isStockout,
      isCritical,
      isWarning,
      isReorderNeeded,
      isOverstock,
      isDeadStock);

  /// Create a copy of InventoryProduct
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InventoryProductImplCopyWith<_$InventoryProductImpl> get copyWith =>
      __$$InventoryProductImplCopyWithImpl<_$InventoryProductImpl>(
          this, _$identity);
}

abstract class _InventoryProduct extends InventoryProduct {
  const factory _InventoryProduct(
      {required final String productId,
      required final String productName,
      final String? categoryId,
      final String? categoryName,
      final String? brandName,
      required final int currentStock,
      required final int reorderPoint,
      required final double avgDailyDemand,
      required final double daysOfInventory,
      required final String statusLabel,
      required final int priorityRank,
      final bool isAbnormal,
      final bool isStockout,
      final bool isCritical,
      final bool isWarning,
      final bool isReorderNeeded,
      final bool isOverstock,
      final bool isDeadStock}) = _$InventoryProductImpl;
  const _InventoryProduct._() : super._();

  /// 상품 ID
  @override
  String get productId;

  /// 상품명
  @override
  String get productName;

  /// 카테고리 ID
  @override
  String? get categoryId;

  /// 카테고리명
  @override
  String? get categoryName;

  /// 브랜드명
  @override
  String? get brandName;

  /// 현재 재고
  @override
  int get currentStock;

  /// 재주문점
  @override
  int get reorderPoint;

  /// 일평균 판매량
  @override
  double get avgDailyDemand;

  /// 남은 재고일
  @override
  double get daysOfInventory;

  /// 상태 라벨 (abnormal, critical, warning, etc.)
  @override
  String get statusLabel;

  /// 우선순위
  @override
  int get priorityRank;

  /// 비정상 여부 (음수 재고)
  @override
  bool get isAbnormal;

  /// 품절 여부
  @override
  bool get isStockout;

  /// 긴급 여부
  @override
  bool get isCritical;

  /// 주의 여부
  @override
  bool get isWarning;

  /// 재주문 필요 여부
  @override
  bool get isReorderNeeded;

  /// 과잉 여부
  @override
  bool get isOverstock;

  /// Dead Stock 여부
  @override
  bool get isDeadStock;

  /// Create a copy of InventoryProduct
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InventoryProductImplCopyWith<_$InventoryProductImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
