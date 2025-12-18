// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'base_currency.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BaseCurrency _$BaseCurrencyFromJson(Map<String, dynamic> json) {
  return _BaseCurrency.fromJson(json);
}

/// @nodoc
mixin _$BaseCurrency {
  @JsonKey(name: 'currency_id')
  String get currencyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'currency_code')
  String get currencyCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'currency_name')
  String get currencyName => throw _privateConstructorUsedError;
  @JsonKey(name: 'symbol')
  String get symbol => throw _privateConstructorUsedError;
  @JsonKey(name: 'flag_emoji')
  String? get flagEmoji => throw _privateConstructorUsedError;

  /// Serializes this BaseCurrency to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BaseCurrency
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BaseCurrencyCopyWith<BaseCurrency> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BaseCurrencyCopyWith<$Res> {
  factory $BaseCurrencyCopyWith(
          BaseCurrency value, $Res Function(BaseCurrency) then) =
      _$BaseCurrencyCopyWithImpl<$Res, BaseCurrency>;
  @useResult
  $Res call(
      {@JsonKey(name: 'currency_id') String currencyId,
      @JsonKey(name: 'currency_code') String currencyCode,
      @JsonKey(name: 'currency_name') String currencyName,
      @JsonKey(name: 'symbol') String symbol,
      @JsonKey(name: 'flag_emoji') String? flagEmoji});
}

/// @nodoc
class _$BaseCurrencyCopyWithImpl<$Res, $Val extends BaseCurrency>
    implements $BaseCurrencyCopyWith<$Res> {
  _$BaseCurrencyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BaseCurrency
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currencyId = null,
    Object? currencyCode = null,
    Object? currencyName = null,
    Object? symbol = null,
    Object? flagEmoji = freezed,
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
      flagEmoji: freezed == flagEmoji
          ? _value.flagEmoji
          : flagEmoji // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BaseCurrencyImplCopyWith<$Res>
    implements $BaseCurrencyCopyWith<$Res> {
  factory _$$BaseCurrencyImplCopyWith(
          _$BaseCurrencyImpl value, $Res Function(_$BaseCurrencyImpl) then) =
      __$$BaseCurrencyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'currency_id') String currencyId,
      @JsonKey(name: 'currency_code') String currencyCode,
      @JsonKey(name: 'currency_name') String currencyName,
      @JsonKey(name: 'symbol') String symbol,
      @JsonKey(name: 'flag_emoji') String? flagEmoji});
}

/// @nodoc
class __$$BaseCurrencyImplCopyWithImpl<$Res>
    extends _$BaseCurrencyCopyWithImpl<$Res, _$BaseCurrencyImpl>
    implements _$$BaseCurrencyImplCopyWith<$Res> {
  __$$BaseCurrencyImplCopyWithImpl(
      _$BaseCurrencyImpl _value, $Res Function(_$BaseCurrencyImpl) _then)
      : super(_value, _then);

  /// Create a copy of BaseCurrency
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currencyId = null,
    Object? currencyCode = null,
    Object? currencyName = null,
    Object? symbol = null,
    Object? flagEmoji = freezed,
  }) {
    return _then(_$BaseCurrencyImpl(
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
      flagEmoji: freezed == flagEmoji
          ? _value.flagEmoji
          : flagEmoji // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BaseCurrencyImpl extends _BaseCurrency {
  const _$BaseCurrencyImpl(
      {@JsonKey(name: 'currency_id') required this.currencyId,
      @JsonKey(name: 'currency_code') required this.currencyCode,
      @JsonKey(name: 'currency_name') required this.currencyName,
      @JsonKey(name: 'symbol') required this.symbol,
      @JsonKey(name: 'flag_emoji') this.flagEmoji})
      : super._();

  factory _$BaseCurrencyImpl.fromJson(Map<String, dynamic> json) =>
      _$$BaseCurrencyImplFromJson(json);

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
  @JsonKey(name: 'flag_emoji')
  final String? flagEmoji;

  @override
  String toString() {
    return 'BaseCurrency(currencyId: $currencyId, currencyCode: $currencyCode, currencyName: $currencyName, symbol: $symbol, flagEmoji: $flagEmoji)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BaseCurrencyImpl &&
            (identical(other.currencyId, currencyId) ||
                other.currencyId == currencyId) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.currencyName, currencyName) ||
                other.currencyName == currencyName) &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.flagEmoji, flagEmoji) ||
                other.flagEmoji == flagEmoji));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, currencyId, currencyCode, currencyName, symbol, flagEmoji);

  /// Create a copy of BaseCurrency
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BaseCurrencyImplCopyWith<_$BaseCurrencyImpl> get copyWith =>
      __$$BaseCurrencyImplCopyWithImpl<_$BaseCurrencyImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BaseCurrencyImplToJson(
      this,
    );
  }
}

abstract class _BaseCurrency extends BaseCurrency {
  const factory _BaseCurrency(
          {@JsonKey(name: 'currency_id') required final String currencyId,
          @JsonKey(name: 'currency_code') required final String currencyCode,
          @JsonKey(name: 'currency_name') required final String currencyName,
          @JsonKey(name: 'symbol') required final String symbol,
          @JsonKey(name: 'flag_emoji') final String? flagEmoji}) =
      _$BaseCurrencyImpl;
  const _BaseCurrency._() : super._();

  factory _BaseCurrency.fromJson(Map<String, dynamic> json) =
      _$BaseCurrencyImpl.fromJson;

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
  @JsonKey(name: 'flag_emoji')
  String? get flagEmoji;

  /// Create a copy of BaseCurrency
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BaseCurrencyImplCopyWith<_$BaseCurrencyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
