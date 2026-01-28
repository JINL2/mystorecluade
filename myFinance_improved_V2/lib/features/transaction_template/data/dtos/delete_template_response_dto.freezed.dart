// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delete_template_response_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DeleteTemplateResponseDto _$DeleteTemplateResponseDtoFromJson(
    Map<String, dynamic> json) {
  return _DeleteTemplateResponseDto.fromJson(json);
}

/// @nodoc
mixin _$DeleteTemplateResponseDto {
  bool get success => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  DeleteTemplateDataDto? get data => throw _privateConstructorUsedError;

  /// Serializes this DeleteTemplateResponseDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DeleteTemplateResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeleteTemplateResponseDtoCopyWith<DeleteTemplateResponseDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeleteTemplateResponseDtoCopyWith<$Res> {
  factory $DeleteTemplateResponseDtoCopyWith(DeleteTemplateResponseDto value,
          $Res Function(DeleteTemplateResponseDto) then) =
      _$DeleteTemplateResponseDtoCopyWithImpl<$Res, DeleteTemplateResponseDto>;
  @useResult
  $Res call(
      {bool success,
      String? error,
      String? message,
      DeleteTemplateDataDto? data});

  $DeleteTemplateDataDtoCopyWith<$Res>? get data;
}

/// @nodoc
class _$DeleteTemplateResponseDtoCopyWithImpl<$Res,
        $Val extends DeleteTemplateResponseDto>
    implements $DeleteTemplateResponseDtoCopyWith<$Res> {
  _$DeleteTemplateResponseDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeleteTemplateResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? error = freezed,
    Object? message = freezed,
    Object? data = freezed,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as DeleteTemplateDataDto?,
    ) as $Val);
  }

  /// Create a copy of DeleteTemplateResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DeleteTemplateDataDtoCopyWith<$Res>? get data {
    if (_value.data == null) {
      return null;
    }

    return $DeleteTemplateDataDtoCopyWith<$Res>(_value.data!, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DeleteTemplateResponseDtoImplCopyWith<$Res>
    implements $DeleteTemplateResponseDtoCopyWith<$Res> {
  factory _$$DeleteTemplateResponseDtoImplCopyWith(
          _$DeleteTemplateResponseDtoImpl value,
          $Res Function(_$DeleteTemplateResponseDtoImpl) then) =
      __$$DeleteTemplateResponseDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool success,
      String? error,
      String? message,
      DeleteTemplateDataDto? data});

  @override
  $DeleteTemplateDataDtoCopyWith<$Res>? get data;
}

/// @nodoc
class __$$DeleteTemplateResponseDtoImplCopyWithImpl<$Res>
    extends _$DeleteTemplateResponseDtoCopyWithImpl<$Res,
        _$DeleteTemplateResponseDtoImpl>
    implements _$$DeleteTemplateResponseDtoImplCopyWith<$Res> {
  __$$DeleteTemplateResponseDtoImplCopyWithImpl(
      _$DeleteTemplateResponseDtoImpl _value,
      $Res Function(_$DeleteTemplateResponseDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of DeleteTemplateResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? error = freezed,
    Object? message = freezed,
    Object? data = freezed,
  }) {
    return _then(_$DeleteTemplateResponseDtoImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as DeleteTemplateDataDto?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DeleteTemplateResponseDtoImpl implements _DeleteTemplateResponseDto {
  const _$DeleteTemplateResponseDtoImpl(
      {required this.success, this.error, this.message, this.data});

  factory _$DeleteTemplateResponseDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeleteTemplateResponseDtoImplFromJson(json);

  @override
  final bool success;
  @override
  final String? error;
  @override
  final String? message;
  @override
  final DeleteTemplateDataDto? data;

  @override
  String toString() {
    return 'DeleteTemplateResponseDto(success: $success, error: $error, message: $message, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeleteTemplateResponseDtoImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, success, error, message, data);

  /// Create a copy of DeleteTemplateResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeleteTemplateResponseDtoImplCopyWith<_$DeleteTemplateResponseDtoImpl>
      get copyWith => __$$DeleteTemplateResponseDtoImplCopyWithImpl<
          _$DeleteTemplateResponseDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DeleteTemplateResponseDtoImplToJson(
      this,
    );
  }
}

abstract class _DeleteTemplateResponseDto implements DeleteTemplateResponseDto {
  const factory _DeleteTemplateResponseDto(
      {required final bool success,
      final String? error,
      final String? message,
      final DeleteTemplateDataDto? data}) = _$DeleteTemplateResponseDtoImpl;

  factory _DeleteTemplateResponseDto.fromJson(Map<String, dynamic> json) =
      _$DeleteTemplateResponseDtoImpl.fromJson;

  @override
  bool get success;
  @override
  String? get error;
  @override
  String? get message;
  @override
  DeleteTemplateDataDto? get data;

  /// Create a copy of DeleteTemplateResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeleteTemplateResponseDtoImplCopyWith<_$DeleteTemplateResponseDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

DeleteTemplateDataDto _$DeleteTemplateDataDtoFromJson(
    Map<String, dynamic> json) {
  return _DeleteTemplateDataDto.fromJson(json);
}

/// @nodoc
mixin _$DeleteTemplateDataDto {
  @JsonKey(name: 'template_id')
  String get templateId => throw _privateConstructorUsedError;
  @JsonKey(name: 'deleted_at')
  String? get deletedAt => throw _privateConstructorUsedError;

  /// Serializes this DeleteTemplateDataDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DeleteTemplateDataDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeleteTemplateDataDtoCopyWith<DeleteTemplateDataDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeleteTemplateDataDtoCopyWith<$Res> {
  factory $DeleteTemplateDataDtoCopyWith(DeleteTemplateDataDto value,
          $Res Function(DeleteTemplateDataDto) then) =
      _$DeleteTemplateDataDtoCopyWithImpl<$Res, DeleteTemplateDataDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'template_id') String templateId,
      @JsonKey(name: 'deleted_at') String? deletedAt});
}

/// @nodoc
class _$DeleteTemplateDataDtoCopyWithImpl<$Res,
        $Val extends DeleteTemplateDataDto>
    implements $DeleteTemplateDataDtoCopyWith<$Res> {
  _$DeleteTemplateDataDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeleteTemplateDataDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? templateId = null,
    Object? deletedAt = freezed,
  }) {
    return _then(_value.copyWith(
      templateId: null == templateId
          ? _value.templateId
          : templateId // ignore: cast_nullable_to_non_nullable
              as String,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DeleteTemplateDataDtoImplCopyWith<$Res>
    implements $DeleteTemplateDataDtoCopyWith<$Res> {
  factory _$$DeleteTemplateDataDtoImplCopyWith(
          _$DeleteTemplateDataDtoImpl value,
          $Res Function(_$DeleteTemplateDataDtoImpl) then) =
      __$$DeleteTemplateDataDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'template_id') String templateId,
      @JsonKey(name: 'deleted_at') String? deletedAt});
}

/// @nodoc
class __$$DeleteTemplateDataDtoImplCopyWithImpl<$Res>
    extends _$DeleteTemplateDataDtoCopyWithImpl<$Res,
        _$DeleteTemplateDataDtoImpl>
    implements _$$DeleteTemplateDataDtoImplCopyWith<$Res> {
  __$$DeleteTemplateDataDtoImplCopyWithImpl(_$DeleteTemplateDataDtoImpl _value,
      $Res Function(_$DeleteTemplateDataDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of DeleteTemplateDataDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? templateId = null,
    Object? deletedAt = freezed,
  }) {
    return _then(_$DeleteTemplateDataDtoImpl(
      templateId: null == templateId
          ? _value.templateId
          : templateId // ignore: cast_nullable_to_non_nullable
              as String,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DeleteTemplateDataDtoImpl implements _DeleteTemplateDataDto {
  const _$DeleteTemplateDataDtoImpl(
      {@JsonKey(name: 'template_id') required this.templateId,
      @JsonKey(name: 'deleted_at') this.deletedAt});

  factory _$DeleteTemplateDataDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeleteTemplateDataDtoImplFromJson(json);

  @override
  @JsonKey(name: 'template_id')
  final String templateId;
  @override
  @JsonKey(name: 'deleted_at')
  final String? deletedAt;

  @override
  String toString() {
    return 'DeleteTemplateDataDto(templateId: $templateId, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeleteTemplateDataDtoImpl &&
            (identical(other.templateId, templateId) ||
                other.templateId == templateId) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, templateId, deletedAt);

  /// Create a copy of DeleteTemplateDataDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeleteTemplateDataDtoImplCopyWith<_$DeleteTemplateDataDtoImpl>
      get copyWith => __$$DeleteTemplateDataDtoImplCopyWithImpl<
          _$DeleteTemplateDataDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DeleteTemplateDataDtoImplToJson(
      this,
    );
  }
}

abstract class _DeleteTemplateDataDto implements DeleteTemplateDataDto {
  const factory _DeleteTemplateDataDto(
          {@JsonKey(name: 'template_id') required final String templateId,
          @JsonKey(name: 'deleted_at') final String? deletedAt}) =
      _$DeleteTemplateDataDtoImpl;

  factory _DeleteTemplateDataDto.fromJson(Map<String, dynamic> json) =
      _$DeleteTemplateDataDtoImpl.fromJson;

  @override
  @JsonKey(name: 'template_id')
  String get templateId;
  @override
  @JsonKey(name: 'deleted_at')
  String? get deletedAt;

  /// Create a copy of DeleteTemplateDataDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeleteTemplateDataDtoImplCopyWith<_$DeleteTemplateDataDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
