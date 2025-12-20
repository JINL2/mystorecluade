// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inventory_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$InventorySession {
  String get sessionId => throw _privateConstructorUsedError;
  String get sessionName => throw _privateConstructorUsedError;
  String get sessionType =>
      throw _privateConstructorUsedError; // 'counting' or 'receiving'
  String get storeId => throw _privateConstructorUsedError;
  String get storeName => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // 'active', 'completed', 'cancelled'
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  String get createdBy => throw _privateConstructorUsedError;
  int get itemCount => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Create a copy of InventorySession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InventorySessionCopyWith<InventorySession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InventorySessionCopyWith<$Res> {
  factory $InventorySessionCopyWith(
          InventorySession value, $Res Function(InventorySession) then) =
      _$InventorySessionCopyWithImpl<$Res, InventorySession>;
  @useResult
  $Res call(
      {String sessionId,
      String sessionName,
      String sessionType,
      String storeId,
      String storeName,
      String status,
      DateTime createdAt,
      DateTime? completedAt,
      String createdBy,
      int itemCount,
      String? notes});
}

/// @nodoc
class _$InventorySessionCopyWithImpl<$Res, $Val extends InventorySession>
    implements $InventorySessionCopyWith<$Res> {
  _$InventorySessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InventorySession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? sessionName = null,
    Object? sessionType = null,
    Object? storeId = null,
    Object? storeName = null,
    Object? status = null,
    Object? createdAt = null,
    Object? completedAt = freezed,
    Object? createdBy = null,
    Object? itemCount = null,
    Object? notes = freezed,
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
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      storeName: null == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      itemCount: null == itemCount
          ? _value.itemCount
          : itemCount // ignore: cast_nullable_to_non_nullable
              as int,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InventorySessionImplCopyWith<$Res>
    implements $InventorySessionCopyWith<$Res> {
  factory _$$InventorySessionImplCopyWith(_$InventorySessionImpl value,
          $Res Function(_$InventorySessionImpl) then) =
      __$$InventorySessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String sessionId,
      String sessionName,
      String sessionType,
      String storeId,
      String storeName,
      String status,
      DateTime createdAt,
      DateTime? completedAt,
      String createdBy,
      int itemCount,
      String? notes});
}

/// @nodoc
class __$$InventorySessionImplCopyWithImpl<$Res>
    extends _$InventorySessionCopyWithImpl<$Res, _$InventorySessionImpl>
    implements _$$InventorySessionImplCopyWith<$Res> {
  __$$InventorySessionImplCopyWithImpl(_$InventorySessionImpl _value,
      $Res Function(_$InventorySessionImpl) _then)
      : super(_value, _then);

  /// Create a copy of InventorySession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? sessionName = null,
    Object? sessionType = null,
    Object? storeId = null,
    Object? storeName = null,
    Object? status = null,
    Object? createdAt = null,
    Object? completedAt = freezed,
    Object? createdBy = null,
    Object? itemCount = null,
    Object? notes = freezed,
  }) {
    return _then(_$InventorySessionImpl(
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
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      storeName: null == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      itemCount: null == itemCount
          ? _value.itemCount
          : itemCount // ignore: cast_nullable_to_non_nullable
              as int,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$InventorySessionImpl extends _InventorySession {
  const _$InventorySessionImpl(
      {required this.sessionId,
      required this.sessionName,
      required this.sessionType,
      required this.storeId,
      required this.storeName,
      required this.status,
      required this.createdAt,
      this.completedAt,
      required this.createdBy,
      this.itemCount = 0,
      this.notes})
      : super._();

  @override
  final String sessionId;
  @override
  final String sessionName;
  @override
  final String sessionType;
// 'counting' or 'receiving'
  @override
  final String storeId;
  @override
  final String storeName;
  @override
  final String status;
// 'active', 'completed', 'cancelled'
  @override
  final DateTime createdAt;
  @override
  final DateTime? completedAt;
  @override
  final String createdBy;
  @override
  @JsonKey()
  final int itemCount;
  @override
  final String? notes;

  @override
  String toString() {
    return 'InventorySession(sessionId: $sessionId, sessionName: $sessionName, sessionType: $sessionType, storeId: $storeId, storeName: $storeName, status: $status, createdAt: $createdAt, completedAt: $completedAt, createdBy: $createdBy, itemCount: $itemCount, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InventorySessionImpl &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.sessionName, sessionName) ||
                other.sessionName == sessionName) &&
            (identical(other.sessionType, sessionType) ||
                other.sessionType == sessionType) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.storeName, storeName) ||
                other.storeName == storeName) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.itemCount, itemCount) ||
                other.itemCount == itemCount) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      sessionId,
      sessionName,
      sessionType,
      storeId,
      storeName,
      status,
      createdAt,
      completedAt,
      createdBy,
      itemCount,
      notes);

  /// Create a copy of InventorySession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InventorySessionImplCopyWith<_$InventorySessionImpl> get copyWith =>
      __$$InventorySessionImplCopyWithImpl<_$InventorySessionImpl>(
          this, _$identity);
}

abstract class _InventorySession extends InventorySession {
  const factory _InventorySession(
      {required final String sessionId,
      required final String sessionName,
      required final String sessionType,
      required final String storeId,
      required final String storeName,
      required final String status,
      required final DateTime createdAt,
      final DateTime? completedAt,
      required final String createdBy,
      final int itemCount,
      final String? notes}) = _$InventorySessionImpl;
  const _InventorySession._() : super._();

  @override
  String get sessionId;
  @override
  String get sessionName;
  @override
  String get sessionType; // 'counting' or 'receiving'
  @override
  String get storeId;
  @override
  String get storeName;
  @override
  String get status; // 'active', 'completed', 'cancelled'
  @override
  DateTime get createdAt;
  @override
  DateTime? get completedAt;
  @override
  String get createdBy;
  @override
  int get itemCount;
  @override
  String? get notes;

  /// Create a copy of InventorySession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InventorySessionImplCopyWith<_$InventorySessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CreateSessionResponse {
  String get sessionId => throw _privateConstructorUsedError;
  String? get sessionName => throw _privateConstructorUsedError;
  String get sessionType => throw _privateConstructorUsedError;
  String? get shipmentId => throw _privateConstructorUsedError;
  String? get shipmentNumber => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  bool get isFinal => throw _privateConstructorUsedError;
  String get createdBy => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;

  /// Create a copy of CreateSessionResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateSessionResponseCopyWith<CreateSessionResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateSessionResponseCopyWith<$Res> {
  factory $CreateSessionResponseCopyWith(CreateSessionResponse value,
          $Res Function(CreateSessionResponse) then) =
      _$CreateSessionResponseCopyWithImpl<$Res, CreateSessionResponse>;
  @useResult
  $Res call(
      {String sessionId,
      String? sessionName,
      String sessionType,
      String? shipmentId,
      String? shipmentNumber,
      bool isActive,
      bool isFinal,
      String createdBy,
      String createdAt});
}

/// @nodoc
class _$CreateSessionResponseCopyWithImpl<$Res,
        $Val extends CreateSessionResponse>
    implements $CreateSessionResponseCopyWith<$Res> {
  _$CreateSessionResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateSessionResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? sessionName = freezed,
    Object? sessionType = null,
    Object? shipmentId = freezed,
    Object? shipmentNumber = freezed,
    Object? isActive = null,
    Object? isFinal = null,
    Object? createdBy = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      sessionName: freezed == sessionName
          ? _value.sessionName
          : sessionName // ignore: cast_nullable_to_non_nullable
              as String?,
      sessionType: null == sessionType
          ? _value.sessionType
          : sessionType // ignore: cast_nullable_to_non_nullable
              as String,
      shipmentId: freezed == shipmentId
          ? _value.shipmentId
          : shipmentId // ignore: cast_nullable_to_non_nullable
              as String?,
      shipmentNumber: freezed == shipmentNumber
          ? _value.shipmentNumber
          : shipmentNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isFinal: null == isFinal
          ? _value.isFinal
          : isFinal // ignore: cast_nullable_to_non_nullable
              as bool,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateSessionResponseImplCopyWith<$Res>
    implements $CreateSessionResponseCopyWith<$Res> {
  factory _$$CreateSessionResponseImplCopyWith(
          _$CreateSessionResponseImpl value,
          $Res Function(_$CreateSessionResponseImpl) then) =
      __$$CreateSessionResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String sessionId,
      String? sessionName,
      String sessionType,
      String? shipmentId,
      String? shipmentNumber,
      bool isActive,
      bool isFinal,
      String createdBy,
      String createdAt});
}

/// @nodoc
class __$$CreateSessionResponseImplCopyWithImpl<$Res>
    extends _$CreateSessionResponseCopyWithImpl<$Res,
        _$CreateSessionResponseImpl>
    implements _$$CreateSessionResponseImplCopyWith<$Res> {
  __$$CreateSessionResponseImplCopyWithImpl(_$CreateSessionResponseImpl _value,
      $Res Function(_$CreateSessionResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateSessionResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? sessionName = freezed,
    Object? sessionType = null,
    Object? shipmentId = freezed,
    Object? shipmentNumber = freezed,
    Object? isActive = null,
    Object? isFinal = null,
    Object? createdBy = null,
    Object? createdAt = null,
  }) {
    return _then(_$CreateSessionResponseImpl(
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      sessionName: freezed == sessionName
          ? _value.sessionName
          : sessionName // ignore: cast_nullable_to_non_nullable
              as String?,
      sessionType: null == sessionType
          ? _value.sessionType
          : sessionType // ignore: cast_nullable_to_non_nullable
              as String,
      shipmentId: freezed == shipmentId
          ? _value.shipmentId
          : shipmentId // ignore: cast_nullable_to_non_nullable
              as String?,
      shipmentNumber: freezed == shipmentNumber
          ? _value.shipmentNumber
          : shipmentNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isFinal: null == isFinal
          ? _value.isFinal
          : isFinal // ignore: cast_nullable_to_non_nullable
              as bool,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$CreateSessionResponseImpl implements _CreateSessionResponse {
  const _$CreateSessionResponseImpl(
      {required this.sessionId,
      this.sessionName,
      required this.sessionType,
      this.shipmentId,
      this.shipmentNumber,
      required this.isActive,
      required this.isFinal,
      required this.createdBy,
      required this.createdAt});

  @override
  final String sessionId;
  @override
  final String? sessionName;
  @override
  final String sessionType;
  @override
  final String? shipmentId;
  @override
  final String? shipmentNumber;
  @override
  final bool isActive;
  @override
  final bool isFinal;
  @override
  final String createdBy;
  @override
  final String createdAt;

  @override
  String toString() {
    return 'CreateSessionResponse(sessionId: $sessionId, sessionName: $sessionName, sessionType: $sessionType, shipmentId: $shipmentId, shipmentNumber: $shipmentNumber, isActive: $isActive, isFinal: $isFinal, createdBy: $createdBy, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateSessionResponseImpl &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.sessionName, sessionName) ||
                other.sessionName == sessionName) &&
            (identical(other.sessionType, sessionType) ||
                other.sessionType == sessionType) &&
            (identical(other.shipmentId, shipmentId) ||
                other.shipmentId == shipmentId) &&
            (identical(other.shipmentNumber, shipmentNumber) ||
                other.shipmentNumber == shipmentNumber) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isFinal, isFinal) || other.isFinal == isFinal) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      sessionId,
      sessionName,
      sessionType,
      shipmentId,
      shipmentNumber,
      isActive,
      isFinal,
      createdBy,
      createdAt);

  /// Create a copy of CreateSessionResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateSessionResponseImplCopyWith<_$CreateSessionResponseImpl>
      get copyWith => __$$CreateSessionResponseImplCopyWithImpl<
          _$CreateSessionResponseImpl>(this, _$identity);
}

abstract class _CreateSessionResponse implements CreateSessionResponse {
  const factory _CreateSessionResponse(
      {required final String sessionId,
      final String? sessionName,
      required final String sessionType,
      final String? shipmentId,
      final String? shipmentNumber,
      required final bool isActive,
      required final bool isFinal,
      required final String createdBy,
      required final String createdAt}) = _$CreateSessionResponseImpl;

  @override
  String get sessionId;
  @override
  String? get sessionName;
  @override
  String get sessionType;
  @override
  String? get shipmentId;
  @override
  String? get shipmentNumber;
  @override
  bool get isActive;
  @override
  bool get isFinal;
  @override
  String get createdBy;
  @override
  String get createdAt;

  /// Create a copy of CreateSessionResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateSessionResponseImplCopyWith<_$CreateSessionResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
