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
  @JsonKey(name: 'company_id')
  String get companyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'store_code')
  String? get storeCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'store_address')
  String? get storeAddress => throw _privateConstructorUsedError;
  @JsonKey(name: 'store_phone')
  String? get storePhone => throw _privateConstructorUsedError;
  @JsonKey(name: 'huddle_time')
  int? get huddleTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_time')
  int? get paymentTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'allowed_distance')
  int? get allowedDistance => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  String? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_deleted')
  bool get isDeleted => throw _privateConstructorUsedError;

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
      @JsonKey(name: 'company_id') String companyId,
      @JsonKey(name: 'store_code') String? storeCode,
      @JsonKey(name: 'store_address') String? storeAddress,
      @JsonKey(name: 'store_phone') String? storePhone,
      @JsonKey(name: 'huddle_time') int? huddleTime,
      @JsonKey(name: 'payment_time') int? paymentTime,
      @JsonKey(name: 'allowed_distance') int? allowedDistance,
      @JsonKey(name: 'created_at') String createdAt,
      @JsonKey(name: 'updated_at') String? updatedAt,
      @JsonKey(name: 'is_deleted') bool isDeleted});
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
    Object? companyId = null,
    Object? storeCode = freezed,
    Object? storeAddress = freezed,
    Object? storePhone = freezed,
    Object? huddleTime = freezed,
    Object? paymentTime = freezed,
    Object? allowedDistance = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? isDeleted = null,
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
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      storeCode: freezed == storeCode
          ? _value.storeCode
          : storeCode // ignore: cast_nullable_to_non_nullable
              as String?,
      storeAddress: freezed == storeAddress
          ? _value.storeAddress
          : storeAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      storePhone: freezed == storePhone
          ? _value.storePhone
          : storePhone // ignore: cast_nullable_to_non_nullable
              as String?,
      huddleTime: freezed == huddleTime
          ? _value.huddleTime
          : huddleTime // ignore: cast_nullable_to_non_nullable
              as int?,
      paymentTime: freezed == paymentTime
          ? _value.paymentTime
          : paymentTime // ignore: cast_nullable_to_non_nullable
              as int?,
      allowedDistance: freezed == allowedDistance
          ? _value.allowedDistance
          : allowedDistance // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
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
      @JsonKey(name: 'company_id') String companyId,
      @JsonKey(name: 'store_code') String? storeCode,
      @JsonKey(name: 'store_address') String? storeAddress,
      @JsonKey(name: 'store_phone') String? storePhone,
      @JsonKey(name: 'huddle_time') int? huddleTime,
      @JsonKey(name: 'payment_time') int? paymentTime,
      @JsonKey(name: 'allowed_distance') int? allowedDistance,
      @JsonKey(name: 'created_at') String createdAt,
      @JsonKey(name: 'updated_at') String? updatedAt,
      @JsonKey(name: 'is_deleted') bool isDeleted});
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
    Object? companyId = null,
    Object? storeCode = freezed,
    Object? storeAddress = freezed,
    Object? storePhone = freezed,
    Object? huddleTime = freezed,
    Object? paymentTime = freezed,
    Object? allowedDistance = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? isDeleted = null,
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
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      storeCode: freezed == storeCode
          ? _value.storeCode
          : storeCode // ignore: cast_nullable_to_non_nullable
              as String?,
      storeAddress: freezed == storeAddress
          ? _value.storeAddress
          : storeAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      storePhone: freezed == storePhone
          ? _value.storePhone
          : storePhone // ignore: cast_nullable_to_non_nullable
              as String?,
      huddleTime: freezed == huddleTime
          ? _value.huddleTime
          : huddleTime // ignore: cast_nullable_to_non_nullable
              as int?,
      paymentTime: freezed == paymentTime
          ? _value.paymentTime
          : paymentTime // ignore: cast_nullable_to_non_nullable
              as int?,
      allowedDistance: freezed == allowedDistance
          ? _value.allowedDistance
          : allowedDistance // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StoreDtoImpl implements _StoreDto {
  const _$StoreDtoImpl(
      {@JsonKey(name: 'store_id') required this.storeId,
      @JsonKey(name: 'store_name') required this.storeName,
      @JsonKey(name: 'company_id') required this.companyId,
      @JsonKey(name: 'store_code') this.storeCode,
      @JsonKey(name: 'store_address') this.storeAddress,
      @JsonKey(name: 'store_phone') this.storePhone,
      @JsonKey(name: 'huddle_time') this.huddleTime,
      @JsonKey(name: 'payment_time') this.paymentTime,
      @JsonKey(name: 'allowed_distance') this.allowedDistance,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      @JsonKey(name: 'is_deleted') this.isDeleted = false});

  factory _$StoreDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$StoreDtoImplFromJson(json);

  @override
  @JsonKey(name: 'store_id')
  final String storeId;
  @override
  @JsonKey(name: 'store_name')
  final String storeName;
  @override
  @JsonKey(name: 'company_id')
  final String companyId;
  @override
  @JsonKey(name: 'store_code')
  final String? storeCode;
  @override
  @JsonKey(name: 'store_address')
  final String? storeAddress;
  @override
  @JsonKey(name: 'store_phone')
  final String? storePhone;
  @override
  @JsonKey(name: 'huddle_time')
  final int? huddleTime;
  @override
  @JsonKey(name: 'payment_time')
  final int? paymentTime;
  @override
  @JsonKey(name: 'allowed_distance')
  final int? allowedDistance;
  @override
  @JsonKey(name: 'created_at')
  final String createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  @override
  @JsonKey(name: 'is_deleted')
  final bool isDeleted;

  @override
  String toString() {
    return 'StoreDto(storeId: $storeId, storeName: $storeName, companyId: $companyId, storeCode: $storeCode, storeAddress: $storeAddress, storePhone: $storePhone, huddleTime: $huddleTime, paymentTime: $paymentTime, allowedDistance: $allowedDistance, createdAt: $createdAt, updatedAt: $updatedAt, isDeleted: $isDeleted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoreDtoImpl &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.storeName, storeName) ||
                other.storeName == storeName) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.storeCode, storeCode) ||
                other.storeCode == storeCode) &&
            (identical(other.storeAddress, storeAddress) ||
                other.storeAddress == storeAddress) &&
            (identical(other.storePhone, storePhone) ||
                other.storePhone == storePhone) &&
            (identical(other.huddleTime, huddleTime) ||
                other.huddleTime == huddleTime) &&
            (identical(other.paymentTime, paymentTime) ||
                other.paymentTime == paymentTime) &&
            (identical(other.allowedDistance, allowedDistance) ||
                other.allowedDistance == allowedDistance) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      storeId,
      storeName,
      companyId,
      storeCode,
      storeAddress,
      storePhone,
      huddleTime,
      paymentTime,
      allowedDistance,
      createdAt,
      updatedAt,
      isDeleted);

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

abstract class _StoreDto implements StoreDto {
  const factory _StoreDto(
      {@JsonKey(name: 'store_id') required final String storeId,
      @JsonKey(name: 'store_name') required final String storeName,
      @JsonKey(name: 'company_id') required final String companyId,
      @JsonKey(name: 'store_code') final String? storeCode,
      @JsonKey(name: 'store_address') final String? storeAddress,
      @JsonKey(name: 'store_phone') final String? storePhone,
      @JsonKey(name: 'huddle_time') final int? huddleTime,
      @JsonKey(name: 'payment_time') final int? paymentTime,
      @JsonKey(name: 'allowed_distance') final int? allowedDistance,
      @JsonKey(name: 'created_at') required final String createdAt,
      @JsonKey(name: 'updated_at') final String? updatedAt,
      @JsonKey(name: 'is_deleted') final bool isDeleted}) = _$StoreDtoImpl;

  factory _StoreDto.fromJson(Map<String, dynamic> json) =
      _$StoreDtoImpl.fromJson;

  @override
  @JsonKey(name: 'store_id')
  String get storeId;
  @override
  @JsonKey(name: 'store_name')
  String get storeName;
  @override
  @JsonKey(name: 'company_id')
  String get companyId;
  @override
  @JsonKey(name: 'store_code')
  String? get storeCode;
  @override
  @JsonKey(name: 'store_address')
  String? get storeAddress;
  @override
  @JsonKey(name: 'store_phone')
  String? get storePhone;
  @override
  @JsonKey(name: 'huddle_time')
  int? get huddleTime;
  @override
  @JsonKey(name: 'payment_time')
  int? get paymentTime;
  @override
  @JsonKey(name: 'allowed_distance')
  int? get allowedDistance;
  @override
  @JsonKey(name: 'created_at')
  String get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  String? get updatedAt;
  @override
  @JsonKey(name: 'is_deleted')
  bool get isDeleted;

  /// Create a copy of StoreDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoreDtoImplCopyWith<_$StoreDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
