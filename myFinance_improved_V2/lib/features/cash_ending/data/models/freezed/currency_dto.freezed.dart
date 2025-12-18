// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'currency_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CurrencyDto _$CurrencyDtoFromJson(Map<String, dynamic> json) {
  return _CurrencyDto.fromJson(json);
}

/// @nodoc
mixin _$CurrencyDto {
  @JsonKey(name: 'currency_id')
  String get currencyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_currency_id')
  String? get companyCurrencyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'currency_code')
  String get currencyCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'currency_name')
  String get currencyName => throw _privateConstructorUsedError;
  @JsonKey(name: 'symbol')
  String get symbol => throw _privateConstructorUsedError;
  @JsonKey(name: 'flag_emoji')
  String? get flagEmoji =>
      throw _privateConstructorUsedError; // Grand Total calculation fields
  @JsonKey(name: 'is_base_currency')
  bool get isBaseCurrency => throw _privateConstructorUsedError;
  @JsonKey(name: 'exchange_rate_to_base')
  double get exchangeRateToBase =>
      throw _privateConstructorUsedError; // RPC returns JSONB array - custom deserializer
  @JsonKey(
      name: 'denominations',
      fromJson: _denominationsFromJson,
      toJson: _denominationsToJson)
  List<DenominationDto> get denominations => throw _privateConstructorUsedError;

  /// Serializes this CurrencyDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CurrencyDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CurrencyDtoCopyWith<CurrencyDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CurrencyDtoCopyWith<$Res> {
  factory $CurrencyDtoCopyWith(
          CurrencyDto value, $Res Function(CurrencyDto) then) =
      _$CurrencyDtoCopyWithImpl<$Res, CurrencyDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'currency_id') String currencyId,
      @JsonKey(name: 'company_currency_id') String? companyCurrencyId,
      @JsonKey(name: 'currency_code') String currencyCode,
      @JsonKey(name: 'currency_name') String currencyName,
      @JsonKey(name: 'symbol') String symbol,
      @JsonKey(name: 'flag_emoji') String? flagEmoji,
      @JsonKey(name: 'is_base_currency') bool isBaseCurrency,
      @JsonKey(name: 'exchange_rate_to_base') double exchangeRateToBase,
      @JsonKey(
          name: 'denominations',
          fromJson: _denominationsFromJson,
          toJson: _denominationsToJson)
      List<DenominationDto> denominations});
}

/// @nodoc
class _$CurrencyDtoCopyWithImpl<$Res, $Val extends CurrencyDto>
    implements $CurrencyDtoCopyWith<$Res> {
  _$CurrencyDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CurrencyDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currencyId = null,
    Object? companyCurrencyId = freezed,
    Object? currencyCode = null,
    Object? currencyName = null,
    Object? symbol = null,
    Object? flagEmoji = freezed,
    Object? isBaseCurrency = null,
    Object? exchangeRateToBase = null,
    Object? denominations = null,
  }) {
    return _then(_value.copyWith(
      currencyId: null == currencyId
          ? _value.currencyId
          : currencyId // ignore: cast_nullable_to_non_nullable
              as String,
      companyCurrencyId: freezed == companyCurrencyId
          ? _value.companyCurrencyId
          : companyCurrencyId // ignore: cast_nullable_to_non_nullable
              as String?,
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
      flagEmoji: freezed == flagEmoji
          ? _value.flagEmoji
          : flagEmoji // ignore: cast_nullable_to_non_nullable
              as String?,
      isBaseCurrency: null == isBaseCurrency
          ? _value.isBaseCurrency
          : isBaseCurrency // ignore: cast_nullable_to_non_nullable
              as bool,
      exchangeRateToBase: null == exchangeRateToBase
          ? _value.exchangeRateToBase
          : exchangeRateToBase // ignore: cast_nullable_to_non_nullable
              as double,
      denominations: null == denominations
          ? _value.denominations
          : denominations // ignore: cast_nullable_to_non_nullable
              as List<DenominationDto>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CurrencyDtoImplCopyWith<$Res>
    implements $CurrencyDtoCopyWith<$Res> {
  factory _$$CurrencyDtoImplCopyWith(
          _$CurrencyDtoImpl value, $Res Function(_$CurrencyDtoImpl) then) =
      __$$CurrencyDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'currency_id') String currencyId,
      @JsonKey(name: 'company_currency_id') String? companyCurrencyId,
      @JsonKey(name: 'currency_code') String currencyCode,
      @JsonKey(name: 'currency_name') String currencyName,
      @JsonKey(name: 'symbol') String symbol,
      @JsonKey(name: 'flag_emoji') String? flagEmoji,
      @JsonKey(name: 'is_base_currency') bool isBaseCurrency,
      @JsonKey(name: 'exchange_rate_to_base') double exchangeRateToBase,
      @JsonKey(
          name: 'denominations',
          fromJson: _denominationsFromJson,
          toJson: _denominationsToJson)
      List<DenominationDto> denominations});
}

/// @nodoc
class __$$CurrencyDtoImplCopyWithImpl<$Res>
    extends _$CurrencyDtoCopyWithImpl<$Res, _$CurrencyDtoImpl>
    implements _$$CurrencyDtoImplCopyWith<$Res> {
  __$$CurrencyDtoImplCopyWithImpl(
      _$CurrencyDtoImpl _value, $Res Function(_$CurrencyDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of CurrencyDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currencyId = null,
    Object? companyCurrencyId = freezed,
    Object? currencyCode = null,
    Object? currencyName = null,
    Object? symbol = null,
    Object? flagEmoji = freezed,
    Object? isBaseCurrency = null,
    Object? exchangeRateToBase = null,
    Object? denominations = null,
  }) {
    return _then(_$CurrencyDtoImpl(
      currencyId: null == currencyId
          ? _value.currencyId
          : currencyId // ignore: cast_nullable_to_non_nullable
              as String,
      companyCurrencyId: freezed == companyCurrencyId
          ? _value.companyCurrencyId
          : companyCurrencyId // ignore: cast_nullable_to_non_nullable
              as String?,
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
      flagEmoji: freezed == flagEmoji
          ? _value.flagEmoji
          : flagEmoji // ignore: cast_nullable_to_non_nullable
              as String?,
      isBaseCurrency: null == isBaseCurrency
          ? _value.isBaseCurrency
          : isBaseCurrency // ignore: cast_nullable_to_non_nullable
              as bool,
      exchangeRateToBase: null == exchangeRateToBase
          ? _value.exchangeRateToBase
          : exchangeRateToBase // ignore: cast_nullable_to_non_nullable
              as double,
      denominations: null == denominations
          ? _value._denominations
          : denominations // ignore: cast_nullable_to_non_nullable
              as List<DenominationDto>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CurrencyDtoImpl extends _CurrencyDto {
  const _$CurrencyDtoImpl(
      {@JsonKey(name: 'currency_id') required this.currencyId,
      @JsonKey(name: 'company_currency_id') this.companyCurrencyId,
      @JsonKey(name: 'currency_code') required this.currencyCode,
      @JsonKey(name: 'currency_name') required this.currencyName,
      @JsonKey(name: 'symbol') required this.symbol,
      @JsonKey(name: 'flag_emoji') this.flagEmoji,
      @JsonKey(name: 'is_base_currency') this.isBaseCurrency = false,
      @JsonKey(name: 'exchange_rate_to_base') this.exchangeRateToBase = 1.0,
      @JsonKey(
          name: 'denominations',
          fromJson: _denominationsFromJson,
          toJson: _denominationsToJson)
      final List<DenominationDto> denominations = const []})
      : _denominations = denominations,
        super._();

  factory _$CurrencyDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CurrencyDtoImplFromJson(json);

  @override
  @JsonKey(name: 'currency_id')
  final String currencyId;
  @override
  @JsonKey(name: 'company_currency_id')
  final String? companyCurrencyId;
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
  @JsonKey(name: 'flag_emoji')
  final String? flagEmoji;
// Grand Total calculation fields
  @override
  @JsonKey(name: 'is_base_currency')
  final bool isBaseCurrency;
  @override
  @JsonKey(name: 'exchange_rate_to_base')
  final double exchangeRateToBase;
// RPC returns JSONB array - custom deserializer
  final List<DenominationDto> _denominations;
// RPC returns JSONB array - custom deserializer
  @override
  @JsonKey(
      name: 'denominations',
      fromJson: _denominationsFromJson,
      toJson: _denominationsToJson)
  List<DenominationDto> get denominations {
    if (_denominations is EqualUnmodifiableListView) return _denominations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_denominations);
  }

  @override
  String toString() {
    return 'CurrencyDto(currencyId: $currencyId, companyCurrencyId: $companyCurrencyId, currencyCode: $currencyCode, currencyName: $currencyName, symbol: $symbol, flagEmoji: $flagEmoji, isBaseCurrency: $isBaseCurrency, exchangeRateToBase: $exchangeRateToBase, denominations: $denominations)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CurrencyDtoImpl &&
            (identical(other.currencyId, currencyId) ||
                other.currencyId == currencyId) &&
            (identical(other.companyCurrencyId, companyCurrencyId) ||
                other.companyCurrencyId == companyCurrencyId) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.currencyName, currencyName) ||
                other.currencyName == currencyName) &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.flagEmoji, flagEmoji) ||
                other.flagEmoji == flagEmoji) &&
            (identical(other.isBaseCurrency, isBaseCurrency) ||
                other.isBaseCurrency == isBaseCurrency) &&
            (identical(other.exchangeRateToBase, exchangeRateToBase) ||
                other.exchangeRateToBase == exchangeRateToBase) &&
            const DeepCollectionEquality()
                .equals(other._denominations, _denominations));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      currencyId,
      companyCurrencyId,
      currencyCode,
      currencyName,
      symbol,
      flagEmoji,
      isBaseCurrency,
      exchangeRateToBase,
      const DeepCollectionEquality().hash(_denominations));

  /// Create a copy of CurrencyDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CurrencyDtoImplCopyWith<_$CurrencyDtoImpl> get copyWith =>
      __$$CurrencyDtoImplCopyWithImpl<_$CurrencyDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CurrencyDtoImplToJson(
      this,
    );
  }
}

abstract class _CurrencyDto extends CurrencyDto {
  const factory _CurrencyDto(
      {@JsonKey(name: 'currency_id') required final String currencyId,
      @JsonKey(name: 'company_currency_id') final String? companyCurrencyId,
      @JsonKey(name: 'currency_code') required final String currencyCode,
      @JsonKey(name: 'currency_name') required final String currencyName,
      @JsonKey(name: 'symbol') required final String symbol,
      @JsonKey(name: 'flag_emoji') final String? flagEmoji,
      @JsonKey(name: 'is_base_currency') final bool isBaseCurrency,
      @JsonKey(name: 'exchange_rate_to_base') final double exchangeRateToBase,
      @JsonKey(
          name: 'denominations',
          fromJson: _denominationsFromJson,
          toJson: _denominationsToJson)
      final List<DenominationDto> denominations}) = _$CurrencyDtoImpl;
  const _CurrencyDto._() : super._();

  factory _CurrencyDto.fromJson(Map<String, dynamic> json) =
      _$CurrencyDtoImpl.fromJson;

  @override
  @JsonKey(name: 'currency_id')
  String get currencyId;
  @override
  @JsonKey(name: 'company_currency_id')
  String? get companyCurrencyId;
  @override
  @JsonKey(name: 'currency_code')
  String get currencyCode;
  @override
  @JsonKey(name: 'currency_name')
  String get currencyName;
  @override
  @JsonKey(name: 'symbol')
  String get symbol;
  @override
  @JsonKey(name: 'flag_emoji')
  String? get flagEmoji; // Grand Total calculation fields
  @override
  @JsonKey(name: 'is_base_currency')
  bool get isBaseCurrency;
  @override
  @JsonKey(name: 'exchange_rate_to_base')
  double
      get exchangeRateToBase; // RPC returns JSONB array - custom deserializer
  @override
  @JsonKey(
      name: 'denominations',
      fromJson: _denominationsFromJson,
      toJson: _denominationsToJson)
  List<DenominationDto> get denominations;

  /// Create a copy of CurrencyDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CurrencyDtoImplCopyWith<_$CurrencyDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
