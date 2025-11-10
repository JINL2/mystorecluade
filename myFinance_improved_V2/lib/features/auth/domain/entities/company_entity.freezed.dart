// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'company_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Company _$CompanyFromJson(Map<String, dynamic> json) {
  return _Company.fromJson(json);
}

/// @nodoc
mixin _$Company {
  @JsonKey(name: 'company_id')
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_name')
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_business_number')
  String? get businessNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_email')
  String? get email => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_phone')
  String? get phone => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_address')
  String? get address => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_type_id')
  String get companyTypeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'base_currency_id')
  String get currencyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_code')
  String? get companyCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'owner_id')
  String get ownerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'timezone')
  String? get timezone => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_deleted')
  bool get isDeleted => throw _privateConstructorUsedError;

  /// Serializes this Company to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Company
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CompanyCopyWith<Company> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompanyCopyWith<$Res> {
  factory $CompanyCopyWith(Company value, $Res Function(Company) then) =
      _$CompanyCopyWithImpl<$Res, Company>;
  @useResult
  $Res call(
      {@JsonKey(name: 'company_id') String id,
      @JsonKey(name: 'company_name') String name,
      @JsonKey(name: 'company_business_number') String? businessNumber,
      @JsonKey(name: 'company_email') String? email,
      @JsonKey(name: 'company_phone') String? phone,
      @JsonKey(name: 'company_address') String? address,
      @JsonKey(name: 'company_type_id') String companyTypeId,
      @JsonKey(name: 'base_currency_id') String currencyId,
      @JsonKey(name: 'company_code') String? companyCode,
      @JsonKey(name: 'owner_id') String ownerId,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'timezone') String? timezone,
      @JsonKey(name: 'is_deleted') bool isDeleted});
}

/// @nodoc
class _$CompanyCopyWithImpl<$Res, $Val extends Company>
    implements $CompanyCopyWith<$Res> {
  _$CompanyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Company
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? businessNumber = freezed,
    Object? email = freezed,
    Object? phone = freezed,
    Object? address = freezed,
    Object? companyTypeId = null,
    Object? currencyId = null,
    Object? companyCode = freezed,
    Object? ownerId = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? timezone = freezed,
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
      businessNumber: freezed == businessNumber
          ? _value.businessNumber
          : businessNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      companyTypeId: null == companyTypeId
          ? _value.companyTypeId
          : companyTypeId // ignore: cast_nullable_to_non_nullable
              as String,
      currencyId: null == currencyId
          ? _value.currencyId
          : currencyId // ignore: cast_nullable_to_non_nullable
              as String,
      companyCode: freezed == companyCode
          ? _value.companyCode
          : companyCode // ignore: cast_nullable_to_non_nullable
              as String?,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      timezone: freezed == timezone
          ? _value.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as String?,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CompanyImplCopyWith<$Res> implements $CompanyCopyWith<$Res> {
  factory _$$CompanyImplCopyWith(
          _$CompanyImpl value, $Res Function(_$CompanyImpl) then) =
      __$$CompanyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'company_id') String id,
      @JsonKey(name: 'company_name') String name,
      @JsonKey(name: 'company_business_number') String? businessNumber,
      @JsonKey(name: 'company_email') String? email,
      @JsonKey(name: 'company_phone') String? phone,
      @JsonKey(name: 'company_address') String? address,
      @JsonKey(name: 'company_type_id') String companyTypeId,
      @JsonKey(name: 'base_currency_id') String currencyId,
      @JsonKey(name: 'company_code') String? companyCode,
      @JsonKey(name: 'owner_id') String ownerId,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'timezone') String? timezone,
      @JsonKey(name: 'is_deleted') bool isDeleted});
}

/// @nodoc
class __$$CompanyImplCopyWithImpl<$Res>
    extends _$CompanyCopyWithImpl<$Res, _$CompanyImpl>
    implements _$$CompanyImplCopyWith<$Res> {
  __$$CompanyImplCopyWithImpl(
      _$CompanyImpl _value, $Res Function(_$CompanyImpl) _then)
      : super(_value, _then);

  /// Create a copy of Company
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? businessNumber = freezed,
    Object? email = freezed,
    Object? phone = freezed,
    Object? address = freezed,
    Object? companyTypeId = null,
    Object? currencyId = null,
    Object? companyCode = freezed,
    Object? ownerId = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? timezone = freezed,
    Object? isDeleted = null,
  }) {
    return _then(_$CompanyImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      businessNumber: freezed == businessNumber
          ? _value.businessNumber
          : businessNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      companyTypeId: null == companyTypeId
          ? _value.companyTypeId
          : companyTypeId // ignore: cast_nullable_to_non_nullable
              as String,
      currencyId: null == currencyId
          ? _value.currencyId
          : currencyId // ignore: cast_nullable_to_non_nullable
              as String,
      companyCode: freezed == companyCode
          ? _value.companyCode
          : companyCode // ignore: cast_nullable_to_non_nullable
              as String?,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      timezone: freezed == timezone
          ? _value.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
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
class _$CompanyImpl extends _Company {
  const _$CompanyImpl(
      {@JsonKey(name: 'company_id') required this.id,
      @JsonKey(name: 'company_name') required this.name,
      @JsonKey(name: 'company_business_number') this.businessNumber,
      @JsonKey(name: 'company_email') this.email,
      @JsonKey(name: 'company_phone') this.phone,
      @JsonKey(name: 'company_address') this.address,
      @JsonKey(name: 'company_type_id') required this.companyTypeId,
      @JsonKey(name: 'base_currency_id') required this.currencyId,
      @JsonKey(name: 'company_code') this.companyCode,
      @JsonKey(name: 'owner_id') required this.ownerId,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      @JsonKey(name: 'timezone') this.timezone,
      @JsonKey(name: 'is_deleted') this.isDeleted = false})
      : super._();

  factory _$CompanyImpl.fromJson(Map<String, dynamic> json) =>
      _$$CompanyImplFromJson(json);

  @override
  @JsonKey(name: 'company_id')
  final String id;
  @override
  @JsonKey(name: 'company_name')
  final String name;
  @override
  @JsonKey(name: 'company_business_number')
  final String? businessNumber;
  @override
  @JsonKey(name: 'company_email')
  final String? email;
  @override
  @JsonKey(name: 'company_phone')
  final String? phone;
  @override
  @JsonKey(name: 'company_address')
  final String? address;
  @override
  @JsonKey(name: 'company_type_id')
  final String companyTypeId;
  @override
  @JsonKey(name: 'base_currency_id')
  final String currencyId;
  @override
  @JsonKey(name: 'company_code')
  final String? companyCode;
  @override
  @JsonKey(name: 'owner_id')
  final String ownerId;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  @override
  @JsonKey(name: 'timezone')
  final String? timezone;
  @override
  @JsonKey(name: 'is_deleted')
  final bool isDeleted;

  @override
  String toString() {
    return 'Company(id: $id, name: $name, businessNumber: $businessNumber, email: $email, phone: $phone, address: $address, companyTypeId: $companyTypeId, currencyId: $currencyId, companyCode: $companyCode, ownerId: $ownerId, createdAt: $createdAt, updatedAt: $updatedAt, timezone: $timezone, isDeleted: $isDeleted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompanyImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.businessNumber, businessNumber) ||
                other.businessNumber == businessNumber) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.companyTypeId, companyTypeId) ||
                other.companyTypeId == companyTypeId) &&
            (identical(other.currencyId, currencyId) ||
                other.currencyId == currencyId) &&
            (identical(other.companyCode, companyCode) ||
                other.companyCode == companyCode) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.timezone, timezone) ||
                other.timezone == timezone) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      businessNumber,
      email,
      phone,
      address,
      companyTypeId,
      currencyId,
      companyCode,
      ownerId,
      createdAt,
      updatedAt,
      timezone,
      isDeleted);

  /// Create a copy of Company
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CompanyImplCopyWith<_$CompanyImpl> get copyWith =>
      __$$CompanyImplCopyWithImpl<_$CompanyImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CompanyImplToJson(
      this,
    );
  }
}

abstract class _Company extends Company {
  const factory _Company(
      {@JsonKey(name: 'company_id') required final String id,
      @JsonKey(name: 'company_name') required final String name,
      @JsonKey(name: 'company_business_number') final String? businessNumber,
      @JsonKey(name: 'company_email') final String? email,
      @JsonKey(name: 'company_phone') final String? phone,
      @JsonKey(name: 'company_address') final String? address,
      @JsonKey(name: 'company_type_id') required final String companyTypeId,
      @JsonKey(name: 'base_currency_id') required final String currencyId,
      @JsonKey(name: 'company_code') final String? companyCode,
      @JsonKey(name: 'owner_id') required final String ownerId,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      @JsonKey(name: 'updated_at') final DateTime? updatedAt,
      @JsonKey(name: 'timezone') final String? timezone,
      @JsonKey(name: 'is_deleted') final bool isDeleted}) = _$CompanyImpl;
  const _Company._() : super._();

  factory _Company.fromJson(Map<String, dynamic> json) = _$CompanyImpl.fromJson;

  @override
  @JsonKey(name: 'company_id')
  String get id;
  @override
  @JsonKey(name: 'company_name')
  String get name;
  @override
  @JsonKey(name: 'company_business_number')
  String? get businessNumber;
  @override
  @JsonKey(name: 'company_email')
  String? get email;
  @override
  @JsonKey(name: 'company_phone')
  String? get phone;
  @override
  @JsonKey(name: 'company_address')
  String? get address;
  @override
  @JsonKey(name: 'company_type_id')
  String get companyTypeId;
  @override
  @JsonKey(name: 'base_currency_id')
  String get currencyId;
  @override
  @JsonKey(name: 'company_code')
  String? get companyCode;
  @override
  @JsonKey(name: 'owner_id')
  String get ownerId;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(name: 'timezone')
  String? get timezone;
  @override
  @JsonKey(name: 'is_deleted')
  bool get isDeleted;

  /// Create a copy of Company
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CompanyImplCopyWith<_$CompanyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
