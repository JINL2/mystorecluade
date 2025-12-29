// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_pnl.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DailyPnl {
  DateTime get date => throw _privateConstructorUsedError;
  double get revenue => throw _privateConstructorUsedError;
  double get cogs => throw _privateConstructorUsedError;
  double get opex => throw _privateConstructorUsedError;
  double get netIncome => throw _privateConstructorUsedError;

  /// Create a copy of DailyPnl
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailyPnlCopyWith<DailyPnl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyPnlCopyWith<$Res> {
  factory $DailyPnlCopyWith(DailyPnl value, $Res Function(DailyPnl) then) =
      _$DailyPnlCopyWithImpl<$Res, DailyPnl>;
  @useResult
  $Res call(
      {DateTime date,
      double revenue,
      double cogs,
      double opex,
      double netIncome});
}

/// @nodoc
class _$DailyPnlCopyWithImpl<$Res, $Val extends DailyPnl>
    implements $DailyPnlCopyWith<$Res> {
  _$DailyPnlCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailyPnl
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? revenue = null,
    Object? cogs = null,
    Object? opex = null,
    Object? netIncome = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      revenue: null == revenue
          ? _value.revenue
          : revenue // ignore: cast_nullable_to_non_nullable
              as double,
      cogs: null == cogs
          ? _value.cogs
          : cogs // ignore: cast_nullable_to_non_nullable
              as double,
      opex: null == opex
          ? _value.opex
          : opex // ignore: cast_nullable_to_non_nullable
              as double,
      netIncome: null == netIncome
          ? _value.netIncome
          : netIncome // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DailyPnlImplCopyWith<$Res>
    implements $DailyPnlCopyWith<$Res> {
  factory _$$DailyPnlImplCopyWith(
          _$DailyPnlImpl value, $Res Function(_$DailyPnlImpl) then) =
      __$$DailyPnlImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime date,
      double revenue,
      double cogs,
      double opex,
      double netIncome});
}

/// @nodoc
class __$$DailyPnlImplCopyWithImpl<$Res>
    extends _$DailyPnlCopyWithImpl<$Res, _$DailyPnlImpl>
    implements _$$DailyPnlImplCopyWith<$Res> {
  __$$DailyPnlImplCopyWithImpl(
      _$DailyPnlImpl _value, $Res Function(_$DailyPnlImpl) _then)
      : super(_value, _then);

  /// Create a copy of DailyPnl
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? revenue = null,
    Object? cogs = null,
    Object? opex = null,
    Object? netIncome = null,
  }) {
    return _then(_$DailyPnlImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      revenue: null == revenue
          ? _value.revenue
          : revenue // ignore: cast_nullable_to_non_nullable
              as double,
      cogs: null == cogs
          ? _value.cogs
          : cogs // ignore: cast_nullable_to_non_nullable
              as double,
      opex: null == opex
          ? _value.opex
          : opex // ignore: cast_nullable_to_non_nullable
              as double,
      netIncome: null == netIncome
          ? _value.netIncome
          : netIncome // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$DailyPnlImpl extends _DailyPnl {
  const _$DailyPnlImpl(
      {required this.date,
      this.revenue = 0,
      this.cogs = 0,
      this.opex = 0,
      this.netIncome = 0})
      : super._();

  @override
  final DateTime date;
  @override
  @JsonKey()
  final double revenue;
  @override
  @JsonKey()
  final double cogs;
  @override
  @JsonKey()
  final double opex;
  @override
  @JsonKey()
  final double netIncome;

  @override
  String toString() {
    return 'DailyPnl(date: $date, revenue: $revenue, cogs: $cogs, opex: $opex, netIncome: $netIncome)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyPnlImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.revenue, revenue) || other.revenue == revenue) &&
            (identical(other.cogs, cogs) || other.cogs == cogs) &&
            (identical(other.opex, opex) || other.opex == opex) &&
            (identical(other.netIncome, netIncome) ||
                other.netIncome == netIncome));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, date, revenue, cogs, opex, netIncome);

  /// Create a copy of DailyPnl
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyPnlImplCopyWith<_$DailyPnlImpl> get copyWith =>
      __$$DailyPnlImplCopyWithImpl<_$DailyPnlImpl>(this, _$identity);
}

abstract class _DailyPnl extends DailyPnl {
  const factory _DailyPnl(
      {required final DateTime date,
      final double revenue,
      final double cogs,
      final double opex,
      final double netIncome}) = _$DailyPnlImpl;
  const _DailyPnl._() : super._();

  @override
  DateTime get date;
  @override
  double get revenue;
  @override
  double get cogs;
  @override
  double get opex;
  @override
  double get netIncome;

  /// Create a copy of DailyPnl
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyPnlImplCopyWith<_$DailyPnlImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
