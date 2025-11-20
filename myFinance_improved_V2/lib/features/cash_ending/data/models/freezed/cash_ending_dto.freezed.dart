// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cash_ending_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CashEndingDto _$CashEndingDtoFromJson(Map<String, dynamic> json) {
  return _CashEndingDto.fromJson(json);
}

/// @nodoc
mixin _$CashEndingDto {
  @JsonKey(name: 'cash_ending_id')
  String? get cashEndingId => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_id')
  String get companyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String? get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_by')
  String? get createdBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'location_id')
  String get locationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'store_id')
  String? get storeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'record_date')
  DateTime get recordDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  List<CurrencyDto> get currencies => throw _privateConstructorUsedError;

  /// Serializes this CashEndingDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CashEndingDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CashEndingDtoCopyWith<CashEndingDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CashEndingDtoCopyWith<$Res> {
  factory $CashEndingDtoCopyWith(
          CashEndingDto value, $Res Function(CashEndingDto) then) =
      _$CashEndingDtoCopyWithImpl<$Res, CashEndingDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'cash_ending_id') String? cashEndingId,
      @JsonKey(name: 'company_id') String companyId,
      @JsonKey(name: 'user_id') String? userId,
      @JsonKey(name: 'created_by') String? createdBy,
      @JsonKey(name: 'location_id') String locationId,
      @JsonKey(name: 'store_id') String? storeId,
      @JsonKey(name: 'record_date') DateTime recordDate,
      @JsonKey(name: 'created_at') DateTime createdAt,
      List<CurrencyDto> currencies});
}

/// @nodoc
class _$CashEndingDtoCopyWithImpl<$Res, $Val extends CashEndingDto>
    implements $CashEndingDtoCopyWith<$Res> {
  _$CashEndingDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CashEndingDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cashEndingId = freezed,
    Object? companyId = null,
    Object? userId = freezed,
    Object? createdBy = freezed,
    Object? locationId = null,
    Object? storeId = freezed,
    Object? recordDate = null,
    Object? createdAt = null,
    Object? currencies = null,
  }) {
    return _then(_value.copyWith(
      cashEndingId: freezed == cashEndingId
          ? _value.cashEndingId
          : cashEndingId // ignore: cast_nullable_to_non_nullable
              as String?,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      locationId: null == locationId
          ? _value.locationId
          : locationId // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: freezed == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      recordDate: null == recordDate
          ? _value.recordDate
          : recordDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      currencies: null == currencies
          ? _value.currencies
          : currencies // ignore: cast_nullable_to_non_nullable
              as List<CurrencyDto>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CashEndingDtoImplCopyWith<$Res>
    implements $CashEndingDtoCopyWith<$Res> {
  factory _$$CashEndingDtoImplCopyWith(
          _$CashEndingDtoImpl value, $Res Function(_$CashEndingDtoImpl) then) =
      __$$CashEndingDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'cash_ending_id') String? cashEndingId,
      @JsonKey(name: 'company_id') String companyId,
      @JsonKey(name: 'user_id') String? userId,
      @JsonKey(name: 'created_by') String? createdBy,
      @JsonKey(name: 'location_id') String locationId,
      @JsonKey(name: 'store_id') String? storeId,
      @JsonKey(name: 'record_date') DateTime recordDate,
      @JsonKey(name: 'created_at') DateTime createdAt,
      List<CurrencyDto> currencies});
}

/// @nodoc
class __$$CashEndingDtoImplCopyWithImpl<$Res>
    extends _$CashEndingDtoCopyWithImpl<$Res, _$CashEndingDtoImpl>
    implements _$$CashEndingDtoImplCopyWith<$Res> {
  __$$CashEndingDtoImplCopyWithImpl(
      _$CashEndingDtoImpl _value, $Res Function(_$CashEndingDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of CashEndingDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cashEndingId = freezed,
    Object? companyId = null,
    Object? userId = freezed,
    Object? createdBy = freezed,
    Object? locationId = null,
    Object? storeId = freezed,
    Object? recordDate = null,
    Object? createdAt = null,
    Object? currencies = null,
  }) {
    return _then(_$CashEndingDtoImpl(
      cashEndingId: freezed == cashEndingId
          ? _value.cashEndingId
          : cashEndingId // ignore: cast_nullable_to_non_nullable
              as String?,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      locationId: null == locationId
          ? _value.locationId
          : locationId // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: freezed == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      recordDate: null == recordDate
          ? _value.recordDate
          : recordDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      currencies: null == currencies
          ? _value._currencies
          : currencies // ignore: cast_nullable_to_non_nullable
              as List<CurrencyDto>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CashEndingDtoImpl extends _CashEndingDto {
  const _$CashEndingDtoImpl(
      {@JsonKey(name: 'cash_ending_id') this.cashEndingId,
      @JsonKey(name: 'company_id') required this.companyId,
      @JsonKey(name: 'user_id') this.userId,
      @JsonKey(name: 'created_by') this.createdBy,
      @JsonKey(name: 'location_id') required this.locationId,
      @JsonKey(name: 'store_id') this.storeId,
      @JsonKey(name: 'record_date') required this.recordDate,
      @JsonKey(name: 'created_at') required this.createdAt,
      final List<CurrencyDto> currencies = const []})
      : _currencies = currencies,
        super._();

  factory _$CashEndingDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CashEndingDtoImplFromJson(json);

  @override
  @JsonKey(name: 'cash_ending_id')
  final String? cashEndingId;
  @override
  @JsonKey(name: 'company_id')
  final String companyId;
  @override
  @JsonKey(name: 'user_id')
  final String? userId;
  @override
  @JsonKey(name: 'created_by')
  final String? createdBy;
  @override
  @JsonKey(name: 'location_id')
  final String locationId;
  @override
  @JsonKey(name: 'store_id')
  final String? storeId;
  @override
  @JsonKey(name: 'record_date')
  final DateTime recordDate;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  final List<CurrencyDto> _currencies;
  @override
  @JsonKey()
  List<CurrencyDto> get currencies {
    if (_currencies is EqualUnmodifiableListView) return _currencies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_currencies);
  }

  @override
  String toString() {
    return 'CashEndingDto(cashEndingId: $cashEndingId, companyId: $companyId, userId: $userId, createdBy: $createdBy, locationId: $locationId, storeId: $storeId, recordDate: $recordDate, createdAt: $createdAt, currencies: $currencies)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CashEndingDtoImpl &&
            (identical(other.cashEndingId, cashEndingId) ||
                other.cashEndingId == cashEndingId) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.locationId, locationId) ||
                other.locationId == locationId) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.recordDate, recordDate) ||
                other.recordDate == recordDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality()
                .equals(other._currencies, _currencies));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      cashEndingId,
      companyId,
      userId,
      createdBy,
      locationId,
      storeId,
      recordDate,
      createdAt,
      const DeepCollectionEquality().hash(_currencies));

  /// Create a copy of CashEndingDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CashEndingDtoImplCopyWith<_$CashEndingDtoImpl> get copyWith =>
      __$$CashEndingDtoImplCopyWithImpl<_$CashEndingDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CashEndingDtoImplToJson(
      this,
    );
  }
}

abstract class _CashEndingDto extends CashEndingDto {
  const factory _CashEndingDto(
      {@JsonKey(name: 'cash_ending_id') final String? cashEndingId,
      @JsonKey(name: 'company_id') required final String companyId,
      @JsonKey(name: 'user_id') final String? userId,
      @JsonKey(name: 'created_by') final String? createdBy,
      @JsonKey(name: 'location_id') required final String locationId,
      @JsonKey(name: 'store_id') final String? storeId,
      @JsonKey(name: 'record_date') required final DateTime recordDate,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      final List<CurrencyDto> currencies}) = _$CashEndingDtoImpl;
  const _CashEndingDto._() : super._();

  factory _CashEndingDto.fromJson(Map<String, dynamic> json) =
      _$CashEndingDtoImpl.fromJson;

  @override
  @JsonKey(name: 'cash_ending_id')
  String? get cashEndingId;
  @override
  @JsonKey(name: 'company_id')
  String get companyId;
  @override
  @JsonKey(name: 'user_id')
  String? get userId;
  @override
  @JsonKey(name: 'created_by')
  String? get createdBy;
  @override
  @JsonKey(name: 'location_id')
  String get locationId;
  @override
  @JsonKey(name: 'store_id')
  String? get storeId;
  @override
  @JsonKey(name: 'record_date')
  DateTime get recordDate;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  List<CurrencyDto> get currencies;

  /// Create a copy of CashEndingDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CashEndingDtoImplCopyWith<_$CashEndingDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
