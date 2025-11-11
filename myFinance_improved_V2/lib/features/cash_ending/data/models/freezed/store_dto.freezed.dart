// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'store_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StoreDto _$StoreDtoFromJson(Map<String, dynamic> json) {
  return _StoreDto.fromJson(json);
}

/// @nodoc
mixin _$StoreDto {
  @JsonKey(name: 'store_id')
  String get storeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'store_name')
  String get storeName => throw _privateConstructorUsedError;
  @JsonKey(name: 'store_code')
  String? get storeCode => throw _privateConstructorUsedError;

  /// Serializes this StoreDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StoreDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StoreDtoCopyWith<StoreDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoreDtoCopyWith<$Res> {
  factory $StoreDtoCopyWith(StoreDto value, $Res Function(StoreDto) then) =
      _$StoreDtoCopyWithImpl<$Res, StoreDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'store_id') String storeId,
      @JsonKey(name: 'store_name') String storeName,
      @JsonKey(name: 'store_code') String? storeCode});
}

/// @nodoc
class _$StoreDtoCopyWithImpl<$Res, $Val extends StoreDto>
    implements $StoreDtoCopyWith<$Res> {
  _$StoreDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StoreDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? storeId = null,
    Object? storeName = null,
    Object? storeCode = freezed,
  }) {
    return _then(_value.copyWith(
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      storeName: null == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String,
      storeCode: freezed == storeCode
          ? _value.storeCode
          : storeCode // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StoreDtoImplCopyWith<$Res>
    implements $StoreDtoCopyWith<$Res> {
  factory _$$StoreDtoImplCopyWith(
          _$StoreDtoImpl value, $Res Function(_$StoreDtoImpl) then) =
      __$$StoreDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'store_id') String storeId,
      @JsonKey(name: 'store_name') String storeName,
      @JsonKey(name: 'store_code') String? storeCode});
}

/// @nodoc
class __$$StoreDtoImplCopyWithImpl<$Res>
    extends _$StoreDtoCopyWithImpl<$Res, _$StoreDtoImpl>
    implements _$$StoreDtoImplCopyWith<$Res> {
  __$$StoreDtoImplCopyWithImpl(
      _$StoreDtoImpl _value, $Res Function(_$StoreDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of StoreDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? storeId = null,
    Object? storeName = null,
    Object? storeCode = freezed,
  }) {
    return _then(_$StoreDtoImpl(
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      storeName: null == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String,
      storeCode: freezed == storeCode
          ? _value.storeCode
          : storeCode // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StoreDtoImpl extends _StoreDto {
  const _$StoreDtoImpl(
      {@JsonKey(name: 'store_id') required this.storeId,
      @JsonKey(name: 'store_name') required this.storeName,
      @JsonKey(name: 'store_code') this.storeCode})
      : super._();

  factory _$StoreDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$StoreDtoImplFromJson(json);

  @override
  @JsonKey(name: 'store_id')
  final String storeId;
  @override
  @JsonKey(name: 'store_name')
  final String storeName;
  @override
  @JsonKey(name: 'store_code')
  final String? storeCode;

  @override
  String toString() {
    return 'StoreDto(storeId: $storeId, storeName: $storeName, storeCode: $storeCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoreDtoImpl &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.storeName, storeName) ||
                other.storeName == storeName) &&
            (identical(other.storeCode, storeCode) ||
                other.storeCode == storeCode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, storeId, storeName, storeCode);

  /// Create a copy of StoreDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StoreDtoImplCopyWith<_$StoreDtoImpl> get copyWith =>
      __$$StoreDtoImplCopyWithImpl<_$StoreDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StoreDtoImplToJson(
      this,
    );
  }
}

abstract class _StoreDto extends StoreDto {
  const factory _StoreDto(
      {@JsonKey(name: 'store_id') required final String storeId,
      @JsonKey(name: 'store_name') required final String storeName,
      @JsonKey(name: 'store_code') final String? storeCode}) = _$StoreDtoImpl;
  const _StoreDto._() : super._();

  factory _StoreDto.fromJson(Map<String, dynamic> json) =
      _$StoreDtoImpl.fromJson;

  @override
  @JsonKey(name: 'store_id')
  String get storeId;
  @override
  @JsonKey(name: 'store_name')
  String get storeName;
  @override
  @JsonKey(name: 'store_code')
  String? get storeCode;

  /// Create a copy of StoreDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoreDtoImplCopyWith<_$StoreDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
