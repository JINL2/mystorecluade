// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vault_recount_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

VaultRecountDto _$VaultRecountDtoFromJson(Map<String, dynamic> json) {
  return _VaultRecountDto.fromJson(json);
}

/// @nodoc
mixin _$VaultRecountDto {
  @JsonKey(name: 'company_id')
  String get companyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'store_id')
  String? get storeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'location_id')
  String get locationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'currency_id')
  String get currencyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_by')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'record_date')
  DateTime get recordDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  List<DenominationDto> get denominations => throw _privateConstructorUsedError;

  /// Serializes this VaultRecountDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VaultRecountDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VaultRecountDtoCopyWith<VaultRecountDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VaultRecountDtoCopyWith<$Res> {
  factory $VaultRecountDtoCopyWith(
          VaultRecountDto value, $Res Function(VaultRecountDto) then) =
      _$VaultRecountDtoCopyWithImpl<$Res, VaultRecountDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'company_id') String companyId,
      @JsonKey(name: 'store_id') String? storeId,
      @JsonKey(name: 'location_id') String locationId,
      @JsonKey(name: 'currency_id') String currencyId,
      @JsonKey(name: 'created_by') String userId,
      @JsonKey(name: 'record_date') DateTime recordDate,
      @JsonKey(name: 'created_at') DateTime createdAt,
      List<DenominationDto> denominations});
}

/// @nodoc
class _$VaultRecountDtoCopyWithImpl<$Res, $Val extends VaultRecountDto>
    implements $VaultRecountDtoCopyWith<$Res> {
  _$VaultRecountDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VaultRecountDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? companyId = null,
    Object? storeId = freezed,
    Object? locationId = null,
    Object? currencyId = null,
    Object? userId = null,
    Object? recordDate = null,
    Object? createdAt = null,
    Object? denominations = null,
  }) {
    return _then(_value.copyWith(
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: freezed == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      locationId: null == locationId
          ? _value.locationId
          : locationId // ignore: cast_nullable_to_non_nullable
              as String,
      currencyId: null == currencyId
          ? _value.currencyId
          : currencyId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      recordDate: null == recordDate
          ? _value.recordDate
          : recordDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      denominations: null == denominations
          ? _value.denominations
          : denominations // ignore: cast_nullable_to_non_nullable
              as List<DenominationDto>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VaultRecountDtoImplCopyWith<$Res>
    implements $VaultRecountDtoCopyWith<$Res> {
  factory _$$VaultRecountDtoImplCopyWith(_$VaultRecountDtoImpl value,
          $Res Function(_$VaultRecountDtoImpl) then) =
      __$$VaultRecountDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'company_id') String companyId,
      @JsonKey(name: 'store_id') String? storeId,
      @JsonKey(name: 'location_id') String locationId,
      @JsonKey(name: 'currency_id') String currencyId,
      @JsonKey(name: 'created_by') String userId,
      @JsonKey(name: 'record_date') DateTime recordDate,
      @JsonKey(name: 'created_at') DateTime createdAt,
      List<DenominationDto> denominations});
}

/// @nodoc
class __$$VaultRecountDtoImplCopyWithImpl<$Res>
    extends _$VaultRecountDtoCopyWithImpl<$Res, _$VaultRecountDtoImpl>
    implements _$$VaultRecountDtoImplCopyWith<$Res> {
  __$$VaultRecountDtoImplCopyWithImpl(
      _$VaultRecountDtoImpl _value, $Res Function(_$VaultRecountDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of VaultRecountDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? companyId = null,
    Object? storeId = freezed,
    Object? locationId = null,
    Object? currencyId = null,
    Object? userId = null,
    Object? recordDate = null,
    Object? createdAt = null,
    Object? denominations = null,
  }) {
    return _then(_$VaultRecountDtoImpl(
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: freezed == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      locationId: null == locationId
          ? _value.locationId
          : locationId // ignore: cast_nullable_to_non_nullable
              as String,
      currencyId: null == currencyId
          ? _value.currencyId
          : currencyId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      recordDate: null == recordDate
          ? _value.recordDate
          : recordDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      denominations: null == denominations
          ? _value._denominations
          : denominations // ignore: cast_nullable_to_non_nullable
              as List<DenominationDto>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VaultRecountDtoImpl extends _VaultRecountDto {
  const _$VaultRecountDtoImpl(
      {@JsonKey(name: 'company_id') required this.companyId,
      @JsonKey(name: 'store_id') this.storeId,
      @JsonKey(name: 'location_id') required this.locationId,
      @JsonKey(name: 'currency_id') required this.currencyId,
      @JsonKey(name: 'created_by') required this.userId,
      @JsonKey(name: 'record_date') required this.recordDate,
      @JsonKey(name: 'created_at') required this.createdAt,
      final List<DenominationDto> denominations = const []})
      : _denominations = denominations,
        super._();

  factory _$VaultRecountDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$VaultRecountDtoImplFromJson(json);

  @override
  @JsonKey(name: 'company_id')
  final String companyId;
  @override
  @JsonKey(name: 'store_id')
  final String? storeId;
  @override
  @JsonKey(name: 'location_id')
  final String locationId;
  @override
  @JsonKey(name: 'currency_id')
  final String currencyId;
  @override
  @JsonKey(name: 'created_by')
  final String userId;
  @override
  @JsonKey(name: 'record_date')
  final DateTime recordDate;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  final List<DenominationDto> _denominations;
  @override
  @JsonKey()
  List<DenominationDto> get denominations {
    if (_denominations is EqualUnmodifiableListView) return _denominations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_denominations);
  }

  @override
  String toString() {
    return 'VaultRecountDto(companyId: $companyId, storeId: $storeId, locationId: $locationId, currencyId: $currencyId, userId: $userId, recordDate: $recordDate, createdAt: $createdAt, denominations: $denominations)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VaultRecountDtoImpl &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.locationId, locationId) ||
                other.locationId == locationId) &&
            (identical(other.currencyId, currencyId) ||
                other.currencyId == currencyId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.recordDate, recordDate) ||
                other.recordDate == recordDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality()
                .equals(other._denominations, _denominations));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      companyId,
      storeId,
      locationId,
      currencyId,
      userId,
      recordDate,
      createdAt,
      const DeepCollectionEquality().hash(_denominations));

  /// Create a copy of VaultRecountDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VaultRecountDtoImplCopyWith<_$VaultRecountDtoImpl> get copyWith =>
      __$$VaultRecountDtoImplCopyWithImpl<_$VaultRecountDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VaultRecountDtoImplToJson(
      this,
    );
  }
}

abstract class _VaultRecountDto extends VaultRecountDto {
  const factory _VaultRecountDto(
      {@JsonKey(name: 'company_id') required final String companyId,
      @JsonKey(name: 'store_id') final String? storeId,
      @JsonKey(name: 'location_id') required final String locationId,
      @JsonKey(name: 'currency_id') required final String currencyId,
      @JsonKey(name: 'created_by') required final String userId,
      @JsonKey(name: 'record_date') required final DateTime recordDate,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      final List<DenominationDto> denominations}) = _$VaultRecountDtoImpl;
  const _VaultRecountDto._() : super._();

  factory _VaultRecountDto.fromJson(Map<String, dynamic> json) =
      _$VaultRecountDtoImpl.fromJson;

  @override
  @JsonKey(name: 'company_id')
  String get companyId;
  @override
  @JsonKey(name: 'store_id')
  String? get storeId;
  @override
  @JsonKey(name: 'location_id')
  String get locationId;
  @override
  @JsonKey(name: 'currency_id')
  String get currencyId;
  @override
  @JsonKey(name: 'created_by')
  String get userId;
  @override
  @JsonKey(name: 'record_date')
  DateTime get recordDate;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  List<DenominationDto> get denominations;

  /// Create a copy of VaultRecountDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VaultRecountDtoImplCopyWith<_$VaultRecountDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
