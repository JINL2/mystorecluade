// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stock_flow_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LocationSummaryDto _$LocationSummaryDtoFromJson(Map<String, dynamic> json) {
  return _LocationSummaryDto.fromJson(json);
}

/// @nodoc
mixin _$LocationSummaryDto {
  @JsonKey(name: 'cash_location_id')
  String get cashLocationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'location_name')
  String get locationName => throw _privateConstructorUsedError;
  @JsonKey(name: 'location_type')
  String get locationType => throw _privateConstructorUsedError;
  @JsonKey(name: 'bank_name')
  String? get bankName => throw _privateConstructorUsedError;
  @JsonKey(name: 'bank_account')
  String? get bankAccount => throw _privateConstructorUsedError;
  @JsonKey(name: 'currency_code')
  String get currencyCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'currency_id')
  String get currencyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'base_currency_symbol')
  String? get baseCurrencySymbol => throw _privateConstructorUsedError;
  @JsonKey(name: 'currency_symbol')
  String? get currencySymbol => throw _privateConstructorUsedError;

  /// Serializes this LocationSummaryDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LocationSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LocationSummaryDtoCopyWith<LocationSummaryDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocationSummaryDtoCopyWith<$Res> {
  factory $LocationSummaryDtoCopyWith(
          LocationSummaryDto value, $Res Function(LocationSummaryDto) then) =
      _$LocationSummaryDtoCopyWithImpl<$Res, LocationSummaryDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'cash_location_id') String cashLocationId,
      @JsonKey(name: 'location_name') String locationName,
      @JsonKey(name: 'location_type') String locationType,
      @JsonKey(name: 'bank_name') String? bankName,
      @JsonKey(name: 'bank_account') String? bankAccount,
      @JsonKey(name: 'currency_code') String currencyCode,
      @JsonKey(name: 'currency_id') String currencyId,
      @JsonKey(name: 'base_currency_symbol') String? baseCurrencySymbol,
      @JsonKey(name: 'currency_symbol') String? currencySymbol});
}

/// @nodoc
class _$LocationSummaryDtoCopyWithImpl<$Res, $Val extends LocationSummaryDto>
    implements $LocationSummaryDtoCopyWith<$Res> {
  _$LocationSummaryDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LocationSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cashLocationId = null,
    Object? locationName = null,
    Object? locationType = null,
    Object? bankName = freezed,
    Object? bankAccount = freezed,
    Object? currencyCode = null,
    Object? currencyId = null,
    Object? baseCurrencySymbol = freezed,
    Object? currencySymbol = freezed,
  }) {
    return _then(_value.copyWith(
      cashLocationId: null == cashLocationId
          ? _value.cashLocationId
          : cashLocationId // ignore: cast_nullable_to_non_nullable
              as String,
      locationName: null == locationName
          ? _value.locationName
          : locationName // ignore: cast_nullable_to_non_nullable
              as String,
      locationType: null == locationType
          ? _value.locationType
          : locationType // ignore: cast_nullable_to_non_nullable
              as String,
      bankName: freezed == bankName
          ? _value.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as String?,
      bankAccount: freezed == bankAccount
          ? _value.bankAccount
          : bankAccount // ignore: cast_nullable_to_non_nullable
              as String?,
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      currencyId: null == currencyId
          ? _value.currencyId
          : currencyId // ignore: cast_nullable_to_non_nullable
              as String,
      baseCurrencySymbol: freezed == baseCurrencySymbol
          ? _value.baseCurrencySymbol
          : baseCurrencySymbol // ignore: cast_nullable_to_non_nullable
              as String?,
      currencySymbol: freezed == currencySymbol
          ? _value.currencySymbol
          : currencySymbol // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LocationSummaryDtoImplCopyWith<$Res>
    implements $LocationSummaryDtoCopyWith<$Res> {
  factory _$$LocationSummaryDtoImplCopyWith(_$LocationSummaryDtoImpl value,
          $Res Function(_$LocationSummaryDtoImpl) then) =
      __$$LocationSummaryDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'cash_location_id') String cashLocationId,
      @JsonKey(name: 'location_name') String locationName,
      @JsonKey(name: 'location_type') String locationType,
      @JsonKey(name: 'bank_name') String? bankName,
      @JsonKey(name: 'bank_account') String? bankAccount,
      @JsonKey(name: 'currency_code') String currencyCode,
      @JsonKey(name: 'currency_id') String currencyId,
      @JsonKey(name: 'base_currency_symbol') String? baseCurrencySymbol,
      @JsonKey(name: 'currency_symbol') String? currencySymbol});
}

/// @nodoc
class __$$LocationSummaryDtoImplCopyWithImpl<$Res>
    extends _$LocationSummaryDtoCopyWithImpl<$Res, _$LocationSummaryDtoImpl>
    implements _$$LocationSummaryDtoImplCopyWith<$Res> {
  __$$LocationSummaryDtoImplCopyWithImpl(_$LocationSummaryDtoImpl _value,
      $Res Function(_$LocationSummaryDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of LocationSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cashLocationId = null,
    Object? locationName = null,
    Object? locationType = null,
    Object? bankName = freezed,
    Object? bankAccount = freezed,
    Object? currencyCode = null,
    Object? currencyId = null,
    Object? baseCurrencySymbol = freezed,
    Object? currencySymbol = freezed,
  }) {
    return _then(_$LocationSummaryDtoImpl(
      cashLocationId: null == cashLocationId
          ? _value.cashLocationId
          : cashLocationId // ignore: cast_nullable_to_non_nullable
              as String,
      locationName: null == locationName
          ? _value.locationName
          : locationName // ignore: cast_nullable_to_non_nullable
              as String,
      locationType: null == locationType
          ? _value.locationType
          : locationType // ignore: cast_nullable_to_non_nullable
              as String,
      bankName: freezed == bankName
          ? _value.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as String?,
      bankAccount: freezed == bankAccount
          ? _value.bankAccount
          : bankAccount // ignore: cast_nullable_to_non_nullable
              as String?,
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      currencyId: null == currencyId
          ? _value.currencyId
          : currencyId // ignore: cast_nullable_to_non_nullable
              as String,
      baseCurrencySymbol: freezed == baseCurrencySymbol
          ? _value.baseCurrencySymbol
          : baseCurrencySymbol // ignore: cast_nullable_to_non_nullable
              as String?,
      currencySymbol: freezed == currencySymbol
          ? _value.currencySymbol
          : currencySymbol // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LocationSummaryDtoImpl extends _LocationSummaryDto {
  const _$LocationSummaryDtoImpl(
      {@JsonKey(name: 'cash_location_id') required this.cashLocationId,
      @JsonKey(name: 'location_name') required this.locationName,
      @JsonKey(name: 'location_type') required this.locationType,
      @JsonKey(name: 'bank_name') this.bankName,
      @JsonKey(name: 'bank_account') this.bankAccount,
      @JsonKey(name: 'currency_code') required this.currencyCode,
      @JsonKey(name: 'currency_id') required this.currencyId,
      @JsonKey(name: 'base_currency_symbol') this.baseCurrencySymbol,
      @JsonKey(name: 'currency_symbol') this.currencySymbol})
      : super._();

  factory _$LocationSummaryDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$LocationSummaryDtoImplFromJson(json);

  @override
  @JsonKey(name: 'cash_location_id')
  final String cashLocationId;
  @override
  @JsonKey(name: 'location_name')
  final String locationName;
  @override
  @JsonKey(name: 'location_type')
  final String locationType;
  @override
  @JsonKey(name: 'bank_name')
  final String? bankName;
  @override
  @JsonKey(name: 'bank_account')
  final String? bankAccount;
  @override
  @JsonKey(name: 'currency_code')
  final String currencyCode;
  @override
  @JsonKey(name: 'currency_id')
  final String currencyId;
  @override
  @JsonKey(name: 'base_currency_symbol')
  final String? baseCurrencySymbol;
  @override
  @JsonKey(name: 'currency_symbol')
  final String? currencySymbol;

  @override
  String toString() {
    return 'LocationSummaryDto(cashLocationId: $cashLocationId, locationName: $locationName, locationType: $locationType, bankName: $bankName, bankAccount: $bankAccount, currencyCode: $currencyCode, currencyId: $currencyId, baseCurrencySymbol: $baseCurrencySymbol, currencySymbol: $currencySymbol)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocationSummaryDtoImpl &&
            (identical(other.cashLocationId, cashLocationId) ||
                other.cashLocationId == cashLocationId) &&
            (identical(other.locationName, locationName) ||
                other.locationName == locationName) &&
            (identical(other.locationType, locationType) ||
                other.locationType == locationType) &&
            (identical(other.bankName, bankName) ||
                other.bankName == bankName) &&
            (identical(other.bankAccount, bankAccount) ||
                other.bankAccount == bankAccount) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.currencyId, currencyId) ||
                other.currencyId == currencyId) &&
            (identical(other.baseCurrencySymbol, baseCurrencySymbol) ||
                other.baseCurrencySymbol == baseCurrencySymbol) &&
            (identical(other.currencySymbol, currencySymbol) ||
                other.currencySymbol == currencySymbol));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      cashLocationId,
      locationName,
      locationType,
      bankName,
      bankAccount,
      currencyCode,
      currencyId,
      baseCurrencySymbol,
      currencySymbol);

  /// Create a copy of LocationSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LocationSummaryDtoImplCopyWith<_$LocationSummaryDtoImpl> get copyWith =>
      __$$LocationSummaryDtoImplCopyWithImpl<_$LocationSummaryDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LocationSummaryDtoImplToJson(
      this,
    );
  }
}

abstract class _LocationSummaryDto extends LocationSummaryDto {
  const factory _LocationSummaryDto(
      {@JsonKey(name: 'cash_location_id') required final String cashLocationId,
      @JsonKey(name: 'location_name') required final String locationName,
      @JsonKey(name: 'location_type') required final String locationType,
      @JsonKey(name: 'bank_name') final String? bankName,
      @JsonKey(name: 'bank_account') final String? bankAccount,
      @JsonKey(name: 'currency_code') required final String currencyCode,
      @JsonKey(name: 'currency_id') required final String currencyId,
      @JsonKey(name: 'base_currency_symbol') final String? baseCurrencySymbol,
      @JsonKey(name: 'currency_symbol')
      final String? currencySymbol}) = _$LocationSummaryDtoImpl;
  const _LocationSummaryDto._() : super._();

  factory _LocationSummaryDto.fromJson(Map<String, dynamic> json) =
      _$LocationSummaryDtoImpl.fromJson;

  @override
  @JsonKey(name: 'cash_location_id')
  String get cashLocationId;
  @override
  @JsonKey(name: 'location_name')
  String get locationName;
  @override
  @JsonKey(name: 'location_type')
  String get locationType;
  @override
  @JsonKey(name: 'bank_name')
  String? get bankName;
  @override
  @JsonKey(name: 'bank_account')
  String? get bankAccount;
  @override
  @JsonKey(name: 'currency_code')
  String get currencyCode;
  @override
  @JsonKey(name: 'currency_id')
  String get currencyId;
  @override
  @JsonKey(name: 'base_currency_symbol')
  String? get baseCurrencySymbol;
  @override
  @JsonKey(name: 'currency_symbol')
  String? get currencySymbol;

  /// Create a copy of LocationSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LocationSummaryDtoImplCopyWith<_$LocationSummaryDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CurrencyInfoDto _$CurrencyInfoDtoFromJson(Map<String, dynamic> json) {
  return _CurrencyInfoDto.fromJson(json);
}

/// @nodoc
mixin _$CurrencyInfoDto {
  @JsonKey(name: 'currency_id')
  String get currencyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'currency_code')
  String get currencyCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'currency_name')
  String get currencyName => throw _privateConstructorUsedError;
  @JsonKey(name: 'symbol')
  String get symbol => throw _privateConstructorUsedError;

  /// Serializes this CurrencyInfoDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CurrencyInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CurrencyInfoDtoCopyWith<CurrencyInfoDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CurrencyInfoDtoCopyWith<$Res> {
  factory $CurrencyInfoDtoCopyWith(
          CurrencyInfoDto value, $Res Function(CurrencyInfoDto) then) =
      _$CurrencyInfoDtoCopyWithImpl<$Res, CurrencyInfoDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'currency_id') String currencyId,
      @JsonKey(name: 'currency_code') String currencyCode,
      @JsonKey(name: 'currency_name') String currencyName,
      @JsonKey(name: 'symbol') String symbol});
}

/// @nodoc
class _$CurrencyInfoDtoCopyWithImpl<$Res, $Val extends CurrencyInfoDto>
    implements $CurrencyInfoDtoCopyWith<$Res> {
  _$CurrencyInfoDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CurrencyInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currencyId = null,
    Object? currencyCode = null,
    Object? currencyName = null,
    Object? symbol = null,
  }) {
    return _then(_value.copyWith(
      currencyId: null == currencyId
          ? _value.currencyId
          : currencyId // ignore: cast_nullable_to_non_nullable
              as String,
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      currencyName: null == currencyName
          ? _value.currencyName
          : currencyName // ignore: cast_nullable_to_non_nullable
              as String,
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CurrencyInfoDtoImplCopyWith<$Res>
    implements $CurrencyInfoDtoCopyWith<$Res> {
  factory _$$CurrencyInfoDtoImplCopyWith(_$CurrencyInfoDtoImpl value,
          $Res Function(_$CurrencyInfoDtoImpl) then) =
      __$$CurrencyInfoDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'currency_id') String currencyId,
      @JsonKey(name: 'currency_code') String currencyCode,
      @JsonKey(name: 'currency_name') String currencyName,
      @JsonKey(name: 'symbol') String symbol});
}

/// @nodoc
class __$$CurrencyInfoDtoImplCopyWithImpl<$Res>
    extends _$CurrencyInfoDtoCopyWithImpl<$Res, _$CurrencyInfoDtoImpl>
    implements _$$CurrencyInfoDtoImplCopyWith<$Res> {
  __$$CurrencyInfoDtoImplCopyWithImpl(
      _$CurrencyInfoDtoImpl _value, $Res Function(_$CurrencyInfoDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of CurrencyInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currencyId = null,
    Object? currencyCode = null,
    Object? currencyName = null,
    Object? symbol = null,
  }) {
    return _then(_$CurrencyInfoDtoImpl(
      currencyId: null == currencyId
          ? _value.currencyId
          : currencyId // ignore: cast_nullable_to_non_nullable
              as String,
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      currencyName: null == currencyName
          ? _value.currencyName
          : currencyName // ignore: cast_nullable_to_non_nullable
              as String,
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CurrencyInfoDtoImpl extends _CurrencyInfoDto {
  const _$CurrencyInfoDtoImpl(
      {@JsonKey(name: 'currency_id') required this.currencyId,
      @JsonKey(name: 'currency_code') required this.currencyCode,
      @JsonKey(name: 'currency_name') required this.currencyName,
      @JsonKey(name: 'symbol') required this.symbol})
      : super._();

  factory _$CurrencyInfoDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CurrencyInfoDtoImplFromJson(json);

  @override
  @JsonKey(name: 'currency_id')
  final String currencyId;
  @override
  @JsonKey(name: 'currency_code')
  final String currencyCode;
  @override
  @JsonKey(name: 'currency_name')
  final String currencyName;
  @override
  @JsonKey(name: 'symbol')
  final String symbol;

  @override
  String toString() {
    return 'CurrencyInfoDto(currencyId: $currencyId, currencyCode: $currencyCode, currencyName: $currencyName, symbol: $symbol)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CurrencyInfoDtoImpl &&
            (identical(other.currencyId, currencyId) ||
                other.currencyId == currencyId) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.currencyName, currencyName) ||
                other.currencyName == currencyName) &&
            (identical(other.symbol, symbol) || other.symbol == symbol));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, currencyId, currencyCode, currencyName, symbol);

  /// Create a copy of CurrencyInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CurrencyInfoDtoImplCopyWith<_$CurrencyInfoDtoImpl> get copyWith =>
      __$$CurrencyInfoDtoImplCopyWithImpl<_$CurrencyInfoDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CurrencyInfoDtoImplToJson(
      this,
    );
  }
}

abstract class _CurrencyInfoDto extends CurrencyInfoDto {
  const factory _CurrencyInfoDto(
          {@JsonKey(name: 'currency_id') required final String currencyId,
          @JsonKey(name: 'currency_code') required final String currencyCode,
          @JsonKey(name: 'currency_name') required final String currencyName,
          @JsonKey(name: 'symbol') required final String symbol}) =
      _$CurrencyInfoDtoImpl;
  const _CurrencyInfoDto._() : super._();

  factory _CurrencyInfoDto.fromJson(Map<String, dynamic> json) =
      _$CurrencyInfoDtoImpl.fromJson;

  @override
  @JsonKey(name: 'currency_id')
  String get currencyId;
  @override
  @JsonKey(name: 'currency_code')
  String get currencyCode;
  @override
  @JsonKey(name: 'currency_name')
  String get currencyName;
  @override
  @JsonKey(name: 'symbol')
  String get symbol;

  /// Create a copy of CurrencyInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CurrencyInfoDtoImplCopyWith<_$CurrencyInfoDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreatedByDto _$CreatedByDtoFromJson(Map<String, dynamic> json) {
  return _CreatedByDto.fromJson(json);
}

/// @nodoc
mixin _$CreatedByDto {
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'full_name')
  String get fullName => throw _privateConstructorUsedError;

  /// Serializes this CreatedByDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreatedByDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreatedByDtoCopyWith<CreatedByDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreatedByDtoCopyWith<$Res> {
  factory $CreatedByDtoCopyWith(
          CreatedByDto value, $Res Function(CreatedByDto) then) =
      _$CreatedByDtoCopyWithImpl<$Res, CreatedByDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'full_name') String fullName});
}

/// @nodoc
class _$CreatedByDtoCopyWithImpl<$Res, $Val extends CreatedByDto>
    implements $CreatedByDtoCopyWith<$Res> {
  _$CreatedByDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreatedByDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? fullName = null,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreatedByDtoImplCopyWith<$Res>
    implements $CreatedByDtoCopyWith<$Res> {
  factory _$$CreatedByDtoImplCopyWith(
          _$CreatedByDtoImpl value, $Res Function(_$CreatedByDtoImpl) then) =
      __$$CreatedByDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'full_name') String fullName});
}

/// @nodoc
class __$$CreatedByDtoImplCopyWithImpl<$Res>
    extends _$CreatedByDtoCopyWithImpl<$Res, _$CreatedByDtoImpl>
    implements _$$CreatedByDtoImplCopyWith<$Res> {
  __$$CreatedByDtoImplCopyWithImpl(
      _$CreatedByDtoImpl _value, $Res Function(_$CreatedByDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreatedByDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? fullName = null,
  }) {
    return _then(_$CreatedByDtoImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreatedByDtoImpl extends _CreatedByDto {
  const _$CreatedByDtoImpl(
      {@JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'full_name') required this.fullName})
      : super._();

  factory _$CreatedByDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreatedByDtoImplFromJson(json);

  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'full_name')
  final String fullName;

  @override
  String toString() {
    return 'CreatedByDto(userId: $userId, fullName: $fullName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreatedByDtoImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userId, fullName);

  /// Create a copy of CreatedByDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreatedByDtoImplCopyWith<_$CreatedByDtoImpl> get copyWith =>
      __$$CreatedByDtoImplCopyWithImpl<_$CreatedByDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreatedByDtoImplToJson(
      this,
    );
  }
}

abstract class _CreatedByDto extends CreatedByDto {
  const factory _CreatedByDto(
          {@JsonKey(name: 'user_id') required final String userId,
          @JsonKey(name: 'full_name') required final String fullName}) =
      _$CreatedByDtoImpl;
  const _CreatedByDto._() : super._();

  factory _CreatedByDto.fromJson(Map<String, dynamic> json) =
      _$CreatedByDtoImpl.fromJson;

  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'full_name')
  String get fullName;

  /// Create a copy of CreatedByDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreatedByDtoImplCopyWith<_$CreatedByDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DenominationDetailDto _$DenominationDetailDtoFromJson(
    Map<String, dynamic> json) {
  return _DenominationDetailDto.fromJson(json);
}

/// @nodoc
mixin _$DenominationDetailDto {
  @JsonKey(name: 'denomination_id')
  String? get denominationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'denomination_value')
  double? get denominationValue => throw _privateConstructorUsedError;
  @JsonKey(name: 'denomination_type')
  String? get denominationType => throw _privateConstructorUsedError;
  @JsonKey(name: 'previous_quantity')
  int? get previousQuantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_quantity')
  int? get currentQuantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'quantity_change')
  int? get quantityChange => throw _privateConstructorUsedError;
  @JsonKey(name: 'subtotal')
  double? get subtotal => throw _privateConstructorUsedError;
  @JsonKey(name: 'currency_symbol')
  String? get currencySymbol => throw _privateConstructorUsedError;

  /// Serializes this DenominationDetailDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DenominationDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DenominationDetailDtoCopyWith<DenominationDetailDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DenominationDetailDtoCopyWith<$Res> {
  factory $DenominationDetailDtoCopyWith(DenominationDetailDto value,
          $Res Function(DenominationDetailDto) then) =
      _$DenominationDetailDtoCopyWithImpl<$Res, DenominationDetailDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'denomination_id') String? denominationId,
      @JsonKey(name: 'denomination_value') double? denominationValue,
      @JsonKey(name: 'denomination_type') String? denominationType,
      @JsonKey(name: 'previous_quantity') int? previousQuantity,
      @JsonKey(name: 'current_quantity') int? currentQuantity,
      @JsonKey(name: 'quantity_change') int? quantityChange,
      @JsonKey(name: 'subtotal') double? subtotal,
      @JsonKey(name: 'currency_symbol') String? currencySymbol});
}

/// @nodoc
class _$DenominationDetailDtoCopyWithImpl<$Res,
        $Val extends DenominationDetailDto>
    implements $DenominationDetailDtoCopyWith<$Res> {
  _$DenominationDetailDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DenominationDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? denominationId = freezed,
    Object? denominationValue = freezed,
    Object? denominationType = freezed,
    Object? previousQuantity = freezed,
    Object? currentQuantity = freezed,
    Object? quantityChange = freezed,
    Object? subtotal = freezed,
    Object? currencySymbol = freezed,
  }) {
    return _then(_value.copyWith(
      denominationId: freezed == denominationId
          ? _value.denominationId
          : denominationId // ignore: cast_nullable_to_non_nullable
              as String?,
      denominationValue: freezed == denominationValue
          ? _value.denominationValue
          : denominationValue // ignore: cast_nullable_to_non_nullable
              as double?,
      denominationType: freezed == denominationType
          ? _value.denominationType
          : denominationType // ignore: cast_nullable_to_non_nullable
              as String?,
      previousQuantity: freezed == previousQuantity
          ? _value.previousQuantity
          : previousQuantity // ignore: cast_nullable_to_non_nullable
              as int?,
      currentQuantity: freezed == currentQuantity
          ? _value.currentQuantity
          : currentQuantity // ignore: cast_nullable_to_non_nullable
              as int?,
      quantityChange: freezed == quantityChange
          ? _value.quantityChange
          : quantityChange // ignore: cast_nullable_to_non_nullable
              as int?,
      subtotal: freezed == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double?,
      currencySymbol: freezed == currencySymbol
          ? _value.currencySymbol
          : currencySymbol // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DenominationDetailDtoImplCopyWith<$Res>
    implements $DenominationDetailDtoCopyWith<$Res> {
  factory _$$DenominationDetailDtoImplCopyWith(
          _$DenominationDetailDtoImpl value,
          $Res Function(_$DenominationDetailDtoImpl) then) =
      __$$DenominationDetailDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'denomination_id') String? denominationId,
      @JsonKey(name: 'denomination_value') double? denominationValue,
      @JsonKey(name: 'denomination_type') String? denominationType,
      @JsonKey(name: 'previous_quantity') int? previousQuantity,
      @JsonKey(name: 'current_quantity') int? currentQuantity,
      @JsonKey(name: 'quantity_change') int? quantityChange,
      @JsonKey(name: 'subtotal') double? subtotal,
      @JsonKey(name: 'currency_symbol') String? currencySymbol});
}

/// @nodoc
class __$$DenominationDetailDtoImplCopyWithImpl<$Res>
    extends _$DenominationDetailDtoCopyWithImpl<$Res,
        _$DenominationDetailDtoImpl>
    implements _$$DenominationDetailDtoImplCopyWith<$Res> {
  __$$DenominationDetailDtoImplCopyWithImpl(_$DenominationDetailDtoImpl _value,
      $Res Function(_$DenominationDetailDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of DenominationDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? denominationId = freezed,
    Object? denominationValue = freezed,
    Object? denominationType = freezed,
    Object? previousQuantity = freezed,
    Object? currentQuantity = freezed,
    Object? quantityChange = freezed,
    Object? subtotal = freezed,
    Object? currencySymbol = freezed,
  }) {
    return _then(_$DenominationDetailDtoImpl(
      denominationId: freezed == denominationId
          ? _value.denominationId
          : denominationId // ignore: cast_nullable_to_non_nullable
              as String?,
      denominationValue: freezed == denominationValue
          ? _value.denominationValue
          : denominationValue // ignore: cast_nullable_to_non_nullable
              as double?,
      denominationType: freezed == denominationType
          ? _value.denominationType
          : denominationType // ignore: cast_nullable_to_non_nullable
              as String?,
      previousQuantity: freezed == previousQuantity
          ? _value.previousQuantity
          : previousQuantity // ignore: cast_nullable_to_non_nullable
              as int?,
      currentQuantity: freezed == currentQuantity
          ? _value.currentQuantity
          : currentQuantity // ignore: cast_nullable_to_non_nullable
              as int?,
      quantityChange: freezed == quantityChange
          ? _value.quantityChange
          : quantityChange // ignore: cast_nullable_to_non_nullable
              as int?,
      subtotal: freezed == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double?,
      currencySymbol: freezed == currencySymbol
          ? _value.currencySymbol
          : currencySymbol // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DenominationDetailDtoImpl extends _DenominationDetailDto {
  const _$DenominationDetailDtoImpl(
      {@JsonKey(name: 'denomination_id') this.denominationId,
      @JsonKey(name: 'denomination_value') this.denominationValue,
      @JsonKey(name: 'denomination_type') this.denominationType,
      @JsonKey(name: 'previous_quantity') this.previousQuantity,
      @JsonKey(name: 'current_quantity') this.currentQuantity,
      @JsonKey(name: 'quantity_change') this.quantityChange,
      @JsonKey(name: 'subtotal') this.subtotal,
      @JsonKey(name: 'currency_symbol') this.currencySymbol})
      : super._();

  factory _$DenominationDetailDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$DenominationDetailDtoImplFromJson(json);

  @override
  @JsonKey(name: 'denomination_id')
  final String? denominationId;
  @override
  @JsonKey(name: 'denomination_value')
  final double? denominationValue;
  @override
  @JsonKey(name: 'denomination_type')
  final String? denominationType;
  @override
  @JsonKey(name: 'previous_quantity')
  final int? previousQuantity;
  @override
  @JsonKey(name: 'current_quantity')
  final int? currentQuantity;
  @override
  @JsonKey(name: 'quantity_change')
  final int? quantityChange;
  @override
  @JsonKey(name: 'subtotal')
  final double? subtotal;
  @override
  @JsonKey(name: 'currency_symbol')
  final String? currencySymbol;

  @override
  String toString() {
    return 'DenominationDetailDto(denominationId: $denominationId, denominationValue: $denominationValue, denominationType: $denominationType, previousQuantity: $previousQuantity, currentQuantity: $currentQuantity, quantityChange: $quantityChange, subtotal: $subtotal, currencySymbol: $currencySymbol)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DenominationDetailDtoImpl &&
            (identical(other.denominationId, denominationId) ||
                other.denominationId == denominationId) &&
            (identical(other.denominationValue, denominationValue) ||
                other.denominationValue == denominationValue) &&
            (identical(other.denominationType, denominationType) ||
                other.denominationType == denominationType) &&
            (identical(other.previousQuantity, previousQuantity) ||
                other.previousQuantity == previousQuantity) &&
            (identical(other.currentQuantity, currentQuantity) ||
                other.currentQuantity == currentQuantity) &&
            (identical(other.quantityChange, quantityChange) ||
                other.quantityChange == quantityChange) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.currencySymbol, currencySymbol) ||
                other.currencySymbol == currencySymbol));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      denominationId,
      denominationValue,
      denominationType,
      previousQuantity,
      currentQuantity,
      quantityChange,
      subtotal,
      currencySymbol);

  /// Create a copy of DenominationDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DenominationDetailDtoImplCopyWith<_$DenominationDetailDtoImpl>
      get copyWith => __$$DenominationDetailDtoImplCopyWithImpl<
          _$DenominationDetailDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DenominationDetailDtoImplToJson(
      this,
    );
  }
}

abstract class _DenominationDetailDto extends DenominationDetailDto {
  const factory _DenominationDetailDto(
          {@JsonKey(name: 'denomination_id') final String? denominationId,
          @JsonKey(name: 'denomination_value') final double? denominationValue,
          @JsonKey(name: 'denomination_type') final String? denominationType,
          @JsonKey(name: 'previous_quantity') final int? previousQuantity,
          @JsonKey(name: 'current_quantity') final int? currentQuantity,
          @JsonKey(name: 'quantity_change') final int? quantityChange,
          @JsonKey(name: 'subtotal') final double? subtotal,
          @JsonKey(name: 'currency_symbol') final String? currencySymbol}) =
      _$DenominationDetailDtoImpl;
  const _DenominationDetailDto._() : super._();

  factory _DenominationDetailDto.fromJson(Map<String, dynamic> json) =
      _$DenominationDetailDtoImpl.fromJson;

  @override
  @JsonKey(name: 'denomination_id')
  String? get denominationId;
  @override
  @JsonKey(name: 'denomination_value')
  double? get denominationValue;
  @override
  @JsonKey(name: 'denomination_type')
  String? get denominationType;
  @override
  @JsonKey(name: 'previous_quantity')
  int? get previousQuantity;
  @override
  @JsonKey(name: 'current_quantity')
  int? get currentQuantity;
  @override
  @JsonKey(name: 'quantity_change')
  int? get quantityChange;
  @override
  @JsonKey(name: 'subtotal')
  double? get subtotal;
  @override
  @JsonKey(name: 'currency_symbol')
  String? get currencySymbol;

  /// Create a copy of DenominationDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DenominationDetailDtoImplCopyWith<_$DenominationDetailDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ActualFlowDto _$ActualFlowDtoFromJson(Map<String, dynamic> json) {
  return _ActualFlowDto.fromJson(json);
}

/// @nodoc
mixin _$ActualFlowDto {
  @JsonKey(name: 'flow_id')
  String get flowId => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'system_time')
  String get systemTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'balance_before')
  double get balanceBefore => throw _privateConstructorUsedError;
  @JsonKey(name: 'flow_amount')
  double get flowAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'balance_after')
  double get balanceAfter => throw _privateConstructorUsedError;
  @JsonKey(name: 'currency')
  CurrencyInfoDto get currency => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_by')
  CreatedByDto get createdBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_denominations')
  List<DenominationDetailDto> get currentDenominations =>
      throw _privateConstructorUsedError;

  /// Serializes this ActualFlowDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActualFlowDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActualFlowDtoCopyWith<ActualFlowDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActualFlowDtoCopyWith<$Res> {
  factory $ActualFlowDtoCopyWith(
          ActualFlowDto value, $Res Function(ActualFlowDto) then) =
      _$ActualFlowDtoCopyWithImpl<$Res, ActualFlowDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'flow_id') String flowId,
      @JsonKey(name: 'created_at') String createdAt,
      @JsonKey(name: 'system_time') String systemTime,
      @JsonKey(name: 'balance_before') double balanceBefore,
      @JsonKey(name: 'flow_amount') double flowAmount,
      @JsonKey(name: 'balance_after') double balanceAfter,
      @JsonKey(name: 'currency') CurrencyInfoDto currency,
      @JsonKey(name: 'created_by') CreatedByDto createdBy,
      @JsonKey(name: 'current_denominations')
      List<DenominationDetailDto> currentDenominations});

  $CurrencyInfoDtoCopyWith<$Res> get currency;
  $CreatedByDtoCopyWith<$Res> get createdBy;
}

/// @nodoc
class _$ActualFlowDtoCopyWithImpl<$Res, $Val extends ActualFlowDto>
    implements $ActualFlowDtoCopyWith<$Res> {
  _$ActualFlowDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActualFlowDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? flowId = null,
    Object? createdAt = null,
    Object? systemTime = null,
    Object? balanceBefore = null,
    Object? flowAmount = null,
    Object? balanceAfter = null,
    Object? currency = null,
    Object? createdBy = null,
    Object? currentDenominations = null,
  }) {
    return _then(_value.copyWith(
      flowId: null == flowId
          ? _value.flowId
          : flowId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      systemTime: null == systemTime
          ? _value.systemTime
          : systemTime // ignore: cast_nullable_to_non_nullable
              as String,
      balanceBefore: null == balanceBefore
          ? _value.balanceBefore
          : balanceBefore // ignore: cast_nullable_to_non_nullable
              as double,
      flowAmount: null == flowAmount
          ? _value.flowAmount
          : flowAmount // ignore: cast_nullable_to_non_nullable
              as double,
      balanceAfter: null == balanceAfter
          ? _value.balanceAfter
          : balanceAfter // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as CurrencyInfoDto,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as CreatedByDto,
      currentDenominations: null == currentDenominations
          ? _value.currentDenominations
          : currentDenominations // ignore: cast_nullable_to_non_nullable
              as List<DenominationDetailDto>,
    ) as $Val);
  }

  /// Create a copy of ActualFlowDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CurrencyInfoDtoCopyWith<$Res> get currency {
    return $CurrencyInfoDtoCopyWith<$Res>(_value.currency, (value) {
      return _then(_value.copyWith(currency: value) as $Val);
    });
  }

  /// Create a copy of ActualFlowDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CreatedByDtoCopyWith<$Res> get createdBy {
    return $CreatedByDtoCopyWith<$Res>(_value.createdBy, (value) {
      return _then(_value.copyWith(createdBy: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ActualFlowDtoImplCopyWith<$Res>
    implements $ActualFlowDtoCopyWith<$Res> {
  factory _$$ActualFlowDtoImplCopyWith(
          _$ActualFlowDtoImpl value, $Res Function(_$ActualFlowDtoImpl) then) =
      __$$ActualFlowDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'flow_id') String flowId,
      @JsonKey(name: 'created_at') String createdAt,
      @JsonKey(name: 'system_time') String systemTime,
      @JsonKey(name: 'balance_before') double balanceBefore,
      @JsonKey(name: 'flow_amount') double flowAmount,
      @JsonKey(name: 'balance_after') double balanceAfter,
      @JsonKey(name: 'currency') CurrencyInfoDto currency,
      @JsonKey(name: 'created_by') CreatedByDto createdBy,
      @JsonKey(name: 'current_denominations')
      List<DenominationDetailDto> currentDenominations});

  @override
  $CurrencyInfoDtoCopyWith<$Res> get currency;
  @override
  $CreatedByDtoCopyWith<$Res> get createdBy;
}

/// @nodoc
class __$$ActualFlowDtoImplCopyWithImpl<$Res>
    extends _$ActualFlowDtoCopyWithImpl<$Res, _$ActualFlowDtoImpl>
    implements _$$ActualFlowDtoImplCopyWith<$Res> {
  __$$ActualFlowDtoImplCopyWithImpl(
      _$ActualFlowDtoImpl _value, $Res Function(_$ActualFlowDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ActualFlowDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? flowId = null,
    Object? createdAt = null,
    Object? systemTime = null,
    Object? balanceBefore = null,
    Object? flowAmount = null,
    Object? balanceAfter = null,
    Object? currency = null,
    Object? createdBy = null,
    Object? currentDenominations = null,
  }) {
    return _then(_$ActualFlowDtoImpl(
      flowId: null == flowId
          ? _value.flowId
          : flowId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      systemTime: null == systemTime
          ? _value.systemTime
          : systemTime // ignore: cast_nullable_to_non_nullable
              as String,
      balanceBefore: null == balanceBefore
          ? _value.balanceBefore
          : balanceBefore // ignore: cast_nullable_to_non_nullable
              as double,
      flowAmount: null == flowAmount
          ? _value.flowAmount
          : flowAmount // ignore: cast_nullable_to_non_nullable
              as double,
      balanceAfter: null == balanceAfter
          ? _value.balanceAfter
          : balanceAfter // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as CurrencyInfoDto,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as CreatedByDto,
      currentDenominations: null == currentDenominations
          ? _value._currentDenominations
          : currentDenominations // ignore: cast_nullable_to_non_nullable
              as List<DenominationDetailDto>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ActualFlowDtoImpl extends _ActualFlowDto {
  const _$ActualFlowDtoImpl(
      {@JsonKey(name: 'flow_id') required this.flowId,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'system_time') required this.systemTime,
      @JsonKey(name: 'balance_before') required this.balanceBefore,
      @JsonKey(name: 'flow_amount') required this.flowAmount,
      @JsonKey(name: 'balance_after') required this.balanceAfter,
      @JsonKey(name: 'currency') required this.currency,
      @JsonKey(name: 'created_by') required this.createdBy,
      @JsonKey(name: 'current_denominations')
      final List<DenominationDetailDto> currentDenominations = const []})
      : _currentDenominations = currentDenominations,
        super._();

  factory _$ActualFlowDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActualFlowDtoImplFromJson(json);

  @override
  @JsonKey(name: 'flow_id')
  final String flowId;
  @override
  @JsonKey(name: 'created_at')
  final String createdAt;
  @override
  @JsonKey(name: 'system_time')
  final String systemTime;
  @override
  @JsonKey(name: 'balance_before')
  final double balanceBefore;
  @override
  @JsonKey(name: 'flow_amount')
  final double flowAmount;
  @override
  @JsonKey(name: 'balance_after')
  final double balanceAfter;
  @override
  @JsonKey(name: 'currency')
  final CurrencyInfoDto currency;
  @override
  @JsonKey(name: 'created_by')
  final CreatedByDto createdBy;
  final List<DenominationDetailDto> _currentDenominations;
  @override
  @JsonKey(name: 'current_denominations')
  List<DenominationDetailDto> get currentDenominations {
    if (_currentDenominations is EqualUnmodifiableListView)
      return _currentDenominations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_currentDenominations);
  }

  @override
  String toString() {
    return 'ActualFlowDto(flowId: $flowId, createdAt: $createdAt, systemTime: $systemTime, balanceBefore: $balanceBefore, flowAmount: $flowAmount, balanceAfter: $balanceAfter, currency: $currency, createdBy: $createdBy, currentDenominations: $currentDenominations)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActualFlowDtoImpl &&
            (identical(other.flowId, flowId) || other.flowId == flowId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.systemTime, systemTime) ||
                other.systemTime == systemTime) &&
            (identical(other.balanceBefore, balanceBefore) ||
                other.balanceBefore == balanceBefore) &&
            (identical(other.flowAmount, flowAmount) ||
                other.flowAmount == flowAmount) &&
            (identical(other.balanceAfter, balanceAfter) ||
                other.balanceAfter == balanceAfter) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            const DeepCollectionEquality()
                .equals(other._currentDenominations, _currentDenominations));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      flowId,
      createdAt,
      systemTime,
      balanceBefore,
      flowAmount,
      balanceAfter,
      currency,
      createdBy,
      const DeepCollectionEquality().hash(_currentDenominations));

  /// Create a copy of ActualFlowDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActualFlowDtoImplCopyWith<_$ActualFlowDtoImpl> get copyWith =>
      __$$ActualFlowDtoImplCopyWithImpl<_$ActualFlowDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActualFlowDtoImplToJson(
      this,
    );
  }
}

abstract class _ActualFlowDto extends ActualFlowDto {
  const factory _ActualFlowDto(
          {@JsonKey(name: 'flow_id') required final String flowId,
          @JsonKey(name: 'created_at') required final String createdAt,
          @JsonKey(name: 'system_time') required final String systemTime,
          @JsonKey(name: 'balance_before') required final double balanceBefore,
          @JsonKey(name: 'flow_amount') required final double flowAmount,
          @JsonKey(name: 'balance_after') required final double balanceAfter,
          @JsonKey(name: 'currency') required final CurrencyInfoDto currency,
          @JsonKey(name: 'created_by') required final CreatedByDto createdBy,
          @JsonKey(name: 'current_denominations')
          final List<DenominationDetailDto> currentDenominations}) =
      _$ActualFlowDtoImpl;
  const _ActualFlowDto._() : super._();

  factory _ActualFlowDto.fromJson(Map<String, dynamic> json) =
      _$ActualFlowDtoImpl.fromJson;

  @override
  @JsonKey(name: 'flow_id')
  String get flowId;
  @override
  @JsonKey(name: 'created_at')
  String get createdAt;
  @override
  @JsonKey(name: 'system_time')
  String get systemTime;
  @override
  @JsonKey(name: 'balance_before')
  double get balanceBefore;
  @override
  @JsonKey(name: 'flow_amount')
  double get flowAmount;
  @override
  @JsonKey(name: 'balance_after')
  double get balanceAfter;
  @override
  @JsonKey(name: 'currency')
  CurrencyInfoDto get currency;
  @override
  @JsonKey(name: 'created_by')
  CreatedByDto get createdBy;
  @override
  @JsonKey(name: 'current_denominations')
  List<DenominationDetailDto> get currentDenominations;

  /// Create a copy of ActualFlowDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActualFlowDtoImplCopyWith<_$ActualFlowDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PaginationInfoDto _$PaginationInfoDtoFromJson(Map<String, dynamic> json) {
  return _PaginationInfoDto.fromJson(json);
}

/// @nodoc
mixin _$PaginationInfoDto {
  @JsonKey(name: 'offset')
  int get offset => throw _privateConstructorUsedError;
  @JsonKey(name: 'limit')
  int get limit => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_journal_flows')
  int get totalJournalFlows => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_actual_flows')
  int get totalActualFlows => throw _privateConstructorUsedError;
  @JsonKey(name: 'has_more')
  bool get hasMore => throw _privateConstructorUsedError;

  /// Serializes this PaginationInfoDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaginationInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaginationInfoDtoCopyWith<PaginationInfoDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginationInfoDtoCopyWith<$Res> {
  factory $PaginationInfoDtoCopyWith(
          PaginationInfoDto value, $Res Function(PaginationInfoDto) then) =
      _$PaginationInfoDtoCopyWithImpl<$Res, PaginationInfoDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'offset') int offset,
      @JsonKey(name: 'limit') int limit,
      @JsonKey(name: 'total_journal_flows') int totalJournalFlows,
      @JsonKey(name: 'total_actual_flows') int totalActualFlows,
      @JsonKey(name: 'has_more') bool hasMore});
}

/// @nodoc
class _$PaginationInfoDtoCopyWithImpl<$Res, $Val extends PaginationInfoDto>
    implements $PaginationInfoDtoCopyWith<$Res> {
  _$PaginationInfoDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaginationInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? offset = null,
    Object? limit = null,
    Object? totalJournalFlows = null,
    Object? totalActualFlows = null,
    Object? hasMore = null,
  }) {
    return _then(_value.copyWith(
      offset: null == offset
          ? _value.offset
          : offset // ignore: cast_nullable_to_non_nullable
              as int,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
      totalJournalFlows: null == totalJournalFlows
          ? _value.totalJournalFlows
          : totalJournalFlows // ignore: cast_nullable_to_non_nullable
              as int,
      totalActualFlows: null == totalActualFlows
          ? _value.totalActualFlows
          : totalActualFlows // ignore: cast_nullable_to_non_nullable
              as int,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaginationInfoDtoImplCopyWith<$Res>
    implements $PaginationInfoDtoCopyWith<$Res> {
  factory _$$PaginationInfoDtoImplCopyWith(_$PaginationInfoDtoImpl value,
          $Res Function(_$PaginationInfoDtoImpl) then) =
      __$$PaginationInfoDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'offset') int offset,
      @JsonKey(name: 'limit') int limit,
      @JsonKey(name: 'total_journal_flows') int totalJournalFlows,
      @JsonKey(name: 'total_actual_flows') int totalActualFlows,
      @JsonKey(name: 'has_more') bool hasMore});
}

/// @nodoc
class __$$PaginationInfoDtoImplCopyWithImpl<$Res>
    extends _$PaginationInfoDtoCopyWithImpl<$Res, _$PaginationInfoDtoImpl>
    implements _$$PaginationInfoDtoImplCopyWith<$Res> {
  __$$PaginationInfoDtoImplCopyWithImpl(_$PaginationInfoDtoImpl _value,
      $Res Function(_$PaginationInfoDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of PaginationInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? offset = null,
    Object? limit = null,
    Object? totalJournalFlows = null,
    Object? totalActualFlows = null,
    Object? hasMore = null,
  }) {
    return _then(_$PaginationInfoDtoImpl(
      offset: null == offset
          ? _value.offset
          : offset // ignore: cast_nullable_to_non_nullable
              as int,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
      totalJournalFlows: null == totalJournalFlows
          ? _value.totalJournalFlows
          : totalJournalFlows // ignore: cast_nullable_to_non_nullable
              as int,
      totalActualFlows: null == totalActualFlows
          ? _value.totalActualFlows
          : totalActualFlows // ignore: cast_nullable_to_non_nullable
              as int,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaginationInfoDtoImpl extends _PaginationInfoDto {
  const _$PaginationInfoDtoImpl(
      {@JsonKey(name: 'offset') this.offset = 0,
      @JsonKey(name: 'limit') this.limit = 20,
      @JsonKey(name: 'total_journal_flows') this.totalJournalFlows = 0,
      @JsonKey(name: 'total_actual_flows') this.totalActualFlows = 0,
      @JsonKey(name: 'has_more') this.hasMore = false})
      : super._();

  factory _$PaginationInfoDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaginationInfoDtoImplFromJson(json);

  @override
  @JsonKey(name: 'offset')
  final int offset;
  @override
  @JsonKey(name: 'limit')
  final int limit;
  @override
  @JsonKey(name: 'total_journal_flows')
  final int totalJournalFlows;
  @override
  @JsonKey(name: 'total_actual_flows')
  final int totalActualFlows;
  @override
  @JsonKey(name: 'has_more')
  final bool hasMore;

  @override
  String toString() {
    return 'PaginationInfoDto(offset: $offset, limit: $limit, totalJournalFlows: $totalJournalFlows, totalActualFlows: $totalActualFlows, hasMore: $hasMore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaginationInfoDtoImpl &&
            (identical(other.offset, offset) || other.offset == offset) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.totalJournalFlows, totalJournalFlows) ||
                other.totalJournalFlows == totalJournalFlows) &&
            (identical(other.totalActualFlows, totalActualFlows) ||
                other.totalActualFlows == totalActualFlows) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, offset, limit, totalJournalFlows, totalActualFlows, hasMore);

  /// Create a copy of PaginationInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaginationInfoDtoImplCopyWith<_$PaginationInfoDtoImpl> get copyWith =>
      __$$PaginationInfoDtoImplCopyWithImpl<_$PaginationInfoDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaginationInfoDtoImplToJson(
      this,
    );
  }
}

abstract class _PaginationInfoDto extends PaginationInfoDto {
  const factory _PaginationInfoDto(
      {@JsonKey(name: 'offset') final int offset,
      @JsonKey(name: 'limit') final int limit,
      @JsonKey(name: 'total_journal_flows') final int totalJournalFlows,
      @JsonKey(name: 'total_actual_flows') final int totalActualFlows,
      @JsonKey(name: 'has_more') final bool hasMore}) = _$PaginationInfoDtoImpl;
  const _PaginationInfoDto._() : super._();

  factory _PaginationInfoDto.fromJson(Map<String, dynamic> json) =
      _$PaginationInfoDtoImpl.fromJson;

  @override
  @JsonKey(name: 'offset')
  int get offset;
  @override
  @JsonKey(name: 'limit')
  int get limit;
  @override
  @JsonKey(name: 'total_journal_flows')
  int get totalJournalFlows;
  @override
  @JsonKey(name: 'total_actual_flows')
  int get totalActualFlows;
  @override
  @JsonKey(name: 'has_more')
  bool get hasMore;

  /// Create a copy of PaginationInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaginationInfoDtoImplCopyWith<_$PaginationInfoDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StockFlowDataDto _$StockFlowDataDtoFromJson(Map<String, dynamic> json) {
  return _StockFlowDataDto.fromJson(json);
}

/// @nodoc
mixin _$StockFlowDataDto {
  @JsonKey(name: 'location_summary')
  LocationSummaryDto? get locationSummary => throw _privateConstructorUsedError;
  @JsonKey(name: 'actual_flows')
  List<ActualFlowDto> get actualFlows => throw _privateConstructorUsedError;

  /// Serializes this StockFlowDataDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StockFlowDataDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StockFlowDataDtoCopyWith<StockFlowDataDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StockFlowDataDtoCopyWith<$Res> {
  factory $StockFlowDataDtoCopyWith(
          StockFlowDataDto value, $Res Function(StockFlowDataDto) then) =
      _$StockFlowDataDtoCopyWithImpl<$Res, StockFlowDataDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'location_summary') LocationSummaryDto? locationSummary,
      @JsonKey(name: 'actual_flows') List<ActualFlowDto> actualFlows});

  $LocationSummaryDtoCopyWith<$Res>? get locationSummary;
}

/// @nodoc
class _$StockFlowDataDtoCopyWithImpl<$Res, $Val extends StockFlowDataDto>
    implements $StockFlowDataDtoCopyWith<$Res> {
  _$StockFlowDataDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StockFlowDataDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? locationSummary = freezed,
    Object? actualFlows = null,
  }) {
    return _then(_value.copyWith(
      locationSummary: freezed == locationSummary
          ? _value.locationSummary
          : locationSummary // ignore: cast_nullable_to_non_nullable
              as LocationSummaryDto?,
      actualFlows: null == actualFlows
          ? _value.actualFlows
          : actualFlows // ignore: cast_nullable_to_non_nullable
              as List<ActualFlowDto>,
    ) as $Val);
  }

  /// Create a copy of StockFlowDataDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LocationSummaryDtoCopyWith<$Res>? get locationSummary {
    if (_value.locationSummary == null) {
      return null;
    }

    return $LocationSummaryDtoCopyWith<$Res>(_value.locationSummary!, (value) {
      return _then(_value.copyWith(locationSummary: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$StockFlowDataDtoImplCopyWith<$Res>
    implements $StockFlowDataDtoCopyWith<$Res> {
  factory _$$StockFlowDataDtoImplCopyWith(_$StockFlowDataDtoImpl value,
          $Res Function(_$StockFlowDataDtoImpl) then) =
      __$$StockFlowDataDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'location_summary') LocationSummaryDto? locationSummary,
      @JsonKey(name: 'actual_flows') List<ActualFlowDto> actualFlows});

  @override
  $LocationSummaryDtoCopyWith<$Res>? get locationSummary;
}

/// @nodoc
class __$$StockFlowDataDtoImplCopyWithImpl<$Res>
    extends _$StockFlowDataDtoCopyWithImpl<$Res, _$StockFlowDataDtoImpl>
    implements _$$StockFlowDataDtoImplCopyWith<$Res> {
  __$$StockFlowDataDtoImplCopyWithImpl(_$StockFlowDataDtoImpl _value,
      $Res Function(_$StockFlowDataDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of StockFlowDataDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? locationSummary = freezed,
    Object? actualFlows = null,
  }) {
    return _then(_$StockFlowDataDtoImpl(
      locationSummary: freezed == locationSummary
          ? _value.locationSummary
          : locationSummary // ignore: cast_nullable_to_non_nullable
              as LocationSummaryDto?,
      actualFlows: null == actualFlows
          ? _value._actualFlows
          : actualFlows // ignore: cast_nullable_to_non_nullable
              as List<ActualFlowDto>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StockFlowDataDtoImpl extends _StockFlowDataDto {
  const _$StockFlowDataDtoImpl(
      {@JsonKey(name: 'location_summary') this.locationSummary,
      @JsonKey(name: 'actual_flows')
      final List<ActualFlowDto> actualFlows = const []})
      : _actualFlows = actualFlows,
        super._();

  factory _$StockFlowDataDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$StockFlowDataDtoImplFromJson(json);

  @override
  @JsonKey(name: 'location_summary')
  final LocationSummaryDto? locationSummary;
  final List<ActualFlowDto> _actualFlows;
  @override
  @JsonKey(name: 'actual_flows')
  List<ActualFlowDto> get actualFlows {
    if (_actualFlows is EqualUnmodifiableListView) return _actualFlows;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_actualFlows);
  }

  @override
  String toString() {
    return 'StockFlowDataDto(locationSummary: $locationSummary, actualFlows: $actualFlows)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StockFlowDataDtoImpl &&
            (identical(other.locationSummary, locationSummary) ||
                other.locationSummary == locationSummary) &&
            const DeepCollectionEquality()
                .equals(other._actualFlows, _actualFlows));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, locationSummary,
      const DeepCollectionEquality().hash(_actualFlows));

  /// Create a copy of StockFlowDataDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StockFlowDataDtoImplCopyWith<_$StockFlowDataDtoImpl> get copyWith =>
      __$$StockFlowDataDtoImplCopyWithImpl<_$StockFlowDataDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StockFlowDataDtoImplToJson(
      this,
    );
  }
}

abstract class _StockFlowDataDto extends StockFlowDataDto {
  const factory _StockFlowDataDto(
      {@JsonKey(name: 'location_summary')
      final LocationSummaryDto? locationSummary,
      @JsonKey(name: 'actual_flows')
      final List<ActualFlowDto> actualFlows}) = _$StockFlowDataDtoImpl;
  const _StockFlowDataDto._() : super._();

  factory _StockFlowDataDto.fromJson(Map<String, dynamic> json) =
      _$StockFlowDataDtoImpl.fromJson;

  @override
  @JsonKey(name: 'location_summary')
  LocationSummaryDto? get locationSummary;
  @override
  @JsonKey(name: 'actual_flows')
  List<ActualFlowDto> get actualFlows;

  /// Create a copy of StockFlowDataDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StockFlowDataDtoImplCopyWith<_$StockFlowDataDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StockFlowResponseDto _$StockFlowResponseDtoFromJson(Map<String, dynamic> json) {
  return _StockFlowResponseDto.fromJson(json);
}

/// @nodoc
mixin _$StockFlowResponseDto {
  @JsonKey(name: 'success')
  bool get success => throw _privateConstructorUsedError;
  @JsonKey(name: 'data')
  StockFlowDataDto? get data => throw _privateConstructorUsedError;
  @JsonKey(name: 'pagination')
  PaginationInfoDto? get pagination => throw _privateConstructorUsedError;

  /// Serializes this StockFlowResponseDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StockFlowResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StockFlowResponseDtoCopyWith<StockFlowResponseDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StockFlowResponseDtoCopyWith<$Res> {
  factory $StockFlowResponseDtoCopyWith(StockFlowResponseDto value,
          $Res Function(StockFlowResponseDto) then) =
      _$StockFlowResponseDtoCopyWithImpl<$Res, StockFlowResponseDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'success') bool success,
      @JsonKey(name: 'data') StockFlowDataDto? data,
      @JsonKey(name: 'pagination') PaginationInfoDto? pagination});

  $StockFlowDataDtoCopyWith<$Res>? get data;
  $PaginationInfoDtoCopyWith<$Res>? get pagination;
}

/// @nodoc
class _$StockFlowResponseDtoCopyWithImpl<$Res,
        $Val extends StockFlowResponseDto>
    implements $StockFlowResponseDtoCopyWith<$Res> {
  _$StockFlowResponseDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StockFlowResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? data = freezed,
    Object? pagination = freezed,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as StockFlowDataDto?,
      pagination: freezed == pagination
          ? _value.pagination
          : pagination // ignore: cast_nullable_to_non_nullable
              as PaginationInfoDto?,
    ) as $Val);
  }

  /// Create a copy of StockFlowResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StockFlowDataDtoCopyWith<$Res>? get data {
    if (_value.data == null) {
      return null;
    }

    return $StockFlowDataDtoCopyWith<$Res>(_value.data!, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }

  /// Create a copy of StockFlowResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PaginationInfoDtoCopyWith<$Res>? get pagination {
    if (_value.pagination == null) {
      return null;
    }

    return $PaginationInfoDtoCopyWith<$Res>(_value.pagination!, (value) {
      return _then(_value.copyWith(pagination: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$StockFlowResponseDtoImplCopyWith<$Res>
    implements $StockFlowResponseDtoCopyWith<$Res> {
  factory _$$StockFlowResponseDtoImplCopyWith(_$StockFlowResponseDtoImpl value,
          $Res Function(_$StockFlowResponseDtoImpl) then) =
      __$$StockFlowResponseDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'success') bool success,
      @JsonKey(name: 'data') StockFlowDataDto? data,
      @JsonKey(name: 'pagination') PaginationInfoDto? pagination});

  @override
  $StockFlowDataDtoCopyWith<$Res>? get data;
  @override
  $PaginationInfoDtoCopyWith<$Res>? get pagination;
}

/// @nodoc
class __$$StockFlowResponseDtoImplCopyWithImpl<$Res>
    extends _$StockFlowResponseDtoCopyWithImpl<$Res, _$StockFlowResponseDtoImpl>
    implements _$$StockFlowResponseDtoImplCopyWith<$Res> {
  __$$StockFlowResponseDtoImplCopyWithImpl(_$StockFlowResponseDtoImpl _value,
      $Res Function(_$StockFlowResponseDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of StockFlowResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? data = freezed,
    Object? pagination = freezed,
  }) {
    return _then(_$StockFlowResponseDtoImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as StockFlowDataDto?,
      pagination: freezed == pagination
          ? _value.pagination
          : pagination // ignore: cast_nullable_to_non_nullable
              as PaginationInfoDto?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StockFlowResponseDtoImpl extends _StockFlowResponseDto {
  const _$StockFlowResponseDtoImpl(
      {@JsonKey(name: 'success') this.success = false,
      @JsonKey(name: 'data') this.data,
      @JsonKey(name: 'pagination') this.pagination})
      : super._();

  factory _$StockFlowResponseDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$StockFlowResponseDtoImplFromJson(json);

  @override
  @JsonKey(name: 'success')
  final bool success;
  @override
  @JsonKey(name: 'data')
  final StockFlowDataDto? data;
  @override
  @JsonKey(name: 'pagination')
  final PaginationInfoDto? pagination;

  @override
  String toString() {
    return 'StockFlowResponseDto(success: $success, data: $data, pagination: $pagination)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StockFlowResponseDtoImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.pagination, pagination) ||
                other.pagination == pagination));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, success, data, pagination);

  /// Create a copy of StockFlowResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StockFlowResponseDtoImplCopyWith<_$StockFlowResponseDtoImpl>
      get copyWith =>
          __$$StockFlowResponseDtoImplCopyWithImpl<_$StockFlowResponseDtoImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StockFlowResponseDtoImplToJson(
      this,
    );
  }
}

abstract class _StockFlowResponseDto extends StockFlowResponseDto {
  const factory _StockFlowResponseDto(
          {@JsonKey(name: 'success') final bool success,
          @JsonKey(name: 'data') final StockFlowDataDto? data,
          @JsonKey(name: 'pagination') final PaginationInfoDto? pagination}) =
      _$StockFlowResponseDtoImpl;
  const _StockFlowResponseDto._() : super._();

  factory _StockFlowResponseDto.fromJson(Map<String, dynamic> json) =
      _$StockFlowResponseDtoImpl.fromJson;

  @override
  @JsonKey(name: 'success')
  bool get success;
  @override
  @JsonKey(name: 'data')
  StockFlowDataDto? get data;
  @override
  @JsonKey(name: 'pagination')
  PaginationInfoDto? get pagination;

  /// Create a copy of StockFlowResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StockFlowResponseDtoImplCopyWith<_$StockFlowResponseDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
