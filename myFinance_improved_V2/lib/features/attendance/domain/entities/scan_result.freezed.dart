// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scan_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ScanResult {
  /// Date of the shift (yyyy-MM-dd format)
  String get requestDate => throw _privateConstructorUsedError;

  /// ID of the shift request
  String get shiftRequestId => throw _privateConstructorUsedError;

  /// Shift start time (HH:mm:ss format)
  String get shiftStartTime => throw _privateConstructorUsedError;

  /// Shift end time (HH:mm:ss format)
  String get shiftEndTime => throw _privateConstructorUsedError;

  /// Store name
  String get storeName => throw _privateConstructorUsedError;

  /// Action to perform: 'check_in' or 'check_out'
  String get action => throw _privateConstructorUsedError;

  /// Timestamp of the scan (ISO 8601 UTC format)
  String get timestamp => throw _privateConstructorUsedError;

  /// Store ID
  String? get storeId => throw _privateConstructorUsedError;

  /// User ID
  String? get userId => throw _privateConstructorUsedError;

  /// Create a copy of ScanResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScanResultCopyWith<ScanResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScanResultCopyWith<$Res> {
  factory $ScanResultCopyWith(
          ScanResult value, $Res Function(ScanResult) then) =
      _$ScanResultCopyWithImpl<$Res, ScanResult>;
  @useResult
  $Res call(
      {String requestDate,
      String shiftRequestId,
      String shiftStartTime,
      String shiftEndTime,
      String storeName,
      String action,
      String timestamp,
      String? storeId,
      String? userId});
}

/// @nodoc
class _$ScanResultCopyWithImpl<$Res, $Val extends ScanResult>
    implements $ScanResultCopyWith<$Res> {
  _$ScanResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScanResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? requestDate = null,
    Object? shiftRequestId = null,
    Object? shiftStartTime = null,
    Object? shiftEndTime = null,
    Object? storeName = null,
    Object? action = null,
    Object? timestamp = null,
    Object? storeId = freezed,
    Object? userId = freezed,
  }) {
    return _then(_value.copyWith(
      requestDate: null == requestDate
          ? _value.requestDate
          : requestDate // ignore: cast_nullable_to_non_nullable
              as String,
      shiftRequestId: null == shiftRequestId
          ? _value.shiftRequestId
          : shiftRequestId // ignore: cast_nullable_to_non_nullable
              as String,
      shiftStartTime: null == shiftStartTime
          ? _value.shiftStartTime
          : shiftStartTime // ignore: cast_nullable_to_non_nullable
              as String,
      shiftEndTime: null == shiftEndTime
          ? _value.shiftEndTime
          : shiftEndTime // ignore: cast_nullable_to_non_nullable
              as String,
      storeName: null == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: freezed == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScanResultImplCopyWith<$Res>
    implements $ScanResultCopyWith<$Res> {
  factory _$$ScanResultImplCopyWith(
          _$ScanResultImpl value, $Res Function(_$ScanResultImpl) then) =
      __$$ScanResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String requestDate,
      String shiftRequestId,
      String shiftStartTime,
      String shiftEndTime,
      String storeName,
      String action,
      String timestamp,
      String? storeId,
      String? userId});
}

/// @nodoc
class __$$ScanResultImplCopyWithImpl<$Res>
    extends _$ScanResultCopyWithImpl<$Res, _$ScanResultImpl>
    implements _$$ScanResultImplCopyWith<$Res> {
  __$$ScanResultImplCopyWithImpl(
      _$ScanResultImpl _value, $Res Function(_$ScanResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of ScanResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? requestDate = null,
    Object? shiftRequestId = null,
    Object? shiftStartTime = null,
    Object? shiftEndTime = null,
    Object? storeName = null,
    Object? action = null,
    Object? timestamp = null,
    Object? storeId = freezed,
    Object? userId = freezed,
  }) {
    return _then(_$ScanResultImpl(
      requestDate: null == requestDate
          ? _value.requestDate
          : requestDate // ignore: cast_nullable_to_non_nullable
              as String,
      shiftRequestId: null == shiftRequestId
          ? _value.shiftRequestId
          : shiftRequestId // ignore: cast_nullable_to_non_nullable
              as String,
      shiftStartTime: null == shiftStartTime
          ? _value.shiftStartTime
          : shiftStartTime // ignore: cast_nullable_to_non_nullable
              as String,
      shiftEndTime: null == shiftEndTime
          ? _value.shiftEndTime
          : shiftEndTime // ignore: cast_nullable_to_non_nullable
              as String,
      storeName: null == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: freezed == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ScanResultImpl extends _ScanResult {
  const _$ScanResultImpl(
      {required this.requestDate,
      required this.shiftRequestId,
      required this.shiftStartTime,
      required this.shiftEndTime,
      required this.storeName,
      required this.action,
      required this.timestamp,
      this.storeId,
      this.userId})
      : super._();

  /// Date of the shift (yyyy-MM-dd format)
  @override
  final String requestDate;

  /// ID of the shift request
  @override
  final String shiftRequestId;

  /// Shift start time (HH:mm:ss format)
  @override
  final String shiftStartTime;

  /// Shift end time (HH:mm:ss format)
  @override
  final String shiftEndTime;

  /// Store name
  @override
  final String storeName;

  /// Action to perform: 'check_in' or 'check_out'
  @override
  final String action;

  /// Timestamp of the scan (ISO 8601 UTC format)
  @override
  final String timestamp;

  /// Store ID
  @override
  final String? storeId;

  /// User ID
  @override
  final String? userId;

  @override
  String toString() {
    return 'ScanResult(requestDate: $requestDate, shiftRequestId: $shiftRequestId, shiftStartTime: $shiftStartTime, shiftEndTime: $shiftEndTime, storeName: $storeName, action: $action, timestamp: $timestamp, storeId: $storeId, userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScanResultImpl &&
            (identical(other.requestDate, requestDate) ||
                other.requestDate == requestDate) &&
            (identical(other.shiftRequestId, shiftRequestId) ||
                other.shiftRequestId == shiftRequestId) &&
            (identical(other.shiftStartTime, shiftStartTime) ||
                other.shiftStartTime == shiftStartTime) &&
            (identical(other.shiftEndTime, shiftEndTime) ||
                other.shiftEndTime == shiftEndTime) &&
            (identical(other.storeName, storeName) ||
                other.storeName == storeName) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      requestDate,
      shiftRequestId,
      shiftStartTime,
      shiftEndTime,
      storeName,
      action,
      timestamp,
      storeId,
      userId);

  /// Create a copy of ScanResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScanResultImplCopyWith<_$ScanResultImpl> get copyWith =>
      __$$ScanResultImplCopyWithImpl<_$ScanResultImpl>(this, _$identity);
}

abstract class _ScanResult extends ScanResult {
  const factory _ScanResult(
      {required final String requestDate,
      required final String shiftRequestId,
      required final String shiftStartTime,
      required final String shiftEndTime,
      required final String storeName,
      required final String action,
      required final String timestamp,
      final String? storeId,
      final String? userId}) = _$ScanResultImpl;
  const _ScanResult._() : super._();

  /// Date of the shift (yyyy-MM-dd format)
  @override
  String get requestDate;

  /// ID of the shift request
  @override
  String get shiftRequestId;

  /// Shift start time (HH:mm:ss format)
  @override
  String get shiftStartTime;

  /// Shift end time (HH:mm:ss format)
  @override
  String get shiftEndTime;

  /// Store name
  @override
  String get storeName;

  /// Action to perform: 'check_in' or 'check_out'
  @override
  String get action;

  /// Timestamp of the scan (ISO 8601 UTC format)
  @override
  String get timestamp;

  /// Store ID
  @override
  String? get storeId;

  /// User ID
  @override
  String? get userId;

  /// Create a copy of ScanResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScanResultImplCopyWith<_$ScanResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
