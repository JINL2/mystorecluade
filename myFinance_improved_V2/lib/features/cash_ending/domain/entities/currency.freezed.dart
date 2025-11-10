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

Currency _$CurrencyFromJson(Map<String, dynamic> json) {
  return _Currency.fromJson(json);
}

/// @nodoc
mixin _$Currency {
  @JsonKey(name: 'currency_id')
  String get currencyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'currency_code')
  String get currencyCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'currency_name')
  String get currencyName => throw _privateConstructorUsedError;
  @JsonKey(name: 'symbol')
  String get symbol => throw _privateConstructorUsedError;
  List<Denomination> get denominations => throw _privateConstructorUsedError;

  /// Serializes this Currency to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

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
      {@JsonKey(name: 'currency_id') String currencyId,
      @JsonKey(name: 'currency_code') String currencyCode,
      @JsonKey(name: 'currency_name') String currencyName,
      @JsonKey(name: 'symbol') String symbol,
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
    Object? currencyCode = null,
    Object? currencyName = null,
    Object? symbol = null,
    Object? denominations = null,
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
      {@JsonKey(name: 'currency_id') String currencyId,
      @JsonKey(name: 'currency_code') String currencyCode,
      @JsonKey(name: 'currency_name') String currencyName,
      @JsonKey(name: 'symbol') String symbol,
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
    Object? currencyCode = null,
    Object? currencyName = null,
    Object? symbol = null,
    Object? denominations = null,
  }) {
    return _then(_$CurrencyImpl(
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
      denominations: null == denominations
          ? _value._denominations
          : denominations // ignore: cast_nullable_to_non_nullable
              as List<Denomination>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CurrencyImpl extends _Currency {
  const _$CurrencyImpl(
      {@JsonKey(name: 'currency_id') required this.currencyId,
      @JsonKey(name: 'currency_code') required this.currencyCode,
      @JsonKey(name: 'currency_name') required this.currencyName,
      @JsonKey(name: 'symbol') required this.symbol,
      final List<Denomination> denominations = const []})
      : _denominations = denominations,
        super._();

  factory _$CurrencyImpl.fromJson(Map<String, dynamic> json) =>
      _$$CurrencyImplFromJson(json);

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
    return 'Currency(currencyId: $currencyId, currencyCode: $currencyCode, currencyName: $currencyName, symbol: $symbol, denominations: $denominations)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CurrencyImpl &&
            (identical(other.currencyId, currencyId) ||
                other.currencyId == currencyId) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.currencyName, currencyName) ||
                other.currencyName == currencyName) &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            const DeepCollectionEquality()
                .equals(other._denominations, _denominations));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      currencyId,
      currencyCode,
      currencyName,
      symbol,
      const DeepCollectionEquality().hash(_denominations));

  /// Create a copy of Currency
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CurrencyImplCopyWith<_$CurrencyImpl> get copyWith =>
      __$$CurrencyImplCopyWithImpl<_$CurrencyImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CurrencyImplToJson(
      this,
    );
  }
}

abstract class _Currency extends Currency {
  const factory _Currency(
      {@JsonKey(name: 'currency_id') required final String currencyId,
      @JsonKey(name: 'currency_code') required final String currencyCode,
      @JsonKey(name: 'currency_name') required final String currencyName,
      @JsonKey(name: 'symbol') required final String symbol,
      final List<Denomination> denominations}) = _$CurrencyImpl;
  const _Currency._() : super._();

  factory _Currency.fromJson(Map<String, dynamic> json) =
      _$CurrencyImpl.fromJson;

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
  @override
  List<Denomination> get denominations;

  /// Create a copy of Currency
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CurrencyImplCopyWith<_$CurrencyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
