// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'operation_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OperationResult _$OperationResultFromJson(Map<String, dynamic> json) {
  return _OperationResult.fromJson(json);
}

/// @nodoc
mixin _$OperationResult {
  /// Whether the operation was successful
  bool get success => throw _privateConstructorUsedError;

  /// Optional message describing the result
  String? get message => throw _privateConstructorUsedError;

  /// Optional error code if operation failed
  @JsonKey(name: 'error_code')
  String? get errorCode => throw _privateConstructorUsedError;

  /// Additional metadata about the operation
  @JsonKey(defaultValue: <String, dynamic>{})
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  /// Serializes this OperationResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OperationResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OperationResultCopyWith<OperationResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OperationResultCopyWith<$Res> {
  factory $OperationResultCopyWith(
          OperationResult value, $Res Function(OperationResult) then) =
      _$OperationResultCopyWithImpl<$Res, OperationResult>;
  @useResult
  $Res call(
      {bool success,
      String? message,
      @JsonKey(name: 'error_code') String? errorCode,
      @JsonKey(defaultValue: <String, dynamic>{})
      Map<String, dynamic> metadata});
}

/// @nodoc
class _$OperationResultCopyWithImpl<$Res, $Val extends OperationResult>
    implements $OperationResultCopyWith<$Res> {
  _$OperationResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OperationResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = freezed,
    Object? errorCode = freezed,
    Object? metadata = null,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      errorCode: freezed == errorCode
          ? _value.errorCode
          : errorCode // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OperationResultImplCopyWith<$Res>
    implements $OperationResultCopyWith<$Res> {
  factory _$$OperationResultImplCopyWith(_$OperationResultImpl value,
          $Res Function(_$OperationResultImpl) then) =
      __$$OperationResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool success,
      String? message,
      @JsonKey(name: 'error_code') String? errorCode,
      @JsonKey(defaultValue: <String, dynamic>{})
      Map<String, dynamic> metadata});
}

/// @nodoc
class __$$OperationResultImplCopyWithImpl<$Res>
    extends _$OperationResultCopyWithImpl<$Res, _$OperationResultImpl>
    implements _$$OperationResultImplCopyWith<$Res> {
  __$$OperationResultImplCopyWithImpl(
      _$OperationResultImpl _value, $Res Function(_$OperationResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of OperationResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = freezed,
    Object? errorCode = freezed,
    Object? metadata = null,
  }) {
    return _then(_$OperationResultImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      errorCode: freezed == errorCode
          ? _value.errorCode
          : errorCode // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OperationResultImpl extends _OperationResult {
  const _$OperationResultImpl(
      {required this.success,
      this.message,
      @JsonKey(name: 'error_code') this.errorCode,
      @JsonKey(defaultValue: <String, dynamic>{})
      required final Map<String, dynamic> metadata})
      : _metadata = metadata,
        super._();

  factory _$OperationResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$OperationResultImplFromJson(json);

  /// Whether the operation was successful
  @override
  final bool success;

  /// Optional message describing the result
  @override
  final String? message;

  /// Optional error code if operation failed
  @override
  @JsonKey(name: 'error_code')
  final String? errorCode;

  /// Additional metadata about the operation
  final Map<String, dynamic> _metadata;

  /// Additional metadata about the operation
  @override
  @JsonKey(defaultValue: <String, dynamic>{})
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  String toString() {
    return 'OperationResult(success: $success, message: $message, errorCode: $errorCode, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OperationResultImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.errorCode, errorCode) ||
                other.errorCode == errorCode) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, success, message, errorCode,
      const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of OperationResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OperationResultImplCopyWith<_$OperationResultImpl> get copyWith =>
      __$$OperationResultImplCopyWithImpl<_$OperationResultImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OperationResultImplToJson(
      this,
    );
  }
}

abstract class _OperationResult extends OperationResult {
  const factory _OperationResult(
      {required final bool success,
      final String? message,
      @JsonKey(name: 'error_code') final String? errorCode,
      @JsonKey(defaultValue: <String, dynamic>{})
      required final Map<String, dynamic> metadata}) = _$OperationResultImpl;
  const _OperationResult._() : super._();

  factory _OperationResult.fromJson(Map<String, dynamic> json) =
      _$OperationResultImpl.fromJson;

  /// Whether the operation was successful
  @override
  bool get success;

  /// Optional message describing the result
  @override
  String? get message;

  /// Optional error code if operation failed
  @override
  @JsonKey(name: 'error_code')
  String? get errorCode;

  /// Additional metadata about the operation
  @override
  @JsonKey(defaultValue: <String, dynamic>{})
  Map<String, dynamic> get metadata;

  /// Create a copy of OperationResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OperationResultImplCopyWith<_$OperationResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
