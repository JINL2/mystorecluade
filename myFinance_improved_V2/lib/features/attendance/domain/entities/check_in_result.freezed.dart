// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'check_in_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CheckInResult {
  /// Action performed: 'check_in' or 'check_out'
  String get action => throw _privateConstructorUsedError;

  /// Date of the shift (yyyy-MM-dd format)
  String get requestDate => throw _privateConstructorUsedError;

  /// Timestamp when action was performed (ISO 8601 format)
  String get timestamp => throw _privateConstructorUsedError;

  /// ID of the shift request that was updated
  String? get shiftRequestId => throw _privateConstructorUsedError;

  /// Success/error message from server
  String? get message => throw _privateConstructorUsedError;

  /// Whether the action was successful
  bool get success => throw _privateConstructorUsedError;

  /// Create a copy of CheckInResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CheckInResultCopyWith<CheckInResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CheckInResultCopyWith<$Res> {
  factory $CheckInResultCopyWith(
          CheckInResult value, $Res Function(CheckInResult) then) =
      _$CheckInResultCopyWithImpl<$Res, CheckInResult>;
  @useResult
  $Res call(
      {String action,
      String requestDate,
      String timestamp,
      String? shiftRequestId,
      String? message,
      bool success});
}

/// @nodoc
class _$CheckInResultCopyWithImpl<$Res, $Val extends CheckInResult>
    implements $CheckInResultCopyWith<$Res> {
  _$CheckInResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CheckInResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? action = null,
    Object? requestDate = null,
    Object? timestamp = null,
    Object? shiftRequestId = freezed,
    Object? message = freezed,
    Object? success = null,
  }) {
    return _then(_value.copyWith(
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      requestDate: null == requestDate
          ? _value.requestDate
          : requestDate // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as String,
      shiftRequestId: freezed == shiftRequestId
          ? _value.shiftRequestId
          : shiftRequestId // ignore: cast_nullable_to_non_nullable
              as String?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CheckInResultImplCopyWith<$Res>
    implements $CheckInResultCopyWith<$Res> {
  factory _$$CheckInResultImplCopyWith(
          _$CheckInResultImpl value, $Res Function(_$CheckInResultImpl) then) =
      __$$CheckInResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String action,
      String requestDate,
      String timestamp,
      String? shiftRequestId,
      String? message,
      bool success});
}

/// @nodoc
class __$$CheckInResultImplCopyWithImpl<$Res>
    extends _$CheckInResultCopyWithImpl<$Res, _$CheckInResultImpl>
    implements _$$CheckInResultImplCopyWith<$Res> {
  __$$CheckInResultImplCopyWithImpl(
      _$CheckInResultImpl _value, $Res Function(_$CheckInResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of CheckInResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? action = null,
    Object? requestDate = null,
    Object? timestamp = null,
    Object? shiftRequestId = freezed,
    Object? message = freezed,
    Object? success = null,
  }) {
    return _then(_$CheckInResultImpl(
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      requestDate: null == requestDate
          ? _value.requestDate
          : requestDate // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as String,
      shiftRequestId: freezed == shiftRequestId
          ? _value.shiftRequestId
          : shiftRequestId // ignore: cast_nullable_to_non_nullable
              as String?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$CheckInResultImpl extends _CheckInResult {
  const _$CheckInResultImpl(
      {required this.action,
      required this.requestDate,
      required this.timestamp,
      this.shiftRequestId,
      this.message,
      this.success = true})
      : super._();

  /// Action performed: 'check_in' or 'check_out'
  @override
  final String action;

  /// Date of the shift (yyyy-MM-dd format)
  @override
  final String requestDate;

  /// Timestamp when action was performed (ISO 8601 format)
  @override
  final String timestamp;

  /// ID of the shift request that was updated
  @override
  final String? shiftRequestId;

  /// Success/error message from server
  @override
  final String? message;

  /// Whether the action was successful
  @override
  @JsonKey()
  final bool success;

  @override
  String toString() {
    return 'CheckInResult(action: $action, requestDate: $requestDate, timestamp: $timestamp, shiftRequestId: $shiftRequestId, message: $message, success: $success)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CheckInResultImpl &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.requestDate, requestDate) ||
                other.requestDate == requestDate) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.shiftRequestId, shiftRequestId) ||
                other.shiftRequestId == shiftRequestId) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.success, success) || other.success == success));
  }

  @override
  int get hashCode => Object.hash(runtimeType, action, requestDate, timestamp,
      shiftRequestId, message, success);

  /// Create a copy of CheckInResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CheckInResultImplCopyWith<_$CheckInResultImpl> get copyWith =>
      __$$CheckInResultImplCopyWithImpl<_$CheckInResultImpl>(this, _$identity);
}

abstract class _CheckInResult extends CheckInResult {
  const factory _CheckInResult(
      {required final String action,
      required final String requestDate,
      required final String timestamp,
      final String? shiftRequestId,
      final String? message,
      final bool success}) = _$CheckInResultImpl;
  const _CheckInResult._() : super._();

  /// Action performed: 'check_in' or 'check_out'
  @override
  String get action;

  /// Date of the shift (yyyy-MM-dd format)
  @override
  String get requestDate;

  /// Timestamp when action was performed (ISO 8601 format)
  @override
  String get timestamp;

  /// ID of the shift request that was updated
  @override
  String? get shiftRequestId;

  /// Success/error message from server
  @override
  String? get message;

  /// Whether the action was successful
  @override
  bool get success;

  /// Create a copy of CheckInResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CheckInResultImplCopyWith<_$CheckInResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
