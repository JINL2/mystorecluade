// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'aging_analysis.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AgingAnalysis {
  double get current => throw _privateConstructorUsedError;
  double get overdue30 => throw _privateConstructorUsedError;
  double get overdue60 => throw _privateConstructorUsedError;
  double get overdue90 => throw _privateConstructorUsedError;
  List<AgingTrendPoint> get trend => throw _privateConstructorUsedError;

  /// Create a copy of AgingAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AgingAnalysisCopyWith<AgingAnalysis> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AgingAnalysisCopyWith<$Res> {
  factory $AgingAnalysisCopyWith(
          AgingAnalysis value, $Res Function(AgingAnalysis) then) =
      _$AgingAnalysisCopyWithImpl<$Res, AgingAnalysis>;
  @useResult
  $Res call(
      {double current,
      double overdue30,
      double overdue60,
      double overdue90,
      List<AgingTrendPoint> trend});
}

/// @nodoc
class _$AgingAnalysisCopyWithImpl<$Res, $Val extends AgingAnalysis>
    implements $AgingAnalysisCopyWith<$Res> {
  _$AgingAnalysisCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AgingAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? current = null,
    Object? overdue30 = null,
    Object? overdue60 = null,
    Object? overdue90 = null,
    Object? trend = null,
  }) {
    return _then(_value.copyWith(
      current: null == current
          ? _value.current
          : current // ignore: cast_nullable_to_non_nullable
              as double,
      overdue30: null == overdue30
          ? _value.overdue30
          : overdue30 // ignore: cast_nullable_to_non_nullable
              as double,
      overdue60: null == overdue60
          ? _value.overdue60
          : overdue60 // ignore: cast_nullable_to_non_nullable
              as double,
      overdue90: null == overdue90
          ? _value.overdue90
          : overdue90 // ignore: cast_nullable_to_non_nullable
              as double,
      trend: null == trend
          ? _value.trend
          : trend // ignore: cast_nullable_to_non_nullable
              as List<AgingTrendPoint>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AgingAnalysisImplCopyWith<$Res>
    implements $AgingAnalysisCopyWith<$Res> {
  factory _$$AgingAnalysisImplCopyWith(
          _$AgingAnalysisImpl value, $Res Function(_$AgingAnalysisImpl) then) =
      __$$AgingAnalysisImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double current,
      double overdue30,
      double overdue60,
      double overdue90,
      List<AgingTrendPoint> trend});
}

/// @nodoc
class __$$AgingAnalysisImplCopyWithImpl<$Res>
    extends _$AgingAnalysisCopyWithImpl<$Res, _$AgingAnalysisImpl>
    implements _$$AgingAnalysisImplCopyWith<$Res> {
  __$$AgingAnalysisImplCopyWithImpl(
      _$AgingAnalysisImpl _value, $Res Function(_$AgingAnalysisImpl) _then)
      : super(_value, _then);

  /// Create a copy of AgingAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? current = null,
    Object? overdue30 = null,
    Object? overdue60 = null,
    Object? overdue90 = null,
    Object? trend = null,
  }) {
    return _then(_$AgingAnalysisImpl(
      current: null == current
          ? _value.current
          : current // ignore: cast_nullable_to_non_nullable
              as double,
      overdue30: null == overdue30
          ? _value.overdue30
          : overdue30 // ignore: cast_nullable_to_non_nullable
              as double,
      overdue60: null == overdue60
          ? _value.overdue60
          : overdue60 // ignore: cast_nullable_to_non_nullable
              as double,
      overdue90: null == overdue90
          ? _value.overdue90
          : overdue90 // ignore: cast_nullable_to_non_nullable
              as double,
      trend: null == trend
          ? _value._trend
          : trend // ignore: cast_nullable_to_non_nullable
              as List<AgingTrendPoint>,
    ));
  }
}

/// @nodoc

class _$AgingAnalysisImpl extends _AgingAnalysis {
  const _$AgingAnalysisImpl(
      {this.current = 0.0,
      this.overdue30 = 0.0,
      this.overdue60 = 0.0,
      this.overdue90 = 0.0,
      final List<AgingTrendPoint> trend = const []})
      : _trend = trend,
        super._();

  @override
  @JsonKey()
  final double current;
  @override
  @JsonKey()
  final double overdue30;
  @override
  @JsonKey()
  final double overdue60;
  @override
  @JsonKey()
  final double overdue90;
  final List<AgingTrendPoint> _trend;
  @override
  @JsonKey()
  List<AgingTrendPoint> get trend {
    if (_trend is EqualUnmodifiableListView) return _trend;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_trend);
  }

  @override
  String toString() {
    return 'AgingAnalysis(current: $current, overdue30: $overdue30, overdue60: $overdue60, overdue90: $overdue90, trend: $trend)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AgingAnalysisImpl &&
            (identical(other.current, current) || other.current == current) &&
            (identical(other.overdue30, overdue30) ||
                other.overdue30 == overdue30) &&
            (identical(other.overdue60, overdue60) ||
                other.overdue60 == overdue60) &&
            (identical(other.overdue90, overdue90) ||
                other.overdue90 == overdue90) &&
            const DeepCollectionEquality().equals(other._trend, _trend));
  }

  @override
  int get hashCode => Object.hash(runtimeType, current, overdue30, overdue60,
      overdue90, const DeepCollectionEquality().hash(_trend));

  /// Create a copy of AgingAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AgingAnalysisImplCopyWith<_$AgingAnalysisImpl> get copyWith =>
      __$$AgingAnalysisImplCopyWithImpl<_$AgingAnalysisImpl>(this, _$identity);
}

abstract class _AgingAnalysis extends AgingAnalysis {
  const factory _AgingAnalysis(
      {final double current,
      final double overdue30,
      final double overdue60,
      final double overdue90,
      final List<AgingTrendPoint> trend}) = _$AgingAnalysisImpl;
  const _AgingAnalysis._() : super._();

  @override
  double get current;
  @override
  double get overdue30;
  @override
  double get overdue60;
  @override
  double get overdue90;
  @override
  List<AgingTrendPoint> get trend;

  /// Create a copy of AgingAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AgingAnalysisImplCopyWith<_$AgingAnalysisImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AgingTrendPoint {
  DateTime get date => throw _privateConstructorUsedError;
  double get current => throw _privateConstructorUsedError;
  double get overdue30 => throw _privateConstructorUsedError;
  double get overdue60 => throw _privateConstructorUsedError;
  double get overdue90 => throw _privateConstructorUsedError;

  /// Create a copy of AgingTrendPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AgingTrendPointCopyWith<AgingTrendPoint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AgingTrendPointCopyWith<$Res> {
  factory $AgingTrendPointCopyWith(
          AgingTrendPoint value, $Res Function(AgingTrendPoint) then) =
      _$AgingTrendPointCopyWithImpl<$Res, AgingTrendPoint>;
  @useResult
  $Res call(
      {DateTime date,
      double current,
      double overdue30,
      double overdue60,
      double overdue90});
}

/// @nodoc
class _$AgingTrendPointCopyWithImpl<$Res, $Val extends AgingTrendPoint>
    implements $AgingTrendPointCopyWith<$Res> {
  _$AgingTrendPointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AgingTrendPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? current = null,
    Object? overdue30 = null,
    Object? overdue60 = null,
    Object? overdue90 = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      current: null == current
          ? _value.current
          : current // ignore: cast_nullable_to_non_nullable
              as double,
      overdue30: null == overdue30
          ? _value.overdue30
          : overdue30 // ignore: cast_nullable_to_non_nullable
              as double,
      overdue60: null == overdue60
          ? _value.overdue60
          : overdue60 // ignore: cast_nullable_to_non_nullable
              as double,
      overdue90: null == overdue90
          ? _value.overdue90
          : overdue90 // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AgingTrendPointImplCopyWith<$Res>
    implements $AgingTrendPointCopyWith<$Res> {
  factory _$$AgingTrendPointImplCopyWith(_$AgingTrendPointImpl value,
          $Res Function(_$AgingTrendPointImpl) then) =
      __$$AgingTrendPointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime date,
      double current,
      double overdue30,
      double overdue60,
      double overdue90});
}

/// @nodoc
class __$$AgingTrendPointImplCopyWithImpl<$Res>
    extends _$AgingTrendPointCopyWithImpl<$Res, _$AgingTrendPointImpl>
    implements _$$AgingTrendPointImplCopyWith<$Res> {
  __$$AgingTrendPointImplCopyWithImpl(
      _$AgingTrendPointImpl _value, $Res Function(_$AgingTrendPointImpl) _then)
      : super(_value, _then);

  /// Create a copy of AgingTrendPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? current = null,
    Object? overdue30 = null,
    Object? overdue60 = null,
    Object? overdue90 = null,
  }) {
    return _then(_$AgingTrendPointImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      current: null == current
          ? _value.current
          : current // ignore: cast_nullable_to_non_nullable
              as double,
      overdue30: null == overdue30
          ? _value.overdue30
          : overdue30 // ignore: cast_nullable_to_non_nullable
              as double,
      overdue60: null == overdue60
          ? _value.overdue60
          : overdue60 // ignore: cast_nullable_to_non_nullable
              as double,
      overdue90: null == overdue90
          ? _value.overdue90
          : overdue90 // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$AgingTrendPointImpl implements _AgingTrendPoint {
  const _$AgingTrendPointImpl(
      {required this.date,
      required this.current,
      required this.overdue30,
      required this.overdue60,
      required this.overdue90});

  @override
  final DateTime date;
  @override
  final double current;
  @override
  final double overdue30;
  @override
  final double overdue60;
  @override
  final double overdue90;

  @override
  String toString() {
    return 'AgingTrendPoint(date: $date, current: $current, overdue30: $overdue30, overdue60: $overdue60, overdue90: $overdue90)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AgingTrendPointImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.current, current) || other.current == current) &&
            (identical(other.overdue30, overdue30) ||
                other.overdue30 == overdue30) &&
            (identical(other.overdue60, overdue60) ||
                other.overdue60 == overdue60) &&
            (identical(other.overdue90, overdue90) ||
                other.overdue90 == overdue90));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, date, current, overdue30, overdue60, overdue90);

  /// Create a copy of AgingTrendPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AgingTrendPointImplCopyWith<_$AgingTrendPointImpl> get copyWith =>
      __$$AgingTrendPointImplCopyWithImpl<_$AgingTrendPointImpl>(
          this, _$identity);
}

abstract class _AgingTrendPoint implements AgingTrendPoint {
  const factory _AgingTrendPoint(
      {required final DateTime date,
      required final double current,
      required final double overdue30,
      required final double overdue60,
      required final double overdue90}) = _$AgingTrendPointImpl;

  @override
  DateTime get date;
  @override
  double get current;
  @override
  double get overdue30;
  @override
  double get overdue60;
  @override
  double get overdue90;

  /// Create a copy of AgingTrendPoint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AgingTrendPointImplCopyWith<_$AgingTrendPointImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
