// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'available_content_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AvailableContentDto _$AvailableContentDtoFromJson(Map<String, dynamic> json) {
  return _AvailableContentDto.fromJson(json);
}

/// @nodoc
mixin _$AvailableContentDto {
  @JsonKey(name: 'content')
  String get content => throw _privateConstructorUsedError;
  @JsonKey(name: 'type')
  String get type => throw _privateConstructorUsedError;

  /// Serializes this AvailableContentDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AvailableContentDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AvailableContentDtoCopyWith<AvailableContentDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AvailableContentDtoCopyWith<$Res> {
  factory $AvailableContentDtoCopyWith(
          AvailableContentDto value, $Res Function(AvailableContentDto) then) =
      _$AvailableContentDtoCopyWithImpl<$Res, AvailableContentDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'content') String content,
      @JsonKey(name: 'type') String type});
}

/// @nodoc
class _$AvailableContentDtoCopyWithImpl<$Res, $Val extends AvailableContentDto>
    implements $AvailableContentDtoCopyWith<$Res> {
  _$AvailableContentDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AvailableContentDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
    Object? type = null,
  }) {
    return _then(_value.copyWith(
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AvailableContentDtoImplCopyWith<$Res>
    implements $AvailableContentDtoCopyWith<$Res> {
  factory _$$AvailableContentDtoImplCopyWith(_$AvailableContentDtoImpl value,
          $Res Function(_$AvailableContentDtoImpl) then) =
      __$$AvailableContentDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'content') String content,
      @JsonKey(name: 'type') String type});
}

/// @nodoc
class __$$AvailableContentDtoImplCopyWithImpl<$Res>
    extends _$AvailableContentDtoCopyWithImpl<$Res, _$AvailableContentDtoImpl>
    implements _$$AvailableContentDtoImplCopyWith<$Res> {
  __$$AvailableContentDtoImplCopyWithImpl(_$AvailableContentDtoImpl _value,
      $Res Function(_$AvailableContentDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of AvailableContentDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
    Object? type = null,
  }) {
    return _then(_$AvailableContentDtoImpl(
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AvailableContentDtoImpl implements _AvailableContentDto {
  const _$AvailableContentDtoImpl(
      {@JsonKey(name: 'content') this.content = '',
      @JsonKey(name: 'type') this.type = ''});

  factory _$AvailableContentDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$AvailableContentDtoImplFromJson(json);

  @override
  @JsonKey(name: 'content')
  final String content;
  @override
  @JsonKey(name: 'type')
  final String type;

  @override
  String toString() {
    return 'AvailableContentDto(content: $content, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AvailableContentDtoImpl &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, content, type);

  /// Create a copy of AvailableContentDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AvailableContentDtoImplCopyWith<_$AvailableContentDtoImpl> get copyWith =>
      __$$AvailableContentDtoImplCopyWithImpl<_$AvailableContentDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AvailableContentDtoImplToJson(
      this,
    );
  }
}

abstract class _AvailableContentDto implements AvailableContentDto {
  const factory _AvailableContentDto(
      {@JsonKey(name: 'content') final String content,
      @JsonKey(name: 'type') final String type}) = _$AvailableContentDtoImpl;

  factory _AvailableContentDto.fromJson(Map<String, dynamic> json) =
      _$AvailableContentDtoImpl.fromJson;

  @override
  @JsonKey(name: 'content')
  String get content;
  @override
  @JsonKey(name: 'type')
  String get type;

  /// Create a copy of AvailableContentDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AvailableContentDtoImplCopyWith<_$AvailableContentDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
