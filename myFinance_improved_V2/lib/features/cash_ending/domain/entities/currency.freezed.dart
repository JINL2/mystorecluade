// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'currency.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Currency {
  String get currencyId => throw _privateConstructorUsedError;
  String? get companyCurrencyId => throw _privateConstructorUsedError;
  String get currencyCode =>
      throw _privateConstructorUsedError; // e.g., 'KRW', 'USD', 'JPY'
  String get currencyName =>
      throw _privateConstructorUsedError; // e.g., 'Korean Won'
  String get symbol =>
      throw _privateConstructorUsedError; // e.g., '₩', '$', '¥'
  String? get flagEmoji =>
      throw _privateConstructorUsedError; // Grand Total calculation fields
  bool get isBaseCurrency => throw _privateConstructorUsedError;
  double get exchangeRateToBase => throw _privateConstructorUsedError;
  List<Denomination> get denominations => throw _privateConstructorUsedError;

  /// Create a copy of Currency
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CurrencyCopyWith<Currency> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CurrencyCopyWith<$Res> {
  factory $CurrencyCopyWith(Currency value, $Res Function(Currency) then) =
      _$CurrencyCopyWithImpl<$Res, Currency>;
  @useResult
  $Res call(
      {String currencyId,
      String? companyCurrencyId,
      String currencyCode,
      String currencyName,
      String symbol,
      String? flagEmoji,
      bool isBaseCurrency,
      double exchangeRateToBase,
      List<Denomination> denominations});
}

/// @nodoc
class _$CurrencyCopyWithImpl<$Res, $Val extends Currency>
    implements $CurrencyCopyWith<$Res> {
  _$CurrencyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Currency
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
              as List<Denomination>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CurrencyImplCopyWith<$Res>
    implements $CurrencyCopyWith<$Res> {
  factory _$$CurrencyImplCopyWith(
          _$CurrencyImpl value, $Res Function(_$CurrencyImpl) then) =
      __$$CurrencyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String currencyId,
      String? companyCurrencyId,
      String currencyCode,
      String currencyName,
      String symbol,
      String? flagEmoji,
      bool isBaseCurrency,
      double exchangeRateToBase,
      List<Denomination> denominations});
}

/// @nodoc
class __$$CurrencyImplCopyWithImpl<$Res>
    extends _$CurrencyCopyWithImpl<$Res, _$CurrencyImpl>
    implements _$$CurrencyImplCopyWith<$Res> {
  __$$CurrencyImplCopyWithImpl(
      _$CurrencyImpl _value, $Res Function(_$CurrencyImpl) _then)
      : super(_value, _then);

  /// Create a copy of Currency
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
    return _then(_$CurrencyImpl(
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
              as List<Denomination>,
    ));
  }
}

/// @nodoc

class _$CurrencyImpl extends _Currency {
  const _$CurrencyImpl(
      {required this.currencyId,
      this.companyCurrencyId,
      required this.currencyCode,
      required this.currencyName,
      required this.symbol,
      this.flagEmoji,
      this.isBaseCurrency = false,
      this.exchangeRateToBase = 1.0,
      final List<Denomination> denominations = const []})
      : _denominations = denominations,
        super._();

  @override
  final String currencyId;
  @override
  final String? companyCurrencyId;
  @override
  final String currencyCode;
// e.g., 'KRW', 'USD', 'JPY'
  @override
  final String currencyName;
// e.g., 'Korean Won'
  @override
  final String symbol;
// e.g., '₩', '$', '¥'
  @override
  final String? flagEmoji;
// Grand Total calculation fields
  @override
  @JsonKey()
  final bool isBaseCurrency;
  @override
  @JsonKey()
  final double exchangeRateToBase;
  final List<Denomination> _denominations;
  @override
  @JsonKey()
  List<Denomination> get denominations {
    if (_denominations is EqualUnmodifiableListView) return _denominations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_denominations);
  }

  @override
  String toString() {
    return 'Currency(currencyId: $currencyId, companyCurrencyId: $companyCurrencyId, currencyCode: $currencyCode, currencyName: $currencyName, symbol: $symbol, flagEmoji: $flagEmoji, isBaseCurrency: $isBaseCurrency, exchangeRateToBase: $exchangeRateToBase, denominations: $denominations)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CurrencyImpl &&
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

  /// Create a copy of Currency
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CurrencyImplCopyWith<_$CurrencyImpl> get copyWith =>
      __$$CurrencyImplCopyWithImpl<_$CurrencyImpl>(this, _$identity);
}

abstract class _Currency extends Currency {
  const factory _Currency(
      {required final String currencyId,
      final String? companyCurrencyId,
      required final String currencyCode,
      required final String currencyName,
      required final String symbol,
      final String? flagEmoji,
      final bool isBaseCurrency,
      final double exchangeRateToBase,
      final List<Denomination> denominations}) = _$CurrencyImpl;
  const _Currency._() : super._();

  @override
  String get currencyId;
  @override
  String? get companyCurrencyId;
  @override
  String get currencyCode; // e.g., 'KRW', 'USD', 'JPY'
  @override
  String get currencyName; // e.g., 'Korean Won'
  @override
  String get symbol; // e.g., '₩', '$', '¥'
  @override
  String? get flagEmoji; // Grand Total calculation fields
  @override
  bool get isBaseCurrency;
  @override
  double get exchangeRateToBase;
  @override
  List<Denomination> get denominations;

  /// Create a copy of Currency
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CurrencyImplCopyWith<_$CurrencyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
