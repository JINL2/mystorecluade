// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'currency_type.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CurrencyType {
  String? get currencyId => throw _privateConstructorUsedError;
  String get currencyCode => throw _privateConstructorUsedError;
  String get currencyName => throw _privateConstructorUsedError;
  String get symbol => throw _privateConstructorUsedError;
  int get decimalPlaces => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

  /// Create a copy of CurrencyType
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CurrencyTypeCopyWith<CurrencyType> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CurrencyTypeCopyWith<$Res> {
  factory $CurrencyTypeCopyWith(
          CurrencyType value, $Res Function(CurrencyType) then) =
      _$CurrencyTypeCopyWithImpl<$Res, CurrencyType>;
  @useResult
  $Res call(
      {String? currencyId,
      String currencyCode,
      String currencyName,
      String symbol,
      int decimalPlaces,
      bool isActive});
}

/// @nodoc
class _$CurrencyTypeCopyWithImpl<$Res, $Val extends CurrencyType>
    implements $CurrencyTypeCopyWith<$Res> {
  _$CurrencyTypeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CurrencyType
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currencyId = freezed,
    Object? currencyCode = null,
    Object? currencyName = null,
    Object? symbol = null,
    Object? decimalPlaces = null,
    Object? isActive = null,
  }) {
    return _then(_value.copyWith(
      currencyId: freezed == currencyId
          ? _value.currencyId
          : currencyId // ignore: cast_nullable_to_non_nullable
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
      decimalPlaces: null == decimalPlaces
          ? _value.decimalPlaces
          : decimalPlaces // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CurrencyTypeImplCopyWith<$Res>
    implements $CurrencyTypeCopyWith<$Res> {
  factory _$$CurrencyTypeImplCopyWith(
          _$CurrencyTypeImpl value, $Res Function(_$CurrencyTypeImpl) then) =
      __$$CurrencyTypeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? currencyId,
      String currencyCode,
      String currencyName,
      String symbol,
      int decimalPlaces,
      bool isActive});
}

/// @nodoc
class __$$CurrencyTypeImplCopyWithImpl<$Res>
    extends _$CurrencyTypeCopyWithImpl<$Res, _$CurrencyTypeImpl>
    implements _$$CurrencyTypeImplCopyWith<$Res> {
  __$$CurrencyTypeImplCopyWithImpl(
      _$CurrencyTypeImpl _value, $Res Function(_$CurrencyTypeImpl) _then)
      : super(_value, _then);

  /// Create a copy of CurrencyType
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currencyId = freezed,
    Object? currencyCode = null,
    Object? currencyName = null,
    Object? symbol = null,
    Object? decimalPlaces = null,
    Object? isActive = null,
  }) {
    return _then(_$CurrencyTypeImpl(
      currencyId: freezed == currencyId
          ? _value.currencyId
          : currencyId // ignore: cast_nullable_to_non_nullable
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
      decimalPlaces: null == decimalPlaces
          ? _value.decimalPlaces
          : decimalPlaces // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$CurrencyTypeImpl implements _CurrencyType {
  const _$CurrencyTypeImpl(
      {this.currencyId,
      required this.currencyCode,
      required this.currencyName,
      required this.symbol,
      this.decimalPlaces = 2,
      this.isActive = true});

  @override
  final String? currencyId;
  @override
  final String currencyCode;
  @override
  final String currencyName;
  @override
  final String symbol;
  @override
  @JsonKey()
  final int decimalPlaces;
  @override
  @JsonKey()
  final bool isActive;

  @override
  String toString() {
    return 'CurrencyType(currencyId: $currencyId, currencyCode: $currencyCode, currencyName: $currencyName, symbol: $symbol, decimalPlaces: $decimalPlaces, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CurrencyTypeImpl &&
            (identical(other.currencyId, currencyId) ||
                other.currencyId == currencyId) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.currencyName, currencyName) ||
                other.currencyName == currencyName) &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.decimalPlaces, decimalPlaces) ||
                other.decimalPlaces == decimalPlaces) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @override
  int get hashCode => Object.hash(runtimeType, currencyId, currencyCode,
      currencyName, symbol, decimalPlaces, isActive);

  /// Create a copy of CurrencyType
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CurrencyTypeImplCopyWith<_$CurrencyTypeImpl> get copyWith =>
      __$$CurrencyTypeImplCopyWithImpl<_$CurrencyTypeImpl>(this, _$identity);
}

abstract class _CurrencyType implements CurrencyType {
  const factory _CurrencyType(
      {final String? currencyId,
      required final String currencyCode,
      required final String currencyName,
      required final String symbol,
      final int decimalPlaces,
      final bool isActive}) = _$CurrencyTypeImpl;

  @override
  String? get currencyId;
  @override
  String get currencyCode;
  @override
  String get currencyName;
  @override
  String get symbol;
  @override
  int get decimalPlaces;
  @override
  bool get isActive;

  /// Create a copy of CurrencyType
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CurrencyTypeImplCopyWith<_$CurrencyTypeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
