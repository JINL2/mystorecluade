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

/// @nodoc
mixin _$Store {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get companyId => throw _privateConstructorUsedError;
  String? get storeCode =>
      throw _privateConstructorUsedError; // Unique code within company
  String? get phone => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get timezone =>
      throw _privateConstructorUsedError; // e.g., "Asia/Seoul", "America/New_York"
  String? get description => throw _privateConstructorUsedError;
  bool get isActive =>
      throw _privateConstructorUsedError; // Operational settings
  int? get huddleTimeMinutes =>
      throw _privateConstructorUsedError; // Meeting duration in minutes
  int? get paymentTimeDays =>
      throw _privateConstructorUsedError; // Payment terms in days
  double? get allowedDistanceMeters =>
      throw _privateConstructorUsedError; // Allowed distance for attendance
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

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
      {String id,
      String name,
      String companyId,
      String? storeCode,
      String? phone,
      String? address,
      String? timezone,
      String? description,
      bool isActive,
      int? huddleTimeMinutes,
      int? paymentTimeDays,
      double? allowedDistanceMeters,
      DateTime createdAt,
      DateTime? updatedAt});
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
      {String id,
      String name,
      String companyId,
      String? storeCode,
      String? phone,
      String? address,
      String? timezone,
      String? description,
      bool isActive,
      int? huddleTimeMinutes,
      int? paymentTimeDays,
      double? allowedDistanceMeters,
      DateTime createdAt,
      DateTime? updatedAt});
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
    ));
  }
}

/// @nodoc

class _$StoreImpl extends _Store {
  const _$StoreImpl(
      {required this.id,
      required this.name,
      required this.companyId,
      this.storeCode,
      this.phone,
      this.address,
      this.timezone,
      this.description,
      this.isActive = true,
      this.huddleTimeMinutes,
      this.paymentTimeDays,
      this.allowedDistanceMeters,
      required this.createdAt,
      this.updatedAt})
      : super._();

  @override
  final String id;
  @override
  final String name;
  @override
  final String companyId;
  @override
  final String? storeCode;
// Unique code within company
  @override
  final String? phone;
  @override
  final String? address;
  @override
  final String? timezone;
// e.g., "Asia/Seoul", "America/New_York"
  @override
  final String? description;
  @override
  @JsonKey()
  final bool isActive;
// Operational settings
  @override
  final int? huddleTimeMinutes;
// Meeting duration in minutes
  @override
  final int? paymentTimeDays;
// Payment terms in days
  @override
  final double? allowedDistanceMeters;
// Allowed distance for attendance
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Store(id: $id, name: $name, companyId: $companyId, storeCode: $storeCode, phone: $phone, address: $address, timezone: $timezone, description: $description, isActive: $isActive, huddleTimeMinutes: $huddleTimeMinutes, paymentTimeDays: $paymentTimeDays, allowedDistanceMeters: $allowedDistanceMeters, createdAt: $createdAt, updatedAt: $updatedAt)';
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
                other.updatedAt == updatedAt));
  }

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
      updatedAt);

  /// Create a copy of Store
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StoreImplCopyWith<_$StoreImpl> get copyWith =>
      __$$StoreImplCopyWithImpl<_$StoreImpl>(this, _$identity);
}

abstract class _Store extends Store {
  const factory _Store(
      {required final String id,
      required final String name,
      required final String companyId,
      final String? storeCode,
      final String? phone,
      final String? address,
      final String? timezone,
      final String? description,
      final bool isActive,
      final int? huddleTimeMinutes,
      final int? paymentTimeDays,
      final double? allowedDistanceMeters,
      required final DateTime createdAt,
      final DateTime? updatedAt}) = _$StoreImpl;
  const _Store._() : super._();

  @override
  String get id;
  @override
  String get name;
  @override
  String get companyId;
  @override
  String? get storeCode; // Unique code within company
  @override
  String? get phone;
  @override
  String? get address;
  @override
  String? get timezone; // e.g., "Asia/Seoul", "America/New_York"
  @override
  String? get description;
  @override
  bool get isActive; // Operational settings
  @override
  int? get huddleTimeMinutes; // Meeting duration in minutes
  @override
  int? get paymentTimeDays; // Payment terms in days
  @override
  double? get allowedDistanceMeters; // Allowed distance for attendance
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of Store
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoreImplCopyWith<_$StoreImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
