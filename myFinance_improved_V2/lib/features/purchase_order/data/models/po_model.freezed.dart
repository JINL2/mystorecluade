// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'po_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

POItemModel _$POItemModelFromJson(Map<String, dynamic> json) {
  return _POItemModel.fromJson(json);
}

/// @nodoc
mixin _$POItemModel {
  @JsonKey(name: 'item_id')
  String get itemId => throw _privateConstructorUsedError;
  @JsonKey(name: 'po_id')
  String get poId => throw _privateConstructorUsedError;
  @JsonKey(name: 'pi_item_id')
  String? get piItemId => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_id')
  String? get productId => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String? get sku => throw _privateConstructorUsedError;
  @JsonKey(name: 'hs_code')
  String? get hsCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'quantity_ordered')
  double get quantityOrdered => throw _privateConstructorUsedError;
  @JsonKey(name: 'quantity_shipped')
  double get quantityShipped => throw _privateConstructorUsedError;
  String? get unit => throw _privateConstructorUsedError;
  @JsonKey(name: 'unit_price')
  double get unitPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_amount')
  double get totalAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_url')
  String? get imageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'sort_order')
  int get sortOrder => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at_utc')
  DateTime? get createdAtUtc => throw _privateConstructorUsedError;

  /// Serializes this POItemModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of POItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $POItemModelCopyWith<POItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $POItemModelCopyWith<$Res> {
  factory $POItemModelCopyWith(
          POItemModel value, $Res Function(POItemModel) then) =
      _$POItemModelCopyWithImpl<$Res, POItemModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'item_id') String itemId,
      @JsonKey(name: 'po_id') String poId,
      @JsonKey(name: 'pi_item_id') String? piItemId,
      @JsonKey(name: 'product_id') String? productId,
      String description,
      String? sku,
      @JsonKey(name: 'hs_code') String? hsCode,
      @JsonKey(name: 'quantity_ordered') double quantityOrdered,
      @JsonKey(name: 'quantity_shipped') double quantityShipped,
      String? unit,
      @JsonKey(name: 'unit_price') double unitPrice,
      @JsonKey(name: 'total_amount') double totalAmount,
      @JsonKey(name: 'image_url') String? imageUrl,
      @JsonKey(name: 'sort_order') int sortOrder,
      @JsonKey(name: 'created_at_utc') DateTime? createdAtUtc});
}

/// @nodoc
class _$POItemModelCopyWithImpl<$Res, $Val extends POItemModel>
    implements $POItemModelCopyWith<$Res> {
  _$POItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of POItemModel
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
    Object? quantityOrdered = null,
    Object? quantityShipped = null,
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
      quantityOrdered: null == quantityOrdered
          ? _value.quantityOrdered
          : quantityOrdered // ignore: cast_nullable_to_non_nullable
              as double,
      quantityShipped: null == quantityShipped
          ? _value.quantityShipped
          : quantityShipped // ignore: cast_nullable_to_non_nullable
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
abstract class _$$POItemModelImplCopyWith<$Res>
    implements $POItemModelCopyWith<$Res> {
  factory _$$POItemModelImplCopyWith(
          _$POItemModelImpl value, $Res Function(_$POItemModelImpl) then) =
      __$$POItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'item_id') String itemId,
      @JsonKey(name: 'po_id') String poId,
      @JsonKey(name: 'pi_item_id') String? piItemId,
      @JsonKey(name: 'product_id') String? productId,
      String description,
      String? sku,
      @JsonKey(name: 'hs_code') String? hsCode,
      @JsonKey(name: 'quantity_ordered') double quantityOrdered,
      @JsonKey(name: 'quantity_shipped') double quantityShipped,
      String? unit,
      @JsonKey(name: 'unit_price') double unitPrice,
      @JsonKey(name: 'total_amount') double totalAmount,
      @JsonKey(name: 'image_url') String? imageUrl,
      @JsonKey(name: 'sort_order') int sortOrder,
      @JsonKey(name: 'created_at_utc') DateTime? createdAtUtc});
}

/// @nodoc
class __$$POItemModelImplCopyWithImpl<$Res>
    extends _$POItemModelCopyWithImpl<$Res, _$POItemModelImpl>
    implements _$$POItemModelImplCopyWith<$Res> {
  __$$POItemModelImplCopyWithImpl(
      _$POItemModelImpl _value, $Res Function(_$POItemModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of POItemModel
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
    Object? quantityOrdered = null,
    Object? quantityShipped = null,
    Object? unit = freezed,
    Object? unitPrice = null,
    Object? totalAmount = null,
    Object? imageUrl = freezed,
    Object? sortOrder = null,
    Object? createdAtUtc = freezed,
  }) {
    return _then(_$POItemModelImpl(
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
      quantityOrdered: null == quantityOrdered
          ? _value.quantityOrdered
          : quantityOrdered // ignore: cast_nullable_to_non_nullable
              as double,
      quantityShipped: null == quantityShipped
          ? _value.quantityShipped
          : quantityShipped // ignore: cast_nullable_to_non_nullable
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
@JsonSerializable()
class _$POItemModelImpl extends _POItemModel {
  const _$POItemModelImpl(
      {@JsonKey(name: 'item_id') required this.itemId,
      @JsonKey(name: 'po_id') required this.poId,
      @JsonKey(name: 'pi_item_id') this.piItemId,
      @JsonKey(name: 'product_id') this.productId,
      required this.description,
      this.sku,
      @JsonKey(name: 'hs_code') this.hsCode,
      @JsonKey(name: 'quantity_ordered') required this.quantityOrdered,
      @JsonKey(name: 'quantity_shipped') this.quantityShipped = 0,
      this.unit,
      @JsonKey(name: 'unit_price') required this.unitPrice,
      @JsonKey(name: 'total_amount') required this.totalAmount,
      @JsonKey(name: 'image_url') this.imageUrl,
      @JsonKey(name: 'sort_order') this.sortOrder = 0,
      @JsonKey(name: 'created_at_utc') this.createdAtUtc})
      : super._();

  factory _$POItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$POItemModelImplFromJson(json);

  @override
  @JsonKey(name: 'item_id')
  final String itemId;
  @override
  @JsonKey(name: 'po_id')
  final String poId;
  @override
  @JsonKey(name: 'pi_item_id')
  final String? piItemId;
  @override
  @JsonKey(name: 'product_id')
  final String? productId;
  @override
  final String description;
  @override
  final String? sku;
  @override
  @JsonKey(name: 'hs_code')
  final String? hsCode;
  @override
  @JsonKey(name: 'quantity_ordered')
  final double quantityOrdered;
  @override
  @JsonKey(name: 'quantity_shipped')
  final double quantityShipped;
  @override
  final String? unit;
  @override
  @JsonKey(name: 'unit_price')
  final double unitPrice;
  @override
  @JsonKey(name: 'total_amount')
  final double totalAmount;
  @override
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @override
  @JsonKey(name: 'sort_order')
  final int sortOrder;
  @override
  @JsonKey(name: 'created_at_utc')
  final DateTime? createdAtUtc;

  @override
  String toString() {
    return 'POItemModel(itemId: $itemId, poId: $poId, piItemId: $piItemId, productId: $productId, description: $description, sku: $sku, hsCode: $hsCode, quantityOrdered: $quantityOrdered, quantityShipped: $quantityShipped, unit: $unit, unitPrice: $unitPrice, totalAmount: $totalAmount, imageUrl: $imageUrl, sortOrder: $sortOrder, createdAtUtc: $createdAtUtc)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$POItemModelImpl &&
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
            (identical(other.quantityOrdered, quantityOrdered) ||
                other.quantityOrdered == quantityOrdered) &&
            (identical(other.quantityShipped, quantityShipped) ||
                other.quantityShipped == quantityShipped) &&
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

  @JsonKey(includeFromJson: false, includeToJson: false)
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
      quantityOrdered,
      quantityShipped,
      unit,
      unitPrice,
      totalAmount,
      imageUrl,
      sortOrder,
      createdAtUtc);

  /// Create a copy of POItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$POItemModelImplCopyWith<_$POItemModelImpl> get copyWith =>
      __$$POItemModelImplCopyWithImpl<_$POItemModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$POItemModelImplToJson(
      this,
    );
  }
}

abstract class _POItemModel extends POItemModel {
  const factory _POItemModel(
      {@JsonKey(name: 'item_id') required final String itemId,
      @JsonKey(name: 'po_id') required final String poId,
      @JsonKey(name: 'pi_item_id') final String? piItemId,
      @JsonKey(name: 'product_id') final String? productId,
      required final String description,
      final String? sku,
      @JsonKey(name: 'hs_code') final String? hsCode,
      @JsonKey(name: 'quantity_ordered') required final double quantityOrdered,
      @JsonKey(name: 'quantity_shipped') final double quantityShipped,
      final String? unit,
      @JsonKey(name: 'unit_price') required final double unitPrice,
      @JsonKey(name: 'total_amount') required final double totalAmount,
      @JsonKey(name: 'image_url') final String? imageUrl,
      @JsonKey(name: 'sort_order') final int sortOrder,
      @JsonKey(name: 'created_at_utc')
      final DateTime? createdAtUtc}) = _$POItemModelImpl;
  const _POItemModel._() : super._();

  factory _POItemModel.fromJson(Map<String, dynamic> json) =
      _$POItemModelImpl.fromJson;

  @override
  @JsonKey(name: 'item_id')
  String get itemId;
  @override
  @JsonKey(name: 'po_id')
  String get poId;
  @override
  @JsonKey(name: 'pi_item_id')
  String? get piItemId;
  @override
  @JsonKey(name: 'product_id')
  String? get productId;
  @override
  String get description;
  @override
  String? get sku;
  @override
  @JsonKey(name: 'hs_code')
  String? get hsCode;
  @override
  @JsonKey(name: 'quantity_ordered')
  double get quantityOrdered;
  @override
  @JsonKey(name: 'quantity_shipped')
  double get quantityShipped;
  @override
  String? get unit;
  @override
  @JsonKey(name: 'unit_price')
  double get unitPrice;
  @override
  @JsonKey(name: 'total_amount')
  double get totalAmount;
  @override
  @JsonKey(name: 'image_url')
  String? get imageUrl;
  @override
  @JsonKey(name: 'sort_order')
  int get sortOrder;
  @override
  @JsonKey(name: 'created_at_utc')
  DateTime? get createdAtUtc;

  /// Create a copy of POItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$POItemModelImplCopyWith<_$POItemModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$POModel {
  @JsonKey(name: 'po_id')
  String get poId => throw _privateConstructorUsedError;
  @JsonKey(name: 'po_number')
  String get poNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_id')
  String get companyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'store_id')
  String? get storeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'pi_id')
  String? get piId => throw _privateConstructorUsedError;
  @JsonKey(name: 'pi_number')
  String? get piNumber => throw _privateConstructorUsedError;

  /// Seller (our company) info for PDF generation
  @JsonKey(name: 'seller_info')
  Map<String, dynamic>? get sellerInfo => throw _privateConstructorUsedError;

  /// Banking info for PDF (from cash_locations)
  @JsonKey(name: 'banking_info')
  List<Map<String, dynamic>>? get bankingInfo =>
      throw _privateConstructorUsedError;

  /// Selected bank account IDs (cash_location_ids) for PDF display
  @JsonKey(name: 'bank_account_ids')
  List<String> get bankAccountIds => throw _privateConstructorUsedError;
  @JsonKey(name: 'buyer_id')
  String? get buyerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'buyer_name')
  String? get buyerName => throw _privateConstructorUsedError;
  @JsonKey(name: 'buyer_po_number')
  String? get buyerPoNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'buyer_info')
  Map<String, dynamic>? get buyerInfo => throw _privateConstructorUsedError;
  @JsonKey(name: 'currency_id')
  String? get currencyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'currency_code')
  String get currencyCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_amount')
  double get totalAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'incoterms_code')
  String? get incotermsCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'incoterms_place')
  String? get incotermsPlace => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_terms_code')
  String? get paymentTermsCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_date_utc')
  DateTime? get orderDateUtc => throw _privateConstructorUsedError;
  @JsonKey(name: 'required_shipment_date_utc')
  DateTime? get requiredShipmentDateUtc => throw _privateConstructorUsedError;
  @JsonKey(name: 'partial_shipment_allowed')
  bool get partialShipmentAllowed => throw _privateConstructorUsedError;
  @JsonKey(name: 'transshipment_allowed')
  bool get transshipmentAllowed => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  int get version => throw _privateConstructorUsedError;
  @JsonKey(name: 'shipped_percent')
  double get shippedPercent => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_by')
  String? get createdBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at_utc')
  DateTime? get createdAtUtc => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at_utc')
  DateTime? get updatedAtUtc => throw _privateConstructorUsedError;
  List<POItemModel> get items => throw _privateConstructorUsedError;

  /// Create a copy of POModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $POModelCopyWith<POModel> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $POModelCopyWith<$Res> {
  factory $POModelCopyWith(POModel value, $Res Function(POModel) then) =
      _$POModelCopyWithImpl<$Res, POModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'po_id') String poId,
      @JsonKey(name: 'po_number') String poNumber,
      @JsonKey(name: 'company_id') String companyId,
      @JsonKey(name: 'store_id') String? storeId,
      @JsonKey(name: 'pi_id') String? piId,
      @JsonKey(name: 'pi_number') String? piNumber,
      @JsonKey(name: 'seller_info') Map<String, dynamic>? sellerInfo,
      @JsonKey(name: 'banking_info') List<Map<String, dynamic>>? bankingInfo,
      @JsonKey(name: 'bank_account_ids') List<String> bankAccountIds,
      @JsonKey(name: 'buyer_id') String? buyerId,
      @JsonKey(name: 'buyer_name') String? buyerName,
      @JsonKey(name: 'buyer_po_number') String? buyerPoNumber,
      @JsonKey(name: 'buyer_info') Map<String, dynamic>? buyerInfo,
      @JsonKey(name: 'currency_id') String? currencyId,
      @JsonKey(name: 'currency_code') String currencyCode,
      @JsonKey(name: 'total_amount') double totalAmount,
      @JsonKey(name: 'incoterms_code') String? incotermsCode,
      @JsonKey(name: 'incoterms_place') String? incotermsPlace,
      @JsonKey(name: 'payment_terms_code') String? paymentTermsCode,
      @JsonKey(name: 'order_date_utc') DateTime? orderDateUtc,
      @JsonKey(name: 'required_shipment_date_utc')
      DateTime? requiredShipmentDateUtc,
      @JsonKey(name: 'partial_shipment_allowed') bool partialShipmentAllowed,
      @JsonKey(name: 'transshipment_allowed') bool transshipmentAllowed,
      String status,
      int version,
      @JsonKey(name: 'shipped_percent') double shippedPercent,
      String? notes,
      @JsonKey(name: 'created_by') String? createdBy,
      @JsonKey(name: 'created_at_utc') DateTime? createdAtUtc,
      @JsonKey(name: 'updated_at_utc') DateTime? updatedAtUtc,
      List<POItemModel> items});
}

/// @nodoc
class _$POModelCopyWithImpl<$Res, $Val extends POModel>
    implements $POModelCopyWith<$Res> {
  _$POModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of POModel
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
              as String,
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
              as List<POItemModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$POModelImplCopyWith<$Res> implements $POModelCopyWith<$Res> {
  factory _$$POModelImplCopyWith(
          _$POModelImpl value, $Res Function(_$POModelImpl) then) =
      __$$POModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'po_id') String poId,
      @JsonKey(name: 'po_number') String poNumber,
      @JsonKey(name: 'company_id') String companyId,
      @JsonKey(name: 'store_id') String? storeId,
      @JsonKey(name: 'pi_id') String? piId,
      @JsonKey(name: 'pi_number') String? piNumber,
      @JsonKey(name: 'seller_info') Map<String, dynamic>? sellerInfo,
      @JsonKey(name: 'banking_info') List<Map<String, dynamic>>? bankingInfo,
      @JsonKey(name: 'bank_account_ids') List<String> bankAccountIds,
      @JsonKey(name: 'buyer_id') String? buyerId,
      @JsonKey(name: 'buyer_name') String? buyerName,
      @JsonKey(name: 'buyer_po_number') String? buyerPoNumber,
      @JsonKey(name: 'buyer_info') Map<String, dynamic>? buyerInfo,
      @JsonKey(name: 'currency_id') String? currencyId,
      @JsonKey(name: 'currency_code') String currencyCode,
      @JsonKey(name: 'total_amount') double totalAmount,
      @JsonKey(name: 'incoterms_code') String? incotermsCode,
      @JsonKey(name: 'incoterms_place') String? incotermsPlace,
      @JsonKey(name: 'payment_terms_code') String? paymentTermsCode,
      @JsonKey(name: 'order_date_utc') DateTime? orderDateUtc,
      @JsonKey(name: 'required_shipment_date_utc')
      DateTime? requiredShipmentDateUtc,
      @JsonKey(name: 'partial_shipment_allowed') bool partialShipmentAllowed,
      @JsonKey(name: 'transshipment_allowed') bool transshipmentAllowed,
      String status,
      int version,
      @JsonKey(name: 'shipped_percent') double shippedPercent,
      String? notes,
      @JsonKey(name: 'created_by') String? createdBy,
      @JsonKey(name: 'created_at_utc') DateTime? createdAtUtc,
      @JsonKey(name: 'updated_at_utc') DateTime? updatedAtUtc,
      List<POItemModel> items});
}

/// @nodoc
class __$$POModelImplCopyWithImpl<$Res>
    extends _$POModelCopyWithImpl<$Res, _$POModelImpl>
    implements _$$POModelImplCopyWith<$Res> {
  __$$POModelImplCopyWithImpl(
      _$POModelImpl _value, $Res Function(_$POModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of POModel
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
    return _then(_$POModelImpl(
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
              as String,
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
              as List<POItemModel>,
    ));
  }
}

/// @nodoc

class _$POModelImpl extends _POModel {
  const _$POModelImpl(
      {@JsonKey(name: 'po_id') required this.poId,
      @JsonKey(name: 'po_number') required this.poNumber,
      @JsonKey(name: 'company_id') required this.companyId,
      @JsonKey(name: 'store_id') this.storeId,
      @JsonKey(name: 'pi_id') this.piId,
      @JsonKey(name: 'pi_number') this.piNumber,
      @JsonKey(name: 'seller_info') final Map<String, dynamic>? sellerInfo,
      @JsonKey(name: 'banking_info')
      final List<Map<String, dynamic>>? bankingInfo,
      @JsonKey(name: 'bank_account_ids')
      final List<String> bankAccountIds = const [],
      @JsonKey(name: 'buyer_id') this.buyerId,
      @JsonKey(name: 'buyer_name') this.buyerName,
      @JsonKey(name: 'buyer_po_number') this.buyerPoNumber,
      @JsonKey(name: 'buyer_info') final Map<String, dynamic>? buyerInfo,
      @JsonKey(name: 'currency_id') this.currencyId,
      @JsonKey(name: 'currency_code') this.currencyCode = 'USD',
      @JsonKey(name: 'total_amount') this.totalAmount = 0,
      @JsonKey(name: 'incoterms_code') this.incotermsCode,
      @JsonKey(name: 'incoterms_place') this.incotermsPlace,
      @JsonKey(name: 'payment_terms_code') this.paymentTermsCode,
      @JsonKey(name: 'order_date_utc') this.orderDateUtc,
      @JsonKey(name: 'required_shipment_date_utc') this.requiredShipmentDateUtc,
      @JsonKey(name: 'partial_shipment_allowed')
      this.partialShipmentAllowed = true,
      @JsonKey(name: 'transshipment_allowed') this.transshipmentAllowed = true,
      this.status = 'draft',
      this.version = 1,
      @JsonKey(name: 'shipped_percent') this.shippedPercent = 0,
      this.notes,
      @JsonKey(name: 'created_by') this.createdBy,
      @JsonKey(name: 'created_at_utc') this.createdAtUtc,
      @JsonKey(name: 'updated_at_utc') this.updatedAtUtc,
      final List<POItemModel> items = const []})
      : _sellerInfo = sellerInfo,
        _bankingInfo = bankingInfo,
        _bankAccountIds = bankAccountIds,
        _buyerInfo = buyerInfo,
        _items = items,
        super._();

  @override
  @JsonKey(name: 'po_id')
  final String poId;
  @override
  @JsonKey(name: 'po_number')
  final String poNumber;
  @override
  @JsonKey(name: 'company_id')
  final String companyId;
  @override
  @JsonKey(name: 'store_id')
  final String? storeId;
  @override
  @JsonKey(name: 'pi_id')
  final String? piId;
  @override
  @JsonKey(name: 'pi_number')
  final String? piNumber;

  /// Seller (our company) info for PDF generation
  final Map<String, dynamic>? _sellerInfo;

  /// Seller (our company) info for PDF generation
  @override
  @JsonKey(name: 'seller_info')
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
  @JsonKey(name: 'banking_info')
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
  @JsonKey(name: 'bank_account_ids')
  List<String> get bankAccountIds {
    if (_bankAccountIds is EqualUnmodifiableListView) return _bankAccountIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_bankAccountIds);
  }

  @override
  @JsonKey(name: 'buyer_id')
  final String? buyerId;
  @override
  @JsonKey(name: 'buyer_name')
  final String? buyerName;
  @override
  @JsonKey(name: 'buyer_po_number')
  final String? buyerPoNumber;
  final Map<String, dynamic>? _buyerInfo;
  @override
  @JsonKey(name: 'buyer_info')
  Map<String, dynamic>? get buyerInfo {
    final value = _buyerInfo;
    if (value == null) return null;
    if (_buyerInfo is EqualUnmodifiableMapView) return _buyerInfo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey(name: 'currency_id')
  final String? currencyId;
  @override
  @JsonKey(name: 'currency_code')
  final String currencyCode;
  @override
  @JsonKey(name: 'total_amount')
  final double totalAmount;
  @override
  @JsonKey(name: 'incoterms_code')
  final String? incotermsCode;
  @override
  @JsonKey(name: 'incoterms_place')
  final String? incotermsPlace;
  @override
  @JsonKey(name: 'payment_terms_code')
  final String? paymentTermsCode;
  @override
  @JsonKey(name: 'order_date_utc')
  final DateTime? orderDateUtc;
  @override
  @JsonKey(name: 'required_shipment_date_utc')
  final DateTime? requiredShipmentDateUtc;
  @override
  @JsonKey(name: 'partial_shipment_allowed')
  final bool partialShipmentAllowed;
  @override
  @JsonKey(name: 'transshipment_allowed')
  final bool transshipmentAllowed;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey()
  final int version;
  @override
  @JsonKey(name: 'shipped_percent')
  final double shippedPercent;
  @override
  final String? notes;
  @override
  @JsonKey(name: 'created_by')
  final String? createdBy;
  @override
  @JsonKey(name: 'created_at_utc')
  final DateTime? createdAtUtc;
  @override
  @JsonKey(name: 'updated_at_utc')
  final DateTime? updatedAtUtc;
  final List<POItemModel> _items;
  @override
  @JsonKey()
  List<POItemModel> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'POModel(poId: $poId, poNumber: $poNumber, companyId: $companyId, storeId: $storeId, piId: $piId, piNumber: $piNumber, sellerInfo: $sellerInfo, bankingInfo: $bankingInfo, bankAccountIds: $bankAccountIds, buyerId: $buyerId, buyerName: $buyerName, buyerPoNumber: $buyerPoNumber, buyerInfo: $buyerInfo, currencyId: $currencyId, currencyCode: $currencyCode, totalAmount: $totalAmount, incotermsCode: $incotermsCode, incotermsPlace: $incotermsPlace, paymentTermsCode: $paymentTermsCode, orderDateUtc: $orderDateUtc, requiredShipmentDateUtc: $requiredShipmentDateUtc, partialShipmentAllowed: $partialShipmentAllowed, transshipmentAllowed: $transshipmentAllowed, status: $status, version: $version, shippedPercent: $shippedPercent, notes: $notes, createdBy: $createdBy, createdAtUtc: $createdAtUtc, updatedAtUtc: $updatedAtUtc, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$POModelImpl &&
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

  /// Create a copy of POModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$POModelImplCopyWith<_$POModelImpl> get copyWith =>
      __$$POModelImplCopyWithImpl<_$POModelImpl>(this, _$identity);
}

abstract class _POModel extends POModel {
  const factory _POModel(
      {@JsonKey(name: 'po_id') required final String poId,
      @JsonKey(name: 'po_number') required final String poNumber,
      @JsonKey(name: 'company_id') required final String companyId,
      @JsonKey(name: 'store_id') final String? storeId,
      @JsonKey(name: 'pi_id') final String? piId,
      @JsonKey(name: 'pi_number') final String? piNumber,
      @JsonKey(name: 'seller_info') final Map<String, dynamic>? sellerInfo,
      @JsonKey(name: 'banking_info')
      final List<Map<String, dynamic>>? bankingInfo,
      @JsonKey(name: 'bank_account_ids') final List<String> bankAccountIds,
      @JsonKey(name: 'buyer_id') final String? buyerId,
      @JsonKey(name: 'buyer_name') final String? buyerName,
      @JsonKey(name: 'buyer_po_number') final String? buyerPoNumber,
      @JsonKey(name: 'buyer_info') final Map<String, dynamic>? buyerInfo,
      @JsonKey(name: 'currency_id') final String? currencyId,
      @JsonKey(name: 'currency_code') final String currencyCode,
      @JsonKey(name: 'total_amount') final double totalAmount,
      @JsonKey(name: 'incoterms_code') final String? incotermsCode,
      @JsonKey(name: 'incoterms_place') final String? incotermsPlace,
      @JsonKey(name: 'payment_terms_code') final String? paymentTermsCode,
      @JsonKey(name: 'order_date_utc') final DateTime? orderDateUtc,
      @JsonKey(name: 'required_shipment_date_utc')
      final DateTime? requiredShipmentDateUtc,
      @JsonKey(name: 'partial_shipment_allowed')
      final bool partialShipmentAllowed,
      @JsonKey(name: 'transshipment_allowed') final bool transshipmentAllowed,
      final String status,
      final int version,
      @JsonKey(name: 'shipped_percent') final double shippedPercent,
      final String? notes,
      @JsonKey(name: 'created_by') final String? createdBy,
      @JsonKey(name: 'created_at_utc') final DateTime? createdAtUtc,
      @JsonKey(name: 'updated_at_utc') final DateTime? updatedAtUtc,
      final List<POItemModel> items}) = _$POModelImpl;
  const _POModel._() : super._();

  @override
  @JsonKey(name: 'po_id')
  String get poId;
  @override
  @JsonKey(name: 'po_number')
  String get poNumber;
  @override
  @JsonKey(name: 'company_id')
  String get companyId;
  @override
  @JsonKey(name: 'store_id')
  String? get storeId;
  @override
  @JsonKey(name: 'pi_id')
  String? get piId;
  @override
  @JsonKey(name: 'pi_number')
  String? get piNumber;

  /// Seller (our company) info for PDF generation
  @override
  @JsonKey(name: 'seller_info')
  Map<String, dynamic>? get sellerInfo;

  /// Banking info for PDF (from cash_locations)
  @override
  @JsonKey(name: 'banking_info')
  List<Map<String, dynamic>>? get bankingInfo;

  /// Selected bank account IDs (cash_location_ids) for PDF display
  @override
  @JsonKey(name: 'bank_account_ids')
  List<String> get bankAccountIds;
  @override
  @JsonKey(name: 'buyer_id')
  String? get buyerId;
  @override
  @JsonKey(name: 'buyer_name')
  String? get buyerName;
  @override
  @JsonKey(name: 'buyer_po_number')
  String? get buyerPoNumber;
  @override
  @JsonKey(name: 'buyer_info')
  Map<String, dynamic>? get buyerInfo;
  @override
  @JsonKey(name: 'currency_id')
  String? get currencyId;
  @override
  @JsonKey(name: 'currency_code')
  String get currencyCode;
  @override
  @JsonKey(name: 'total_amount')
  double get totalAmount;
  @override
  @JsonKey(name: 'incoterms_code')
  String? get incotermsCode;
  @override
  @JsonKey(name: 'incoterms_place')
  String? get incotermsPlace;
  @override
  @JsonKey(name: 'payment_terms_code')
  String? get paymentTermsCode;
  @override
  @JsonKey(name: 'order_date_utc')
  DateTime? get orderDateUtc;
  @override
  @JsonKey(name: 'required_shipment_date_utc')
  DateTime? get requiredShipmentDateUtc;
  @override
  @JsonKey(name: 'partial_shipment_allowed')
  bool get partialShipmentAllowed;
  @override
  @JsonKey(name: 'transshipment_allowed')
  bool get transshipmentAllowed;
  @override
  String get status;
  @override
  int get version;
  @override
  @JsonKey(name: 'shipped_percent')
  double get shippedPercent;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'created_by')
  String? get createdBy;
  @override
  @JsonKey(name: 'created_at_utc')
  DateTime? get createdAtUtc;
  @override
  @JsonKey(name: 'updated_at_utc')
  DateTime? get updatedAtUtc;
  @override
  List<POItemModel> get items;

  /// Create a copy of POModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$POModelImplCopyWith<_$POModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

POListItemModel _$POListItemModelFromJson(Map<String, dynamic> json) {
  return _POListItemModel.fromJson(json);
}

/// @nodoc
mixin _$POListItemModel {
  @JsonKey(name: 'po_id')
  String get poId => throw _privateConstructorUsedError;
  @JsonKey(name: 'po_number')
  String get poNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'pi_number')
  String? get piNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'buyer_name')
  String? get buyerName => throw _privateConstructorUsedError;
  @JsonKey(name: 'buyer_po_number')
  String? get buyerPoNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'currency_code')
  String get currencyCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_amount')
  double get totalAmount => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'shipped_percent')
  double get shippedPercent => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_date_utc')
  DateTime? get orderDateUtc => throw _privateConstructorUsedError;
  @JsonKey(name: 'required_shipment_date_utc')
  DateTime? get requiredShipmentDateUtc => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at_utc')
  DateTime? get createdAtUtc => throw _privateConstructorUsedError;
  @JsonKey(name: 'item_count')
  int get itemCount => throw _privateConstructorUsedError;

  /// Serializes this POListItemModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of POListItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $POListItemModelCopyWith<POListItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $POListItemModelCopyWith<$Res> {
  factory $POListItemModelCopyWith(
          POListItemModel value, $Res Function(POListItemModel) then) =
      _$POListItemModelCopyWithImpl<$Res, POListItemModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'po_id') String poId,
      @JsonKey(name: 'po_number') String poNumber,
      @JsonKey(name: 'pi_number') String? piNumber,
      @JsonKey(name: 'buyer_name') String? buyerName,
      @JsonKey(name: 'buyer_po_number') String? buyerPoNumber,
      @JsonKey(name: 'currency_code') String currencyCode,
      @JsonKey(name: 'total_amount') double totalAmount,
      String status,
      @JsonKey(name: 'shipped_percent') double shippedPercent,
      @JsonKey(name: 'order_date_utc') DateTime? orderDateUtc,
      @JsonKey(name: 'required_shipment_date_utc')
      DateTime? requiredShipmentDateUtc,
      @JsonKey(name: 'created_at_utc') DateTime? createdAtUtc,
      @JsonKey(name: 'item_count') int itemCount});
}

/// @nodoc
class _$POListItemModelCopyWithImpl<$Res, $Val extends POListItemModel>
    implements $POListItemModelCopyWith<$Res> {
  _$POListItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of POListItemModel
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
              as String,
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
abstract class _$$POListItemModelImplCopyWith<$Res>
    implements $POListItemModelCopyWith<$Res> {
  factory _$$POListItemModelImplCopyWith(_$POListItemModelImpl value,
          $Res Function(_$POListItemModelImpl) then) =
      __$$POListItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'po_id') String poId,
      @JsonKey(name: 'po_number') String poNumber,
      @JsonKey(name: 'pi_number') String? piNumber,
      @JsonKey(name: 'buyer_name') String? buyerName,
      @JsonKey(name: 'buyer_po_number') String? buyerPoNumber,
      @JsonKey(name: 'currency_code') String currencyCode,
      @JsonKey(name: 'total_amount') double totalAmount,
      String status,
      @JsonKey(name: 'shipped_percent') double shippedPercent,
      @JsonKey(name: 'order_date_utc') DateTime? orderDateUtc,
      @JsonKey(name: 'required_shipment_date_utc')
      DateTime? requiredShipmentDateUtc,
      @JsonKey(name: 'created_at_utc') DateTime? createdAtUtc,
      @JsonKey(name: 'item_count') int itemCount});
}

/// @nodoc
class __$$POListItemModelImplCopyWithImpl<$Res>
    extends _$POListItemModelCopyWithImpl<$Res, _$POListItemModelImpl>
    implements _$$POListItemModelImplCopyWith<$Res> {
  __$$POListItemModelImplCopyWithImpl(
      _$POListItemModelImpl _value, $Res Function(_$POListItemModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of POListItemModel
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
    return _then(_$POListItemModelImpl(
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
              as String,
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
@JsonSerializable()
class _$POListItemModelImpl extends _POListItemModel {
  const _$POListItemModelImpl(
      {@JsonKey(name: 'po_id') required this.poId,
      @JsonKey(name: 'po_number') required this.poNumber,
      @JsonKey(name: 'pi_number') this.piNumber,
      @JsonKey(name: 'buyer_name') this.buyerName,
      @JsonKey(name: 'buyer_po_number') this.buyerPoNumber,
      @JsonKey(name: 'currency_code') this.currencyCode = 'USD',
      @JsonKey(name: 'total_amount') this.totalAmount = 0,
      this.status = 'draft',
      @JsonKey(name: 'shipped_percent') this.shippedPercent = 0,
      @JsonKey(name: 'order_date_utc') this.orderDateUtc,
      @JsonKey(name: 'required_shipment_date_utc') this.requiredShipmentDateUtc,
      @JsonKey(name: 'created_at_utc') this.createdAtUtc,
      @JsonKey(name: 'item_count') this.itemCount = 0})
      : super._();

  factory _$POListItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$POListItemModelImplFromJson(json);

  @override
  @JsonKey(name: 'po_id')
  final String poId;
  @override
  @JsonKey(name: 'po_number')
  final String poNumber;
  @override
  @JsonKey(name: 'pi_number')
  final String? piNumber;
  @override
  @JsonKey(name: 'buyer_name')
  final String? buyerName;
  @override
  @JsonKey(name: 'buyer_po_number')
  final String? buyerPoNumber;
  @override
  @JsonKey(name: 'currency_code')
  final String currencyCode;
  @override
  @JsonKey(name: 'total_amount')
  final double totalAmount;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey(name: 'shipped_percent')
  final double shippedPercent;
  @override
  @JsonKey(name: 'order_date_utc')
  final DateTime? orderDateUtc;
  @override
  @JsonKey(name: 'required_shipment_date_utc')
  final DateTime? requiredShipmentDateUtc;
  @override
  @JsonKey(name: 'created_at_utc')
  final DateTime? createdAtUtc;
  @override
  @JsonKey(name: 'item_count')
  final int itemCount;

  @override
  String toString() {
    return 'POListItemModel(poId: $poId, poNumber: $poNumber, piNumber: $piNumber, buyerName: $buyerName, buyerPoNumber: $buyerPoNumber, currencyCode: $currencyCode, totalAmount: $totalAmount, status: $status, shippedPercent: $shippedPercent, orderDateUtc: $orderDateUtc, requiredShipmentDateUtc: $requiredShipmentDateUtc, createdAtUtc: $createdAtUtc, itemCount: $itemCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$POListItemModelImpl &&
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

  @JsonKey(includeFromJson: false, includeToJson: false)
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

  /// Create a copy of POListItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$POListItemModelImplCopyWith<_$POListItemModelImpl> get copyWith =>
      __$$POListItemModelImplCopyWithImpl<_$POListItemModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$POListItemModelImplToJson(
      this,
    );
  }
}

abstract class _POListItemModel extends POListItemModel {
  const factory _POListItemModel(
          {@JsonKey(name: 'po_id') required final String poId,
          @JsonKey(name: 'po_number') required final String poNumber,
          @JsonKey(name: 'pi_number') final String? piNumber,
          @JsonKey(name: 'buyer_name') final String? buyerName,
          @JsonKey(name: 'buyer_po_number') final String? buyerPoNumber,
          @JsonKey(name: 'currency_code') final String currencyCode,
          @JsonKey(name: 'total_amount') final double totalAmount,
          final String status,
          @JsonKey(name: 'shipped_percent') final double shippedPercent,
          @JsonKey(name: 'order_date_utc') final DateTime? orderDateUtc,
          @JsonKey(name: 'required_shipment_date_utc')
          final DateTime? requiredShipmentDateUtc,
          @JsonKey(name: 'created_at_utc') final DateTime? createdAtUtc,
          @JsonKey(name: 'item_count') final int itemCount}) =
      _$POListItemModelImpl;
  const _POListItemModel._() : super._();

  factory _POListItemModel.fromJson(Map<String, dynamic> json) =
      _$POListItemModelImpl.fromJson;

  @override
  @JsonKey(name: 'po_id')
  String get poId;
  @override
  @JsonKey(name: 'po_number')
  String get poNumber;
  @override
  @JsonKey(name: 'pi_number')
  String? get piNumber;
  @override
  @JsonKey(name: 'buyer_name')
  String? get buyerName;
  @override
  @JsonKey(name: 'buyer_po_number')
  String? get buyerPoNumber;
  @override
  @JsonKey(name: 'currency_code')
  String get currencyCode;
  @override
  @JsonKey(name: 'total_amount')
  double get totalAmount;
  @override
  String get status;
  @override
  @JsonKey(name: 'shipped_percent')
  double get shippedPercent;
  @override
  @JsonKey(name: 'order_date_utc')
  DateTime? get orderDateUtc;
  @override
  @JsonKey(name: 'required_shipment_date_utc')
  DateTime? get requiredShipmentDateUtc;
  @override
  @JsonKey(name: 'created_at_utc')
  DateTime? get createdAtUtc;
  @override
  @JsonKey(name: 'item_count')
  int get itemCount;

  /// Create a copy of POListItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$POListItemModelImplCopyWith<_$POListItemModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
