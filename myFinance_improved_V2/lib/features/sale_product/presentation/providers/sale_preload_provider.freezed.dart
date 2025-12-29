// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sale_preload_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SalePreloadData {
  ExchangeRateData? get exchangeRateData => throw _privateConstructorUsedError;
  List<CashLocation> get cashLocations => throw _privateConstructorUsedError;

  /// Create a copy of SalePreloadData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SalePreloadDataCopyWith<SalePreloadData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SalePreloadDataCopyWith<$Res> {
  factory $SalePreloadDataCopyWith(
          SalePreloadData value, $Res Function(SalePreloadData) then) =
      _$SalePreloadDataCopyWithImpl<$Res, SalePreloadData>;
  @useResult
  $Res call(
      {ExchangeRateData? exchangeRateData, List<CashLocation> cashLocations});
}

/// @nodoc
class _$SalePreloadDataCopyWithImpl<$Res, $Val extends SalePreloadData>
    implements $SalePreloadDataCopyWith<$Res> {
  _$SalePreloadDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SalePreloadData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? exchangeRateData = freezed,
    Object? cashLocations = null,
  }) {
    return _then(_value.copyWith(
      exchangeRateData: freezed == exchangeRateData
          ? _value.exchangeRateData
          : exchangeRateData // ignore: cast_nullable_to_non_nullable
              as ExchangeRateData?,
      cashLocations: null == cashLocations
          ? _value.cashLocations
          : cashLocations // ignore: cast_nullable_to_non_nullable
              as List<CashLocation>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SalePreloadDataImplCopyWith<$Res>
    implements $SalePreloadDataCopyWith<$Res> {
  factory _$$SalePreloadDataImplCopyWith(_$SalePreloadDataImpl value,
          $Res Function(_$SalePreloadDataImpl) then) =
      __$$SalePreloadDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {ExchangeRateData? exchangeRateData, List<CashLocation> cashLocations});
}

/// @nodoc
class __$$SalePreloadDataImplCopyWithImpl<$Res>
    extends _$SalePreloadDataCopyWithImpl<$Res, _$SalePreloadDataImpl>
    implements _$$SalePreloadDataImplCopyWith<$Res> {
  __$$SalePreloadDataImplCopyWithImpl(
      _$SalePreloadDataImpl _value, $Res Function(_$SalePreloadDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of SalePreloadData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? exchangeRateData = freezed,
    Object? cashLocations = null,
  }) {
    return _then(_$SalePreloadDataImpl(
      exchangeRateData: freezed == exchangeRateData
          ? _value.exchangeRateData
          : exchangeRateData // ignore: cast_nullable_to_non_nullable
              as ExchangeRateData?,
      cashLocations: null == cashLocations
          ? _value._cashLocations
          : cashLocations // ignore: cast_nullable_to_non_nullable
              as List<CashLocation>,
    ));
  }
}

/// @nodoc

class _$SalePreloadDataImpl extends _SalePreloadData {
  const _$SalePreloadDataImpl(
      {this.exchangeRateData,
      final List<CashLocation> cashLocations = const []})
      : _cashLocations = cashLocations,
        super._();

  @override
  final ExchangeRateData? exchangeRateData;
  final List<CashLocation> _cashLocations;
  @override
  @JsonKey()
  List<CashLocation> get cashLocations {
    if (_cashLocations is EqualUnmodifiableListView) return _cashLocations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cashLocations);
  }

  @override
  String toString() {
    return 'SalePreloadData(exchangeRateData: $exchangeRateData, cashLocations: $cashLocations)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SalePreloadDataImpl &&
            (identical(other.exchangeRateData, exchangeRateData) ||
                other.exchangeRateData == exchangeRateData) &&
            const DeepCollectionEquality()
                .equals(other._cashLocations, _cashLocations));
  }

  @override
  int get hashCode => Object.hash(runtimeType, exchangeRateData,
      const DeepCollectionEquality().hash(_cashLocations));

  /// Create a copy of SalePreloadData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SalePreloadDataImplCopyWith<_$SalePreloadDataImpl> get copyWith =>
      __$$SalePreloadDataImplCopyWithImpl<_$SalePreloadDataImpl>(
          this, _$identity);
}

abstract class _SalePreloadData extends SalePreloadData {
  const factory _SalePreloadData(
      {final ExchangeRateData? exchangeRateData,
      final List<CashLocation> cashLocations}) = _$SalePreloadDataImpl;
  const _SalePreloadData._() : super._();

  @override
  ExchangeRateData? get exchangeRateData;
  @override
  List<CashLocation> get cashLocations;

  /// Create a copy of SalePreloadData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SalePreloadDataImplCopyWith<_$SalePreloadDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
