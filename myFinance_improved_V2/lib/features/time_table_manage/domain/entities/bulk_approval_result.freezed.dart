// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bulk_approval_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BulkApprovalResult _$BulkApprovalResultFromJson(Map<String, dynamic> json) {
  return _BulkApprovalResult.fromJson(json);
}

/// @nodoc
mixin _$BulkApprovalResult {
  /// Total number of requests processed
  @JsonKey(name: 'total_processed')
  int get totalProcessed => throw _privateConstructorUsedError;

  /// Number of successfully processed requests
  @JsonKey(name: 'success_count')
  int get successCount => throw _privateConstructorUsedError;

  /// Number of failed requests
  @JsonKey(name: 'failure_count')
  int get failureCount => throw _privateConstructorUsedError;

  /// List of successfully processed shift request IDs
  @JsonKey(name: 'successful_ids', defaultValue: <String>[])
  List<String> get successfulIds => throw _privateConstructorUsedError;

  /// List of errors encountered during processing
  @JsonKey(defaultValue: <BulkApprovalError>[])
  List<BulkApprovalError> get errors => throw _privateConstructorUsedError;

  /// Serializes this BulkApprovalResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BulkApprovalResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BulkApprovalResultCopyWith<BulkApprovalResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BulkApprovalResultCopyWith<$Res> {
  factory $BulkApprovalResultCopyWith(
          BulkApprovalResult value, $Res Function(BulkApprovalResult) then) =
      _$BulkApprovalResultCopyWithImpl<$Res, BulkApprovalResult>;
  @useResult
  $Res call(
      {@JsonKey(name: 'total_processed') int totalProcessed,
      @JsonKey(name: 'success_count') int successCount,
      @JsonKey(name: 'failure_count') int failureCount,
      @JsonKey(name: 'successful_ids', defaultValue: <String>[])
      List<String> successfulIds,
      @JsonKey(defaultValue: <BulkApprovalError>[])
      List<BulkApprovalError> errors});
}

/// @nodoc
class _$BulkApprovalResultCopyWithImpl<$Res, $Val extends BulkApprovalResult>
    implements $BulkApprovalResultCopyWith<$Res> {
  _$BulkApprovalResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BulkApprovalResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalProcessed = null,
    Object? successCount = null,
    Object? failureCount = null,
    Object? successfulIds = null,
    Object? errors = null,
  }) {
    return _then(_value.copyWith(
      totalProcessed: null == totalProcessed
          ? _value.totalProcessed
          : totalProcessed // ignore: cast_nullable_to_non_nullable
              as int,
      successCount: null == successCount
          ? _value.successCount
          : successCount // ignore: cast_nullable_to_non_nullable
              as int,
      failureCount: null == failureCount
          ? _value.failureCount
          : failureCount // ignore: cast_nullable_to_non_nullable
              as int,
      successfulIds: null == successfulIds
          ? _value.successfulIds
          : successfulIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      errors: null == errors
          ? _value.errors
          : errors // ignore: cast_nullable_to_non_nullable
              as List<BulkApprovalError>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BulkApprovalResultImplCopyWith<$Res>
    implements $BulkApprovalResultCopyWith<$Res> {
  factory _$$BulkApprovalResultImplCopyWith(_$BulkApprovalResultImpl value,
          $Res Function(_$BulkApprovalResultImpl) then) =
      __$$BulkApprovalResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'total_processed') int totalProcessed,
      @JsonKey(name: 'success_count') int successCount,
      @JsonKey(name: 'failure_count') int failureCount,
      @JsonKey(name: 'successful_ids', defaultValue: <String>[])
      List<String> successfulIds,
      @JsonKey(defaultValue: <BulkApprovalError>[])
      List<BulkApprovalError> errors});
}

/// @nodoc
class __$$BulkApprovalResultImplCopyWithImpl<$Res>
    extends _$BulkApprovalResultCopyWithImpl<$Res, _$BulkApprovalResultImpl>
    implements _$$BulkApprovalResultImplCopyWith<$Res> {
  __$$BulkApprovalResultImplCopyWithImpl(_$BulkApprovalResultImpl _value,
      $Res Function(_$BulkApprovalResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of BulkApprovalResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalProcessed = null,
    Object? successCount = null,
    Object? failureCount = null,
    Object? successfulIds = null,
    Object? errors = null,
  }) {
    return _then(_$BulkApprovalResultImpl(
      totalProcessed: null == totalProcessed
          ? _value.totalProcessed
          : totalProcessed // ignore: cast_nullable_to_non_nullable
              as int,
      successCount: null == successCount
          ? _value.successCount
          : successCount // ignore: cast_nullable_to_non_nullable
              as int,
      failureCount: null == failureCount
          ? _value.failureCount
          : failureCount // ignore: cast_nullable_to_non_nullable
              as int,
      successfulIds: null == successfulIds
          ? _value._successfulIds
          : successfulIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      errors: null == errors
          ? _value._errors
          : errors // ignore: cast_nullable_to_non_nullable
              as List<BulkApprovalError>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BulkApprovalResultImpl extends _BulkApprovalResult {
  const _$BulkApprovalResultImpl(
      {@JsonKey(name: 'total_processed') required this.totalProcessed,
      @JsonKey(name: 'success_count') required this.successCount,
      @JsonKey(name: 'failure_count') required this.failureCount,
      @JsonKey(name: 'successful_ids', defaultValue: <String>[])
      required final List<String> successfulIds,
      @JsonKey(defaultValue: <BulkApprovalError>[])
      required final List<BulkApprovalError> errors})
      : _successfulIds = successfulIds,
        _errors = errors,
        super._();

  factory _$BulkApprovalResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$BulkApprovalResultImplFromJson(json);

  /// Total number of requests processed
  @override
  @JsonKey(name: 'total_processed')
  final int totalProcessed;

  /// Number of successfully processed requests
  @override
  @JsonKey(name: 'success_count')
  final int successCount;

  /// Number of failed requests
  @override
  @JsonKey(name: 'failure_count')
  final int failureCount;

  /// List of successfully processed shift request IDs
  final List<String> _successfulIds;

  /// List of successfully processed shift request IDs
  @override
  @JsonKey(name: 'successful_ids', defaultValue: <String>[])
  List<String> get successfulIds {
    if (_successfulIds is EqualUnmodifiableListView) return _successfulIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_successfulIds);
  }

  /// List of errors encountered during processing
  final List<BulkApprovalError> _errors;

  /// List of errors encountered during processing
  @override
  @JsonKey(defaultValue: <BulkApprovalError>[])
  List<BulkApprovalError> get errors {
    if (_errors is EqualUnmodifiableListView) return _errors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_errors);
  }

  @override
  String toString() {
    return 'BulkApprovalResult(totalProcessed: $totalProcessed, successCount: $successCount, failureCount: $failureCount, successfulIds: $successfulIds, errors: $errors)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BulkApprovalResultImpl &&
            (identical(other.totalProcessed, totalProcessed) ||
                other.totalProcessed == totalProcessed) &&
            (identical(other.successCount, successCount) ||
                other.successCount == successCount) &&
            (identical(other.failureCount, failureCount) ||
                other.failureCount == failureCount) &&
            const DeepCollectionEquality()
                .equals(other._successfulIds, _successfulIds) &&
            const DeepCollectionEquality().equals(other._errors, _errors));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalProcessed,
      successCount,
      failureCount,
      const DeepCollectionEquality().hash(_successfulIds),
      const DeepCollectionEquality().hash(_errors));

  /// Create a copy of BulkApprovalResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BulkApprovalResultImplCopyWith<_$BulkApprovalResultImpl> get copyWith =>
      __$$BulkApprovalResultImplCopyWithImpl<_$BulkApprovalResultImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BulkApprovalResultImplToJson(
      this,
    );
  }
}

abstract class _BulkApprovalResult extends BulkApprovalResult {
  const factory _BulkApprovalResult(
          {@JsonKey(name: 'total_processed') required final int totalProcessed,
          @JsonKey(name: 'success_count') required final int successCount,
          @JsonKey(name: 'failure_count') required final int failureCount,
          @JsonKey(name: 'successful_ids', defaultValue: <String>[])
          required final List<String> successfulIds,
          @JsonKey(defaultValue: <BulkApprovalError>[])
          required final List<BulkApprovalError> errors}) =
      _$BulkApprovalResultImpl;
  const _BulkApprovalResult._() : super._();

  factory _BulkApprovalResult.fromJson(Map<String, dynamic> json) =
      _$BulkApprovalResultImpl.fromJson;

  /// Total number of requests processed
  @override
  @JsonKey(name: 'total_processed')
  int get totalProcessed;

  /// Number of successfully processed requests
  @override
  @JsonKey(name: 'success_count')
  int get successCount;

  /// Number of failed requests
  @override
  @JsonKey(name: 'failure_count')
  int get failureCount;

  /// List of successfully processed shift request IDs
  @override
  @JsonKey(name: 'successful_ids', defaultValue: <String>[])
  List<String> get successfulIds;

  /// List of errors encountered during processing
  @override
  @JsonKey(defaultValue: <BulkApprovalError>[])
  List<BulkApprovalError> get errors;

  /// Create a copy of BulkApprovalResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BulkApprovalResultImplCopyWith<_$BulkApprovalResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BulkApprovalError _$BulkApprovalErrorFromJson(Map<String, dynamic> json) {
  return _BulkApprovalError.fromJson(json);
}

/// @nodoc
mixin _$BulkApprovalError {
  /// The shift request ID that failed
  @JsonKey(name: 'shift_request_id')
  String get shiftRequestId => throw _privateConstructorUsedError;

  /// Error message describing what went wrong
  @JsonKey(name: 'error_message')
  String get errorMessage => throw _privateConstructorUsedError;

  /// Optional error code
  @JsonKey(name: 'error_code')
  String? get errorCode => throw _privateConstructorUsedError;

  /// Serializes this BulkApprovalError to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BulkApprovalError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BulkApprovalErrorCopyWith<BulkApprovalError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BulkApprovalErrorCopyWith<$Res> {
  factory $BulkApprovalErrorCopyWith(
          BulkApprovalError value, $Res Function(BulkApprovalError) then) =
      _$BulkApprovalErrorCopyWithImpl<$Res, BulkApprovalError>;
  @useResult
  $Res call(
      {@JsonKey(name: 'shift_request_id') String shiftRequestId,
      @JsonKey(name: 'error_message') String errorMessage,
      @JsonKey(name: 'error_code') String? errorCode});
}

/// @nodoc
class _$BulkApprovalErrorCopyWithImpl<$Res, $Val extends BulkApprovalError>
    implements $BulkApprovalErrorCopyWith<$Res> {
  _$BulkApprovalErrorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BulkApprovalError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shiftRequestId = null,
    Object? errorMessage = null,
    Object? errorCode = freezed,
  }) {
    return _then(_value.copyWith(
      shiftRequestId: null == shiftRequestId
          ? _value.shiftRequestId
          : shiftRequestId // ignore: cast_nullable_to_non_nullable
              as String,
      errorMessage: null == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String,
      errorCode: freezed == errorCode
          ? _value.errorCode
          : errorCode // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BulkApprovalErrorImplCopyWith<$Res>
    implements $BulkApprovalErrorCopyWith<$Res> {
  factory _$$BulkApprovalErrorImplCopyWith(_$BulkApprovalErrorImpl value,
          $Res Function(_$BulkApprovalErrorImpl) then) =
      __$$BulkApprovalErrorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'shift_request_id') String shiftRequestId,
      @JsonKey(name: 'error_message') String errorMessage,
      @JsonKey(name: 'error_code') String? errorCode});
}

/// @nodoc
class __$$BulkApprovalErrorImplCopyWithImpl<$Res>
    extends _$BulkApprovalErrorCopyWithImpl<$Res, _$BulkApprovalErrorImpl>
    implements _$$BulkApprovalErrorImplCopyWith<$Res> {
  __$$BulkApprovalErrorImplCopyWithImpl(_$BulkApprovalErrorImpl _value,
      $Res Function(_$BulkApprovalErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of BulkApprovalError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shiftRequestId = null,
    Object? errorMessage = null,
    Object? errorCode = freezed,
  }) {
    return _then(_$BulkApprovalErrorImpl(
      shiftRequestId: null == shiftRequestId
          ? _value.shiftRequestId
          : shiftRequestId // ignore: cast_nullable_to_non_nullable
              as String,
      errorMessage: null == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String,
      errorCode: freezed == errorCode
          ? _value.errorCode
          : errorCode // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BulkApprovalErrorImpl implements _BulkApprovalError {
  const _$BulkApprovalErrorImpl(
      {@JsonKey(name: 'shift_request_id') required this.shiftRequestId,
      @JsonKey(name: 'error_message') required this.errorMessage,
      @JsonKey(name: 'error_code') this.errorCode});

  factory _$BulkApprovalErrorImpl.fromJson(Map<String, dynamic> json) =>
      _$$BulkApprovalErrorImplFromJson(json);

  /// The shift request ID that failed
  @override
  @JsonKey(name: 'shift_request_id')
  final String shiftRequestId;

  /// Error message describing what went wrong
  @override
  @JsonKey(name: 'error_message')
  final String errorMessage;

  /// Optional error code
  @override
  @JsonKey(name: 'error_code')
  final String? errorCode;

  @override
  String toString() {
    return 'BulkApprovalError(shiftRequestId: $shiftRequestId, errorMessage: $errorMessage, errorCode: $errorCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BulkApprovalErrorImpl &&
            (identical(other.shiftRequestId, shiftRequestId) ||
                other.shiftRequestId == shiftRequestId) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.errorCode, errorCode) ||
                other.errorCode == errorCode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, shiftRequestId, errorMessage, errorCode);

  /// Create a copy of BulkApprovalError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BulkApprovalErrorImplCopyWith<_$BulkApprovalErrorImpl> get copyWith =>
      __$$BulkApprovalErrorImplCopyWithImpl<_$BulkApprovalErrorImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BulkApprovalErrorImplToJson(
      this,
    );
  }
}

abstract class _BulkApprovalError implements BulkApprovalError {
  const factory _BulkApprovalError(
      {@JsonKey(name: 'shift_request_id') required final String shiftRequestId,
      @JsonKey(name: 'error_message') required final String errorMessage,
      @JsonKey(name: 'error_code')
      final String? errorCode}) = _$BulkApprovalErrorImpl;

  factory _BulkApprovalError.fromJson(Map<String, dynamic> json) =
      _$BulkApprovalErrorImpl.fromJson;

  /// The shift request ID that failed
  @override
  @JsonKey(name: 'shift_request_id')
  String get shiftRequestId;

  /// Error message describing what went wrong
  @override
  @JsonKey(name: 'error_message')
  String get errorMessage;

  /// Optional error code
  @override
  @JsonKey(name: 'error_code')
  String? get errorCode;

  /// Create a copy of BulkApprovalError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BulkApprovalErrorImplCopyWith<_$BulkApprovalErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
