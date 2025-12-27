// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pi_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PIItemModel _$PIItemModelFromJson(Map<String, dynamic> json) {
  return _PIItemModel.fromJson(json);
}

/// @nodoc
mixin _$PIItemModel {
  @JsonKey(name: 'item_id')
  String get itemId => throw _privateConstructorUsedError;
  @JsonKey(name: 'pi_id')
  String get piId => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_id')
  String? get productId => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String? get sku => throw _privateConstructorUsedError;
  String? get barcode => throw _privateConstructorUsedError;
  @JsonKey(name: 'hs_code')
  String? get hsCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'country_of_origin')
  String? get countryOfOrigin => throw _privateConstructorUsedError;
  double get quantity => throw _privateConstructorUsedError;
  String? get unit => throw _privateConstructorUsedError;
  @JsonKey(name: 'unit_price')
  double get unitPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'discount_percent')
  double get discountPercent => throw _privateConstructorUsedError;
  @JsonKey(name: 'discount_amount')
  double get discountAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_amount')
  double get totalAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'packing_info')
  String? get packingInfo => throw _privateConstructorUsedError;
  @JsonKey(name: 'sort_order')
  int get sortOrder => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at_utc')
  DateTime? get createdAtUtc => throw _privateConstructorUsedError;

  /// Serializes this PIItemModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PIItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PIItemModelCopyWith<PIItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PIItemModelCopyWith<$Res> {
  factory $PIItemModelCopyWith(
          PIItemModel value, $Res Function(PIItemModel) then) =
      _$PIItemModelCopyWithImpl<$Res, PIItemModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'item_id') String itemId,
      @JsonKey(name: 'pi_id') String piId,
      @JsonKey(name: 'product_id') String? productId,
      String description,
      String? sku,
      String? barcode,
      @JsonKey(name: 'hs_code') String? hsCode,
      @JsonKey(name: 'country_of_origin') String? countryOfOrigin,
      double quantity,
      String? unit,
      @JsonKey(name: 'unit_price') double unitPrice,
      @JsonKey(name: 'discount_percent') double discountPercent,
      @JsonKey(name: 'discount_amount') double discountAmount,
      @JsonKey(name: 'total_amount') double totalAmount,
      @JsonKey(name: 'packing_info') String? packingInfo,
      @JsonKey(name: 'sort_order') int sortOrder,
      @JsonKey(name: 'created_at_utc') DateTime? createdAtUtc});
}

/// @nodoc
class _$PIItemModelCopyWithImpl<$Res, $Val extends PIItemModel>
    implements $PIItemModelCopyWith<$Res> {
  _$PIItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PIItemModel
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
abstract class _$$PIItemModelImplCopyWith<$Res>
    implements $PIItemModelCopyWith<$Res> {
  factory _$$PIItemModelImplCopyWith(
          _$PIItemModelImpl value, $Res Function(_$PIItemModelImpl) then) =
      __$$PIItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'item_id') String itemId,
      @JsonKey(name: 'pi_id') String piId,
      @JsonKey(name: 'product_id') String? productId,
      String description,
      String? sku,
      String? barcode,
      @JsonKey(name: 'hs_code') String? hsCode,
      @JsonKey(name: 'country_of_origin') String? countryOfOrigin,
      double quantity,
      String? unit,
      @JsonKey(name: 'unit_price') double unitPrice,
      @JsonKey(name: 'discount_percent') double discountPercent,
      @JsonKey(name: 'discount_amount') double discountAmount,
      @JsonKey(name: 'total_amount') double totalAmount,
      @JsonKey(name: 'packing_info') String? packingInfo,
      @JsonKey(name: 'sort_order') int sortOrder,
      @JsonKey(name: 'created_at_utc') DateTime? createdAtUtc});
}

/// @nodoc
class __$$PIItemModelImplCopyWithImpl<$Res>
    extends _$PIItemModelCopyWithImpl<$Res, _$PIItemModelImpl>
    implements _$$PIItemModelImplCopyWith<$Res> {
  __$$PIItemModelImplCopyWithImpl(
      _$PIItemModelImpl _value, $Res Function(_$PIItemModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of PIItemModel
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
    return _then(_$PIItemModelImpl(
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
@JsonSerializable()
class _$PIItemModelImpl extends _PIItemModel {
  const _$PIItemModelImpl(
      {@JsonKey(name: 'item_id') required this.itemId,
      @JsonKey(name: 'pi_id') required this.piId,
      @JsonKey(name: 'product_id') this.productId,
      required this.description,
      this.sku,
      this.barcode,
      @JsonKey(name: 'hs_code') this.hsCode,
      @JsonKey(name: 'country_of_origin') this.countryOfOrigin,
      required this.quantity,
      this.unit,
      @JsonKey(name: 'unit_price') required this.unitPrice,
      @JsonKey(name: 'discount_percent') this.discountPercent = 0,
      @JsonKey(name: 'discount_amount') this.discountAmount = 0,
      @JsonKey(name: 'total_amount') required this.totalAmount,
      @JsonKey(name: 'packing_info') this.packingInfo,
      @JsonKey(name: 'sort_order') this.sortOrder = 0,
      @JsonKey(name: 'created_at_utc') this.createdAtUtc})
      : super._();

  factory _$PIItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PIItemModelImplFromJson(json);

  @override
  @JsonKey(name: 'item_id')
  final String itemId;
  @override
  @JsonKey(name: 'pi_id')
  final String piId;
  @override
  @JsonKey(name: 'product_id')
  final String? productId;
  @override
  final String description;
  @override
  final String? sku;
  @override
  final String? barcode;
  @override
  @JsonKey(name: 'hs_code')
  final String? hsCode;
  @override
  @JsonKey(name: 'country_of_origin')
  final String? countryOfOrigin;
  @override
  final double quantity;
  @override
  final String? unit;
  @override
  @JsonKey(name: 'unit_price')
  final double unitPrice;
  @override
  @JsonKey(name: 'discount_percent')
  final double discountPercent;
  @override
  @JsonKey(name: 'discount_amount')
  final double discountAmount;
  @override
  @JsonKey(name: 'total_amount')
  final double totalAmount;
  @override
  @JsonKey(name: 'packing_info')
  final String? packingInfo;
  @override
  @JsonKey(name: 'sort_order')
  final int sortOrder;
  @override
  @JsonKey(name: 'created_at_utc')
  final DateTime? createdAtUtc;

  @override
  String toString() {
    return 'PIItemModel(itemId: $itemId, piId: $piId, productId: $productId, description: $description, sku: $sku, barcode: $barcode, hsCode: $hsCode, countryOfOrigin: $countryOfOrigin, quantity: $quantity, unit: $unit, unitPrice: $unitPrice, discountPercent: $discountPercent, discountAmount: $discountAmount, totalAmount: $totalAmount, packingInfo: $packingInfo, sortOrder: $sortOrder, createdAtUtc: $createdAtUtc)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PIItemModelImpl &&
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

  @JsonKey(includeFromJson: false, includeToJson: false)
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

  /// Create a copy of PIItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PIItemModelImplCopyWith<_$PIItemModelImpl> get copyWith =>
      __$$PIItemModelImplCopyWithImpl<_$PIItemModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PIItemModelImplToJson(
      this,
    );
  }
}

abstract class _PIItemModel extends PIItemModel {
  const factory _PIItemModel(
          {@JsonKey(name: 'item_id') required final String itemId,
          @JsonKey(name: 'pi_id') required final String piId,
          @JsonKey(name: 'product_id') final String? productId,
          required final String description,
          final String? sku,
          final String? barcode,
          @JsonKey(name: 'hs_code') final String? hsCode,
          @JsonKey(name: 'country_of_origin') final String? countryOfOrigin,
          required final double quantity,
          final String? unit,
          @JsonKey(name: 'unit_price') required final double unitPrice,
          @JsonKey(name: 'discount_percent') final double discountPercent,
          @JsonKey(name: 'discount_amount') final double discountAmount,
          @JsonKey(name: 'total_amount') required final double totalAmount,
          @JsonKey(name: 'packing_info') final String? packingInfo,
          @JsonKey(name: 'sort_order') final int sortOrder,
          @JsonKey(name: 'created_at_utc') final DateTime? createdAtUtc}) =
      _$PIItemModelImpl;
  const _PIItemModel._() : super._();

  factory _PIItemModel.fromJson(Map<String, dynamic> json) =
      _$PIItemModelImpl.fromJson;

  @override
  @JsonKey(name: 'item_id')
  String get itemId;
  @override
  @JsonKey(name: 'pi_id')
  String get piId;
  @override
  @JsonKey(name: 'product_id')
  String? get productId;
  @override
  String get description;
  @override
  String? get sku;
  @override
  String? get barcode;
  @override
  @JsonKey(name: 'hs_code')
  String? get hsCode;
  @override
  @JsonKey(name: 'country_of_origin')
  String? get countryOfOrigin;
  @override
  double get quantity;
  @override
  String? get unit;
  @override
  @JsonKey(name: 'unit_price')
  double get unitPrice;
  @override
  @JsonKey(name: 'discount_percent')
  double get discountPercent;
  @override
  @JsonKey(name: 'discount_amount')
  double get discountAmount;
  @override
  @JsonKey(name: 'total_amount')
  double get totalAmount;
  @override
  @JsonKey(name: 'packing_info')
  String? get packingInfo;
  @override
  @JsonKey(name: 'sort_order')
  int get sortOrder;
  @override
  @JsonKey(name: 'created_at_utc')
  DateTime? get createdAtUtc;

  /// Create a copy of PIItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PIItemModelImplCopyWith<_$PIItemModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PIModel _$PIModelFromJson(Map<String, dynamic> json) {
  return _PIModel.fromJson(json);
}

/// @nodoc
mixin _$PIModel {
  @JsonKey(name: 'pi_id')
  String get piId => throw _privateConstructorUsedError;
  @JsonKey(name: 'pi_number')
  String get piNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_id')
  String get companyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'store_id')
  String? get storeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'counterparty_id')
  String? get counterpartyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'counterparty_name')
  String? get counterpartyName => throw _privateConstructorUsedError;
  @JsonKey(name: 'counterparty_info')
  Map<String, dynamic>? get counterpartyInfo =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'seller_info')
  Map<String, dynamic>? get sellerInfo => throw _privateConstructorUsedError;
  @JsonKey(name: 'currency_id')
  String? get currencyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'currency_code')
  String get currencyCode => throw _privateConstructorUsedError;
  double get subtotal => throw _privateConstructorUsedError;
  @JsonKey(name: 'discount_percent')
  double get discountPercent => throw _privateConstructorUsedError;
  @JsonKey(name: 'discount_amount')
  double get discountAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'tax_percent')
  double get taxPercent => throw _privateConstructorUsedError;
  @JsonKey(name: 'tax_amount')
  double get taxAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_amount')
  double get totalAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'incoterms_code')
  String? get incotermsCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'incoterms_place')
  String? get incotermsPlace => throw _privateConstructorUsedError;
  @JsonKey(name: 'port_of_loading')
  String? get portOfLoading => throw _privateConstructorUsedError;
  @JsonKey(name: 'port_of_discharge')
  String? get portOfDischarge => throw _privateConstructorUsedError;
  @JsonKey(name: 'final_destination')
  String? get finalDestination => throw _privateConstructorUsedError;
  @JsonKey(name: 'country_of_origin')
  String? get countryOfOrigin => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_terms_code')
  String? get paymentTermsCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_terms_detail')
  String? get paymentTermsDetail => throw _privateConstructorUsedError;
  @JsonKey(name: 'partial_shipment_allowed')
  bool get partialShipmentAllowed => throw _privateConstructorUsedError;
  @JsonKey(name: 'transshipment_allowed')
  bool get transshipmentAllowed => throw _privateConstructorUsedError;
  @JsonKey(name: 'shipping_method_code')
  String? get shippingMethodCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'estimated_shipment_date')
  DateTime? get estimatedShipmentDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'lead_time_days')
  int? get leadTimeDays => throw _privateConstructorUsedError;
  @JsonKey(name: 'validity_date')
  DateTime? get validityDate => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  int get version => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'internal_notes')
  String? get internalNotes => throw _privateConstructorUsedError;
  @JsonKey(name: 'terms_and_conditions')
  String? get termsAndConditions => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_by')
  String? get createdBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at_utc')
  DateTime? get createdAtUtc => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at_utc')
  DateTime? get updatedAtUtc => throw _privateConstructorUsedError;
  List<PIItemModel> get items => throw _privateConstructorUsedError;
  @JsonKey(name: 'item_count')
  int get itemCount => throw _privateConstructorUsedError;

  /// Serializes this PIModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PIModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PIModelCopyWith<PIModel> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PIModelCopyWith<$Res> {
  factory $PIModelCopyWith(PIModel value, $Res Function(PIModel) then) =
      _$PIModelCopyWithImpl<$Res, PIModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'pi_id') String piId,
      @JsonKey(name: 'pi_number') String piNumber,
      @JsonKey(name: 'company_id') String companyId,
      @JsonKey(name: 'store_id') String? storeId,
      @JsonKey(name: 'counterparty_id') String? counterpartyId,
      @JsonKey(name: 'counterparty_name') String? counterpartyName,
      @JsonKey(name: 'counterparty_info')
      Map<String, dynamic>? counterpartyInfo,
      @JsonKey(name: 'seller_info') Map<String, dynamic>? sellerInfo,
      @JsonKey(name: 'currency_id') String? currencyId,
      @JsonKey(name: 'currency_code') String currencyCode,
      double subtotal,
      @JsonKey(name: 'discount_percent') double discountPercent,
      @JsonKey(name: 'discount_amount') double discountAmount,
      @JsonKey(name: 'tax_percent') double taxPercent,
      @JsonKey(name: 'tax_amount') double taxAmount,
      @JsonKey(name: 'total_amount') double totalAmount,
      @JsonKey(name: 'incoterms_code') String? incotermsCode,
      @JsonKey(name: 'incoterms_place') String? incotermsPlace,
      @JsonKey(name: 'port_of_loading') String? portOfLoading,
      @JsonKey(name: 'port_of_discharge') String? portOfDischarge,
      @JsonKey(name: 'final_destination') String? finalDestination,
      @JsonKey(name: 'country_of_origin') String? countryOfOrigin,
      @JsonKey(name: 'payment_terms_code') String? paymentTermsCode,
      @JsonKey(name: 'payment_terms_detail') String? paymentTermsDetail,
      @JsonKey(name: 'partial_shipment_allowed') bool partialShipmentAllowed,
      @JsonKey(name: 'transshipment_allowed') bool transshipmentAllowed,
      @JsonKey(name: 'shipping_method_code') String? shippingMethodCode,
      @JsonKey(name: 'estimated_shipment_date') DateTime? estimatedShipmentDate,
      @JsonKey(name: 'lead_time_days') int? leadTimeDays,
      @JsonKey(name: 'validity_date') DateTime? validityDate,
      String status,
      int version,
      String? notes,
      @JsonKey(name: 'internal_notes') String? internalNotes,
      @JsonKey(name: 'terms_and_conditions') String? termsAndConditions,
      @JsonKey(name: 'created_by') String? createdBy,
      @JsonKey(name: 'created_at_utc') DateTime? createdAtUtc,
      @JsonKey(name: 'updated_at_utc') DateTime? updatedAtUtc,
      List<PIItemModel> items,
      @JsonKey(name: 'item_count') int itemCount});
}

/// @nodoc
class _$PIModelCopyWithImpl<$Res, $Val extends PIModel>
    implements $PIModelCopyWith<$Res> {
  _$PIModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PIModel
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
              as String,
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
              as List<PIItemModel>,
      itemCount: null == itemCount
          ? _value.itemCount
          : itemCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PIModelImplCopyWith<$Res> implements $PIModelCopyWith<$Res> {
  factory _$$PIModelImplCopyWith(
          _$PIModelImpl value, $Res Function(_$PIModelImpl) then) =
      __$$PIModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'pi_id') String piId,
      @JsonKey(name: 'pi_number') String piNumber,
      @JsonKey(name: 'company_id') String companyId,
      @JsonKey(name: 'store_id') String? storeId,
      @JsonKey(name: 'counterparty_id') String? counterpartyId,
      @JsonKey(name: 'counterparty_name') String? counterpartyName,
      @JsonKey(name: 'counterparty_info')
      Map<String, dynamic>? counterpartyInfo,
      @JsonKey(name: 'seller_info') Map<String, dynamic>? sellerInfo,
      @JsonKey(name: 'currency_id') String? currencyId,
      @JsonKey(name: 'currency_code') String currencyCode,
      double subtotal,
      @JsonKey(name: 'discount_percent') double discountPercent,
      @JsonKey(name: 'discount_amount') double discountAmount,
      @JsonKey(name: 'tax_percent') double taxPercent,
      @JsonKey(name: 'tax_amount') double taxAmount,
      @JsonKey(name: 'total_amount') double totalAmount,
      @JsonKey(name: 'incoterms_code') String? incotermsCode,
      @JsonKey(name: 'incoterms_place') String? incotermsPlace,
      @JsonKey(name: 'port_of_loading') String? portOfLoading,
      @JsonKey(name: 'port_of_discharge') String? portOfDischarge,
      @JsonKey(name: 'final_destination') String? finalDestination,
      @JsonKey(name: 'country_of_origin') String? countryOfOrigin,
      @JsonKey(name: 'payment_terms_code') String? paymentTermsCode,
      @JsonKey(name: 'payment_terms_detail') String? paymentTermsDetail,
      @JsonKey(name: 'partial_shipment_allowed') bool partialShipmentAllowed,
      @JsonKey(name: 'transshipment_allowed') bool transshipmentAllowed,
      @JsonKey(name: 'shipping_method_code') String? shippingMethodCode,
      @JsonKey(name: 'estimated_shipment_date') DateTime? estimatedShipmentDate,
      @JsonKey(name: 'lead_time_days') int? leadTimeDays,
      @JsonKey(name: 'validity_date') DateTime? validityDate,
      String status,
      int version,
      String? notes,
      @JsonKey(name: 'internal_notes') String? internalNotes,
      @JsonKey(name: 'terms_and_conditions') String? termsAndConditions,
      @JsonKey(name: 'created_by') String? createdBy,
      @JsonKey(name: 'created_at_utc') DateTime? createdAtUtc,
      @JsonKey(name: 'updated_at_utc') DateTime? updatedAtUtc,
      List<PIItemModel> items,
      @JsonKey(name: 'item_count') int itemCount});
}

/// @nodoc
class __$$PIModelImplCopyWithImpl<$Res>
    extends _$PIModelCopyWithImpl<$Res, _$PIModelImpl>
    implements _$$PIModelImplCopyWith<$Res> {
  __$$PIModelImplCopyWithImpl(
      _$PIModelImpl _value, $Res Function(_$PIModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of PIModel
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
    Object? itemCount = null,
  }) {
    return _then(_$PIModelImpl(
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
              as String,
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
              as List<PIItemModel>,
      itemCount: null == itemCount
          ? _value.itemCount
          : itemCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PIModelImpl extends _PIModel {
  const _$PIModelImpl(
      {@JsonKey(name: 'pi_id') required this.piId,
      @JsonKey(name: 'pi_number') required this.piNumber,
      @JsonKey(name: 'company_id') required this.companyId,
      @JsonKey(name: 'store_id') this.storeId,
      @JsonKey(name: 'counterparty_id') this.counterpartyId,
      @JsonKey(name: 'counterparty_name') this.counterpartyName,
      @JsonKey(name: 'counterparty_info')
      final Map<String, dynamic>? counterpartyInfo,
      @JsonKey(name: 'seller_info') final Map<String, dynamic>? sellerInfo,
      @JsonKey(name: 'currency_id') this.currencyId,
      @JsonKey(name: 'currency_code') this.currencyCode = 'USD',
      this.subtotal = 0,
      @JsonKey(name: 'discount_percent') this.discountPercent = 0,
      @JsonKey(name: 'discount_amount') this.discountAmount = 0,
      @JsonKey(name: 'tax_percent') this.taxPercent = 0,
      @JsonKey(name: 'tax_amount') this.taxAmount = 0,
      @JsonKey(name: 'total_amount') this.totalAmount = 0,
      @JsonKey(name: 'incoterms_code') this.incotermsCode,
      @JsonKey(name: 'incoterms_place') this.incotermsPlace,
      @JsonKey(name: 'port_of_loading') this.portOfLoading,
      @JsonKey(name: 'port_of_discharge') this.portOfDischarge,
      @JsonKey(name: 'final_destination') this.finalDestination,
      @JsonKey(name: 'country_of_origin') this.countryOfOrigin,
      @JsonKey(name: 'payment_terms_code') this.paymentTermsCode,
      @JsonKey(name: 'payment_terms_detail') this.paymentTermsDetail,
      @JsonKey(name: 'partial_shipment_allowed')
      this.partialShipmentAllowed = true,
      @JsonKey(name: 'transshipment_allowed') this.transshipmentAllowed = true,
      @JsonKey(name: 'shipping_method_code') this.shippingMethodCode,
      @JsonKey(name: 'estimated_shipment_date') this.estimatedShipmentDate,
      @JsonKey(name: 'lead_time_days') this.leadTimeDays,
      @JsonKey(name: 'validity_date') this.validityDate,
      this.status = 'draft',
      this.version = 1,
      this.notes,
      @JsonKey(name: 'internal_notes') this.internalNotes,
      @JsonKey(name: 'terms_and_conditions') this.termsAndConditions,
      @JsonKey(name: 'created_by') this.createdBy,
      @JsonKey(name: 'created_at_utc') this.createdAtUtc,
      @JsonKey(name: 'updated_at_utc') this.updatedAtUtc,
      final List<PIItemModel> items = const [],
      @JsonKey(name: 'item_count') this.itemCount = 0})
      : _counterpartyInfo = counterpartyInfo,
        _sellerInfo = sellerInfo,
        _items = items,
        super._();

  factory _$PIModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PIModelImplFromJson(json);

  @override
  @JsonKey(name: 'pi_id')
  final String piId;
  @override
  @JsonKey(name: 'pi_number')
  final String piNumber;
  @override
  @JsonKey(name: 'company_id')
  final String companyId;
  @override
  @JsonKey(name: 'store_id')
  final String? storeId;
  @override
  @JsonKey(name: 'counterparty_id')
  final String? counterpartyId;
  @override
  @JsonKey(name: 'counterparty_name')
  final String? counterpartyName;
  final Map<String, dynamic>? _counterpartyInfo;
  @override
  @JsonKey(name: 'counterparty_info')
  Map<String, dynamic>? get counterpartyInfo {
    final value = _counterpartyInfo;
    if (value == null) return null;
    if (_counterpartyInfo is EqualUnmodifiableMapView) return _counterpartyInfo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _sellerInfo;
  @override
  @JsonKey(name: 'seller_info')
  Map<String, dynamic>? get sellerInfo {
    final value = _sellerInfo;
    if (value == null) return null;
    if (_sellerInfo is EqualUnmodifiableMapView) return _sellerInfo;
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
  @JsonKey()
  final double subtotal;
  @override
  @JsonKey(name: 'discount_percent')
  final double discountPercent;
  @override
  @JsonKey(name: 'discount_amount')
  final double discountAmount;
  @override
  @JsonKey(name: 'tax_percent')
  final double taxPercent;
  @override
  @JsonKey(name: 'tax_amount')
  final double taxAmount;
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
  @JsonKey(name: 'port_of_loading')
  final String? portOfLoading;
  @override
  @JsonKey(name: 'port_of_discharge')
  final String? portOfDischarge;
  @override
  @JsonKey(name: 'final_destination')
  final String? finalDestination;
  @override
  @JsonKey(name: 'country_of_origin')
  final String? countryOfOrigin;
  @override
  @JsonKey(name: 'payment_terms_code')
  final String? paymentTermsCode;
  @override
  @JsonKey(name: 'payment_terms_detail')
  final String? paymentTermsDetail;
  @override
  @JsonKey(name: 'partial_shipment_allowed')
  final bool partialShipmentAllowed;
  @override
  @JsonKey(name: 'transshipment_allowed')
  final bool transshipmentAllowed;
  @override
  @JsonKey(name: 'shipping_method_code')
  final String? shippingMethodCode;
  @override
  @JsonKey(name: 'estimated_shipment_date')
  final DateTime? estimatedShipmentDate;
  @override
  @JsonKey(name: 'lead_time_days')
  final int? leadTimeDays;
  @override
  @JsonKey(name: 'validity_date')
  final DateTime? validityDate;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey()
  final int version;
  @override
  final String? notes;
  @override
  @JsonKey(name: 'internal_notes')
  final String? internalNotes;
  @override
  @JsonKey(name: 'terms_and_conditions')
  final String? termsAndConditions;
  @override
  @JsonKey(name: 'created_by')
  final String? createdBy;
  @override
  @JsonKey(name: 'created_at_utc')
  final DateTime? createdAtUtc;
  @override
  @JsonKey(name: 'updated_at_utc')
  final DateTime? updatedAtUtc;
  final List<PIItemModel> _items;
  @override
  @JsonKey()
  List<PIItemModel> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  @JsonKey(name: 'item_count')
  final int itemCount;

  @override
  String toString() {
    return 'PIModel(piId: $piId, piNumber: $piNumber, companyId: $companyId, storeId: $storeId, counterpartyId: $counterpartyId, counterpartyName: $counterpartyName, counterpartyInfo: $counterpartyInfo, sellerInfo: $sellerInfo, currencyId: $currencyId, currencyCode: $currencyCode, subtotal: $subtotal, discountPercent: $discountPercent, discountAmount: $discountAmount, taxPercent: $taxPercent, taxAmount: $taxAmount, totalAmount: $totalAmount, incotermsCode: $incotermsCode, incotermsPlace: $incotermsPlace, portOfLoading: $portOfLoading, portOfDischarge: $portOfDischarge, finalDestination: $finalDestination, countryOfOrigin: $countryOfOrigin, paymentTermsCode: $paymentTermsCode, paymentTermsDetail: $paymentTermsDetail, partialShipmentAllowed: $partialShipmentAllowed, transshipmentAllowed: $transshipmentAllowed, shippingMethodCode: $shippingMethodCode, estimatedShipmentDate: $estimatedShipmentDate, leadTimeDays: $leadTimeDays, validityDate: $validityDate, status: $status, version: $version, notes: $notes, internalNotes: $internalNotes, termsAndConditions: $termsAndConditions, createdBy: $createdBy, createdAtUtc: $createdAtUtc, updatedAtUtc: $updatedAtUtc, items: $items, itemCount: $itemCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PIModelImpl &&
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
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.itemCount, itemCount) ||
                other.itemCount == itemCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
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
        const DeepCollectionEquality().hash(_items),
        itemCount
      ]);

  /// Create a copy of PIModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PIModelImplCopyWith<_$PIModelImpl> get copyWith =>
      __$$PIModelImplCopyWithImpl<_$PIModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PIModelImplToJson(
      this,
    );
  }
}

abstract class _PIModel extends PIModel {
  const factory _PIModel(
      {@JsonKey(name: 'pi_id') required final String piId,
      @JsonKey(name: 'pi_number') required final String piNumber,
      @JsonKey(name: 'company_id') required final String companyId,
      @JsonKey(name: 'store_id') final String? storeId,
      @JsonKey(name: 'counterparty_id') final String? counterpartyId,
      @JsonKey(name: 'counterparty_name') final String? counterpartyName,
      @JsonKey(name: 'counterparty_info')
      final Map<String, dynamic>? counterpartyInfo,
      @JsonKey(name: 'seller_info') final Map<String, dynamic>? sellerInfo,
      @JsonKey(name: 'currency_id') final String? currencyId,
      @JsonKey(name: 'currency_code') final String currencyCode,
      final double subtotal,
      @JsonKey(name: 'discount_percent') final double discountPercent,
      @JsonKey(name: 'discount_amount') final double discountAmount,
      @JsonKey(name: 'tax_percent') final double taxPercent,
      @JsonKey(name: 'tax_amount') final double taxAmount,
      @JsonKey(name: 'total_amount') final double totalAmount,
      @JsonKey(name: 'incoterms_code') final String? incotermsCode,
      @JsonKey(name: 'incoterms_place') final String? incotermsPlace,
      @JsonKey(name: 'port_of_loading') final String? portOfLoading,
      @JsonKey(name: 'port_of_discharge') final String? portOfDischarge,
      @JsonKey(name: 'final_destination') final String? finalDestination,
      @JsonKey(name: 'country_of_origin') final String? countryOfOrigin,
      @JsonKey(name: 'payment_terms_code') final String? paymentTermsCode,
      @JsonKey(name: 'payment_terms_detail') final String? paymentTermsDetail,
      @JsonKey(name: 'partial_shipment_allowed')
      final bool partialShipmentAllowed,
      @JsonKey(name: 'transshipment_allowed') final bool transshipmentAllowed,
      @JsonKey(name: 'shipping_method_code') final String? shippingMethodCode,
      @JsonKey(name: 'estimated_shipment_date')
      final DateTime? estimatedShipmentDate,
      @JsonKey(name: 'lead_time_days') final int? leadTimeDays,
      @JsonKey(name: 'validity_date') final DateTime? validityDate,
      final String status,
      final int version,
      final String? notes,
      @JsonKey(name: 'internal_notes') final String? internalNotes,
      @JsonKey(name: 'terms_and_conditions') final String? termsAndConditions,
      @JsonKey(name: 'created_by') final String? createdBy,
      @JsonKey(name: 'created_at_utc') final DateTime? createdAtUtc,
      @JsonKey(name: 'updated_at_utc') final DateTime? updatedAtUtc,
      final List<PIItemModel> items,
      @JsonKey(name: 'item_count') final int itemCount}) = _$PIModelImpl;
  const _PIModel._() : super._();

  factory _PIModel.fromJson(Map<String, dynamic> json) = _$PIModelImpl.fromJson;

  @override
  @JsonKey(name: 'pi_id')
  String get piId;
  @override
  @JsonKey(name: 'pi_number')
  String get piNumber;
  @override
  @JsonKey(name: 'company_id')
  String get companyId;
  @override
  @JsonKey(name: 'store_id')
  String? get storeId;
  @override
  @JsonKey(name: 'counterparty_id')
  String? get counterpartyId;
  @override
  @JsonKey(name: 'counterparty_name')
  String? get counterpartyName;
  @override
  @JsonKey(name: 'counterparty_info')
  Map<String, dynamic>? get counterpartyInfo;
  @override
  @JsonKey(name: 'seller_info')
  Map<String, dynamic>? get sellerInfo;
  @override
  @JsonKey(name: 'currency_id')
  String? get currencyId;
  @override
  @JsonKey(name: 'currency_code')
  String get currencyCode;
  @override
  double get subtotal;
  @override
  @JsonKey(name: 'discount_percent')
  double get discountPercent;
  @override
  @JsonKey(name: 'discount_amount')
  double get discountAmount;
  @override
  @JsonKey(name: 'tax_percent')
  double get taxPercent;
  @override
  @JsonKey(name: 'tax_amount')
  double get taxAmount;
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
  @JsonKey(name: 'port_of_loading')
  String? get portOfLoading;
  @override
  @JsonKey(name: 'port_of_discharge')
  String? get portOfDischarge;
  @override
  @JsonKey(name: 'final_destination')
  String? get finalDestination;
  @override
  @JsonKey(name: 'country_of_origin')
  String? get countryOfOrigin;
  @override
  @JsonKey(name: 'payment_terms_code')
  String? get paymentTermsCode;
  @override
  @JsonKey(name: 'payment_terms_detail')
  String? get paymentTermsDetail;
  @override
  @JsonKey(name: 'partial_shipment_allowed')
  bool get partialShipmentAllowed;
  @override
  @JsonKey(name: 'transshipment_allowed')
  bool get transshipmentAllowed;
  @override
  @JsonKey(name: 'shipping_method_code')
  String? get shippingMethodCode;
  @override
  @JsonKey(name: 'estimated_shipment_date')
  DateTime? get estimatedShipmentDate;
  @override
  @JsonKey(name: 'lead_time_days')
  int? get leadTimeDays;
  @override
  @JsonKey(name: 'validity_date')
  DateTime? get validityDate;
  @override
  String get status;
  @override
  int get version;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'internal_notes')
  String? get internalNotes;
  @override
  @JsonKey(name: 'terms_and_conditions')
  String? get termsAndConditions;
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
  List<PIItemModel> get items;
  @override
  @JsonKey(name: 'item_count')
  int get itemCount;

  /// Create a copy of PIModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PIModelImplCopyWith<_$PIModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PaginatedPIResponse _$PaginatedPIResponseFromJson(Map<String, dynamic> json) {
  return _PaginatedPIResponse.fromJson(json);
}

/// @nodoc
mixin _$PaginatedPIResponse {
  List<PIModel> get data => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_count')
  int get totalCount => throw _privateConstructorUsedError;
  int get page => throw _privateConstructorUsedError;
  @JsonKey(name: 'page_size')
  int get pageSize => throw _privateConstructorUsedError;
  @JsonKey(name: 'has_more')
  bool get hasMore => throw _privateConstructorUsedError;

  /// Serializes this PaginatedPIResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaginatedPIResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaginatedPIResponseCopyWith<PaginatedPIResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginatedPIResponseCopyWith<$Res> {
  factory $PaginatedPIResponseCopyWith(
          PaginatedPIResponse value, $Res Function(PaginatedPIResponse) then) =
      _$PaginatedPIResponseCopyWithImpl<$Res, PaginatedPIResponse>;
  @useResult
  $Res call(
      {List<PIModel> data,
      @JsonKey(name: 'total_count') int totalCount,
      int page,
      @JsonKey(name: 'page_size') int pageSize,
      @JsonKey(name: 'has_more') bool hasMore});
}

/// @nodoc
class _$PaginatedPIResponseCopyWithImpl<$Res, $Val extends PaginatedPIResponse>
    implements $PaginatedPIResponseCopyWith<$Res> {
  _$PaginatedPIResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaginatedPIResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? totalCount = null,
    Object? page = null,
    Object? pageSize = null,
    Object? hasMore = null,
  }) {
    return _then(_value.copyWith(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<PIModel>,
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      pageSize: null == pageSize
          ? _value.pageSize
          : pageSize // ignore: cast_nullable_to_non_nullable
              as int,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaginatedPIResponseImplCopyWith<$Res>
    implements $PaginatedPIResponseCopyWith<$Res> {
  factory _$$PaginatedPIResponseImplCopyWith(_$PaginatedPIResponseImpl value,
          $Res Function(_$PaginatedPIResponseImpl) then) =
      __$$PaginatedPIResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<PIModel> data,
      @JsonKey(name: 'total_count') int totalCount,
      int page,
      @JsonKey(name: 'page_size') int pageSize,
      @JsonKey(name: 'has_more') bool hasMore});
}

/// @nodoc
class __$$PaginatedPIResponseImplCopyWithImpl<$Res>
    extends _$PaginatedPIResponseCopyWithImpl<$Res, _$PaginatedPIResponseImpl>
    implements _$$PaginatedPIResponseImplCopyWith<$Res> {
  __$$PaginatedPIResponseImplCopyWithImpl(_$PaginatedPIResponseImpl _value,
      $Res Function(_$PaginatedPIResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of PaginatedPIResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? totalCount = null,
    Object? page = null,
    Object? pageSize = null,
    Object? hasMore = null,
  }) {
    return _then(_$PaginatedPIResponseImpl(
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<PIModel>,
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      pageSize: null == pageSize
          ? _value.pageSize
          : pageSize // ignore: cast_nullable_to_non_nullable
              as int,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaginatedPIResponseImpl extends _PaginatedPIResponse {
  const _$PaginatedPIResponseImpl(
      {required final List<PIModel> data,
      @JsonKey(name: 'total_count') required this.totalCount,
      required this.page,
      @JsonKey(name: 'page_size') required this.pageSize,
      @JsonKey(name: 'has_more') required this.hasMore})
      : _data = data,
        super._();

  factory _$PaginatedPIResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaginatedPIResponseImplFromJson(json);

  final List<PIModel> _data;
  @override
  List<PIModel> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  @JsonKey(name: 'total_count')
  final int totalCount;
  @override
  final int page;
  @override
  @JsonKey(name: 'page_size')
  final int pageSize;
  @override
  @JsonKey(name: 'has_more')
  final bool hasMore;

  @override
  String toString() {
    return 'PaginatedPIResponse(data: $data, totalCount: $totalCount, page: $page, pageSize: $pageSize, hasMore: $hasMore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaginatedPIResponseImpl &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.pageSize, pageSize) ||
                other.pageSize == pageSize) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_data),
      totalCount,
      page,
      pageSize,
      hasMore);

  /// Create a copy of PaginatedPIResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaginatedPIResponseImplCopyWith<_$PaginatedPIResponseImpl> get copyWith =>
      __$$PaginatedPIResponseImplCopyWithImpl<_$PaginatedPIResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaginatedPIResponseImplToJson(
      this,
    );
  }
}

abstract class _PaginatedPIResponse extends PaginatedPIResponse {
  const factory _PaginatedPIResponse(
          {required final List<PIModel> data,
          @JsonKey(name: 'total_count') required final int totalCount,
          required final int page,
          @JsonKey(name: 'page_size') required final int pageSize,
          @JsonKey(name: 'has_more') required final bool hasMore}) =
      _$PaginatedPIResponseImpl;
  const _PaginatedPIResponse._() : super._();

  factory _PaginatedPIResponse.fromJson(Map<String, dynamic> json) =
      _$PaginatedPIResponseImpl.fromJson;

  @override
  List<PIModel> get data;
  @override
  @JsonKey(name: 'total_count')
  int get totalCount;
  @override
  int get page;
  @override
  @JsonKey(name: 'page_size')
  int get pageSize;
  @override
  @JsonKey(name: 'has_more')
  bool get hasMore;

  /// Create a copy of PaginatedPIResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaginatedPIResponseImplCopyWith<_$PaginatedPIResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
