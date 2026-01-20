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
mixin _$SessionHistoryUser {
  String get userId => throw _privateConstructorUsedError;
  String get firstName => throw _privateConstructorUsedError;
  String get lastName => throw _privateConstructorUsedError;
  String? get profileImage => throw _privateConstructorUsedError;

  /// Create a copy of SessionHistoryUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionHistoryUserCopyWith<SessionHistoryUser> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionHistoryUserCopyWith<$Res> {
  factory $SessionHistoryUserCopyWith(
          SessionHistoryUser value, $Res Function(SessionHistoryUser) then) =
      _$SessionHistoryUserCopyWithImpl<$Res, SessionHistoryUser>;
  @useResult
  $Res call(
      {String userId, String firstName, String lastName, String? profileImage});
}

/// @nodoc
class _$SessionHistoryUserCopyWithImpl<$Res, $Val extends SessionHistoryUser>
    implements $SessionHistoryUserCopyWith<$Res> {
  _$SessionHistoryUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SessionHistoryUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? profileImage = freezed,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      profileImage: freezed == profileImage
          ? _value.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SessionHistoryUserImplCopyWith<$Res>
    implements $SessionHistoryUserCopyWith<$Res> {
  factory _$$SessionHistoryUserImplCopyWith(_$SessionHistoryUserImpl value,
          $Res Function(_$SessionHistoryUserImpl) then) =
      __$$SessionHistoryUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId, String firstName, String lastName, String? profileImage});
}

/// @nodoc
class __$$SessionHistoryUserImplCopyWithImpl<$Res>
    extends _$SessionHistoryUserCopyWithImpl<$Res, _$SessionHistoryUserImpl>
    implements _$$SessionHistoryUserImplCopyWith<$Res> {
  __$$SessionHistoryUserImplCopyWithImpl(_$SessionHistoryUserImpl _value,
      $Res Function(_$SessionHistoryUserImpl) _then)
      : super(_value, _then);

  /// Create a copy of SessionHistoryUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? profileImage = freezed,
  }) {
    return _then(_$SessionHistoryUserImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      profileImage: freezed == profileImage
          ? _value.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$SessionHistoryUserImpl implements _SessionHistoryUser {
  const _$SessionHistoryUserImpl(
      {required this.userId,
      required this.firstName,
      required this.lastName,
      this.profileImage});

  @override
  final String userId;
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String? profileImage;

  @override
  String toString() {
    return 'SessionHistoryUser(userId: $userId, firstName: $firstName, lastName: $lastName, profileImage: $profileImage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionHistoryUserImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.profileImage, profileImage) ||
                other.profileImage == profileImage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, userId, firstName, lastName, profileImage);

  /// Create a copy of SessionHistoryUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionHistoryUserImplCopyWith<_$SessionHistoryUserImpl> get copyWith =>
      __$$SessionHistoryUserImplCopyWithImpl<_$SessionHistoryUserImpl>(
          this, _$identity);
}

abstract class _SessionHistoryUser implements SessionHistoryUser {
  const factory _SessionHistoryUser(
      {required final String userId,
      required final String firstName,
      required final String lastName,
      final String? profileImage}) = _$SessionHistoryUserImpl;

  @override
  String get userId;
  @override
  String get firstName;
  @override
  String get lastName;
  @override
  String? get profileImage;

  /// Create a copy of SessionHistoryUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionHistoryUserImplCopyWith<_$SessionHistoryUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SessionHistoryMember {
  String get oderId => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;
  String get joinedAt => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  String? get profileImage =>
      throw _privateConstructorUsedError; // V2: Extended user info
  String? get firstName => throw _privateConstructorUsedError;
  String? get lastName => throw _privateConstructorUsedError;

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
  $Res call(
      {String oderId,
      String userName,
      String joinedAt,
      bool isActive,
      String? profileImage,
      String? firstName,
      String? lastName});
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
    Object? profileImage = freezed,
    Object? firstName = freezed,
    Object? lastName = freezed,
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
      profileImage: freezed == profileImage
          ? _value.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as String?,
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
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
  $Res call(
      {String oderId,
      String userName,
      String joinedAt,
      bool isActive,
      String? profileImage,
      String? firstName,
      String? lastName});
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
    Object? profileImage = freezed,
    Object? firstName = freezed,
    Object? lastName = freezed,
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
      profileImage: freezed == profileImage
          ? _value.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as String?,
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$SessionHistoryMemberImpl implements _SessionHistoryMember {
  const _$SessionHistoryMemberImpl(
      {required this.oderId,
      required this.userName,
      required this.joinedAt,
      required this.isActive,
      this.profileImage,
      this.firstName,
      this.lastName});

  @override
  final String oderId;
  @override
  final String userName;
  @override
  final String joinedAt;
  @override
  final bool isActive;
  @override
  final String? profileImage;
// V2: Extended user info
  @override
  final String? firstName;
  @override
  final String? lastName;

  @override
  String toString() {
    return 'SessionHistoryMember(oderId: $oderId, userName: $userName, joinedAt: $joinedAt, isActive: $isActive, profileImage: $profileImage, firstName: $firstName, lastName: $lastName)';
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
                other.isActive == isActive) &&
            (identical(other.profileImage, profileImage) ||
                other.profileImage == profileImage) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName));
  }

  @override
  int get hashCode => Object.hash(runtimeType, oderId, userName, joinedAt,
      isActive, profileImage, firstName, lastName);

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
      required final bool isActive,
      final String? profileImage,
      final String? firstName,
      final String? lastName}) = _$SessionHistoryMemberImpl;

  @override
  String get oderId;
  @override
  String get userName;
  @override
  String get joinedAt;
  @override
  bool get isActive;
  @override
  String? get profileImage; // V2: Extended user info
  @override
  String? get firstName;
  @override
  String? get lastName;

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
  int get quantityRejected =>
      throw _privateConstructorUsedError; // V2: Extended user info
  String? get firstName => throw _privateConstructorUsedError;
  String? get lastName => throw _privateConstructorUsedError;
  String? get profileImage => throw _privateConstructorUsedError;

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
      {String userId,
      String userName,
      int quantity,
      int quantityRejected,
      String? firstName,
      String? lastName,
      String? profileImage});
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
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? profileImage = freezed,
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
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      profileImage: freezed == profileImage
          ? _value.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as String?,
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
      {String userId,
      String userName,
      int quantity,
      int quantityRejected,
      String? firstName,
      String? lastName,
      String? profileImage});
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
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? profileImage = freezed,
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
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      profileImage: freezed == profileImage
          ? _value.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ScannedByInfoImpl implements _ScannedByInfo {
  const _$ScannedByInfoImpl(
      {required this.userId,
      required this.userName,
      required this.quantity,
      required this.quantityRejected,
      this.firstName,
      this.lastName,
      this.profileImage});

  @override
  final String userId;
  @override
  final String userName;
  @override
  final int quantity;
  @override
  final int quantityRejected;
// V2: Extended user info
  @override
  final String? firstName;
  @override
  final String? lastName;
  @override
  final String? profileImage;

  @override
  String toString() {
    return 'ScannedByInfo(userId: $userId, userName: $userName, quantity: $quantity, quantityRejected: $quantityRejected, firstName: $firstName, lastName: $lastName, profileImage: $profileImage)';
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
                other.quantityRejected == quantityRejected) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.profileImage, profileImage) ||
                other.profileImage == profileImage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, userId, userName, quantity,
      quantityRejected, firstName, lastName, profileImage);

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
      required final int quantityRejected,
      final String? firstName,
      final String? lastName,
      final String? profileImage}) = _$ScannedByInfoImpl;

  @override
  String get userId;
  @override
  String get userName;
  @override
  int get quantity;
  @override
  int get quantityRejected; // V2: Extended user info
  @override
  String? get firstName;
  @override
  String? get lastName;
  @override
  String? get profileImage;

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
  String? get sku => throw _privateConstructorUsedError; // v3 variant fields
  String? get variantId => throw _privateConstructorUsedError;
  String? get variantName => throw _privateConstructorUsedError;
  String? get displayName => throw _privateConstructorUsedError;
  bool get hasVariants => throw _privateConstructorUsedError;
  String? get variantSku => throw _privateConstructorUsedError;
  String? get displaySku => throw _privateConstructorUsedError;

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
      String? variantId,
      String? variantName,
      String? displayName,
      bool hasVariants,
      String? variantSku,
      String? displaySku,
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
    Object? variantId = freezed,
    Object? variantName = freezed,
    Object? displayName = freezed,
    Object? hasVariants = null,
    Object? variantSku = freezed,
    Object? displaySku = freezed,
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
      variantSku: freezed == variantSku
          ? _value.variantSku
          : variantSku // ignore: cast_nullable_to_non_nullable
              as String?,
      displaySku: freezed == displaySku
          ? _value.displaySku
          : displaySku // ignore: cast_nullable_to_non_nullable
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
      String? variantId,
      String? variantName,
      String? displayName,
      bool hasVariants,
      String? variantSku,
      String? displaySku,
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
    Object? variantId = freezed,
    Object? variantName = freezed,
    Object? displayName = freezed,
    Object? hasVariants = null,
    Object? variantSku = freezed,
    Object? displaySku = freezed,
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
      variantSku: freezed == variantSku
          ? _value.variantSku
          : variantSku // ignore: cast_nullable_to_non_nullable
              as String?,
      displaySku: freezed == displaySku
          ? _value.displaySku
          : displaySku // ignore: cast_nullable_to_non_nullable
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
      this.variantId,
      this.variantName,
      this.displayName,
      this.hasVariants = false,
      this.variantSku,
      this.displaySku,
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
  final String? variantSku;
  @override
  final String? displaySku;

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
    return 'SessionHistoryItemDetail(productId: $productId, productName: $productName, sku: $sku, variantId: $variantId, variantName: $variantName, displayName: $displayName, hasVariants: $hasVariants, variantSku: $variantSku, displaySku: $displaySku, scannedQuantity: $scannedQuantity, scannedRejected: $scannedRejected, scannedBy: $scannedBy, confirmedQuantity: $confirmedQuantity, confirmedRejected: $confirmedRejected, quantityExpected: $quantityExpected, quantityDifference: $quantityDifference)';
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
            (identical(other.variantId, variantId) ||
                other.variantId == variantId) &&
            (identical(other.variantName, variantName) ||
                other.variantName == variantName) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.hasVariants, hasVariants) ||
                other.hasVariants == hasVariants) &&
            (identical(other.variantSku, variantSku) ||
                other.variantSku == variantSku) &&
            (identical(other.displaySku, displaySku) ||
                other.displaySku == displaySku) &&
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
      variantId,
      variantName,
      displayName,
      hasVariants,
      variantSku,
      displaySku,
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
      final String? variantId,
      final String? variantName,
      final String? displayName,
      final bool hasVariants,
      final String? variantSku,
      final String? displaySku,
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
  String? get sku; // v3 variant fields
  @override
  String? get variantId;
  @override
  String? get variantName;
  @override
  String? get displayName;
  @override
  bool get hasVariants;
  @override
  String? get variantSku;
  @override
  String? get displaySku;

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
mixin _$StockSnapshotItem {
  String get productId => throw _privateConstructorUsedError;
  String get sku => throw _privateConstructorUsedError;
  String get productName => throw _privateConstructorUsedError;
  int get quantityBefore => throw _privateConstructorUsedError;
  int get quantityReceived => throw _privateConstructorUsedError;
  int get quantityAfter => throw _privateConstructorUsedError;

  /// true = new product (needs display), false = restock
  bool get needsDisplay =>
      throw _privateConstructorUsedError; // v3 variant fields
  String? get variantId => throw _privateConstructorUsedError;
  String? get variantName => throw _privateConstructorUsedError;
  String? get displayName => throw _privateConstructorUsedError;

  /// Create a copy of StockSnapshotItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StockSnapshotItemCopyWith<StockSnapshotItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StockSnapshotItemCopyWith<$Res> {
  factory $StockSnapshotItemCopyWith(
          StockSnapshotItem value, $Res Function(StockSnapshotItem) then) =
      _$StockSnapshotItemCopyWithImpl<$Res, StockSnapshotItem>;
  @useResult
  $Res call(
      {String productId,
      String sku,
      String productName,
      int quantityBefore,
      int quantityReceived,
      int quantityAfter,
      bool needsDisplay,
      String? variantId,
      String? variantName,
      String? displayName});
}

/// @nodoc
class _$StockSnapshotItemCopyWithImpl<$Res, $Val extends StockSnapshotItem>
    implements $StockSnapshotItemCopyWith<$Res> {
  _$StockSnapshotItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StockSnapshotItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? sku = null,
    Object? productName = null,
    Object? quantityBefore = null,
    Object? quantityReceived = null,
    Object? quantityAfter = null,
    Object? needsDisplay = null,
    Object? variantId = freezed,
    Object? variantName = freezed,
    Object? displayName = freezed,
  }) {
    return _then(_value.copyWith(
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      sku: null == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StockSnapshotItemImplCopyWith<$Res>
    implements $StockSnapshotItemCopyWith<$Res> {
  factory _$$StockSnapshotItemImplCopyWith(_$StockSnapshotItemImpl value,
          $Res Function(_$StockSnapshotItemImpl) then) =
      __$$StockSnapshotItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String productId,
      String sku,
      String productName,
      int quantityBefore,
      int quantityReceived,
      int quantityAfter,
      bool needsDisplay,
      String? variantId,
      String? variantName,
      String? displayName});
}

/// @nodoc
class __$$StockSnapshotItemImplCopyWithImpl<$Res>
    extends _$StockSnapshotItemCopyWithImpl<$Res, _$StockSnapshotItemImpl>
    implements _$$StockSnapshotItemImplCopyWith<$Res> {
  __$$StockSnapshotItemImplCopyWithImpl(_$StockSnapshotItemImpl _value,
      $Res Function(_$StockSnapshotItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of StockSnapshotItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? sku = null,
    Object? productName = null,
    Object? quantityBefore = null,
    Object? quantityReceived = null,
    Object? quantityAfter = null,
    Object? needsDisplay = null,
    Object? variantId = freezed,
    Object? variantName = freezed,
    Object? displayName = freezed,
  }) {
    return _then(_$StockSnapshotItemImpl(
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      sku: null == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String,
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
    ));
  }
}

/// @nodoc

class _$StockSnapshotItemImpl extends _StockSnapshotItem {
  const _$StockSnapshotItemImpl(
      {required this.productId,
      required this.sku,
      required this.productName,
      required this.quantityBefore,
      required this.quantityReceived,
      required this.quantityAfter,
      required this.needsDisplay,
      this.variantId,
      this.variantName,
      this.displayName})
      : super._();

  @override
  final String productId;
  @override
  final String sku;
  @override
  final String productName;
  @override
  final int quantityBefore;
  @override
  final int quantityReceived;
  @override
  final int quantityAfter;

  /// true = new product (needs display), false = restock
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
  String toString() {
    return 'StockSnapshotItem(productId: $productId, sku: $sku, productName: $productName, quantityBefore: $quantityBefore, quantityReceived: $quantityReceived, quantityAfter: $quantityAfter, needsDisplay: $needsDisplay, variantId: $variantId, variantName: $variantName, displayName: $displayName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StockSnapshotItemImpl &&
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
                other.displayName == displayName));
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
      displayName);

  /// Create a copy of StockSnapshotItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StockSnapshotItemImplCopyWith<_$StockSnapshotItemImpl> get copyWith =>
      __$$StockSnapshotItemImplCopyWithImpl<_$StockSnapshotItemImpl>(
          this, _$identity);
}

abstract class _StockSnapshotItem extends StockSnapshotItem {
  const factory _StockSnapshotItem(
      {required final String productId,
      required final String sku,
      required final String productName,
      required final int quantityBefore,
      required final int quantityReceived,
      required final int quantityAfter,
      required final bool needsDisplay,
      final String? variantId,
      final String? variantName,
      final String? displayName}) = _$StockSnapshotItemImpl;
  const _StockSnapshotItem._() : super._();

  @override
  String get productId;
  @override
  String get sku;
  @override
  String get productName;
  @override
  int get quantityBefore;
  @override
  int get quantityReceived;
  @override
  int get quantityAfter;

  /// true = new product (needs display), false = restock
  @override
  bool get needsDisplay; // v3 variant fields
  @override
  String? get variantId;
  @override
  String? get variantName;
  @override
  String? get displayName;

  /// Create a copy of StockSnapshotItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StockSnapshotItemImplCopyWith<_$StockSnapshotItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ReceivingInfo {
  String get receivingId => throw _privateConstructorUsedError;
  String get receivingNumber => throw _privateConstructorUsedError;
  String get receivedAt => throw _privateConstructorUsedError;
  List<StockSnapshotItem> get stockSnapshot =>
      throw _privateConstructorUsedError;
  int get newProductsCount => throw _privateConstructorUsedError;
  int get restockProductsCount => throw _privateConstructorUsedError;

  /// Create a copy of ReceivingInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReceivingInfoCopyWith<ReceivingInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReceivingInfoCopyWith<$Res> {
  factory $ReceivingInfoCopyWith(
          ReceivingInfo value, $Res Function(ReceivingInfo) then) =
      _$ReceivingInfoCopyWithImpl<$Res, ReceivingInfo>;
  @useResult
  $Res call(
      {String receivingId,
      String receivingNumber,
      String receivedAt,
      List<StockSnapshotItem> stockSnapshot,
      int newProductsCount,
      int restockProductsCount});
}

/// @nodoc
class _$ReceivingInfoCopyWithImpl<$Res, $Val extends ReceivingInfo>
    implements $ReceivingInfoCopyWith<$Res> {
  _$ReceivingInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReceivingInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? receivingId = null,
    Object? receivingNumber = null,
    Object? receivedAt = null,
    Object? stockSnapshot = null,
    Object? newProductsCount = null,
    Object? restockProductsCount = null,
  }) {
    return _then(_value.copyWith(
      receivingId: null == receivingId
          ? _value.receivingId
          : receivingId // ignore: cast_nullable_to_non_nullable
              as String,
      receivingNumber: null == receivingNumber
          ? _value.receivingNumber
          : receivingNumber // ignore: cast_nullable_to_non_nullable
              as String,
      receivedAt: null == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as String,
      stockSnapshot: null == stockSnapshot
          ? _value.stockSnapshot
          : stockSnapshot // ignore: cast_nullable_to_non_nullable
              as List<StockSnapshotItem>,
      newProductsCount: null == newProductsCount
          ? _value.newProductsCount
          : newProductsCount // ignore: cast_nullable_to_non_nullable
              as int,
      restockProductsCount: null == restockProductsCount
          ? _value.restockProductsCount
          : restockProductsCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReceivingInfoImplCopyWith<$Res>
    implements $ReceivingInfoCopyWith<$Res> {
  factory _$$ReceivingInfoImplCopyWith(
          _$ReceivingInfoImpl value, $Res Function(_$ReceivingInfoImpl) then) =
      __$$ReceivingInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String receivingId,
      String receivingNumber,
      String receivedAt,
      List<StockSnapshotItem> stockSnapshot,
      int newProductsCount,
      int restockProductsCount});
}

/// @nodoc
class __$$ReceivingInfoImplCopyWithImpl<$Res>
    extends _$ReceivingInfoCopyWithImpl<$Res, _$ReceivingInfoImpl>
    implements _$$ReceivingInfoImplCopyWith<$Res> {
  __$$ReceivingInfoImplCopyWithImpl(
      _$ReceivingInfoImpl _value, $Res Function(_$ReceivingInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReceivingInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? receivingId = null,
    Object? receivingNumber = null,
    Object? receivedAt = null,
    Object? stockSnapshot = null,
    Object? newProductsCount = null,
    Object? restockProductsCount = null,
  }) {
    return _then(_$ReceivingInfoImpl(
      receivingId: null == receivingId
          ? _value.receivingId
          : receivingId // ignore: cast_nullable_to_non_nullable
              as String,
      receivingNumber: null == receivingNumber
          ? _value.receivingNumber
          : receivingNumber // ignore: cast_nullable_to_non_nullable
              as String,
      receivedAt: null == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as String,
      stockSnapshot: null == stockSnapshot
          ? _value._stockSnapshot
          : stockSnapshot // ignore: cast_nullable_to_non_nullable
              as List<StockSnapshotItem>,
      newProductsCount: null == newProductsCount
          ? _value.newProductsCount
          : newProductsCount // ignore: cast_nullable_to_non_nullable
              as int,
      restockProductsCount: null == restockProductsCount
          ? _value.restockProductsCount
          : restockProductsCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$ReceivingInfoImpl extends _ReceivingInfo {
  const _$ReceivingInfoImpl(
      {required this.receivingId,
      required this.receivingNumber,
      required this.receivedAt,
      required final List<StockSnapshotItem> stockSnapshot,
      required this.newProductsCount,
      required this.restockProductsCount})
      : _stockSnapshot = stockSnapshot,
        super._();

  @override
  final String receivingId;
  @override
  final String receivingNumber;
  @override
  final String receivedAt;
  final List<StockSnapshotItem> _stockSnapshot;
  @override
  List<StockSnapshotItem> get stockSnapshot {
    if (_stockSnapshot is EqualUnmodifiableListView) return _stockSnapshot;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_stockSnapshot);
  }

  @override
  final int newProductsCount;
  @override
  final int restockProductsCount;

  @override
  String toString() {
    return 'ReceivingInfo(receivingId: $receivingId, receivingNumber: $receivingNumber, receivedAt: $receivedAt, stockSnapshot: $stockSnapshot, newProductsCount: $newProductsCount, restockProductsCount: $restockProductsCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReceivingInfoImpl &&
            (identical(other.receivingId, receivingId) ||
                other.receivingId == receivingId) &&
            (identical(other.receivingNumber, receivingNumber) ||
                other.receivingNumber == receivingNumber) &&
            (identical(other.receivedAt, receivedAt) ||
                other.receivedAt == receivedAt) &&
            const DeepCollectionEquality()
                .equals(other._stockSnapshot, _stockSnapshot) &&
            (identical(other.newProductsCount, newProductsCount) ||
                other.newProductsCount == newProductsCount) &&
            (identical(other.restockProductsCount, restockProductsCount) ||
                other.restockProductsCount == restockProductsCount));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      receivingId,
      receivingNumber,
      receivedAt,
      const DeepCollectionEquality().hash(_stockSnapshot),
      newProductsCount,
      restockProductsCount);

  /// Create a copy of ReceivingInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReceivingInfoImplCopyWith<_$ReceivingInfoImpl> get copyWith =>
      __$$ReceivingInfoImplCopyWithImpl<_$ReceivingInfoImpl>(this, _$identity);
}

abstract class _ReceivingInfo extends ReceivingInfo {
  const factory _ReceivingInfo(
      {required final String receivingId,
      required final String receivingNumber,
      required final String receivedAt,
      required final List<StockSnapshotItem> stockSnapshot,
      required final int newProductsCount,
      required final int restockProductsCount}) = _$ReceivingInfoImpl;
  const _ReceivingInfo._() : super._();

  @override
  String get receivingId;
  @override
  String get receivingNumber;
  @override
  String get receivedAt;
  @override
  List<StockSnapshotItem> get stockSnapshot;
  @override
  int get newProductsCount;
  @override
  int get restockProductsCount;

  /// Create a copy of ReceivingInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReceivingInfoImplCopyWith<_$ReceivingInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$MergedSessionItem {
  String get productId => throw _privateConstructorUsedError;
  String get sku => throw _privateConstructorUsedError;
  String get productName => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  int get quantityRejected => throw _privateConstructorUsedError;
  SessionHistoryUser get scannedBy =>
      throw _privateConstructorUsedError; // v3 variant fields
  String? get variantId => throw _privateConstructorUsedError;
  String? get variantName => throw _privateConstructorUsedError;
  String? get displayName => throw _privateConstructorUsedError;
  bool get hasVariants => throw _privateConstructorUsedError;

  /// Create a copy of MergedSessionItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MergedSessionItemCopyWith<MergedSessionItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MergedSessionItemCopyWith<$Res> {
  factory $MergedSessionItemCopyWith(
          MergedSessionItem value, $Res Function(MergedSessionItem) then) =
      _$MergedSessionItemCopyWithImpl<$Res, MergedSessionItem>;
  @useResult
  $Res call(
      {String productId,
      String sku,
      String productName,
      int quantity,
      int quantityRejected,
      SessionHistoryUser scannedBy,
      String? variantId,
      String? variantName,
      String? displayName,
      bool hasVariants});

  $SessionHistoryUserCopyWith<$Res> get scannedBy;
}

/// @nodoc
class _$MergedSessionItemCopyWithImpl<$Res, $Val extends MergedSessionItem>
    implements $MergedSessionItemCopyWith<$Res> {
  _$MergedSessionItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MergedSessionItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? sku = null,
    Object? productName = null,
    Object? quantity = null,
    Object? quantityRejected = null,
    Object? scannedBy = null,
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
      sku: null == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      quantityRejected: null == quantityRejected
          ? _value.quantityRejected
          : quantityRejected // ignore: cast_nullable_to_non_nullable
              as int,
      scannedBy: null == scannedBy
          ? _value.scannedBy
          : scannedBy // ignore: cast_nullable_to_non_nullable
              as SessionHistoryUser,
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

  /// Create a copy of MergedSessionItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SessionHistoryUserCopyWith<$Res> get scannedBy {
    return $SessionHistoryUserCopyWith<$Res>(_value.scannedBy, (value) {
      return _then(_value.copyWith(scannedBy: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MergedSessionItemImplCopyWith<$Res>
    implements $MergedSessionItemCopyWith<$Res> {
  factory _$$MergedSessionItemImplCopyWith(_$MergedSessionItemImpl value,
          $Res Function(_$MergedSessionItemImpl) then) =
      __$$MergedSessionItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String productId,
      String sku,
      String productName,
      int quantity,
      int quantityRejected,
      SessionHistoryUser scannedBy,
      String? variantId,
      String? variantName,
      String? displayName,
      bool hasVariants});

  @override
  $SessionHistoryUserCopyWith<$Res> get scannedBy;
}

/// @nodoc
class __$$MergedSessionItemImplCopyWithImpl<$Res>
    extends _$MergedSessionItemCopyWithImpl<$Res, _$MergedSessionItemImpl>
    implements _$$MergedSessionItemImplCopyWith<$Res> {
  __$$MergedSessionItemImplCopyWithImpl(_$MergedSessionItemImpl _value,
      $Res Function(_$MergedSessionItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of MergedSessionItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? sku = null,
    Object? productName = null,
    Object? quantity = null,
    Object? quantityRejected = null,
    Object? scannedBy = null,
    Object? variantId = freezed,
    Object? variantName = freezed,
    Object? displayName = freezed,
    Object? hasVariants = null,
  }) {
    return _then(_$MergedSessionItemImpl(
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      sku: null == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      quantityRejected: null == quantityRejected
          ? _value.quantityRejected
          : quantityRejected // ignore: cast_nullable_to_non_nullable
              as int,
      scannedBy: null == scannedBy
          ? _value.scannedBy
          : scannedBy // ignore: cast_nullable_to_non_nullable
              as SessionHistoryUser,
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

class _$MergedSessionItemImpl extends _MergedSessionItem {
  const _$MergedSessionItemImpl(
      {required this.productId,
      required this.sku,
      required this.productName,
      required this.quantity,
      required this.quantityRejected,
      required this.scannedBy,
      this.variantId,
      this.variantName,
      this.displayName,
      this.hasVariants = false})
      : super._();

  @override
  final String productId;
  @override
  final String sku;
  @override
  final String productName;
  @override
  final int quantity;
  @override
  final int quantityRejected;
  @override
  final SessionHistoryUser scannedBy;
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
    return 'MergedSessionItem(productId: $productId, sku: $sku, productName: $productName, quantity: $quantity, quantityRejected: $quantityRejected, scannedBy: $scannedBy, variantId: $variantId, variantName: $variantName, displayName: $displayName, hasVariants: $hasVariants)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MergedSessionItemImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.quantityRejected, quantityRejected) ||
                other.quantityRejected == quantityRejected) &&
            (identical(other.scannedBy, scannedBy) ||
                other.scannedBy == scannedBy) &&
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
      quantity,
      quantityRejected,
      scannedBy,
      variantId,
      variantName,
      displayName,
      hasVariants);

  /// Create a copy of MergedSessionItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MergedSessionItemImplCopyWith<_$MergedSessionItemImpl> get copyWith =>
      __$$MergedSessionItemImplCopyWithImpl<_$MergedSessionItemImpl>(
          this, _$identity);
}

abstract class _MergedSessionItem extends MergedSessionItem {
  const factory _MergedSessionItem(
      {required final String productId,
      required final String sku,
      required final String productName,
      required final int quantity,
      required final int quantityRejected,
      required final SessionHistoryUser scannedBy,
      final String? variantId,
      final String? variantName,
      final String? displayName,
      final bool hasVariants}) = _$MergedSessionItemImpl;
  const _MergedSessionItem._() : super._();

  @override
  String get productId;
  @override
  String get sku;
  @override
  String get productName;
  @override
  int get quantity;
  @override
  int get quantityRejected;
  @override
  SessionHistoryUser get scannedBy; // v3 variant fields
  @override
  String? get variantId;
  @override
  String? get variantName;
  @override
  String? get displayName;
  @override
  bool get hasVariants;

  /// Create a copy of MergedSessionItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MergedSessionItemImplCopyWith<_$MergedSessionItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$MergedSessionInfo {
  String get sourceSessionId => throw _privateConstructorUsedError;
  String get sourceSessionName => throw _privateConstructorUsedError;
  String get sourceCreatedAt => throw _privateConstructorUsedError;
  SessionHistoryUser get sourceCreatedBy => throw _privateConstructorUsedError;
  List<MergedSessionItem> get items => throw _privateConstructorUsedError;
  int get itemsCount => throw _privateConstructorUsedError;
  int get totalQuantity => throw _privateConstructorUsedError;
  int get totalRejected => throw _privateConstructorUsedError;

  /// Create a copy of MergedSessionInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MergedSessionInfoCopyWith<MergedSessionInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MergedSessionInfoCopyWith<$Res> {
  factory $MergedSessionInfoCopyWith(
          MergedSessionInfo value, $Res Function(MergedSessionInfo) then) =
      _$MergedSessionInfoCopyWithImpl<$Res, MergedSessionInfo>;
  @useResult
  $Res call(
      {String sourceSessionId,
      String sourceSessionName,
      String sourceCreatedAt,
      SessionHistoryUser sourceCreatedBy,
      List<MergedSessionItem> items,
      int itemsCount,
      int totalQuantity,
      int totalRejected});

  $SessionHistoryUserCopyWith<$Res> get sourceCreatedBy;
}

/// @nodoc
class _$MergedSessionInfoCopyWithImpl<$Res, $Val extends MergedSessionInfo>
    implements $MergedSessionInfoCopyWith<$Res> {
  _$MergedSessionInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MergedSessionInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sourceSessionId = null,
    Object? sourceSessionName = null,
    Object? sourceCreatedAt = null,
    Object? sourceCreatedBy = null,
    Object? items = null,
    Object? itemsCount = null,
    Object? totalQuantity = null,
    Object? totalRejected = null,
  }) {
    return _then(_value.copyWith(
      sourceSessionId: null == sourceSessionId
          ? _value.sourceSessionId
          : sourceSessionId // ignore: cast_nullable_to_non_nullable
              as String,
      sourceSessionName: null == sourceSessionName
          ? _value.sourceSessionName
          : sourceSessionName // ignore: cast_nullable_to_non_nullable
              as String,
      sourceCreatedAt: null == sourceCreatedAt
          ? _value.sourceCreatedAt
          : sourceCreatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      sourceCreatedBy: null == sourceCreatedBy
          ? _value.sourceCreatedBy
          : sourceCreatedBy // ignore: cast_nullable_to_non_nullable
              as SessionHistoryUser,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<MergedSessionItem>,
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
    ) as $Val);
  }

  /// Create a copy of MergedSessionInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SessionHistoryUserCopyWith<$Res> get sourceCreatedBy {
    return $SessionHistoryUserCopyWith<$Res>(_value.sourceCreatedBy, (value) {
      return _then(_value.copyWith(sourceCreatedBy: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MergedSessionInfoImplCopyWith<$Res>
    implements $MergedSessionInfoCopyWith<$Res> {
  factory _$$MergedSessionInfoImplCopyWith(_$MergedSessionInfoImpl value,
          $Res Function(_$MergedSessionInfoImpl) then) =
      __$$MergedSessionInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String sourceSessionId,
      String sourceSessionName,
      String sourceCreatedAt,
      SessionHistoryUser sourceCreatedBy,
      List<MergedSessionItem> items,
      int itemsCount,
      int totalQuantity,
      int totalRejected});

  @override
  $SessionHistoryUserCopyWith<$Res> get sourceCreatedBy;
}

/// @nodoc
class __$$MergedSessionInfoImplCopyWithImpl<$Res>
    extends _$MergedSessionInfoCopyWithImpl<$Res, _$MergedSessionInfoImpl>
    implements _$$MergedSessionInfoImplCopyWith<$Res> {
  __$$MergedSessionInfoImplCopyWithImpl(_$MergedSessionInfoImpl _value,
      $Res Function(_$MergedSessionInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of MergedSessionInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sourceSessionId = null,
    Object? sourceSessionName = null,
    Object? sourceCreatedAt = null,
    Object? sourceCreatedBy = null,
    Object? items = null,
    Object? itemsCount = null,
    Object? totalQuantity = null,
    Object? totalRejected = null,
  }) {
    return _then(_$MergedSessionInfoImpl(
      sourceSessionId: null == sourceSessionId
          ? _value.sourceSessionId
          : sourceSessionId // ignore: cast_nullable_to_non_nullable
              as String,
      sourceSessionName: null == sourceSessionName
          ? _value.sourceSessionName
          : sourceSessionName // ignore: cast_nullable_to_non_nullable
              as String,
      sourceCreatedAt: null == sourceCreatedAt
          ? _value.sourceCreatedAt
          : sourceCreatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      sourceCreatedBy: null == sourceCreatedBy
          ? _value.sourceCreatedBy
          : sourceCreatedBy // ignore: cast_nullable_to_non_nullable
              as SessionHistoryUser,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<MergedSessionItem>,
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
    ));
  }
}

/// @nodoc

class _$MergedSessionInfoImpl implements _MergedSessionInfo {
  const _$MergedSessionInfoImpl(
      {required this.sourceSessionId,
      required this.sourceSessionName,
      required this.sourceCreatedAt,
      required this.sourceCreatedBy,
      required final List<MergedSessionItem> items,
      required this.itemsCount,
      required this.totalQuantity,
      required this.totalRejected})
      : _items = items;

  @override
  final String sourceSessionId;
  @override
  final String sourceSessionName;
  @override
  final String sourceCreatedAt;
  @override
  final SessionHistoryUser sourceCreatedBy;
  final List<MergedSessionItem> _items;
  @override
  List<MergedSessionItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final int itemsCount;
  @override
  final int totalQuantity;
  @override
  final int totalRejected;

  @override
  String toString() {
    return 'MergedSessionInfo(sourceSessionId: $sourceSessionId, sourceSessionName: $sourceSessionName, sourceCreatedAt: $sourceCreatedAt, sourceCreatedBy: $sourceCreatedBy, items: $items, itemsCount: $itemsCount, totalQuantity: $totalQuantity, totalRejected: $totalRejected)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MergedSessionInfoImpl &&
            (identical(other.sourceSessionId, sourceSessionId) ||
                other.sourceSessionId == sourceSessionId) &&
            (identical(other.sourceSessionName, sourceSessionName) ||
                other.sourceSessionName == sourceSessionName) &&
            (identical(other.sourceCreatedAt, sourceCreatedAt) ||
                other.sourceCreatedAt == sourceCreatedAt) &&
            (identical(other.sourceCreatedBy, sourceCreatedBy) ||
                other.sourceCreatedBy == sourceCreatedBy) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.itemsCount, itemsCount) ||
                other.itemsCount == itemsCount) &&
            (identical(other.totalQuantity, totalQuantity) ||
                other.totalQuantity == totalQuantity) &&
            (identical(other.totalRejected, totalRejected) ||
                other.totalRejected == totalRejected));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      sourceSessionId,
      sourceSessionName,
      sourceCreatedAt,
      sourceCreatedBy,
      const DeepCollectionEquality().hash(_items),
      itemsCount,
      totalQuantity,
      totalRejected);

  /// Create a copy of MergedSessionInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MergedSessionInfoImplCopyWith<_$MergedSessionInfoImpl> get copyWith =>
      __$$MergedSessionInfoImplCopyWithImpl<_$MergedSessionInfoImpl>(
          this, _$identity);
}

abstract class _MergedSessionInfo implements MergedSessionInfo {
  const factory _MergedSessionInfo(
      {required final String sourceSessionId,
      required final String sourceSessionName,
      required final String sourceCreatedAt,
      required final SessionHistoryUser sourceCreatedBy,
      required final List<MergedSessionItem> items,
      required final int itemsCount,
      required final int totalQuantity,
      required final int totalRejected}) = _$MergedSessionInfoImpl;

  @override
  String get sourceSessionId;
  @override
  String get sourceSessionName;
  @override
  String get sourceCreatedAt;
  @override
  SessionHistoryUser get sourceCreatedBy;
  @override
  List<MergedSessionItem> get items;
  @override
  int get itemsCount;
  @override
  int get totalQuantity;
  @override
  int get totalRejected;

  /// Create a copy of MergedSessionInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MergedSessionInfoImplCopyWith<_$MergedSessionInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$OriginalSessionInfo {
  List<MergedSessionItem> get items => throw _privateConstructorUsedError;
  int get itemsCount => throw _privateConstructorUsedError;
  int get totalQuantity => throw _privateConstructorUsedError;
  int get totalRejected => throw _privateConstructorUsedError;

  /// Create a copy of OriginalSessionInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OriginalSessionInfoCopyWith<OriginalSessionInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OriginalSessionInfoCopyWith<$Res> {
  factory $OriginalSessionInfoCopyWith(
          OriginalSessionInfo value, $Res Function(OriginalSessionInfo) then) =
      _$OriginalSessionInfoCopyWithImpl<$Res, OriginalSessionInfo>;
  @useResult
  $Res call(
      {List<MergedSessionItem> items,
      int itemsCount,
      int totalQuantity,
      int totalRejected});
}

/// @nodoc
class _$OriginalSessionInfoCopyWithImpl<$Res, $Val extends OriginalSessionInfo>
    implements $OriginalSessionInfoCopyWith<$Res> {
  _$OriginalSessionInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OriginalSessionInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? itemsCount = null,
    Object? totalQuantity = null,
    Object? totalRejected = null,
  }) {
    return _then(_value.copyWith(
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<MergedSessionItem>,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OriginalSessionInfoImplCopyWith<$Res>
    implements $OriginalSessionInfoCopyWith<$Res> {
  factory _$$OriginalSessionInfoImplCopyWith(_$OriginalSessionInfoImpl value,
          $Res Function(_$OriginalSessionInfoImpl) then) =
      __$$OriginalSessionInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<MergedSessionItem> items,
      int itemsCount,
      int totalQuantity,
      int totalRejected});
}

/// @nodoc
class __$$OriginalSessionInfoImplCopyWithImpl<$Res>
    extends _$OriginalSessionInfoCopyWithImpl<$Res, _$OriginalSessionInfoImpl>
    implements _$$OriginalSessionInfoImplCopyWith<$Res> {
  __$$OriginalSessionInfoImplCopyWithImpl(_$OriginalSessionInfoImpl _value,
      $Res Function(_$OriginalSessionInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of OriginalSessionInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? itemsCount = null,
    Object? totalQuantity = null,
    Object? totalRejected = null,
  }) {
    return _then(_$OriginalSessionInfoImpl(
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<MergedSessionItem>,
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
    ));
  }
}

/// @nodoc

class _$OriginalSessionInfoImpl implements _OriginalSessionInfo {
  const _$OriginalSessionInfoImpl(
      {required final List<MergedSessionItem> items,
      required this.itemsCount,
      required this.totalQuantity,
      required this.totalRejected})
      : _items = items;

  final List<MergedSessionItem> _items;
  @override
  List<MergedSessionItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final int itemsCount;
  @override
  final int totalQuantity;
  @override
  final int totalRejected;

  @override
  String toString() {
    return 'OriginalSessionInfo(items: $items, itemsCount: $itemsCount, totalQuantity: $totalQuantity, totalRejected: $totalRejected)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OriginalSessionInfoImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.itemsCount, itemsCount) ||
                other.itemsCount == itemsCount) &&
            (identical(other.totalQuantity, totalQuantity) ||
                other.totalQuantity == totalQuantity) &&
            (identical(other.totalRejected, totalRejected) ||
                other.totalRejected == totalRejected));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_items),
      itemsCount,
      totalQuantity,
      totalRejected);

  /// Create a copy of OriginalSessionInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OriginalSessionInfoImplCopyWith<_$OriginalSessionInfoImpl> get copyWith =>
      __$$OriginalSessionInfoImplCopyWithImpl<_$OriginalSessionInfoImpl>(
          this, _$identity);
}

abstract class _OriginalSessionInfo implements OriginalSessionInfo {
  const factory _OriginalSessionInfo(
      {required final List<MergedSessionItem> items,
      required final int itemsCount,
      required final int totalQuantity,
      required final int totalRejected}) = _$OriginalSessionInfoImpl;

  @override
  List<MergedSessionItem> get items;
  @override
  int get itemsCount;
  @override
  int get totalQuantity;
  @override
  int get totalRejected;

  /// Create a copy of OriginalSessionInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OriginalSessionInfoImplCopyWith<_$OriginalSessionInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$MergeInfo {
  OriginalSessionInfo get originalSession => throw _privateConstructorUsedError;
  List<MergedSessionInfo> get mergedSessions =>
      throw _privateConstructorUsedError;
  int get totalMergedSessionsCount => throw _privateConstructorUsedError;

  /// Create a copy of MergeInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MergeInfoCopyWith<MergeInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MergeInfoCopyWith<$Res> {
  factory $MergeInfoCopyWith(MergeInfo value, $Res Function(MergeInfo) then) =
      _$MergeInfoCopyWithImpl<$Res, MergeInfo>;
  @useResult
  $Res call(
      {OriginalSessionInfo originalSession,
      List<MergedSessionInfo> mergedSessions,
      int totalMergedSessionsCount});

  $OriginalSessionInfoCopyWith<$Res> get originalSession;
}

/// @nodoc
class _$MergeInfoCopyWithImpl<$Res, $Val extends MergeInfo>
    implements $MergeInfoCopyWith<$Res> {
  _$MergeInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MergeInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? originalSession = null,
    Object? mergedSessions = null,
    Object? totalMergedSessionsCount = null,
  }) {
    return _then(_value.copyWith(
      originalSession: null == originalSession
          ? _value.originalSession
          : originalSession // ignore: cast_nullable_to_non_nullable
              as OriginalSessionInfo,
      mergedSessions: null == mergedSessions
          ? _value.mergedSessions
          : mergedSessions // ignore: cast_nullable_to_non_nullable
              as List<MergedSessionInfo>,
      totalMergedSessionsCount: null == totalMergedSessionsCount
          ? _value.totalMergedSessionsCount
          : totalMergedSessionsCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  /// Create a copy of MergeInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OriginalSessionInfoCopyWith<$Res> get originalSession {
    return $OriginalSessionInfoCopyWith<$Res>(_value.originalSession, (value) {
      return _then(_value.copyWith(originalSession: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MergeInfoImplCopyWith<$Res>
    implements $MergeInfoCopyWith<$Res> {
  factory _$$MergeInfoImplCopyWith(
          _$MergeInfoImpl value, $Res Function(_$MergeInfoImpl) then) =
      __$$MergeInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {OriginalSessionInfo originalSession,
      List<MergedSessionInfo> mergedSessions,
      int totalMergedSessionsCount});

  @override
  $OriginalSessionInfoCopyWith<$Res> get originalSession;
}

/// @nodoc
class __$$MergeInfoImplCopyWithImpl<$Res>
    extends _$MergeInfoCopyWithImpl<$Res, _$MergeInfoImpl>
    implements _$$MergeInfoImplCopyWith<$Res> {
  __$$MergeInfoImplCopyWithImpl(
      _$MergeInfoImpl _value, $Res Function(_$MergeInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of MergeInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? originalSession = null,
    Object? mergedSessions = null,
    Object? totalMergedSessionsCount = null,
  }) {
    return _then(_$MergeInfoImpl(
      originalSession: null == originalSession
          ? _value.originalSession
          : originalSession // ignore: cast_nullable_to_non_nullable
              as OriginalSessionInfo,
      mergedSessions: null == mergedSessions
          ? _value._mergedSessions
          : mergedSessions // ignore: cast_nullable_to_non_nullable
              as List<MergedSessionInfo>,
      totalMergedSessionsCount: null == totalMergedSessionsCount
          ? _value.totalMergedSessionsCount
          : totalMergedSessionsCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$MergeInfoImpl implements _MergeInfo {
  const _$MergeInfoImpl(
      {required this.originalSession,
      required final List<MergedSessionInfo> mergedSessions,
      required this.totalMergedSessionsCount})
      : _mergedSessions = mergedSessions;

  @override
  final OriginalSessionInfo originalSession;
  final List<MergedSessionInfo> _mergedSessions;
  @override
  List<MergedSessionInfo> get mergedSessions {
    if (_mergedSessions is EqualUnmodifiableListView) return _mergedSessions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_mergedSessions);
  }

  @override
  final int totalMergedSessionsCount;

  @override
  String toString() {
    return 'MergeInfo(originalSession: $originalSession, mergedSessions: $mergedSessions, totalMergedSessionsCount: $totalMergedSessionsCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MergeInfoImpl &&
            (identical(other.originalSession, originalSession) ||
                other.originalSession == originalSession) &&
            const DeepCollectionEquality()
                .equals(other._mergedSessions, _mergedSessions) &&
            (identical(
                    other.totalMergedSessionsCount, totalMergedSessionsCount) ||
                other.totalMergedSessionsCount == totalMergedSessionsCount));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      originalSession,
      const DeepCollectionEquality().hash(_mergedSessions),
      totalMergedSessionsCount);

  /// Create a copy of MergeInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MergeInfoImplCopyWith<_$MergeInfoImpl> get copyWith =>
      __$$MergeInfoImplCopyWithImpl<_$MergeInfoImpl>(this, _$identity);
}

abstract class _MergeInfo implements MergeInfo {
  const factory _MergeInfo(
      {required final OriginalSessionInfo originalSession,
      required final List<MergedSessionInfo> mergedSessions,
      required final int totalMergedSessionsCount}) = _$MergeInfoImpl;

  @override
  OriginalSessionInfo get originalSession;
  @override
  List<MergedSessionInfo> get mergedSessions;
  @override
  int get totalMergedSessionsCount;

  /// Create a copy of MergeInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MergeInfoImplCopyWith<_$MergeInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
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

  /// V2: createdBy is now an object
  String get createdBy => throw _privateConstructorUsedError;
  String get createdByName => throw _privateConstructorUsedError;
  String? get createdByFirstName => throw _privateConstructorUsedError;
  String? get createdByLastName => throw _privateConstructorUsedError;
  String? get createdByProfileImage => throw _privateConstructorUsedError;
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

  /// V2: Merge info
  bool get isMergedSession => throw _privateConstructorUsedError;
  MergeInfo? get mergeInfo => throw _privateConstructorUsedError;

  /// V2: Receiving info (receiving sessions only)
  ReceivingInfo? get receivingInfo => throw _privateConstructorUsedError;

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
      String? createdByFirstName,
      String? createdByLastName,
      String? createdByProfileImage,
      List<SessionHistoryMember> members,
      int memberCount,
      List<SessionHistoryItemDetail> items,
      int totalScannedQuantity,
      int totalScannedRejected,
      int? totalConfirmedQuantity,
      int? totalConfirmedRejected,
      int? totalDifference,
      bool isMergedSession,
      MergeInfo? mergeInfo,
      ReceivingInfo? receivingInfo});

  $MergeInfoCopyWith<$Res>? get mergeInfo;
  $ReceivingInfoCopyWith<$Res>? get receivingInfo;
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
    Object? createdByFirstName = freezed,
    Object? createdByLastName = freezed,
    Object? createdByProfileImage = freezed,
    Object? members = null,
    Object? memberCount = null,
    Object? items = null,
    Object? totalScannedQuantity = null,
    Object? totalScannedRejected = null,
    Object? totalConfirmedQuantity = freezed,
    Object? totalConfirmedRejected = freezed,
    Object? totalDifference = freezed,
    Object? isMergedSession = null,
    Object? mergeInfo = freezed,
    Object? receivingInfo = freezed,
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
      createdByFirstName: freezed == createdByFirstName
          ? _value.createdByFirstName
          : createdByFirstName // ignore: cast_nullable_to_non_nullable
              as String?,
      createdByLastName: freezed == createdByLastName
          ? _value.createdByLastName
          : createdByLastName // ignore: cast_nullable_to_non_nullable
              as String?,
      createdByProfileImage: freezed == createdByProfileImage
          ? _value.createdByProfileImage
          : createdByProfileImage // ignore: cast_nullable_to_non_nullable
              as String?,
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
      isMergedSession: null == isMergedSession
          ? _value.isMergedSession
          : isMergedSession // ignore: cast_nullable_to_non_nullable
              as bool,
      mergeInfo: freezed == mergeInfo
          ? _value.mergeInfo
          : mergeInfo // ignore: cast_nullable_to_non_nullable
              as MergeInfo?,
      receivingInfo: freezed == receivingInfo
          ? _value.receivingInfo
          : receivingInfo // ignore: cast_nullable_to_non_nullable
              as ReceivingInfo?,
    ) as $Val);
  }

  /// Create a copy of SessionHistoryItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MergeInfoCopyWith<$Res>? get mergeInfo {
    if (_value.mergeInfo == null) {
      return null;
    }

    return $MergeInfoCopyWith<$Res>(_value.mergeInfo!, (value) {
      return _then(_value.copyWith(mergeInfo: value) as $Val);
    });
  }

  /// Create a copy of SessionHistoryItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ReceivingInfoCopyWith<$Res>? get receivingInfo {
    if (_value.receivingInfo == null) {
      return null;
    }

    return $ReceivingInfoCopyWith<$Res>(_value.receivingInfo!, (value) {
      return _then(_value.copyWith(receivingInfo: value) as $Val);
    });
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
      String? createdByFirstName,
      String? createdByLastName,
      String? createdByProfileImage,
      List<SessionHistoryMember> members,
      int memberCount,
      List<SessionHistoryItemDetail> items,
      int totalScannedQuantity,
      int totalScannedRejected,
      int? totalConfirmedQuantity,
      int? totalConfirmedRejected,
      int? totalDifference,
      bool isMergedSession,
      MergeInfo? mergeInfo,
      ReceivingInfo? receivingInfo});

  @override
  $MergeInfoCopyWith<$Res>? get mergeInfo;
  @override
  $ReceivingInfoCopyWith<$Res>? get receivingInfo;
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
    Object? createdByFirstName = freezed,
    Object? createdByLastName = freezed,
    Object? createdByProfileImage = freezed,
    Object? members = null,
    Object? memberCount = null,
    Object? items = null,
    Object? totalScannedQuantity = null,
    Object? totalScannedRejected = null,
    Object? totalConfirmedQuantity = freezed,
    Object? totalConfirmedRejected = freezed,
    Object? totalDifference = freezed,
    Object? isMergedSession = null,
    Object? mergeInfo = freezed,
    Object? receivingInfo = freezed,
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
      createdByFirstName: freezed == createdByFirstName
          ? _value.createdByFirstName
          : createdByFirstName // ignore: cast_nullable_to_non_nullable
              as String?,
      createdByLastName: freezed == createdByLastName
          ? _value.createdByLastName
          : createdByLastName // ignore: cast_nullable_to_non_nullable
              as String?,
      createdByProfileImage: freezed == createdByProfileImage
          ? _value.createdByProfileImage
          : createdByProfileImage // ignore: cast_nullable_to_non_nullable
              as String?,
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
      isMergedSession: null == isMergedSession
          ? _value.isMergedSession
          : isMergedSession // ignore: cast_nullable_to_non_nullable
              as bool,
      mergeInfo: freezed == mergeInfo
          ? _value.mergeInfo
          : mergeInfo // ignore: cast_nullable_to_non_nullable
              as MergeInfo?,
      receivingInfo: freezed == receivingInfo
          ? _value.receivingInfo
          : receivingInfo // ignore: cast_nullable_to_non_nullable
              as ReceivingInfo?,
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
      this.createdByFirstName,
      this.createdByLastName,
      this.createdByProfileImage,
      required final List<SessionHistoryMember> members,
      required this.memberCount,
      required final List<SessionHistoryItemDetail> items,
      required this.totalScannedQuantity,
      required this.totalScannedRejected,
      this.totalConfirmedQuantity,
      this.totalConfirmedRejected,
      this.totalDifference,
      this.isMergedSession = false,
      this.mergeInfo,
      this.receivingInfo})
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

  /// V2: createdBy is now an object
  @override
  final String createdBy;
  @override
  final String createdByName;
  @override
  final String? createdByFirstName;
  @override
  final String? createdByLastName;
  @override
  final String? createdByProfileImage;
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

  /// V2: Merge info
  @override
  @JsonKey()
  final bool isMergedSession;
  @override
  final MergeInfo? mergeInfo;

  /// V2: Receiving info (receiving sessions only)
  @override
  final ReceivingInfo? receivingInfo;

  @override
  String toString() {
    return 'SessionHistoryItem(sessionId: $sessionId, sessionName: $sessionName, sessionType: $sessionType, isActive: $isActive, isFinal: $isFinal, storeId: $storeId, storeName: $storeName, shipmentId: $shipmentId, shipmentNumber: $shipmentNumber, createdAt: $createdAt, completedAt: $completedAt, durationMinutes: $durationMinutes, createdBy: $createdBy, createdByName: $createdByName, createdByFirstName: $createdByFirstName, createdByLastName: $createdByLastName, createdByProfileImage: $createdByProfileImage, members: $members, memberCount: $memberCount, items: $items, totalScannedQuantity: $totalScannedQuantity, totalScannedRejected: $totalScannedRejected, totalConfirmedQuantity: $totalConfirmedQuantity, totalConfirmedRejected: $totalConfirmedRejected, totalDifference: $totalDifference, isMergedSession: $isMergedSession, mergeInfo: $mergeInfo, receivingInfo: $receivingInfo)';
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
            (identical(other.createdByFirstName, createdByFirstName) ||
                other.createdByFirstName == createdByFirstName) &&
            (identical(other.createdByLastName, createdByLastName) ||
                other.createdByLastName == createdByLastName) &&
            (identical(other.createdByProfileImage, createdByProfileImage) ||
                other.createdByProfileImage == createdByProfileImage) &&
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
                other.totalDifference == totalDifference) &&
            (identical(other.isMergedSession, isMergedSession) ||
                other.isMergedSession == isMergedSession) &&
            (identical(other.mergeInfo, mergeInfo) ||
                other.mergeInfo == mergeInfo) &&
            (identical(other.receivingInfo, receivingInfo) ||
                other.receivingInfo == receivingInfo));
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
        createdByFirstName,
        createdByLastName,
        createdByProfileImage,
        const DeepCollectionEquality().hash(_members),
        memberCount,
        const DeepCollectionEquality().hash(_items),
        totalScannedQuantity,
        totalScannedRejected,
        totalConfirmedQuantity,
        totalConfirmedRejected,
        totalDifference,
        isMergedSession,
        mergeInfo,
        receivingInfo
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
      final String? createdByFirstName,
      final String? createdByLastName,
      final String? createdByProfileImage,
      required final List<SessionHistoryMember> members,
      required final int memberCount,
      required final List<SessionHistoryItemDetail> items,
      required final int totalScannedQuantity,
      required final int totalScannedRejected,
      final int? totalConfirmedQuantity,
      final int? totalConfirmedRejected,
      final int? totalDifference,
      final bool isMergedSession,
      final MergeInfo? mergeInfo,
      final ReceivingInfo? receivingInfo}) = _$SessionHistoryItemImpl;
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

  /// V2: createdBy is now an object
  @override
  String get createdBy;
  @override
  String get createdByName;
  @override
  String? get createdByFirstName;
  @override
  String? get createdByLastName;
  @override
  String? get createdByProfileImage;
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

  /// V2: Merge info
  @override
  bool get isMergedSession;
  @override
  MergeInfo? get mergeInfo;

  /// V2: Receiving info (receiving sessions only)
  @override
  ReceivingInfo? get receivingInfo;

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
