// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_list_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SessionListItem {
  String get sessionId => throw _privateConstructorUsedError;
  String get sessionName => throw _privateConstructorUsedError;
  String get sessionType => throw _privateConstructorUsedError;

  /// Session status: 'in_progress', 'complete', 'cancelled'
  String get status => throw _privateConstructorUsedError;
  String get storeId => throw _privateConstructorUsedError;
  String get storeName => throw _privateConstructorUsedError;
  String? get shipmentId => throw _privateConstructorUsedError;
  String? get shipmentNumber => throw _privateConstructorUsedError;

  /// v2: Supplier info (via shipment connection)
  String? get supplierId => throw _privateConstructorUsedError;
  String? get supplierName => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  bool get isFinal => throw _privateConstructorUsedError;
  int get memberCount => throw _privateConstructorUsedError;
  String get createdBy => throw _privateConstructorUsedError;
  String get createdByName => throw _privateConstructorUsedError;
  String? get completedAt => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;

  /// Create a copy of SessionListItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionListItemCopyWith<SessionListItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionListItemCopyWith<$Res> {
  factory $SessionListItemCopyWith(
          SessionListItem value, $Res Function(SessionListItem) then) =
      _$SessionListItemCopyWithImpl<$Res, SessionListItem>;
  @useResult
  $Res call(
      {String sessionId,
      String sessionName,
      String sessionType,
      String status,
      String storeId,
      String storeName,
      String? shipmentId,
      String? shipmentNumber,
      String? supplierId,
      String? supplierName,
      bool isActive,
      bool isFinal,
      int memberCount,
      String createdBy,
      String createdByName,
      String? completedAt,
      String createdAt});
}

/// @nodoc
class _$SessionListItemCopyWithImpl<$Res, $Val extends SessionListItem>
    implements $SessionListItemCopyWith<$Res> {
  _$SessionListItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SessionListItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? sessionName = null,
    Object? sessionType = null,
    Object? status = null,
    Object? storeId = null,
    Object? storeName = null,
    Object? shipmentId = freezed,
    Object? shipmentNumber = freezed,
    Object? supplierId = freezed,
    Object? supplierName = freezed,
    Object? isActive = null,
    Object? isFinal = null,
    Object? memberCount = null,
    Object? createdBy = null,
    Object? createdByName = null,
    Object? completedAt = freezed,
    Object? createdAt = null,
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
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
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
      supplierId: freezed == supplierId
          ? _value.supplierId
          : supplierId // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierName: freezed == supplierName
          ? _value.supplierName
          : supplierName // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isFinal: null == isFinal
          ? _value.isFinal
          : isFinal // ignore: cast_nullable_to_non_nullable
              as bool,
      memberCount: null == memberCount
          ? _value.memberCount
          : memberCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdByName: null == createdByName
          ? _value.createdByName
          : createdByName // ignore: cast_nullable_to_non_nullable
              as String,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SessionListItemImplCopyWith<$Res>
    implements $SessionListItemCopyWith<$Res> {
  factory _$$SessionListItemImplCopyWith(_$SessionListItemImpl value,
          $Res Function(_$SessionListItemImpl) then) =
      __$$SessionListItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String sessionId,
      String sessionName,
      String sessionType,
      String status,
      String storeId,
      String storeName,
      String? shipmentId,
      String? shipmentNumber,
      String? supplierId,
      String? supplierName,
      bool isActive,
      bool isFinal,
      int memberCount,
      String createdBy,
      String createdByName,
      String? completedAt,
      String createdAt});
}

/// @nodoc
class __$$SessionListItemImplCopyWithImpl<$Res>
    extends _$SessionListItemCopyWithImpl<$Res, _$SessionListItemImpl>
    implements _$$SessionListItemImplCopyWith<$Res> {
  __$$SessionListItemImplCopyWithImpl(
      _$SessionListItemImpl _value, $Res Function(_$SessionListItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of SessionListItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? sessionName = null,
    Object? sessionType = null,
    Object? status = null,
    Object? storeId = null,
    Object? storeName = null,
    Object? shipmentId = freezed,
    Object? shipmentNumber = freezed,
    Object? supplierId = freezed,
    Object? supplierName = freezed,
    Object? isActive = null,
    Object? isFinal = null,
    Object? memberCount = null,
    Object? createdBy = null,
    Object? createdByName = null,
    Object? completedAt = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$SessionListItemImpl(
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
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
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
      supplierId: freezed == supplierId
          ? _value.supplierId
          : supplierId // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierName: freezed == supplierName
          ? _value.supplierName
          : supplierName // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isFinal: null == isFinal
          ? _value.isFinal
          : isFinal // ignore: cast_nullable_to_non_nullable
              as bool,
      memberCount: null == memberCount
          ? _value.memberCount
          : memberCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdByName: null == createdByName
          ? _value.createdByName
          : createdByName // ignore: cast_nullable_to_non_nullable
              as String,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$SessionListItemImpl extends _SessionListItem {
  const _$SessionListItemImpl(
      {required this.sessionId,
      required this.sessionName,
      required this.sessionType,
      required this.status,
      required this.storeId,
      required this.storeName,
      this.shipmentId,
      this.shipmentNumber,
      this.supplierId,
      this.supplierName,
      required this.isActive,
      required this.isFinal,
      required this.memberCount,
      required this.createdBy,
      required this.createdByName,
      this.completedAt,
      required this.createdAt})
      : super._();

  @override
  final String sessionId;
  @override
  final String sessionName;
  @override
  final String sessionType;

  /// Session status: 'in_progress', 'complete', 'cancelled'
  @override
  final String status;
  @override
  final String storeId;
  @override
  final String storeName;
  @override
  final String? shipmentId;
  @override
  final String? shipmentNumber;

  /// v2: Supplier info (via shipment connection)
  @override
  final String? supplierId;
  @override
  final String? supplierName;
  @override
  final bool isActive;
  @override
  final bool isFinal;
  @override
  final int memberCount;
  @override
  final String createdBy;
  @override
  final String createdByName;
  @override
  final String? completedAt;
  @override
  final String createdAt;

  @override
  String toString() {
    return 'SessionListItem(sessionId: $sessionId, sessionName: $sessionName, sessionType: $sessionType, status: $status, storeId: $storeId, storeName: $storeName, shipmentId: $shipmentId, shipmentNumber: $shipmentNumber, supplierId: $supplierId, supplierName: $supplierName, isActive: $isActive, isFinal: $isFinal, memberCount: $memberCount, createdBy: $createdBy, createdByName: $createdByName, completedAt: $completedAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionListItemImpl &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.sessionName, sessionName) ||
                other.sessionName == sessionName) &&
            (identical(other.sessionType, sessionType) ||
                other.sessionType == sessionType) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.storeName, storeName) ||
                other.storeName == storeName) &&
            (identical(other.shipmentId, shipmentId) ||
                other.shipmentId == shipmentId) &&
            (identical(other.shipmentNumber, shipmentNumber) ||
                other.shipmentNumber == shipmentNumber) &&
            (identical(other.supplierId, supplierId) ||
                other.supplierId == supplierId) &&
            (identical(other.supplierName, supplierName) ||
                other.supplierName == supplierName) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isFinal, isFinal) || other.isFinal == isFinal) &&
            (identical(other.memberCount, memberCount) ||
                other.memberCount == memberCount) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdByName, createdByName) ||
                other.createdByName == createdByName) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      sessionId,
      sessionName,
      sessionType,
      status,
      storeId,
      storeName,
      shipmentId,
      shipmentNumber,
      supplierId,
      supplierName,
      isActive,
      isFinal,
      memberCount,
      createdBy,
      createdByName,
      completedAt,
      createdAt);

  /// Create a copy of SessionListItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionListItemImplCopyWith<_$SessionListItemImpl> get copyWith =>
      __$$SessionListItemImplCopyWithImpl<_$SessionListItemImpl>(
          this, _$identity);
}

abstract class _SessionListItem extends SessionListItem {
  const factory _SessionListItem(
      {required final String sessionId,
      required final String sessionName,
      required final String sessionType,
      required final String status,
      required final String storeId,
      required final String storeName,
      final String? shipmentId,
      final String? shipmentNumber,
      final String? supplierId,
      final String? supplierName,
      required final bool isActive,
      required final bool isFinal,
      required final int memberCount,
      required final String createdBy,
      required final String createdByName,
      final String? completedAt,
      required final String createdAt}) = _$SessionListItemImpl;
  const _SessionListItem._() : super._();

  @override
  String get sessionId;
  @override
  String get sessionName;
  @override
  String get sessionType;

  /// Session status: 'in_progress', 'complete', 'cancelled'
  @override
  String get status;
  @override
  String get storeId;
  @override
  String get storeName;
  @override
  String? get shipmentId;
  @override
  String? get shipmentNumber;

  /// v2: Supplier info (via shipment connection)
  @override
  String? get supplierId;
  @override
  String? get supplierName;
  @override
  bool get isActive;
  @override
  bool get isFinal;
  @override
  int get memberCount;
  @override
  String get createdBy;
  @override
  String get createdByName;
  @override
  String? get completedAt;
  @override
  String get createdAt;

  /// Create a copy of SessionListItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionListItemImplCopyWith<_$SessionListItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SessionListResponse {
  List<SessionListItem> get sessions => throw _privateConstructorUsedError;
  int get totalCount => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;
  int get offset => throw _privateConstructorUsedError;

  /// Create a copy of SessionListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionListResponseCopyWith<SessionListResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionListResponseCopyWith<$Res> {
  factory $SessionListResponseCopyWith(
          SessionListResponse value, $Res Function(SessionListResponse) then) =
      _$SessionListResponseCopyWithImpl<$Res, SessionListResponse>;
  @useResult
  $Res call(
      {List<SessionListItem> sessions, int totalCount, int limit, int offset});
}

/// @nodoc
class _$SessionListResponseCopyWithImpl<$Res, $Val extends SessionListResponse>
    implements $SessionListResponseCopyWith<$Res> {
  _$SessionListResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SessionListResponse
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
              as List<SessionListItem>,
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
abstract class _$$SessionListResponseImplCopyWith<$Res>
    implements $SessionListResponseCopyWith<$Res> {
  factory _$$SessionListResponseImplCopyWith(_$SessionListResponseImpl value,
          $Res Function(_$SessionListResponseImpl) then) =
      __$$SessionListResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<SessionListItem> sessions, int totalCount, int limit, int offset});
}

/// @nodoc
class __$$SessionListResponseImplCopyWithImpl<$Res>
    extends _$SessionListResponseCopyWithImpl<$Res, _$SessionListResponseImpl>
    implements _$$SessionListResponseImplCopyWith<$Res> {
  __$$SessionListResponseImplCopyWithImpl(_$SessionListResponseImpl _value,
      $Res Function(_$SessionListResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of SessionListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessions = null,
    Object? totalCount = null,
    Object? limit = null,
    Object? offset = null,
  }) {
    return _then(_$SessionListResponseImpl(
      sessions: null == sessions
          ? _value._sessions
          : sessions // ignore: cast_nullable_to_non_nullable
              as List<SessionListItem>,
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

class _$SessionListResponseImpl extends _SessionListResponse {
  const _$SessionListResponseImpl(
      {required final List<SessionListItem> sessions,
      required this.totalCount,
      required this.limit,
      required this.offset})
      : _sessions = sessions,
        super._();

  final List<SessionListItem> _sessions;
  @override
  List<SessionListItem> get sessions {
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
    return 'SessionListResponse(sessions: $sessions, totalCount: $totalCount, limit: $limit, offset: $offset)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionListResponseImpl &&
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

  /// Create a copy of SessionListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionListResponseImplCopyWith<_$SessionListResponseImpl> get copyWith =>
      __$$SessionListResponseImplCopyWithImpl<_$SessionListResponseImpl>(
          this, _$identity);
}

abstract class _SessionListResponse extends SessionListResponse {
  const factory _SessionListResponse(
      {required final List<SessionListItem> sessions,
      required final int totalCount,
      required final int limit,
      required final int offset}) = _$SessionListResponseImpl;
  const _SessionListResponse._() : super._();

  @override
  List<SessionListItem> get sessions;
  @override
  int get totalCount;
  @override
  int get limit;
  @override
  int get offset;

  /// Create a copy of SessionListResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionListResponseImplCopyWith<_$SessionListResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
