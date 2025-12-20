// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shipment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Shipment {
  String get shipmentId => throw _privateConstructorUsedError;
  String get shipmentNumber => throw _privateConstructorUsedError;
  String? get trackingNumber => throw _privateConstructorUsedError;
  String? get shippedDate => throw _privateConstructorUsedError;
  String? get supplierId => throw _privateConstructorUsedError;
  String get supplierName => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  int get itemCount => throw _privateConstructorUsedError;
  double get totalAmount => throw _privateConstructorUsedError;
  bool get hasOrders => throw _privateConstructorUsedError;
  int get linkedOrderCount => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  String get createdBy => throw _privateConstructorUsedError;

  /// Create a copy of Shipment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShipmentCopyWith<Shipment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShipmentCopyWith<$Res> {
  factory $ShipmentCopyWith(Shipment value, $Res Function(Shipment) then) =
      _$ShipmentCopyWithImpl<$Res, Shipment>;
  @useResult
  $Res call(
      {String shipmentId,
      String shipmentNumber,
      String? trackingNumber,
      String? shippedDate,
      String? supplierId,
      String supplierName,
      String status,
      int itemCount,
      double totalAmount,
      bool hasOrders,
      int linkedOrderCount,
      String? notes,
      String createdAt,
      String createdBy});
}

/// @nodoc
class _$ShipmentCopyWithImpl<$Res, $Val extends Shipment>
    implements $ShipmentCopyWith<$Res> {
  _$ShipmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Shipment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shipmentId = null,
    Object? shipmentNumber = null,
    Object? trackingNumber = freezed,
    Object? shippedDate = freezed,
    Object? supplierId = freezed,
    Object? supplierName = null,
    Object? status = null,
    Object? itemCount = null,
    Object? totalAmount = null,
    Object? hasOrders = null,
    Object? linkedOrderCount = null,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? createdBy = null,
  }) {
    return _then(_value.copyWith(
      shipmentId: null == shipmentId
          ? _value.shipmentId
          : shipmentId // ignore: cast_nullable_to_non_nullable
              as String,
      shipmentNumber: null == shipmentNumber
          ? _value.shipmentNumber
          : shipmentNumber // ignore: cast_nullable_to_non_nullable
              as String,
      trackingNumber: freezed == trackingNumber
          ? _value.trackingNumber
          : trackingNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      shippedDate: freezed == shippedDate
          ? _value.shippedDate
          : shippedDate // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierId: freezed == supplierId
          ? _value.supplierId
          : supplierId // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierName: null == supplierName
          ? _value.supplierName
          : supplierName // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      itemCount: null == itemCount
          ? _value.itemCount
          : itemCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      hasOrders: null == hasOrders
          ? _value.hasOrders
          : hasOrders // ignore: cast_nullable_to_non_nullable
              as bool,
      linkedOrderCount: null == linkedOrderCount
          ? _value.linkedOrderCount
          : linkedOrderCount // ignore: cast_nullable_to_non_nullable
              as int,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ShipmentImplCopyWith<$Res>
    implements $ShipmentCopyWith<$Res> {
  factory _$$ShipmentImplCopyWith(
          _$ShipmentImpl value, $Res Function(_$ShipmentImpl) then) =
      __$$ShipmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String shipmentId,
      String shipmentNumber,
      String? trackingNumber,
      String? shippedDate,
      String? supplierId,
      String supplierName,
      String status,
      int itemCount,
      double totalAmount,
      bool hasOrders,
      int linkedOrderCount,
      String? notes,
      String createdAt,
      String createdBy});
}

/// @nodoc
class __$$ShipmentImplCopyWithImpl<$Res>
    extends _$ShipmentCopyWithImpl<$Res, _$ShipmentImpl>
    implements _$$ShipmentImplCopyWith<$Res> {
  __$$ShipmentImplCopyWithImpl(
      _$ShipmentImpl _value, $Res Function(_$ShipmentImpl) _then)
      : super(_value, _then);

  /// Create a copy of Shipment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shipmentId = null,
    Object? shipmentNumber = null,
    Object? trackingNumber = freezed,
    Object? shippedDate = freezed,
    Object? supplierId = freezed,
    Object? supplierName = null,
    Object? status = null,
    Object? itemCount = null,
    Object? totalAmount = null,
    Object? hasOrders = null,
    Object? linkedOrderCount = null,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? createdBy = null,
  }) {
    return _then(_$ShipmentImpl(
      shipmentId: null == shipmentId
          ? _value.shipmentId
          : shipmentId // ignore: cast_nullable_to_non_nullable
              as String,
      shipmentNumber: null == shipmentNumber
          ? _value.shipmentNumber
          : shipmentNumber // ignore: cast_nullable_to_non_nullable
              as String,
      trackingNumber: freezed == trackingNumber
          ? _value.trackingNumber
          : trackingNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      shippedDate: freezed == shippedDate
          ? _value.shippedDate
          : shippedDate // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierId: freezed == supplierId
          ? _value.supplierId
          : supplierId // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierName: null == supplierName
          ? _value.supplierName
          : supplierName // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      itemCount: null == itemCount
          ? _value.itemCount
          : itemCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      hasOrders: null == hasOrders
          ? _value.hasOrders
          : hasOrders // ignore: cast_nullable_to_non_nullable
              as bool,
      linkedOrderCount: null == linkedOrderCount
          ? _value.linkedOrderCount
          : linkedOrderCount // ignore: cast_nullable_to_non_nullable
              as int,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ShipmentImpl extends _Shipment {
  const _$ShipmentImpl(
      {required this.shipmentId,
      required this.shipmentNumber,
      this.trackingNumber,
      this.shippedDate,
      this.supplierId,
      required this.supplierName,
      required this.status,
      required this.itemCount,
      required this.totalAmount,
      required this.hasOrders,
      required this.linkedOrderCount,
      this.notes,
      required this.createdAt,
      required this.createdBy})
      : super._();

  @override
  final String shipmentId;
  @override
  final String shipmentNumber;
  @override
  final String? trackingNumber;
  @override
  final String? shippedDate;
  @override
  final String? supplierId;
  @override
  final String supplierName;
  @override
  final String status;
  @override
  final int itemCount;
  @override
  final double totalAmount;
  @override
  final bool hasOrders;
  @override
  final int linkedOrderCount;
  @override
  final String? notes;
  @override
  final String createdAt;
  @override
  final String createdBy;

  @override
  String toString() {
    return 'Shipment(shipmentId: $shipmentId, shipmentNumber: $shipmentNumber, trackingNumber: $trackingNumber, shippedDate: $shippedDate, supplierId: $supplierId, supplierName: $supplierName, status: $status, itemCount: $itemCount, totalAmount: $totalAmount, hasOrders: $hasOrders, linkedOrderCount: $linkedOrderCount, notes: $notes, createdAt: $createdAt, createdBy: $createdBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShipmentImpl &&
            (identical(other.shipmentId, shipmentId) ||
                other.shipmentId == shipmentId) &&
            (identical(other.shipmentNumber, shipmentNumber) ||
                other.shipmentNumber == shipmentNumber) &&
            (identical(other.trackingNumber, trackingNumber) ||
                other.trackingNumber == trackingNumber) &&
            (identical(other.shippedDate, shippedDate) ||
                other.shippedDate == shippedDate) &&
            (identical(other.supplierId, supplierId) ||
                other.supplierId == supplierId) &&
            (identical(other.supplierName, supplierName) ||
                other.supplierName == supplierName) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.itemCount, itemCount) ||
                other.itemCount == itemCount) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.hasOrders, hasOrders) ||
                other.hasOrders == hasOrders) &&
            (identical(other.linkedOrderCount, linkedOrderCount) ||
                other.linkedOrderCount == linkedOrderCount) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      shipmentId,
      shipmentNumber,
      trackingNumber,
      shippedDate,
      supplierId,
      supplierName,
      status,
      itemCount,
      totalAmount,
      hasOrders,
      linkedOrderCount,
      notes,
      createdAt,
      createdBy);

  /// Create a copy of Shipment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShipmentImplCopyWith<_$ShipmentImpl> get copyWith =>
      __$$ShipmentImplCopyWithImpl<_$ShipmentImpl>(this, _$identity);
}

abstract class _Shipment extends Shipment {
  const factory _Shipment(
      {required final String shipmentId,
      required final String shipmentNumber,
      final String? trackingNumber,
      final String? shippedDate,
      final String? supplierId,
      required final String supplierName,
      required final String status,
      required final int itemCount,
      required final double totalAmount,
      required final bool hasOrders,
      required final int linkedOrderCount,
      final String? notes,
      required final String createdAt,
      required final String createdBy}) = _$ShipmentImpl;
  const _Shipment._() : super._();

  @override
  String get shipmentId;
  @override
  String get shipmentNumber;
  @override
  String? get trackingNumber;
  @override
  String? get shippedDate;
  @override
  String? get supplierId;
  @override
  String get supplierName;
  @override
  String get status;
  @override
  int get itemCount;
  @override
  double get totalAmount;
  @override
  bool get hasOrders;
  @override
  int get linkedOrderCount;
  @override
  String? get notes;
  @override
  String get createdAt;
  @override
  String get createdBy;

  /// Create a copy of Shipment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShipmentImplCopyWith<_$ShipmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ShipmentListResponse {
  List<Shipment> get shipments => throw _privateConstructorUsedError;
  int get totalCount => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;
  int get offset => throw _privateConstructorUsedError;

  /// Create a copy of ShipmentListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShipmentListResponseCopyWith<ShipmentListResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShipmentListResponseCopyWith<$Res> {
  factory $ShipmentListResponseCopyWith(ShipmentListResponse value,
          $Res Function(ShipmentListResponse) then) =
      _$ShipmentListResponseCopyWithImpl<$Res, ShipmentListResponse>;
  @useResult
  $Res call({List<Shipment> shipments, int totalCount, int limit, int offset});
}

/// @nodoc
class _$ShipmentListResponseCopyWithImpl<$Res,
        $Val extends ShipmentListResponse>
    implements $ShipmentListResponseCopyWith<$Res> {
  _$ShipmentListResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShipmentListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shipments = null,
    Object? totalCount = null,
    Object? limit = null,
    Object? offset = null,
  }) {
    return _then(_value.copyWith(
      shipments: null == shipments
          ? _value.shipments
          : shipments // ignore: cast_nullable_to_non_nullable
              as List<Shipment>,
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
abstract class _$$ShipmentListResponseImplCopyWith<$Res>
    implements $ShipmentListResponseCopyWith<$Res> {
  factory _$$ShipmentListResponseImplCopyWith(_$ShipmentListResponseImpl value,
          $Res Function(_$ShipmentListResponseImpl) then) =
      __$$ShipmentListResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Shipment> shipments, int totalCount, int limit, int offset});
}

/// @nodoc
class __$$ShipmentListResponseImplCopyWithImpl<$Res>
    extends _$ShipmentListResponseCopyWithImpl<$Res, _$ShipmentListResponseImpl>
    implements _$$ShipmentListResponseImplCopyWith<$Res> {
  __$$ShipmentListResponseImplCopyWithImpl(_$ShipmentListResponseImpl _value,
      $Res Function(_$ShipmentListResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of ShipmentListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shipments = null,
    Object? totalCount = null,
    Object? limit = null,
    Object? offset = null,
  }) {
    return _then(_$ShipmentListResponseImpl(
      shipments: null == shipments
          ? _value._shipments
          : shipments // ignore: cast_nullable_to_non_nullable
              as List<Shipment>,
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

class _$ShipmentListResponseImpl extends _ShipmentListResponse {
  const _$ShipmentListResponseImpl(
      {required final List<Shipment> shipments,
      required this.totalCount,
      required this.limit,
      required this.offset})
      : _shipments = shipments,
        super._();

  final List<Shipment> _shipments;
  @override
  List<Shipment> get shipments {
    if (_shipments is EqualUnmodifiableListView) return _shipments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_shipments);
  }

  @override
  final int totalCount;
  @override
  final int limit;
  @override
  final int offset;

  @override
  String toString() {
    return 'ShipmentListResponse(shipments: $shipments, totalCount: $totalCount, limit: $limit, offset: $offset)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShipmentListResponseImpl &&
            const DeepCollectionEquality()
                .equals(other._shipments, _shipments) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.offset, offset) || other.offset == offset));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_shipments),
      totalCount,
      limit,
      offset);

  /// Create a copy of ShipmentListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShipmentListResponseImplCopyWith<_$ShipmentListResponseImpl>
      get copyWith =>
          __$$ShipmentListResponseImplCopyWithImpl<_$ShipmentListResponseImpl>(
              this, _$identity);
}

abstract class _ShipmentListResponse extends ShipmentListResponse {
  const factory _ShipmentListResponse(
      {required final List<Shipment> shipments,
      required final int totalCount,
      required final int limit,
      required final int offset}) = _$ShipmentListResponseImpl;
  const _ShipmentListResponse._() : super._();

  @override
  List<Shipment> get shipments;
  @override
  int get totalCount;
  @override
  int get limit;
  @override
  int get offset;

  /// Create a copy of ShipmentListResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShipmentListResponseImplCopyWith<_$ShipmentListResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
