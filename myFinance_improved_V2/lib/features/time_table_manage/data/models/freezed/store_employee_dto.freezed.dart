// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'store_employee_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StoreEmployeeDto _$StoreEmployeeDtoFromJson(Map<String, dynamic> json) {
  return _StoreEmployeeDto.fromJson(json);
}

/// @nodoc
mixin _$StoreEmployeeDto {
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'full_name')
  String get fullName => throw _privateConstructorUsedError;
  @JsonKey(name: 'email')
  String get email => throw _privateConstructorUsedError;
  @JsonKey(name: 'display_name')
  String get displayName => throw _privateConstructorUsedError;

  /// Serializes this StoreEmployeeDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StoreEmployeeDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StoreEmployeeDtoCopyWith<StoreEmployeeDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoreEmployeeDtoCopyWith<$Res> {
  factory $StoreEmployeeDtoCopyWith(
          StoreEmployeeDto value, $Res Function(StoreEmployeeDto) then) =
      _$StoreEmployeeDtoCopyWithImpl<$Res, StoreEmployeeDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'full_name') String fullName,
      @JsonKey(name: 'email') String email,
      @JsonKey(name: 'display_name') String displayName});
}

/// @nodoc
class _$StoreEmployeeDtoCopyWithImpl<$Res, $Val extends StoreEmployeeDto>
    implements $StoreEmployeeDtoCopyWith<$Res> {
  _$StoreEmployeeDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StoreEmployeeDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? fullName = null,
    Object? email = null,
    Object? displayName = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StoreEmployeeDtoImplCopyWith<$Res>
    implements $StoreEmployeeDtoCopyWith<$Res> {
  factory _$$StoreEmployeeDtoImplCopyWith(_$StoreEmployeeDtoImpl value,
          $Res Function(_$StoreEmployeeDtoImpl) then) =
      __$$StoreEmployeeDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'full_name') String fullName,
      @JsonKey(name: 'email') String email,
      @JsonKey(name: 'display_name') String displayName});
}

/// @nodoc
class __$$StoreEmployeeDtoImplCopyWithImpl<$Res>
    extends _$StoreEmployeeDtoCopyWithImpl<$Res, _$StoreEmployeeDtoImpl>
    implements _$$StoreEmployeeDtoImplCopyWith<$Res> {
  __$$StoreEmployeeDtoImplCopyWithImpl(_$StoreEmployeeDtoImpl _value,
      $Res Function(_$StoreEmployeeDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of StoreEmployeeDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? fullName = null,
    Object? email = null,
    Object? displayName = null,
  }) {
    return _then(_$StoreEmployeeDtoImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StoreEmployeeDtoImpl implements _StoreEmployeeDto {
  const _$StoreEmployeeDtoImpl(
      {@JsonKey(name: 'user_id') this.userId = '',
      @JsonKey(name: 'full_name') this.fullName = '',
      @JsonKey(name: 'email') this.email = '',
      @JsonKey(name: 'display_name') this.displayName = ''});

  factory _$StoreEmployeeDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$StoreEmployeeDtoImplFromJson(json);

  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'full_name')
  final String fullName;
  @override
  @JsonKey(name: 'email')
  final String email;
  @override
  @JsonKey(name: 'display_name')
  final String displayName;

  @override
  String toString() {
    return 'StoreEmployeeDto(userId: $userId, fullName: $fullName, email: $email, displayName: $displayName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoreEmployeeDtoImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, userId, fullName, email, displayName);

  /// Create a copy of StoreEmployeeDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StoreEmployeeDtoImplCopyWith<_$StoreEmployeeDtoImpl> get copyWith =>
      __$$StoreEmployeeDtoImplCopyWithImpl<_$StoreEmployeeDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StoreEmployeeDtoImplToJson(
      this,
    );
  }
}

abstract class _StoreEmployeeDto implements StoreEmployeeDto {
  const factory _StoreEmployeeDto(
          {@JsonKey(name: 'user_id') final String userId,
          @JsonKey(name: 'full_name') final String fullName,
          @JsonKey(name: 'email') final String email,
          @JsonKey(name: 'display_name') final String displayName}) =
      _$StoreEmployeeDtoImpl;

  factory _StoreEmployeeDto.fromJson(Map<String, dynamic> json) =
      _$StoreEmployeeDtoImpl.fromJson;

  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'full_name')
  String get fullName;
  @override
  @JsonKey(name: 'email')
  String get email;
  @override
  @JsonKey(name: 'display_name')
  String get displayName;

  /// Create a copy of StoreEmployeeDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoreEmployeeDtoImplCopyWith<_$StoreEmployeeDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
