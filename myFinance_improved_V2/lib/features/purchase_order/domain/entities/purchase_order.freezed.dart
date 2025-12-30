// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'purchase_order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$POItem {
  String get itemId => throw _privateConstructorUsedError;
  String get poId => throw _privateConstructorUsedError;
  String? get piItemId => throw _privateConstructorUsedError;
  String? get productId => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String? get sku => throw _privateConstructorUsedError;
  String? get hsCode => throw _privateConstructorUsedError;
  double get quantity => throw _privateConstructorUsedError;
  double get shippedQuantity => throw _privateConstructorUsedError;
  String? get unit => throw _privateConstructorUsedError;
  double get unitPrice => throw _privateConstructorUsedError;
  double get totalAmount => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  int get sortOrder => throw _privateConstructorUsedError;
  DateTime? get createdAtUtc => throw _privateConstructorUsedError;

  /// Create a copy of POItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $POItemCopyWith<POItem> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $POItemCopyWith<$Res> {
  factory $POItemCopyWith(POItem value, $Res Function(POItem) then) =
      _$POItemCopyWithImpl<$Res, POItem>;
  @useResult
  $Res call(
      {String itemId,
      String poId,
      String? piItemId,
      String? productId,
      String description,
      String? sku,
      String? hsCode,
      double quantity,
      double shippedQuantity,
      String? unit,
      double unitPrice,
      double totalAmount,
      String? imageUrl,
      int sortOrder,
      DateTime? createdAtUtc});
}

/// @nodoc
class _$POItemCopyWithImpl<$Res, $Val extends POItem>
    implements $POItemCopyWith<$Res> {
  _$POItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of POItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? itemId = null,
    Object? poId = null,
    Object? piItemId = freezed,
    Object? productId = freezed,
    Object? description = null,
    Object? sku = freezed,
    Object? hsCode = freezed,
    Object? quantity = null,
    Object? shippedQuantity = null,
    Object? unit = freezed,
    Object? unitPrice = null,
    Object? totalAmount = null,
    Object? imageUrl = freezed,
    Object? sortOrder = null,
    Object? createdAtUtc = freezed,
  }) {
    return _then(_value.copyWith(
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      poId: null == poId
          ? _value.poId
          : poId // ignore: cast_nullable_to_non_nullable
              as String,
      piItemId: freezed == piItemId
          ? _value.piItemId
          : piItemId // ignore: cast_nullable_to_non_nullable
              as String?,
      productId: freezed == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String?,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      sku: freezed == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String?,
      hsCode: freezed == hsCode
          ? _value.hsCode
          : hsCode // ignore: cast_nullable_to_non_nullable
              as String?,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      shippedQuantity: null == shippedQuantity
          ? _value.shippedQuantity
          : shippedQuantity // ignore: cast_nullable_to_non_nullable
              as double,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      unitPrice: null == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
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
abstract class _$$POItemImplCopyWith<$Res> implements $POItemCopyWith<$Res> {
  factory _$$POItemImplCopyWith(
          _$POItemImpl value, $Res Function(_$POItemImpl) then) =
      __$$POItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String itemId,
      String poId,
      String? piItemId,
      String? productId,
      String description,
      String? sku,
      String? hsCode,
      double quantity,
      double shippedQuantity,
      String? unit,
      double unitPrice,
      double totalAmount,
      String? imageUrl,
      int sortOrder,
      DateTime? createdAtUtc});
}

/// @nodoc
class __$$POItemImplCopyWithImpl<$Res>
    extends _$POItemCopyWithImpl<$Res, _$POItemImpl>
    implements _$$POItemImplCopyWith<$Res> {
  __$$POItemImplCopyWithImpl(
      _$POItemImpl _value, $Res Function(_$POItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of POItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? itemId = null,
    Object? poId = null,
    Object? piItemId = freezed,
    Object? productId = freezed,
    Object? description = null,
    Object? sku = freezed,
    Object? hsCode = freezed,
    Object? quantity = null,
    Object? shippedQuantity = null,
    Object? unit = freezed,
    Object? unitPrice = null,
    Object? totalAmount = null,
    Object? imageUrl = freezed,
    Object? sortOrder = null,
    Object? createdAtUtc = freezed,
  }) {
    return _then(_$POItemImpl(
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      poId: null == poId
          ? _value.poId
          : poId // ignore: cast_nullable_to_non_nullable
              as String,
      piItemId: freezed == piItemId
          ? _value.piItemId
          : piItemId // ignore: cast_nullable_to_non_nullable
              as String?,
      productId: freezed == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String?,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      sku: freezed == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String?,
      hsCode: freezed == hsCode
          ? _value.hsCode
          : hsCode // ignore: cast_nullable_to_non_nullable
              as String?,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      shippedQuantity: null == shippedQuantity
          ? _value.shippedQuantity
          : shippedQuantity // ignore: cast_nullable_to_non_nullable
              as double,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      unitPrice: null == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
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

class _$POItemImpl extends _POItem {
  const _$POItemImpl(
      {required this.itemId,
      required this.poId,
      this.piItemId,
      this.productId,
      required this.description,
      this.sku,
      this.hsCode,
      required this.quantity,
      this.shippedQuantity = 0,
      this.unit,
      required this.unitPrice,
      required this.totalAmount,
      this.imageUrl,
      this.sortOrder = 0,
      this.createdAtUtc})
      : super._();

  @override
  final String itemId;
  @override
  final String poId;
  @override
  final String? piItemId;
  @override
  final String? productId;
  @override
  final String description;
  @override
  final String? sku;
  @override
  final String? hsCode;
  @override
  final double quantity;
  @override
  @JsonKey()
  final double shippedQuantity;
  @override
  final String? unit;
  @override
  final double unitPrice;
  @override
  final double totalAmount;
  @override
  final String? imageUrl;
  @override
  @JsonKey()
  final int sortOrder;
  @override
  final DateTime? createdAtUtc;

  @override
  String toString() {
    return 'POItem(itemId: $itemId, poId: $poId, piItemId: $piItemId, productId: $productId, description: $description, sku: $sku, hsCode: $hsCode, quantity: $quantity, shippedQuantity: $shippedQuantity, unit: $unit, unitPrice: $unitPrice, totalAmount: $totalAmount, imageUrl: $imageUrl, sortOrder: $sortOrder, createdAtUtc: $createdAtUtc)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$POItemImpl &&
            (identical(other.itemId, itemId) || other.itemId == itemId) &&
            (identical(other.poId, poId) || other.poId == poId) &&
            (identical(other.piItemId, piItemId) ||
                other.piItemId == piItemId) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.hsCode, hsCode) || other.hsCode == hsCode) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.shippedQuantity, shippedQuantity) ||
                other.shippedQuantity == shippedQuantity) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.createdAtUtc, createdAtUtc) ||
                other.createdAtUtc == createdAtUtc));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      itemId,
      poId,
      piItemId,
      productId,
      description,
      sku,
      hsCode,
      quantity,
      shippedQuantity,
      unit,
      unitPrice,
      totalAmount,
      imageUrl,
      sortOrder,
      createdAtUtc);

  /// Create a copy of POItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$POItemImplCopyWith<_$POItemImpl> get copyWith =>
      __$$POItemImplCopyWithImpl<_$POItemImpl>(this, _$identity);
}

abstract class _POItem extends POItem {
  const factory _POItem(
      {required final String itemId,
      required final String poId,
      final String? piItemId,
      final String? productId,
      required final String description,
      final String? sku,
      final String? hsCode,
      required final double quantity,
      final double shippedQuantity,
      final String? unit,
      required final double unitPrice,
      required final double totalAmount,
      final String? imageUrl,
      final int sortOrder,
      final DateTime? createdAtUtc}) = _$POItemImpl;
  const _POItem._() : super._();

  @override
  String get itemId;
  @override
  String get poId;
  @override
  String? get piItemId;
  @override
  String? get productId;
  @override
  String get description;
  @override
  String? get sku;
  @override
  String? get hsCode;
  @override
  double get quantity;
  @override
  double get shippedQuantity;
  @override
  String? get unit;
  @override
  double get unitPrice;
  @override
  double get totalAmount;
  @override
  String? get imageUrl;
  @override
  int get sortOrder;
  @override
  DateTime? get createdAtUtc;

  /// Create a copy of POItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$POItemImplCopyWith<_$POItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PurchaseOrder {
  String get poId => throw _privateConstructorUsedError;
  String get poNumber => throw _privateConstructorUsedError;
  String get companyId => throw _privateConstructorUsedError;
  String? get storeId => throw _privateConstructorUsedError;
  String? get piId => throw _privateConstructorUsedError;
  String? get piNumber => throw _privateConstructorUsedError;

  /// Seller (our company) info for PDF generation
  Map<String, dynamic>? get sellerInfo => throw _privateConstructorUsedError;

  /// Banking info for PDF (from cash_locations)
  List<Map<String, dynamic>>? get bankingInfo =>
      throw _privateConstructorUsedError;

  /// Selected bank account IDs (cash_location_ids) for PDF display
  List<String> get bankAccountIds => throw _privateConstructorUsedError;
  String? get buyerId => throw _privateConstructorUsedError;
  String? get buyerName => throw _privateConstructorUsedError;
  String? get buyerPoNumber => throw _privateConstructorUsedError;
  Map<String, dynamic>? get buyerInfo => throw _privateConstructorUsedError;
  String? get currencyId => throw _privateConstructorUsedError;
  String get currencyCode => throw _privateConstructorUsedError;
  double get totalAmount => throw _privateConstructorUsedError;
  String? get incotermsCode => throw _privateConstructorUsedError;
  String? get incotermsPlace => throw _privateConstructorUsedError;
  String? get paymentTermsCode => throw _privateConstructorUsedError;
  DateTime? get orderDateUtc => throw _privateConstructorUsedError;
  DateTime? get requiredShipmentDateUtc => throw _privateConstructorUsedError;
  bool get partialShipmentAllowed => throw _privateConstructorUsedError;
  bool get transshipmentAllowed => throw _privateConstructorUsedError;
  POStatus get status => throw _privateConstructorUsedError;
  int get version => throw _privateConstructorUsedError;
  double get shippedPercent => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;
  DateTime? get createdAtUtc => throw _privateConstructorUsedError;
  DateTime? get updatedAtUtc => throw _privateConstructorUsedError;
  List<POItem> get items => throw _privateConstructorUsedError;

  /// Create a copy of PurchaseOrder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PurchaseOrderCopyWith<PurchaseOrder> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PurchaseOrderCopyWith<$Res> {
  factory $PurchaseOrderCopyWith(
          PurchaseOrder value, $Res Function(PurchaseOrder) then) =
      _$PurchaseOrderCopyWithImpl<$Res, PurchaseOrder>;
  @useResult
  $Res call(
      {String poId,
      String poNumber,
      String companyId,
      String? storeId,
      String? piId,
      String? piNumber,
      Map<String, dynamic>? sellerInfo,
      List<Map<String, dynamic>>? bankingInfo,
      List<String> bankAccountIds,
      String? buyerId,
      String? buyerName,
      String? buyerPoNumber,
      Map<String, dynamic>? buyerInfo,
      String? currencyId,
      String currencyCode,
      double totalAmount,
      String? incotermsCode,
      String? incotermsPlace,
      String? paymentTermsCode,
      DateTime? orderDateUtc,
      DateTime? requiredShipmentDateUtc,
      bool partialShipmentAllowed,
      bool transshipmentAllowed,
      POStatus status,
      int version,
      double shippedPercent,
      String? notes,
      String? createdBy,
      DateTime? createdAtUtc,
      DateTime? updatedAtUtc,
      List<POItem> items});
}

/// @nodoc
class _$PurchaseOrderCopyWithImpl<$Res, $Val extends PurchaseOrder>
    implements $PurchaseOrderCopyWith<$Res> {
  _$PurchaseOrderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PurchaseOrder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? poId = null,
    Object? poNumber = null,
    Object? companyId = null,
    Object? storeId = freezed,
    Object? piId = freezed,
    Object? piNumber = freezed,
    Object? sellerInfo = freezed,
    Object? bankingInfo = freezed,
    Object? bankAccountIds = null,
    Object? buyerId = freezed,
    Object? buyerName = freezed,
    Object? buyerPoNumber = freezed,
    Object? buyerInfo = freezed,
    Object? currencyId = freezed,
    Object? currencyCode = null,
    Object? totalAmount = null,
    Object? incotermsCode = freezed,
    Object? incotermsPlace = freezed,
    Object? paymentTermsCode = freezed,
    Object? orderDateUtc = freezed,
    Object? requiredShipmentDateUtc = freezed,
    Object? partialShipmentAllowed = null,
    Object? transshipmentAllowed = null,
    Object? status = null,
    Object? version = null,
    Object? shippedPercent = null,
    Object? notes = freezed,
    Object? createdBy = freezed,
    Object? createdAtUtc = freezed,
    Object? updatedAtUtc = freezed,
    Object? items = null,
  }) {
    return _then(_value.copyWith(
      poId: null == poId
          ? _value.poId
          : poId // ignore: cast_nullable_to_non_nullable
              as String,
      poNumber: null == poNumber
          ? _value.poNumber
          : poNumber // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: freezed == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      piId: freezed == piId
          ? _value.piId
          : piId // ignore: cast_nullable_to_non_nullable
              as String?,
      piNumber: freezed == piNumber
          ? _value.piNumber
          : piNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      sellerInfo: freezed == sellerInfo
          ? _value.sellerInfo
          : sellerInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      bankingInfo: freezed == bankingInfo
          ? _value.bankingInfo
          : bankingInfo // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>?,
      bankAccountIds: null == bankAccountIds
          ? _value.bankAccountIds
          : bankAccountIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      buyerId: freezed == buyerId
          ? _value.buyerId
          : buyerId // ignore: cast_nullable_to_non_nullable
              as String?,
      buyerName: freezed == buyerName
          ? _value.buyerName
          : buyerName // ignore: cast_nullable_to_non_nullable
              as String?,
      buyerPoNumber: freezed == buyerPoNumber
          ? _value.buyerPoNumber
          : buyerPoNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      buyerInfo: freezed == buyerInfo
          ? _value.buyerInfo
          : buyerInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      currencyId: freezed == currencyId
          ? _value.currencyId
          : currencyId // ignore: cast_nullable_to_non_nullable
              as String?,
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      incotermsCode: freezed == incotermsCode
          ? _value.incotermsCode
          : incotermsCode // ignore: cast_nullable_to_non_nullable
              as String?,
      incotermsPlace: freezed == incotermsPlace
          ? _value.incotermsPlace
          : incotermsPlace // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentTermsCode: freezed == paymentTermsCode
          ? _value.paymentTermsCode
          : paymentTermsCode // ignore: cast_nullable_to_non_nullable
              as String?,
      orderDateUtc: freezed == orderDateUtc
          ? _value.orderDateUtc
          : orderDateUtc // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      requiredShipmentDateUtc: freezed == requiredShipmentDateUtc
          ? _value.requiredShipmentDateUtc
          : requiredShipmentDateUtc // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      partialShipmentAllowed: null == partialShipmentAllowed
          ? _value.partialShipmentAllowed
          : partialShipmentAllowed // ignore: cast_nullable_to_non_nullable
              as bool,
      transshipmentAllowed: null == transshipmentAllowed
          ? _value.transshipmentAllowed
          : transshipmentAllowed // ignore: cast_nullable_to_non_nullable
              as bool,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as POStatus,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
      shippedPercent: null == shippedPercent
          ? _value.shippedPercent
          : shippedPercent // ignore: cast_nullable_to_non_nullable
              as double,
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
              as List<POItem>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PurchaseOrderImplCopyWith<$Res>
    implements $PurchaseOrderCopyWith<$Res> {
  factory _$$PurchaseOrderImplCopyWith(
          _$PurchaseOrderImpl value, $Res Function(_$PurchaseOrderImpl) then) =
      __$$PurchaseOrderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String poId,
      String poNumber,
      String companyId,
      String? storeId,
      String? piId,
      String? piNumber,
      Map<String, dynamic>? sellerInfo,
      List<Map<String, dynamic>>? bankingInfo,
      List<String> bankAccountIds,
      String? buyerId,
      String? buyerName,
      String? buyerPoNumber,
      Map<String, dynamic>? buyerInfo,
      String? currencyId,
      String currencyCode,
      double totalAmount,
      String? incotermsCode,
      String? incotermsPlace,
      String? paymentTermsCode,
      DateTime? orderDateUtc,
      DateTime? requiredShipmentDateUtc,
      bool partialShipmentAllowed,
      bool transshipmentAllowed,
      POStatus status,
      int version,
      double shippedPercent,
      String? notes,
      String? createdBy,
      DateTime? createdAtUtc,
      DateTime? updatedAtUtc,
      List<POItem> items});
}

/// @nodoc
class __$$PurchaseOrderImplCopyWithImpl<$Res>
    extends _$PurchaseOrderCopyWithImpl<$Res, _$PurchaseOrderImpl>
    implements _$$PurchaseOrderImplCopyWith<$Res> {
  __$$PurchaseOrderImplCopyWithImpl(
      _$PurchaseOrderImpl _value, $Res Function(_$PurchaseOrderImpl) _then)
      : super(_value, _then);

  /// Create a copy of PurchaseOrder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? poId = null,
    Object? poNumber = null,
    Object? companyId = null,
    Object? storeId = freezed,
    Object? piId = freezed,
    Object? piNumber = freezed,
    Object? sellerInfo = freezed,
    Object? bankingInfo = freezed,
    Object? bankAccountIds = null,
    Object? buyerId = freezed,
    Object? buyerName = freezed,
    Object? buyerPoNumber = freezed,
    Object? buyerInfo = freezed,
    Object? currencyId = freezed,
    Object? currencyCode = null,
    Object? totalAmount = null,
    Object? incotermsCode = freezed,
    Object? incotermsPlace = freezed,
    Object? paymentTermsCode = freezed,
    Object? orderDateUtc = freezed,
    Object? requiredShipmentDateUtc = freezed,
    Object? partialShipmentAllowed = null,
    Object? transshipmentAllowed = null,
    Object? status = null,
    Object? version = null,
    Object? shippedPercent = null,
    Object? notes = freezed,
    Object? createdBy = freezed,
    Object? createdAtUtc = freezed,
    Object? updatedAtUtc = freezed,
    Object? items = null,
  }) {
    return _then(_$PurchaseOrderImpl(
      poId: null == poId
          ? _value.poId
          : poId // ignore: cast_nullable_to_non_nullable
              as String,
      poNumber: null == poNumber
          ? _value.poNumber
          : poNumber // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: freezed == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      piId: freezed == piId
          ? _value.piId
          : piId // ignore: cast_nullable_to_non_nullable
              as String?,
      piNumber: freezed == piNumber
          ? _value.piNumber
          : piNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      sellerInfo: freezed == sellerInfo
          ? _value._sellerInfo
          : sellerInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      bankingInfo: freezed == bankingInfo
          ? _value._bankingInfo
          : bankingInfo // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>?,
      bankAccountIds: null == bankAccountIds
          ? _value._bankAccountIds
          : bankAccountIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      buyerId: freezed == buyerId
          ? _value.buyerId
          : buyerId // ignore: cast_nullable_to_non_nullable
              as String?,
      buyerName: freezed == buyerName
          ? _value.buyerName
          : buyerName // ignore: cast_nullable_to_non_nullable
              as String?,
      buyerPoNumber: freezed == buyerPoNumber
          ? _value.buyerPoNumber
          : buyerPoNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      buyerInfo: freezed == buyerInfo
          ? _value._buyerInfo
          : buyerInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      currencyId: freezed == currencyId
          ? _value.currencyId
          : currencyId // ignore: cast_nullable_to_non_nullable
              as String?,
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      incotermsCode: freezed == incotermsCode
          ? _value.incotermsCode
          : incotermsCode // ignore: cast_nullable_to_non_nullable
              as String?,
      incotermsPlace: freezed == incotermsPlace
          ? _value.incotermsPlace
          : incotermsPlace // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentTermsCode: freezed == paymentTermsCode
          ? _value.paymentTermsCode
          : paymentTermsCode // ignore: cast_nullable_to_non_nullable
              as String?,
      orderDateUtc: freezed == orderDateUtc
          ? _value.orderDateUtc
          : orderDateUtc // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      requiredShipmentDateUtc: freezed == requiredShipmentDateUtc
          ? _value.requiredShipmentDateUtc
          : requiredShipmentDateUtc // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      partialShipmentAllowed: null == partialShipmentAllowed
          ? _value.partialShipmentAllowed
          : partialShipmentAllowed // ignore: cast_nullable_to_non_nullable
              as bool,
      transshipmentAllowed: null == transshipmentAllowed
          ? _value.transshipmentAllowed
          : transshipmentAllowed // ignore: cast_nullable_to_non_nullable
              as bool,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as POStatus,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
      shippedPercent: null == shippedPercent
          ? _value.shippedPercent
          : shippedPercent // ignore: cast_nullable_to_non_nullable
              as double,
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
              as List<POItem>,
    ));
  }
}

/// @nodoc

class _$PurchaseOrderImpl extends _PurchaseOrder {
  const _$PurchaseOrderImpl(
      {required this.poId,
      required this.poNumber,
      required this.companyId,
      this.storeId,
      this.piId,
      this.piNumber,
      final Map<String, dynamic>? sellerInfo,
      final List<Map<String, dynamic>>? bankingInfo,
      final List<String> bankAccountIds = const [],
      this.buyerId,
      this.buyerName,
      this.buyerPoNumber,
      final Map<String, dynamic>? buyerInfo,
      this.currencyId,
      this.currencyCode = 'USD',
      this.totalAmount = 0,
      this.incotermsCode,
      this.incotermsPlace,
      this.paymentTermsCode,
      this.orderDateUtc,
      this.requiredShipmentDateUtc,
      this.partialShipmentAllowed = true,
      this.transshipmentAllowed = true,
      this.status = POStatus.draft,
      this.version = 1,
      this.shippedPercent = 0,
      this.notes,
      this.createdBy,
      this.createdAtUtc,
      this.updatedAtUtc,
      final List<POItem> items = const []})
      : _sellerInfo = sellerInfo,
        _bankingInfo = bankingInfo,
        _bankAccountIds = bankAccountIds,
        _buyerInfo = buyerInfo,
        _items = items,
        super._();

  @override
  final String poId;
  @override
  final String poNumber;
  @override
  final String companyId;
  @override
  final String? storeId;
  @override
  final String? piId;
  @override
  final String? piNumber;

  /// Seller (our company) info for PDF generation
  final Map<String, dynamic>? _sellerInfo;

  /// Seller (our company) info for PDF generation
  @override
  Map<String, dynamic>? get sellerInfo {
    final value = _sellerInfo;
    if (value == null) return null;
    if (_sellerInfo is EqualUnmodifiableMapView) return _sellerInfo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// Banking info for PDF (from cash_locations)
  final List<Map<String, dynamic>>? _bankingInfo;

  /// Banking info for PDF (from cash_locations)
  @override
  List<Map<String, dynamic>>? get bankingInfo {
    final value = _bankingInfo;
    if (value == null) return null;
    if (_bankingInfo is EqualUnmodifiableListView) return _bankingInfo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Selected bank account IDs (cash_location_ids) for PDF display
  final List<String> _bankAccountIds;

  /// Selected bank account IDs (cash_location_ids) for PDF display
  @override
  @JsonKey()
  List<String> get bankAccountIds {
    if (_bankAccountIds is EqualUnmodifiableListView) return _bankAccountIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_bankAccountIds);
  }

  @override
  final String? buyerId;
  @override
  final String? buyerName;
  @override
  final String? buyerPoNumber;
  final Map<String, dynamic>? _buyerInfo;
  @override
  Map<String, dynamic>? get buyerInfo {
    final value = _buyerInfo;
    if (value == null) return null;
    if (_buyerInfo is EqualUnmodifiableMapView) return _buyerInfo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? currencyId;
  @override
  @JsonKey()
  final String currencyCode;
  @override
  @JsonKey()
  final double totalAmount;
  @override
  final String? incotermsCode;
  @override
  final String? incotermsPlace;
  @override
  final String? paymentTermsCode;
  @override
  final DateTime? orderDateUtc;
  @override
  final DateTime? requiredShipmentDateUtc;
  @override
  @JsonKey()
  final bool partialShipmentAllowed;
  @override
  @JsonKey()
  final bool transshipmentAllowed;
  @override
  @JsonKey()
  final POStatus status;
  @override
  @JsonKey()
  final int version;
  @override
  @JsonKey()
  final double shippedPercent;
  @override
  final String? notes;
  @override
  final String? createdBy;
  @override
  final DateTime? createdAtUtc;
  @override
  final DateTime? updatedAtUtc;
  final List<POItem> _items;
  @override
  @JsonKey()
  List<POItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'PurchaseOrder(poId: $poId, poNumber: $poNumber, companyId: $companyId, storeId: $storeId, piId: $piId, piNumber: $piNumber, sellerInfo: $sellerInfo, bankingInfo: $bankingInfo, bankAccountIds: $bankAccountIds, buyerId: $buyerId, buyerName: $buyerName, buyerPoNumber: $buyerPoNumber, buyerInfo: $buyerInfo, currencyId: $currencyId, currencyCode: $currencyCode, totalAmount: $totalAmount, incotermsCode: $incotermsCode, incotermsPlace: $incotermsPlace, paymentTermsCode: $paymentTermsCode, orderDateUtc: $orderDateUtc, requiredShipmentDateUtc: $requiredShipmentDateUtc, partialShipmentAllowed: $partialShipmentAllowed, transshipmentAllowed: $transshipmentAllowed, status: $status, version: $version, shippedPercent: $shippedPercent, notes: $notes, createdBy: $createdBy, createdAtUtc: $createdAtUtc, updatedAtUtc: $updatedAtUtc, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PurchaseOrderImpl &&
            (identical(other.poId, poId) || other.poId == poId) &&
            (identical(other.poNumber, poNumber) ||
                other.poNumber == poNumber) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.piId, piId) || other.piId == piId) &&
            (identical(other.piNumber, piNumber) ||
                other.piNumber == piNumber) &&
            const DeepCollectionEquality()
                .equals(other._sellerInfo, _sellerInfo) &&
            const DeepCollectionEquality()
                .equals(other._bankingInfo, _bankingInfo) &&
            const DeepCollectionEquality()
                .equals(other._bankAccountIds, _bankAccountIds) &&
            (identical(other.buyerId, buyerId) || other.buyerId == buyerId) &&
            (identical(other.buyerName, buyerName) ||
                other.buyerName == buyerName) &&
            (identical(other.buyerPoNumber, buyerPoNumber) ||
                other.buyerPoNumber == buyerPoNumber) &&
            const DeepCollectionEquality()
                .equals(other._buyerInfo, _buyerInfo) &&
            (identical(other.currencyId, currencyId) ||
                other.currencyId == currencyId) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.incotermsCode, incotermsCode) ||
                other.incotermsCode == incotermsCode) &&
            (identical(other.incotermsPlace, incotermsPlace) ||
                other.incotermsPlace == incotermsPlace) &&
            (identical(other.paymentTermsCode, paymentTermsCode) ||
                other.paymentTermsCode == paymentTermsCode) &&
            (identical(other.orderDateUtc, orderDateUtc) ||
                other.orderDateUtc == orderDateUtc) &&
            (identical(
                    other.requiredShipmentDateUtc, requiredShipmentDateUtc) ||
                other.requiredShipmentDateUtc == requiredShipmentDateUtc) &&
            (identical(other.partialShipmentAllowed, partialShipmentAllowed) ||
                other.partialShipmentAllowed == partialShipmentAllowed) &&
            (identical(other.transshipmentAllowed, transshipmentAllowed) ||
                other.transshipmentAllowed == transshipmentAllowed) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.shippedPercent, shippedPercent) ||
                other.shippedPercent == shippedPercent) &&
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
  int get hashCode => Object.hashAll([
        runtimeType,
        poId,
        poNumber,
        companyId,
        storeId,
        piId,
        piNumber,
        const DeepCollectionEquality().hash(_sellerInfo),
        const DeepCollectionEquality().hash(_bankingInfo),
        const DeepCollectionEquality().hash(_bankAccountIds),
        buyerId,
        buyerName,
        buyerPoNumber,
        const DeepCollectionEquality().hash(_buyerInfo),
        currencyId,
        currencyCode,
        totalAmount,
        incotermsCode,
        incotermsPlace,
        paymentTermsCode,
        orderDateUtc,
        requiredShipmentDateUtc,
        partialShipmentAllowed,
        transshipmentAllowed,
        status,
        version,
        shippedPercent,
        notes,
        createdBy,
        createdAtUtc,
        updatedAtUtc,
        const DeepCollectionEquality().hash(_items)
      ]);

  /// Create a copy of PurchaseOrder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PurchaseOrderImplCopyWith<_$PurchaseOrderImpl> get copyWith =>
      __$$PurchaseOrderImplCopyWithImpl<_$PurchaseOrderImpl>(this, _$identity);
}

abstract class _PurchaseOrder extends PurchaseOrder {
  const factory _PurchaseOrder(
      {required final String poId,
      required final String poNumber,
      required final String companyId,
      final String? storeId,
      final String? piId,
      final String? piNumber,
      final Map<String, dynamic>? sellerInfo,
      final List<Map<String, dynamic>>? bankingInfo,
      final List<String> bankAccountIds,
      final String? buyerId,
      final String? buyerName,
      final String? buyerPoNumber,
      final Map<String, dynamic>? buyerInfo,
      final String? currencyId,
      final String currencyCode,
      final double totalAmount,
      final String? incotermsCode,
      final String? incotermsPlace,
      final String? paymentTermsCode,
      final DateTime? orderDateUtc,
      final DateTime? requiredShipmentDateUtc,
      final bool partialShipmentAllowed,
      final bool transshipmentAllowed,
      final POStatus status,
      final int version,
      final double shippedPercent,
      final String? notes,
      final String? createdBy,
      final DateTime? createdAtUtc,
      final DateTime? updatedAtUtc,
      final List<POItem> items}) = _$PurchaseOrderImpl;
  const _PurchaseOrder._() : super._();

  @override
  String get poId;
  @override
  String get poNumber;
  @override
  String get companyId;
  @override
  String? get storeId;
  @override
  String? get piId;
  @override
  String? get piNumber;

  /// Seller (our company) info for PDF generation
  @override
  Map<String, dynamic>? get sellerInfo;

  /// Banking info for PDF (from cash_locations)
  @override
  List<Map<String, dynamic>>? get bankingInfo;

  /// Selected bank account IDs (cash_location_ids) for PDF display
  @override
  List<String> get bankAccountIds;
  @override
  String? get buyerId;
  @override
  String? get buyerName;
  @override
  String? get buyerPoNumber;
  @override
  Map<String, dynamic>? get buyerInfo;
  @override
  String? get currencyId;
  @override
  String get currencyCode;
  @override
  double get totalAmount;
  @override
  String? get incotermsCode;
  @override
  String? get incotermsPlace;
  @override
  String? get paymentTermsCode;
  @override
  DateTime? get orderDateUtc;
  @override
  DateTime? get requiredShipmentDateUtc;
  @override
  bool get partialShipmentAllowed;
  @override
  bool get transshipmentAllowed;
  @override
  POStatus get status;
  @override
  int get version;
  @override
  double get shippedPercent;
  @override
  String? get notes;
  @override
  String? get createdBy;
  @override
  DateTime? get createdAtUtc;
  @override
  DateTime? get updatedAtUtc;
  @override
  List<POItem> get items;

  /// Create a copy of PurchaseOrder
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PurchaseOrderImplCopyWith<_$PurchaseOrderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$POListItem {
  String get poId => throw _privateConstructorUsedError;
  String get poNumber => throw _privateConstructorUsedError;
  String? get piNumber => throw _privateConstructorUsedError;
  String? get buyerName => throw _privateConstructorUsedError;
  String? get buyerPoNumber => throw _privateConstructorUsedError;
  String get currencyCode => throw _privateConstructorUsedError;
  double get totalAmount => throw _privateConstructorUsedError;
  POStatus get status => throw _privateConstructorUsedError;
  double get shippedPercent => throw _privateConstructorUsedError;
  DateTime? get orderDateUtc => throw _privateConstructorUsedError;
  DateTime? get requiredShipmentDateUtc => throw _privateConstructorUsedError;
  DateTime? get createdAtUtc => throw _privateConstructorUsedError;
  int get itemCount => throw _privateConstructorUsedError;

  /// Create a copy of POListItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $POListItemCopyWith<POListItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $POListItemCopyWith<$Res> {
  factory $POListItemCopyWith(
          POListItem value, $Res Function(POListItem) then) =
      _$POListItemCopyWithImpl<$Res, POListItem>;
  @useResult
  $Res call(
      {String poId,
      String poNumber,
      String? piNumber,
      String? buyerName,
      String? buyerPoNumber,
      String currencyCode,
      double totalAmount,
      POStatus status,
      double shippedPercent,
      DateTime? orderDateUtc,
      DateTime? requiredShipmentDateUtc,
      DateTime? createdAtUtc,
      int itemCount});
}

/// @nodoc
class _$POListItemCopyWithImpl<$Res, $Val extends POListItem>
    implements $POListItemCopyWith<$Res> {
  _$POListItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of POListItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? poId = null,
    Object? poNumber = null,
    Object? piNumber = freezed,
    Object? buyerName = freezed,
    Object? buyerPoNumber = freezed,
    Object? currencyCode = null,
    Object? totalAmount = null,
    Object? status = null,
    Object? shippedPercent = null,
    Object? orderDateUtc = freezed,
    Object? requiredShipmentDateUtc = freezed,
    Object? createdAtUtc = freezed,
    Object? itemCount = null,
  }) {
    return _then(_value.copyWith(
      poId: null == poId
          ? _value.poId
          : poId // ignore: cast_nullable_to_non_nullable
              as String,
      poNumber: null == poNumber
          ? _value.poNumber
          : poNumber // ignore: cast_nullable_to_non_nullable
              as String,
      piNumber: freezed == piNumber
          ? _value.piNumber
          : piNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      buyerName: freezed == buyerName
          ? _value.buyerName
          : buyerName // ignore: cast_nullable_to_non_nullable
              as String?,
      buyerPoNumber: freezed == buyerPoNumber
          ? _value.buyerPoNumber
          : buyerPoNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as POStatus,
      shippedPercent: null == shippedPercent
          ? _value.shippedPercent
          : shippedPercent // ignore: cast_nullable_to_non_nullable
              as double,
      orderDateUtc: freezed == orderDateUtc
          ? _value.orderDateUtc
          : orderDateUtc // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      requiredShipmentDateUtc: freezed == requiredShipmentDateUtc
          ? _value.requiredShipmentDateUtc
          : requiredShipmentDateUtc // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAtUtc: freezed == createdAtUtc
          ? _value.createdAtUtc
          : createdAtUtc // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      itemCount: null == itemCount
          ? _value.itemCount
          : itemCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$POListItemImplCopyWith<$Res>
    implements $POListItemCopyWith<$Res> {
  factory _$$POListItemImplCopyWith(
          _$POListItemImpl value, $Res Function(_$POListItemImpl) then) =
      __$$POListItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String poId,
      String poNumber,
      String? piNumber,
      String? buyerName,
      String? buyerPoNumber,
      String currencyCode,
      double totalAmount,
      POStatus status,
      double shippedPercent,
      DateTime? orderDateUtc,
      DateTime? requiredShipmentDateUtc,
      DateTime? createdAtUtc,
      int itemCount});
}

/// @nodoc
class __$$POListItemImplCopyWithImpl<$Res>
    extends _$POListItemCopyWithImpl<$Res, _$POListItemImpl>
    implements _$$POListItemImplCopyWith<$Res> {
  __$$POListItemImplCopyWithImpl(
      _$POListItemImpl _value, $Res Function(_$POListItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of POListItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? poId = null,
    Object? poNumber = null,
    Object? piNumber = freezed,
    Object? buyerName = freezed,
    Object? buyerPoNumber = freezed,
    Object? currencyCode = null,
    Object? totalAmount = null,
    Object? status = null,
    Object? shippedPercent = null,
    Object? orderDateUtc = freezed,
    Object? requiredShipmentDateUtc = freezed,
    Object? createdAtUtc = freezed,
    Object? itemCount = null,
  }) {
    return _then(_$POListItemImpl(
      poId: null == poId
          ? _value.poId
          : poId // ignore: cast_nullable_to_non_nullable
              as String,
      poNumber: null == poNumber
          ? _value.poNumber
          : poNumber // ignore: cast_nullable_to_non_nullable
              as String,
      piNumber: freezed == piNumber
          ? _value.piNumber
          : piNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      buyerName: freezed == buyerName
          ? _value.buyerName
          : buyerName // ignore: cast_nullable_to_non_nullable
              as String?,
      buyerPoNumber: freezed == buyerPoNumber
          ? _value.buyerPoNumber
          : buyerPoNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as POStatus,
      shippedPercent: null == shippedPercent
          ? _value.shippedPercent
          : shippedPercent // ignore: cast_nullable_to_non_nullable
              as double,
      orderDateUtc: freezed == orderDateUtc
          ? _value.orderDateUtc
          : orderDateUtc // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      requiredShipmentDateUtc: freezed == requiredShipmentDateUtc
          ? _value.requiredShipmentDateUtc
          : requiredShipmentDateUtc // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAtUtc: freezed == createdAtUtc
          ? _value.createdAtUtc
          : createdAtUtc // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      itemCount: null == itemCount
          ? _value.itemCount
          : itemCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$POListItemImpl extends _POListItem {
  const _$POListItemImpl(
      {required this.poId,
      required this.poNumber,
      this.piNumber,
      this.buyerName,
      this.buyerPoNumber,
      required this.currencyCode,
      required this.totalAmount,
      required this.status,
      this.shippedPercent = 0,
      this.orderDateUtc,
      this.requiredShipmentDateUtc,
      this.createdAtUtc,
      this.itemCount = 0})
      : super._();

  @override
  final String poId;
  @override
  final String poNumber;
  @override
  final String? piNumber;
  @override
  final String? buyerName;
  @override
  final String? buyerPoNumber;
  @override
  final String currencyCode;
  @override
  final double totalAmount;
  @override
  final POStatus status;
  @override
  @JsonKey()
  final double shippedPercent;
  @override
  final DateTime? orderDateUtc;
  @override
  final DateTime? requiredShipmentDateUtc;
  @override
  final DateTime? createdAtUtc;
  @override
  @JsonKey()
  final int itemCount;

  @override
  String toString() {
    return 'POListItem(poId: $poId, poNumber: $poNumber, piNumber: $piNumber, buyerName: $buyerName, buyerPoNumber: $buyerPoNumber, currencyCode: $currencyCode, totalAmount: $totalAmount, status: $status, shippedPercent: $shippedPercent, orderDateUtc: $orderDateUtc, requiredShipmentDateUtc: $requiredShipmentDateUtc, createdAtUtc: $createdAtUtc, itemCount: $itemCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$POListItemImpl &&
            (identical(other.poId, poId) || other.poId == poId) &&
            (identical(other.poNumber, poNumber) ||
                other.poNumber == poNumber) &&
            (identical(other.piNumber, piNumber) ||
                other.piNumber == piNumber) &&
            (identical(other.buyerName, buyerName) ||
                other.buyerName == buyerName) &&
            (identical(other.buyerPoNumber, buyerPoNumber) ||
                other.buyerPoNumber == buyerPoNumber) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.shippedPercent, shippedPercent) ||
                other.shippedPercent == shippedPercent) &&
            (identical(other.orderDateUtc, orderDateUtc) ||
                other.orderDateUtc == orderDateUtc) &&
            (identical(
                    other.requiredShipmentDateUtc, requiredShipmentDateUtc) ||
                other.requiredShipmentDateUtc == requiredShipmentDateUtc) &&
            (identical(other.createdAtUtc, createdAtUtc) ||
                other.createdAtUtc == createdAtUtc) &&
            (identical(other.itemCount, itemCount) ||
                other.itemCount == itemCount));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      poId,
      poNumber,
      piNumber,
      buyerName,
      buyerPoNumber,
      currencyCode,
      totalAmount,
      status,
      shippedPercent,
      orderDateUtc,
      requiredShipmentDateUtc,
      createdAtUtc,
      itemCount);

  /// Create a copy of POListItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$POListItemImplCopyWith<_$POListItemImpl> get copyWith =>
      __$$POListItemImplCopyWithImpl<_$POListItemImpl>(this, _$identity);
}

abstract class _POListItem extends POListItem {
  const factory _POListItem(
      {required final String poId,
      required final String poNumber,
      final String? piNumber,
      final String? buyerName,
      final String? buyerPoNumber,
      required final String currencyCode,
      required final double totalAmount,
      required final POStatus status,
      final double shippedPercent,
      final DateTime? orderDateUtc,
      final DateTime? requiredShipmentDateUtc,
      final DateTime? createdAtUtc,
      final int itemCount}) = _$POListItemImpl;
  const _POListItem._() : super._();

  @override
  String get poId;
  @override
  String get poNumber;
  @override
  String? get piNumber;
  @override
  String? get buyerName;
  @override
  String? get buyerPoNumber;
  @override
  String get currencyCode;
  @override
  double get totalAmount;
  @override
  POStatus get status;
  @override
  double get shippedPercent;
  @override
  DateTime? get orderDateUtc;
  @override
  DateTime? get requiredShipmentDateUtc;
  @override
  DateTime? get createdAtUtc;
  @override
  int get itemCount;

  /// Create a copy of POListItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$POListItemImplCopyWith<_$POListItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
