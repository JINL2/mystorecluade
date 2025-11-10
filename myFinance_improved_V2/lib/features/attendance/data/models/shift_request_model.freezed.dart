// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shift_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ShiftRequestModel {
  String get shiftRequestId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get storeId => throw _privateConstructorUsedError;
  String get requestDate => throw _privateConstructorUsedError;
  DateTime? get scheduledStartTime => throw _privateConstructorUsedError;
  DateTime? get scheduledEndTime => throw _privateConstructorUsedError;
  DateTime? get actualStartTime => throw _privateConstructorUsedError;
  DateTime? get actualEndTime => throw _privateConstructorUsedError;
  AttendanceLocation? get checkinLocation => throw _privateConstructorUsedError;
  AttendanceLocation? get checkoutLocation =>
      throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  Map<String, dynamic>? get storeShift => throw _privateConstructorUsedError;

  /// Create a copy of ShiftRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShiftRequestModelCopyWith<ShiftRequestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShiftRequestModelCopyWith<$Res> {
  factory $ShiftRequestModelCopyWith(
          ShiftRequestModel value, $Res Function(ShiftRequestModel) then) =
      _$ShiftRequestModelCopyWithImpl<$Res, ShiftRequestModel>;
  @useResult
  $Res call(
      {String shiftRequestId,
      String userId,
      String storeId,
      String requestDate,
      DateTime? scheduledStartTime,
      DateTime? scheduledEndTime,
      DateTime? actualStartTime,
      DateTime? actualEndTime,
      AttendanceLocation? checkinLocation,
      AttendanceLocation? checkoutLocation,
      String status,
      Map<String, dynamic>? storeShift});
}

/// @nodoc
class _$ShiftRequestModelCopyWithImpl<$Res, $Val extends ShiftRequestModel>
    implements $ShiftRequestModelCopyWith<$Res> {
  _$ShiftRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShiftRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shiftRequestId = null,
    Object? userId = null,
    Object? storeId = null,
    Object? requestDate = null,
    Object? scheduledStartTime = freezed,
    Object? scheduledEndTime = freezed,
    Object? actualStartTime = freezed,
    Object? actualEndTime = freezed,
    Object? checkinLocation = freezed,
    Object? checkoutLocation = freezed,
    Object? status = null,
    Object? storeShift = freezed,
  }) {
    return _then(_value.copyWith(
      shiftRequestId: null == shiftRequestId
          ? _value.shiftRequestId
          : shiftRequestId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      requestDate: null == requestDate
          ? _value.requestDate
          : requestDate // ignore: cast_nullable_to_non_nullable
              as String,
      scheduledStartTime: freezed == scheduledStartTime
          ? _value.scheduledStartTime
          : scheduledStartTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      scheduledEndTime: freezed == scheduledEndTime
          ? _value.scheduledEndTime
          : scheduledEndTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      actualStartTime: freezed == actualStartTime
          ? _value.actualStartTime
          : actualStartTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      actualEndTime: freezed == actualEndTime
          ? _value.actualEndTime
          : actualEndTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      checkinLocation: freezed == checkinLocation
          ? _value.checkinLocation
          : checkinLocation // ignore: cast_nullable_to_non_nullable
              as AttendanceLocation?,
      checkoutLocation: freezed == checkoutLocation
          ? _value.checkoutLocation
          : checkoutLocation // ignore: cast_nullable_to_non_nullable
              as AttendanceLocation?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      storeShift: freezed == storeShift
          ? _value.storeShift
          : storeShift // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ShiftRequestModelImplCopyWith<$Res>
    implements $ShiftRequestModelCopyWith<$Res> {
  factory _$$ShiftRequestModelImplCopyWith(_$ShiftRequestModelImpl value,
          $Res Function(_$ShiftRequestModelImpl) then) =
      __$$ShiftRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String shiftRequestId,
      String userId,
      String storeId,
      String requestDate,
      DateTime? scheduledStartTime,
      DateTime? scheduledEndTime,
      DateTime? actualStartTime,
      DateTime? actualEndTime,
      AttendanceLocation? checkinLocation,
      AttendanceLocation? checkoutLocation,
      String status,
      Map<String, dynamic>? storeShift});
}

/// @nodoc
class __$$ShiftRequestModelImplCopyWithImpl<$Res>
    extends _$ShiftRequestModelCopyWithImpl<$Res, _$ShiftRequestModelImpl>
    implements _$$ShiftRequestModelImplCopyWith<$Res> {
  __$$ShiftRequestModelImplCopyWithImpl(_$ShiftRequestModelImpl _value,
      $Res Function(_$ShiftRequestModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ShiftRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shiftRequestId = null,
    Object? userId = null,
    Object? storeId = null,
    Object? requestDate = null,
    Object? scheduledStartTime = freezed,
    Object? scheduledEndTime = freezed,
    Object? actualStartTime = freezed,
    Object? actualEndTime = freezed,
    Object? checkinLocation = freezed,
    Object? checkoutLocation = freezed,
    Object? status = null,
    Object? storeShift = freezed,
  }) {
    return _then(_$ShiftRequestModelImpl(
      shiftRequestId: null == shiftRequestId
          ? _value.shiftRequestId
          : shiftRequestId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      requestDate: null == requestDate
          ? _value.requestDate
          : requestDate // ignore: cast_nullable_to_non_nullable
              as String,
      scheduledStartTime: freezed == scheduledStartTime
          ? _value.scheduledStartTime
          : scheduledStartTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      scheduledEndTime: freezed == scheduledEndTime
          ? _value.scheduledEndTime
          : scheduledEndTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      actualStartTime: freezed == actualStartTime
          ? _value.actualStartTime
          : actualStartTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      actualEndTime: freezed == actualEndTime
          ? _value.actualEndTime
          : actualEndTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      checkinLocation: freezed == checkinLocation
          ? _value.checkinLocation
          : checkinLocation // ignore: cast_nullable_to_non_nullable
              as AttendanceLocation?,
      checkoutLocation: freezed == checkoutLocation
          ? _value.checkoutLocation
          : checkoutLocation // ignore: cast_nullable_to_non_nullable
              as AttendanceLocation?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      storeShift: freezed == storeShift
          ? _value._storeShift
          : storeShift // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc

class _$ShiftRequestModelImpl extends _ShiftRequestModel {
  const _$ShiftRequestModelImpl(
      {required this.shiftRequestId,
      required this.userId,
      required this.storeId,
      required this.requestDate,
      this.scheduledStartTime,
      this.scheduledEndTime,
      this.actualStartTime,
      this.actualEndTime,
      this.checkinLocation,
      this.checkoutLocation,
      required this.status,
      final Map<String, dynamic>? storeShift})
      : _storeShift = storeShift,
        super._();

  @override
  final String shiftRequestId;
  @override
  final String userId;
  @override
  final String storeId;
  @override
  final String requestDate;
  @override
  final DateTime? scheduledStartTime;
  @override
  final DateTime? scheduledEndTime;
  @override
  final DateTime? actualStartTime;
  @override
  final DateTime? actualEndTime;
  @override
  final AttendanceLocation? checkinLocation;
  @override
  final AttendanceLocation? checkoutLocation;
  @override
  final String status;
  final Map<String, dynamic>? _storeShift;
  @override
  Map<String, dynamic>? get storeShift {
    final value = _storeShift;
    if (value == null) return null;
    if (_storeShift is EqualUnmodifiableMapView) return _storeShift;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'ShiftRequestModel(shiftRequestId: $shiftRequestId, userId: $userId, storeId: $storeId, requestDate: $requestDate, scheduledStartTime: $scheduledStartTime, scheduledEndTime: $scheduledEndTime, actualStartTime: $actualStartTime, actualEndTime: $actualEndTime, checkinLocation: $checkinLocation, checkoutLocation: $checkoutLocation, status: $status, storeShift: $storeShift)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShiftRequestModelImpl &&
            (identical(other.shiftRequestId, shiftRequestId) ||
                other.shiftRequestId == shiftRequestId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.requestDate, requestDate) ||
                other.requestDate == requestDate) &&
            (identical(other.scheduledStartTime, scheduledStartTime) ||
                other.scheduledStartTime == scheduledStartTime) &&
            (identical(other.scheduledEndTime, scheduledEndTime) ||
                other.scheduledEndTime == scheduledEndTime) &&
            (identical(other.actualStartTime, actualStartTime) ||
                other.actualStartTime == actualStartTime) &&
            (identical(other.actualEndTime, actualEndTime) ||
                other.actualEndTime == actualEndTime) &&
            (identical(other.checkinLocation, checkinLocation) ||
                other.checkinLocation == checkinLocation) &&
            (identical(other.checkoutLocation, checkoutLocation) ||
                other.checkoutLocation == checkoutLocation) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality()
                .equals(other._storeShift, _storeShift));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      shiftRequestId,
      userId,
      storeId,
      requestDate,
      scheduledStartTime,
      scheduledEndTime,
      actualStartTime,
      actualEndTime,
      checkinLocation,
      checkoutLocation,
      status,
      const DeepCollectionEquality().hash(_storeShift));

  /// Create a copy of ShiftRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShiftRequestModelImplCopyWith<_$ShiftRequestModelImpl> get copyWith =>
      __$$ShiftRequestModelImplCopyWithImpl<_$ShiftRequestModelImpl>(
          this, _$identity);
}

abstract class _ShiftRequestModel extends ShiftRequestModel {
  const factory _ShiftRequestModel(
      {required final String shiftRequestId,
      required final String userId,
      required final String storeId,
      required final String requestDate,
      final DateTime? scheduledStartTime,
      final DateTime? scheduledEndTime,
      final DateTime? actualStartTime,
      final DateTime? actualEndTime,
      final AttendanceLocation? checkinLocation,
      final AttendanceLocation? checkoutLocation,
      required final String status,
      final Map<String, dynamic>? storeShift}) = _$ShiftRequestModelImpl;
  const _ShiftRequestModel._() : super._();

  @override
  String get shiftRequestId;
  @override
  String get userId;
  @override
  String get storeId;
  @override
  String get requestDate;
  @override
  DateTime? get scheduledStartTime;
  @override
  DateTime? get scheduledEndTime;
  @override
  DateTime? get actualStartTime;
  @override
  DateTime? get actualEndTime;
  @override
  AttendanceLocation? get checkinLocation;
  @override
  AttendanceLocation? get checkoutLocation;
  @override
  String get status;
  @override
  Map<String, dynamic>? get storeShift;

  /// Create a copy of ShiftRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShiftRequestModelImplCopyWith<_$ShiftRequestModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
