// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'proforma_invoice.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PIItem {
  String get itemId => throw _privateConstructorUsedError;
  String get piId => throw _privateConstructorUsedError;
  String? get productId => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String? get sku => throw _privateConstructorUsedError;
  String? get barcode => throw _privateConstructorUsedError;
  String? get hsCode => throw _privateConstructorUsedError;
  String? get countryOfOrigin => throw _privateConstructorUsedError;
  double get quantity => throw _privateConstructorUsedError;
  String? get unit => throw _privateConstructorUsedError;
  double get unitPrice => throw _privateConstructorUsedError;
  double get discountPercent => throw _privateConstructorUsedError;
  double get discountAmount => throw _privateConstructorUsedError;
  double get totalAmount => throw _privateConstructorUsedError;
  String? get packingInfo => throw _privateConstructorUsedError;
  int get sortOrder => throw _privateConstructorUsedError;
  DateTime? get createdAtUtc => throw _privateConstructorUsedError;

  /// Create a copy of PIItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PIItemCopyWith<PIItem> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PIItemCopyWith<$Res> {
  factory $PIItemCopyWith(PIItem value, $Res Function(PIItem) then) =
      _$PIItemCopyWithImpl<$Res, PIItem>;
  @useResult
  $Res call(
      {String itemId,
      String piId,
      String? productId,
      String description,
      String? sku,
      String? barcode,
      String? hsCode,
      String? countryOfOrigin,
      double quantity,
      String? unit,
      double unitPrice,
      double discountPercent,
      double discountAmount,
      double totalAmount,
      String? packingInfo,
      int sortOrder,
      DateTime? createdAtUtc});
}

/// @nodoc
class _$PIItemCopyWithImpl<$Res, $Val extends PIItem>
    implements $PIItemCopyWith<$Res> {
  _$PIItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PIItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? itemId = null,
    Object? piId = null,
    Object? productId = freezed,
    Object? description = null,
    Object? sku = freezed,
    Object? barcode = freezed,
    Object? hsCode = freezed,
    Object? countryOfOrigin = freezed,
    Object? quantity = null,
    Object? unit = freezed,
    Object? unitPrice = null,
    Object? discountPercent = null,
    Object? discountAmount = null,
    Object? totalAmount = null,
    Object? packingInfo = freezed,
    Object? sortOrder = null,
    Object? createdAtUtc = freezed,
  }) {
    return _then(_value.copyWith(
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      piId: null == piId
          ? _value.piId
          : piId // ignore: cast_nullable_to_non_nullable
              as String,
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
      barcode: freezed == barcode
          ? _value.barcode
          : barcode // ignore: cast_nullable_to_non_nullable
              as String?,
      hsCode: freezed == hsCode
          ? _value.hsCode
          : hsCode // ignore: cast_nullable_to_non_nullable
              as String?,
      countryOfOrigin: freezed == countryOfOrigin
          ? _value.countryOfOrigin
          : countryOfOrigin // ignore: cast_nullable_to_non_nullable
              as String?,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      unitPrice: null == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double,
      discountPercent: null == discountPercent
          ? _value.discountPercent
          : discountPercent // ignore: cast_nullable_to_non_nullable
              as double,
      discountAmount: null == discountAmount
          ? _value.discountAmount
          : discountAmount // ignore: cast_nullable_to_non_nullable
              as double,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      packingInfo: freezed == packingInfo
          ? _value.packingInfo
          : packingInfo // ignore: cast_nullable_to_non_nullable
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
abstract class _$$PIItemImplCopyWith<$Res> implements $PIItemCopyWith<$Res> {
  factory _$$PIItemImplCopyWith(
          _$PIItemImpl value, $Res Function(_$PIItemImpl) then) =
      __$$PIItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String itemId,
      String piId,
      String? productId,
      String description,
      String? sku,
      String? barcode,
      String? hsCode,
      String? countryOfOrigin,
      double quantity,
      String? unit,
      double unitPrice,
      double discountPercent,
      double discountAmount,
      double totalAmount,
      String? packingInfo,
      int sortOrder,
      DateTime? createdAtUtc});
}

/// @nodoc
class __$$PIItemImplCopyWithImpl<$Res>
    extends _$PIItemCopyWithImpl<$Res, _$PIItemImpl>
    implements _$$PIItemImplCopyWith<$Res> {
  __$$PIItemImplCopyWithImpl(
      _$PIItemImpl _value, $Res Function(_$PIItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of PIItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? itemId = null,
    Object? piId = null,
    Object? productId = freezed,
    Object? description = null,
    Object? sku = freezed,
    Object? barcode = freezed,
    Object? hsCode = freezed,
    Object? countryOfOrigin = freezed,
    Object? quantity = null,
    Object? unit = freezed,
    Object? unitPrice = null,
    Object? discountPercent = null,
    Object? discountAmount = null,
    Object? totalAmount = null,
    Object? packingInfo = freezed,
    Object? sortOrder = null,
    Object? createdAtUtc = freezed,
  }) {
    return _then(_$PIItemImpl(
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      piId: null == piId
          ? _value.piId
          : piId // ignore: cast_nullable_to_non_nullable
              as String,
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
      barcode: freezed == barcode
          ? _value.barcode
          : barcode // ignore: cast_nullable_to_non_nullable
              as String?,
      hsCode: freezed == hsCode
          ? _value.hsCode
          : hsCode // ignore: cast_nullable_to_non_nullable
              as String?,
      countryOfOrigin: freezed == countryOfOrigin
          ? _value.countryOfOrigin
          : countryOfOrigin // ignore: cast_nullable_to_non_nullable
              as String?,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      unitPrice: null == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double,
      discountPercent: null == discountPercent
          ? _value.discountPercent
          : discountPercent // ignore: cast_nullable_to_non_nullable
              as double,
      discountAmount: null == discountAmount
          ? _value.discountAmount
          : discountAmount // ignore: cast_nullable_to_non_nullable
              as double,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      packingInfo: freezed == packingInfo
          ? _value.packingInfo
          : packingInfo // ignore: cast_nullable_to_non_nullable
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

class _$PIItemImpl extends _PIItem {
  const _$PIItemImpl(
      {required this.itemId,
      required this.piId,
      this.productId,
      required this.description,
      this.sku,
      this.barcode,
      this.hsCode,
      this.countryOfOrigin,
      required this.quantity,
      this.unit,
      required this.unitPrice,
      this.discountPercent = 0,
      this.discountAmount = 0,
      required this.totalAmount,
      this.packingInfo,
      this.sortOrder = 0,
      this.createdAtUtc})
      : super._();

  @override
  final String itemId;
  @override
  final String piId;
  @override
  final String? productId;
  @override
  final String description;
  @override
  final String? sku;
  @override
  final String? barcode;
  @override
  final String? hsCode;
  @override
  final String? countryOfOrigin;
  @override
  final double quantity;
  @override
  final String? unit;
  @override
  final double unitPrice;
  @override
  @JsonKey()
  final double discountPercent;
  @override
  @JsonKey()
  final double discountAmount;
  @override
  final double totalAmount;
  @override
  final String? packingInfo;
  @override
  @JsonKey()
  final int sortOrder;
  @override
  final DateTime? createdAtUtc;

  @override
  String toString() {
    return 'PIItem(itemId: $itemId, piId: $piId, productId: $productId, description: $description, sku: $sku, barcode: $barcode, hsCode: $hsCode, countryOfOrigin: $countryOfOrigin, quantity: $quantity, unit: $unit, unitPrice: $unitPrice, discountPercent: $discountPercent, discountAmount: $discountAmount, totalAmount: $totalAmount, packingInfo: $packingInfo, sortOrder: $sortOrder, createdAtUtc: $createdAtUtc)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PIItemImpl &&
            (identical(other.itemId, itemId) || other.itemId == itemId) &&
            (identical(other.piId, piId) || other.piId == piId) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.barcode, barcode) || other.barcode == barcode) &&
            (identical(other.hsCode, hsCode) || other.hsCode == hsCode) &&
            (identical(other.countryOfOrigin, countryOfOrigin) ||
                other.countryOfOrigin == countryOfOrigin) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.discountPercent, discountPercent) ||
                other.discountPercent == discountPercent) &&
            (identical(other.discountAmount, discountAmount) ||
                other.discountAmount == discountAmount) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.packingInfo, packingInfo) ||
                other.packingInfo == packingInfo) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.createdAtUtc, createdAtUtc) ||
                other.createdAtUtc == createdAtUtc));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      itemId,
      piId,
      productId,
      description,
      sku,
      barcode,
      hsCode,
      countryOfOrigin,
      quantity,
      unit,
      unitPrice,
      discountPercent,
      discountAmount,
      totalAmount,
      packingInfo,
      sortOrder,
      createdAtUtc);

  /// Create a copy of PIItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PIItemImplCopyWith<_$PIItemImpl> get copyWith =>
      __$$PIItemImplCopyWithImpl<_$PIItemImpl>(this, _$identity);
}

abstract class _PIItem extends PIItem {
  const factory _PIItem(
      {required final String itemId,
      required final String piId,
      final String? productId,
      required final String description,
      final String? sku,
      final String? barcode,
      final String? hsCode,
      final String? countryOfOrigin,
      required final double quantity,
      final String? unit,
      required final double unitPrice,
      final double discountPercent,
      final double discountAmount,
      required final double totalAmount,
      final String? packingInfo,
      final int sortOrder,
      final DateTime? createdAtUtc}) = _$PIItemImpl;
  const _PIItem._() : super._();

  @override
  String get itemId;
  @override
  String get piId;
  @override
  String? get productId;
  @override
  String get description;
  @override
  String? get sku;
  @override
  String? get barcode;
  @override
  String? get hsCode;
  @override
  String? get countryOfOrigin;
  @override
  double get quantity;
  @override
  String? get unit;
  @override
  double get unitPrice;
  @override
  double get discountPercent;
  @override
  double get discountAmount;
  @override
  double get totalAmount;
  @override
  String? get packingInfo;
  @override
  int get sortOrder;
  @override
  DateTime? get createdAtUtc;

  /// Create a copy of PIItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PIItemImplCopyWith<_$PIItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ProformaInvoice {
  String get piId => throw _privateConstructorUsedError;
  String get piNumber => throw _privateConstructorUsedError;
  String get companyId => throw _privateConstructorUsedError;
  String? get storeId => throw _privateConstructorUsedError;
  String? get counterpartyId => throw _privateConstructorUsedError;
  String? get counterpartyName => throw _privateConstructorUsedError;
  Map<String, dynamic>? get counterpartyInfo =>
      throw _privateConstructorUsedError;
  Map<String, dynamic>? get sellerInfo => throw _privateConstructorUsedError;
  String? get currencyId => throw _privateConstructorUsedError;
  String get currencyCode => throw _privateConstructorUsedError;
  double get subtotal => throw _privateConstructorUsedError;
  double get discountPercent => throw _privateConstructorUsedError;
  double get discountAmount => throw _privateConstructorUsedError;
  double get taxPercent => throw _privateConstructorUsedError;
  double get taxAmount => throw _privateConstructorUsedError;
  double get totalAmount => throw _privateConstructorUsedError;
  String? get incotermsCode => throw _privateConstructorUsedError;
  String? get incotermsPlace => throw _privateConstructorUsedError;
  String? get portOfLoading => throw _privateConstructorUsedError;
  String? get portOfDischarge => throw _privateConstructorUsedError;
  String? get finalDestination => throw _privateConstructorUsedError;
  String? get countryOfOrigin => throw _privateConstructorUsedError;
  String? get paymentTermsCode => throw _privateConstructorUsedError;
  String? get paymentTermsDetail => throw _privateConstructorUsedError;
  bool get partialShipmentAllowed => throw _privateConstructorUsedError;
  bool get transshipmentAllowed => throw _privateConstructorUsedError;
  String? get shippingMethodCode => throw _privateConstructorUsedError;
  DateTime? get estimatedShipmentDate => throw _privateConstructorUsedError;
  int? get leadTimeDays => throw _privateConstructorUsedError;
  DateTime? get validityDate => throw _privateConstructorUsedError;
  PIStatus get status => throw _privateConstructorUsedError;
  int get version => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String? get internalNotes => throw _privateConstructorUsedError;
  String? get termsAndConditions => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;
  DateTime? get createdAtUtc => throw _privateConstructorUsedError;
  DateTime? get updatedAtUtc => throw _privateConstructorUsedError;
  List<PIItem> get items => throw _privateConstructorUsedError;

  /// Create a copy of ProformaInvoice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProformaInvoiceCopyWith<ProformaInvoice> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProformaInvoiceCopyWith<$Res> {
  factory $ProformaInvoiceCopyWith(
          ProformaInvoice value, $Res Function(ProformaInvoice) then) =
      _$ProformaInvoiceCopyWithImpl<$Res, ProformaInvoice>;
  @useResult
  $Res call(
      {String piId,
      String piNumber,
      String companyId,
      String? storeId,
      String? counterpartyId,
      String? counterpartyName,
      Map<String, dynamic>? counterpartyInfo,
      Map<String, dynamic>? sellerInfo,
      String? currencyId,
      String currencyCode,
      double subtotal,
      double discountPercent,
      double discountAmount,
      double taxPercent,
      double taxAmount,
      double totalAmount,
      String? incotermsCode,
      String? incotermsPlace,
      String? portOfLoading,
      String? portOfDischarge,
      String? finalDestination,
      String? countryOfOrigin,
      String? paymentTermsCode,
      String? paymentTermsDetail,
      bool partialShipmentAllowed,
      bool transshipmentAllowed,
      String? shippingMethodCode,
      DateTime? estimatedShipmentDate,
      int? leadTimeDays,
      DateTime? validityDate,
      PIStatus status,
      int version,
      String? notes,
      String? internalNotes,
      String? termsAndConditions,
      String? createdBy,
      DateTime? createdAtUtc,
      DateTime? updatedAtUtc,
      List<PIItem> items});
}

/// @nodoc
class _$ProformaInvoiceCopyWithImpl<$Res, $Val extends ProformaInvoice>
    implements $ProformaInvoiceCopyWith<$Res> {
  _$ProformaInvoiceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProformaInvoice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? piId = null,
    Object? piNumber = null,
    Object? companyId = null,
    Object? storeId = freezed,
    Object? counterpartyId = freezed,
    Object? counterpartyName = freezed,
    Object? counterpartyInfo = freezed,
    Object? sellerInfo = freezed,
    Object? currencyId = freezed,
    Object? currencyCode = null,
    Object? subtotal = null,
    Object? discountPercent = null,
    Object? discountAmount = null,
    Object? taxPercent = null,
    Object? taxAmount = null,
    Object? totalAmount = null,
    Object? incotermsCode = freezed,
    Object? incotermsPlace = freezed,
    Object? portOfLoading = freezed,
    Object? portOfDischarge = freezed,
    Object? finalDestination = freezed,
    Object? countryOfOrigin = freezed,
    Object? paymentTermsCode = freezed,
    Object? paymentTermsDetail = freezed,
    Object? partialShipmentAllowed = null,
    Object? transshipmentAllowed = null,
    Object? shippingMethodCode = freezed,
    Object? estimatedShipmentDate = freezed,
    Object? leadTimeDays = freezed,
    Object? validityDate = freezed,
    Object? status = null,
    Object? version = null,
    Object? notes = freezed,
    Object? internalNotes = freezed,
    Object? termsAndConditions = freezed,
    Object? createdBy = freezed,
    Object? createdAtUtc = freezed,
    Object? updatedAtUtc = freezed,
    Object? items = null,
  }) {
    return _then(_value.copyWith(
      piId: null == piId
          ? _value.piId
          : piId // ignore: cast_nullable_to_non_nullable
              as String,
      piNumber: null == piNumber
          ? _value.piNumber
          : piNumber // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: freezed == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      counterpartyId: freezed == counterpartyId
          ? _value.counterpartyId
          : counterpartyId // ignore: cast_nullable_to_non_nullable
              as String?,
      counterpartyName: freezed == counterpartyName
          ? _value.counterpartyName
          : counterpartyName // ignore: cast_nullable_to_non_nullable
              as String?,
      counterpartyInfo: freezed == counterpartyInfo
          ? _value.counterpartyInfo
          : counterpartyInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      sellerInfo: freezed == sellerInfo
          ? _value.sellerInfo
          : sellerInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      currencyId: freezed == currencyId
          ? _value.currencyId
          : currencyId // ignore: cast_nullable_to_non_nullable
              as String?,
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      discountPercent: null == discountPercent
          ? _value.discountPercent
          : discountPercent // ignore: cast_nullable_to_non_nullable
              as double,
      discountAmount: null == discountAmount
          ? _value.discountAmount
          : discountAmount // ignore: cast_nullable_to_non_nullable
              as double,
      taxPercent: null == taxPercent
          ? _value.taxPercent
          : taxPercent // ignore: cast_nullable_to_non_nullable
              as double,
      taxAmount: null == taxAmount
          ? _value.taxAmount
          : taxAmount // ignore: cast_nullable_to_non_nullable
              as double,
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
      portOfLoading: freezed == portOfLoading
          ? _value.portOfLoading
          : portOfLoading // ignore: cast_nullable_to_non_nullable
              as String?,
      portOfDischarge: freezed == portOfDischarge
          ? _value.portOfDischarge
          : portOfDischarge // ignore: cast_nullable_to_non_nullable
              as String?,
      finalDestination: freezed == finalDestination
          ? _value.finalDestination
          : finalDestination // ignore: cast_nullable_to_non_nullable
              as String?,
      countryOfOrigin: freezed == countryOfOrigin
          ? _value.countryOfOrigin
          : countryOfOrigin // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentTermsCode: freezed == paymentTermsCode
          ? _value.paymentTermsCode
          : paymentTermsCode // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentTermsDetail: freezed == paymentTermsDetail
          ? _value.paymentTermsDetail
          : paymentTermsDetail // ignore: cast_nullable_to_non_nullable
              as String?,
      partialShipmentAllowed: null == partialShipmentAllowed
          ? _value.partialShipmentAllowed
          : partialShipmentAllowed // ignore: cast_nullable_to_non_nullable
              as bool,
      transshipmentAllowed: null == transshipmentAllowed
          ? _value.transshipmentAllowed
          : transshipmentAllowed // ignore: cast_nullable_to_non_nullable
              as bool,
      shippingMethodCode: freezed == shippingMethodCode
          ? _value.shippingMethodCode
          : shippingMethodCode // ignore: cast_nullable_to_non_nullable
              as String?,
      estimatedShipmentDate: freezed == estimatedShipmentDate
          ? _value.estimatedShipmentDate
          : estimatedShipmentDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      leadTimeDays: freezed == leadTimeDays
          ? _value.leadTimeDays
          : leadTimeDays // ignore: cast_nullable_to_non_nullable
              as int?,
      validityDate: freezed == validityDate
          ? _value.validityDate
          : validityDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PIStatus,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      internalNotes: freezed == internalNotes
          ? _value.internalNotes
          : internalNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      termsAndConditions: freezed == termsAndConditions
          ? _value.termsAndConditions
          : termsAndConditions // ignore: cast_nullable_to_non_nullable
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
              as List<PIItem>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProformaInvoiceImplCopyWith<$Res>
    implements $ProformaInvoiceCopyWith<$Res> {
  factory _$$ProformaInvoiceImplCopyWith(_$ProformaInvoiceImpl value,
          $Res Function(_$ProformaInvoiceImpl) then) =
      __$$ProformaInvoiceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String piId,
      String piNumber,
      String companyId,
      String? storeId,
      String? counterpartyId,
      String? counterpartyName,
      Map<String, dynamic>? counterpartyInfo,
      Map<String, dynamic>? sellerInfo,
      String? currencyId,
      String currencyCode,
      double subtotal,
      double discountPercent,
      double discountAmount,
      double taxPercent,
      double taxAmount,
      double totalAmount,
      String? incotermsCode,
      String? incotermsPlace,
      String? portOfLoading,
      String? portOfDischarge,
      String? finalDestination,
      String? countryOfOrigin,
      String? paymentTermsCode,
      String? paymentTermsDetail,
      bool partialShipmentAllowed,
      bool transshipmentAllowed,
      String? shippingMethodCode,
      DateTime? estimatedShipmentDate,
      int? leadTimeDays,
      DateTime? validityDate,
      PIStatus status,
      int version,
      String? notes,
      String? internalNotes,
      String? termsAndConditions,
      String? createdBy,
      DateTime? createdAtUtc,
      DateTime? updatedAtUtc,
      List<PIItem> items});
}

/// @nodoc
class __$$ProformaInvoiceImplCopyWithImpl<$Res>
    extends _$ProformaInvoiceCopyWithImpl<$Res, _$ProformaInvoiceImpl>
    implements _$$ProformaInvoiceImplCopyWith<$Res> {
  __$$ProformaInvoiceImplCopyWithImpl(
      _$ProformaInvoiceImpl _value, $Res Function(_$ProformaInvoiceImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProformaInvoice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? piId = null,
    Object? piNumber = null,
    Object? companyId = null,
    Object? storeId = freezed,
    Object? counterpartyId = freezed,
    Object? counterpartyName = freezed,
    Object? counterpartyInfo = freezed,
    Object? sellerInfo = freezed,
    Object? currencyId = freezed,
    Object? currencyCode = null,
    Object? subtotal = null,
    Object? discountPercent = null,
    Object? discountAmount = null,
    Object? taxPercent = null,
    Object? taxAmount = null,
    Object? totalAmount = null,
    Object? incotermsCode = freezed,
    Object? incotermsPlace = freezed,
    Object? portOfLoading = freezed,
    Object? portOfDischarge = freezed,
    Object? finalDestination = freezed,
    Object? countryOfOrigin = freezed,
    Object? paymentTermsCode = freezed,
    Object? paymentTermsDetail = freezed,
    Object? partialShipmentAllowed = null,
    Object? transshipmentAllowed = null,
    Object? shippingMethodCode = freezed,
    Object? estimatedShipmentDate = freezed,
    Object? leadTimeDays = freezed,
    Object? validityDate = freezed,
    Object? status = null,
    Object? version = null,
    Object? notes = freezed,
    Object? internalNotes = freezed,
    Object? termsAndConditions = freezed,
    Object? createdBy = freezed,
    Object? createdAtUtc = freezed,
    Object? updatedAtUtc = freezed,
    Object? items = null,
  }) {
    return _then(_$ProformaInvoiceImpl(
      piId: null == piId
          ? _value.piId
          : piId // ignore: cast_nullable_to_non_nullable
              as String,
      piNumber: null == piNumber
          ? _value.piNumber
          : piNumber // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: freezed == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      counterpartyId: freezed == counterpartyId
          ? _value.counterpartyId
          : counterpartyId // ignore: cast_nullable_to_non_nullable
              as String?,
      counterpartyName: freezed == counterpartyName
          ? _value.counterpartyName
          : counterpartyName // ignore: cast_nullable_to_non_nullable
              as String?,
      counterpartyInfo: freezed == counterpartyInfo
          ? _value._counterpartyInfo
          : counterpartyInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      sellerInfo: freezed == sellerInfo
          ? _value._sellerInfo
          : sellerInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      currencyId: freezed == currencyId
          ? _value.currencyId
          : currencyId // ignore: cast_nullable_to_non_nullable
              as String?,
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      discountPercent: null == discountPercent
          ? _value.discountPercent
          : discountPercent // ignore: cast_nullable_to_non_nullable
              as double,
      discountAmount: null == discountAmount
          ? _value.discountAmount
          : discountAmount // ignore: cast_nullable_to_non_nullable
              as double,
      taxPercent: null == taxPercent
          ? _value.taxPercent
          : taxPercent // ignore: cast_nullable_to_non_nullable
              as double,
      taxAmount: null == taxAmount
          ? _value.taxAmount
          : taxAmount // ignore: cast_nullable_to_non_nullable
              as double,
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
      portOfLoading: freezed == portOfLoading
          ? _value.portOfLoading
          : portOfLoading // ignore: cast_nullable_to_non_nullable
              as String?,
      portOfDischarge: freezed == portOfDischarge
          ? _value.portOfDischarge
          : portOfDischarge // ignore: cast_nullable_to_non_nullable
              as String?,
      finalDestination: freezed == finalDestination
          ? _value.finalDestination
          : finalDestination // ignore: cast_nullable_to_non_nullable
              as String?,
      countryOfOrigin: freezed == countryOfOrigin
          ? _value.countryOfOrigin
          : countryOfOrigin // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentTermsCode: freezed == paymentTermsCode
          ? _value.paymentTermsCode
          : paymentTermsCode // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentTermsDetail: freezed == paymentTermsDetail
          ? _value.paymentTermsDetail
          : paymentTermsDetail // ignore: cast_nullable_to_non_nullable
              as String?,
      partialShipmentAllowed: null == partialShipmentAllowed
          ? _value.partialShipmentAllowed
          : partialShipmentAllowed // ignore: cast_nullable_to_non_nullable
              as bool,
      transshipmentAllowed: null == transshipmentAllowed
          ? _value.transshipmentAllowed
          : transshipmentAllowed // ignore: cast_nullable_to_non_nullable
              as bool,
      shippingMethodCode: freezed == shippingMethodCode
          ? _value.shippingMethodCode
          : shippingMethodCode // ignore: cast_nullable_to_non_nullable
              as String?,
      estimatedShipmentDate: freezed == estimatedShipmentDate
          ? _value.estimatedShipmentDate
          : estimatedShipmentDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      leadTimeDays: freezed == leadTimeDays
          ? _value.leadTimeDays
          : leadTimeDays // ignore: cast_nullable_to_non_nullable
              as int?,
      validityDate: freezed == validityDate
          ? _value.validityDate
          : validityDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PIStatus,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      internalNotes: freezed == internalNotes
          ? _value.internalNotes
          : internalNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      termsAndConditions: freezed == termsAndConditions
          ? _value.termsAndConditions
          : termsAndConditions // ignore: cast_nullable_to_non_nullable
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
              as List<PIItem>,
    ));
  }
}

/// @nodoc

class _$ProformaInvoiceImpl extends _ProformaInvoice {
  const _$ProformaInvoiceImpl(
      {required this.piId,
      required this.piNumber,
      required this.companyId,
      this.storeId,
      this.counterpartyId,
      this.counterpartyName,
      final Map<String, dynamic>? counterpartyInfo,
      final Map<String, dynamic>? sellerInfo,
      this.currencyId,
      this.currencyCode = 'USD',
      this.subtotal = 0,
      this.discountPercent = 0,
      this.discountAmount = 0,
      this.taxPercent = 0,
      this.taxAmount = 0,
      this.totalAmount = 0,
      this.incotermsCode,
      this.incotermsPlace,
      this.portOfLoading,
      this.portOfDischarge,
      this.finalDestination,
      this.countryOfOrigin,
      this.paymentTermsCode,
      this.paymentTermsDetail,
      this.partialShipmentAllowed = true,
      this.transshipmentAllowed = true,
      this.shippingMethodCode,
      this.estimatedShipmentDate,
      this.leadTimeDays,
      this.validityDate,
      this.status = PIStatus.draft,
      this.version = 1,
      this.notes,
      this.internalNotes,
      this.termsAndConditions,
      this.createdBy,
      this.createdAtUtc,
      this.updatedAtUtc,
      final List<PIItem> items = const []})
      : _counterpartyInfo = counterpartyInfo,
        _sellerInfo = sellerInfo,
        _items = items,
        super._();

  @override
  final String piId;
  @override
  final String piNumber;
  @override
  final String companyId;
  @override
  final String? storeId;
  @override
  final String? counterpartyId;
  @override
  final String? counterpartyName;
  final Map<String, dynamic>? _counterpartyInfo;
  @override
  Map<String, dynamic>? get counterpartyInfo {
    final value = _counterpartyInfo;
    if (value == null) return null;
    if (_counterpartyInfo is EqualUnmodifiableMapView) return _counterpartyInfo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _sellerInfo;
  @override
  Map<String, dynamic>? get sellerInfo {
    final value = _sellerInfo;
    if (value == null) return null;
    if (_sellerInfo is EqualUnmodifiableMapView) return _sellerInfo;
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
  final double subtotal;
  @override
  @JsonKey()
  final double discountPercent;
  @override
  @JsonKey()
  final double discountAmount;
  @override
  @JsonKey()
  final double taxPercent;
  @override
  @JsonKey()
  final double taxAmount;
  @override
  @JsonKey()
  final double totalAmount;
  @override
  final String? incotermsCode;
  @override
  final String? incotermsPlace;
  @override
  final String? portOfLoading;
  @override
  final String? portOfDischarge;
  @override
  final String? finalDestination;
  @override
  final String? countryOfOrigin;
  @override
  final String? paymentTermsCode;
  @override
  final String? paymentTermsDetail;
  @override
  @JsonKey()
  final bool partialShipmentAllowed;
  @override
  @JsonKey()
  final bool transshipmentAllowed;
  @override
  final String? shippingMethodCode;
  @override
  final DateTime? estimatedShipmentDate;
  @override
  final int? leadTimeDays;
  @override
  final DateTime? validityDate;
  @override
  @JsonKey()
  final PIStatus status;
  @override
  @JsonKey()
  final int version;
  @override
  final String? notes;
  @override
  final String? internalNotes;
  @override
  final String? termsAndConditions;
  @override
  final String? createdBy;
  @override
  final DateTime? createdAtUtc;
  @override
  final DateTime? updatedAtUtc;
  final List<PIItem> _items;
  @override
  @JsonKey()
  List<PIItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'ProformaInvoice(piId: $piId, piNumber: $piNumber, companyId: $companyId, storeId: $storeId, counterpartyId: $counterpartyId, counterpartyName: $counterpartyName, counterpartyInfo: $counterpartyInfo, sellerInfo: $sellerInfo, currencyId: $currencyId, currencyCode: $currencyCode, subtotal: $subtotal, discountPercent: $discountPercent, discountAmount: $discountAmount, taxPercent: $taxPercent, taxAmount: $taxAmount, totalAmount: $totalAmount, incotermsCode: $incotermsCode, incotermsPlace: $incotermsPlace, portOfLoading: $portOfLoading, portOfDischarge: $portOfDischarge, finalDestination: $finalDestination, countryOfOrigin: $countryOfOrigin, paymentTermsCode: $paymentTermsCode, paymentTermsDetail: $paymentTermsDetail, partialShipmentAllowed: $partialShipmentAllowed, transshipmentAllowed: $transshipmentAllowed, shippingMethodCode: $shippingMethodCode, estimatedShipmentDate: $estimatedShipmentDate, leadTimeDays: $leadTimeDays, validityDate: $validityDate, status: $status, version: $version, notes: $notes, internalNotes: $internalNotes, termsAndConditions: $termsAndConditions, createdBy: $createdBy, createdAtUtc: $createdAtUtc, updatedAtUtc: $updatedAtUtc, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProformaInvoiceImpl &&
            (identical(other.piId, piId) || other.piId == piId) &&
            (identical(other.piNumber, piNumber) ||
                other.piNumber == piNumber) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.counterpartyId, counterpartyId) ||
                other.counterpartyId == counterpartyId) &&
            (identical(other.counterpartyName, counterpartyName) ||
                other.counterpartyName == counterpartyName) &&
            const DeepCollectionEquality()
                .equals(other._counterpartyInfo, _counterpartyInfo) &&
            const DeepCollectionEquality()
                .equals(other._sellerInfo, _sellerInfo) &&
            (identical(other.currencyId, currencyId) ||
                other.currencyId == currencyId) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.discountPercent, discountPercent) ||
                other.discountPercent == discountPercent) &&
            (identical(other.discountAmount, discountAmount) ||
                other.discountAmount == discountAmount) &&
            (identical(other.taxPercent, taxPercent) ||
                other.taxPercent == taxPercent) &&
            (identical(other.taxAmount, taxAmount) ||
                other.taxAmount == taxAmount) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.incotermsCode, incotermsCode) ||
                other.incotermsCode == incotermsCode) &&
            (identical(other.incotermsPlace, incotermsPlace) ||
                other.incotermsPlace == incotermsPlace) &&
            (identical(other.portOfLoading, portOfLoading) ||
                other.portOfLoading == portOfLoading) &&
            (identical(other.portOfDischarge, portOfDischarge) ||
                other.portOfDischarge == portOfDischarge) &&
            (identical(other.finalDestination, finalDestination) ||
                other.finalDestination == finalDestination) &&
            (identical(other.countryOfOrigin, countryOfOrigin) ||
                other.countryOfOrigin == countryOfOrigin) &&
            (identical(other.paymentTermsCode, paymentTermsCode) ||
                other.paymentTermsCode == paymentTermsCode) &&
            (identical(other.paymentTermsDetail, paymentTermsDetail) ||
                other.paymentTermsDetail == paymentTermsDetail) &&
            (identical(other.partialShipmentAllowed, partialShipmentAllowed) ||
                other.partialShipmentAllowed == partialShipmentAllowed) &&
            (identical(other.transshipmentAllowed, transshipmentAllowed) ||
                other.transshipmentAllowed == transshipmentAllowed) &&
            (identical(other.shippingMethodCode, shippingMethodCode) ||
                other.shippingMethodCode == shippingMethodCode) &&
            (identical(other.estimatedShipmentDate, estimatedShipmentDate) ||
                other.estimatedShipmentDate == estimatedShipmentDate) &&
            (identical(other.leadTimeDays, leadTimeDays) ||
                other.leadTimeDays == leadTimeDays) &&
            (identical(other.validityDate, validityDate) ||
                other.validityDate == validityDate) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.internalNotes, internalNotes) ||
                other.internalNotes == internalNotes) &&
            (identical(other.termsAndConditions, termsAndConditions) ||
                other.termsAndConditions == termsAndConditions) &&
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
        piId,
        piNumber,
        companyId,
        storeId,
        counterpartyId,
        counterpartyName,
        const DeepCollectionEquality().hash(_counterpartyInfo),
        const DeepCollectionEquality().hash(_sellerInfo),
        currencyId,
        currencyCode,
        subtotal,
        discountPercent,
        discountAmount,
        taxPercent,
        taxAmount,
        totalAmount,
        incotermsCode,
        incotermsPlace,
        portOfLoading,
        portOfDischarge,
        finalDestination,
        countryOfOrigin,
        paymentTermsCode,
        paymentTermsDetail,
        partialShipmentAllowed,
        transshipmentAllowed,
        shippingMethodCode,
        estimatedShipmentDate,
        leadTimeDays,
        validityDate,
        status,
        version,
        notes,
        internalNotes,
        termsAndConditions,
        createdBy,
        createdAtUtc,
        updatedAtUtc,
        const DeepCollectionEquality().hash(_items)
      ]);

  /// Create a copy of ProformaInvoice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProformaInvoiceImplCopyWith<_$ProformaInvoiceImpl> get copyWith =>
      __$$ProformaInvoiceImplCopyWithImpl<_$ProformaInvoiceImpl>(
          this, _$identity);
}

abstract class _ProformaInvoice extends ProformaInvoice {
  const factory _ProformaInvoice(
      {required final String piId,
      required final String piNumber,
      required final String companyId,
      final String? storeId,
      final String? counterpartyId,
      final String? counterpartyName,
      final Map<String, dynamic>? counterpartyInfo,
      final Map<String, dynamic>? sellerInfo,
      final String? currencyId,
      final String currencyCode,
      final double subtotal,
      final double discountPercent,
      final double discountAmount,
      final double taxPercent,
      final double taxAmount,
      final double totalAmount,
      final String? incotermsCode,
      final String? incotermsPlace,
      final String? portOfLoading,
      final String? portOfDischarge,
      final String? finalDestination,
      final String? countryOfOrigin,
      final String? paymentTermsCode,
      final String? paymentTermsDetail,
      final bool partialShipmentAllowed,
      final bool transshipmentAllowed,
      final String? shippingMethodCode,
      final DateTime? estimatedShipmentDate,
      final int? leadTimeDays,
      final DateTime? validityDate,
      final PIStatus status,
      final int version,
      final String? notes,
      final String? internalNotes,
      final String? termsAndConditions,
      final String? createdBy,
      final DateTime? createdAtUtc,
      final DateTime? updatedAtUtc,
      final List<PIItem> items}) = _$ProformaInvoiceImpl;
  const _ProformaInvoice._() : super._();

  @override
  String get piId;
  @override
  String get piNumber;
  @override
  String get companyId;
  @override
  String? get storeId;
  @override
  String? get counterpartyId;
  @override
  String? get counterpartyName;
  @override
  Map<String, dynamic>? get counterpartyInfo;
  @override
  Map<String, dynamic>? get sellerInfo;
  @override
  String? get currencyId;
  @override
  String get currencyCode;
  @override
  double get subtotal;
  @override
  double get discountPercent;
  @override
  double get discountAmount;
  @override
  double get taxPercent;
  @override
  double get taxAmount;
  @override
  double get totalAmount;
  @override
  String? get incotermsCode;
  @override
  String? get incotermsPlace;
  @override
  String? get portOfLoading;
  @override
  String? get portOfDischarge;
  @override
  String? get finalDestination;
  @override
  String? get countryOfOrigin;
  @override
  String? get paymentTermsCode;
  @override
  String? get paymentTermsDetail;
  @override
  bool get partialShipmentAllowed;
  @override
  bool get transshipmentAllowed;
  @override
  String? get shippingMethodCode;
  @override
  DateTime? get estimatedShipmentDate;
  @override
  int? get leadTimeDays;
  @override
  DateTime? get validityDate;
  @override
  PIStatus get status;
  @override
  int get version;
  @override
  String? get notes;
  @override
  String? get internalNotes;
  @override
  String? get termsAndConditions;
  @override
  String? get createdBy;
  @override
  DateTime? get createdAtUtc;
  @override
  DateTime? get updatedAtUtc;
  @override
  List<PIItem> get items;

  /// Create a copy of ProformaInvoice
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProformaInvoiceImplCopyWith<_$ProformaInvoiceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PIListItem {
  String get piId => throw _privateConstructorUsedError;
  String get piNumber => throw _privateConstructorUsedError;
  String? get counterpartyName => throw _privateConstructorUsedError;
  String get currencyCode => throw _privateConstructorUsedError;
  double get totalAmount => throw _privateConstructorUsedError;
  PIStatus get status => throw _privateConstructorUsedError;
  DateTime? get validityDate => throw _privateConstructorUsedError;
  DateTime? get createdAtUtc => throw _privateConstructorUsedError;
  int get itemCount => throw _privateConstructorUsedError;

  /// Create a copy of PIListItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PIListItemCopyWith<PIListItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PIListItemCopyWith<$Res> {
  factory $PIListItemCopyWith(
          PIListItem value, $Res Function(PIListItem) then) =
      _$PIListItemCopyWithImpl<$Res, PIListItem>;
  @useResult
  $Res call(
      {String piId,
      String piNumber,
      String? counterpartyName,
      String currencyCode,
      double totalAmount,
      PIStatus status,
      DateTime? validityDate,
      DateTime? createdAtUtc,
      int itemCount});
}

/// @nodoc
class _$PIListItemCopyWithImpl<$Res, $Val extends PIListItem>
    implements $PIListItemCopyWith<$Res> {
  _$PIListItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PIListItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? piId = null,
    Object? piNumber = null,
    Object? counterpartyName = freezed,
    Object? currencyCode = null,
    Object? totalAmount = null,
    Object? status = null,
    Object? validityDate = freezed,
    Object? createdAtUtc = freezed,
    Object? itemCount = null,
  }) {
    return _then(_value.copyWith(
      piId: null == piId
          ? _value.piId
          : piId // ignore: cast_nullable_to_non_nullable
              as String,
      piNumber: null == piNumber
          ? _value.piNumber
          : piNumber // ignore: cast_nullable_to_non_nullable
              as String,
      counterpartyName: freezed == counterpartyName
          ? _value.counterpartyName
          : counterpartyName // ignore: cast_nullable_to_non_nullable
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
              as PIStatus,
      validityDate: freezed == validityDate
          ? _value.validityDate
          : validityDate // ignore: cast_nullable_to_non_nullable
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
abstract class _$$PIListItemImplCopyWith<$Res>
    implements $PIListItemCopyWith<$Res> {
  factory _$$PIListItemImplCopyWith(
          _$PIListItemImpl value, $Res Function(_$PIListItemImpl) then) =
      __$$PIListItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String piId,
      String piNumber,
      String? counterpartyName,
      String currencyCode,
      double totalAmount,
      PIStatus status,
      DateTime? validityDate,
      DateTime? createdAtUtc,
      int itemCount});
}

/// @nodoc
class __$$PIListItemImplCopyWithImpl<$Res>
    extends _$PIListItemCopyWithImpl<$Res, _$PIListItemImpl>
    implements _$$PIListItemImplCopyWith<$Res> {
  __$$PIListItemImplCopyWithImpl(
      _$PIListItemImpl _value, $Res Function(_$PIListItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of PIListItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? piId = null,
    Object? piNumber = null,
    Object? counterpartyName = freezed,
    Object? currencyCode = null,
    Object? totalAmount = null,
    Object? status = null,
    Object? validityDate = freezed,
    Object? createdAtUtc = freezed,
    Object? itemCount = null,
  }) {
    return _then(_$PIListItemImpl(
      piId: null == piId
          ? _value.piId
          : piId // ignore: cast_nullable_to_non_nullable
              as String,
      piNumber: null == piNumber
          ? _value.piNumber
          : piNumber // ignore: cast_nullable_to_non_nullable
              as String,
      counterpartyName: freezed == counterpartyName
          ? _value.counterpartyName
          : counterpartyName // ignore: cast_nullable_to_non_nullable
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
              as PIStatus,
      validityDate: freezed == validityDate
          ? _value.validityDate
          : validityDate // ignore: cast_nullable_to_non_nullable
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

class _$PIListItemImpl extends _PIListItem {
  const _$PIListItemImpl(
      {required this.piId,
      required this.piNumber,
      this.counterpartyName,
      required this.currencyCode,
      required this.totalAmount,
      required this.status,
      this.validityDate,
      this.createdAtUtc,
      this.itemCount = 0})
      : super._();

  @override
  final String piId;
  @override
  final String piNumber;
  @override
  final String? counterpartyName;
  @override
  final String currencyCode;
  @override
  final double totalAmount;
  @override
  final PIStatus status;
  @override
  final DateTime? validityDate;
  @override
  final DateTime? createdAtUtc;
  @override
  @JsonKey()
  final int itemCount;

  @override
  String toString() {
    return 'PIListItem(piId: $piId, piNumber: $piNumber, counterpartyName: $counterpartyName, currencyCode: $currencyCode, totalAmount: $totalAmount, status: $status, validityDate: $validityDate, createdAtUtc: $createdAtUtc, itemCount: $itemCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PIListItemImpl &&
            (identical(other.piId, piId) || other.piId == piId) &&
            (identical(other.piNumber, piNumber) ||
                other.piNumber == piNumber) &&
            (identical(other.counterpartyName, counterpartyName) ||
                other.counterpartyName == counterpartyName) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.validityDate, validityDate) ||
                other.validityDate == validityDate) &&
            (identical(other.createdAtUtc, createdAtUtc) ||
                other.createdAtUtc == createdAtUtc) &&
            (identical(other.itemCount, itemCount) ||
                other.itemCount == itemCount));
  }

  @override
  int get hashCode => Object.hash(runtimeType, piId, piNumber, counterpartyName,
      currencyCode, totalAmount, status, validityDate, createdAtUtc, itemCount);

  /// Create a copy of PIListItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PIListItemImplCopyWith<_$PIListItemImpl> get copyWith =>
      __$$PIListItemImplCopyWithImpl<_$PIListItemImpl>(this, _$identity);
}

abstract class _PIListItem extends PIListItem {
  const factory _PIListItem(
      {required final String piId,
      required final String piNumber,
      final String? counterpartyName,
      required final String currencyCode,
      required final double totalAmount,
      required final PIStatus status,
      final DateTime? validityDate,
      final DateTime? createdAtUtc,
      final int itemCount}) = _$PIListItemImpl;
  const _PIListItem._() : super._();

  @override
  String get piId;
  @override
  String get piNumber;
  @override
  String? get counterpartyName;
  @override
  String get currencyCode;
  @override
  double get totalAmount;
  @override
  PIStatus get status;
  @override
  DateTime? get validityDate;
  @override
  DateTime? get createdAtUtc;
  @override
  int get itemCount;

  /// Create a copy of PIListItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PIListItemImplCopyWith<_$PIListItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
