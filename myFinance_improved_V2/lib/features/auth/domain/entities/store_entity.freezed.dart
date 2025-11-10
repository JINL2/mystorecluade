// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'store_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Store _$StoreFromJson(Map<String, dynamic> json) {
  return _Store.fromJson(json);
}

/// @nodoc
mixin _$Store {
  @JsonKey(name: 'store_id')
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'store_name')
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_id')
  String get companyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'store_code')
  String? get storeCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'store_phone')
  String? get phone => throw _privateConstructorUsedError;
  @JsonKey(name: 'store_address')
  String? get address => throw _privateConstructorUsedError;
  String? get timezone => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive =>
      throw _privateConstructorUsedError; // Operational settings
  @JsonKey(name: 'huddle_time')
  int? get huddleTimeMinutes => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_time')
  int? get paymentTimeDays => throw _privateConstructorUsedError;
  @JsonKey(name: 'allowed_distance')
  double? get allowedDistanceMeters => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_deleted')
  bool get isDeleted => throw _privateConstructorUsedError;

  /// Serializes this Store to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Store
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StoreCopyWith<Store> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoreCopyWith<$Res> {
  factory $StoreCopyWith(Store value, $Res Function(Store) then) =
      _$StoreCopyWithImpl<$Res, Store>;
  @useResult
  $Res call(
      {@JsonKey(name: 'store_id') String id,
      @JsonKey(name: 'store_name') String name,
      @JsonKey(name: 'company_id') String companyId,
      @JsonKey(name: 'store_code') String? storeCode,
      @JsonKey(name: 'store_phone') String? phone,
      @JsonKey(name: 'store_address') String? address,
      String? timezone,
      String? description,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'huddle_time') int? huddleTimeMinutes,
      @JsonKey(name: 'payment_time') int? paymentTimeDays,
      @JsonKey(name: 'allowed_distance') double? allowedDistanceMeters,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'is_deleted') bool isDeleted});
}

/// @nodoc
class _$StoreCopyWithImpl<$Res, $Val extends Store>
    implements $StoreCopyWith<$Res> {
  _$StoreCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Store
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? companyId = null,
    Object? storeCode = freezed,
    Object? phone = freezed,
    Object? address = freezed,
    Object? timezone = freezed,
    Object? description = freezed,
    Object? isActive = null,
    Object? huddleTimeMinutes = freezed,
    Object? paymentTimeDays = freezed,
    Object? allowedDistanceMeters = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? isDeleted = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      storeCode: freezed == storeCode
          ? _value.storeCode
          : storeCode // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      timezone: freezed == timezone
          ? _value.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      huddleTimeMinutes: freezed == huddleTimeMinutes
          ? _value.huddleTimeMinutes
          : huddleTimeMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      paymentTimeDays: freezed == paymentTimeDays
          ? _value.paymentTimeDays
          : paymentTimeDays // ignore: cast_nullable_to_non_nullable
              as int?,
      allowedDistanceMeters: freezed == allowedDistanceMeters
          ? _value.allowedDistanceMeters
          : allowedDistanceMeters // ignore: cast_nullable_to_non_nullable
              as double?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StoreImplCopyWith<$Res> implements $StoreCopyWith<$Res> {
  factory _$$StoreImplCopyWith(
          _$StoreImpl value, $Res Function(_$StoreImpl) then) =
      __$$StoreImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'store_id') String id,
      @JsonKey(name: 'store_name') String name,
      @JsonKey(name: 'company_id') String companyId,
      @JsonKey(name: 'store_code') String? storeCode,
      @JsonKey(name: 'store_phone') String? phone,
      @JsonKey(name: 'store_address') String? address,
      String? timezone,
      String? description,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'huddle_time') int? huddleTimeMinutes,
      @JsonKey(name: 'payment_time') int? paymentTimeDays,
      @JsonKey(name: 'allowed_distance') double? allowedDistanceMeters,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'is_deleted') bool isDeleted});
}

/// @nodoc
class __$$StoreImplCopyWithImpl<$Res>
    extends _$StoreCopyWithImpl<$Res, _$StoreImpl>
    implements _$$StoreImplCopyWith<$Res> {
  __$$StoreImplCopyWithImpl(
      _$StoreImpl _value, $Res Function(_$StoreImpl) _then)
      : super(_value, _then);

  /// Create a copy of Store
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? companyId = null,
    Object? storeCode = freezed,
    Object? phone = freezed,
    Object? address = freezed,
    Object? timezone = freezed,
    Object? description = freezed,
    Object? isActive = null,
    Object? huddleTimeMinutes = freezed,
    Object? paymentTimeDays = freezed,
    Object? allowedDistanceMeters = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? isDeleted = null,
  }) {
    return _then(_$StoreImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      storeCode: freezed == storeCode
          ? _value.storeCode
          : storeCode // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      timezone: freezed == timezone
          ? _value.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      huddleTimeMinutes: freezed == huddleTimeMinutes
          ? _value.huddleTimeMinutes
          : huddleTimeMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      paymentTimeDays: freezed == paymentTimeDays
          ? _value.paymentTimeDays
          : paymentTimeDays // ignore: cast_nullable_to_non_nullable
              as int?,
      allowedDistanceMeters: freezed == allowedDistanceMeters
          ? _value.allowedDistanceMeters
          : allowedDistanceMeters // ignore: cast_nullable_to_non_nullable
              as double?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StoreImpl extends _Store {
  const _$StoreImpl(
      {@JsonKey(name: 'store_id') required this.id,
      @JsonKey(name: 'store_name') required this.name,
      @JsonKey(name: 'company_id') required this.companyId,
      @JsonKey(name: 'store_code') this.storeCode,
      @JsonKey(name: 'store_phone') this.phone,
      @JsonKey(name: 'store_address') this.address,
      this.timezone,
      this.description,
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'huddle_time') this.huddleTimeMinutes,
      @JsonKey(name: 'payment_time') this.paymentTimeDays,
      @JsonKey(name: 'allowed_distance') this.allowedDistanceMeters,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      @JsonKey(name: 'is_deleted') this.isDeleted = false})
      : super._();

  factory _$StoreImpl.fromJson(Map<String, dynamic> json) =>
      _$$StoreImplFromJson(json);

  @override
  @JsonKey(name: 'store_id')
  final String id;
  @override
  @JsonKey(name: 'store_name')
  final String name;
  @override
  @JsonKey(name: 'company_id')
  final String companyId;
  @override
  @JsonKey(name: 'store_code')
  final String? storeCode;
  @override
  @JsonKey(name: 'store_phone')
  final String? phone;
  @override
  @JsonKey(name: 'store_address')
  final String? address;
  @override
  final String? timezone;
  @override
  final String? description;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
// Operational settings
  @override
  @JsonKey(name: 'huddle_time')
  final int? huddleTimeMinutes;
  @override
  @JsonKey(name: 'payment_time')
  final int? paymentTimeDays;
  @override
  @JsonKey(name: 'allowed_distance')
  final double? allowedDistanceMeters;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  @override
  @JsonKey(name: 'is_deleted')
  final bool isDeleted;

  @override
  String toString() {
    return 'Store(id: $id, name: $name, companyId: $companyId, storeCode: $storeCode, phone: $phone, address: $address, timezone: $timezone, description: $description, isActive: $isActive, huddleTimeMinutes: $huddleTimeMinutes, paymentTimeDays: $paymentTimeDays, allowedDistanceMeters: $allowedDistanceMeters, createdAt: $createdAt, updatedAt: $updatedAt, isDeleted: $isDeleted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoreImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.storeCode, storeCode) ||
                other.storeCode == storeCode) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.timezone, timezone) ||
                other.timezone == timezone) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.huddleTimeMinutes, huddleTimeMinutes) ||
                other.huddleTimeMinutes == huddleTimeMinutes) &&
            (identical(other.paymentTimeDays, paymentTimeDays) ||
                other.paymentTimeDays == paymentTimeDays) &&
            (identical(other.allowedDistanceMeters, allowedDistanceMeters) ||
                other.allowedDistanceMeters == allowedDistanceMeters) &&
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
      id,
      name,
      companyId,
      storeCode,
      phone,
      address,
      timezone,
      description,
      isActive,
      huddleTimeMinutes,
      paymentTimeDays,
      allowedDistanceMeters,
      createdAt,
      updatedAt,
      isDeleted);

  /// Create a copy of Store
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StoreImplCopyWith<_$StoreImpl> get copyWith =>
      __$$StoreImplCopyWithImpl<_$StoreImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StoreImplToJson(
      this,
    );
  }
}

abstract class _Store extends Store {
  const factory _Store(
      {@JsonKey(name: 'store_id') required final String id,
      @JsonKey(name: 'store_name') required final String name,
      @JsonKey(name: 'company_id') required final String companyId,
      @JsonKey(name: 'store_code') final String? storeCode,
      @JsonKey(name: 'store_phone') final String? phone,
      @JsonKey(name: 'store_address') final String? address,
      final String? timezone,
      final String? description,
      @JsonKey(name: 'is_active') final bool isActive,
      @JsonKey(name: 'huddle_time') final int? huddleTimeMinutes,
      @JsonKey(name: 'payment_time') final int? paymentTimeDays,
      @JsonKey(name: 'allowed_distance') final double? allowedDistanceMeters,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      @JsonKey(name: 'updated_at') final DateTime? updatedAt,
      @JsonKey(name: 'is_deleted') final bool isDeleted}) = _$StoreImpl;
  const _Store._() : super._();

  factory _Store.fromJson(Map<String, dynamic> json) = _$StoreImpl.fromJson;

  @override
  @JsonKey(name: 'store_id')
  String get id;
  @override
  @JsonKey(name: 'store_name')
  String get name;
  @override
  @JsonKey(name: 'company_id')
  String get companyId;
  @override
  @JsonKey(name: 'store_code')
  String? get storeCode;
  @override
  @JsonKey(name: 'store_phone')
  String? get phone;
  @override
  @JsonKey(name: 'store_address')
  String? get address;
  @override
  String? get timezone;
  @override
  String? get description;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive; // Operational settings
  @override
  @JsonKey(name: 'huddle_time')
  int? get huddleTimeMinutes;
  @override
  @JsonKey(name: 'payment_time')
  int? get paymentTimeDays;
  @override
  @JsonKey(name: 'allowed_distance')
  double? get allowedDistanceMeters;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(name: 'is_deleted')
  bool get isDeleted;

  /// Create a copy of Store
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoreImplCopyWith<_$StoreImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
