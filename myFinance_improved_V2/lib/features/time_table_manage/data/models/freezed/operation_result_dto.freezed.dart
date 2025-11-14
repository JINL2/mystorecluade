// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'operation_result_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OperationResultDto _$OperationResultDtoFromJson(Map<String, dynamic> json) {
  return _OperationResultDto.fromJson(json);
}

/// @nodoc
mixin _$OperationResultDto {
  /// Whether the operation succeeded
  @JsonKey(name: 'success')
  bool get success => throw _privateConstructorUsedError;

  /// Optional message describing the result
  @JsonKey(name: 'message')
  String? get message => throw _privateConstructorUsedError;

  /// Optional error code for failures
  @JsonKey(name: 'error_code')
  String? get errorCode => throw _privateConstructorUsedError;

  /// Additional metadata from the operation
  @JsonKey(name: 'metadata')
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  /// Serializes this OperationResultDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OperationResultDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OperationResultDtoCopyWith<OperationResultDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OperationResultDtoCopyWith<$Res> {
  factory $OperationResultDtoCopyWith(
          OperationResultDto value, $Res Function(OperationResultDto) then) =
      _$OperationResultDtoCopyWithImpl<$Res, OperationResultDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'success') bool success,
      @JsonKey(name: 'message') String? message,
      @JsonKey(name: 'error_code') String? errorCode,
      @JsonKey(name: 'metadata') Map<String, dynamic> metadata});
}

/// @nodoc
class _$OperationResultDtoCopyWithImpl<$Res, $Val extends OperationResultDto>
    implements $OperationResultDtoCopyWith<$Res> {
  _$OperationResultDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OperationResultDto
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
abstract class _$$OperationResultDtoImplCopyWith<$Res>
    implements $OperationResultDtoCopyWith<$Res> {
  factory _$$OperationResultDtoImplCopyWith(_$OperationResultDtoImpl value,
          $Res Function(_$OperationResultDtoImpl) then) =
      __$$OperationResultDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'success') bool success,
      @JsonKey(name: 'message') String? message,
      @JsonKey(name: 'error_code') String? errorCode,
      @JsonKey(name: 'metadata') Map<String, dynamic> metadata});
}

/// @nodoc
class __$$OperationResultDtoImplCopyWithImpl<$Res>
    extends _$OperationResultDtoCopyWithImpl<$Res, _$OperationResultDtoImpl>
    implements _$$OperationResultDtoImplCopyWith<$Res> {
  __$$OperationResultDtoImplCopyWithImpl(_$OperationResultDtoImpl _value,
      $Res Function(_$OperationResultDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of OperationResultDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = freezed,
    Object? errorCode = freezed,
    Object? metadata = null,
  }) {
    return _then(_$OperationResultDtoImpl(
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
class _$OperationResultDtoImpl implements _OperationResultDto {
  const _$OperationResultDtoImpl(
      {@JsonKey(name: 'success') this.success = false,
      @JsonKey(name: 'message') this.message,
      @JsonKey(name: 'error_code') this.errorCode,
      @JsonKey(name: 'metadata')
      final Map<String, dynamic> metadata = const {}})
      : _metadata = metadata;

  factory _$OperationResultDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$OperationResultDtoImplFromJson(json);

  /// Whether the operation succeeded
  @override
  @JsonKey(name: 'success')
  final bool success;

  /// Optional message describing the result
  @override
  @JsonKey(name: 'message')
  final String? message;

  /// Optional error code for failures
  @override
  @JsonKey(name: 'error_code')
  final String? errorCode;

  /// Additional metadata from the operation
  final Map<String, dynamic> _metadata;

  /// Additional metadata from the operation
  @override
  @JsonKey(name: 'metadata')
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  String toString() {
    return 'OperationResultDto(success: $success, message: $message, errorCode: $errorCode, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OperationResultDtoImpl &&
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

  /// Create a copy of OperationResultDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OperationResultDtoImplCopyWith<_$OperationResultDtoImpl> get copyWith =>
      __$$OperationResultDtoImplCopyWithImpl<_$OperationResultDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OperationResultDtoImplToJson(
      this,
    );
  }
}

abstract class _OperationResultDto implements OperationResultDto {
  const factory _OperationResultDto(
          {@JsonKey(name: 'success') final bool success,
          @JsonKey(name: 'message') final String? message,
          @JsonKey(name: 'error_code') final String? errorCode,
          @JsonKey(name: 'metadata') final Map<String, dynamic> metadata}) =
      _$OperationResultDtoImpl;

  factory _OperationResultDto.fromJson(Map<String, dynamic> json) =
      _$OperationResultDtoImpl.fromJson;

  /// Whether the operation succeeded
  @override
  @JsonKey(name: 'success')
  bool get success;

  /// Optional message describing the result
  @override
  @JsonKey(name: 'message')
  String? get message;

  /// Optional error code for failures
  @override
  @JsonKey(name: 'error_code')
  String? get errorCode;

  /// Additional metadata from the operation
  @override
  @JsonKey(name: 'metadata')
  Map<String, dynamic> get metadata;

  /// Create a copy of OperationResultDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OperationResultDtoImplCopyWith<_$OperationResultDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
