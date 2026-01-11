// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sales_dashboard.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MonthlyMetrics {
  num get revenue => throw _privateConstructorUsedError;
  num get margin => throw _privateConstructorUsedError;
  num get marginRate => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;

  /// Create a copy of MonthlyMetrics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MonthlyMetricsCopyWith<MonthlyMetrics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MonthlyMetricsCopyWith<$Res> {
  factory $MonthlyMetricsCopyWith(
          MonthlyMetrics value, $Res Function(MonthlyMetrics) then) =
      _$MonthlyMetricsCopyWithImpl<$Res, MonthlyMetrics>;
  @useResult
  $Res call({num revenue, num margin, num marginRate, int quantity});
}

/// @nodoc
class _$MonthlyMetricsCopyWithImpl<$Res, $Val extends MonthlyMetrics>
    implements $MonthlyMetricsCopyWith<$Res> {
  _$MonthlyMetricsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MonthlyMetrics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? revenue = null,
    Object? margin = null,
    Object? marginRate = null,
    Object? quantity = null,
  }) {
    return _then(_value.copyWith(
      revenue: null == revenue
          ? _value.revenue
          : revenue // ignore: cast_nullable_to_non_nullable
              as num,
      margin: null == margin
          ? _value.margin
          : margin // ignore: cast_nullable_to_non_nullable
              as num,
      marginRate: null == marginRate
          ? _value.marginRate
          : marginRate // ignore: cast_nullable_to_non_nullable
              as num,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MonthlyMetricsImplCopyWith<$Res>
    implements $MonthlyMetricsCopyWith<$Res> {
  factory _$$MonthlyMetricsImplCopyWith(_$MonthlyMetricsImpl value,
          $Res Function(_$MonthlyMetricsImpl) then) =
      __$$MonthlyMetricsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({num revenue, num margin, num marginRate, int quantity});
}

/// @nodoc
class __$$MonthlyMetricsImplCopyWithImpl<$Res>
    extends _$MonthlyMetricsCopyWithImpl<$Res, _$MonthlyMetricsImpl>
    implements _$$MonthlyMetricsImplCopyWith<$Res> {
  __$$MonthlyMetricsImplCopyWithImpl(
      _$MonthlyMetricsImpl _value, $Res Function(_$MonthlyMetricsImpl) _then)
      : super(_value, _then);

  /// Create a copy of MonthlyMetrics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? revenue = null,
    Object? margin = null,
    Object? marginRate = null,
    Object? quantity = null,
  }) {
    return _then(_$MonthlyMetricsImpl(
      revenue: null == revenue
          ? _value.revenue
          : revenue // ignore: cast_nullable_to_non_nullable
              as num,
      margin: null == margin
          ? _value.margin
          : margin // ignore: cast_nullable_to_non_nullable
              as num,
      marginRate: null == marginRate
          ? _value.marginRate
          : marginRate // ignore: cast_nullable_to_non_nullable
              as num,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$MonthlyMetricsImpl implements _MonthlyMetrics {
  const _$MonthlyMetricsImpl(
      {required this.revenue,
      required this.margin,
      required this.marginRate,
      required this.quantity});

  @override
  final num revenue;
  @override
  final num margin;
  @override
  final num marginRate;
  @override
  final int quantity;

  @override
  String toString() {
    return 'MonthlyMetrics(revenue: $revenue, margin: $margin, marginRate: $marginRate, quantity: $quantity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MonthlyMetricsImpl &&
            (identical(other.revenue, revenue) || other.revenue == revenue) &&
            (identical(other.margin, margin) || other.margin == margin) &&
            (identical(other.marginRate, marginRate) ||
                other.marginRate == marginRate) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, revenue, margin, marginRate, quantity);

  /// Create a copy of MonthlyMetrics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MonthlyMetricsImplCopyWith<_$MonthlyMetricsImpl> get copyWith =>
      __$$MonthlyMetricsImplCopyWithImpl<_$MonthlyMetricsImpl>(
          this, _$identity);
}

abstract class _MonthlyMetrics implements MonthlyMetrics {
  const factory _MonthlyMetrics(
      {required final num revenue,
      required final num margin,
      required final num marginRate,
      required final int quantity}) = _$MonthlyMetricsImpl;

  @override
  num get revenue;
  @override
  num get margin;
  @override
  num get marginRate;
  @override
  int get quantity;

  /// Create a copy of MonthlyMetrics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MonthlyMetricsImplCopyWith<_$MonthlyMetricsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$GrowthMetrics {
  num get revenuePct => throw _privateConstructorUsedError;
  num get marginPct => throw _privateConstructorUsedError;
  num get quantityPct => throw _privateConstructorUsedError;

  /// Create a copy of GrowthMetrics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GrowthMetricsCopyWith<GrowthMetrics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GrowthMetricsCopyWith<$Res> {
  factory $GrowthMetricsCopyWith(
          GrowthMetrics value, $Res Function(GrowthMetrics) then) =
      _$GrowthMetricsCopyWithImpl<$Res, GrowthMetrics>;
  @useResult
  $Res call({num revenuePct, num marginPct, num quantityPct});
}

/// @nodoc
class _$GrowthMetricsCopyWithImpl<$Res, $Val extends GrowthMetrics>
    implements $GrowthMetricsCopyWith<$Res> {
  _$GrowthMetricsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GrowthMetrics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? revenuePct = null,
    Object? marginPct = null,
    Object? quantityPct = null,
  }) {
    return _then(_value.copyWith(
      revenuePct: null == revenuePct
          ? _value.revenuePct
          : revenuePct // ignore: cast_nullable_to_non_nullable
              as num,
      marginPct: null == marginPct
          ? _value.marginPct
          : marginPct // ignore: cast_nullable_to_non_nullable
              as num,
      quantityPct: null == quantityPct
          ? _value.quantityPct
          : quantityPct // ignore: cast_nullable_to_non_nullable
              as num,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GrowthMetricsImplCopyWith<$Res>
    implements $GrowthMetricsCopyWith<$Res> {
  factory _$$GrowthMetricsImplCopyWith(
          _$GrowthMetricsImpl value, $Res Function(_$GrowthMetricsImpl) then) =
      __$$GrowthMetricsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({num revenuePct, num marginPct, num quantityPct});
}

/// @nodoc
class __$$GrowthMetricsImplCopyWithImpl<$Res>
    extends _$GrowthMetricsCopyWithImpl<$Res, _$GrowthMetricsImpl>
    implements _$$GrowthMetricsImplCopyWith<$Res> {
  __$$GrowthMetricsImplCopyWithImpl(
      _$GrowthMetricsImpl _value, $Res Function(_$GrowthMetricsImpl) _then)
      : super(_value, _then);

  /// Create a copy of GrowthMetrics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? revenuePct = null,
    Object? marginPct = null,
    Object? quantityPct = null,
  }) {
    return _then(_$GrowthMetricsImpl(
      revenuePct: null == revenuePct
          ? _value.revenuePct
          : revenuePct // ignore: cast_nullable_to_non_nullable
              as num,
      marginPct: null == marginPct
          ? _value.marginPct
          : marginPct // ignore: cast_nullable_to_non_nullable
              as num,
      quantityPct: null == quantityPct
          ? _value.quantityPct
          : quantityPct // ignore: cast_nullable_to_non_nullable
              as num,
    ));
  }
}

/// @nodoc

class _$GrowthMetricsImpl implements _GrowthMetrics {
  const _$GrowthMetricsImpl(
      {required this.revenuePct,
      required this.marginPct,
      required this.quantityPct});

  @override
  final num revenuePct;
  @override
  final num marginPct;
  @override
  final num quantityPct;

  @override
  String toString() {
    return 'GrowthMetrics(revenuePct: $revenuePct, marginPct: $marginPct, quantityPct: $quantityPct)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GrowthMetricsImpl &&
            (identical(other.revenuePct, revenuePct) ||
                other.revenuePct == revenuePct) &&
            (identical(other.marginPct, marginPct) ||
                other.marginPct == marginPct) &&
            (identical(other.quantityPct, quantityPct) ||
                other.quantityPct == quantityPct));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, revenuePct, marginPct, quantityPct);

  /// Create a copy of GrowthMetrics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GrowthMetricsImplCopyWith<_$GrowthMetricsImpl> get copyWith =>
      __$$GrowthMetricsImplCopyWithImpl<_$GrowthMetricsImpl>(this, _$identity);
}

abstract class _GrowthMetrics implements GrowthMetrics {
  const factory _GrowthMetrics(
      {required final num revenuePct,
      required final num marginPct,
      required final num quantityPct}) = _$GrowthMetricsImpl;

  @override
  num get revenuePct;
  @override
  num get marginPct;
  @override
  num get quantityPct;

  /// Create a copy of GrowthMetrics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GrowthMetricsImplCopyWith<_$GrowthMetricsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SalesDashboard {
  MonthlyMetrics get thisMonth => throw _privateConstructorUsedError;
  MonthlyMetrics get lastMonth => throw _privateConstructorUsedError;
  GrowthMetrics get growth => throw _privateConstructorUsedError;

  /// Create a copy of SalesDashboard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SalesDashboardCopyWith<SalesDashboard> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SalesDashboardCopyWith<$Res> {
  factory $SalesDashboardCopyWith(
          SalesDashboard value, $Res Function(SalesDashboard) then) =
      _$SalesDashboardCopyWithImpl<$Res, SalesDashboard>;
  @useResult
  $Res call(
      {MonthlyMetrics thisMonth,
      MonthlyMetrics lastMonth,
      GrowthMetrics growth});

  $MonthlyMetricsCopyWith<$Res> get thisMonth;
  $MonthlyMetricsCopyWith<$Res> get lastMonth;
  $GrowthMetricsCopyWith<$Res> get growth;
}

/// @nodoc
class _$SalesDashboardCopyWithImpl<$Res, $Val extends SalesDashboard>
    implements $SalesDashboardCopyWith<$Res> {
  _$SalesDashboardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SalesDashboard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? thisMonth = null,
    Object? lastMonth = null,
    Object? growth = null,
  }) {
    return _then(_value.copyWith(
      thisMonth: null == thisMonth
          ? _value.thisMonth
          : thisMonth // ignore: cast_nullable_to_non_nullable
              as MonthlyMetrics,
      lastMonth: null == lastMonth
          ? _value.lastMonth
          : lastMonth // ignore: cast_nullable_to_non_nullable
              as MonthlyMetrics,
      growth: null == growth
          ? _value.growth
          : growth // ignore: cast_nullable_to_non_nullable
              as GrowthMetrics,
    ) as $Val);
  }

  /// Create a copy of SalesDashboard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MonthlyMetricsCopyWith<$Res> get thisMonth {
    return $MonthlyMetricsCopyWith<$Res>(_value.thisMonth, (value) {
      return _then(_value.copyWith(thisMonth: value) as $Val);
    });
  }

  /// Create a copy of SalesDashboard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MonthlyMetricsCopyWith<$Res> get lastMonth {
    return $MonthlyMetricsCopyWith<$Res>(_value.lastMonth, (value) {
      return _then(_value.copyWith(lastMonth: value) as $Val);
    });
  }

  /// Create a copy of SalesDashboard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GrowthMetricsCopyWith<$Res> get growth {
    return $GrowthMetricsCopyWith<$Res>(_value.growth, (value) {
      return _then(_value.copyWith(growth: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SalesDashboardImplCopyWith<$Res>
    implements $SalesDashboardCopyWith<$Res> {
  factory _$$SalesDashboardImplCopyWith(_$SalesDashboardImpl value,
          $Res Function(_$SalesDashboardImpl) then) =
      __$$SalesDashboardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {MonthlyMetrics thisMonth,
      MonthlyMetrics lastMonth,
      GrowthMetrics growth});

  @override
  $MonthlyMetricsCopyWith<$Res> get thisMonth;
  @override
  $MonthlyMetricsCopyWith<$Res> get lastMonth;
  @override
  $GrowthMetricsCopyWith<$Res> get growth;
}

/// @nodoc
class __$$SalesDashboardImplCopyWithImpl<$Res>
    extends _$SalesDashboardCopyWithImpl<$Res, _$SalesDashboardImpl>
    implements _$$SalesDashboardImplCopyWith<$Res> {
  __$$SalesDashboardImplCopyWithImpl(
      _$SalesDashboardImpl _value, $Res Function(_$SalesDashboardImpl) _then)
      : super(_value, _then);

  /// Create a copy of SalesDashboard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? thisMonth = null,
    Object? lastMonth = null,
    Object? growth = null,
  }) {
    return _then(_$SalesDashboardImpl(
      thisMonth: null == thisMonth
          ? _value.thisMonth
          : thisMonth // ignore: cast_nullable_to_non_nullable
              as MonthlyMetrics,
      lastMonth: null == lastMonth
          ? _value.lastMonth
          : lastMonth // ignore: cast_nullable_to_non_nullable
              as MonthlyMetrics,
      growth: null == growth
          ? _value.growth
          : growth // ignore: cast_nullable_to_non_nullable
              as GrowthMetrics,
    ));
  }
}

/// @nodoc

class _$SalesDashboardImpl extends _SalesDashboard {
  const _$SalesDashboardImpl(
      {required this.thisMonth, required this.lastMonth, required this.growth})
      : super._();

  @override
  final MonthlyMetrics thisMonth;
  @override
  final MonthlyMetrics lastMonth;
  @override
  final GrowthMetrics growth;

  @override
  String toString() {
    return 'SalesDashboard(thisMonth: $thisMonth, lastMonth: $lastMonth, growth: $growth)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SalesDashboardImpl &&
            (identical(other.thisMonth, thisMonth) ||
                other.thisMonth == thisMonth) &&
            (identical(other.lastMonth, lastMonth) ||
                other.lastMonth == lastMonth) &&
            (identical(other.growth, growth) || other.growth == growth));
  }

  @override
  int get hashCode => Object.hash(runtimeType, thisMonth, lastMonth, growth);

  /// Create a copy of SalesDashboard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SalesDashboardImplCopyWith<_$SalesDashboardImpl> get copyWith =>
      __$$SalesDashboardImplCopyWithImpl<_$SalesDashboardImpl>(
          this, _$identity);
}

abstract class _SalesDashboard extends SalesDashboard {
  const factory _SalesDashboard(
      {required final MonthlyMetrics thisMonth,
      required final MonthlyMetrics lastMonth,
      required final GrowthMetrics growth}) = _$SalesDashboardImpl;
  const _SalesDashboard._() : super._();

  @override
  MonthlyMetrics get thisMonth;
  @override
  MonthlyMetrics get lastMonth;
  @override
  GrowthMetrics get growth;

  /// Create a copy of SalesDashboard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SalesDashboardImplCopyWith<_$SalesDashboardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
