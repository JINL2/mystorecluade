// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_history_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SessionHistoryMember {
  String get oderId => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;
  String get joinedAt => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

  /// Create a copy of SessionHistoryMember
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionHistoryMemberCopyWith<SessionHistoryMember> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionHistoryMemberCopyWith<$Res> {
  factory $SessionHistoryMemberCopyWith(SessionHistoryMember value,
          $Res Function(SessionHistoryMember) then) =
      _$SessionHistoryMemberCopyWithImpl<$Res, SessionHistoryMember>;
  @useResult
  $Res call({String oderId, String userName, String joinedAt, bool isActive});
}

/// @nodoc
class _$SessionHistoryMemberCopyWithImpl<$Res,
        $Val extends SessionHistoryMember>
    implements $SessionHistoryMemberCopyWith<$Res> {
  _$SessionHistoryMemberCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SessionHistoryMember
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? oderId = null,
    Object? userName = null,
    Object? joinedAt = null,
    Object? isActive = null,
  }) {
    return _then(_value.copyWith(
      oderId: null == oderId
          ? _value.oderId
          : oderId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      joinedAt: null == joinedAt
          ? _value.joinedAt
          : joinedAt // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SessionHistoryMemberImplCopyWith<$Res>
    implements $SessionHistoryMemberCopyWith<$Res> {
  factory _$$SessionHistoryMemberImplCopyWith(_$SessionHistoryMemberImpl value,
          $Res Function(_$SessionHistoryMemberImpl) then) =
      __$$SessionHistoryMemberImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String oderId, String userName, String joinedAt, bool isActive});
}

/// @nodoc
class __$$SessionHistoryMemberImplCopyWithImpl<$Res>
    extends _$SessionHistoryMemberCopyWithImpl<$Res, _$SessionHistoryMemberImpl>
    implements _$$SessionHistoryMemberImplCopyWith<$Res> {
  __$$SessionHistoryMemberImplCopyWithImpl(_$SessionHistoryMemberImpl _value,
      $Res Function(_$SessionHistoryMemberImpl) _then)
      : super(_value, _then);

  /// Create a copy of SessionHistoryMember
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? oderId = null,
    Object? userName = null,
    Object? joinedAt = null,
    Object? isActive = null,
  }) {
    return _then(_$SessionHistoryMemberImpl(
      oderId: null == oderId
          ? _value.oderId
          : oderId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      joinedAt: null == joinedAt
          ? _value.joinedAt
          : joinedAt // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$SessionHistoryMemberImpl implements _SessionHistoryMember {
  const _$SessionHistoryMemberImpl(
      {required this.oderId,
      required this.userName,
      required this.joinedAt,
      required this.isActive});

  @override
  final String oderId;
  @override
  final String userName;
  @override
  final String joinedAt;
  @override
  final bool isActive;

  @override
  String toString() {
    return 'SessionHistoryMember(oderId: $oderId, userName: $userName, joinedAt: $joinedAt, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionHistoryMemberImpl &&
            (identical(other.oderId, oderId) || other.oderId == oderId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.joinedAt, joinedAt) ||
                other.joinedAt == joinedAt) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, oderId, userName, joinedAt, isActive);

  /// Create a copy of SessionHistoryMember
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionHistoryMemberImplCopyWith<_$SessionHistoryMemberImpl>
      get copyWith =>
          __$$SessionHistoryMemberImplCopyWithImpl<_$SessionHistoryMemberImpl>(
              this, _$identity);
}

abstract class _SessionHistoryMember implements SessionHistoryMember {
  const factory _SessionHistoryMember(
      {required final String oderId,
      required final String userName,
      required final String joinedAt,
      required final bool isActive}) = _$SessionHistoryMemberImpl;

  @override
  String get oderId;
  @override
  String get userName;
  @override
  String get joinedAt;
  @override
  bool get isActive;

  /// Create a copy of SessionHistoryMember
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionHistoryMemberImplCopyWith<_$SessionHistoryMemberImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ScannedByInfo {
  String get userId => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  int get quantityRejected => throw _privateConstructorUsedError;

  /// Create a copy of ScannedByInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScannedByInfoCopyWith<ScannedByInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScannedByInfoCopyWith<$Res> {
  factory $ScannedByInfoCopyWith(
          ScannedByInfo value, $Res Function(ScannedByInfo) then) =
      _$ScannedByInfoCopyWithImpl<$Res, ScannedByInfo>;
  @useResult
  $Res call(
      {String userId, String userName, int quantity, int quantityRejected});
}

/// @nodoc
class _$ScannedByInfoCopyWithImpl<$Res, $Val extends ScannedByInfo>
    implements $ScannedByInfoCopyWith<$Res> {
  _$ScannedByInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScannedByInfo
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
abstract class _$$ScannedByInfoImplCopyWith<$Res>
    implements $ScannedByInfoCopyWith<$Res> {
  factory _$$ScannedByInfoImplCopyWith(
          _$ScannedByInfoImpl value, $Res Function(_$ScannedByInfoImpl) then) =
      __$$ScannedByInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId, String userName, int quantity, int quantityRejected});
}

/// @nodoc
class __$$ScannedByInfoImplCopyWithImpl<$Res>
    extends _$ScannedByInfoCopyWithImpl<$Res, _$ScannedByInfoImpl>
    implements _$$ScannedByInfoImplCopyWith<$Res> {
  __$$ScannedByInfoImplCopyWithImpl(
      _$ScannedByInfoImpl _value, $Res Function(_$ScannedByInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ScannedByInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? userName = null,
    Object? quantity = null,
    Object? quantityRejected = null,
  }) {
    return _then(_$ScannedByInfoImpl(
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

class _$ScannedByInfoImpl implements _ScannedByInfo {
  const _$ScannedByInfoImpl(
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
    return 'ScannedByInfo(userId: $userId, userName: $userName, quantity: $quantity, quantityRejected: $quantityRejected)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScannedByInfoImpl &&
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

  /// Create a copy of ScannedByInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScannedByInfoImplCopyWith<_$ScannedByInfoImpl> get copyWith =>
      __$$ScannedByInfoImplCopyWithImpl<_$ScannedByInfoImpl>(this, _$identity);
}

abstract class _ScannedByInfo implements ScannedByInfo {
  const factory _ScannedByInfo(
      {required final String userId,
      required final String userName,
      required final int quantity,
      required final int quantityRejected}) = _$ScannedByInfoImpl;

  @override
  String get userId;
  @override
  String get userName;
  @override
  int get quantity;
  @override
  int get quantityRejected;

  /// Create a copy of ScannedByInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScannedByInfoImplCopyWith<_$ScannedByInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SessionHistoryItemDetail {
  String get productId => throw _privateConstructorUsedError;
  String get productName => throw _privateConstructorUsedError;
  String? get sku => throw _privateConstructorUsedError;

  /// Scanned by employees (from inventory_session_items)
  int get scannedQuantity => throw _privateConstructorUsedError;
  int get scannedRejected => throw _privateConstructorUsedError;
  List<ScannedByInfo> get scannedBy => throw _privateConstructorUsedError;

  /// Confirmed by manager (from receiving_items or counting_items)
  /// Null if session is still active (not submitted yet)
  int? get confirmedQuantity => throw _privateConstructorUsedError;
  int? get confirmedRejected => throw _privateConstructorUsedError;

  /// Counting specific fields
  int? get quantityExpected => throw _privateConstructorUsedError;
  int? get quantityDifference => throw _privateConstructorUsedError;

  /// Create a copy of SessionHistoryItemDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionHistoryItemDetailCopyWith<SessionHistoryItemDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionHistoryItemDetailCopyWith<$Res> {
  factory $SessionHistoryItemDetailCopyWith(SessionHistoryItemDetail value,
          $Res Function(SessionHistoryItemDetail) then) =
      _$SessionHistoryItemDetailCopyWithImpl<$Res, SessionHistoryItemDetail>;
  @useResult
  $Res call(
      {String productId,
      String productName,
      String? sku,
      int scannedQuantity,
      int scannedRejected,
      List<ScannedByInfo> scannedBy,
      int? confirmedQuantity,
      int? confirmedRejected,
      int? quantityExpected,
      int? quantityDifference});
}

/// @nodoc
class _$SessionHistoryItemDetailCopyWithImpl<$Res,
        $Val extends SessionHistoryItemDetail>
    implements $SessionHistoryItemDetailCopyWith<$Res> {
  _$SessionHistoryItemDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SessionHistoryItemDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? productName = null,
    Object? sku = freezed,
    Object? scannedQuantity = null,
    Object? scannedRejected = null,
    Object? scannedBy = null,
    Object? confirmedQuantity = freezed,
    Object? confirmedRejected = freezed,
    Object? quantityExpected = freezed,
    Object? quantityDifference = freezed,
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
      scannedQuantity: null == scannedQuantity
          ? _value.scannedQuantity
          : scannedQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      scannedRejected: null == scannedRejected
          ? _value.scannedRejected
          : scannedRejected // ignore: cast_nullable_to_non_nullable
              as int,
      scannedBy: null == scannedBy
          ? _value.scannedBy
          : scannedBy // ignore: cast_nullable_to_non_nullable
              as List<ScannedByInfo>,
      confirmedQuantity: freezed == confirmedQuantity
          ? _value.confirmedQuantity
          : confirmedQuantity // ignore: cast_nullable_to_non_nullable
              as int?,
      confirmedRejected: freezed == confirmedRejected
          ? _value.confirmedRejected
          : confirmedRejected // ignore: cast_nullable_to_non_nullable
              as int?,
      quantityExpected: freezed == quantityExpected
          ? _value.quantityExpected
          : quantityExpected // ignore: cast_nullable_to_non_nullable
              as int?,
      quantityDifference: freezed == quantityDifference
          ? _value.quantityDifference
          : quantityDifference // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SessionHistoryItemDetailImplCopyWith<$Res>
    implements $SessionHistoryItemDetailCopyWith<$Res> {
  factory _$$SessionHistoryItemDetailImplCopyWith(
          _$SessionHistoryItemDetailImpl value,
          $Res Function(_$SessionHistoryItemDetailImpl) then) =
      __$$SessionHistoryItemDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String productId,
      String productName,
      String? sku,
      int scannedQuantity,
      int scannedRejected,
      List<ScannedByInfo> scannedBy,
      int? confirmedQuantity,
      int? confirmedRejected,
      int? quantityExpected,
      int? quantityDifference});
}

/// @nodoc
class __$$SessionHistoryItemDetailImplCopyWithImpl<$Res>
    extends _$SessionHistoryItemDetailCopyWithImpl<$Res,
        _$SessionHistoryItemDetailImpl>
    implements _$$SessionHistoryItemDetailImplCopyWith<$Res> {
  __$$SessionHistoryItemDetailImplCopyWithImpl(
      _$SessionHistoryItemDetailImpl _value,
      $Res Function(_$SessionHistoryItemDetailImpl) _then)
      : super(_value, _then);

  /// Create a copy of SessionHistoryItemDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? productName = null,
    Object? sku = freezed,
    Object? scannedQuantity = null,
    Object? scannedRejected = null,
    Object? scannedBy = null,
    Object? confirmedQuantity = freezed,
    Object? confirmedRejected = freezed,
    Object? quantityExpected = freezed,
    Object? quantityDifference = freezed,
  }) {
    return _then(_$SessionHistoryItemDetailImpl(
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
      scannedQuantity: null == scannedQuantity
          ? _value.scannedQuantity
          : scannedQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      scannedRejected: null == scannedRejected
          ? _value.scannedRejected
          : scannedRejected // ignore: cast_nullable_to_non_nullable
              as int,
      scannedBy: null == scannedBy
          ? _value._scannedBy
          : scannedBy // ignore: cast_nullable_to_non_nullable
              as List<ScannedByInfo>,
      confirmedQuantity: freezed == confirmedQuantity
          ? _value.confirmedQuantity
          : confirmedQuantity // ignore: cast_nullable_to_non_nullable
              as int?,
      confirmedRejected: freezed == confirmedRejected
          ? _value.confirmedRejected
          : confirmedRejected // ignore: cast_nullable_to_non_nullable
              as int?,
      quantityExpected: freezed == quantityExpected
          ? _value.quantityExpected
          : quantityExpected // ignore: cast_nullable_to_non_nullable
              as int?,
      quantityDifference: freezed == quantityDifference
          ? _value.quantityDifference
          : quantityDifference // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$SessionHistoryItemDetailImpl extends _SessionHistoryItemDetail {
  const _$SessionHistoryItemDetailImpl(
      {required this.productId,
      required this.productName,
      this.sku,
      required this.scannedQuantity,
      required this.scannedRejected,
      required final List<ScannedByInfo> scannedBy,
      this.confirmedQuantity,
      this.confirmedRejected,
      this.quantityExpected,
      this.quantityDifference})
      : _scannedBy = scannedBy,
        super._();

  @override
  final String productId;
  @override
  final String productName;
  @override
  final String? sku;

  /// Scanned by employees (from inventory_session_items)
  @override
  final int scannedQuantity;
  @override
  final int scannedRejected;
  final List<ScannedByInfo> _scannedBy;
  @override
  List<ScannedByInfo> get scannedBy {
    if (_scannedBy is EqualUnmodifiableListView) return _scannedBy;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_scannedBy);
  }

  /// Confirmed by manager (from receiving_items or counting_items)
  /// Null if session is still active (not submitted yet)
  @override
  final int? confirmedQuantity;
  @override
  final int? confirmedRejected;

  /// Counting specific fields
  @override
  final int? quantityExpected;
  @override
  final int? quantityDifference;

  @override
  String toString() {
    return 'SessionHistoryItemDetail(productId: $productId, productName: $productName, sku: $sku, scannedQuantity: $scannedQuantity, scannedRejected: $scannedRejected, scannedBy: $scannedBy, confirmedQuantity: $confirmedQuantity, confirmedRejected: $confirmedRejected, quantityExpected: $quantityExpected, quantityDifference: $quantityDifference)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionHistoryItemDetailImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.scannedQuantity, scannedQuantity) ||
                other.scannedQuantity == scannedQuantity) &&
            (identical(other.scannedRejected, scannedRejected) ||
                other.scannedRejected == scannedRejected) &&
            const DeepCollectionEquality()
                .equals(other._scannedBy, _scannedBy) &&
            (identical(other.confirmedQuantity, confirmedQuantity) ||
                other.confirmedQuantity == confirmedQuantity) &&
            (identical(other.confirmedRejected, confirmedRejected) ||
                other.confirmedRejected == confirmedRejected) &&
            (identical(other.quantityExpected, quantityExpected) ||
                other.quantityExpected == quantityExpected) &&
            (identical(other.quantityDifference, quantityDifference) ||
                other.quantityDifference == quantityDifference));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      productId,
      productName,
      sku,
      scannedQuantity,
      scannedRejected,
      const DeepCollectionEquality().hash(_scannedBy),
      confirmedQuantity,
      confirmedRejected,
      quantityExpected,
      quantityDifference);

  /// Create a copy of SessionHistoryItemDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionHistoryItemDetailImplCopyWith<_$SessionHistoryItemDetailImpl>
      get copyWith => __$$SessionHistoryItemDetailImplCopyWithImpl<
          _$SessionHistoryItemDetailImpl>(this, _$identity);
}

abstract class _SessionHistoryItemDetail extends SessionHistoryItemDetail {
  const factory _SessionHistoryItemDetail(
      {required final String productId,
      required final String productName,
      final String? sku,
      required final int scannedQuantity,
      required final int scannedRejected,
      required final List<ScannedByInfo> scannedBy,
      final int? confirmedQuantity,
      final int? confirmedRejected,
      final int? quantityExpected,
      final int? quantityDifference}) = _$SessionHistoryItemDetailImpl;
  const _SessionHistoryItemDetail._() : super._();

  @override
  String get productId;
  @override
  String get productName;
  @override
  String? get sku;

  /// Scanned by employees (from inventory_session_items)
  @override
  int get scannedQuantity;
  @override
  int get scannedRejected;
  @override
  List<ScannedByInfo> get scannedBy;

  /// Confirmed by manager (from receiving_items or counting_items)
  /// Null if session is still active (not submitted yet)
  @override
  int? get confirmedQuantity;
  @override
  int? get confirmedRejected;

  /// Counting specific fields
  @override
  int? get quantityExpected;
  @override
  int? get quantityDifference;

  /// Create a copy of SessionHistoryItemDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionHistoryItemDetailImplCopyWith<_$SessionHistoryItemDetailImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SessionHistoryItem {
  String get sessionId => throw _privateConstructorUsedError;
  String get sessionName => throw _privateConstructorUsedError;
  String get sessionType => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  bool get isFinal => throw _privateConstructorUsedError;
  String get storeId => throw _privateConstructorUsedError;
  String get storeName => throw _privateConstructorUsedError;
  String? get shipmentId => throw _privateConstructorUsedError;
  String? get shipmentNumber => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  String? get completedAt => throw _privateConstructorUsedError;
  int? get durationMinutes => throw _privateConstructorUsedError;
  String get createdBy => throw _privateConstructorUsedError;
  String get createdByName => throw _privateConstructorUsedError;
  List<SessionHistoryMember> get members => throw _privateConstructorUsedError;
  int get memberCount => throw _privateConstructorUsedError;
  List<SessionHistoryItemDetail> get items =>
      throw _privateConstructorUsedError;

  /// Totals - Scanned by employees
  int get totalScannedQuantity => throw _privateConstructorUsedError;
  int get totalScannedRejected => throw _privateConstructorUsedError;

  /// Totals - Confirmed by manager (null if not submitted)
  int? get totalConfirmedQuantity => throw _privateConstructorUsedError;
  int? get totalConfirmedRejected => throw _privateConstructorUsedError;

  /// Counting specific - total difference from expected
  int? get totalDifference => throw _privateConstructorUsedError;

  /// Create a copy of SessionHistoryItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionHistoryItemCopyWith<SessionHistoryItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionHistoryItemCopyWith<$Res> {
  factory $SessionHistoryItemCopyWith(
          SessionHistoryItem value, $Res Function(SessionHistoryItem) then) =
      _$SessionHistoryItemCopyWithImpl<$Res, SessionHistoryItem>;
  @useResult
  $Res call(
      {String sessionId,
      String sessionName,
      String sessionType,
      bool isActive,
      bool isFinal,
      String storeId,
      String storeName,
      String? shipmentId,
      String? shipmentNumber,
      String createdAt,
      String? completedAt,
      int? durationMinutes,
      String createdBy,
      String createdByName,
      List<SessionHistoryMember> members,
      int memberCount,
      List<SessionHistoryItemDetail> items,
      int totalScannedQuantity,
      int totalScannedRejected,
      int? totalConfirmedQuantity,
      int? totalConfirmedRejected,
      int? totalDifference});
}

/// @nodoc
class _$SessionHistoryItemCopyWithImpl<$Res, $Val extends SessionHistoryItem>
    implements $SessionHistoryItemCopyWith<$Res> {
  _$SessionHistoryItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SessionHistoryItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? sessionName = null,
    Object? sessionType = null,
    Object? isActive = null,
    Object? isFinal = null,
    Object? storeId = null,
    Object? storeName = null,
    Object? shipmentId = freezed,
    Object? shipmentNumber = freezed,
    Object? createdAt = null,
    Object? completedAt = freezed,
    Object? durationMinutes = freezed,
    Object? createdBy = null,
    Object? createdByName = null,
    Object? members = null,
    Object? memberCount = null,
    Object? items = null,
    Object? totalScannedQuantity = null,
    Object? totalScannedRejected = null,
    Object? totalConfirmedQuantity = freezed,
    Object? totalConfirmedRejected = freezed,
    Object? totalDifference = freezed,
  }) {
    return _then(_value.copyWith(
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      sessionName: null == sessionName
          ? _value.sessionName
          : sessionName // ignore: cast_nullable_to_non_nullable
              as String,
      sessionType: null == sessionType
          ? _value.sessionType
          : sessionType // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isFinal: null == isFinal
          ? _value.isFinal
          : isFinal // ignore: cast_nullable_to_non_nullable
              as bool,
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      storeName: null == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String,
      shipmentId: freezed == shipmentId
          ? _value.shipmentId
          : shipmentId // ignore: cast_nullable_to_non_nullable
              as String?,
      shipmentNumber: freezed == shipmentNumber
          ? _value.shipmentNumber
          : shipmentNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      durationMinutes: freezed == durationMinutes
          ? _value.durationMinutes
          : durationMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdByName: null == createdByName
          ? _value.createdByName
          : createdByName // ignore: cast_nullable_to_non_nullable
              as String,
      members: null == members
          ? _value.members
          : members // ignore: cast_nullable_to_non_nullable
              as List<SessionHistoryMember>,
      memberCount: null == memberCount
          ? _value.memberCount
          : memberCount // ignore: cast_nullable_to_non_nullable
              as int,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<SessionHistoryItemDetail>,
      totalScannedQuantity: null == totalScannedQuantity
          ? _value.totalScannedQuantity
          : totalScannedQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      totalScannedRejected: null == totalScannedRejected
          ? _value.totalScannedRejected
          : totalScannedRejected // ignore: cast_nullable_to_non_nullable
              as int,
      totalConfirmedQuantity: freezed == totalConfirmedQuantity
          ? _value.totalConfirmedQuantity
          : totalConfirmedQuantity // ignore: cast_nullable_to_non_nullable
              as int?,
      totalConfirmedRejected: freezed == totalConfirmedRejected
          ? _value.totalConfirmedRejected
          : totalConfirmedRejected // ignore: cast_nullable_to_non_nullable
              as int?,
      totalDifference: freezed == totalDifference
          ? _value.totalDifference
          : totalDifference // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SessionHistoryItemImplCopyWith<$Res>
    implements $SessionHistoryItemCopyWith<$Res> {
  factory _$$SessionHistoryItemImplCopyWith(_$SessionHistoryItemImpl value,
          $Res Function(_$SessionHistoryItemImpl) then) =
      __$$SessionHistoryItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String sessionId,
      String sessionName,
      String sessionType,
      bool isActive,
      bool isFinal,
      String storeId,
      String storeName,
      String? shipmentId,
      String? shipmentNumber,
      String createdAt,
      String? completedAt,
      int? durationMinutes,
      String createdBy,
      String createdByName,
      List<SessionHistoryMember> members,
      int memberCount,
      List<SessionHistoryItemDetail> items,
      int totalScannedQuantity,
      int totalScannedRejected,
      int? totalConfirmedQuantity,
      int? totalConfirmedRejected,
      int? totalDifference});
}

/// @nodoc
class __$$SessionHistoryItemImplCopyWithImpl<$Res>
    extends _$SessionHistoryItemCopyWithImpl<$Res, _$SessionHistoryItemImpl>
    implements _$$SessionHistoryItemImplCopyWith<$Res> {
  __$$SessionHistoryItemImplCopyWithImpl(_$SessionHistoryItemImpl _value,
      $Res Function(_$SessionHistoryItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of SessionHistoryItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? sessionName = null,
    Object? sessionType = null,
    Object? isActive = null,
    Object? isFinal = null,
    Object? storeId = null,
    Object? storeName = null,
    Object? shipmentId = freezed,
    Object? shipmentNumber = freezed,
    Object? createdAt = null,
    Object? completedAt = freezed,
    Object? durationMinutes = freezed,
    Object? createdBy = null,
    Object? createdByName = null,
    Object? members = null,
    Object? memberCount = null,
    Object? items = null,
    Object? totalScannedQuantity = null,
    Object? totalScannedRejected = null,
    Object? totalConfirmedQuantity = freezed,
    Object? totalConfirmedRejected = freezed,
    Object? totalDifference = freezed,
  }) {
    return _then(_$SessionHistoryItemImpl(
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      sessionName: null == sessionName
          ? _value.sessionName
          : sessionName // ignore: cast_nullable_to_non_nullable
              as String,
      sessionType: null == sessionType
          ? _value.sessionType
          : sessionType // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isFinal: null == isFinal
          ? _value.isFinal
          : isFinal // ignore: cast_nullable_to_non_nullable
              as bool,
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      storeName: null == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String,
      shipmentId: freezed == shipmentId
          ? _value.shipmentId
          : shipmentId // ignore: cast_nullable_to_non_nullable
              as String?,
      shipmentNumber: freezed == shipmentNumber
          ? _value.shipmentNumber
          : shipmentNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      durationMinutes: freezed == durationMinutes
          ? _value.durationMinutes
          : durationMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdByName: null == createdByName
          ? _value.createdByName
          : createdByName // ignore: cast_nullable_to_non_nullable
              as String,
      members: null == members
          ? _value._members
          : members // ignore: cast_nullable_to_non_nullable
              as List<SessionHistoryMember>,
      memberCount: null == memberCount
          ? _value.memberCount
          : memberCount // ignore: cast_nullable_to_non_nullable
              as int,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<SessionHistoryItemDetail>,
      totalScannedQuantity: null == totalScannedQuantity
          ? _value.totalScannedQuantity
          : totalScannedQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      totalScannedRejected: null == totalScannedRejected
          ? _value.totalScannedRejected
          : totalScannedRejected // ignore: cast_nullable_to_non_nullable
              as int,
      totalConfirmedQuantity: freezed == totalConfirmedQuantity
          ? _value.totalConfirmedQuantity
          : totalConfirmedQuantity // ignore: cast_nullable_to_non_nullable
              as int?,
      totalConfirmedRejected: freezed == totalConfirmedRejected
          ? _value.totalConfirmedRejected
          : totalConfirmedRejected // ignore: cast_nullable_to_non_nullable
              as int?,
      totalDifference: freezed == totalDifference
          ? _value.totalDifference
          : totalDifference // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$SessionHistoryItemImpl extends _SessionHistoryItem {
  const _$SessionHistoryItemImpl(
      {required this.sessionId,
      required this.sessionName,
      required this.sessionType,
      required this.isActive,
      required this.isFinal,
      required this.storeId,
      required this.storeName,
      this.shipmentId,
      this.shipmentNumber,
      required this.createdAt,
      this.completedAt,
      this.durationMinutes,
      required this.createdBy,
      required this.createdByName,
      required final List<SessionHistoryMember> members,
      required this.memberCount,
      required final List<SessionHistoryItemDetail> items,
      required this.totalScannedQuantity,
      required this.totalScannedRejected,
      this.totalConfirmedQuantity,
      this.totalConfirmedRejected,
      this.totalDifference})
      : _members = members,
        _items = items,
        super._();

  @override
  final String sessionId;
  @override
  final String sessionName;
  @override
  final String sessionType;
  @override
  final bool isActive;
  @override
  final bool isFinal;
  @override
  final String storeId;
  @override
  final String storeName;
  @override
  final String? shipmentId;
  @override
  final String? shipmentNumber;
  @override
  final String createdAt;
  @override
  final String? completedAt;
  @override
  final int? durationMinutes;
  @override
  final String createdBy;
  @override
  final String createdByName;
  final List<SessionHistoryMember> _members;
  @override
  List<SessionHistoryMember> get members {
    if (_members is EqualUnmodifiableListView) return _members;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_members);
  }

  @override
  final int memberCount;
  final List<SessionHistoryItemDetail> _items;
  @override
  List<SessionHistoryItemDetail> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  /// Totals - Scanned by employees
  @override
  final int totalScannedQuantity;
  @override
  final int totalScannedRejected;

  /// Totals - Confirmed by manager (null if not submitted)
  @override
  final int? totalConfirmedQuantity;
  @override
  final int? totalConfirmedRejected;

  /// Counting specific - total difference from expected
  @override
  final int? totalDifference;

  @override
  String toString() {
    return 'SessionHistoryItem(sessionId: $sessionId, sessionName: $sessionName, sessionType: $sessionType, isActive: $isActive, isFinal: $isFinal, storeId: $storeId, storeName: $storeName, shipmentId: $shipmentId, shipmentNumber: $shipmentNumber, createdAt: $createdAt, completedAt: $completedAt, durationMinutes: $durationMinutes, createdBy: $createdBy, createdByName: $createdByName, members: $members, memberCount: $memberCount, items: $items, totalScannedQuantity: $totalScannedQuantity, totalScannedRejected: $totalScannedRejected, totalConfirmedQuantity: $totalConfirmedQuantity, totalConfirmedRejected: $totalConfirmedRejected, totalDifference: $totalDifference)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionHistoryItemImpl &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.sessionName, sessionName) ||
                other.sessionName == sessionName) &&
            (identical(other.sessionType, sessionType) ||
                other.sessionType == sessionType) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isFinal, isFinal) || other.isFinal == isFinal) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.storeName, storeName) ||
                other.storeName == storeName) &&
            (identical(other.shipmentId, shipmentId) ||
                other.shipmentId == shipmentId) &&
            (identical(other.shipmentNumber, shipmentNumber) ||
                other.shipmentNumber == shipmentNumber) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdByName, createdByName) ||
                other.createdByName == createdByName) &&
            const DeepCollectionEquality().equals(other._members, _members) &&
            (identical(other.memberCount, memberCount) ||
                other.memberCount == memberCount) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.totalScannedQuantity, totalScannedQuantity) ||
                other.totalScannedQuantity == totalScannedQuantity) &&
            (identical(other.totalScannedRejected, totalScannedRejected) ||
                other.totalScannedRejected == totalScannedRejected) &&
            (identical(other.totalConfirmedQuantity, totalConfirmedQuantity) ||
                other.totalConfirmedQuantity == totalConfirmedQuantity) &&
            (identical(other.totalConfirmedRejected, totalConfirmedRejected) ||
                other.totalConfirmedRejected == totalConfirmedRejected) &&
            (identical(other.totalDifference, totalDifference) ||
                other.totalDifference == totalDifference));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        sessionId,
        sessionName,
        sessionType,
        isActive,
        isFinal,
        storeId,
        storeName,
        shipmentId,
        shipmentNumber,
        createdAt,
        completedAt,
        durationMinutes,
        createdBy,
        createdByName,
        const DeepCollectionEquality().hash(_members),
        memberCount,
        const DeepCollectionEquality().hash(_items),
        totalScannedQuantity,
        totalScannedRejected,
        totalConfirmedQuantity,
        totalConfirmedRejected,
        totalDifference
      ]);

  /// Create a copy of SessionHistoryItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionHistoryItemImplCopyWith<_$SessionHistoryItemImpl> get copyWith =>
      __$$SessionHistoryItemImplCopyWithImpl<_$SessionHistoryItemImpl>(
          this, _$identity);
}

abstract class _SessionHistoryItem extends SessionHistoryItem {
  const factory _SessionHistoryItem(
      {required final String sessionId,
      required final String sessionName,
      required final String sessionType,
      required final bool isActive,
      required final bool isFinal,
      required final String storeId,
      required final String storeName,
      final String? shipmentId,
      final String? shipmentNumber,
      required final String createdAt,
      final String? completedAt,
      final int? durationMinutes,
      required final String createdBy,
      required final String createdByName,
      required final List<SessionHistoryMember> members,
      required final int memberCount,
      required final List<SessionHistoryItemDetail> items,
      required final int totalScannedQuantity,
      required final int totalScannedRejected,
      final int? totalConfirmedQuantity,
      final int? totalConfirmedRejected,
      final int? totalDifference}) = _$SessionHistoryItemImpl;
  const _SessionHistoryItem._() : super._();

  @override
  String get sessionId;
  @override
  String get sessionName;
  @override
  String get sessionType;
  @override
  bool get isActive;
  @override
  bool get isFinal;
  @override
  String get storeId;
  @override
  String get storeName;
  @override
  String? get shipmentId;
  @override
  String? get shipmentNumber;
  @override
  String get createdAt;
  @override
  String? get completedAt;
  @override
  int? get durationMinutes;
  @override
  String get createdBy;
  @override
  String get createdByName;
  @override
  List<SessionHistoryMember> get members;
  @override
  int get memberCount;
  @override
  List<SessionHistoryItemDetail> get items;

  /// Totals - Scanned by employees
  @override
  int get totalScannedQuantity;
  @override
  int get totalScannedRejected;

  /// Totals - Confirmed by manager (null if not submitted)
  @override
  int? get totalConfirmedQuantity;
  @override
  int? get totalConfirmedRejected;

  /// Counting specific - total difference from expected
  @override
  int? get totalDifference;

  /// Create a copy of SessionHistoryItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionHistoryItemImplCopyWith<_$SessionHistoryItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SessionHistoryResponse {
  List<SessionHistoryItem> get sessions => throw _privateConstructorUsedError;
  int get totalCount => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;
  int get offset => throw _privateConstructorUsedError;

  /// Create a copy of SessionHistoryResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionHistoryResponseCopyWith<SessionHistoryResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionHistoryResponseCopyWith<$Res> {
  factory $SessionHistoryResponseCopyWith(SessionHistoryResponse value,
          $Res Function(SessionHistoryResponse) then) =
      _$SessionHistoryResponseCopyWithImpl<$Res, SessionHistoryResponse>;
  @useResult
  $Res call(
      {List<SessionHistoryItem> sessions,
      int totalCount,
      int limit,
      int offset});
}

/// @nodoc
class _$SessionHistoryResponseCopyWithImpl<$Res,
        $Val extends SessionHistoryResponse>
    implements $SessionHistoryResponseCopyWith<$Res> {
  _$SessionHistoryResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SessionHistoryResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessions = null,
    Object? totalCount = null,
    Object? limit = null,
    Object? offset = null,
  }) {
    return _then(_value.copyWith(
      sessions: null == sessions
          ? _value.sessions
          : sessions // ignore: cast_nullable_to_non_nullable
              as List<SessionHistoryItem>,
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
abstract class _$$SessionHistoryResponseImplCopyWith<$Res>
    implements $SessionHistoryResponseCopyWith<$Res> {
  factory _$$SessionHistoryResponseImplCopyWith(
          _$SessionHistoryResponseImpl value,
          $Res Function(_$SessionHistoryResponseImpl) then) =
      __$$SessionHistoryResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<SessionHistoryItem> sessions,
      int totalCount,
      int limit,
      int offset});
}

/// @nodoc
class __$$SessionHistoryResponseImplCopyWithImpl<$Res>
    extends _$SessionHistoryResponseCopyWithImpl<$Res,
        _$SessionHistoryResponseImpl>
    implements _$$SessionHistoryResponseImplCopyWith<$Res> {
  __$$SessionHistoryResponseImplCopyWithImpl(
      _$SessionHistoryResponseImpl _value,
      $Res Function(_$SessionHistoryResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of SessionHistoryResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessions = null,
    Object? totalCount = null,
    Object? limit = null,
    Object? offset = null,
  }) {
    return _then(_$SessionHistoryResponseImpl(
      sessions: null == sessions
          ? _value._sessions
          : sessions // ignore: cast_nullable_to_non_nullable
              as List<SessionHistoryItem>,
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

class _$SessionHistoryResponseImpl extends _SessionHistoryResponse {
  const _$SessionHistoryResponseImpl(
      {required final List<SessionHistoryItem> sessions,
      required this.totalCount,
      required this.limit,
      required this.offset})
      : _sessions = sessions,
        super._();

  final List<SessionHistoryItem> _sessions;
  @override
  List<SessionHistoryItem> get sessions {
    if (_sessions is EqualUnmodifiableListView) return _sessions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sessions);
  }

  @override
  final int totalCount;
  @override
  final int limit;
  @override
  final int offset;

  @override
  String toString() {
    return 'SessionHistoryResponse(sessions: $sessions, totalCount: $totalCount, limit: $limit, offset: $offset)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionHistoryResponseImpl &&
            const DeepCollectionEquality().equals(other._sessions, _sessions) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.offset, offset) || other.offset == offset));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_sessions),
      totalCount,
      limit,
      offset);

  /// Create a copy of SessionHistoryResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionHistoryResponseImplCopyWith<_$SessionHistoryResponseImpl>
      get copyWith => __$$SessionHistoryResponseImplCopyWithImpl<
          _$SessionHistoryResponseImpl>(this, _$identity);
}

abstract class _SessionHistoryResponse extends SessionHistoryResponse {
  const factory _SessionHistoryResponse(
      {required final List<SessionHistoryItem> sessions,
      required final int totalCount,
      required final int limit,
      required final int offset}) = _$SessionHistoryResponseImpl;
  const _SessionHistoryResponse._() : super._();

  @override
  List<SessionHistoryItem> get sessions;
  @override
  int get totalCount;
  @override
  int get limit;
  @override
  int get offset;

  /// Create a copy of SessionHistoryResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionHistoryResponseImplCopyWith<_$SessionHistoryResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
