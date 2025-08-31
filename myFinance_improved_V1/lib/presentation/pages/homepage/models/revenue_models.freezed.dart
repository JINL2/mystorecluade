// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'revenue_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RevenueData _$RevenueDataFromJson(Map<String, dynamic> json) {
  return _RevenueData.fromJson(json);
}

/// @nodoc
mixin _$RevenueData {
  double get amount => throw _privateConstructorUsedError;
  String get currencySymbol => throw _privateConstructorUsedError;
  String get period => throw _privateConstructorUsedError;
  double get comparisonAmount => throw _privateConstructorUsedError;
  String get comparisonPeriod => throw _privateConstructorUsedError;

  /// Serializes this RevenueData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RevenueData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RevenueDataCopyWith<RevenueData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RevenueDataCopyWith<$Res> {
  factory $RevenueDataCopyWith(
          RevenueData value, $Res Function(RevenueData) then) =
      _$RevenueDataCopyWithImpl<$Res, RevenueData>;
  @useResult
  $Res call(
      {double amount,
      String currencySymbol,
      String period,
      double comparisonAmount,
      String comparisonPeriod});
}

/// @nodoc
class _$RevenueDataCopyWithImpl<$Res, $Val extends RevenueData>
    implements $RevenueDataCopyWith<$Res> {
  _$RevenueDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RevenueData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? amount = null,
    Object? currencySymbol = null,
    Object? period = null,
    Object? comparisonAmount = null,
    Object? comparisonPeriod = null,
  }) {
    return _then(_value.copyWith(
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      currencySymbol: null == currencySymbol
          ? _value.currencySymbol
          : currencySymbol // ignore: cast_nullable_to_non_nullable
              as String,
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as String,
      comparisonAmount: null == comparisonAmount
          ? _value.comparisonAmount
          : comparisonAmount // ignore: cast_nullable_to_non_nullable
              as double,
      comparisonPeriod: null == comparisonPeriod
          ? _value.comparisonPeriod
          : comparisonPeriod // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RevenueDataImplCopyWith<$Res>
    implements $RevenueDataCopyWith<$Res> {
  factory _$$RevenueDataImplCopyWith(
          _$RevenueDataImpl value, $Res Function(_$RevenueDataImpl) then) =
      __$$RevenueDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double amount,
      String currencySymbol,
      String period,
      double comparisonAmount,
      String comparisonPeriod});
}

/// @nodoc
class __$$RevenueDataImplCopyWithImpl<$Res>
    extends _$RevenueDataCopyWithImpl<$Res, _$RevenueDataImpl>
    implements _$$RevenueDataImplCopyWith<$Res> {
  __$$RevenueDataImplCopyWithImpl(
      _$RevenueDataImpl _value, $Res Function(_$RevenueDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of RevenueData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? amount = null,
    Object? currencySymbol = null,
    Object? period = null,
    Object? comparisonAmount = null,
    Object? comparisonPeriod = null,
  }) {
    return _then(_$RevenueDataImpl(
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      currencySymbol: null == currencySymbol
          ? _value.currencySymbol
          : currencySymbol // ignore: cast_nullable_to_non_nullable
              as String,
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as String,
      comparisonAmount: null == comparisonAmount
          ? _value.comparisonAmount
          : comparisonAmount // ignore: cast_nullable_to_non_nullable
              as double,
      comparisonPeriod: null == comparisonPeriod
          ? _value.comparisonPeriod
          : comparisonPeriod // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RevenueDataImpl implements _RevenueData {
  const _$RevenueDataImpl(
      {this.amount = 0.0,
      this.currencySymbol = 'USD',
      this.period = 'Today',
      this.comparisonAmount = 0.0,
      this.comparisonPeriod = ''});

  factory _$RevenueDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$RevenueDataImplFromJson(json);

  @override
  @JsonKey()
  final double amount;
  @override
  @JsonKey()
  final String currencySymbol;
  @override
  @JsonKey()
  final String period;
  @override
  @JsonKey()
  final double comparisonAmount;
  @override
  @JsonKey()
  final String comparisonPeriod;

  @override
  String toString() {
    return 'RevenueData(amount: $amount, currencySymbol: $currencySymbol, period: $period, comparisonAmount: $comparisonAmount, comparisonPeriod: $comparisonPeriod)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RevenueDataImpl &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currencySymbol, currencySymbol) ||
                other.currencySymbol == currencySymbol) &&
            (identical(other.period, period) || other.period == period) &&
            (identical(other.comparisonAmount, comparisonAmount) ||
                other.comparisonAmount == comparisonAmount) &&
            (identical(other.comparisonPeriod, comparisonPeriod) ||
                other.comparisonPeriod == comparisonPeriod));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, amount, currencySymbol, period,
      comparisonAmount, comparisonPeriod);

  /// Create a copy of RevenueData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RevenueDataImplCopyWith<_$RevenueDataImpl> get copyWith =>
      __$$RevenueDataImplCopyWithImpl<_$RevenueDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RevenueDataImplToJson(
      this,
    );
  }
}

abstract class _RevenueData implements RevenueData {
  const factory _RevenueData(
      {final double amount,
      final String currencySymbol,
      final String period,
      final double comparisonAmount,
      final String comparisonPeriod}) = _$RevenueDataImpl;

  factory _RevenueData.fromJson(Map<String, dynamic> json) =
      _$RevenueDataImpl.fromJson;

  @override
  double get amount;
  @override
  String get currencySymbol;
  @override
  String get period;
  @override
  double get comparisonAmount;
  @override
  String get comparisonPeriod;

  /// Create a copy of RevenueData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RevenueDataImplCopyWith<_$RevenueDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RevenueResponse _$RevenueResponseFromJson(Map<String, dynamic> json) {
  return _RevenueResponse.fromJson(json);
}

/// @nodoc
mixin _$RevenueResponse {
  double get revenue => throw _privateConstructorUsedError;
  String get currency_symbol => throw _privateConstructorUsedError;
  String get period => throw _privateConstructorUsedError;
  double get comparison_revenue => throw _privateConstructorUsedError;
  String get comparison_period => throw _privateConstructorUsedError;

  /// Serializes this RevenueResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RevenueResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RevenueResponseCopyWith<RevenueResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RevenueResponseCopyWith<$Res> {
  factory $RevenueResponseCopyWith(
          RevenueResponse value, $Res Function(RevenueResponse) then) =
      _$RevenueResponseCopyWithImpl<$Res, RevenueResponse>;
  @useResult
  $Res call(
      {double revenue,
      String currency_symbol,
      String period,
      double comparison_revenue,
      String comparison_period});
}

/// @nodoc
class _$RevenueResponseCopyWithImpl<$Res, $Val extends RevenueResponse>
    implements $RevenueResponseCopyWith<$Res> {
  _$RevenueResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RevenueResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? revenue = null,
    Object? currency_symbol = null,
    Object? period = null,
    Object? comparison_revenue = null,
    Object? comparison_period = null,
  }) {
    return _then(_value.copyWith(
      revenue: null == revenue
          ? _value.revenue
          : revenue // ignore: cast_nullable_to_non_nullable
              as double,
      currency_symbol: null == currency_symbol
          ? _value.currency_symbol
          : currency_symbol // ignore: cast_nullable_to_non_nullable
              as String,
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as String,
      comparison_revenue: null == comparison_revenue
          ? _value.comparison_revenue
          : comparison_revenue // ignore: cast_nullable_to_non_nullable
              as double,
      comparison_period: null == comparison_period
          ? _value.comparison_period
          : comparison_period // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RevenueResponseImplCopyWith<$Res>
    implements $RevenueResponseCopyWith<$Res> {
  factory _$$RevenueResponseImplCopyWith(_$RevenueResponseImpl value,
          $Res Function(_$RevenueResponseImpl) then) =
      __$$RevenueResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double revenue,
      String currency_symbol,
      String period,
      double comparison_revenue,
      String comparison_period});
}

/// @nodoc
class __$$RevenueResponseImplCopyWithImpl<$Res>
    extends _$RevenueResponseCopyWithImpl<$Res, _$RevenueResponseImpl>
    implements _$$RevenueResponseImplCopyWith<$Res> {
  __$$RevenueResponseImplCopyWithImpl(
      _$RevenueResponseImpl _value, $Res Function(_$RevenueResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of RevenueResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? revenue = null,
    Object? currency_symbol = null,
    Object? period = null,
    Object? comparison_revenue = null,
    Object? comparison_period = null,
  }) {
    return _then(_$RevenueResponseImpl(
      revenue: null == revenue
          ? _value.revenue
          : revenue // ignore: cast_nullable_to_non_nullable
              as double,
      currency_symbol: null == currency_symbol
          ? _value.currency_symbol
          : currency_symbol // ignore: cast_nullable_to_non_nullable
              as String,
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as String,
      comparison_revenue: null == comparison_revenue
          ? _value.comparison_revenue
          : comparison_revenue // ignore: cast_nullable_to_non_nullable
              as double,
      comparison_period: null == comparison_period
          ? _value.comparison_period
          : comparison_period // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RevenueResponseImpl implements _RevenueResponse {
  const _$RevenueResponseImpl(
      {this.revenue = 0.0,
      this.currency_symbol = 'USD',
      this.period = 'Today',
      this.comparison_revenue = 0.0,
      this.comparison_period = ''});

  factory _$RevenueResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$RevenueResponseImplFromJson(json);

  @override
  @JsonKey()
  final double revenue;
  @override
  @JsonKey()
  final String currency_symbol;
  @override
  @JsonKey()
  final String period;
  @override
  @JsonKey()
  final double comparison_revenue;
  @override
  @JsonKey()
  final String comparison_period;

  @override
  String toString() {
    return 'RevenueResponse(revenue: $revenue, currency_symbol: $currency_symbol, period: $period, comparison_revenue: $comparison_revenue, comparison_period: $comparison_period)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RevenueResponseImpl &&
            (identical(other.revenue, revenue) || other.revenue == revenue) &&
            (identical(other.currency_symbol, currency_symbol) ||
                other.currency_symbol == currency_symbol) &&
            (identical(other.period, period) || other.period == period) &&
            (identical(other.comparison_revenue, comparison_revenue) ||
                other.comparison_revenue == comparison_revenue) &&
            (identical(other.comparison_period, comparison_period) ||
                other.comparison_period == comparison_period));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, revenue, currency_symbol, period,
      comparison_revenue, comparison_period);

  /// Create a copy of RevenueResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RevenueResponseImplCopyWith<_$RevenueResponseImpl> get copyWith =>
      __$$RevenueResponseImplCopyWithImpl<_$RevenueResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RevenueResponseImplToJson(
      this,
    );
  }
}

abstract class _RevenueResponse implements RevenueResponse {
  const factory _RevenueResponse(
      {final double revenue,
      final String currency_symbol,
      final String period,
      final double comparison_revenue,
      final String comparison_period}) = _$RevenueResponseImpl;

  factory _RevenueResponse.fromJson(Map<String, dynamic> json) =
      _$RevenueResponseImpl.fromJson;

  @override
  double get revenue;
  @override
  String get currency_symbol;
  @override
  String get period;
  @override
  double get comparison_revenue;
  @override
  String get comparison_period;

  /// Create a copy of RevenueResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RevenueResponseImplCopyWith<_$RevenueResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
