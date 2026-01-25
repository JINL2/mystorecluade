// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shipment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ShipmentItem {
  String get itemId => throw _privateConstructorUsedError;
  String get shipmentId => throw _privateConstructorUsedError;
  String? get orderItemId => throw _privateConstructorUsedError;
  String? get productId => throw _privateConstructorUsedError;
  String? get productName => throw _privateConstructorUsedError;
  String? get sku => throw _privateConstructorUsedError;
  double get quantity => throw _privateConstructorUsedError;
  String? get unit => throw _privateConstructorUsedError;
  double? get unitPrice => throw _privateConstructorUsedError;
  double? get totalAmount => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  int get sortOrder => throw _privateConstructorUsedError;
  DateTime? get createdAtUtc => throw _privateConstructorUsedError;

  /// Create a copy of ShipmentItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShipmentItemCopyWith<ShipmentItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShipmentItemCopyWith<$Res> {
  factory $ShipmentItemCopyWith(
          ShipmentItem value, $Res Function(ShipmentItem) then) =
      _$ShipmentItemCopyWithImpl<$Res, ShipmentItem>;
  @useResult
  $Res call(
      {String itemId,
      String shipmentId,
      String? orderItemId,
      String? productId,
      String? productName,
      String? sku,
      double quantity,
      String? unit,
      double? unitPrice,
      double? totalAmount,
      String? notes,
      int sortOrder,
      DateTime? createdAtUtc});
}

/// @nodoc
class _$ShipmentItemCopyWithImpl<$Res, $Val extends ShipmentItem>
    implements $ShipmentItemCopyWith<$Res> {
  _$ShipmentItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShipmentItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? itemId = null,
    Object? shipmentId = null,
    Object? orderItemId = freezed,
    Object? productId = freezed,
    Object? productName = freezed,
    Object? sku = freezed,
    Object? quantity = null,
    Object? unit = freezed,
    Object? unitPrice = freezed,
    Object? totalAmount = freezed,
    Object? notes = freezed,
    Object? sortOrder = null,
    Object? createdAtUtc = freezed,
  }) {
    return _then(_value.copyWith(
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      shipmentId: null == shipmentId
          ? _value.shipmentId
          : shipmentId // ignore: cast_nullable_to_non_nullable
              as String,
      orderItemId: freezed == orderItemId
          ? _value.orderItemId
          : orderItemId // ignore: cast_nullable_to_non_nullable
              as String?,
      productId: freezed == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String?,
      productName: freezed == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String?,
      sku: freezed == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String?,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      unitPrice: freezed == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      totalAmount: freezed == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      createdAtUtc: freezed == createdAtUtc
          ? _value.createdAtUtc
          : createdAtUtc // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ShipmentItemImplCopyWith<$Res>
    implements $ShipmentItemCopyWith<$Res> {
  factory _$$ShipmentItemImplCopyWith(
          _$ShipmentItemImpl value, $Res Function(_$ShipmentItemImpl) then) =
      __$$ShipmentItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String itemId,
      String shipmentId,
      String? orderItemId,
      String? productId,
      String? productName,
      String? sku,
      double quantity,
      String? unit,
      double? unitPrice,
      double? totalAmount,
      String? notes,
      int sortOrder,
      DateTime? createdAtUtc});
}

/// @nodoc
class __$$ShipmentItemImplCopyWithImpl<$Res>
    extends _$ShipmentItemCopyWithImpl<$Res, _$ShipmentItemImpl>
    implements _$$ShipmentItemImplCopyWith<$Res> {
  __$$ShipmentItemImplCopyWithImpl(
      _$ShipmentItemImpl _value, $Res Function(_$ShipmentItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of ShipmentItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? itemId = null,
    Object? shipmentId = null,
    Object? orderItemId = freezed,
    Object? productId = freezed,
    Object? productName = freezed,
    Object? sku = freezed,
    Object? quantity = null,
    Object? unit = freezed,
    Object? unitPrice = freezed,
    Object? totalAmount = freezed,
    Object? notes = freezed,
    Object? sortOrder = null,
    Object? createdAtUtc = freezed,
  }) {
    return _then(_$ShipmentItemImpl(
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      shipmentId: null == shipmentId
          ? _value.shipmentId
          : shipmentId // ignore: cast_nullable_to_non_nullable
              as String,
      orderItemId: freezed == orderItemId
          ? _value.orderItemId
          : orderItemId // ignore: cast_nullable_to_non_nullable
              as String?,
      productId: freezed == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String?,
      productName: freezed == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String?,
      sku: freezed == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String?,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      unitPrice: freezed == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      totalAmount: freezed == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      createdAtUtc: freezed == createdAtUtc
          ? _value.createdAtUtc
          : createdAtUtc // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$ShipmentItemImpl extends _ShipmentItem {
  const _$ShipmentItemImpl(
      {required this.itemId,
      required this.shipmentId,
      this.orderItemId,
      this.productId,
      this.productName,
      this.sku,
      required this.quantity,
      this.unit,
      this.unitPrice,
      this.totalAmount,
      this.notes,
      this.sortOrder = 0,
      this.createdAtUtc})
      : super._();

  @override
  final String itemId;
  @override
  final String shipmentId;
  @override
  final String? orderItemId;
  @override
  final String? productId;
  @override
  final String? productName;
  @override
  final String? sku;
  @override
  final double quantity;
  @override
  final String? unit;
  @override
  final double? unitPrice;
  @override
  final double? totalAmount;
  @override
  final String? notes;
  @override
  @JsonKey()
  final int sortOrder;
  @override
  final DateTime? createdAtUtc;

  @override
  String toString() {
    return 'ShipmentItem(itemId: $itemId, shipmentId: $shipmentId, orderItemId: $orderItemId, productId: $productId, productName: $productName, sku: $sku, quantity: $quantity, unit: $unit, unitPrice: $unitPrice, totalAmount: $totalAmount, notes: $notes, sortOrder: $sortOrder, createdAtUtc: $createdAtUtc)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShipmentItemImpl &&
            (identical(other.itemId, itemId) || other.itemId == itemId) &&
            (identical(other.shipmentId, shipmentId) ||
                other.shipmentId == shipmentId) &&
            (identical(other.orderItemId, orderItemId) ||
                other.orderItemId == orderItemId) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.createdAtUtc, createdAtUtc) ||
                other.createdAtUtc == createdAtUtc));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      itemId,
      shipmentId,
      orderItemId,
      productId,
      productName,
      sku,
      quantity,
      unit,
      unitPrice,
      totalAmount,
      notes,
      sortOrder,
      createdAtUtc);

  /// Create a copy of ShipmentItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShipmentItemImplCopyWith<_$ShipmentItemImpl> get copyWith =>
      __$$ShipmentItemImplCopyWithImpl<_$ShipmentItemImpl>(this, _$identity);
}

abstract class _ShipmentItem extends ShipmentItem {
  const factory _ShipmentItem(
      {required final String itemId,
      required final String shipmentId,
      final String? orderItemId,
      final String? productId,
      final String? productName,
      final String? sku,
      required final double quantity,
      final String? unit,
      final double? unitPrice,
      final double? totalAmount,
      final String? notes,
      final int sortOrder,
      final DateTime? createdAtUtc}) = _$ShipmentItemImpl;
  const _ShipmentItem._() : super._();

  @override
  String get itemId;
  @override
  String get shipmentId;
  @override
  String? get orderItemId;
  @override
  String? get productId;
  @override
  String? get productName;
  @override
  String? get sku;
  @override
  double get quantity;
  @override
  String? get unit;
  @override
  double? get unitPrice;
  @override
  double? get totalAmount;
  @override
  String? get notes;
  @override
  int get sortOrder;
  @override
  DateTime? get createdAtUtc;

  /// Create a copy of ShipmentItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShipmentItemImplCopyWith<_$ShipmentItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Shipment {
  String get shipmentId => throw _privateConstructorUsedError;
  String get shipmentNumber => throw _privateConstructorUsedError;
  String get companyId => throw _privateConstructorUsedError;
  String? get trackingNumber => throw _privateConstructorUsedError;
  DateTime? get shippedDateUtc => throw _privateConstructorUsedError;
  String? get supplierId => throw _privateConstructorUsedError;
  String? get supplierName => throw _privateConstructorUsedError;
  Map<String, dynamic>? get supplierInfo => throw _privateConstructorUsedError;
  ShipmentStatus get status => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;
  DateTime? get createdAtUtc => throw _privateConstructorUsedError;
  DateTime? get updatedAtUtc => throw _privateConstructorUsedError; // Items
  List<ShipmentItem> get items => throw _privateConstructorUsedError;

  /// Create a copy of Shipment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShipmentCopyWith<Shipment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShipmentCopyWith<$Res> {
  factory $ShipmentCopyWith(Shipment value, $Res Function(Shipment) then) =
      _$ShipmentCopyWithImpl<$Res, Shipment>;
  @useResult
  $Res call(
      {String shipmentId,
      String shipmentNumber,
      String companyId,
      String? trackingNumber,
      DateTime? shippedDateUtc,
      String? supplierId,
      String? supplierName,
      Map<String, dynamic>? supplierInfo,
      ShipmentStatus status,
      String? notes,
      String? createdBy,
      DateTime? createdAtUtc,
      DateTime? updatedAtUtc,
      List<ShipmentItem> items});
}

/// @nodoc
class _$ShipmentCopyWithImpl<$Res, $Val extends Shipment>
    implements $ShipmentCopyWith<$Res> {
  _$ShipmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Shipment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shipmentId = null,
    Object? shipmentNumber = null,
    Object? companyId = null,
    Object? trackingNumber = freezed,
    Object? shippedDateUtc = freezed,
    Object? supplierId = freezed,
    Object? supplierName = freezed,
    Object? supplierInfo = freezed,
    Object? status = null,
    Object? notes = freezed,
    Object? createdBy = freezed,
    Object? createdAtUtc = freezed,
    Object? updatedAtUtc = freezed,
    Object? items = null,
  }) {
    return _then(_value.copyWith(
      shipmentId: null == shipmentId
          ? _value.shipmentId
          : shipmentId // ignore: cast_nullable_to_non_nullable
              as String,
      shipmentNumber: null == shipmentNumber
          ? _value.shipmentNumber
          : shipmentNumber // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      trackingNumber: freezed == trackingNumber
          ? _value.trackingNumber
          : trackingNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      shippedDateUtc: freezed == shippedDateUtc
          ? _value.shippedDateUtc
          : shippedDateUtc // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      supplierId: freezed == supplierId
          ? _value.supplierId
          : supplierId // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierName: freezed == supplierName
          ? _value.supplierName
          : supplierName // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierInfo: freezed == supplierInfo
          ? _value.supplierInfo
          : supplierInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ShipmentStatus,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAtUtc: freezed == createdAtUtc
          ? _value.createdAtUtc
          : createdAtUtc // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAtUtc: freezed == updatedAtUtc
          ? _value.updatedAtUtc
          : updatedAtUtc // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<ShipmentItem>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ShipmentImplCopyWith<$Res>
    implements $ShipmentCopyWith<$Res> {
  factory _$$ShipmentImplCopyWith(
          _$ShipmentImpl value, $Res Function(_$ShipmentImpl) then) =
      __$$ShipmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String shipmentId,
      String shipmentNumber,
      String companyId,
      String? trackingNumber,
      DateTime? shippedDateUtc,
      String? supplierId,
      String? supplierName,
      Map<String, dynamic>? supplierInfo,
      ShipmentStatus status,
      String? notes,
      String? createdBy,
      DateTime? createdAtUtc,
      DateTime? updatedAtUtc,
      List<ShipmentItem> items});
}

/// @nodoc
class __$$ShipmentImplCopyWithImpl<$Res>
    extends _$ShipmentCopyWithImpl<$Res, _$ShipmentImpl>
    implements _$$ShipmentImplCopyWith<$Res> {
  __$$ShipmentImplCopyWithImpl(
      _$ShipmentImpl _value, $Res Function(_$ShipmentImpl) _then)
      : super(_value, _then);

  /// Create a copy of Shipment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shipmentId = null,
    Object? shipmentNumber = null,
    Object? companyId = null,
    Object? trackingNumber = freezed,
    Object? shippedDateUtc = freezed,
    Object? supplierId = freezed,
    Object? supplierName = freezed,
    Object? supplierInfo = freezed,
    Object? status = null,
    Object? notes = freezed,
    Object? createdBy = freezed,
    Object? createdAtUtc = freezed,
    Object? updatedAtUtc = freezed,
    Object? items = null,
  }) {
    return _then(_$ShipmentImpl(
      shipmentId: null == shipmentId
          ? _value.shipmentId
          : shipmentId // ignore: cast_nullable_to_non_nullable
              as String,
      shipmentNumber: null == shipmentNumber
          ? _value.shipmentNumber
          : shipmentNumber // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      trackingNumber: freezed == trackingNumber
          ? _value.trackingNumber
          : trackingNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      shippedDateUtc: freezed == shippedDateUtc
          ? _value.shippedDateUtc
          : shippedDateUtc // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      supplierId: freezed == supplierId
          ? _value.supplierId
          : supplierId // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierName: freezed == supplierName
          ? _value.supplierName
          : supplierName // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierInfo: freezed == supplierInfo
          ? _value._supplierInfo
          : supplierInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ShipmentStatus,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAtUtc: freezed == createdAtUtc
          ? _value.createdAtUtc
          : createdAtUtc // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAtUtc: freezed == updatedAtUtc
          ? _value.updatedAtUtc
          : updatedAtUtc // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<ShipmentItem>,
    ));
  }
}

/// @nodoc

class _$ShipmentImpl extends _Shipment {
  const _$ShipmentImpl(
      {required this.shipmentId,
      required this.shipmentNumber,
      required this.companyId,
      this.trackingNumber,
      this.shippedDateUtc,
      this.supplierId,
      this.supplierName,
      final Map<String, dynamic>? supplierInfo,
      this.status = ShipmentStatus.pending,
      this.notes,
      this.createdBy,
      this.createdAtUtc,
      this.updatedAtUtc,
      final List<ShipmentItem> items = const []})
      : _supplierInfo = supplierInfo,
        _items = items,
        super._();

  @override
  final String shipmentId;
  @override
  final String shipmentNumber;
  @override
  final String companyId;
  @override
  final String? trackingNumber;
  @override
  final DateTime? shippedDateUtc;
  @override
  final String? supplierId;
  @override
  final String? supplierName;
  final Map<String, dynamic>? _supplierInfo;
  @override
  Map<String, dynamic>? get supplierInfo {
    final value = _supplierInfo;
    if (value == null) return null;
    if (_supplierInfo is EqualUnmodifiableMapView) return _supplierInfo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey()
  final ShipmentStatus status;
  @override
  final String? notes;
  @override
  final String? createdBy;
  @override
  final DateTime? createdAtUtc;
  @override
  final DateTime? updatedAtUtc;
// Items
  final List<ShipmentItem> _items;
// Items
  @override
  @JsonKey()
  List<ShipmentItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'Shipment(shipmentId: $shipmentId, shipmentNumber: $shipmentNumber, companyId: $companyId, trackingNumber: $trackingNumber, shippedDateUtc: $shippedDateUtc, supplierId: $supplierId, supplierName: $supplierName, supplierInfo: $supplierInfo, status: $status, notes: $notes, createdBy: $createdBy, createdAtUtc: $createdAtUtc, updatedAtUtc: $updatedAtUtc, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShipmentImpl &&
            (identical(other.shipmentId, shipmentId) ||
                other.shipmentId == shipmentId) &&
            (identical(other.shipmentNumber, shipmentNumber) ||
                other.shipmentNumber == shipmentNumber) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.trackingNumber, trackingNumber) ||
                other.trackingNumber == trackingNumber) &&
            (identical(other.shippedDateUtc, shippedDateUtc) ||
                other.shippedDateUtc == shippedDateUtc) &&
            (identical(other.supplierId, supplierId) ||
                other.supplierId == supplierId) &&
            (identical(other.supplierName, supplierName) ||
                other.supplierName == supplierName) &&
            const DeepCollectionEquality()
                .equals(other._supplierInfo, _supplierInfo) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAtUtc, createdAtUtc) ||
                other.createdAtUtc == createdAtUtc) &&
            (identical(other.updatedAtUtc, updatedAtUtc) ||
                other.updatedAtUtc == updatedAtUtc) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      shipmentId,
      shipmentNumber,
      companyId,
      trackingNumber,
      shippedDateUtc,
      supplierId,
      supplierName,
      const DeepCollectionEquality().hash(_supplierInfo),
      status,
      notes,
      createdBy,
      createdAtUtc,
      updatedAtUtc,
      const DeepCollectionEquality().hash(_items));

  /// Create a copy of Shipment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShipmentImplCopyWith<_$ShipmentImpl> get copyWith =>
      __$$ShipmentImplCopyWithImpl<_$ShipmentImpl>(this, _$identity);
}

abstract class _Shipment extends Shipment {
  const factory _Shipment(
      {required final String shipmentId,
      required final String shipmentNumber,
      required final String companyId,
      final String? trackingNumber,
      final DateTime? shippedDateUtc,
      final String? supplierId,
      final String? supplierName,
      final Map<String, dynamic>? supplierInfo,
      final ShipmentStatus status,
      final String? notes,
      final String? createdBy,
      final DateTime? createdAtUtc,
      final DateTime? updatedAtUtc,
      final List<ShipmentItem> items}) = _$ShipmentImpl;
  const _Shipment._() : super._();

  @override
  String get shipmentId;
  @override
  String get shipmentNumber;
  @override
  String get companyId;
  @override
  String? get trackingNumber;
  @override
  DateTime? get shippedDateUtc;
  @override
  String? get supplierId;
  @override
  String? get supplierName;
  @override
  Map<String, dynamic>? get supplierInfo;
  @override
  ShipmentStatus get status;
  @override
  String? get notes;
  @override
  String? get createdBy;
  @override
  DateTime? get createdAtUtc;
  @override
  DateTime? get updatedAtUtc; // Items
  @override
  List<ShipmentItem> get items;

  /// Create a copy of Shipment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShipmentImplCopyWith<_$ShipmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ShipmentListItem {
  String get shipmentId => throw _privateConstructorUsedError;
  String get shipmentNumber => throw _privateConstructorUsedError;
  String? get trackingNumber => throw _privateConstructorUsedError;
  DateTime? get shippedDate => throw _privateConstructorUsedError;
  String? get supplierId => throw _privateConstructorUsedError;
  String? get supplierName => throw _privateConstructorUsedError;
  ShipmentStatus get status => throw _privateConstructorUsedError;
  int get itemCount => throw _privateConstructorUsedError;
  double get totalAmount => throw _privateConstructorUsedError;
  bool get hasOrders => throw _privateConstructorUsedError;
  int get linkedOrderCount => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;

  /// Create a copy of ShipmentListItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShipmentListItemCopyWith<ShipmentListItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShipmentListItemCopyWith<$Res> {
  factory $ShipmentListItemCopyWith(
          ShipmentListItem value, $Res Function(ShipmentListItem) then) =
      _$ShipmentListItemCopyWithImpl<$Res, ShipmentListItem>;
  @useResult
  $Res call(
      {String shipmentId,
      String shipmentNumber,
      String? trackingNumber,
      DateTime? shippedDate,
      String? supplierId,
      String? supplierName,
      ShipmentStatus status,
      int itemCount,
      double totalAmount,
      bool hasOrders,
      int linkedOrderCount,
      String? notes,
      DateTime? createdAt,
      String? createdBy});
}

/// @nodoc
class _$ShipmentListItemCopyWithImpl<$Res, $Val extends ShipmentListItem>
    implements $ShipmentListItemCopyWith<$Res> {
  _$ShipmentListItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShipmentListItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shipmentId = null,
    Object? shipmentNumber = null,
    Object? trackingNumber = freezed,
    Object? shippedDate = freezed,
    Object? supplierId = freezed,
    Object? supplierName = freezed,
    Object? status = null,
    Object? itemCount = null,
    Object? totalAmount = null,
    Object? hasOrders = null,
    Object? linkedOrderCount = null,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? createdBy = freezed,
  }) {
    return _then(_value.copyWith(
      shipmentId: null == shipmentId
          ? _value.shipmentId
          : shipmentId // ignore: cast_nullable_to_non_nullable
              as String,
      shipmentNumber: null == shipmentNumber
          ? _value.shipmentNumber
          : shipmentNumber // ignore: cast_nullable_to_non_nullable
              as String,
      trackingNumber: freezed == trackingNumber
          ? _value.trackingNumber
          : trackingNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      shippedDate: freezed == shippedDate
          ? _value.shippedDate
          : shippedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      supplierId: freezed == supplierId
          ? _value.supplierId
          : supplierId // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierName: freezed == supplierName
          ? _value.supplierName
          : supplierName // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ShipmentStatus,
      itemCount: null == itemCount
          ? _value.itemCount
          : itemCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      hasOrders: null == hasOrders
          ? _value.hasOrders
          : hasOrders // ignore: cast_nullable_to_non_nullable
              as bool,
      linkedOrderCount: null == linkedOrderCount
          ? _value.linkedOrderCount
          : linkedOrderCount // ignore: cast_nullable_to_non_nullable
              as int,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ShipmentListItemImplCopyWith<$Res>
    implements $ShipmentListItemCopyWith<$Res> {
  factory _$$ShipmentListItemImplCopyWith(_$ShipmentListItemImpl value,
          $Res Function(_$ShipmentListItemImpl) then) =
      __$$ShipmentListItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String shipmentId,
      String shipmentNumber,
      String? trackingNumber,
      DateTime? shippedDate,
      String? supplierId,
      String? supplierName,
      ShipmentStatus status,
      int itemCount,
      double totalAmount,
      bool hasOrders,
      int linkedOrderCount,
      String? notes,
      DateTime? createdAt,
      String? createdBy});
}

/// @nodoc
class __$$ShipmentListItemImplCopyWithImpl<$Res>
    extends _$ShipmentListItemCopyWithImpl<$Res, _$ShipmentListItemImpl>
    implements _$$ShipmentListItemImplCopyWith<$Res> {
  __$$ShipmentListItemImplCopyWithImpl(_$ShipmentListItemImpl _value,
      $Res Function(_$ShipmentListItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of ShipmentListItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shipmentId = null,
    Object? shipmentNumber = null,
    Object? trackingNumber = freezed,
    Object? shippedDate = freezed,
    Object? supplierId = freezed,
    Object? supplierName = freezed,
    Object? status = null,
    Object? itemCount = null,
    Object? totalAmount = null,
    Object? hasOrders = null,
    Object? linkedOrderCount = null,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? createdBy = freezed,
  }) {
    return _then(_$ShipmentListItemImpl(
      shipmentId: null == shipmentId
          ? _value.shipmentId
          : shipmentId // ignore: cast_nullable_to_non_nullable
              as String,
      shipmentNumber: null == shipmentNumber
          ? _value.shipmentNumber
          : shipmentNumber // ignore: cast_nullable_to_non_nullable
              as String,
      trackingNumber: freezed == trackingNumber
          ? _value.trackingNumber
          : trackingNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      shippedDate: freezed == shippedDate
          ? _value.shippedDate
          : shippedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      supplierId: freezed == supplierId
          ? _value.supplierId
          : supplierId // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierName: freezed == supplierName
          ? _value.supplierName
          : supplierName // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ShipmentStatus,
      itemCount: null == itemCount
          ? _value.itemCount
          : itemCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      hasOrders: null == hasOrders
          ? _value.hasOrders
          : hasOrders // ignore: cast_nullable_to_non_nullable
              as bool,
      linkedOrderCount: null == linkedOrderCount
          ? _value.linkedOrderCount
          : linkedOrderCount // ignore: cast_nullable_to_non_nullable
              as int,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ShipmentListItemImpl extends _ShipmentListItem {
  const _$ShipmentListItemImpl(
      {required this.shipmentId,
      required this.shipmentNumber,
      this.trackingNumber,
      this.shippedDate,
      this.supplierId,
      this.supplierName,
      required this.status,
      this.itemCount = 0,
      this.totalAmount = 0,
      this.hasOrders = false,
      this.linkedOrderCount = 0,
      this.notes,
      this.createdAt,
      this.createdBy})
      : super._();

  @override
  final String shipmentId;
  @override
  final String shipmentNumber;
  @override
  final String? trackingNumber;
  @override
  final DateTime? shippedDate;
  @override
  final String? supplierId;
  @override
  final String? supplierName;
  @override
  final ShipmentStatus status;
  @override
  @JsonKey()
  final int itemCount;
  @override
  @JsonKey()
  final double totalAmount;
  @override
  @JsonKey()
  final bool hasOrders;
  @override
  @JsonKey()
  final int linkedOrderCount;
  @override
  final String? notes;
  @override
  final DateTime? createdAt;
  @override
  final String? createdBy;

  @override
  String toString() {
    return 'ShipmentListItem(shipmentId: $shipmentId, shipmentNumber: $shipmentNumber, trackingNumber: $trackingNumber, shippedDate: $shippedDate, supplierId: $supplierId, supplierName: $supplierName, status: $status, itemCount: $itemCount, totalAmount: $totalAmount, hasOrders: $hasOrders, linkedOrderCount: $linkedOrderCount, notes: $notes, createdAt: $createdAt, createdBy: $createdBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShipmentListItemImpl &&
            (identical(other.shipmentId, shipmentId) ||
                other.shipmentId == shipmentId) &&
            (identical(other.shipmentNumber, shipmentNumber) ||
                other.shipmentNumber == shipmentNumber) &&
            (identical(other.trackingNumber, trackingNumber) ||
                other.trackingNumber == trackingNumber) &&
            (identical(other.shippedDate, shippedDate) ||
                other.shippedDate == shippedDate) &&
            (identical(other.supplierId, supplierId) ||
                other.supplierId == supplierId) &&
            (identical(other.supplierName, supplierName) ||
                other.supplierName == supplierName) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.itemCount, itemCount) ||
                other.itemCount == itemCount) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.hasOrders, hasOrders) ||
                other.hasOrders == hasOrders) &&
            (identical(other.linkedOrderCount, linkedOrderCount) ||
                other.linkedOrderCount == linkedOrderCount) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      shipmentId,
      shipmentNumber,
      trackingNumber,
      shippedDate,
      supplierId,
      supplierName,
      status,
      itemCount,
      totalAmount,
      hasOrders,
      linkedOrderCount,
      notes,
      createdAt,
      createdBy);

  /// Create a copy of ShipmentListItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShipmentListItemImplCopyWith<_$ShipmentListItemImpl> get copyWith =>
      __$$ShipmentListItemImplCopyWithImpl<_$ShipmentListItemImpl>(
          this, _$identity);
}

abstract class _ShipmentListItem extends ShipmentListItem {
  const factory _ShipmentListItem(
      {required final String shipmentId,
      required final String shipmentNumber,
      final String? trackingNumber,
      final DateTime? shippedDate,
      final String? supplierId,
      final String? supplierName,
      required final ShipmentStatus status,
      final int itemCount,
      final double totalAmount,
      final bool hasOrders,
      final int linkedOrderCount,
      final String? notes,
      final DateTime? createdAt,
      final String? createdBy}) = _$ShipmentListItemImpl;
  const _ShipmentListItem._() : super._();

  @override
  String get shipmentId;
  @override
  String get shipmentNumber;
  @override
  String? get trackingNumber;
  @override
  DateTime? get shippedDate;
  @override
  String? get supplierId;
  @override
  String? get supplierName;
  @override
  ShipmentStatus get status;
  @override
  int get itemCount;
  @override
  double get totalAmount;
  @override
  bool get hasOrders;
  @override
  int get linkedOrderCount;
  @override
  String? get notes;
  @override
  DateTime? get createdAt;
  @override
  String? get createdBy;

  /// Create a copy of ShipmentListItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShipmentListItemImplCopyWith<_$ShipmentListItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PaginatedShipmentResponse {
  List<ShipmentListItem> get data => throw _privateConstructorUsedError;
  int get totalCount => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;
  int get offset => throw _privateConstructorUsedError;

  /// Create a copy of PaginatedShipmentResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaginatedShipmentResponseCopyWith<PaginatedShipmentResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginatedShipmentResponseCopyWith<$Res> {
  factory $PaginatedShipmentResponseCopyWith(PaginatedShipmentResponse value,
          $Res Function(PaginatedShipmentResponse) then) =
      _$PaginatedShipmentResponseCopyWithImpl<$Res, PaginatedShipmentResponse>;
  @useResult
  $Res call(
      {List<ShipmentListItem> data, int totalCount, int limit, int offset});
}

/// @nodoc
class _$PaginatedShipmentResponseCopyWithImpl<$Res,
        $Val extends PaginatedShipmentResponse>
    implements $PaginatedShipmentResponseCopyWith<$Res> {
  _$PaginatedShipmentResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaginatedShipmentResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? totalCount = null,
    Object? limit = null,
    Object? offset = null,
  }) {
    return _then(_value.copyWith(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<ShipmentListItem>,
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
      offset: null == offset
          ? _value.offset
          : offset // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaginatedShipmentResponseImplCopyWith<$Res>
    implements $PaginatedShipmentResponseCopyWith<$Res> {
  factory _$$PaginatedShipmentResponseImplCopyWith(
          _$PaginatedShipmentResponseImpl value,
          $Res Function(_$PaginatedShipmentResponseImpl) then) =
      __$$PaginatedShipmentResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<ShipmentListItem> data, int totalCount, int limit, int offset});
}

/// @nodoc
class __$$PaginatedShipmentResponseImplCopyWithImpl<$Res>
    extends _$PaginatedShipmentResponseCopyWithImpl<$Res,
        _$PaginatedShipmentResponseImpl>
    implements _$$PaginatedShipmentResponseImplCopyWith<$Res> {
  __$$PaginatedShipmentResponseImplCopyWithImpl(
      _$PaginatedShipmentResponseImpl _value,
      $Res Function(_$PaginatedShipmentResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of PaginatedShipmentResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? totalCount = null,
    Object? limit = null,
    Object? offset = null,
  }) {
    return _then(_$PaginatedShipmentResponseImpl(
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<ShipmentListItem>,
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
      offset: null == offset
          ? _value.offset
          : offset // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$PaginatedShipmentResponseImpl implements _PaginatedShipmentResponse {
  const _$PaginatedShipmentResponseImpl(
      {required final List<ShipmentListItem> data,
      required this.totalCount,
      required this.limit,
      required this.offset})
      : _data = data;

  final List<ShipmentListItem> _data;
  @override
  List<ShipmentListItem> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  final int totalCount;
  @override
  final int limit;
  @override
  final int offset;

  @override
  String toString() {
    return 'PaginatedShipmentResponse(data: $data, totalCount: $totalCount, limit: $limit, offset: $offset)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaginatedShipmentResponseImpl &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.offset, offset) || other.offset == offset));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_data), totalCount, limit, offset);

  /// Create a copy of PaginatedShipmentResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaginatedShipmentResponseImplCopyWith<_$PaginatedShipmentResponseImpl>
      get copyWith => __$$PaginatedShipmentResponseImplCopyWithImpl<
          _$PaginatedShipmentResponseImpl>(this, _$identity);
}

abstract class _PaginatedShipmentResponse implements PaginatedShipmentResponse {
  const factory _PaginatedShipmentResponse(
      {required final List<ShipmentListItem> data,
      required final int totalCount,
      required final int limit,
      required final int offset}) = _$PaginatedShipmentResponseImpl;

  @override
  List<ShipmentListItem> get data;
  @override
  int get totalCount;
  @override
  int get limit;
  @override
  int get offset;

  /// Create a copy of PaginatedShipmentResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaginatedShipmentResponseImplCopyWith<_$PaginatedShipmentResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ShipmentSupplierInfo {
  String? get supplierId => throw _privateConstructorUsedError;
  String? get supplierName => throw _privateConstructorUsedError;
  String? get supplierPhone => throw _privateConstructorUsedError;
  String? get supplierEmail => throw _privateConstructorUsedError;
  bool get isRegisteredSupplier => throw _privateConstructorUsedError;

  /// Create a copy of ShipmentSupplierInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShipmentSupplierInfoCopyWith<ShipmentSupplierInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShipmentSupplierInfoCopyWith<$Res> {
  factory $ShipmentSupplierInfoCopyWith(ShipmentSupplierInfo value,
          $Res Function(ShipmentSupplierInfo) then) =
      _$ShipmentSupplierInfoCopyWithImpl<$Res, ShipmentSupplierInfo>;
  @useResult
  $Res call(
      {String? supplierId,
      String? supplierName,
      String? supplierPhone,
      String? supplierEmail,
      bool isRegisteredSupplier});
}

/// @nodoc
class _$ShipmentSupplierInfoCopyWithImpl<$Res,
        $Val extends ShipmentSupplierInfo>
    implements $ShipmentSupplierInfoCopyWith<$Res> {
  _$ShipmentSupplierInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShipmentSupplierInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? supplierId = freezed,
    Object? supplierName = freezed,
    Object? supplierPhone = freezed,
    Object? supplierEmail = freezed,
    Object? isRegisteredSupplier = null,
  }) {
    return _then(_value.copyWith(
      supplierId: freezed == supplierId
          ? _value.supplierId
          : supplierId // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierName: freezed == supplierName
          ? _value.supplierName
          : supplierName // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierPhone: freezed == supplierPhone
          ? _value.supplierPhone
          : supplierPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierEmail: freezed == supplierEmail
          ? _value.supplierEmail
          : supplierEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      isRegisteredSupplier: null == isRegisteredSupplier
          ? _value.isRegisteredSupplier
          : isRegisteredSupplier // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ShipmentSupplierInfoImplCopyWith<$Res>
    implements $ShipmentSupplierInfoCopyWith<$Res> {
  factory _$$ShipmentSupplierInfoImplCopyWith(_$ShipmentSupplierInfoImpl value,
          $Res Function(_$ShipmentSupplierInfoImpl) then) =
      __$$ShipmentSupplierInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? supplierId,
      String? supplierName,
      String? supplierPhone,
      String? supplierEmail,
      bool isRegisteredSupplier});
}

/// @nodoc
class __$$ShipmentSupplierInfoImplCopyWithImpl<$Res>
    extends _$ShipmentSupplierInfoCopyWithImpl<$Res, _$ShipmentSupplierInfoImpl>
    implements _$$ShipmentSupplierInfoImplCopyWith<$Res> {
  __$$ShipmentSupplierInfoImplCopyWithImpl(_$ShipmentSupplierInfoImpl _value,
      $Res Function(_$ShipmentSupplierInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ShipmentSupplierInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? supplierId = freezed,
    Object? supplierName = freezed,
    Object? supplierPhone = freezed,
    Object? supplierEmail = freezed,
    Object? isRegisteredSupplier = null,
  }) {
    return _then(_$ShipmentSupplierInfoImpl(
      supplierId: freezed == supplierId
          ? _value.supplierId
          : supplierId // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierName: freezed == supplierName
          ? _value.supplierName
          : supplierName // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierPhone: freezed == supplierPhone
          ? _value.supplierPhone
          : supplierPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierEmail: freezed == supplierEmail
          ? _value.supplierEmail
          : supplierEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      isRegisteredSupplier: null == isRegisteredSupplier
          ? _value.isRegisteredSupplier
          : isRegisteredSupplier // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$ShipmentSupplierInfoImpl implements _ShipmentSupplierInfo {
  const _$ShipmentSupplierInfoImpl(
      {this.supplierId,
      this.supplierName,
      this.supplierPhone,
      this.supplierEmail,
      this.isRegisteredSupplier = false});

  @override
  final String? supplierId;
  @override
  final String? supplierName;
  @override
  final String? supplierPhone;
  @override
  final String? supplierEmail;
  @override
  @JsonKey()
  final bool isRegisteredSupplier;

  @override
  String toString() {
    return 'ShipmentSupplierInfo(supplierId: $supplierId, supplierName: $supplierName, supplierPhone: $supplierPhone, supplierEmail: $supplierEmail, isRegisteredSupplier: $isRegisteredSupplier)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShipmentSupplierInfoImpl &&
            (identical(other.supplierId, supplierId) ||
                other.supplierId == supplierId) &&
            (identical(other.supplierName, supplierName) ||
                other.supplierName == supplierName) &&
            (identical(other.supplierPhone, supplierPhone) ||
                other.supplierPhone == supplierPhone) &&
            (identical(other.supplierEmail, supplierEmail) ||
                other.supplierEmail == supplierEmail) &&
            (identical(other.isRegisteredSupplier, isRegisteredSupplier) ||
                other.isRegisteredSupplier == isRegisteredSupplier));
  }

  @override
  int get hashCode => Object.hash(runtimeType, supplierId, supplierName,
      supplierPhone, supplierEmail, isRegisteredSupplier);

  /// Create a copy of ShipmentSupplierInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShipmentSupplierInfoImplCopyWith<_$ShipmentSupplierInfoImpl>
      get copyWith =>
          __$$ShipmentSupplierInfoImplCopyWithImpl<_$ShipmentSupplierInfoImpl>(
              this, _$identity);
}

abstract class _ShipmentSupplierInfo implements ShipmentSupplierInfo {
  const factory _ShipmentSupplierInfo(
      {final String? supplierId,
      final String? supplierName,
      final String? supplierPhone,
      final String? supplierEmail,
      final bool isRegisteredSupplier}) = _$ShipmentSupplierInfoImpl;

  @override
  String? get supplierId;
  @override
  String? get supplierName;
  @override
  String? get supplierPhone;
  @override
  String? get supplierEmail;
  @override
  bool get isRegisteredSupplier;

  /// Create a copy of ShipmentSupplierInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShipmentSupplierInfoImplCopyWith<_$ShipmentSupplierInfoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ShipmentDetailItem {
  String get itemId => throw _privateConstructorUsedError;
  String? get productId => throw _privateConstructorUsedError;
  String? get variantId => throw _privateConstructorUsedError;
  String? get productName => throw _privateConstructorUsedError;
  String? get variantName => throw _privateConstructorUsedError;
  String? get displayName => throw _privateConstructorUsedError;
  bool get hasVariants => throw _privateConstructorUsedError;
  String? get sku => throw _privateConstructorUsedError;
  double get quantityShipped => throw _privateConstructorUsedError;
  double get quantityReceived => throw _privateConstructorUsedError;
  double get quantityAccepted => throw _privateConstructorUsedError;
  double get quantityRejected => throw _privateConstructorUsedError;
  double get quantityRemaining => throw _privateConstructorUsedError;
  double get unitCost => throw _privateConstructorUsedError;
  double get totalAmount => throw _privateConstructorUsedError;
  String? get unit => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  int get sortOrder => throw _privateConstructorUsedError;

  /// Create a copy of ShipmentDetailItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShipmentDetailItemCopyWith<ShipmentDetailItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShipmentDetailItemCopyWith<$Res> {
  factory $ShipmentDetailItemCopyWith(
          ShipmentDetailItem value, $Res Function(ShipmentDetailItem) then) =
      _$ShipmentDetailItemCopyWithImpl<$Res, ShipmentDetailItem>;
  @useResult
  $Res call(
      {String itemId,
      String? productId,
      String? variantId,
      String? productName,
      String? variantName,
      String? displayName,
      bool hasVariants,
      String? sku,
      double quantityShipped,
      double quantityReceived,
      double quantityAccepted,
      double quantityRejected,
      double quantityRemaining,
      double unitCost,
      double totalAmount,
      String? unit,
      String? notes,
      int sortOrder});
}

/// @nodoc
class _$ShipmentDetailItemCopyWithImpl<$Res, $Val extends ShipmentDetailItem>
    implements $ShipmentDetailItemCopyWith<$Res> {
  _$ShipmentDetailItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShipmentDetailItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? itemId = null,
    Object? productId = freezed,
    Object? variantId = freezed,
    Object? productName = freezed,
    Object? variantName = freezed,
    Object? displayName = freezed,
    Object? hasVariants = null,
    Object? sku = freezed,
    Object? quantityShipped = null,
    Object? quantityReceived = null,
    Object? quantityAccepted = null,
    Object? quantityRejected = null,
    Object? quantityRemaining = null,
    Object? unitCost = null,
    Object? totalAmount = null,
    Object? unit = freezed,
    Object? notes = freezed,
    Object? sortOrder = null,
  }) {
    return _then(_value.copyWith(
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      productId: freezed == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String?,
      variantId: freezed == variantId
          ? _value.variantId
          : variantId // ignore: cast_nullable_to_non_nullable
              as String?,
      productName: freezed == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String?,
      variantName: freezed == variantName
          ? _value.variantName
          : variantName // ignore: cast_nullable_to_non_nullable
              as String?,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      hasVariants: null == hasVariants
          ? _value.hasVariants
          : hasVariants // ignore: cast_nullable_to_non_nullable
              as bool,
      sku: freezed == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String?,
      quantityShipped: null == quantityShipped
          ? _value.quantityShipped
          : quantityShipped // ignore: cast_nullable_to_non_nullable
              as double,
      quantityReceived: null == quantityReceived
          ? _value.quantityReceived
          : quantityReceived // ignore: cast_nullable_to_non_nullable
              as double,
      quantityAccepted: null == quantityAccepted
          ? _value.quantityAccepted
          : quantityAccepted // ignore: cast_nullable_to_non_nullable
              as double,
      quantityRejected: null == quantityRejected
          ? _value.quantityRejected
          : quantityRejected // ignore: cast_nullable_to_non_nullable
              as double,
      quantityRemaining: null == quantityRemaining
          ? _value.quantityRemaining
          : quantityRemaining // ignore: cast_nullable_to_non_nullable
              as double,
      unitCost: null == unitCost
          ? _value.unitCost
          : unitCost // ignore: cast_nullable_to_non_nullable
              as double,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ShipmentDetailItemImplCopyWith<$Res>
    implements $ShipmentDetailItemCopyWith<$Res> {
  factory _$$ShipmentDetailItemImplCopyWith(_$ShipmentDetailItemImpl value,
          $Res Function(_$ShipmentDetailItemImpl) then) =
      __$$ShipmentDetailItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String itemId,
      String? productId,
      String? variantId,
      String? productName,
      String? variantName,
      String? displayName,
      bool hasVariants,
      String? sku,
      double quantityShipped,
      double quantityReceived,
      double quantityAccepted,
      double quantityRejected,
      double quantityRemaining,
      double unitCost,
      double totalAmount,
      String? unit,
      String? notes,
      int sortOrder});
}

/// @nodoc
class __$$ShipmentDetailItemImplCopyWithImpl<$Res>
    extends _$ShipmentDetailItemCopyWithImpl<$Res, _$ShipmentDetailItemImpl>
    implements _$$ShipmentDetailItemImplCopyWith<$Res> {
  __$$ShipmentDetailItemImplCopyWithImpl(_$ShipmentDetailItemImpl _value,
      $Res Function(_$ShipmentDetailItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of ShipmentDetailItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? itemId = null,
    Object? productId = freezed,
    Object? variantId = freezed,
    Object? productName = freezed,
    Object? variantName = freezed,
    Object? displayName = freezed,
    Object? hasVariants = null,
    Object? sku = freezed,
    Object? quantityShipped = null,
    Object? quantityReceived = null,
    Object? quantityAccepted = null,
    Object? quantityRejected = null,
    Object? quantityRemaining = null,
    Object? unitCost = null,
    Object? totalAmount = null,
    Object? unit = freezed,
    Object? notes = freezed,
    Object? sortOrder = null,
  }) {
    return _then(_$ShipmentDetailItemImpl(
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      productId: freezed == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String?,
      variantId: freezed == variantId
          ? _value.variantId
          : variantId // ignore: cast_nullable_to_non_nullable
              as String?,
      productName: freezed == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String?,
      variantName: freezed == variantName
          ? _value.variantName
          : variantName // ignore: cast_nullable_to_non_nullable
              as String?,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      hasVariants: null == hasVariants
          ? _value.hasVariants
          : hasVariants // ignore: cast_nullable_to_non_nullable
              as bool,
      sku: freezed == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String?,
      quantityShipped: null == quantityShipped
          ? _value.quantityShipped
          : quantityShipped // ignore: cast_nullable_to_non_nullable
              as double,
      quantityReceived: null == quantityReceived
          ? _value.quantityReceived
          : quantityReceived // ignore: cast_nullable_to_non_nullable
              as double,
      quantityAccepted: null == quantityAccepted
          ? _value.quantityAccepted
          : quantityAccepted // ignore: cast_nullable_to_non_nullable
              as double,
      quantityRejected: null == quantityRejected
          ? _value.quantityRejected
          : quantityRejected // ignore: cast_nullable_to_non_nullable
              as double,
      quantityRemaining: null == quantityRemaining
          ? _value.quantityRemaining
          : quantityRemaining // ignore: cast_nullable_to_non_nullable
              as double,
      unitCost: null == unitCost
          ? _value.unitCost
          : unitCost // ignore: cast_nullable_to_non_nullable
              as double,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$ShipmentDetailItemImpl extends _ShipmentDetailItem {
  const _$ShipmentDetailItemImpl(
      {required this.itemId,
      this.productId,
      this.variantId,
      this.productName,
      this.variantName,
      this.displayName,
      this.hasVariants = false,
      this.sku,
      this.quantityShipped = 0,
      this.quantityReceived = 0,
      this.quantityAccepted = 0,
      this.quantityRejected = 0,
      this.quantityRemaining = 0,
      this.unitCost = 0,
      this.totalAmount = 0,
      this.unit,
      this.notes,
      this.sortOrder = 0})
      : super._();

  @override
  final String itemId;
  @override
  final String? productId;
  @override
  final String? variantId;
  @override
  final String? productName;
  @override
  final String? variantName;
  @override
  final String? displayName;
  @override
  @JsonKey()
  final bool hasVariants;
  @override
  final String? sku;
  @override
  @JsonKey()
  final double quantityShipped;
  @override
  @JsonKey()
  final double quantityReceived;
  @override
  @JsonKey()
  final double quantityAccepted;
  @override
  @JsonKey()
  final double quantityRejected;
  @override
  @JsonKey()
  final double quantityRemaining;
  @override
  @JsonKey()
  final double unitCost;
  @override
  @JsonKey()
  final double totalAmount;
  @override
  final String? unit;
  @override
  final String? notes;
  @override
  @JsonKey()
  final int sortOrder;

  @override
  String toString() {
    return 'ShipmentDetailItem(itemId: $itemId, productId: $productId, variantId: $variantId, productName: $productName, variantName: $variantName, displayName: $displayName, hasVariants: $hasVariants, sku: $sku, quantityShipped: $quantityShipped, quantityReceived: $quantityReceived, quantityAccepted: $quantityAccepted, quantityRejected: $quantityRejected, quantityRemaining: $quantityRemaining, unitCost: $unitCost, totalAmount: $totalAmount, unit: $unit, notes: $notes, sortOrder: $sortOrder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShipmentDetailItemImpl &&
            (identical(other.itemId, itemId) || other.itemId == itemId) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.variantId, variantId) ||
                other.variantId == variantId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.variantName, variantName) ||
                other.variantName == variantName) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.hasVariants, hasVariants) ||
                other.hasVariants == hasVariants) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.quantityShipped, quantityShipped) ||
                other.quantityShipped == quantityShipped) &&
            (identical(other.quantityReceived, quantityReceived) ||
                other.quantityReceived == quantityReceived) &&
            (identical(other.quantityAccepted, quantityAccepted) ||
                other.quantityAccepted == quantityAccepted) &&
            (identical(other.quantityRejected, quantityRejected) ||
                other.quantityRejected == quantityRejected) &&
            (identical(other.quantityRemaining, quantityRemaining) ||
                other.quantityRemaining == quantityRemaining) &&
            (identical(other.unitCost, unitCost) ||
                other.unitCost == unitCost) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      itemId,
      productId,
      variantId,
      productName,
      variantName,
      displayName,
      hasVariants,
      sku,
      quantityShipped,
      quantityReceived,
      quantityAccepted,
      quantityRejected,
      quantityRemaining,
      unitCost,
      totalAmount,
      unit,
      notes,
      sortOrder);

  /// Create a copy of ShipmentDetailItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShipmentDetailItemImplCopyWith<_$ShipmentDetailItemImpl> get copyWith =>
      __$$ShipmentDetailItemImplCopyWithImpl<_$ShipmentDetailItemImpl>(
          this, _$identity);
}

abstract class _ShipmentDetailItem extends ShipmentDetailItem {
  const factory _ShipmentDetailItem(
      {required final String itemId,
      final String? productId,
      final String? variantId,
      final String? productName,
      final String? variantName,
      final String? displayName,
      final bool hasVariants,
      final String? sku,
      final double quantityShipped,
      final double quantityReceived,
      final double quantityAccepted,
      final double quantityRejected,
      final double quantityRemaining,
      final double unitCost,
      final double totalAmount,
      final String? unit,
      final String? notes,
      final int sortOrder}) = _$ShipmentDetailItemImpl;
  const _ShipmentDetailItem._() : super._();

  @override
  String get itemId;
  @override
  String? get productId;
  @override
  String? get variantId;
  @override
  String? get productName;
  @override
  String? get variantName;
  @override
  String? get displayName;
  @override
  bool get hasVariants;
  @override
  String? get sku;
  @override
  double get quantityShipped;
  @override
  double get quantityReceived;
  @override
  double get quantityAccepted;
  @override
  double get quantityRejected;
  @override
  double get quantityRemaining;
  @override
  double get unitCost;
  @override
  double get totalAmount;
  @override
  String? get unit;
  @override
  String? get notes;
  @override
  int get sortOrder;

  /// Create a copy of ShipmentDetailItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShipmentDetailItemImplCopyWith<_$ShipmentDetailItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ShipmentReceivingSummary {
  double get totalShipped => throw _privateConstructorUsedError;
  double get totalReceived => throw _privateConstructorUsedError;
  double get totalAccepted => throw _privateConstructorUsedError;
  double get totalRejected => throw _privateConstructorUsedError;
  double get totalRemaining => throw _privateConstructorUsedError;
  double get progressPercentage => throw _privateConstructorUsedError;

  /// Create a copy of ShipmentReceivingSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShipmentReceivingSummaryCopyWith<ShipmentReceivingSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShipmentReceivingSummaryCopyWith<$Res> {
  factory $ShipmentReceivingSummaryCopyWith(ShipmentReceivingSummary value,
          $Res Function(ShipmentReceivingSummary) then) =
      _$ShipmentReceivingSummaryCopyWithImpl<$Res, ShipmentReceivingSummary>;
  @useResult
  $Res call(
      {double totalShipped,
      double totalReceived,
      double totalAccepted,
      double totalRejected,
      double totalRemaining,
      double progressPercentage});
}

/// @nodoc
class _$ShipmentReceivingSummaryCopyWithImpl<$Res,
        $Val extends ShipmentReceivingSummary>
    implements $ShipmentReceivingSummaryCopyWith<$Res> {
  _$ShipmentReceivingSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShipmentReceivingSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalShipped = null,
    Object? totalReceived = null,
    Object? totalAccepted = null,
    Object? totalRejected = null,
    Object? totalRemaining = null,
    Object? progressPercentage = null,
  }) {
    return _then(_value.copyWith(
      totalShipped: null == totalShipped
          ? _value.totalShipped
          : totalShipped // ignore: cast_nullable_to_non_nullable
              as double,
      totalReceived: null == totalReceived
          ? _value.totalReceived
          : totalReceived // ignore: cast_nullable_to_non_nullable
              as double,
      totalAccepted: null == totalAccepted
          ? _value.totalAccepted
          : totalAccepted // ignore: cast_nullable_to_non_nullable
              as double,
      totalRejected: null == totalRejected
          ? _value.totalRejected
          : totalRejected // ignore: cast_nullable_to_non_nullable
              as double,
      totalRemaining: null == totalRemaining
          ? _value.totalRemaining
          : totalRemaining // ignore: cast_nullable_to_non_nullable
              as double,
      progressPercentage: null == progressPercentage
          ? _value.progressPercentage
          : progressPercentage // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ShipmentReceivingSummaryImplCopyWith<$Res>
    implements $ShipmentReceivingSummaryCopyWith<$Res> {
  factory _$$ShipmentReceivingSummaryImplCopyWith(
          _$ShipmentReceivingSummaryImpl value,
          $Res Function(_$ShipmentReceivingSummaryImpl) then) =
      __$$ShipmentReceivingSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double totalShipped,
      double totalReceived,
      double totalAccepted,
      double totalRejected,
      double totalRemaining,
      double progressPercentage});
}

/// @nodoc
class __$$ShipmentReceivingSummaryImplCopyWithImpl<$Res>
    extends _$ShipmentReceivingSummaryCopyWithImpl<$Res,
        _$ShipmentReceivingSummaryImpl>
    implements _$$ShipmentReceivingSummaryImplCopyWith<$Res> {
  __$$ShipmentReceivingSummaryImplCopyWithImpl(
      _$ShipmentReceivingSummaryImpl _value,
      $Res Function(_$ShipmentReceivingSummaryImpl) _then)
      : super(_value, _then);

  /// Create a copy of ShipmentReceivingSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalShipped = null,
    Object? totalReceived = null,
    Object? totalAccepted = null,
    Object? totalRejected = null,
    Object? totalRemaining = null,
    Object? progressPercentage = null,
  }) {
    return _then(_$ShipmentReceivingSummaryImpl(
      totalShipped: null == totalShipped
          ? _value.totalShipped
          : totalShipped // ignore: cast_nullable_to_non_nullable
              as double,
      totalReceived: null == totalReceived
          ? _value.totalReceived
          : totalReceived // ignore: cast_nullable_to_non_nullable
              as double,
      totalAccepted: null == totalAccepted
          ? _value.totalAccepted
          : totalAccepted // ignore: cast_nullable_to_non_nullable
              as double,
      totalRejected: null == totalRejected
          ? _value.totalRejected
          : totalRejected // ignore: cast_nullable_to_non_nullable
              as double,
      totalRemaining: null == totalRemaining
          ? _value.totalRemaining
          : totalRemaining // ignore: cast_nullable_to_non_nullable
              as double,
      progressPercentage: null == progressPercentage
          ? _value.progressPercentage
          : progressPercentage // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$ShipmentReceivingSummaryImpl extends _ShipmentReceivingSummary {
  const _$ShipmentReceivingSummaryImpl(
      {this.totalShipped = 0,
      this.totalReceived = 0,
      this.totalAccepted = 0,
      this.totalRejected = 0,
      this.totalRemaining = 0,
      this.progressPercentage = 0})
      : super._();

  @override
  @JsonKey()
  final double totalShipped;
  @override
  @JsonKey()
  final double totalReceived;
  @override
  @JsonKey()
  final double totalAccepted;
  @override
  @JsonKey()
  final double totalRejected;
  @override
  @JsonKey()
  final double totalRemaining;
  @override
  @JsonKey()
  final double progressPercentage;

  @override
  String toString() {
    return 'ShipmentReceivingSummary(totalShipped: $totalShipped, totalReceived: $totalReceived, totalAccepted: $totalAccepted, totalRejected: $totalRejected, totalRemaining: $totalRemaining, progressPercentage: $progressPercentage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShipmentReceivingSummaryImpl &&
            (identical(other.totalShipped, totalShipped) ||
                other.totalShipped == totalShipped) &&
            (identical(other.totalReceived, totalReceived) ||
                other.totalReceived == totalReceived) &&
            (identical(other.totalAccepted, totalAccepted) ||
                other.totalAccepted == totalAccepted) &&
            (identical(other.totalRejected, totalRejected) ||
                other.totalRejected == totalRejected) &&
            (identical(other.totalRemaining, totalRemaining) ||
                other.totalRemaining == totalRemaining) &&
            (identical(other.progressPercentage, progressPercentage) ||
                other.progressPercentage == progressPercentage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, totalShipped, totalReceived,
      totalAccepted, totalRejected, totalRemaining, progressPercentage);

  /// Create a copy of ShipmentReceivingSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShipmentReceivingSummaryImplCopyWith<_$ShipmentReceivingSummaryImpl>
      get copyWith => __$$ShipmentReceivingSummaryImplCopyWithImpl<
          _$ShipmentReceivingSummaryImpl>(this, _$identity);
}

abstract class _ShipmentReceivingSummary extends ShipmentReceivingSummary {
  const factory _ShipmentReceivingSummary(
      {final double totalShipped,
      final double totalReceived,
      final double totalAccepted,
      final double totalRejected,
      final double totalRemaining,
      final double progressPercentage}) = _$ShipmentReceivingSummaryImpl;
  const _ShipmentReceivingSummary._() : super._();

  @override
  double get totalShipped;
  @override
  double get totalReceived;
  @override
  double get totalAccepted;
  @override
  double get totalRejected;
  @override
  double get totalRemaining;
  @override
  double get progressPercentage;

  /// Create a copy of ShipmentReceivingSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShipmentReceivingSummaryImplCopyWith<_$ShipmentReceivingSummaryImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ShipmentLinkedOrder {
  String get orderId => throw _privateConstructorUsedError;
  String get orderNumber => throw _privateConstructorUsedError;
  String? get orderDate => throw _privateConstructorUsedError;
  String? get orderStatus => throw _privateConstructorUsedError;

  /// Create a copy of ShipmentLinkedOrder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShipmentLinkedOrderCopyWith<ShipmentLinkedOrder> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShipmentLinkedOrderCopyWith<$Res> {
  factory $ShipmentLinkedOrderCopyWith(
          ShipmentLinkedOrder value, $Res Function(ShipmentLinkedOrder) then) =
      _$ShipmentLinkedOrderCopyWithImpl<$Res, ShipmentLinkedOrder>;
  @useResult
  $Res call(
      {String orderId,
      String orderNumber,
      String? orderDate,
      String? orderStatus});
}

/// @nodoc
class _$ShipmentLinkedOrderCopyWithImpl<$Res, $Val extends ShipmentLinkedOrder>
    implements $ShipmentLinkedOrderCopyWith<$Res> {
  _$ShipmentLinkedOrderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShipmentLinkedOrder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = null,
    Object? orderNumber = null,
    Object? orderDate = freezed,
    Object? orderStatus = freezed,
  }) {
    return _then(_value.copyWith(
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String,
      orderNumber: null == orderNumber
          ? _value.orderNumber
          : orderNumber // ignore: cast_nullable_to_non_nullable
              as String,
      orderDate: freezed == orderDate
          ? _value.orderDate
          : orderDate // ignore: cast_nullable_to_non_nullable
              as String?,
      orderStatus: freezed == orderStatus
          ? _value.orderStatus
          : orderStatus // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ShipmentLinkedOrderImplCopyWith<$Res>
    implements $ShipmentLinkedOrderCopyWith<$Res> {
  factory _$$ShipmentLinkedOrderImplCopyWith(_$ShipmentLinkedOrderImpl value,
          $Res Function(_$ShipmentLinkedOrderImpl) then) =
      __$$ShipmentLinkedOrderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String orderId,
      String orderNumber,
      String? orderDate,
      String? orderStatus});
}

/// @nodoc
class __$$ShipmentLinkedOrderImplCopyWithImpl<$Res>
    extends _$ShipmentLinkedOrderCopyWithImpl<$Res, _$ShipmentLinkedOrderImpl>
    implements _$$ShipmentLinkedOrderImplCopyWith<$Res> {
  __$$ShipmentLinkedOrderImplCopyWithImpl(_$ShipmentLinkedOrderImpl _value,
      $Res Function(_$ShipmentLinkedOrderImpl) _then)
      : super(_value, _then);

  /// Create a copy of ShipmentLinkedOrder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = null,
    Object? orderNumber = null,
    Object? orderDate = freezed,
    Object? orderStatus = freezed,
  }) {
    return _then(_$ShipmentLinkedOrderImpl(
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String,
      orderNumber: null == orderNumber
          ? _value.orderNumber
          : orderNumber // ignore: cast_nullable_to_non_nullable
              as String,
      orderDate: freezed == orderDate
          ? _value.orderDate
          : orderDate // ignore: cast_nullable_to_non_nullable
              as String?,
      orderStatus: freezed == orderStatus
          ? _value.orderStatus
          : orderStatus // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ShipmentLinkedOrderImpl implements _ShipmentLinkedOrder {
  const _$ShipmentLinkedOrderImpl(
      {required this.orderId,
      required this.orderNumber,
      this.orderDate,
      this.orderStatus});

  @override
  final String orderId;
  @override
  final String orderNumber;
  @override
  final String? orderDate;
  @override
  final String? orderStatus;

  @override
  String toString() {
    return 'ShipmentLinkedOrder(orderId: $orderId, orderNumber: $orderNumber, orderDate: $orderDate, orderStatus: $orderStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShipmentLinkedOrderImpl &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.orderNumber, orderNumber) ||
                other.orderNumber == orderNumber) &&
            (identical(other.orderDate, orderDate) ||
                other.orderDate == orderDate) &&
            (identical(other.orderStatus, orderStatus) ||
                other.orderStatus == orderStatus));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, orderId, orderNumber, orderDate, orderStatus);

  /// Create a copy of ShipmentLinkedOrder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShipmentLinkedOrderImplCopyWith<_$ShipmentLinkedOrderImpl> get copyWith =>
      __$$ShipmentLinkedOrderImplCopyWithImpl<_$ShipmentLinkedOrderImpl>(
          this, _$identity);
}

abstract class _ShipmentLinkedOrder implements ShipmentLinkedOrder {
  const factory _ShipmentLinkedOrder(
      {required final String orderId,
      required final String orderNumber,
      final String? orderDate,
      final String? orderStatus}) = _$ShipmentLinkedOrderImpl;

  @override
  String get orderId;
  @override
  String get orderNumber;
  @override
  String? get orderDate;
  @override
  String? get orderStatus;

  /// Create a copy of ShipmentLinkedOrder
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShipmentLinkedOrderImplCopyWith<_$ShipmentLinkedOrderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ShipmentDetail {
// Header info
  String get shipmentId => throw _privateConstructorUsedError;
  String get shipmentNumber => throw _privateConstructorUsedError;
  String? get trackingNumber => throw _privateConstructorUsedError;
  DateTime? get shippedDate => throw _privateConstructorUsedError;
  ShipmentStatus get status => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  String? get updatedBy => throw _privateConstructorUsedError; // Supplier info
  ShipmentSupplierInfo? get supplierInfo =>
      throw _privateConstructorUsedError; // Items
  List<ShipmentDetailItem> get items =>
      throw _privateConstructorUsedError; // Receiving summary
  ShipmentReceivingSummary? get receivingSummary =>
      throw _privateConstructorUsedError; // Linked orders
  bool get hasOrders => throw _privateConstructorUsedError;
  int get orderCount => throw _privateConstructorUsedError;
  List<ShipmentLinkedOrder> get linkedOrders =>
      throw _privateConstructorUsedError; // Actions
  bool get canCancel => throw _privateConstructorUsedError;

  /// Create a copy of ShipmentDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShipmentDetailCopyWith<ShipmentDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShipmentDetailCopyWith<$Res> {
  factory $ShipmentDetailCopyWith(
          ShipmentDetail value, $Res Function(ShipmentDetail) then) =
      _$ShipmentDetailCopyWithImpl<$Res, ShipmentDetail>;
  @useResult
  $Res call(
      {String shipmentId,
      String shipmentNumber,
      String? trackingNumber,
      DateTime? shippedDate,
      ShipmentStatus status,
      String? notes,
      DateTime? createdAt,
      String? createdBy,
      DateTime? updatedAt,
      String? updatedBy,
      ShipmentSupplierInfo? supplierInfo,
      List<ShipmentDetailItem> items,
      ShipmentReceivingSummary? receivingSummary,
      bool hasOrders,
      int orderCount,
      List<ShipmentLinkedOrder> linkedOrders,
      bool canCancel});

  $ShipmentSupplierInfoCopyWith<$Res>? get supplierInfo;
  $ShipmentReceivingSummaryCopyWith<$Res>? get receivingSummary;
}

/// @nodoc
class _$ShipmentDetailCopyWithImpl<$Res, $Val extends ShipmentDetail>
    implements $ShipmentDetailCopyWith<$Res> {
  _$ShipmentDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShipmentDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shipmentId = null,
    Object? shipmentNumber = null,
    Object? trackingNumber = freezed,
    Object? shippedDate = freezed,
    Object? status = null,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? createdBy = freezed,
    Object? updatedAt = freezed,
    Object? updatedBy = freezed,
    Object? supplierInfo = freezed,
    Object? items = null,
    Object? receivingSummary = freezed,
    Object? hasOrders = null,
    Object? orderCount = null,
    Object? linkedOrders = null,
    Object? canCancel = null,
  }) {
    return _then(_value.copyWith(
      shipmentId: null == shipmentId
          ? _value.shipmentId
          : shipmentId // ignore: cast_nullable_to_non_nullable
              as String,
      shipmentNumber: null == shipmentNumber
          ? _value.shipmentNumber
          : shipmentNumber // ignore: cast_nullable_to_non_nullable
              as String,
      trackingNumber: freezed == trackingNumber
          ? _value.trackingNumber
          : trackingNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      shippedDate: freezed == shippedDate
          ? _value.shippedDate
          : shippedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ShipmentStatus,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedBy: freezed == updatedBy
          ? _value.updatedBy
          : updatedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierInfo: freezed == supplierInfo
          ? _value.supplierInfo
          : supplierInfo // ignore: cast_nullable_to_non_nullable
              as ShipmentSupplierInfo?,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<ShipmentDetailItem>,
      receivingSummary: freezed == receivingSummary
          ? _value.receivingSummary
          : receivingSummary // ignore: cast_nullable_to_non_nullable
              as ShipmentReceivingSummary?,
      hasOrders: null == hasOrders
          ? _value.hasOrders
          : hasOrders // ignore: cast_nullable_to_non_nullable
              as bool,
      orderCount: null == orderCount
          ? _value.orderCount
          : orderCount // ignore: cast_nullable_to_non_nullable
              as int,
      linkedOrders: null == linkedOrders
          ? _value.linkedOrders
          : linkedOrders // ignore: cast_nullable_to_non_nullable
              as List<ShipmentLinkedOrder>,
      canCancel: null == canCancel
          ? _value.canCancel
          : canCancel // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  /// Create a copy of ShipmentDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ShipmentSupplierInfoCopyWith<$Res>? get supplierInfo {
    if (_value.supplierInfo == null) {
      return null;
    }

    return $ShipmentSupplierInfoCopyWith<$Res>(_value.supplierInfo!, (value) {
      return _then(_value.copyWith(supplierInfo: value) as $Val);
    });
  }

  /// Create a copy of ShipmentDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ShipmentReceivingSummaryCopyWith<$Res>? get receivingSummary {
    if (_value.receivingSummary == null) {
      return null;
    }

    return $ShipmentReceivingSummaryCopyWith<$Res>(_value.receivingSummary!,
        (value) {
      return _then(_value.copyWith(receivingSummary: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ShipmentDetailImplCopyWith<$Res>
    implements $ShipmentDetailCopyWith<$Res> {
  factory _$$ShipmentDetailImplCopyWith(_$ShipmentDetailImpl value,
          $Res Function(_$ShipmentDetailImpl) then) =
      __$$ShipmentDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String shipmentId,
      String shipmentNumber,
      String? trackingNumber,
      DateTime? shippedDate,
      ShipmentStatus status,
      String? notes,
      DateTime? createdAt,
      String? createdBy,
      DateTime? updatedAt,
      String? updatedBy,
      ShipmentSupplierInfo? supplierInfo,
      List<ShipmentDetailItem> items,
      ShipmentReceivingSummary? receivingSummary,
      bool hasOrders,
      int orderCount,
      List<ShipmentLinkedOrder> linkedOrders,
      bool canCancel});

  @override
  $ShipmentSupplierInfoCopyWith<$Res>? get supplierInfo;
  @override
  $ShipmentReceivingSummaryCopyWith<$Res>? get receivingSummary;
}

/// @nodoc
class __$$ShipmentDetailImplCopyWithImpl<$Res>
    extends _$ShipmentDetailCopyWithImpl<$Res, _$ShipmentDetailImpl>
    implements _$$ShipmentDetailImplCopyWith<$Res> {
  __$$ShipmentDetailImplCopyWithImpl(
      _$ShipmentDetailImpl _value, $Res Function(_$ShipmentDetailImpl) _then)
      : super(_value, _then);

  /// Create a copy of ShipmentDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shipmentId = null,
    Object? shipmentNumber = null,
    Object? trackingNumber = freezed,
    Object? shippedDate = freezed,
    Object? status = null,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? createdBy = freezed,
    Object? updatedAt = freezed,
    Object? updatedBy = freezed,
    Object? supplierInfo = freezed,
    Object? items = null,
    Object? receivingSummary = freezed,
    Object? hasOrders = null,
    Object? orderCount = null,
    Object? linkedOrders = null,
    Object? canCancel = null,
  }) {
    return _then(_$ShipmentDetailImpl(
      shipmentId: null == shipmentId
          ? _value.shipmentId
          : shipmentId // ignore: cast_nullable_to_non_nullable
              as String,
      shipmentNumber: null == shipmentNumber
          ? _value.shipmentNumber
          : shipmentNumber // ignore: cast_nullable_to_non_nullable
              as String,
      trackingNumber: freezed == trackingNumber
          ? _value.trackingNumber
          : trackingNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      shippedDate: freezed == shippedDate
          ? _value.shippedDate
          : shippedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ShipmentStatus,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedBy: freezed == updatedBy
          ? _value.updatedBy
          : updatedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierInfo: freezed == supplierInfo
          ? _value.supplierInfo
          : supplierInfo // ignore: cast_nullable_to_non_nullable
              as ShipmentSupplierInfo?,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<ShipmentDetailItem>,
      receivingSummary: freezed == receivingSummary
          ? _value.receivingSummary
          : receivingSummary // ignore: cast_nullable_to_non_nullable
              as ShipmentReceivingSummary?,
      hasOrders: null == hasOrders
          ? _value.hasOrders
          : hasOrders // ignore: cast_nullable_to_non_nullable
              as bool,
      orderCount: null == orderCount
          ? _value.orderCount
          : orderCount // ignore: cast_nullable_to_non_nullable
              as int,
      linkedOrders: null == linkedOrders
          ? _value._linkedOrders
          : linkedOrders // ignore: cast_nullable_to_non_nullable
              as List<ShipmentLinkedOrder>,
      canCancel: null == canCancel
          ? _value.canCancel
          : canCancel // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$ShipmentDetailImpl extends _ShipmentDetail {
  const _$ShipmentDetailImpl(
      {required this.shipmentId,
      required this.shipmentNumber,
      this.trackingNumber,
      this.shippedDate,
      required this.status,
      this.notes,
      this.createdAt,
      this.createdBy,
      this.updatedAt,
      this.updatedBy,
      this.supplierInfo,
      final List<ShipmentDetailItem> items = const [],
      this.receivingSummary,
      this.hasOrders = false,
      this.orderCount = 0,
      final List<ShipmentLinkedOrder> linkedOrders = const [],
      this.canCancel = false})
      : _items = items,
        _linkedOrders = linkedOrders,
        super._();

// Header info
  @override
  final String shipmentId;
  @override
  final String shipmentNumber;
  @override
  final String? trackingNumber;
  @override
  final DateTime? shippedDate;
  @override
  final ShipmentStatus status;
  @override
  final String? notes;
  @override
  final DateTime? createdAt;
  @override
  final String? createdBy;
  @override
  final DateTime? updatedAt;
  @override
  final String? updatedBy;
// Supplier info
  @override
  final ShipmentSupplierInfo? supplierInfo;
// Items
  final List<ShipmentDetailItem> _items;
// Items
  @override
  @JsonKey()
  List<ShipmentDetailItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

// Receiving summary
  @override
  final ShipmentReceivingSummary? receivingSummary;
// Linked orders
  @override
  @JsonKey()
  final bool hasOrders;
  @override
  @JsonKey()
  final int orderCount;
  final List<ShipmentLinkedOrder> _linkedOrders;
  @override
  @JsonKey()
  List<ShipmentLinkedOrder> get linkedOrders {
    if (_linkedOrders is EqualUnmodifiableListView) return _linkedOrders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_linkedOrders);
  }

// Actions
  @override
  @JsonKey()
  final bool canCancel;

  @override
  String toString() {
    return 'ShipmentDetail(shipmentId: $shipmentId, shipmentNumber: $shipmentNumber, trackingNumber: $trackingNumber, shippedDate: $shippedDate, status: $status, notes: $notes, createdAt: $createdAt, createdBy: $createdBy, updatedAt: $updatedAt, updatedBy: $updatedBy, supplierInfo: $supplierInfo, items: $items, receivingSummary: $receivingSummary, hasOrders: $hasOrders, orderCount: $orderCount, linkedOrders: $linkedOrders, canCancel: $canCancel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShipmentDetailImpl &&
            (identical(other.shipmentId, shipmentId) ||
                other.shipmentId == shipmentId) &&
            (identical(other.shipmentNumber, shipmentNumber) ||
                other.shipmentNumber == shipmentNumber) &&
            (identical(other.trackingNumber, trackingNumber) ||
                other.trackingNumber == trackingNumber) &&
            (identical(other.shippedDate, shippedDate) ||
                other.shippedDate == shippedDate) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.updatedBy, updatedBy) ||
                other.updatedBy == updatedBy) &&
            (identical(other.supplierInfo, supplierInfo) ||
                other.supplierInfo == supplierInfo) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.receivingSummary, receivingSummary) ||
                other.receivingSummary == receivingSummary) &&
            (identical(other.hasOrders, hasOrders) ||
                other.hasOrders == hasOrders) &&
            (identical(other.orderCount, orderCount) ||
                other.orderCount == orderCount) &&
            const DeepCollectionEquality()
                .equals(other._linkedOrders, _linkedOrders) &&
            (identical(other.canCancel, canCancel) ||
                other.canCancel == canCancel));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      shipmentId,
      shipmentNumber,
      trackingNumber,
      shippedDate,
      status,
      notes,
      createdAt,
      createdBy,
      updatedAt,
      updatedBy,
      supplierInfo,
      const DeepCollectionEquality().hash(_items),
      receivingSummary,
      hasOrders,
      orderCount,
      const DeepCollectionEquality().hash(_linkedOrders),
      canCancel);

  /// Create a copy of ShipmentDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShipmentDetailImplCopyWith<_$ShipmentDetailImpl> get copyWith =>
      __$$ShipmentDetailImplCopyWithImpl<_$ShipmentDetailImpl>(
          this, _$identity);
}

abstract class _ShipmentDetail extends ShipmentDetail {
  const factory _ShipmentDetail(
      {required final String shipmentId,
      required final String shipmentNumber,
      final String? trackingNumber,
      final DateTime? shippedDate,
      required final ShipmentStatus status,
      final String? notes,
      final DateTime? createdAt,
      final String? createdBy,
      final DateTime? updatedAt,
      final String? updatedBy,
      final ShipmentSupplierInfo? supplierInfo,
      final List<ShipmentDetailItem> items,
      final ShipmentReceivingSummary? receivingSummary,
      final bool hasOrders,
      final int orderCount,
      final List<ShipmentLinkedOrder> linkedOrders,
      final bool canCancel}) = _$ShipmentDetailImpl;
  const _ShipmentDetail._() : super._();

// Header info
  @override
  String get shipmentId;
  @override
  String get shipmentNumber;
  @override
  String? get trackingNumber;
  @override
  DateTime? get shippedDate;
  @override
  ShipmentStatus get status;
  @override
  String? get notes;
  @override
  DateTime? get createdAt;
  @override
  String? get createdBy;
  @override
  DateTime? get updatedAt;
  @override
  String? get updatedBy; // Supplier info
  @override
  ShipmentSupplierInfo? get supplierInfo; // Items
  @override
  List<ShipmentDetailItem> get items; // Receiving summary
  @override
  ShipmentReceivingSummary? get receivingSummary; // Linked orders
  @override
  bool get hasOrders;
  @override
  int get orderCount;
  @override
  List<ShipmentLinkedOrder> get linkedOrders; // Actions
  @override
  bool get canCancel;

  /// Create a copy of ShipmentDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShipmentDetailImplCopyWith<_$ShipmentDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
