// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_review_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ScannedByUser {
  String get userId => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  int get quantityRejected => throw _privateConstructorUsedError;

  /// Create a copy of ScannedByUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScannedByUserCopyWith<ScannedByUser> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScannedByUserCopyWith<$Res> {
  factory $ScannedByUserCopyWith(
          ScannedByUser value, $Res Function(ScannedByUser) then) =
      _$ScannedByUserCopyWithImpl<$Res, ScannedByUser>;
  @useResult
  $Res call(
      {String userId, String userName, int quantity, int quantityRejected});
}

/// @nodoc
class _$ScannedByUserCopyWithImpl<$Res, $Val extends ScannedByUser>
    implements $ScannedByUserCopyWith<$Res> {
  _$ScannedByUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScannedByUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? userName = null,
    Object? quantity = null,
    Object? quantityRejected = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      quantityRejected: null == quantityRejected
          ? _value.quantityRejected
          : quantityRejected // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScannedByUserImplCopyWith<$Res>
    implements $ScannedByUserCopyWith<$Res> {
  factory _$$ScannedByUserImplCopyWith(
          _$ScannedByUserImpl value, $Res Function(_$ScannedByUserImpl) then) =
      __$$ScannedByUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId, String userName, int quantity, int quantityRejected});
}

/// @nodoc
class __$$ScannedByUserImplCopyWithImpl<$Res>
    extends _$ScannedByUserCopyWithImpl<$Res, _$ScannedByUserImpl>
    implements _$$ScannedByUserImplCopyWith<$Res> {
  __$$ScannedByUserImplCopyWithImpl(
      _$ScannedByUserImpl _value, $Res Function(_$ScannedByUserImpl) _then)
      : super(_value, _then);

  /// Create a copy of ScannedByUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? userName = null,
    Object? quantity = null,
    Object? quantityRejected = null,
  }) {
    return _then(_$ScannedByUserImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      quantityRejected: null == quantityRejected
          ? _value.quantityRejected
          : quantityRejected // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$ScannedByUserImpl implements _ScannedByUser {
  const _$ScannedByUserImpl(
      {required this.userId,
      required this.userName,
      required this.quantity,
      required this.quantityRejected});

  @override
  final String userId;
  @override
  final String userName;
  @override
  final int quantity;
  @override
  final int quantityRejected;

  @override
  String toString() {
    return 'ScannedByUser(userId: $userId, userName: $userName, quantity: $quantity, quantityRejected: $quantityRejected)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScannedByUserImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.quantityRejected, quantityRejected) ||
                other.quantityRejected == quantityRejected));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, userId, userName, quantity, quantityRejected);

  /// Create a copy of ScannedByUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScannedByUserImplCopyWith<_$ScannedByUserImpl> get copyWith =>
      __$$ScannedByUserImplCopyWithImpl<_$ScannedByUserImpl>(this, _$identity);
}

abstract class _ScannedByUser implements ScannedByUser {
  const factory _ScannedByUser(
      {required final String userId,
      required final String userName,
      required final int quantity,
      required final int quantityRejected}) = _$ScannedByUserImpl;

  @override
  String get userId;
  @override
  String get userName;
  @override
  int get quantity;
  @override
  int get quantityRejected;

  /// Create a copy of ScannedByUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScannedByUserImplCopyWith<_$ScannedByUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SessionReviewItem {
  String get productId => throw _privateConstructorUsedError;
  String get productName => throw _privateConstructorUsedError;
  String? get sku => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get brand => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  int get totalQuantity => throw _privateConstructorUsedError;
  int get totalRejected => throw _privateConstructorUsedError;
  int get previousStock => throw _privateConstructorUsedError;
  List<ScannedByUser> get scannedBy => throw _privateConstructorUsedError;

  /// Session type: 'counting' or 'receiving'
  /// Used to calculate newStock and stockChange differently
  String get sessionType =>
      throw _privateConstructorUsedError; // v2 variant fields
  String? get variantId => throw _privateConstructorUsedError;
  String? get variantName => throw _privateConstructorUsedError;
  String? get displayName => throw _privateConstructorUsedError;
  String? get variantSku => throw _privateConstructorUsedError;
  String? get displaySku => throw _privateConstructorUsedError;
  bool get hasVariants => throw _privateConstructorUsedError;

  /// Create a copy of SessionReviewItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionReviewItemCopyWith<SessionReviewItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionReviewItemCopyWith<$Res> {
  factory $SessionReviewItemCopyWith(
          SessionReviewItem value, $Res Function(SessionReviewItem) then) =
      _$SessionReviewItemCopyWithImpl<$Res, SessionReviewItem>;
  @useResult
  $Res call(
      {String productId,
      String productName,
      String? sku,
      String? imageUrl,
      String? brand,
      String? category,
      int totalQuantity,
      int totalRejected,
      int previousStock,
      List<ScannedByUser> scannedBy,
      String sessionType,
      String? variantId,
      String? variantName,
      String? displayName,
      String? variantSku,
      String? displaySku,
      bool hasVariants});
}

/// @nodoc
class _$SessionReviewItemCopyWithImpl<$Res, $Val extends SessionReviewItem>
    implements $SessionReviewItemCopyWith<$Res> {
  _$SessionReviewItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SessionReviewItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? productName = null,
    Object? sku = freezed,
    Object? imageUrl = freezed,
    Object? brand = freezed,
    Object? category = freezed,
    Object? totalQuantity = null,
    Object? totalRejected = null,
    Object? previousStock = null,
    Object? scannedBy = null,
    Object? sessionType = null,
    Object? variantId = freezed,
    Object? variantName = freezed,
    Object? displayName = freezed,
    Object? variantSku = freezed,
    Object? displaySku = freezed,
    Object? hasVariants = null,
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
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      totalQuantity: null == totalQuantity
          ? _value.totalQuantity
          : totalQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      totalRejected: null == totalRejected
          ? _value.totalRejected
          : totalRejected // ignore: cast_nullable_to_non_nullable
              as int,
      previousStock: null == previousStock
          ? _value.previousStock
          : previousStock // ignore: cast_nullable_to_non_nullable
              as int,
      scannedBy: null == scannedBy
          ? _value.scannedBy
          : scannedBy // ignore: cast_nullable_to_non_nullable
              as List<ScannedByUser>,
      sessionType: null == sessionType
          ? _value.sessionType
          : sessionType // ignore: cast_nullable_to_non_nullable
              as String,
      variantId: freezed == variantId
          ? _value.variantId
          : variantId // ignore: cast_nullable_to_non_nullable
              as String?,
      variantName: freezed == variantName
          ? _value.variantName
          : variantName // ignore: cast_nullable_to_non_nullable
              as String?,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      variantSku: freezed == variantSku
          ? _value.variantSku
          : variantSku // ignore: cast_nullable_to_non_nullable
              as String?,
      displaySku: freezed == displaySku
          ? _value.displaySku
          : displaySku // ignore: cast_nullable_to_non_nullable
              as String?,
      hasVariants: null == hasVariants
          ? _value.hasVariants
          : hasVariants // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SessionReviewItemImplCopyWith<$Res>
    implements $SessionReviewItemCopyWith<$Res> {
  factory _$$SessionReviewItemImplCopyWith(_$SessionReviewItemImpl value,
          $Res Function(_$SessionReviewItemImpl) then) =
      __$$SessionReviewItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String productId,
      String productName,
      String? sku,
      String? imageUrl,
      String? brand,
      String? category,
      int totalQuantity,
      int totalRejected,
      int previousStock,
      List<ScannedByUser> scannedBy,
      String sessionType,
      String? variantId,
      String? variantName,
      String? displayName,
      String? variantSku,
      String? displaySku,
      bool hasVariants});
}

/// @nodoc
class __$$SessionReviewItemImplCopyWithImpl<$Res>
    extends _$SessionReviewItemCopyWithImpl<$Res, _$SessionReviewItemImpl>
    implements _$$SessionReviewItemImplCopyWith<$Res> {
  __$$SessionReviewItemImplCopyWithImpl(_$SessionReviewItemImpl _value,
      $Res Function(_$SessionReviewItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of SessionReviewItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? productName = null,
    Object? sku = freezed,
    Object? imageUrl = freezed,
    Object? brand = freezed,
    Object? category = freezed,
    Object? totalQuantity = null,
    Object? totalRejected = null,
    Object? previousStock = null,
    Object? scannedBy = null,
    Object? sessionType = null,
    Object? variantId = freezed,
    Object? variantName = freezed,
    Object? displayName = freezed,
    Object? variantSku = freezed,
    Object? displaySku = freezed,
    Object? hasVariants = null,
  }) {
    return _then(_$SessionReviewItemImpl(
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
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      totalQuantity: null == totalQuantity
          ? _value.totalQuantity
          : totalQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      totalRejected: null == totalRejected
          ? _value.totalRejected
          : totalRejected // ignore: cast_nullable_to_non_nullable
              as int,
      previousStock: null == previousStock
          ? _value.previousStock
          : previousStock // ignore: cast_nullable_to_non_nullable
              as int,
      scannedBy: null == scannedBy
          ? _value._scannedBy
          : scannedBy // ignore: cast_nullable_to_non_nullable
              as List<ScannedByUser>,
      sessionType: null == sessionType
          ? _value.sessionType
          : sessionType // ignore: cast_nullable_to_non_nullable
              as String,
      variantId: freezed == variantId
          ? _value.variantId
          : variantId // ignore: cast_nullable_to_non_nullable
              as String?,
      variantName: freezed == variantName
          ? _value.variantName
          : variantName // ignore: cast_nullable_to_non_nullable
              as String?,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      variantSku: freezed == variantSku
          ? _value.variantSku
          : variantSku // ignore: cast_nullable_to_non_nullable
              as String?,
      displaySku: freezed == displaySku
          ? _value.displaySku
          : displaySku // ignore: cast_nullable_to_non_nullable
              as String?,
      hasVariants: null == hasVariants
          ? _value.hasVariants
          : hasVariants // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$SessionReviewItemImpl extends _SessionReviewItem {
  const _$SessionReviewItemImpl(
      {required this.productId,
      required this.productName,
      this.sku,
      this.imageUrl,
      this.brand,
      this.category,
      required this.totalQuantity,
      required this.totalRejected,
      this.previousStock = 0,
      required final List<ScannedByUser> scannedBy,
      this.sessionType = 'receiving',
      this.variantId,
      this.variantName,
      this.displayName,
      this.variantSku,
      this.displaySku,
      this.hasVariants = false})
      : _scannedBy = scannedBy,
        super._();

  @override
  final String productId;
  @override
  final String productName;
  @override
  final String? sku;
  @override
  final String? imageUrl;
  @override
  final String? brand;
  @override
  final String? category;
  @override
  final int totalQuantity;
  @override
  final int totalRejected;
  @override
  @JsonKey()
  final int previousStock;
  final List<ScannedByUser> _scannedBy;
  @override
  List<ScannedByUser> get scannedBy {
    if (_scannedBy is EqualUnmodifiableListView) return _scannedBy;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_scannedBy);
  }

  /// Session type: 'counting' or 'receiving'
  /// Used to calculate newStock and stockChange differently
  @override
  @JsonKey()
  final String sessionType;
// v2 variant fields
  @override
  final String? variantId;
  @override
  final String? variantName;
  @override
  final String? displayName;
  @override
  final String? variantSku;
  @override
  final String? displaySku;
  @override
  @JsonKey()
  final bool hasVariants;

  @override
  String toString() {
    return 'SessionReviewItem(productId: $productId, productName: $productName, sku: $sku, imageUrl: $imageUrl, brand: $brand, category: $category, totalQuantity: $totalQuantity, totalRejected: $totalRejected, previousStock: $previousStock, scannedBy: $scannedBy, sessionType: $sessionType, variantId: $variantId, variantName: $variantName, displayName: $displayName, variantSku: $variantSku, displaySku: $displaySku, hasVariants: $hasVariants)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionReviewItemImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.totalQuantity, totalQuantity) ||
                other.totalQuantity == totalQuantity) &&
            (identical(other.totalRejected, totalRejected) ||
                other.totalRejected == totalRejected) &&
            (identical(other.previousStock, previousStock) ||
                other.previousStock == previousStock) &&
            const DeepCollectionEquality()
                .equals(other._scannedBy, _scannedBy) &&
            (identical(other.sessionType, sessionType) ||
                other.sessionType == sessionType) &&
            (identical(other.variantId, variantId) ||
                other.variantId == variantId) &&
            (identical(other.variantName, variantName) ||
                other.variantName == variantName) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.variantSku, variantSku) ||
                other.variantSku == variantSku) &&
            (identical(other.displaySku, displaySku) ||
                other.displaySku == displaySku) &&
            (identical(other.hasVariants, hasVariants) ||
                other.hasVariants == hasVariants));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      productId,
      productName,
      sku,
      imageUrl,
      brand,
      category,
      totalQuantity,
      totalRejected,
      previousStock,
      const DeepCollectionEquality().hash(_scannedBy),
      sessionType,
      variantId,
      variantName,
      displayName,
      variantSku,
      displaySku,
      hasVariants);

  /// Create a copy of SessionReviewItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionReviewItemImplCopyWith<_$SessionReviewItemImpl> get copyWith =>
      __$$SessionReviewItemImplCopyWithImpl<_$SessionReviewItemImpl>(
          this, _$identity);
}

abstract class _SessionReviewItem extends SessionReviewItem {
  const factory _SessionReviewItem(
      {required final String productId,
      required final String productName,
      final String? sku,
      final String? imageUrl,
      final String? brand,
      final String? category,
      required final int totalQuantity,
      required final int totalRejected,
      final int previousStock,
      required final List<ScannedByUser> scannedBy,
      final String sessionType,
      final String? variantId,
      final String? variantName,
      final String? displayName,
      final String? variantSku,
      final String? displaySku,
      final bool hasVariants}) = _$SessionReviewItemImpl;
  const _SessionReviewItem._() : super._();

  @override
  String get productId;
  @override
  String get productName;
  @override
  String? get sku;
  @override
  String? get imageUrl;
  @override
  String? get brand;
  @override
  String? get category;
  @override
  int get totalQuantity;
  @override
  int get totalRejected;
  @override
  int get previousStock;
  @override
  List<ScannedByUser> get scannedBy;

  /// Session type: 'counting' or 'receiving'
  /// Used to calculate newStock and stockChange differently
  @override
  String get sessionType; // v2 variant fields
  @override
  String? get variantId;
  @override
  String? get variantName;
  @override
  String? get displayName;
  @override
  String? get variantSku;
  @override
  String? get displaySku;
  @override
  bool get hasVariants;

  /// Create a copy of SessionReviewItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionReviewItemImplCopyWith<_$SessionReviewItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SessionReviewSummary {
  int get totalProducts => throw _privateConstructorUsedError;
  int get totalQuantity => throw _privateConstructorUsedError;
  int get totalRejected => throw _privateConstructorUsedError;
  int get totalParticipants => throw _privateConstructorUsedError;

  /// Create a copy of SessionReviewSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionReviewSummaryCopyWith<SessionReviewSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionReviewSummaryCopyWith<$Res> {
  factory $SessionReviewSummaryCopyWith(SessionReviewSummary value,
          $Res Function(SessionReviewSummary) then) =
      _$SessionReviewSummaryCopyWithImpl<$Res, SessionReviewSummary>;
  @useResult
  $Res call(
      {int totalProducts,
      int totalQuantity,
      int totalRejected,
      int totalParticipants});
}

/// @nodoc
class _$SessionReviewSummaryCopyWithImpl<$Res,
        $Val extends SessionReviewSummary>
    implements $SessionReviewSummaryCopyWith<$Res> {
  _$SessionReviewSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SessionReviewSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalProducts = null,
    Object? totalQuantity = null,
    Object? totalRejected = null,
    Object? totalParticipants = null,
  }) {
    return _then(_value.copyWith(
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
      totalParticipants: null == totalParticipants
          ? _value.totalParticipants
          : totalParticipants // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SessionReviewSummaryImplCopyWith<$Res>
    implements $SessionReviewSummaryCopyWith<$Res> {
  factory _$$SessionReviewSummaryImplCopyWith(_$SessionReviewSummaryImpl value,
          $Res Function(_$SessionReviewSummaryImpl) then) =
      __$$SessionReviewSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int totalProducts,
      int totalQuantity,
      int totalRejected,
      int totalParticipants});
}

/// @nodoc
class __$$SessionReviewSummaryImplCopyWithImpl<$Res>
    extends _$SessionReviewSummaryCopyWithImpl<$Res, _$SessionReviewSummaryImpl>
    implements _$$SessionReviewSummaryImplCopyWith<$Res> {
  __$$SessionReviewSummaryImplCopyWithImpl(_$SessionReviewSummaryImpl _value,
      $Res Function(_$SessionReviewSummaryImpl) _then)
      : super(_value, _then);

  /// Create a copy of SessionReviewSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalProducts = null,
    Object? totalQuantity = null,
    Object? totalRejected = null,
    Object? totalParticipants = null,
  }) {
    return _then(_$SessionReviewSummaryImpl(
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
      totalParticipants: null == totalParticipants
          ? _value.totalParticipants
          : totalParticipants // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$SessionReviewSummaryImpl extends _SessionReviewSummary {
  const _$SessionReviewSummaryImpl(
      {required this.totalProducts,
      required this.totalQuantity,
      required this.totalRejected,
      this.totalParticipants = 0})
      : super._();

  @override
  final int totalProducts;
  @override
  final int totalQuantity;
  @override
  final int totalRejected;
  @override
  @JsonKey()
  final int totalParticipants;

  @override
  String toString() {
    return 'SessionReviewSummary(totalProducts: $totalProducts, totalQuantity: $totalQuantity, totalRejected: $totalRejected, totalParticipants: $totalParticipants)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionReviewSummaryImpl &&
            (identical(other.totalProducts, totalProducts) ||
                other.totalProducts == totalProducts) &&
            (identical(other.totalQuantity, totalQuantity) ||
                other.totalQuantity == totalQuantity) &&
            (identical(other.totalRejected, totalRejected) ||
                other.totalRejected == totalRejected) &&
            (identical(other.totalParticipants, totalParticipants) ||
                other.totalParticipants == totalParticipants));
  }

  @override
  int get hashCode => Object.hash(runtimeType, totalProducts, totalQuantity,
      totalRejected, totalParticipants);

  /// Create a copy of SessionReviewSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionReviewSummaryImplCopyWith<_$SessionReviewSummaryImpl>
      get copyWith =>
          __$$SessionReviewSummaryImplCopyWithImpl<_$SessionReviewSummaryImpl>(
              this, _$identity);
}

abstract class _SessionReviewSummary extends SessionReviewSummary {
  const factory _SessionReviewSummary(
      {required final int totalProducts,
      required final int totalQuantity,
      required final int totalRejected,
      final int totalParticipants}) = _$SessionReviewSummaryImpl;
  const _SessionReviewSummary._() : super._();

  @override
  int get totalProducts;
  @override
  int get totalQuantity;
  @override
  int get totalRejected;
  @override
  int get totalParticipants;

  /// Create a copy of SessionReviewSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionReviewSummaryImplCopyWith<_$SessionReviewSummaryImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SessionParticipant {
  String get userId => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;
  String? get userProfileImage => throw _privateConstructorUsedError;
  int get productCount => throw _privateConstructorUsedError;
  int get totalScanned => throw _privateConstructorUsedError;

  /// Create a copy of SessionParticipant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionParticipantCopyWith<SessionParticipant> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionParticipantCopyWith<$Res> {
  factory $SessionParticipantCopyWith(
          SessionParticipant value, $Res Function(SessionParticipant) then) =
      _$SessionParticipantCopyWithImpl<$Res, SessionParticipant>;
  @useResult
  $Res call(
      {String userId,
      String userName,
      String? userProfileImage,
      int productCount,
      int totalScanned});
}

/// @nodoc
class _$SessionParticipantCopyWithImpl<$Res, $Val extends SessionParticipant>
    implements $SessionParticipantCopyWith<$Res> {
  _$SessionParticipantCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SessionParticipant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? userName = null,
    Object? userProfileImage = freezed,
    Object? productCount = null,
    Object? totalScanned = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      userProfileImage: freezed == userProfileImage
          ? _value.userProfileImage
          : userProfileImage // ignore: cast_nullable_to_non_nullable
              as String?,
      productCount: null == productCount
          ? _value.productCount
          : productCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalScanned: null == totalScanned
          ? _value.totalScanned
          : totalScanned // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SessionParticipantImplCopyWith<$Res>
    implements $SessionParticipantCopyWith<$Res> {
  factory _$$SessionParticipantImplCopyWith(_$SessionParticipantImpl value,
          $Res Function(_$SessionParticipantImpl) then) =
      __$$SessionParticipantImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      String userName,
      String? userProfileImage,
      int productCount,
      int totalScanned});
}

/// @nodoc
class __$$SessionParticipantImplCopyWithImpl<$Res>
    extends _$SessionParticipantCopyWithImpl<$Res, _$SessionParticipantImpl>
    implements _$$SessionParticipantImplCopyWith<$Res> {
  __$$SessionParticipantImplCopyWithImpl(_$SessionParticipantImpl _value,
      $Res Function(_$SessionParticipantImpl) _then)
      : super(_value, _then);

  /// Create a copy of SessionParticipant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? userName = null,
    Object? userProfileImage = freezed,
    Object? productCount = null,
    Object? totalScanned = null,
  }) {
    return _then(_$SessionParticipantImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      userProfileImage: freezed == userProfileImage
          ? _value.userProfileImage
          : userProfileImage // ignore: cast_nullable_to_non_nullable
              as String?,
      productCount: null == productCount
          ? _value.productCount
          : productCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalScanned: null == totalScanned
          ? _value.totalScanned
          : totalScanned // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$SessionParticipantImpl implements _SessionParticipant {
  const _$SessionParticipantImpl(
      {required this.userId,
      required this.userName,
      this.userProfileImage,
      required this.productCount,
      required this.totalScanned});

  @override
  final String userId;
  @override
  final String userName;
  @override
  final String? userProfileImage;
  @override
  final int productCount;
  @override
  final int totalScanned;

  @override
  String toString() {
    return 'SessionParticipant(userId: $userId, userName: $userName, userProfileImage: $userProfileImage, productCount: $productCount, totalScanned: $totalScanned)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionParticipantImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.userProfileImage, userProfileImage) ||
                other.userProfileImage == userProfileImage) &&
            (identical(other.productCount, productCount) ||
                other.productCount == productCount) &&
            (identical(other.totalScanned, totalScanned) ||
                other.totalScanned == totalScanned));
  }

  @override
  int get hashCode => Object.hash(runtimeType, userId, userName,
      userProfileImage, productCount, totalScanned);

  /// Create a copy of SessionParticipant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionParticipantImplCopyWith<_$SessionParticipantImpl> get copyWith =>
      __$$SessionParticipantImplCopyWithImpl<_$SessionParticipantImpl>(
          this, _$identity);
}

abstract class _SessionParticipant implements SessionParticipant {
  const factory _SessionParticipant(
      {required final String userId,
      required final String userName,
      final String? userProfileImage,
      required final int productCount,
      required final int totalScanned}) = _$SessionParticipantImpl;

  @override
  String get userId;
  @override
  String get userName;
  @override
  String? get userProfileImage;
  @override
  int get productCount;
  @override
  int get totalScanned;

  /// Create a copy of SessionParticipant
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionParticipantImplCopyWith<_$SessionParticipantImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SessionReviewResponse {
  String get sessionId => throw _privateConstructorUsedError;
  List<SessionReviewItem> get items => throw _privateConstructorUsedError;
  List<SessionParticipant> get participants =>
      throw _privateConstructorUsedError;
  SessionReviewSummary get summary => throw _privateConstructorUsedError;

  /// Create a copy of SessionReviewResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionReviewResponseCopyWith<SessionReviewResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionReviewResponseCopyWith<$Res> {
  factory $SessionReviewResponseCopyWith(SessionReviewResponse value,
          $Res Function(SessionReviewResponse) then) =
      _$SessionReviewResponseCopyWithImpl<$Res, SessionReviewResponse>;
  @useResult
  $Res call(
      {String sessionId,
      List<SessionReviewItem> items,
      List<SessionParticipant> participants,
      SessionReviewSummary summary});

  $SessionReviewSummaryCopyWith<$Res> get summary;
}

/// @nodoc
class _$SessionReviewResponseCopyWithImpl<$Res,
        $Val extends SessionReviewResponse>
    implements $SessionReviewResponseCopyWith<$Res> {
  _$SessionReviewResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SessionReviewResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? items = null,
    Object? participants = null,
    Object? summary = null,
  }) {
    return _then(_value.copyWith(
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<SessionReviewItem>,
      participants: null == participants
          ? _value.participants
          : participants // ignore: cast_nullable_to_non_nullable
              as List<SessionParticipant>,
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as SessionReviewSummary,
    ) as $Val);
  }

  /// Create a copy of SessionReviewResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SessionReviewSummaryCopyWith<$Res> get summary {
    return $SessionReviewSummaryCopyWith<$Res>(_value.summary, (value) {
      return _then(_value.copyWith(summary: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SessionReviewResponseImplCopyWith<$Res>
    implements $SessionReviewResponseCopyWith<$Res> {
  factory _$$SessionReviewResponseImplCopyWith(
          _$SessionReviewResponseImpl value,
          $Res Function(_$SessionReviewResponseImpl) then) =
      __$$SessionReviewResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String sessionId,
      List<SessionReviewItem> items,
      List<SessionParticipant> participants,
      SessionReviewSummary summary});

  @override
  $SessionReviewSummaryCopyWith<$Res> get summary;
}

/// @nodoc
class __$$SessionReviewResponseImplCopyWithImpl<$Res>
    extends _$SessionReviewResponseCopyWithImpl<$Res,
        _$SessionReviewResponseImpl>
    implements _$$SessionReviewResponseImplCopyWith<$Res> {
  __$$SessionReviewResponseImplCopyWithImpl(_$SessionReviewResponseImpl _value,
      $Res Function(_$SessionReviewResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of SessionReviewResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? items = null,
    Object? participants = null,
    Object? summary = null,
  }) {
    return _then(_$SessionReviewResponseImpl(
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<SessionReviewItem>,
      participants: null == participants
          ? _value._participants
          : participants // ignore: cast_nullable_to_non_nullable
              as List<SessionParticipant>,
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as SessionReviewSummary,
    ));
  }
}

/// @nodoc

class _$SessionReviewResponseImpl implements _SessionReviewResponse {
  const _$SessionReviewResponseImpl(
      {required this.sessionId,
      required final List<SessionReviewItem> items,
      required final List<SessionParticipant> participants,
      required this.summary})
      : _items = items,
        _participants = participants;

  @override
  final String sessionId;
  final List<SessionReviewItem> _items;
  @override
  List<SessionReviewItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  final List<SessionParticipant> _participants;
  @override
  List<SessionParticipant> get participants {
    if (_participants is EqualUnmodifiableListView) return _participants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_participants);
  }

  @override
  final SessionReviewSummary summary;

  @override
  String toString() {
    return 'SessionReviewResponse(sessionId: $sessionId, items: $items, participants: $participants, summary: $summary)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionReviewResponseImpl &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            const DeepCollectionEquality()
                .equals(other._participants, _participants) &&
            (identical(other.summary, summary) || other.summary == summary));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      sessionId,
      const DeepCollectionEquality().hash(_items),
      const DeepCollectionEquality().hash(_participants),
      summary);

  /// Create a copy of SessionReviewResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionReviewResponseImplCopyWith<_$SessionReviewResponseImpl>
      get copyWith => __$$SessionReviewResponseImplCopyWithImpl<
          _$SessionReviewResponseImpl>(this, _$identity);
}

abstract class _SessionReviewResponse implements SessionReviewResponse {
  const factory _SessionReviewResponse(
          {required final String sessionId,
          required final List<SessionReviewItem> items,
          required final List<SessionParticipant> participants,
          required final SessionReviewSummary summary}) =
      _$SessionReviewResponseImpl;

  @override
  String get sessionId;
  @override
  List<SessionReviewItem> get items;
  @override
  List<SessionParticipant> get participants;
  @override
  SessionReviewSummary get summary;

  /// Create a copy of SessionReviewResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionReviewResponseImplCopyWith<_$SessionReviewResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SessionSubmitItem {
  String get productId => throw _privateConstructorUsedError;

  /// Variant ID for variant products, null for simple products
  String? get variantId => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  int get quantityRejected => throw _privateConstructorUsedError;

  /// Create a copy of SessionSubmitItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionSubmitItemCopyWith<SessionSubmitItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionSubmitItemCopyWith<$Res> {
  factory $SessionSubmitItemCopyWith(
          SessionSubmitItem value, $Res Function(SessionSubmitItem) then) =
      _$SessionSubmitItemCopyWithImpl<$Res, SessionSubmitItem>;
  @useResult
  $Res call(
      {String productId,
      String? variantId,
      int quantity,
      int quantityRejected});
}

/// @nodoc
class _$SessionSubmitItemCopyWithImpl<$Res, $Val extends SessionSubmitItem>
    implements $SessionSubmitItemCopyWith<$Res> {
  _$SessionSubmitItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SessionSubmitItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? variantId = freezed,
    Object? quantity = null,
    Object? quantityRejected = null,
  }) {
    return _then(_value.copyWith(
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      variantId: freezed == variantId
          ? _value.variantId
          : variantId // ignore: cast_nullable_to_non_nullable
              as String?,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      quantityRejected: null == quantityRejected
          ? _value.quantityRejected
          : quantityRejected // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SessionSubmitItemImplCopyWith<$Res>
    implements $SessionSubmitItemCopyWith<$Res> {
  factory _$$SessionSubmitItemImplCopyWith(_$SessionSubmitItemImpl value,
          $Res Function(_$SessionSubmitItemImpl) then) =
      __$$SessionSubmitItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String productId,
      String? variantId,
      int quantity,
      int quantityRejected});
}

/// @nodoc
class __$$SessionSubmitItemImplCopyWithImpl<$Res>
    extends _$SessionSubmitItemCopyWithImpl<$Res, _$SessionSubmitItemImpl>
    implements _$$SessionSubmitItemImplCopyWith<$Res> {
  __$$SessionSubmitItemImplCopyWithImpl(_$SessionSubmitItemImpl _value,
      $Res Function(_$SessionSubmitItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of SessionSubmitItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? variantId = freezed,
    Object? quantity = null,
    Object? quantityRejected = null,
  }) {
    return _then(_$SessionSubmitItemImpl(
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      variantId: freezed == variantId
          ? _value.variantId
          : variantId // ignore: cast_nullable_to_non_nullable
              as String?,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      quantityRejected: null == quantityRejected
          ? _value.quantityRejected
          : quantityRejected // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$SessionSubmitItemImpl implements _SessionSubmitItem {
  const _$SessionSubmitItemImpl(
      {required this.productId,
      this.variantId,
      required this.quantity,
      this.quantityRejected = 0});

  @override
  final String productId;

  /// Variant ID for variant products, null for simple products
  @override
  final String? variantId;
  @override
  final int quantity;
  @override
  @JsonKey()
  final int quantityRejected;

  @override
  String toString() {
    return 'SessionSubmitItem(productId: $productId, variantId: $variantId, quantity: $quantity, quantityRejected: $quantityRejected)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionSubmitItemImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.variantId, variantId) ||
                other.variantId == variantId) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.quantityRejected, quantityRejected) ||
                other.quantityRejected == quantityRejected));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, productId, variantId, quantity, quantityRejected);

  /// Create a copy of SessionSubmitItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionSubmitItemImplCopyWith<_$SessionSubmitItemImpl> get copyWith =>
      __$$SessionSubmitItemImplCopyWithImpl<_$SessionSubmitItemImpl>(
          this, _$identity);
}

abstract class _SessionSubmitItem implements SessionSubmitItem {
  const factory _SessionSubmitItem(
      {required final String productId,
      final String? variantId,
      required final int quantity,
      final int quantityRejected}) = _$SessionSubmitItemImpl;

  @override
  String get productId;

  /// Variant ID for variant products, null for simple products
  @override
  String? get variantId;
  @override
  int get quantity;
  @override
  int get quantityRejected;

  /// Create a copy of SessionSubmitItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionSubmitItemImplCopyWith<_$SessionSubmitItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$StockChangeItem {
  String get productId => throw _privateConstructorUsedError;
  String? get sku => throw _privateConstructorUsedError;
  String get productName => throw _privateConstructorUsedError;
  int get quantityBefore => throw _privateConstructorUsedError;
  int get quantityReceived => throw _privateConstructorUsedError;
  int get quantityAfter => throw _privateConstructorUsedError;

  /// True if quantityBefore was 0 (new item needs display)
  bool get needsDisplay =>
      throw _privateConstructorUsedError; // v3 variant fields
  String? get variantId => throw _privateConstructorUsedError;
  String? get variantName => throw _privateConstructorUsedError;
  String? get displayName => throw _privateConstructorUsedError;
  bool get hasVariants => throw _privateConstructorUsedError;

  /// Create a copy of StockChangeItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StockChangeItemCopyWith<StockChangeItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StockChangeItemCopyWith<$Res> {
  factory $StockChangeItemCopyWith(
          StockChangeItem value, $Res Function(StockChangeItem) then) =
      _$StockChangeItemCopyWithImpl<$Res, StockChangeItem>;
  @useResult
  $Res call(
      {String productId,
      String? sku,
      String productName,
      int quantityBefore,
      int quantityReceived,
      int quantityAfter,
      bool needsDisplay,
      String? variantId,
      String? variantName,
      String? displayName,
      bool hasVariants});
}

/// @nodoc
class _$StockChangeItemCopyWithImpl<$Res, $Val extends StockChangeItem>
    implements $StockChangeItemCopyWith<$Res> {
  _$StockChangeItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StockChangeItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? sku = freezed,
    Object? productName = null,
    Object? quantityBefore = null,
    Object? quantityReceived = null,
    Object? quantityAfter = null,
    Object? needsDisplay = null,
    Object? variantId = freezed,
    Object? variantName = freezed,
    Object? displayName = freezed,
    Object? hasVariants = null,
  }) {
    return _then(_value.copyWith(
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      sku: freezed == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String?,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      quantityBefore: null == quantityBefore
          ? _value.quantityBefore
          : quantityBefore // ignore: cast_nullable_to_non_nullable
              as int,
      quantityReceived: null == quantityReceived
          ? _value.quantityReceived
          : quantityReceived // ignore: cast_nullable_to_non_nullable
              as int,
      quantityAfter: null == quantityAfter
          ? _value.quantityAfter
          : quantityAfter // ignore: cast_nullable_to_non_nullable
              as int,
      needsDisplay: null == needsDisplay
          ? _value.needsDisplay
          : needsDisplay // ignore: cast_nullable_to_non_nullable
              as bool,
      variantId: freezed == variantId
          ? _value.variantId
          : variantId // ignore: cast_nullable_to_non_nullable
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StockChangeItemImplCopyWith<$Res>
    implements $StockChangeItemCopyWith<$Res> {
  factory _$$StockChangeItemImplCopyWith(_$StockChangeItemImpl value,
          $Res Function(_$StockChangeItemImpl) then) =
      __$$StockChangeItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String productId,
      String? sku,
      String productName,
      int quantityBefore,
      int quantityReceived,
      int quantityAfter,
      bool needsDisplay,
      String? variantId,
      String? variantName,
      String? displayName,
      bool hasVariants});
}

/// @nodoc
class __$$StockChangeItemImplCopyWithImpl<$Res>
    extends _$StockChangeItemCopyWithImpl<$Res, _$StockChangeItemImpl>
    implements _$$StockChangeItemImplCopyWith<$Res> {
  __$$StockChangeItemImplCopyWithImpl(
      _$StockChangeItemImpl _value, $Res Function(_$StockChangeItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of StockChangeItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? sku = freezed,
    Object? productName = null,
    Object? quantityBefore = null,
    Object? quantityReceived = null,
    Object? quantityAfter = null,
    Object? needsDisplay = null,
    Object? variantId = freezed,
    Object? variantName = freezed,
    Object? displayName = freezed,
    Object? hasVariants = null,
  }) {
    return _then(_$StockChangeItemImpl(
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      sku: freezed == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String?,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      quantityBefore: null == quantityBefore
          ? _value.quantityBefore
          : quantityBefore // ignore: cast_nullable_to_non_nullable
              as int,
      quantityReceived: null == quantityReceived
          ? _value.quantityReceived
          : quantityReceived // ignore: cast_nullable_to_non_nullable
              as int,
      quantityAfter: null == quantityAfter
          ? _value.quantityAfter
          : quantityAfter // ignore: cast_nullable_to_non_nullable
              as int,
      needsDisplay: null == needsDisplay
          ? _value.needsDisplay
          : needsDisplay // ignore: cast_nullable_to_non_nullable
              as bool,
      variantId: freezed == variantId
          ? _value.variantId
          : variantId // ignore: cast_nullable_to_non_nullable
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
    ));
  }
}

/// @nodoc

class _$StockChangeItemImpl extends _StockChangeItem {
  const _$StockChangeItemImpl(
      {required this.productId,
      this.sku,
      required this.productName,
      required this.quantityBefore,
      required this.quantityReceived,
      required this.quantityAfter,
      required this.needsDisplay,
      this.variantId,
      this.variantName,
      this.displayName,
      this.hasVariants = false})
      : super._();

  @override
  final String productId;
  @override
  final String? sku;
  @override
  final String productName;
  @override
  final int quantityBefore;
  @override
  final int quantityReceived;
  @override
  final int quantityAfter;

  /// True if quantityBefore was 0 (new item needs display)
  @override
  final bool needsDisplay;
// v3 variant fields
  @override
  final String? variantId;
  @override
  final String? variantName;
  @override
  final String? displayName;
  @override
  @JsonKey()
  final bool hasVariants;

  @override
  String toString() {
    return 'StockChangeItem(productId: $productId, sku: $sku, productName: $productName, quantityBefore: $quantityBefore, quantityReceived: $quantityReceived, quantityAfter: $quantityAfter, needsDisplay: $needsDisplay, variantId: $variantId, variantName: $variantName, displayName: $displayName, hasVariants: $hasVariants)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StockChangeItemImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.quantityBefore, quantityBefore) ||
                other.quantityBefore == quantityBefore) &&
            (identical(other.quantityReceived, quantityReceived) ||
                other.quantityReceived == quantityReceived) &&
            (identical(other.quantityAfter, quantityAfter) ||
                other.quantityAfter == quantityAfter) &&
            (identical(other.needsDisplay, needsDisplay) ||
                other.needsDisplay == needsDisplay) &&
            (identical(other.variantId, variantId) ||
                other.variantId == variantId) &&
            (identical(other.variantName, variantName) ||
                other.variantName == variantName) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.hasVariants, hasVariants) ||
                other.hasVariants == hasVariants));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      productId,
      sku,
      productName,
      quantityBefore,
      quantityReceived,
      quantityAfter,
      needsDisplay,
      variantId,
      variantName,
      displayName,
      hasVariants);

  /// Create a copy of StockChangeItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StockChangeItemImplCopyWith<_$StockChangeItemImpl> get copyWith =>
      __$$StockChangeItemImplCopyWithImpl<_$StockChangeItemImpl>(
          this, _$identity);
}

abstract class _StockChangeItem extends StockChangeItem {
  const factory _StockChangeItem(
      {required final String productId,
      final String? sku,
      required final String productName,
      required final int quantityBefore,
      required final int quantityReceived,
      required final int quantityAfter,
      required final bool needsDisplay,
      final String? variantId,
      final String? variantName,
      final String? displayName,
      final bool hasVariants}) = _$StockChangeItemImpl;
  const _StockChangeItem._() : super._();

  @override
  String get productId;
  @override
  String? get sku;
  @override
  String get productName;
  @override
  int get quantityBefore;
  @override
  int get quantityReceived;
  @override
  int get quantityAfter;

  /// True if quantityBefore was 0 (new item needs display)
  @override
  bool get needsDisplay; // v3 variant fields
  @override
  String? get variantId;
  @override
  String? get variantName;
  @override
  String? get displayName;
  @override
  bool get hasVariants;

  /// Create a copy of StockChangeItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StockChangeItemImplCopyWith<_$StockChangeItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SessionSubmitResponse {
  String get sessionType => throw _privateConstructorUsedError;
  String get receivingId => throw _privateConstructorUsedError;
  String get receivingNumber => throw _privateConstructorUsedError;
  String get sessionId => throw _privateConstructorUsedError;
  bool get isFinal => throw _privateConstructorUsedError;
  int get itemsCount => throw _privateConstructorUsedError;
  int get totalQuantity => throw _privateConstructorUsedError;
  int get totalRejected => throw _privateConstructorUsedError;
  bool get stockUpdated => throw _privateConstructorUsedError;

  /// Stock changes for each product (receiving only)
  List<StockChangeItem> get stockChanges => throw _privateConstructorUsedError;

  /// Count of new items that need display (quantityBefore = 0)
  int get newDisplayCount => throw _privateConstructorUsedError;

  /// Create a copy of SessionSubmitResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionSubmitResponseCopyWith<SessionSubmitResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionSubmitResponseCopyWith<$Res> {
  factory $SessionSubmitResponseCopyWith(SessionSubmitResponse value,
          $Res Function(SessionSubmitResponse) then) =
      _$SessionSubmitResponseCopyWithImpl<$Res, SessionSubmitResponse>;
  @useResult
  $Res call(
      {String sessionType,
      String receivingId,
      String receivingNumber,
      String sessionId,
      bool isFinal,
      int itemsCount,
      int totalQuantity,
      int totalRejected,
      bool stockUpdated,
      List<StockChangeItem> stockChanges,
      int newDisplayCount});
}

/// @nodoc
class _$SessionSubmitResponseCopyWithImpl<$Res,
        $Val extends SessionSubmitResponse>
    implements $SessionSubmitResponseCopyWith<$Res> {
  _$SessionSubmitResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SessionSubmitResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionType = null,
    Object? receivingId = null,
    Object? receivingNumber = null,
    Object? sessionId = null,
    Object? isFinal = null,
    Object? itemsCount = null,
    Object? totalQuantity = null,
    Object? totalRejected = null,
    Object? stockUpdated = null,
    Object? stockChanges = null,
    Object? newDisplayCount = null,
  }) {
    return _then(_value.copyWith(
      sessionType: null == sessionType
          ? _value.sessionType
          : sessionType // ignore: cast_nullable_to_non_nullable
              as String,
      receivingId: null == receivingId
          ? _value.receivingId
          : receivingId // ignore: cast_nullable_to_non_nullable
              as String,
      receivingNumber: null == receivingNumber
          ? _value.receivingNumber
          : receivingNumber // ignore: cast_nullable_to_non_nullable
              as String,
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      isFinal: null == isFinal
          ? _value.isFinal
          : isFinal // ignore: cast_nullable_to_non_nullable
              as bool,
      itemsCount: null == itemsCount
          ? _value.itemsCount
          : itemsCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalQuantity: null == totalQuantity
          ? _value.totalQuantity
          : totalQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      totalRejected: null == totalRejected
          ? _value.totalRejected
          : totalRejected // ignore: cast_nullable_to_non_nullable
              as int,
      stockUpdated: null == stockUpdated
          ? _value.stockUpdated
          : stockUpdated // ignore: cast_nullable_to_non_nullable
              as bool,
      stockChanges: null == stockChanges
          ? _value.stockChanges
          : stockChanges // ignore: cast_nullable_to_non_nullable
              as List<StockChangeItem>,
      newDisplayCount: null == newDisplayCount
          ? _value.newDisplayCount
          : newDisplayCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SessionSubmitResponseImplCopyWith<$Res>
    implements $SessionSubmitResponseCopyWith<$Res> {
  factory _$$SessionSubmitResponseImplCopyWith(
          _$SessionSubmitResponseImpl value,
          $Res Function(_$SessionSubmitResponseImpl) then) =
      __$$SessionSubmitResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String sessionType,
      String receivingId,
      String receivingNumber,
      String sessionId,
      bool isFinal,
      int itemsCount,
      int totalQuantity,
      int totalRejected,
      bool stockUpdated,
      List<StockChangeItem> stockChanges,
      int newDisplayCount});
}

/// @nodoc
class __$$SessionSubmitResponseImplCopyWithImpl<$Res>
    extends _$SessionSubmitResponseCopyWithImpl<$Res,
        _$SessionSubmitResponseImpl>
    implements _$$SessionSubmitResponseImplCopyWith<$Res> {
  __$$SessionSubmitResponseImplCopyWithImpl(_$SessionSubmitResponseImpl _value,
      $Res Function(_$SessionSubmitResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of SessionSubmitResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionType = null,
    Object? receivingId = null,
    Object? receivingNumber = null,
    Object? sessionId = null,
    Object? isFinal = null,
    Object? itemsCount = null,
    Object? totalQuantity = null,
    Object? totalRejected = null,
    Object? stockUpdated = null,
    Object? stockChanges = null,
    Object? newDisplayCount = null,
  }) {
    return _then(_$SessionSubmitResponseImpl(
      sessionType: null == sessionType
          ? _value.sessionType
          : sessionType // ignore: cast_nullable_to_non_nullable
              as String,
      receivingId: null == receivingId
          ? _value.receivingId
          : receivingId // ignore: cast_nullable_to_non_nullable
              as String,
      receivingNumber: null == receivingNumber
          ? _value.receivingNumber
          : receivingNumber // ignore: cast_nullable_to_non_nullable
              as String,
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      isFinal: null == isFinal
          ? _value.isFinal
          : isFinal // ignore: cast_nullable_to_non_nullable
              as bool,
      itemsCount: null == itemsCount
          ? _value.itemsCount
          : itemsCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalQuantity: null == totalQuantity
          ? _value.totalQuantity
          : totalQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      totalRejected: null == totalRejected
          ? _value.totalRejected
          : totalRejected // ignore: cast_nullable_to_non_nullable
              as int,
      stockUpdated: null == stockUpdated
          ? _value.stockUpdated
          : stockUpdated // ignore: cast_nullable_to_non_nullable
              as bool,
      stockChanges: null == stockChanges
          ? _value._stockChanges
          : stockChanges // ignore: cast_nullable_to_non_nullable
              as List<StockChangeItem>,
      newDisplayCount: null == newDisplayCount
          ? _value.newDisplayCount
          : newDisplayCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$SessionSubmitResponseImpl implements _SessionSubmitResponse {
  const _$SessionSubmitResponseImpl(
      {this.sessionType = 'receiving',
      required this.receivingId,
      required this.receivingNumber,
      required this.sessionId,
      required this.isFinal,
      required this.itemsCount,
      required this.totalQuantity,
      required this.totalRejected,
      required this.stockUpdated,
      final List<StockChangeItem> stockChanges = const [],
      this.newDisplayCount = 0})
      : _stockChanges = stockChanges;

  @override
  @JsonKey()
  final String sessionType;
  @override
  final String receivingId;
  @override
  final String receivingNumber;
  @override
  final String sessionId;
  @override
  final bool isFinal;
  @override
  final int itemsCount;
  @override
  final int totalQuantity;
  @override
  final int totalRejected;
  @override
  final bool stockUpdated;

  /// Stock changes for each product (receiving only)
  final List<StockChangeItem> _stockChanges;

  /// Stock changes for each product (receiving only)
  @override
  @JsonKey()
  List<StockChangeItem> get stockChanges {
    if (_stockChanges is EqualUnmodifiableListView) return _stockChanges;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_stockChanges);
  }

  /// Count of new items that need display (quantityBefore = 0)
  @override
  @JsonKey()
  final int newDisplayCount;

  @override
  String toString() {
    return 'SessionSubmitResponse(sessionType: $sessionType, receivingId: $receivingId, receivingNumber: $receivingNumber, sessionId: $sessionId, isFinal: $isFinal, itemsCount: $itemsCount, totalQuantity: $totalQuantity, totalRejected: $totalRejected, stockUpdated: $stockUpdated, stockChanges: $stockChanges, newDisplayCount: $newDisplayCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionSubmitResponseImpl &&
            (identical(other.sessionType, sessionType) ||
                other.sessionType == sessionType) &&
            (identical(other.receivingId, receivingId) ||
                other.receivingId == receivingId) &&
            (identical(other.receivingNumber, receivingNumber) ||
                other.receivingNumber == receivingNumber) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.isFinal, isFinal) || other.isFinal == isFinal) &&
            (identical(other.itemsCount, itemsCount) ||
                other.itemsCount == itemsCount) &&
            (identical(other.totalQuantity, totalQuantity) ||
                other.totalQuantity == totalQuantity) &&
            (identical(other.totalRejected, totalRejected) ||
                other.totalRejected == totalRejected) &&
            (identical(other.stockUpdated, stockUpdated) ||
                other.stockUpdated == stockUpdated) &&
            const DeepCollectionEquality()
                .equals(other._stockChanges, _stockChanges) &&
            (identical(other.newDisplayCount, newDisplayCount) ||
                other.newDisplayCount == newDisplayCount));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      sessionType,
      receivingId,
      receivingNumber,
      sessionId,
      isFinal,
      itemsCount,
      totalQuantity,
      totalRejected,
      stockUpdated,
      const DeepCollectionEquality().hash(_stockChanges),
      newDisplayCount);

  /// Create a copy of SessionSubmitResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionSubmitResponseImplCopyWith<_$SessionSubmitResponseImpl>
      get copyWith => __$$SessionSubmitResponseImplCopyWithImpl<
          _$SessionSubmitResponseImpl>(this, _$identity);
}

abstract class _SessionSubmitResponse implements SessionSubmitResponse {
  const factory _SessionSubmitResponse(
      {final String sessionType,
      required final String receivingId,
      required final String receivingNumber,
      required final String sessionId,
      required final bool isFinal,
      required final int itemsCount,
      required final int totalQuantity,
      required final int totalRejected,
      required final bool stockUpdated,
      final List<StockChangeItem> stockChanges,
      final int newDisplayCount}) = _$SessionSubmitResponseImpl;

  @override
  String get sessionType;
  @override
  String get receivingId;
  @override
  String get receivingNumber;
  @override
  String get sessionId;
  @override
  bool get isFinal;
  @override
  int get itemsCount;
  @override
  int get totalQuantity;
  @override
  int get totalRejected;
  @override
  bool get stockUpdated;

  /// Stock changes for each product (receiving only)
  @override
  List<StockChangeItem> get stockChanges;

  /// Count of new items that need display (quantityBefore = 0)
  @override
  int get newDisplayCount;

  /// Create a copy of SessionSubmitResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionSubmitResponseImplCopyWith<_$SessionSubmitResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
