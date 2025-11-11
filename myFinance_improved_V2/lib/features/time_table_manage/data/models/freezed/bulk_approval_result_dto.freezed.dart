// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bulk_approval_result_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BulkApprovalResultDto _$BulkApprovalResultDtoFromJson(
    Map<String, dynamic> json) {
  return _BulkApprovalResultDto.fromJson(json);
}

/// @nodoc
mixin _$BulkApprovalResultDto {
  /// Total number of shift requests processed
  @JsonKey(name: 'total_processed')
  int get totalProcessed => throw _privateConstructorUsedError;

  /// Number of successful approvals/rejections
  @JsonKey(name: 'success_count')
  int get successCount => throw _privateConstructorUsedError;

  /// Number of failed operations
  @JsonKey(name: 'failure_count')
  int get failureCount => throw _privateConstructorUsedError;

  /// List of successfully processed shift request IDs
  @JsonKey(name: 'successful_ids')
  List<String> get successfulIds => throw _privateConstructorUsedError;

  /// List of errors for failed operations
  @JsonKey(name: 'errors')
  List<BulkApprovalErrorDto> get errors => throw _privateConstructorUsedError;

  /// Serializes this BulkApprovalResultDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BulkApprovalResultDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BulkApprovalResultDtoCopyWith<BulkApprovalResultDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BulkApprovalResultDtoCopyWith<$Res> {
  factory $BulkApprovalResultDtoCopyWith(BulkApprovalResultDto value,
          $Res Function(BulkApprovalResultDto) then) =
      _$BulkApprovalResultDtoCopyWithImpl<$Res, BulkApprovalResultDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'total_processed') int totalProcessed,
      @JsonKey(name: 'success_count') int successCount,
      @JsonKey(name: 'failure_count') int failureCount,
      @JsonKey(name: 'successful_ids') List<String> successfulIds,
      @JsonKey(name: 'errors') List<BulkApprovalErrorDto> errors});
}

/// @nodoc
class _$BulkApprovalResultDtoCopyWithImpl<$Res,
        $Val extends BulkApprovalResultDto>
    implements $BulkApprovalResultDtoCopyWith<$Res> {
  _$BulkApprovalResultDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BulkApprovalResultDto
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
              as List<BulkApprovalErrorDto>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BulkApprovalResultDtoImplCopyWith<$Res>
    implements $BulkApprovalResultDtoCopyWith<$Res> {
  factory _$$BulkApprovalResultDtoImplCopyWith(
          _$BulkApprovalResultDtoImpl value,
          $Res Function(_$BulkApprovalResultDtoImpl) then) =
      __$$BulkApprovalResultDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'total_processed') int totalProcessed,
      @JsonKey(name: 'success_count') int successCount,
      @JsonKey(name: 'failure_count') int failureCount,
      @JsonKey(name: 'successful_ids') List<String> successfulIds,
      @JsonKey(name: 'errors') List<BulkApprovalErrorDto> errors});
}

/// @nodoc
class __$$BulkApprovalResultDtoImplCopyWithImpl<$Res>
    extends _$BulkApprovalResultDtoCopyWithImpl<$Res,
        _$BulkApprovalResultDtoImpl>
    implements _$$BulkApprovalResultDtoImplCopyWith<$Res> {
  __$$BulkApprovalResultDtoImplCopyWithImpl(_$BulkApprovalResultDtoImpl _value,
      $Res Function(_$BulkApprovalResultDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of BulkApprovalResultDto
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
    return _then(_$BulkApprovalResultDtoImpl(
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
              as List<BulkApprovalErrorDto>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BulkApprovalResultDtoImpl implements _BulkApprovalResultDto {
  const _$BulkApprovalResultDtoImpl(
      {@JsonKey(name: 'total_processed') this.totalProcessed = 0,
      @JsonKey(name: 'success_count') this.successCount = 0,
      @JsonKey(name: 'failure_count') this.failureCount = 0,
      @JsonKey(name: 'successful_ids')
      final List<String> successfulIds = const [],
      @JsonKey(name: 'errors')
      final List<BulkApprovalErrorDto> errors = const []})
      : _successfulIds = successfulIds,
        _errors = errors;

  factory _$BulkApprovalResultDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$BulkApprovalResultDtoImplFromJson(json);

  /// Total number of shift requests processed
  @override
  @JsonKey(name: 'total_processed')
  final int totalProcessed;

  /// Number of successful approvals/rejections
  @override
  @JsonKey(name: 'success_count')
  final int successCount;

  /// Number of failed operations
  @override
  @JsonKey(name: 'failure_count')
  final int failureCount;

  /// List of successfully processed shift request IDs
  final List<String> _successfulIds;

  /// List of successfully processed shift request IDs
  @override
  @JsonKey(name: 'successful_ids')
  List<String> get successfulIds {
    if (_successfulIds is EqualUnmodifiableListView) return _successfulIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_successfulIds);
  }

  /// List of errors for failed operations
  final List<BulkApprovalErrorDto> _errors;

  /// List of errors for failed operations
  @override
  @JsonKey(name: 'errors')
  List<BulkApprovalErrorDto> get errors {
    if (_errors is EqualUnmodifiableListView) return _errors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_errors);
  }

  @override
  String toString() {
    return 'BulkApprovalResultDto(totalProcessed: $totalProcessed, successCount: $successCount, failureCount: $failureCount, successfulIds: $successfulIds, errors: $errors)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BulkApprovalResultDtoImpl &&
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

  /// Create a copy of BulkApprovalResultDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BulkApprovalResultDtoImplCopyWith<_$BulkApprovalResultDtoImpl>
      get copyWith => __$$BulkApprovalResultDtoImplCopyWithImpl<
          _$BulkApprovalResultDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BulkApprovalResultDtoImplToJson(
      this,
    );
  }
}

abstract class _BulkApprovalResultDto implements BulkApprovalResultDto {
  const factory _BulkApprovalResultDto(
          {@JsonKey(name: 'total_processed') final int totalProcessed,
          @JsonKey(name: 'success_count') final int successCount,
          @JsonKey(name: 'failure_count') final int failureCount,
          @JsonKey(name: 'successful_ids') final List<String> successfulIds,
          @JsonKey(name: 'errors') final List<BulkApprovalErrorDto> errors}) =
      _$BulkApprovalResultDtoImpl;

  factory _BulkApprovalResultDto.fromJson(Map<String, dynamic> json) =
      _$BulkApprovalResultDtoImpl.fromJson;

  /// Total number of shift requests processed
  @override
  @JsonKey(name: 'total_processed')
  int get totalProcessed;

  /// Number of successful approvals/rejections
  @override
  @JsonKey(name: 'success_count')
  int get successCount;

  /// Number of failed operations
  @override
  @JsonKey(name: 'failure_count')
  int get failureCount;

  /// List of successfully processed shift request IDs
  @override
  @JsonKey(name: 'successful_ids')
  List<String> get successfulIds;

  /// List of errors for failed operations
  @override
  @JsonKey(name: 'errors')
  List<BulkApprovalErrorDto> get errors;

  /// Create a copy of BulkApprovalResultDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BulkApprovalResultDtoImplCopyWith<_$BulkApprovalResultDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

BulkApprovalErrorDto _$BulkApprovalErrorDtoFromJson(Map<String, dynamic> json) {
  return _BulkApprovalErrorDto.fromJson(json);
}

/// @nodoc
mixin _$BulkApprovalErrorDto {
  /// Shift request ID that failed
  @JsonKey(name: 'shift_request_id')
  String get shiftRequestId => throw _privateConstructorUsedError;

  /// Error message describing the failure
  @JsonKey(name: 'error_message')
  String get errorMessage => throw _privateConstructorUsedError;

  /// Optional error code for categorization
  @JsonKey(name: 'error_code')
  String? get errorCode => throw _privateConstructorUsedError;

  /// Serializes this BulkApprovalErrorDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BulkApprovalErrorDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BulkApprovalErrorDtoCopyWith<BulkApprovalErrorDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BulkApprovalErrorDtoCopyWith<$Res> {
  factory $BulkApprovalErrorDtoCopyWith(BulkApprovalErrorDto value,
          $Res Function(BulkApprovalErrorDto) then) =
      _$BulkApprovalErrorDtoCopyWithImpl<$Res, BulkApprovalErrorDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'shift_request_id') String shiftRequestId,
      @JsonKey(name: 'error_message') String errorMessage,
      @JsonKey(name: 'error_code') String? errorCode});
}

/// @nodoc
class _$BulkApprovalErrorDtoCopyWithImpl<$Res,
        $Val extends BulkApprovalErrorDto>
    implements $BulkApprovalErrorDtoCopyWith<$Res> {
  _$BulkApprovalErrorDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BulkApprovalErrorDto
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
abstract class _$$BulkApprovalErrorDtoImplCopyWith<$Res>
    implements $BulkApprovalErrorDtoCopyWith<$Res> {
  factory _$$BulkApprovalErrorDtoImplCopyWith(_$BulkApprovalErrorDtoImpl value,
          $Res Function(_$BulkApprovalErrorDtoImpl) then) =
      __$$BulkApprovalErrorDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'shift_request_id') String shiftRequestId,
      @JsonKey(name: 'error_message') String errorMessage,
      @JsonKey(name: 'error_code') String? errorCode});
}

/// @nodoc
class __$$BulkApprovalErrorDtoImplCopyWithImpl<$Res>
    extends _$BulkApprovalErrorDtoCopyWithImpl<$Res, _$BulkApprovalErrorDtoImpl>
    implements _$$BulkApprovalErrorDtoImplCopyWith<$Res> {
  __$$BulkApprovalErrorDtoImplCopyWithImpl(_$BulkApprovalErrorDtoImpl _value,
      $Res Function(_$BulkApprovalErrorDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of BulkApprovalErrorDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shiftRequestId = null,
    Object? errorMessage = null,
    Object? errorCode = freezed,
  }) {
    return _then(_$BulkApprovalErrorDtoImpl(
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
class _$BulkApprovalErrorDtoImpl implements _BulkApprovalErrorDto {
  const _$BulkApprovalErrorDtoImpl(
      {@JsonKey(name: 'shift_request_id') this.shiftRequestId = '',
      @JsonKey(name: 'error_message') this.errorMessage = '',
      @JsonKey(name: 'error_code') this.errorCode});

  factory _$BulkApprovalErrorDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$BulkApprovalErrorDtoImplFromJson(json);

  /// Shift request ID that failed
  @override
  @JsonKey(name: 'shift_request_id')
  final String shiftRequestId;

  /// Error message describing the failure
  @override
  @JsonKey(name: 'error_message')
  final String errorMessage;

  /// Optional error code for categorization
  @override
  @JsonKey(name: 'error_code')
  final String? errorCode;

  @override
  String toString() {
    return 'BulkApprovalErrorDto(shiftRequestId: $shiftRequestId, errorMessage: $errorMessage, errorCode: $errorCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BulkApprovalErrorDtoImpl &&
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

  /// Create a copy of BulkApprovalErrorDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BulkApprovalErrorDtoImplCopyWith<_$BulkApprovalErrorDtoImpl>
      get copyWith =>
          __$$BulkApprovalErrorDtoImplCopyWithImpl<_$BulkApprovalErrorDtoImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BulkApprovalErrorDtoImplToJson(
      this,
    );
  }
}

abstract class _BulkApprovalErrorDto implements BulkApprovalErrorDto {
  const factory _BulkApprovalErrorDto(
          {@JsonKey(name: 'shift_request_id') final String shiftRequestId,
          @JsonKey(name: 'error_message') final String errorMessage,
          @JsonKey(name: 'error_code') final String? errorCode}) =
      _$BulkApprovalErrorDtoImpl;

  factory _BulkApprovalErrorDto.fromJson(Map<String, dynamic> json) =
      _$BulkApprovalErrorDtoImpl.fromJson;

  /// Shift request ID that failed
  @override
  @JsonKey(name: 'shift_request_id')
  String get shiftRequestId;

  /// Error message describing the failure
  @override
  @JsonKey(name: 'error_message')
  String get errorMessage;

  /// Optional error code for categorization
  @override
  @JsonKey(name: 'error_code')
  String? get errorCode;

  /// Create a copy of BulkApprovalErrorDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BulkApprovalErrorDtoImplCopyWith<_$BulkApprovalErrorDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
