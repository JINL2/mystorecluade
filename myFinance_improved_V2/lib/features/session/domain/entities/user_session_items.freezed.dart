// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_session_items.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$UserSessionItem {
  String get itemId => throw _privateConstructorUsedError;
  String get productId => throw _privateConstructorUsedError;
  String get productName => throw _privateConstructorUsedError;
  String? get sku => throw _privateConstructorUsedError;
  List<String>? get imageUrls => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  int get quantityRejected => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String get createdAt =>
      throw _privateConstructorUsedError; // v6 variant fields
  String? get variantId => throw _privateConstructorUsedError;
  String? get displayName => throw _privateConstructorUsedError;

  /// Create a copy of UserSessionItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserSessionItemCopyWith<UserSessionItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserSessionItemCopyWith<$Res> {
  factory $UserSessionItemCopyWith(
          UserSessionItem value, $Res Function(UserSessionItem) then) =
      _$UserSessionItemCopyWithImpl<$Res, UserSessionItem>;
  @useResult
  $Res call(
      {String itemId,
      String productId,
      String productName,
      String? sku,
      List<String>? imageUrls,
      int quantity,
      int quantityRejected,
      String? notes,
      String createdAt,
      String? variantId,
      String? displayName});
}

/// @nodoc
class _$UserSessionItemCopyWithImpl<$Res, $Val extends UserSessionItem>
    implements $UserSessionItemCopyWith<$Res> {
  _$UserSessionItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserSessionItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? itemId = null,
    Object? productId = null,
    Object? productName = null,
    Object? sku = freezed,
    Object? imageUrls = freezed,
    Object? quantity = null,
    Object? quantityRejected = null,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? variantId = freezed,
    Object? displayName = freezed,
  }) {
    return _then(_value.copyWith(
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
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
      imageUrls: freezed == imageUrls
          ? _value.imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      quantityRejected: null == quantityRejected
          ? _value.quantityRejected
          : quantityRejected // ignore: cast_nullable_to_non_nullable
              as int,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      variantId: freezed == variantId
          ? _value.variantId
          : variantId // ignore: cast_nullable_to_non_nullable
              as String?,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserSessionItemImplCopyWith<$Res>
    implements $UserSessionItemCopyWith<$Res> {
  factory _$$UserSessionItemImplCopyWith(_$UserSessionItemImpl value,
          $Res Function(_$UserSessionItemImpl) then) =
      __$$UserSessionItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String itemId,
      String productId,
      String productName,
      String? sku,
      List<String>? imageUrls,
      int quantity,
      int quantityRejected,
      String? notes,
      String createdAt,
      String? variantId,
      String? displayName});
}

/// @nodoc
class __$$UserSessionItemImplCopyWithImpl<$Res>
    extends _$UserSessionItemCopyWithImpl<$Res, _$UserSessionItemImpl>
    implements _$$UserSessionItemImplCopyWith<$Res> {
  __$$UserSessionItemImplCopyWithImpl(
      _$UserSessionItemImpl _value, $Res Function(_$UserSessionItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserSessionItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? itemId = null,
    Object? productId = null,
    Object? productName = null,
    Object? sku = freezed,
    Object? imageUrls = freezed,
    Object? quantity = null,
    Object? quantityRejected = null,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? variantId = freezed,
    Object? displayName = freezed,
  }) {
    return _then(_$UserSessionItemImpl(
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
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
      imageUrls: freezed == imageUrls
          ? _value._imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      quantityRejected: null == quantityRejected
          ? _value.quantityRejected
          : quantityRejected // ignore: cast_nullable_to_non_nullable
              as int,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      variantId: freezed == variantId
          ? _value.variantId
          : variantId // ignore: cast_nullable_to_non_nullable
              as String?,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$UserSessionItemImpl extends _UserSessionItem {
  const _$UserSessionItemImpl(
      {required this.itemId,
      required this.productId,
      required this.productName,
      this.sku,
      final List<String>? imageUrls,
      required this.quantity,
      required this.quantityRejected,
      this.notes,
      required this.createdAt,
      this.variantId,
      this.displayName})
      : _imageUrls = imageUrls,
        super._();

  @override
  final String itemId;
  @override
  final String productId;
  @override
  final String productName;
  @override
  final String? sku;
  final List<String>? _imageUrls;
  @override
  List<String>? get imageUrls {
    final value = _imageUrls;
    if (value == null) return null;
    if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final int quantity;
  @override
  final int quantityRejected;
  @override
  final String? notes;
  @override
  final String createdAt;
// v6 variant fields
  @override
  final String? variantId;
  @override
  final String? displayName;

  @override
  String toString() {
    return 'UserSessionItem(itemId: $itemId, productId: $productId, productName: $productName, sku: $sku, imageUrls: $imageUrls, quantity: $quantity, quantityRejected: $quantityRejected, notes: $notes, createdAt: $createdAt, variantId: $variantId, displayName: $displayName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserSessionItemImpl &&
            (identical(other.itemId, itemId) || other.itemId == itemId) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            const DeepCollectionEquality()
                .equals(other._imageUrls, _imageUrls) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.quantityRejected, quantityRejected) ||
                other.quantityRejected == quantityRejected) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.variantId, variantId) ||
                other.variantId == variantId) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      itemId,
      productId,
      productName,
      sku,
      const DeepCollectionEquality().hash(_imageUrls),
      quantity,
      quantityRejected,
      notes,
      createdAt,
      variantId,
      displayName);

  /// Create a copy of UserSessionItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserSessionItemImplCopyWith<_$UserSessionItemImpl> get copyWith =>
      __$$UserSessionItemImplCopyWithImpl<_$UserSessionItemImpl>(
          this, _$identity);
}

abstract class _UserSessionItem extends UserSessionItem {
  const factory _UserSessionItem(
      {required final String itemId,
      required final String productId,
      required final String productName,
      final String? sku,
      final List<String>? imageUrls,
      required final int quantity,
      required final int quantityRejected,
      final String? notes,
      required final String createdAt,
      final String? variantId,
      final String? displayName}) = _$UserSessionItemImpl;
  const _UserSessionItem._() : super._();

  @override
  String get itemId;
  @override
  String get productId;
  @override
  String get productName;
  @override
  String? get sku;
  @override
  List<String>? get imageUrls;
  @override
  int get quantity;
  @override
  int get quantityRejected;
  @override
  String? get notes;
  @override
  String get createdAt; // v6 variant fields
  @override
  String? get variantId;
  @override
  String? get displayName;

  /// Create a copy of UserSessionItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserSessionItemImplCopyWith<_$UserSessionItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$UserSessionItemsSummary {
  int get totalItems => throw _privateConstructorUsedError;
  int get totalProducts => throw _privateConstructorUsedError;
  int get totalQuantity => throw _privateConstructorUsedError;
  int get totalRejected => throw _privateConstructorUsedError;

  /// Create a copy of UserSessionItemsSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserSessionItemsSummaryCopyWith<UserSessionItemsSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserSessionItemsSummaryCopyWith<$Res> {
  factory $UserSessionItemsSummaryCopyWith(UserSessionItemsSummary value,
          $Res Function(UserSessionItemsSummary) then) =
      _$UserSessionItemsSummaryCopyWithImpl<$Res, UserSessionItemsSummary>;
  @useResult
  $Res call(
      {int totalItems,
      int totalProducts,
      int totalQuantity,
      int totalRejected});
}

/// @nodoc
class _$UserSessionItemsSummaryCopyWithImpl<$Res,
        $Val extends UserSessionItemsSummary>
    implements $UserSessionItemsSummaryCopyWith<$Res> {
  _$UserSessionItemsSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserSessionItemsSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalItems = null,
    Object? totalProducts = null,
    Object? totalQuantity = null,
    Object? totalRejected = null,
  }) {
    return _then(_value.copyWith(
      totalItems: null == totalItems
          ? _value.totalItems
          : totalItems // ignore: cast_nullable_to_non_nullable
              as int,
      totalProducts: null == totalProducts
          ? _value.totalProducts
          : totalProducts // ignore: cast_nullable_to_non_nullable
              as int,
      totalQuantity: null == totalQuantity
          ? _value.totalQuantity
          : totalQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      totalRejected: null == totalRejected
          ? _value.totalRejected
          : totalRejected // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserSessionItemsSummaryImplCopyWith<$Res>
    implements $UserSessionItemsSummaryCopyWith<$Res> {
  factory _$$UserSessionItemsSummaryImplCopyWith(
          _$UserSessionItemsSummaryImpl value,
          $Res Function(_$UserSessionItemsSummaryImpl) then) =
      __$$UserSessionItemsSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int totalItems,
      int totalProducts,
      int totalQuantity,
      int totalRejected});
}

/// @nodoc
class __$$UserSessionItemsSummaryImplCopyWithImpl<$Res>
    extends _$UserSessionItemsSummaryCopyWithImpl<$Res,
        _$UserSessionItemsSummaryImpl>
    implements _$$UserSessionItemsSummaryImplCopyWith<$Res> {
  __$$UserSessionItemsSummaryImplCopyWithImpl(
      _$UserSessionItemsSummaryImpl _value,
      $Res Function(_$UserSessionItemsSummaryImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserSessionItemsSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalItems = null,
    Object? totalProducts = null,
    Object? totalQuantity = null,
    Object? totalRejected = null,
  }) {
    return _then(_$UserSessionItemsSummaryImpl(
      totalItems: null == totalItems
          ? _value.totalItems
          : totalItems // ignore: cast_nullable_to_non_nullable
              as int,
      totalProducts: null == totalProducts
          ? _value.totalProducts
          : totalProducts // ignore: cast_nullable_to_non_nullable
              as int,
      totalQuantity: null == totalQuantity
          ? _value.totalQuantity
          : totalQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      totalRejected: null == totalRejected
          ? _value.totalRejected
          : totalRejected // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$UserSessionItemsSummaryImpl implements _UserSessionItemsSummary {
  const _$UserSessionItemsSummaryImpl(
      {required this.totalItems,
      required this.totalProducts,
      required this.totalQuantity,
      required this.totalRejected});

  @override
  final int totalItems;
  @override
  final int totalProducts;
  @override
  final int totalQuantity;
  @override
  final int totalRejected;

  @override
  String toString() {
    return 'UserSessionItemsSummary(totalItems: $totalItems, totalProducts: $totalProducts, totalQuantity: $totalQuantity, totalRejected: $totalRejected)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserSessionItemsSummaryImpl &&
            (identical(other.totalItems, totalItems) ||
                other.totalItems == totalItems) &&
            (identical(other.totalProducts, totalProducts) ||
                other.totalProducts == totalProducts) &&
            (identical(other.totalQuantity, totalQuantity) ||
                other.totalQuantity == totalQuantity) &&
            (identical(other.totalRejected, totalRejected) ||
                other.totalRejected == totalRejected));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, totalItems, totalProducts, totalQuantity, totalRejected);

  /// Create a copy of UserSessionItemsSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserSessionItemsSummaryImplCopyWith<_$UserSessionItemsSummaryImpl>
      get copyWith => __$$UserSessionItemsSummaryImplCopyWithImpl<
          _$UserSessionItemsSummaryImpl>(this, _$identity);
}

abstract class _UserSessionItemsSummary implements UserSessionItemsSummary {
  const factory _UserSessionItemsSummary(
      {required final int totalItems,
      required final int totalProducts,
      required final int totalQuantity,
      required final int totalRejected}) = _$UserSessionItemsSummaryImpl;

  @override
  int get totalItems;
  @override
  int get totalProducts;
  @override
  int get totalQuantity;
  @override
  int get totalRejected;

  /// Create a copy of UserSessionItemsSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserSessionItemsSummaryImplCopyWith<_$UserSessionItemsSummaryImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AggregatedUserSessionItem {
  String get productId => throw _privateConstructorUsedError;
  String get productName => throw _privateConstructorUsedError;
  String? get sku => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  int get totalQuantity => throw _privateConstructorUsedError;
  int get totalRejected => throw _privateConstructorUsedError;
  List<String> get itemIds =>
      throw _privateConstructorUsedError; // v6 variant fields
  String? get variantId => throw _privateConstructorUsedError;
  String? get displayName => throw _privateConstructorUsedError;

  /// Create a copy of AggregatedUserSessionItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AggregatedUserSessionItemCopyWith<AggregatedUserSessionItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AggregatedUserSessionItemCopyWith<$Res> {
  factory $AggregatedUserSessionItemCopyWith(AggregatedUserSessionItem value,
          $Res Function(AggregatedUserSessionItem) then) =
      _$AggregatedUserSessionItemCopyWithImpl<$Res, AggregatedUserSessionItem>;
  @useResult
  $Res call(
      {String productId,
      String productName,
      String? sku,
      String? imageUrl,
      int totalQuantity,
      int totalRejected,
      List<String> itemIds,
      String? variantId,
      String? displayName});
}

/// @nodoc
class _$AggregatedUserSessionItemCopyWithImpl<$Res,
        $Val extends AggregatedUserSessionItem>
    implements $AggregatedUserSessionItemCopyWith<$Res> {
  _$AggregatedUserSessionItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AggregatedUserSessionItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? productName = null,
    Object? sku = freezed,
    Object? imageUrl = freezed,
    Object? totalQuantity = null,
    Object? totalRejected = null,
    Object? itemIds = null,
    Object? variantId = freezed,
    Object? displayName = freezed,
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
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      totalQuantity: null == totalQuantity
          ? _value.totalQuantity
          : totalQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      totalRejected: null == totalRejected
          ? _value.totalRejected
          : totalRejected // ignore: cast_nullable_to_non_nullable
              as int,
      itemIds: null == itemIds
          ? _value.itemIds
          : itemIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      variantId: freezed == variantId
          ? _value.variantId
          : variantId // ignore: cast_nullable_to_non_nullable
              as String?,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AggregatedUserSessionItemImplCopyWith<$Res>
    implements $AggregatedUserSessionItemCopyWith<$Res> {
  factory _$$AggregatedUserSessionItemImplCopyWith(
          _$AggregatedUserSessionItemImpl value,
          $Res Function(_$AggregatedUserSessionItemImpl) then) =
      __$$AggregatedUserSessionItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String productId,
      String productName,
      String? sku,
      String? imageUrl,
      int totalQuantity,
      int totalRejected,
      List<String> itemIds,
      String? variantId,
      String? displayName});
}

/// @nodoc
class __$$AggregatedUserSessionItemImplCopyWithImpl<$Res>
    extends _$AggregatedUserSessionItemCopyWithImpl<$Res,
        _$AggregatedUserSessionItemImpl>
    implements _$$AggregatedUserSessionItemImplCopyWith<$Res> {
  __$$AggregatedUserSessionItemImplCopyWithImpl(
      _$AggregatedUserSessionItemImpl _value,
      $Res Function(_$AggregatedUserSessionItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of AggregatedUserSessionItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? productName = null,
    Object? sku = freezed,
    Object? imageUrl = freezed,
    Object? totalQuantity = null,
    Object? totalRejected = null,
    Object? itemIds = null,
    Object? variantId = freezed,
    Object? displayName = freezed,
  }) {
    return _then(_$AggregatedUserSessionItemImpl(
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
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      totalQuantity: null == totalQuantity
          ? _value.totalQuantity
          : totalQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      totalRejected: null == totalRejected
          ? _value.totalRejected
          : totalRejected // ignore: cast_nullable_to_non_nullable
              as int,
      itemIds: null == itemIds
          ? _value._itemIds
          : itemIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      variantId: freezed == variantId
          ? _value.variantId
          : variantId // ignore: cast_nullable_to_non_nullable
              as String?,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$AggregatedUserSessionItemImpl implements _AggregatedUserSessionItem {
  const _$AggregatedUserSessionItemImpl(
      {required this.productId,
      required this.productName,
      this.sku,
      this.imageUrl,
      required this.totalQuantity,
      required this.totalRejected,
      required final List<String> itemIds,
      this.variantId,
      this.displayName})
      : _itemIds = itemIds;

  @override
  final String productId;
  @override
  final String productName;
  @override
  final String? sku;
  @override
  final String? imageUrl;
  @override
  final int totalQuantity;
  @override
  final int totalRejected;
  final List<String> _itemIds;
  @override
  List<String> get itemIds {
    if (_itemIds is EqualUnmodifiableListView) return _itemIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_itemIds);
  }

// v6 variant fields
  @override
  final String? variantId;
  @override
  final String? displayName;

  @override
  String toString() {
    return 'AggregatedUserSessionItem(productId: $productId, productName: $productName, sku: $sku, imageUrl: $imageUrl, totalQuantity: $totalQuantity, totalRejected: $totalRejected, itemIds: $itemIds, variantId: $variantId, displayName: $displayName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AggregatedUserSessionItemImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.totalQuantity, totalQuantity) ||
                other.totalQuantity == totalQuantity) &&
            (identical(other.totalRejected, totalRejected) ||
                other.totalRejected == totalRejected) &&
            const DeepCollectionEquality().equals(other._itemIds, _itemIds) &&
            (identical(other.variantId, variantId) ||
                other.variantId == variantId) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      productId,
      productName,
      sku,
      imageUrl,
      totalQuantity,
      totalRejected,
      const DeepCollectionEquality().hash(_itemIds),
      variantId,
      displayName);

  /// Create a copy of AggregatedUserSessionItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AggregatedUserSessionItemImplCopyWith<_$AggregatedUserSessionItemImpl>
      get copyWith => __$$AggregatedUserSessionItemImplCopyWithImpl<
          _$AggregatedUserSessionItemImpl>(this, _$identity);
}

abstract class _AggregatedUserSessionItem implements AggregatedUserSessionItem {
  const factory _AggregatedUserSessionItem(
      {required final String productId,
      required final String productName,
      final String? sku,
      final String? imageUrl,
      required final int totalQuantity,
      required final int totalRejected,
      required final List<String> itemIds,
      final String? variantId,
      final String? displayName}) = _$AggregatedUserSessionItemImpl;

  @override
  String get productId;
  @override
  String get productName;
  @override
  String? get sku;
  @override
  String? get imageUrl;
  @override
  int get totalQuantity;
  @override
  int get totalRejected;
  @override
  List<String> get itemIds; // v6 variant fields
  @override
  String? get variantId;
  @override
  String? get displayName;

  /// Create a copy of AggregatedUserSessionItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AggregatedUserSessionItemImplCopyWith<_$AggregatedUserSessionItemImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$UserSessionItemsResponse {
  String get sessionId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  List<UserSessionItem> get items => throw _privateConstructorUsedError;
  UserSessionItemsSummary get summary => throw _privateConstructorUsedError;

  /// Create a copy of UserSessionItemsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserSessionItemsResponseCopyWith<UserSessionItemsResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserSessionItemsResponseCopyWith<$Res> {
  factory $UserSessionItemsResponseCopyWith(UserSessionItemsResponse value,
          $Res Function(UserSessionItemsResponse) then) =
      _$UserSessionItemsResponseCopyWithImpl<$Res, UserSessionItemsResponse>;
  @useResult
  $Res call(
      {String sessionId,
      String userId,
      List<UserSessionItem> items,
      UserSessionItemsSummary summary});

  $UserSessionItemsSummaryCopyWith<$Res> get summary;
}

/// @nodoc
class _$UserSessionItemsResponseCopyWithImpl<$Res,
        $Val extends UserSessionItemsResponse>
    implements $UserSessionItemsResponseCopyWith<$Res> {
  _$UserSessionItemsResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserSessionItemsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? userId = null,
    Object? items = null,
    Object? summary = null,
  }) {
    return _then(_value.copyWith(
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<UserSessionItem>,
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as UserSessionItemsSummary,
    ) as $Val);
  }

  /// Create a copy of UserSessionItemsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserSessionItemsSummaryCopyWith<$Res> get summary {
    return $UserSessionItemsSummaryCopyWith<$Res>(_value.summary, (value) {
      return _then(_value.copyWith(summary: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserSessionItemsResponseImplCopyWith<$Res>
    implements $UserSessionItemsResponseCopyWith<$Res> {
  factory _$$UserSessionItemsResponseImplCopyWith(
          _$UserSessionItemsResponseImpl value,
          $Res Function(_$UserSessionItemsResponseImpl) then) =
      __$$UserSessionItemsResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String sessionId,
      String userId,
      List<UserSessionItem> items,
      UserSessionItemsSummary summary});

  @override
  $UserSessionItemsSummaryCopyWith<$Res> get summary;
}

/// @nodoc
class __$$UserSessionItemsResponseImplCopyWithImpl<$Res>
    extends _$UserSessionItemsResponseCopyWithImpl<$Res,
        _$UserSessionItemsResponseImpl>
    implements _$$UserSessionItemsResponseImplCopyWith<$Res> {
  __$$UserSessionItemsResponseImplCopyWithImpl(
      _$UserSessionItemsResponseImpl _value,
      $Res Function(_$UserSessionItemsResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserSessionItemsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? userId = null,
    Object? items = null,
    Object? summary = null,
  }) {
    return _then(_$UserSessionItemsResponseImpl(
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<UserSessionItem>,
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as UserSessionItemsSummary,
    ));
  }
}

/// @nodoc

class _$UserSessionItemsResponseImpl extends _UserSessionItemsResponse {
  const _$UserSessionItemsResponseImpl(
      {required this.sessionId,
      required this.userId,
      required final List<UserSessionItem> items,
      required this.summary})
      : _items = items,
        super._();

  @override
  final String sessionId;
  @override
  final String userId;
  final List<UserSessionItem> _items;
  @override
  List<UserSessionItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final UserSessionItemsSummary summary;

  @override
  String toString() {
    return 'UserSessionItemsResponse(sessionId: $sessionId, userId: $userId, items: $items, summary: $summary)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserSessionItemsResponseImpl &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.summary, summary) || other.summary == summary));
  }

  @override
  int get hashCode => Object.hash(runtimeType, sessionId, userId,
      const DeepCollectionEquality().hash(_items), summary);

  /// Create a copy of UserSessionItemsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserSessionItemsResponseImplCopyWith<_$UserSessionItemsResponseImpl>
      get copyWith => __$$UserSessionItemsResponseImplCopyWithImpl<
          _$UserSessionItemsResponseImpl>(this, _$identity);
}

abstract class _UserSessionItemsResponse extends UserSessionItemsResponse {
  const factory _UserSessionItemsResponse(
          {required final String sessionId,
          required final String userId,
          required final List<UserSessionItem> items,
          required final UserSessionItemsSummary summary}) =
      _$UserSessionItemsResponseImpl;
  const _UserSessionItemsResponse._() : super._();

  @override
  String get sessionId;
  @override
  String get userId;
  @override
  List<UserSessionItem> get items;
  @override
  UserSessionItemsSummary get summary;

  /// Create a copy of UserSessionItemsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserSessionItemsResponseImplCopyWith<_$UserSessionItemsResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
