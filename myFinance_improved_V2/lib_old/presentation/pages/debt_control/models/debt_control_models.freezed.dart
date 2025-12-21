// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'debt_control_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CriticalAlert _$CriticalAlertFromJson(Map<String, dynamic> json) {
  return _CriticalAlert.fromJson(json);
}

/// @nodoc
mixin _$CriticalAlert {
  String get id => throw _privateConstructorUsedError;
  String get type =>
      throw _privateConstructorUsedError; // 'overdue_critical', 'payment_received', 'dispute_pending'
  String get message => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;
  String get severity =>
      throw _privateConstructorUsedError; // 'critical', 'warning', 'info'
  bool get isRead => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this CriticalAlert to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CriticalAlert
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CriticalAlertCopyWith<CriticalAlert> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CriticalAlertCopyWith<$Res> {
  factory $CriticalAlertCopyWith(
          CriticalAlert value, $Res Function(CriticalAlert) then) =
      _$CriticalAlertCopyWithImpl<$Res, CriticalAlert>;
  @useResult
  $Res call(
      {String id,
      String type,
      String message,
      int count,
      String severity,
      bool isRead,
      DateTime? createdAt});
}

/// @nodoc
class _$CriticalAlertCopyWithImpl<$Res, $Val extends CriticalAlert>
    implements $CriticalAlertCopyWith<$Res> {
  _$CriticalAlertCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CriticalAlert
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? message = null,
    Object? count = null,
    Object? severity = null,
    Object? isRead = null,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      severity: null == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as String,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CriticalAlertImplCopyWith<$Res>
    implements $CriticalAlertCopyWith<$Res> {
  factory _$$CriticalAlertImplCopyWith(
          _$CriticalAlertImpl value, $Res Function(_$CriticalAlertImpl) then) =
      __$$CriticalAlertImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String type,
      String message,
      int count,
      String severity,
      bool isRead,
      DateTime? createdAt});
}

/// @nodoc
class __$$CriticalAlertImplCopyWithImpl<$Res>
    extends _$CriticalAlertCopyWithImpl<$Res, _$CriticalAlertImpl>
    implements _$$CriticalAlertImplCopyWith<$Res> {
  __$$CriticalAlertImplCopyWithImpl(
      _$CriticalAlertImpl _value, $Res Function(_$CriticalAlertImpl) _then)
      : super(_value, _then);

  /// Create a copy of CriticalAlert
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? message = null,
    Object? count = null,
    Object? severity = null,
    Object? isRead = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$CriticalAlertImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      severity: null == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as String,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CriticalAlertImpl implements _CriticalAlert {
  const _$CriticalAlertImpl(
      {required this.id,
      required this.type,
      required this.message,
      required this.count,
      required this.severity,
      this.isRead = false,
      this.createdAt});

  factory _$CriticalAlertImpl.fromJson(Map<String, dynamic> json) =>
      _$$CriticalAlertImplFromJson(json);

  @override
  final String id;
  @override
  final String type;
// 'overdue_critical', 'payment_received', 'dispute_pending'
  @override
  final String message;
  @override
  final int count;
  @override
  final String severity;
// 'critical', 'warning', 'info'
  @override
  @JsonKey()
  final bool isRead;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'CriticalAlert(id: $id, type: $type, message: $message, count: $count, severity: $severity, isRead: $isRead, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CriticalAlertImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, type, message, count, severity, isRead, createdAt);

  /// Create a copy of CriticalAlert
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CriticalAlertImplCopyWith<_$CriticalAlertImpl> get copyWith =>
      __$$CriticalAlertImplCopyWithImpl<_$CriticalAlertImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CriticalAlertImplToJson(
      this,
    );
  }
}

abstract class _CriticalAlert implements CriticalAlert {
  const factory _CriticalAlert(
      {required final String id,
      required final String type,
      required final String message,
      required final int count,
      required final String severity,
      final bool isRead,
      final DateTime? createdAt}) = _$CriticalAlertImpl;

  factory _CriticalAlert.fromJson(Map<String, dynamic> json) =
      _$CriticalAlertImpl.fromJson;

  @override
  String get id;
  @override
  String get type; // 'overdue_critical', 'payment_received', 'dispute_pending'
  @override
  String get message;
  @override
  int get count;
  @override
  String get severity; // 'critical', 'warning', 'info'
  @override
  bool get isRead;
  @override
  DateTime? get createdAt;

  /// Create a copy of CriticalAlert
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CriticalAlertImplCopyWith<_$CriticalAlertImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

KPIMetrics _$KPIMetricsFromJson(Map<String, dynamic> json) {
  return _KPIMetrics.fromJson(json);
}

/// @nodoc
mixin _$KPIMetrics {
  double get netPosition => throw _privateConstructorUsedError;
  double get netPositionTrend =>
      throw _privateConstructorUsedError; // percentage change
  int get avgDaysOutstanding => throw _privateConstructorUsedError;
  double get agingTrend => throw _privateConstructorUsedError;
  double get collectionRate => throw _privateConstructorUsedError;
  double get collectionTrend => throw _privateConstructorUsedError;
  int get criticalCount => throw _privateConstructorUsedError;
  double get criticalTrend => throw _privateConstructorUsedError;
  double get totalReceivable => throw _privateConstructorUsedError;
  double get totalPayable => throw _privateConstructorUsedError;
  int get transactionCount => throw _privateConstructorUsedError;

  /// Serializes this KPIMetrics to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of KPIMetrics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $KPIMetricsCopyWith<KPIMetrics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KPIMetricsCopyWith<$Res> {
  factory $KPIMetricsCopyWith(
          KPIMetrics value, $Res Function(KPIMetrics) then) =
      _$KPIMetricsCopyWithImpl<$Res, KPIMetrics>;
  @useResult
  $Res call(
      {double netPosition,
      double netPositionTrend,
      int avgDaysOutstanding,
      double agingTrend,
      double collectionRate,
      double collectionTrend,
      int criticalCount,
      double criticalTrend,
      double totalReceivable,
      double totalPayable,
      int transactionCount});
}

/// @nodoc
class _$KPIMetricsCopyWithImpl<$Res, $Val extends KPIMetrics>
    implements $KPIMetricsCopyWith<$Res> {
  _$KPIMetricsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of KPIMetrics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? netPosition = null,
    Object? netPositionTrend = null,
    Object? avgDaysOutstanding = null,
    Object? agingTrend = null,
    Object? collectionRate = null,
    Object? collectionTrend = null,
    Object? criticalCount = null,
    Object? criticalTrend = null,
    Object? totalReceivable = null,
    Object? totalPayable = null,
    Object? transactionCount = null,
  }) {
    return _then(_value.copyWith(
      netPosition: null == netPosition
          ? _value.netPosition
          : netPosition // ignore: cast_nullable_to_non_nullable
              as double,
      netPositionTrend: null == netPositionTrend
          ? _value.netPositionTrend
          : netPositionTrend // ignore: cast_nullable_to_non_nullable
              as double,
      avgDaysOutstanding: null == avgDaysOutstanding
          ? _value.avgDaysOutstanding
          : avgDaysOutstanding // ignore: cast_nullable_to_non_nullable
              as int,
      agingTrend: null == agingTrend
          ? _value.agingTrend
          : agingTrend // ignore: cast_nullable_to_non_nullable
              as double,
      collectionRate: null == collectionRate
          ? _value.collectionRate
          : collectionRate // ignore: cast_nullable_to_non_nullable
              as double,
      collectionTrend: null == collectionTrend
          ? _value.collectionTrend
          : collectionTrend // ignore: cast_nullable_to_non_nullable
              as double,
      criticalCount: null == criticalCount
          ? _value.criticalCount
          : criticalCount // ignore: cast_nullable_to_non_nullable
              as int,
      criticalTrend: null == criticalTrend
          ? _value.criticalTrend
          : criticalTrend // ignore: cast_nullable_to_non_nullable
              as double,
      totalReceivable: null == totalReceivable
          ? _value.totalReceivable
          : totalReceivable // ignore: cast_nullable_to_non_nullable
              as double,
      totalPayable: null == totalPayable
          ? _value.totalPayable
          : totalPayable // ignore: cast_nullable_to_non_nullable
              as double,
      transactionCount: null == transactionCount
          ? _value.transactionCount
          : transactionCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$KPIMetricsImplCopyWith<$Res>
    implements $KPIMetricsCopyWith<$Res> {
  factory _$$KPIMetricsImplCopyWith(
          _$KPIMetricsImpl value, $Res Function(_$KPIMetricsImpl) then) =
      __$$KPIMetricsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double netPosition,
      double netPositionTrend,
      int avgDaysOutstanding,
      double agingTrend,
      double collectionRate,
      double collectionTrend,
      int criticalCount,
      double criticalTrend,
      double totalReceivable,
      double totalPayable,
      int transactionCount});
}

/// @nodoc
class __$$KPIMetricsImplCopyWithImpl<$Res>
    extends _$KPIMetricsCopyWithImpl<$Res, _$KPIMetricsImpl>
    implements _$$KPIMetricsImplCopyWith<$Res> {
  __$$KPIMetricsImplCopyWithImpl(
      _$KPIMetricsImpl _value, $Res Function(_$KPIMetricsImpl) _then)
      : super(_value, _then);

  /// Create a copy of KPIMetrics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? netPosition = null,
    Object? netPositionTrend = null,
    Object? avgDaysOutstanding = null,
    Object? agingTrend = null,
    Object? collectionRate = null,
    Object? collectionTrend = null,
    Object? criticalCount = null,
    Object? criticalTrend = null,
    Object? totalReceivable = null,
    Object? totalPayable = null,
    Object? transactionCount = null,
  }) {
    return _then(_$KPIMetricsImpl(
      netPosition: null == netPosition
          ? _value.netPosition
          : netPosition // ignore: cast_nullable_to_non_nullable
              as double,
      netPositionTrend: null == netPositionTrend
          ? _value.netPositionTrend
          : netPositionTrend // ignore: cast_nullable_to_non_nullable
              as double,
      avgDaysOutstanding: null == avgDaysOutstanding
          ? _value.avgDaysOutstanding
          : avgDaysOutstanding // ignore: cast_nullable_to_non_nullable
              as int,
      agingTrend: null == agingTrend
          ? _value.agingTrend
          : agingTrend // ignore: cast_nullable_to_non_nullable
              as double,
      collectionRate: null == collectionRate
          ? _value.collectionRate
          : collectionRate // ignore: cast_nullable_to_non_nullable
              as double,
      collectionTrend: null == collectionTrend
          ? _value.collectionTrend
          : collectionTrend // ignore: cast_nullable_to_non_nullable
              as double,
      criticalCount: null == criticalCount
          ? _value.criticalCount
          : criticalCount // ignore: cast_nullable_to_non_nullable
              as int,
      criticalTrend: null == criticalTrend
          ? _value.criticalTrend
          : criticalTrend // ignore: cast_nullable_to_non_nullable
              as double,
      totalReceivable: null == totalReceivable
          ? _value.totalReceivable
          : totalReceivable // ignore: cast_nullable_to_non_nullable
              as double,
      totalPayable: null == totalPayable
          ? _value.totalPayable
          : totalPayable // ignore: cast_nullable_to_non_nullable
              as double,
      transactionCount: null == transactionCount
          ? _value.transactionCount
          : transactionCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$KPIMetricsImpl implements _KPIMetrics {
  const _$KPIMetricsImpl(
      {this.netPosition = 0.0,
      this.netPositionTrend = 0.0,
      this.avgDaysOutstanding = 0,
      this.agingTrend = 0.0,
      this.collectionRate = 0.0,
      this.collectionTrend = 0.0,
      this.criticalCount = 0,
      this.criticalTrend = 0.0,
      this.totalReceivable = 0.0,
      this.totalPayable = 0.0,
      this.transactionCount = 0});

  factory _$KPIMetricsImpl.fromJson(Map<String, dynamic> json) =>
      _$$KPIMetricsImplFromJson(json);

  @override
  @JsonKey()
  final double netPosition;
  @override
  @JsonKey()
  final double netPositionTrend;
// percentage change
  @override
  @JsonKey()
  final int avgDaysOutstanding;
  @override
  @JsonKey()
  final double agingTrend;
  @override
  @JsonKey()
  final double collectionRate;
  @override
  @JsonKey()
  final double collectionTrend;
  @override
  @JsonKey()
  final int criticalCount;
  @override
  @JsonKey()
  final double criticalTrend;
  @override
  @JsonKey()
  final double totalReceivable;
  @override
  @JsonKey()
  final double totalPayable;
  @override
  @JsonKey()
  final int transactionCount;

  @override
  String toString() {
    return 'KPIMetrics(netPosition: $netPosition, netPositionTrend: $netPositionTrend, avgDaysOutstanding: $avgDaysOutstanding, agingTrend: $agingTrend, collectionRate: $collectionRate, collectionTrend: $collectionTrend, criticalCount: $criticalCount, criticalTrend: $criticalTrend, totalReceivable: $totalReceivable, totalPayable: $totalPayable, transactionCount: $transactionCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KPIMetricsImpl &&
            (identical(other.netPosition, netPosition) ||
                other.netPosition == netPosition) &&
            (identical(other.netPositionTrend, netPositionTrend) ||
                other.netPositionTrend == netPositionTrend) &&
            (identical(other.avgDaysOutstanding, avgDaysOutstanding) ||
                other.avgDaysOutstanding == avgDaysOutstanding) &&
            (identical(other.agingTrend, agingTrend) ||
                other.agingTrend == agingTrend) &&
            (identical(other.collectionRate, collectionRate) ||
                other.collectionRate == collectionRate) &&
            (identical(other.collectionTrend, collectionTrend) ||
                other.collectionTrend == collectionTrend) &&
            (identical(other.criticalCount, criticalCount) ||
                other.criticalCount == criticalCount) &&
            (identical(other.criticalTrend, criticalTrend) ||
                other.criticalTrend == criticalTrend) &&
            (identical(other.totalReceivable, totalReceivable) ||
                other.totalReceivable == totalReceivable) &&
            (identical(other.totalPayable, totalPayable) ||
                other.totalPayable == totalPayable) &&
            (identical(other.transactionCount, transactionCount) ||
                other.transactionCount == transactionCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      netPosition,
      netPositionTrend,
      avgDaysOutstanding,
      agingTrend,
      collectionRate,
      collectionTrend,
      criticalCount,
      criticalTrend,
      totalReceivable,
      totalPayable,
      transactionCount);

  /// Create a copy of KPIMetrics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$KPIMetricsImplCopyWith<_$KPIMetricsImpl> get copyWith =>
      __$$KPIMetricsImplCopyWithImpl<_$KPIMetricsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$KPIMetricsImplToJson(
      this,
    );
  }
}

abstract class _KPIMetrics implements KPIMetrics {
  const factory _KPIMetrics(
      {final double netPosition,
      final double netPositionTrend,
      final int avgDaysOutstanding,
      final double agingTrend,
      final double collectionRate,
      final double collectionTrend,
      final int criticalCount,
      final double criticalTrend,
      final double totalReceivable,
      final double totalPayable,
      final int transactionCount}) = _$KPIMetricsImpl;

  factory _KPIMetrics.fromJson(Map<String, dynamic> json) =
      _$KPIMetricsImpl.fromJson;

  @override
  double get netPosition;
  @override
  double get netPositionTrend; // percentage change
  @override
  int get avgDaysOutstanding;
  @override
  double get agingTrend;
  @override
  double get collectionRate;
  @override
  double get collectionTrend;
  @override
  int get criticalCount;
  @override
  double get criticalTrend;
  @override
  double get totalReceivable;
  @override
  double get totalPayable;
  @override
  int get transactionCount;

  /// Create a copy of KPIMetrics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$KPIMetricsImplCopyWith<_$KPIMetricsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AgingAnalysis _$AgingAnalysisFromJson(Map<String, dynamic> json) {
  return _AgingAnalysis.fromJson(json);
}

/// @nodoc
mixin _$AgingAnalysis {
  double get current => throw _privateConstructorUsedError; // 0-30 days
  double get overdue30 => throw _privateConstructorUsedError; // 31-60 days
  double get overdue60 => throw _privateConstructorUsedError; // 61-90 days
  double get overdue90 => throw _privateConstructorUsedError; // 90+ days
  List<AgingTrendPoint> get trend => throw _privateConstructorUsedError;

  /// Serializes this AgingAnalysis to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

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
@JsonSerializable()
class _$AgingAnalysisImpl implements _AgingAnalysis {
  const _$AgingAnalysisImpl(
      {this.current = 0.0,
      this.overdue30 = 0.0,
      this.overdue60 = 0.0,
      this.overdue90 = 0.0,
      final List<AgingTrendPoint> trend = const []})
      : _trend = trend;

  factory _$AgingAnalysisImpl.fromJson(Map<String, dynamic> json) =>
      _$$AgingAnalysisImplFromJson(json);

  @override
  @JsonKey()
  final double current;
// 0-30 days
  @override
  @JsonKey()
  final double overdue30;
// 31-60 days
  @override
  @JsonKey()
  final double overdue60;
// 61-90 days
  @override
  @JsonKey()
  final double overdue90;
// 90+ days
  final List<AgingTrendPoint> _trend;
// 90+ days
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

  @JsonKey(includeFromJson: false, includeToJson: false)
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

  @override
  Map<String, dynamic> toJson() {
    return _$$AgingAnalysisImplToJson(
      this,
    );
  }
}

abstract class _AgingAnalysis implements AgingAnalysis {
  const factory _AgingAnalysis(
      {final double current,
      final double overdue30,
      final double overdue60,
      final double overdue90,
      final List<AgingTrendPoint> trend}) = _$AgingAnalysisImpl;

  factory _AgingAnalysis.fromJson(Map<String, dynamic> json) =
      _$AgingAnalysisImpl.fromJson;

  @override
  double get current; // 0-30 days
  @override
  double get overdue30; // 31-60 days
  @override
  double get overdue60; // 61-90 days
  @override
  double get overdue90; // 90+ days
  @override
  List<AgingTrendPoint> get trend;

  /// Create a copy of AgingAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AgingAnalysisImplCopyWith<_$AgingAnalysisImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AgingTrendPoint _$AgingTrendPointFromJson(Map<String, dynamic> json) {
  return _AgingTrendPoint.fromJson(json);
}

/// @nodoc
mixin _$AgingTrendPoint {
  DateTime get date => throw _privateConstructorUsedError;
  double get current => throw _privateConstructorUsedError;
  double get overdue30 => throw _privateConstructorUsedError;
  double get overdue60 => throw _privateConstructorUsedError;
  double get overdue90 => throw _privateConstructorUsedError;

  /// Serializes this AgingTrendPoint to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

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
@JsonSerializable()
class _$AgingTrendPointImpl implements _AgingTrendPoint {
  const _$AgingTrendPointImpl(
      {required this.date,
      required this.current,
      required this.overdue30,
      required this.overdue60,
      required this.overdue90});

  factory _$AgingTrendPointImpl.fromJson(Map<String, dynamic> json) =>
      _$$AgingTrendPointImplFromJson(json);

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

  @JsonKey(includeFromJson: false, includeToJson: false)
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

  @override
  Map<String, dynamic> toJson() {
    return _$$AgingTrendPointImplToJson(
      this,
    );
  }
}

abstract class _AgingTrendPoint implements AgingTrendPoint {
  const factory _AgingTrendPoint(
      {required final DateTime date,
      required final double current,
      required final double overdue30,
      required final double overdue60,
      required final double overdue90}) = _$AgingTrendPointImpl;

  factory _AgingTrendPoint.fromJson(Map<String, dynamic> json) =
      _$AgingTrendPointImpl.fromJson;

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

PrioritizedDebt _$PrioritizedDebtFromJson(Map<String, dynamic> json) {
  return _PrioritizedDebt.fromJson(json);
}

/// @nodoc
mixin _$PrioritizedDebt {
  String get id => throw _privateConstructorUsedError;
  String get counterpartyId => throw _privateConstructorUsedError;
  String get counterpartyName => throw _privateConstructorUsedError;
  String get counterpartyType =>
      throw _privateConstructorUsedError; // 'customer', 'vendor', 'employee', 'internal'
  double get amount => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  DateTime get dueDate => throw _privateConstructorUsedError;
  int get daysOverdue => throw _privateConstructorUsedError;
  String get riskCategory =>
      throw _privateConstructorUsedError; // 'critical', 'attention', 'watch', 'current'
  double get priorityScore =>
      throw _privateConstructorUsedError; // 0-100 risk score
  DateTime? get lastContactDate => throw _privateConstructorUsedError;
  String? get lastContactType =>
      throw _privateConstructorUsedError; // 'call', 'email', 'meeting'
  String? get paymentStatus =>
      throw _privateConstructorUsedError; // 'overdue', 'partial', 'current', 'disputed'
  List<SuggestedAction> get suggestedActions =>
      throw _privateConstructorUsedError;
  List<DebtTransaction> get recentTransactions =>
      throw _privateConstructorUsedError;
  bool get hasPaymentPlan => throw _privateConstructorUsedError;
  bool get isDisputed => throw _privateConstructorUsedError;
  int get transactionCount =>
      throw _privateConstructorUsedError; // Total transaction count with counterparty
  String? get linkedCompanyName =>
      throw _privateConstructorUsedError; // For internal counterparties
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this PrioritizedDebt to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PrioritizedDebt
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PrioritizedDebtCopyWith<PrioritizedDebt> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrioritizedDebtCopyWith<$Res> {
  factory $PrioritizedDebtCopyWith(
          PrioritizedDebt value, $Res Function(PrioritizedDebt) then) =
      _$PrioritizedDebtCopyWithImpl<$Res, PrioritizedDebt>;
  @useResult
  $Res call(
      {String id,
      String counterpartyId,
      String counterpartyName,
      String counterpartyType,
      double amount,
      String currency,
      DateTime dueDate,
      int daysOverdue,
      String riskCategory,
      double priorityScore,
      DateTime? lastContactDate,
      String? lastContactType,
      String? paymentStatus,
      List<SuggestedAction> suggestedActions,
      List<DebtTransaction> recentTransactions,
      bool hasPaymentPlan,
      bool isDisputed,
      int transactionCount,
      String? linkedCompanyName,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$PrioritizedDebtCopyWithImpl<$Res, $Val extends PrioritizedDebt>
    implements $PrioritizedDebtCopyWith<$Res> {
  _$PrioritizedDebtCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PrioritizedDebt
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? counterpartyId = null,
    Object? counterpartyName = null,
    Object? counterpartyType = null,
    Object? amount = null,
    Object? currency = null,
    Object? dueDate = null,
    Object? daysOverdue = null,
    Object? riskCategory = null,
    Object? priorityScore = null,
    Object? lastContactDate = freezed,
    Object? lastContactType = freezed,
    Object? paymentStatus = freezed,
    Object? suggestedActions = null,
    Object? recentTransactions = null,
    Object? hasPaymentPlan = null,
    Object? isDisputed = null,
    Object? transactionCount = null,
    Object? linkedCompanyName = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      counterpartyId: null == counterpartyId
          ? _value.counterpartyId
          : counterpartyId // ignore: cast_nullable_to_non_nullable
              as String,
      counterpartyName: null == counterpartyName
          ? _value.counterpartyName
          : counterpartyName // ignore: cast_nullable_to_non_nullable
              as String,
      counterpartyType: null == counterpartyType
          ? _value.counterpartyType
          : counterpartyType // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      dueDate: null == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      daysOverdue: null == daysOverdue
          ? _value.daysOverdue
          : daysOverdue // ignore: cast_nullable_to_non_nullable
              as int,
      riskCategory: null == riskCategory
          ? _value.riskCategory
          : riskCategory // ignore: cast_nullable_to_non_nullable
              as String,
      priorityScore: null == priorityScore
          ? _value.priorityScore
          : priorityScore // ignore: cast_nullable_to_non_nullable
              as double,
      lastContactDate: freezed == lastContactDate
          ? _value.lastContactDate
          : lastContactDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastContactType: freezed == lastContactType
          ? _value.lastContactType
          : lastContactType // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentStatus: freezed == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      suggestedActions: null == suggestedActions
          ? _value.suggestedActions
          : suggestedActions // ignore: cast_nullable_to_non_nullable
              as List<SuggestedAction>,
      recentTransactions: null == recentTransactions
          ? _value.recentTransactions
          : recentTransactions // ignore: cast_nullable_to_non_nullable
              as List<DebtTransaction>,
      hasPaymentPlan: null == hasPaymentPlan
          ? _value.hasPaymentPlan
          : hasPaymentPlan // ignore: cast_nullable_to_non_nullable
              as bool,
      isDisputed: null == isDisputed
          ? _value.isDisputed
          : isDisputed // ignore: cast_nullable_to_non_nullable
              as bool,
      transactionCount: null == transactionCount
          ? _value.transactionCount
          : transactionCount // ignore: cast_nullable_to_non_nullable
              as int,
      linkedCompanyName: freezed == linkedCompanyName
          ? _value.linkedCompanyName
          : linkedCompanyName // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PrioritizedDebtImplCopyWith<$Res>
    implements $PrioritizedDebtCopyWith<$Res> {
  factory _$$PrioritizedDebtImplCopyWith(_$PrioritizedDebtImpl value,
          $Res Function(_$PrioritizedDebtImpl) then) =
      __$$PrioritizedDebtImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String counterpartyId,
      String counterpartyName,
      String counterpartyType,
      double amount,
      String currency,
      DateTime dueDate,
      int daysOverdue,
      String riskCategory,
      double priorityScore,
      DateTime? lastContactDate,
      String? lastContactType,
      String? paymentStatus,
      List<SuggestedAction> suggestedActions,
      List<DebtTransaction> recentTransactions,
      bool hasPaymentPlan,
      bool isDisputed,
      int transactionCount,
      String? linkedCompanyName,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$PrioritizedDebtImplCopyWithImpl<$Res>
    extends _$PrioritizedDebtCopyWithImpl<$Res, _$PrioritizedDebtImpl>
    implements _$$PrioritizedDebtImplCopyWith<$Res> {
  __$$PrioritizedDebtImplCopyWithImpl(
      _$PrioritizedDebtImpl _value, $Res Function(_$PrioritizedDebtImpl) _then)
      : super(_value, _then);

  /// Create a copy of PrioritizedDebt
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? counterpartyId = null,
    Object? counterpartyName = null,
    Object? counterpartyType = null,
    Object? amount = null,
    Object? currency = null,
    Object? dueDate = null,
    Object? daysOverdue = null,
    Object? riskCategory = null,
    Object? priorityScore = null,
    Object? lastContactDate = freezed,
    Object? lastContactType = freezed,
    Object? paymentStatus = freezed,
    Object? suggestedActions = null,
    Object? recentTransactions = null,
    Object? hasPaymentPlan = null,
    Object? isDisputed = null,
    Object? transactionCount = null,
    Object? linkedCompanyName = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$PrioritizedDebtImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      counterpartyId: null == counterpartyId
          ? _value.counterpartyId
          : counterpartyId // ignore: cast_nullable_to_non_nullable
              as String,
      counterpartyName: null == counterpartyName
          ? _value.counterpartyName
          : counterpartyName // ignore: cast_nullable_to_non_nullable
              as String,
      counterpartyType: null == counterpartyType
          ? _value.counterpartyType
          : counterpartyType // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      dueDate: null == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      daysOverdue: null == daysOverdue
          ? _value.daysOverdue
          : daysOverdue // ignore: cast_nullable_to_non_nullable
              as int,
      riskCategory: null == riskCategory
          ? _value.riskCategory
          : riskCategory // ignore: cast_nullable_to_non_nullable
              as String,
      priorityScore: null == priorityScore
          ? _value.priorityScore
          : priorityScore // ignore: cast_nullable_to_non_nullable
              as double,
      lastContactDate: freezed == lastContactDate
          ? _value.lastContactDate
          : lastContactDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastContactType: freezed == lastContactType
          ? _value.lastContactType
          : lastContactType // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentStatus: freezed == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      suggestedActions: null == suggestedActions
          ? _value._suggestedActions
          : suggestedActions // ignore: cast_nullable_to_non_nullable
              as List<SuggestedAction>,
      recentTransactions: null == recentTransactions
          ? _value._recentTransactions
          : recentTransactions // ignore: cast_nullable_to_non_nullable
              as List<DebtTransaction>,
      hasPaymentPlan: null == hasPaymentPlan
          ? _value.hasPaymentPlan
          : hasPaymentPlan // ignore: cast_nullable_to_non_nullable
              as bool,
      isDisputed: null == isDisputed
          ? _value.isDisputed
          : isDisputed // ignore: cast_nullable_to_non_nullable
              as bool,
      transactionCount: null == transactionCount
          ? _value.transactionCount
          : transactionCount // ignore: cast_nullable_to_non_nullable
              as int,
      linkedCompanyName: freezed == linkedCompanyName
          ? _value.linkedCompanyName
          : linkedCompanyName // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PrioritizedDebtImpl implements _PrioritizedDebt {
  const _$PrioritizedDebtImpl(
      {required this.id,
      required this.counterpartyId,
      required this.counterpartyName,
      required this.counterpartyType,
      required this.amount,
      required this.currency,
      required this.dueDate,
      required this.daysOverdue,
      required this.riskCategory,
      required this.priorityScore,
      this.lastContactDate,
      this.lastContactType,
      this.paymentStatus,
      final List<SuggestedAction> suggestedActions = const [],
      final List<DebtTransaction> recentTransactions = const [],
      this.hasPaymentPlan = false,
      this.isDisputed = false,
      this.transactionCount = 0,
      this.linkedCompanyName,
      final Map<String, dynamic>? metadata})
      : _suggestedActions = suggestedActions,
        _recentTransactions = recentTransactions,
        _metadata = metadata;

  factory _$PrioritizedDebtImpl.fromJson(Map<String, dynamic> json) =>
      _$$PrioritizedDebtImplFromJson(json);

  @override
  final String id;
  @override
  final String counterpartyId;
  @override
  final String counterpartyName;
  @override
  final String counterpartyType;
// 'customer', 'vendor', 'employee', 'internal'
  @override
  final double amount;
  @override
  final String currency;
  @override
  final DateTime dueDate;
  @override
  final int daysOverdue;
  @override
  final String riskCategory;
// 'critical', 'attention', 'watch', 'current'
  @override
  final double priorityScore;
// 0-100 risk score
  @override
  final DateTime? lastContactDate;
  @override
  final String? lastContactType;
// 'call', 'email', 'meeting'
  @override
  final String? paymentStatus;
// 'overdue', 'partial', 'current', 'disputed'
  final List<SuggestedAction> _suggestedActions;
// 'overdue', 'partial', 'current', 'disputed'
  @override
  @JsonKey()
  List<SuggestedAction> get suggestedActions {
    if (_suggestedActions is EqualUnmodifiableListView)
      return _suggestedActions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_suggestedActions);
  }

  final List<DebtTransaction> _recentTransactions;
  @override
  @JsonKey()
  List<DebtTransaction> get recentTransactions {
    if (_recentTransactions is EqualUnmodifiableListView)
      return _recentTransactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentTransactions);
  }

  @override
  @JsonKey()
  final bool hasPaymentPlan;
  @override
  @JsonKey()
  final bool isDisputed;
  @override
  @JsonKey()
  final int transactionCount;
// Total transaction count with counterparty
  @override
  final String? linkedCompanyName;
// For internal counterparties
  final Map<String, dynamic>? _metadata;
// For internal counterparties
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'PrioritizedDebt(id: $id, counterpartyId: $counterpartyId, counterpartyName: $counterpartyName, counterpartyType: $counterpartyType, amount: $amount, currency: $currency, dueDate: $dueDate, daysOverdue: $daysOverdue, riskCategory: $riskCategory, priorityScore: $priorityScore, lastContactDate: $lastContactDate, lastContactType: $lastContactType, paymentStatus: $paymentStatus, suggestedActions: $suggestedActions, recentTransactions: $recentTransactions, hasPaymentPlan: $hasPaymentPlan, isDisputed: $isDisputed, transactionCount: $transactionCount, linkedCompanyName: $linkedCompanyName, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrioritizedDebtImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.counterpartyId, counterpartyId) ||
                other.counterpartyId == counterpartyId) &&
            (identical(other.counterpartyName, counterpartyName) ||
                other.counterpartyName == counterpartyName) &&
            (identical(other.counterpartyType, counterpartyType) ||
                other.counterpartyType == counterpartyType) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.daysOverdue, daysOverdue) ||
                other.daysOverdue == daysOverdue) &&
            (identical(other.riskCategory, riskCategory) ||
                other.riskCategory == riskCategory) &&
            (identical(other.priorityScore, priorityScore) ||
                other.priorityScore == priorityScore) &&
            (identical(other.lastContactDate, lastContactDate) ||
                other.lastContactDate == lastContactDate) &&
            (identical(other.lastContactType, lastContactType) ||
                other.lastContactType == lastContactType) &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus) &&
            const DeepCollectionEquality()
                .equals(other._suggestedActions, _suggestedActions) &&
            const DeepCollectionEquality()
                .equals(other._recentTransactions, _recentTransactions) &&
            (identical(other.hasPaymentPlan, hasPaymentPlan) ||
                other.hasPaymentPlan == hasPaymentPlan) &&
            (identical(other.isDisputed, isDisputed) ||
                other.isDisputed == isDisputed) &&
            (identical(other.transactionCount, transactionCount) ||
                other.transactionCount == transactionCount) &&
            (identical(other.linkedCompanyName, linkedCompanyName) ||
                other.linkedCompanyName == linkedCompanyName) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        counterpartyId,
        counterpartyName,
        counterpartyType,
        amount,
        currency,
        dueDate,
        daysOverdue,
        riskCategory,
        priorityScore,
        lastContactDate,
        lastContactType,
        paymentStatus,
        const DeepCollectionEquality().hash(_suggestedActions),
        const DeepCollectionEquality().hash(_recentTransactions),
        hasPaymentPlan,
        isDisputed,
        transactionCount,
        linkedCompanyName,
        const DeepCollectionEquality().hash(_metadata)
      ]);

  /// Create a copy of PrioritizedDebt
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PrioritizedDebtImplCopyWith<_$PrioritizedDebtImpl> get copyWith =>
      __$$PrioritizedDebtImplCopyWithImpl<_$PrioritizedDebtImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PrioritizedDebtImplToJson(
      this,
    );
  }
}

abstract class _PrioritizedDebt implements PrioritizedDebt {
  const factory _PrioritizedDebt(
      {required final String id,
      required final String counterpartyId,
      required final String counterpartyName,
      required final String counterpartyType,
      required final double amount,
      required final String currency,
      required final DateTime dueDate,
      required final int daysOverdue,
      required final String riskCategory,
      required final double priorityScore,
      final DateTime? lastContactDate,
      final String? lastContactType,
      final String? paymentStatus,
      final List<SuggestedAction> suggestedActions,
      final List<DebtTransaction> recentTransactions,
      final bool hasPaymentPlan,
      final bool isDisputed,
      final int transactionCount,
      final String? linkedCompanyName,
      final Map<String, dynamic>? metadata}) = _$PrioritizedDebtImpl;

  factory _PrioritizedDebt.fromJson(Map<String, dynamic> json) =
      _$PrioritizedDebtImpl.fromJson;

  @override
  String get id;
  @override
  String get counterpartyId;
  @override
  String get counterpartyName;
  @override
  String get counterpartyType; // 'customer', 'vendor', 'employee', 'internal'
  @override
  double get amount;
  @override
  String get currency;
  @override
  DateTime get dueDate;
  @override
  int get daysOverdue;
  @override
  String get riskCategory; // 'critical', 'attention', 'watch', 'current'
  @override
  double get priorityScore; // 0-100 risk score
  @override
  DateTime? get lastContactDate;
  @override
  String? get lastContactType; // 'call', 'email', 'meeting'
  @override
  String? get paymentStatus; // 'overdue', 'partial', 'current', 'disputed'
  @override
  List<SuggestedAction> get suggestedActions;
  @override
  List<DebtTransaction> get recentTransactions;
  @override
  bool get hasPaymentPlan;
  @override
  bool get isDisputed;
  @override
  int get transactionCount; // Total transaction count with counterparty
  @override
  String? get linkedCompanyName; // For internal counterparties
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of PrioritizedDebt
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PrioritizedDebtImplCopyWith<_$PrioritizedDebtImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SuggestedAction _$SuggestedActionFromJson(Map<String, dynamic> json) {
  return _SuggestedAction.fromJson(json);
}

/// @nodoc
mixin _$SuggestedAction {
  String get id => throw _privateConstructorUsedError;
  String get type =>
      throw _privateConstructorUsedError; // 'call', 'email', 'payment_plan', 'legal', etc.
  String get label => throw _privateConstructorUsedError;
  String get icon => throw _privateConstructorUsedError;
  bool get isPrimary => throw _privateConstructorUsedError;
  String get color => throw _privateConstructorUsedError; // hex color code
  String? get description => throw _privateConstructorUsedError;
  Map<String, dynamic>? get parameters => throw _privateConstructorUsedError;

  /// Serializes this SuggestedAction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SuggestedAction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SuggestedActionCopyWith<SuggestedAction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SuggestedActionCopyWith<$Res> {
  factory $SuggestedActionCopyWith(
          SuggestedAction value, $Res Function(SuggestedAction) then) =
      _$SuggestedActionCopyWithImpl<$Res, SuggestedAction>;
  @useResult
  $Res call(
      {String id,
      String type,
      String label,
      String icon,
      bool isPrimary,
      String color,
      String? description,
      Map<String, dynamic>? parameters});
}

/// @nodoc
class _$SuggestedActionCopyWithImpl<$Res, $Val extends SuggestedAction>
    implements $SuggestedActionCopyWith<$Res> {
  _$SuggestedActionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SuggestedAction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? label = null,
    Object? icon = null,
    Object? isPrimary = null,
    Object? color = null,
    Object? description = freezed,
    Object? parameters = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      isPrimary: null == isPrimary
          ? _value.isPrimary
          : isPrimary // ignore: cast_nullable_to_non_nullable
              as bool,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      parameters: freezed == parameters
          ? _value.parameters
          : parameters // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SuggestedActionImplCopyWith<$Res>
    implements $SuggestedActionCopyWith<$Res> {
  factory _$$SuggestedActionImplCopyWith(_$SuggestedActionImpl value,
          $Res Function(_$SuggestedActionImpl) then) =
      __$$SuggestedActionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String type,
      String label,
      String icon,
      bool isPrimary,
      String color,
      String? description,
      Map<String, dynamic>? parameters});
}

/// @nodoc
class __$$SuggestedActionImplCopyWithImpl<$Res>
    extends _$SuggestedActionCopyWithImpl<$Res, _$SuggestedActionImpl>
    implements _$$SuggestedActionImplCopyWith<$Res> {
  __$$SuggestedActionImplCopyWithImpl(
      _$SuggestedActionImpl _value, $Res Function(_$SuggestedActionImpl) _then)
      : super(_value, _then);

  /// Create a copy of SuggestedAction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? label = null,
    Object? icon = null,
    Object? isPrimary = null,
    Object? color = null,
    Object? description = freezed,
    Object? parameters = freezed,
  }) {
    return _then(_$SuggestedActionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      isPrimary: null == isPrimary
          ? _value.isPrimary
          : isPrimary // ignore: cast_nullable_to_non_nullable
              as bool,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      parameters: freezed == parameters
          ? _value._parameters
          : parameters // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SuggestedActionImpl implements _SuggestedAction {
  const _$SuggestedActionImpl(
      {required this.id,
      required this.type,
      required this.label,
      required this.icon,
      required this.isPrimary,
      required this.color,
      this.description,
      final Map<String, dynamic>? parameters})
      : _parameters = parameters;

  factory _$SuggestedActionImpl.fromJson(Map<String, dynamic> json) =>
      _$$SuggestedActionImplFromJson(json);

  @override
  final String id;
  @override
  final String type;
// 'call', 'email', 'payment_plan', 'legal', etc.
  @override
  final String label;
  @override
  final String icon;
  @override
  final bool isPrimary;
  @override
  final String color;
// hex color code
  @override
  final String? description;
  final Map<String, dynamic>? _parameters;
  @override
  Map<String, dynamic>? get parameters {
    final value = _parameters;
    if (value == null) return null;
    if (_parameters is EqualUnmodifiableMapView) return _parameters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'SuggestedAction(id: $id, type: $type, label: $label, icon: $icon, isPrimary: $isPrimary, color: $color, description: $description, parameters: $parameters)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SuggestedActionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.isPrimary, isPrimary) ||
                other.isPrimary == isPrimary) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other._parameters, _parameters));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, type, label, icon, isPrimary,
      color, description, const DeepCollectionEquality().hash(_parameters));

  /// Create a copy of SuggestedAction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SuggestedActionImplCopyWith<_$SuggestedActionImpl> get copyWith =>
      __$$SuggestedActionImplCopyWithImpl<_$SuggestedActionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SuggestedActionImplToJson(
      this,
    );
  }
}

abstract class _SuggestedAction implements SuggestedAction {
  const factory _SuggestedAction(
      {required final String id,
      required final String type,
      required final String label,
      required final String icon,
      required final bool isPrimary,
      required final String color,
      final String? description,
      final Map<String, dynamic>? parameters}) = _$SuggestedActionImpl;

  factory _SuggestedAction.fromJson(Map<String, dynamic> json) =
      _$SuggestedActionImpl.fromJson;

  @override
  String get id;
  @override
  String get type; // 'call', 'email', 'payment_plan', 'legal', etc.
  @override
  String get label;
  @override
  String get icon;
  @override
  bool get isPrimary;
  @override
  String get color; // hex color code
  @override
  String? get description;
  @override
  Map<String, dynamic>? get parameters;

  /// Create a copy of SuggestedAction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SuggestedActionImplCopyWith<_$SuggestedActionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DebtTransaction _$DebtTransactionFromJson(Map<String, dynamic> json) {
  return _DebtTransaction.fromJson(json);
}

/// @nodoc
mixin _$DebtTransaction {
  String get id => throw _privateConstructorUsedError;
  String get type =>
      throw _privateConstructorUsedError; // 'invoice', 'payment', 'credit_note', 'adjustment'
  double get amount => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  DateTime get transactionDate => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // 'posted', 'pending', 'cancelled'
  String? get description => throw _privateConstructorUsedError;
  String? get referenceNumber => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this DebtTransaction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DebtTransaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DebtTransactionCopyWith<DebtTransaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DebtTransactionCopyWith<$Res> {
  factory $DebtTransactionCopyWith(
          DebtTransaction value, $Res Function(DebtTransaction) then) =
      _$DebtTransactionCopyWithImpl<$Res, DebtTransaction>;
  @useResult
  $Res call(
      {String id,
      String type,
      double amount,
      String currency,
      DateTime transactionDate,
      String status,
      String? description,
      String? referenceNumber,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$DebtTransactionCopyWithImpl<$Res, $Val extends DebtTransaction>
    implements $DebtTransactionCopyWith<$Res> {
  _$DebtTransactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DebtTransaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? amount = null,
    Object? currency = null,
    Object? transactionDate = null,
    Object? status = null,
    Object? description = freezed,
    Object? referenceNumber = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      transactionDate: null == transactionDate
          ? _value.transactionDate
          : transactionDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      referenceNumber: freezed == referenceNumber
          ? _value.referenceNumber
          : referenceNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DebtTransactionImplCopyWith<$Res>
    implements $DebtTransactionCopyWith<$Res> {
  factory _$$DebtTransactionImplCopyWith(_$DebtTransactionImpl value,
          $Res Function(_$DebtTransactionImpl) then) =
      __$$DebtTransactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String type,
      double amount,
      String currency,
      DateTime transactionDate,
      String status,
      String? description,
      String? referenceNumber,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$DebtTransactionImplCopyWithImpl<$Res>
    extends _$DebtTransactionCopyWithImpl<$Res, _$DebtTransactionImpl>
    implements _$$DebtTransactionImplCopyWith<$Res> {
  __$$DebtTransactionImplCopyWithImpl(
      _$DebtTransactionImpl _value, $Res Function(_$DebtTransactionImpl) _then)
      : super(_value, _then);

  /// Create a copy of DebtTransaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? amount = null,
    Object? currency = null,
    Object? transactionDate = null,
    Object? status = null,
    Object? description = freezed,
    Object? referenceNumber = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$DebtTransactionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      transactionDate: null == transactionDate
          ? _value.transactionDate
          : transactionDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      referenceNumber: freezed == referenceNumber
          ? _value.referenceNumber
          : referenceNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DebtTransactionImpl implements _DebtTransaction {
  const _$DebtTransactionImpl(
      {required this.id,
      required this.type,
      required this.amount,
      required this.currency,
      required this.transactionDate,
      required this.status,
      this.description,
      this.referenceNumber,
      final Map<String, dynamic>? metadata})
      : _metadata = metadata;

  factory _$DebtTransactionImpl.fromJson(Map<String, dynamic> json) =>
      _$$DebtTransactionImplFromJson(json);

  @override
  final String id;
  @override
  final String type;
// 'invoice', 'payment', 'credit_note', 'adjustment'
  @override
  final double amount;
  @override
  final String currency;
  @override
  final DateTime transactionDate;
  @override
  final String status;
// 'posted', 'pending', 'cancelled'
  @override
  final String? description;
  @override
  final String? referenceNumber;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'DebtTransaction(id: $id, type: $type, amount: $amount, currency: $currency, transactionDate: $transactionDate, status: $status, description: $description, referenceNumber: $referenceNumber, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DebtTransactionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.transactionDate, transactionDate) ||
                other.transactionDate == transactionDate) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.referenceNumber, referenceNumber) ||
                other.referenceNumber == referenceNumber) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      type,
      amount,
      currency,
      transactionDate,
      status,
      description,
      referenceNumber,
      const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of DebtTransaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DebtTransactionImplCopyWith<_$DebtTransactionImpl> get copyWith =>
      __$$DebtTransactionImplCopyWithImpl<_$DebtTransactionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DebtTransactionImplToJson(
      this,
    );
  }
}

abstract class _DebtTransaction implements DebtTransaction {
  const factory _DebtTransaction(
      {required final String id,
      required final String type,
      required final double amount,
      required final String currency,
      required final DateTime transactionDate,
      required final String status,
      final String? description,
      final String? referenceNumber,
      final Map<String, dynamic>? metadata}) = _$DebtTransactionImpl;

  factory _DebtTransaction.fromJson(Map<String, dynamic> json) =
      _$DebtTransactionImpl.fromJson;

  @override
  String get id;
  @override
  String get type; // 'invoice', 'payment', 'credit_note', 'adjustment'
  @override
  double get amount;
  @override
  String get currency;
  @override
  DateTime get transactionDate;
  @override
  String get status; // 'posted', 'pending', 'cancelled'
  @override
  String? get description;
  @override
  String? get referenceNumber;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of DebtTransaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DebtTransactionImplCopyWith<_$DebtTransactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SmartDebtOverview _$SmartDebtOverviewFromJson(Map<String, dynamic> json) {
  return _SmartDebtOverview.fromJson(json);
}

/// @nodoc
mixin _$SmartDebtOverview {
  KPIMetrics get kpiMetrics => throw _privateConstructorUsedError;
  AgingAnalysis get agingAnalysis => throw _privateConstructorUsedError;
  List<CriticalAlert> get criticalAlerts => throw _privateConstructorUsedError;
  List<PrioritizedDebt> get topRisks => throw _privateConstructorUsedError;
  String? get viewpointDescription => throw _privateConstructorUsedError;
  DateTime? get lastUpdated => throw _privateConstructorUsedError;

  /// Serializes this SmartDebtOverview to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SmartDebtOverview
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SmartDebtOverviewCopyWith<SmartDebtOverview> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SmartDebtOverviewCopyWith<$Res> {
  factory $SmartDebtOverviewCopyWith(
          SmartDebtOverview value, $Res Function(SmartDebtOverview) then) =
      _$SmartDebtOverviewCopyWithImpl<$Res, SmartDebtOverview>;
  @useResult
  $Res call(
      {KPIMetrics kpiMetrics,
      AgingAnalysis agingAnalysis,
      List<CriticalAlert> criticalAlerts,
      List<PrioritizedDebt> topRisks,
      String? viewpointDescription,
      DateTime? lastUpdated});

  $KPIMetricsCopyWith<$Res> get kpiMetrics;
  $AgingAnalysisCopyWith<$Res> get agingAnalysis;
}

/// @nodoc
class _$SmartDebtOverviewCopyWithImpl<$Res, $Val extends SmartDebtOverview>
    implements $SmartDebtOverviewCopyWith<$Res> {
  _$SmartDebtOverviewCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SmartDebtOverview
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? kpiMetrics = null,
    Object? agingAnalysis = null,
    Object? criticalAlerts = null,
    Object? topRisks = null,
    Object? viewpointDescription = freezed,
    Object? lastUpdated = freezed,
  }) {
    return _then(_value.copyWith(
      kpiMetrics: null == kpiMetrics
          ? _value.kpiMetrics
          : kpiMetrics // ignore: cast_nullable_to_non_nullable
              as KPIMetrics,
      agingAnalysis: null == agingAnalysis
          ? _value.agingAnalysis
          : agingAnalysis // ignore: cast_nullable_to_non_nullable
              as AgingAnalysis,
      criticalAlerts: null == criticalAlerts
          ? _value.criticalAlerts
          : criticalAlerts // ignore: cast_nullable_to_non_nullable
              as List<CriticalAlert>,
      topRisks: null == topRisks
          ? _value.topRisks
          : topRisks // ignore: cast_nullable_to_non_nullable
              as List<PrioritizedDebt>,
      viewpointDescription: freezed == viewpointDescription
          ? _value.viewpointDescription
          : viewpointDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  /// Create a copy of SmartDebtOverview
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $KPIMetricsCopyWith<$Res> get kpiMetrics {
    return $KPIMetricsCopyWith<$Res>(_value.kpiMetrics, (value) {
      return _then(_value.copyWith(kpiMetrics: value) as $Val);
    });
  }

  /// Create a copy of SmartDebtOverview
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AgingAnalysisCopyWith<$Res> get agingAnalysis {
    return $AgingAnalysisCopyWith<$Res>(_value.agingAnalysis, (value) {
      return _then(_value.copyWith(agingAnalysis: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SmartDebtOverviewImplCopyWith<$Res>
    implements $SmartDebtOverviewCopyWith<$Res> {
  factory _$$SmartDebtOverviewImplCopyWith(_$SmartDebtOverviewImpl value,
          $Res Function(_$SmartDebtOverviewImpl) then) =
      __$$SmartDebtOverviewImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {KPIMetrics kpiMetrics,
      AgingAnalysis agingAnalysis,
      List<CriticalAlert> criticalAlerts,
      List<PrioritizedDebt> topRisks,
      String? viewpointDescription,
      DateTime? lastUpdated});

  @override
  $KPIMetricsCopyWith<$Res> get kpiMetrics;
  @override
  $AgingAnalysisCopyWith<$Res> get agingAnalysis;
}

/// @nodoc
class __$$SmartDebtOverviewImplCopyWithImpl<$Res>
    extends _$SmartDebtOverviewCopyWithImpl<$Res, _$SmartDebtOverviewImpl>
    implements _$$SmartDebtOverviewImplCopyWith<$Res> {
  __$$SmartDebtOverviewImplCopyWithImpl(_$SmartDebtOverviewImpl _value,
      $Res Function(_$SmartDebtOverviewImpl) _then)
      : super(_value, _then);

  /// Create a copy of SmartDebtOverview
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? kpiMetrics = null,
    Object? agingAnalysis = null,
    Object? criticalAlerts = null,
    Object? topRisks = null,
    Object? viewpointDescription = freezed,
    Object? lastUpdated = freezed,
  }) {
    return _then(_$SmartDebtOverviewImpl(
      kpiMetrics: null == kpiMetrics
          ? _value.kpiMetrics
          : kpiMetrics // ignore: cast_nullable_to_non_nullable
              as KPIMetrics,
      agingAnalysis: null == agingAnalysis
          ? _value.agingAnalysis
          : agingAnalysis // ignore: cast_nullable_to_non_nullable
              as AgingAnalysis,
      criticalAlerts: null == criticalAlerts
          ? _value._criticalAlerts
          : criticalAlerts // ignore: cast_nullable_to_non_nullable
              as List<CriticalAlert>,
      topRisks: null == topRisks
          ? _value._topRisks
          : topRisks // ignore: cast_nullable_to_non_nullable
              as List<PrioritizedDebt>,
      viewpointDescription: freezed == viewpointDescription
          ? _value.viewpointDescription
          : viewpointDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SmartDebtOverviewImpl implements _SmartDebtOverview {
  const _$SmartDebtOverviewImpl(
      {required this.kpiMetrics,
      required this.agingAnalysis,
      final List<CriticalAlert> criticalAlerts = const [],
      final List<PrioritizedDebt> topRisks = const [],
      this.viewpointDescription,
      this.lastUpdated})
      : _criticalAlerts = criticalAlerts,
        _topRisks = topRisks;

  factory _$SmartDebtOverviewImpl.fromJson(Map<String, dynamic> json) =>
      _$$SmartDebtOverviewImplFromJson(json);

  @override
  final KPIMetrics kpiMetrics;
  @override
  final AgingAnalysis agingAnalysis;
  final List<CriticalAlert> _criticalAlerts;
  @override
  @JsonKey()
  List<CriticalAlert> get criticalAlerts {
    if (_criticalAlerts is EqualUnmodifiableListView) return _criticalAlerts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_criticalAlerts);
  }

  final List<PrioritizedDebt> _topRisks;
  @override
  @JsonKey()
  List<PrioritizedDebt> get topRisks {
    if (_topRisks is EqualUnmodifiableListView) return _topRisks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topRisks);
  }

  @override
  final String? viewpointDescription;
  @override
  final DateTime? lastUpdated;

  @override
  String toString() {
    return 'SmartDebtOverview(kpiMetrics: $kpiMetrics, agingAnalysis: $agingAnalysis, criticalAlerts: $criticalAlerts, topRisks: $topRisks, viewpointDescription: $viewpointDescription, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SmartDebtOverviewImpl &&
            (identical(other.kpiMetrics, kpiMetrics) ||
                other.kpiMetrics == kpiMetrics) &&
            (identical(other.agingAnalysis, agingAnalysis) ||
                other.agingAnalysis == agingAnalysis) &&
            const DeepCollectionEquality()
                .equals(other._criticalAlerts, _criticalAlerts) &&
            const DeepCollectionEquality().equals(other._topRisks, _topRisks) &&
            (identical(other.viewpointDescription, viewpointDescription) ||
                other.viewpointDescription == viewpointDescription) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      kpiMetrics,
      agingAnalysis,
      const DeepCollectionEquality().hash(_criticalAlerts),
      const DeepCollectionEquality().hash(_topRisks),
      viewpointDescription,
      lastUpdated);

  /// Create a copy of SmartDebtOverview
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SmartDebtOverviewImplCopyWith<_$SmartDebtOverviewImpl> get copyWith =>
      __$$SmartDebtOverviewImplCopyWithImpl<_$SmartDebtOverviewImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SmartDebtOverviewImplToJson(
      this,
    );
  }
}

abstract class _SmartDebtOverview implements SmartDebtOverview {
  const factory _SmartDebtOverview(
      {required final KPIMetrics kpiMetrics,
      required final AgingAnalysis agingAnalysis,
      final List<CriticalAlert> criticalAlerts,
      final List<PrioritizedDebt> topRisks,
      final String? viewpointDescription,
      final DateTime? lastUpdated}) = _$SmartDebtOverviewImpl;

  factory _SmartDebtOverview.fromJson(Map<String, dynamic> json) =
      _$SmartDebtOverviewImpl.fromJson;

  @override
  KPIMetrics get kpiMetrics;
  @override
  AgingAnalysis get agingAnalysis;
  @override
  List<CriticalAlert> get criticalAlerts;
  @override
  List<PrioritizedDebt> get topRisks;
  @override
  String? get viewpointDescription;
  @override
  DateTime? get lastUpdated;

  /// Create a copy of SmartDebtOverview
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SmartDebtOverviewImplCopyWith<_$SmartDebtOverviewImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

QuickAction _$QuickActionFromJson(Map<String, dynamic> json) {
  return _QuickAction.fromJson(json);
}

/// @nodoc
mixin _$QuickAction {
  String get id => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  String get icon => throw _privateConstructorUsedError;
  String get color => throw _privateConstructorUsedError;
  bool get isEnabled => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  Map<String, dynamic>? get parameters => throw _privateConstructorUsedError;

  /// Serializes this QuickAction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuickAction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuickActionCopyWith<QuickAction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuickActionCopyWith<$Res> {
  factory $QuickActionCopyWith(
          QuickAction value, $Res Function(QuickAction) then) =
      _$QuickActionCopyWithImpl<$Res, QuickAction>;
  @useResult
  $Res call(
      {String id,
      String type,
      String label,
      String icon,
      String color,
      bool isEnabled,
      String? description,
      Map<String, dynamic>? parameters});
}

/// @nodoc
class _$QuickActionCopyWithImpl<$Res, $Val extends QuickAction>
    implements $QuickActionCopyWith<$Res> {
  _$QuickActionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuickAction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? label = null,
    Object? icon = null,
    Object? color = null,
    Object? isEnabled = null,
    Object? description = freezed,
    Object? parameters = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
      isEnabled: null == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      parameters: freezed == parameters
          ? _value.parameters
          : parameters // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuickActionImplCopyWith<$Res>
    implements $QuickActionCopyWith<$Res> {
  factory _$$QuickActionImplCopyWith(
          _$QuickActionImpl value, $Res Function(_$QuickActionImpl) then) =
      __$$QuickActionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String type,
      String label,
      String icon,
      String color,
      bool isEnabled,
      String? description,
      Map<String, dynamic>? parameters});
}

/// @nodoc
class __$$QuickActionImplCopyWithImpl<$Res>
    extends _$QuickActionCopyWithImpl<$Res, _$QuickActionImpl>
    implements _$$QuickActionImplCopyWith<$Res> {
  __$$QuickActionImplCopyWithImpl(
      _$QuickActionImpl _value, $Res Function(_$QuickActionImpl) _then)
      : super(_value, _then);

  /// Create a copy of QuickAction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? label = null,
    Object? icon = null,
    Object? color = null,
    Object? isEnabled = null,
    Object? description = freezed,
    Object? parameters = freezed,
  }) {
    return _then(_$QuickActionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
      isEnabled: null == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      parameters: freezed == parameters
          ? _value._parameters
          : parameters // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuickActionImpl implements _QuickAction {
  const _$QuickActionImpl(
      {required this.id,
      required this.type,
      required this.label,
      required this.icon,
      required this.color,
      required this.isEnabled,
      this.description,
      final Map<String, dynamic>? parameters})
      : _parameters = parameters;

  factory _$QuickActionImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuickActionImplFromJson(json);

  @override
  final String id;
  @override
  final String type;
  @override
  final String label;
  @override
  final String icon;
  @override
  final String color;
  @override
  final bool isEnabled;
  @override
  final String? description;
  final Map<String, dynamic>? _parameters;
  @override
  Map<String, dynamic>? get parameters {
    final value = _parameters;
    if (value == null) return null;
    if (_parameters is EqualUnmodifiableMapView) return _parameters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'QuickAction(id: $id, type: $type, label: $label, icon: $icon, color: $color, isEnabled: $isEnabled, description: $description, parameters: $parameters)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuickActionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.isEnabled, isEnabled) ||
                other.isEnabled == isEnabled) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other._parameters, _parameters));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, type, label, icon, color,
      isEnabled, description, const DeepCollectionEquality().hash(_parameters));

  /// Create a copy of QuickAction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuickActionImplCopyWith<_$QuickActionImpl> get copyWith =>
      __$$QuickActionImplCopyWithImpl<_$QuickActionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuickActionImplToJson(
      this,
    );
  }
}

abstract class _QuickAction implements QuickAction {
  const factory _QuickAction(
      {required final String id,
      required final String type,
      required final String label,
      required final String icon,
      required final String color,
      required final bool isEnabled,
      final String? description,
      final Map<String, dynamic>? parameters}) = _$QuickActionImpl;

  factory _QuickAction.fromJson(Map<String, dynamic> json) =
      _$QuickActionImpl.fromJson;

  @override
  String get id;
  @override
  String get type;
  @override
  String get label;
  @override
  String get icon;
  @override
  String get color;
  @override
  bool get isEnabled;
  @override
  String? get description;
  @override
  Map<String, dynamic>? get parameters;

  /// Create a copy of QuickAction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuickActionImplCopyWith<_$QuickActionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DebtCommunication _$DebtCommunicationFromJson(Map<String, dynamic> json) {
  return _DebtCommunication.fromJson(json);
}

/// @nodoc
mixin _$DebtCommunication {
  String get id => throw _privateConstructorUsedError;
  String get debtId => throw _privateConstructorUsedError;
  String get type =>
      throw _privateConstructorUsedError; // 'call', 'email', 'letter', 'meeting'
  DateTime get communicationDate => throw _privateConstructorUsedError;
  String get createdBy => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  DateTime? get followUpDate => throw _privateConstructorUsedError;
  bool get isFollowUpCompleted => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this DebtCommunication to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DebtCommunication
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DebtCommunicationCopyWith<DebtCommunication> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DebtCommunicationCopyWith<$Res> {
  factory $DebtCommunicationCopyWith(
          DebtCommunication value, $Res Function(DebtCommunication) then) =
      _$DebtCommunicationCopyWithImpl<$Res, DebtCommunication>;
  @useResult
  $Res call(
      {String id,
      String debtId,
      String type,
      DateTime communicationDate,
      String createdBy,
      String? notes,
      DateTime? followUpDate,
      bool isFollowUpCompleted,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$DebtCommunicationCopyWithImpl<$Res, $Val extends DebtCommunication>
    implements $DebtCommunicationCopyWith<$Res> {
  _$DebtCommunicationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DebtCommunication
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? debtId = null,
    Object? type = null,
    Object? communicationDate = null,
    Object? createdBy = null,
    Object? notes = freezed,
    Object? followUpDate = freezed,
    Object? isFollowUpCompleted = null,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      debtId: null == debtId
          ? _value.debtId
          : debtId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      communicationDate: null == communicationDate
          ? _value.communicationDate
          : communicationDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      followUpDate: freezed == followUpDate
          ? _value.followUpDate
          : followUpDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isFollowUpCompleted: null == isFollowUpCompleted
          ? _value.isFollowUpCompleted
          : isFollowUpCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DebtCommunicationImplCopyWith<$Res>
    implements $DebtCommunicationCopyWith<$Res> {
  factory _$$DebtCommunicationImplCopyWith(_$DebtCommunicationImpl value,
          $Res Function(_$DebtCommunicationImpl) then) =
      __$$DebtCommunicationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String debtId,
      String type,
      DateTime communicationDate,
      String createdBy,
      String? notes,
      DateTime? followUpDate,
      bool isFollowUpCompleted,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$DebtCommunicationImplCopyWithImpl<$Res>
    extends _$DebtCommunicationCopyWithImpl<$Res, _$DebtCommunicationImpl>
    implements _$$DebtCommunicationImplCopyWith<$Res> {
  __$$DebtCommunicationImplCopyWithImpl(_$DebtCommunicationImpl _value,
      $Res Function(_$DebtCommunicationImpl) _then)
      : super(_value, _then);

  /// Create a copy of DebtCommunication
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? debtId = null,
    Object? type = null,
    Object? communicationDate = null,
    Object? createdBy = null,
    Object? notes = freezed,
    Object? followUpDate = freezed,
    Object? isFollowUpCompleted = null,
    Object? metadata = freezed,
  }) {
    return _then(_$DebtCommunicationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      debtId: null == debtId
          ? _value.debtId
          : debtId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      communicationDate: null == communicationDate
          ? _value.communicationDate
          : communicationDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      followUpDate: freezed == followUpDate
          ? _value.followUpDate
          : followUpDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isFollowUpCompleted: null == isFollowUpCompleted
          ? _value.isFollowUpCompleted
          : isFollowUpCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DebtCommunicationImpl implements _DebtCommunication {
  const _$DebtCommunicationImpl(
      {required this.id,
      required this.debtId,
      required this.type,
      required this.communicationDate,
      required this.createdBy,
      this.notes,
      this.followUpDate,
      this.isFollowUpCompleted = false,
      final Map<String, dynamic>? metadata})
      : _metadata = metadata;

  factory _$DebtCommunicationImpl.fromJson(Map<String, dynamic> json) =>
      _$$DebtCommunicationImplFromJson(json);

  @override
  final String id;
  @override
  final String debtId;
  @override
  final String type;
// 'call', 'email', 'letter', 'meeting'
  @override
  final DateTime communicationDate;
  @override
  final String createdBy;
  @override
  final String? notes;
  @override
  final DateTime? followUpDate;
  @override
  @JsonKey()
  final bool isFollowUpCompleted;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'DebtCommunication(id: $id, debtId: $debtId, type: $type, communicationDate: $communicationDate, createdBy: $createdBy, notes: $notes, followUpDate: $followUpDate, isFollowUpCompleted: $isFollowUpCompleted, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DebtCommunicationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.debtId, debtId) || other.debtId == debtId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.communicationDate, communicationDate) ||
                other.communicationDate == communicationDate) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.followUpDate, followUpDate) ||
                other.followUpDate == followUpDate) &&
            (identical(other.isFollowUpCompleted, isFollowUpCompleted) ||
                other.isFollowUpCompleted == isFollowUpCompleted) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      debtId,
      type,
      communicationDate,
      createdBy,
      notes,
      followUpDate,
      isFollowUpCompleted,
      const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of DebtCommunication
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DebtCommunicationImplCopyWith<_$DebtCommunicationImpl> get copyWith =>
      __$$DebtCommunicationImplCopyWithImpl<_$DebtCommunicationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DebtCommunicationImplToJson(
      this,
    );
  }
}

abstract class _DebtCommunication implements DebtCommunication {
  const factory _DebtCommunication(
      {required final String id,
      required final String debtId,
      required final String type,
      required final DateTime communicationDate,
      required final String createdBy,
      final String? notes,
      final DateTime? followUpDate,
      final bool isFollowUpCompleted,
      final Map<String, dynamic>? metadata}) = _$DebtCommunicationImpl;

  factory _DebtCommunication.fromJson(Map<String, dynamic> json) =
      _$DebtCommunicationImpl.fromJson;

  @override
  String get id;
  @override
  String get debtId;
  @override
  String get type; // 'call', 'email', 'letter', 'meeting'
  @override
  DateTime get communicationDate;
  @override
  String get createdBy;
  @override
  String? get notes;
  @override
  DateTime? get followUpDate;
  @override
  bool get isFollowUpCompleted;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of DebtCommunication
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DebtCommunicationImplCopyWith<_$DebtCommunicationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PaymentPlan _$PaymentPlanFromJson(Map<String, dynamic> json) {
  return _PaymentPlan.fromJson(json);
}

/// @nodoc
mixin _$PaymentPlan {
  String get id => throw _privateConstructorUsedError;
  String get debtId => throw _privateConstructorUsedError;
  double get totalAmount => throw _privateConstructorUsedError;
  double get installmentAmount => throw _privateConstructorUsedError;
  String get frequency =>
      throw _privateConstructorUsedError; // 'weekly', 'monthly', 'quarterly'
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // 'active', 'completed', 'defaulted', 'cancelled'
  List<PaymentPlanInstallment> get installments =>
      throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this PaymentPlan to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaymentPlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentPlanCopyWith<PaymentPlan> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentPlanCopyWith<$Res> {
  factory $PaymentPlanCopyWith(
          PaymentPlan value, $Res Function(PaymentPlan) then) =
      _$PaymentPlanCopyWithImpl<$Res, PaymentPlan>;
  @useResult
  $Res call(
      {String id,
      String debtId,
      double totalAmount,
      double installmentAmount,
      String frequency,
      DateTime startDate,
      DateTime endDate,
      String status,
      List<PaymentPlanInstallment> installments,
      DateTime? createdAt,
      String? notes});
}

/// @nodoc
class _$PaymentPlanCopyWithImpl<$Res, $Val extends PaymentPlan>
    implements $PaymentPlanCopyWith<$Res> {
  _$PaymentPlanCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentPlan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? debtId = null,
    Object? totalAmount = null,
    Object? installmentAmount = null,
    Object? frequency = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? status = null,
    Object? installments = null,
    Object? createdAt = freezed,
    Object? notes = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      debtId: null == debtId
          ? _value.debtId
          : debtId // ignore: cast_nullable_to_non_nullable
              as String,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      installmentAmount: null == installmentAmount
          ? _value.installmentAmount
          : installmentAmount // ignore: cast_nullable_to_non_nullable
              as double,
      frequency: null == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      installments: null == installments
          ? _value.installments
          : installments // ignore: cast_nullable_to_non_nullable
              as List<PaymentPlanInstallment>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaymentPlanImplCopyWith<$Res>
    implements $PaymentPlanCopyWith<$Res> {
  factory _$$PaymentPlanImplCopyWith(
          _$PaymentPlanImpl value, $Res Function(_$PaymentPlanImpl) then) =
      __$$PaymentPlanImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String debtId,
      double totalAmount,
      double installmentAmount,
      String frequency,
      DateTime startDate,
      DateTime endDate,
      String status,
      List<PaymentPlanInstallment> installments,
      DateTime? createdAt,
      String? notes});
}

/// @nodoc
class __$$PaymentPlanImplCopyWithImpl<$Res>
    extends _$PaymentPlanCopyWithImpl<$Res, _$PaymentPlanImpl>
    implements _$$PaymentPlanImplCopyWith<$Res> {
  __$$PaymentPlanImplCopyWithImpl(
      _$PaymentPlanImpl _value, $Res Function(_$PaymentPlanImpl) _then)
      : super(_value, _then);

  /// Create a copy of PaymentPlan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? debtId = null,
    Object? totalAmount = null,
    Object? installmentAmount = null,
    Object? frequency = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? status = null,
    Object? installments = null,
    Object? createdAt = freezed,
    Object? notes = freezed,
  }) {
    return _then(_$PaymentPlanImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      debtId: null == debtId
          ? _value.debtId
          : debtId // ignore: cast_nullable_to_non_nullable
              as String,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      installmentAmount: null == installmentAmount
          ? _value.installmentAmount
          : installmentAmount // ignore: cast_nullable_to_non_nullable
              as double,
      frequency: null == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      installments: null == installments
          ? _value._installments
          : installments // ignore: cast_nullable_to_non_nullable
              as List<PaymentPlanInstallment>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentPlanImpl implements _PaymentPlan {
  const _$PaymentPlanImpl(
      {required this.id,
      required this.debtId,
      required this.totalAmount,
      required this.installmentAmount,
      required this.frequency,
      required this.startDate,
      required this.endDate,
      required this.status,
      final List<PaymentPlanInstallment> installments = const [],
      this.createdAt,
      this.notes})
      : _installments = installments;

  factory _$PaymentPlanImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentPlanImplFromJson(json);

  @override
  final String id;
  @override
  final String debtId;
  @override
  final double totalAmount;
  @override
  final double installmentAmount;
  @override
  final String frequency;
// 'weekly', 'monthly', 'quarterly'
  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  @override
  final String status;
// 'active', 'completed', 'defaulted', 'cancelled'
  final List<PaymentPlanInstallment> _installments;
// 'active', 'completed', 'defaulted', 'cancelled'
  @override
  @JsonKey()
  List<PaymentPlanInstallment> get installments {
    if (_installments is EqualUnmodifiableListView) return _installments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_installments);
  }

  @override
  final DateTime? createdAt;
  @override
  final String? notes;

  @override
  String toString() {
    return 'PaymentPlan(id: $id, debtId: $debtId, totalAmount: $totalAmount, installmentAmount: $installmentAmount, frequency: $frequency, startDate: $startDate, endDate: $endDate, status: $status, installments: $installments, createdAt: $createdAt, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentPlanImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.debtId, debtId) || other.debtId == debtId) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.installmentAmount, installmentAmount) ||
                other.installmentAmount == installmentAmount) &&
            (identical(other.frequency, frequency) ||
                other.frequency == frequency) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality()
                .equals(other._installments, _installments) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      debtId,
      totalAmount,
      installmentAmount,
      frequency,
      startDate,
      endDate,
      status,
      const DeepCollectionEquality().hash(_installments),
      createdAt,
      notes);

  /// Create a copy of PaymentPlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentPlanImplCopyWith<_$PaymentPlanImpl> get copyWith =>
      __$$PaymentPlanImplCopyWithImpl<_$PaymentPlanImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentPlanImplToJson(
      this,
    );
  }
}

abstract class _PaymentPlan implements PaymentPlan {
  const factory _PaymentPlan(
      {required final String id,
      required final String debtId,
      required final double totalAmount,
      required final double installmentAmount,
      required final String frequency,
      required final DateTime startDate,
      required final DateTime endDate,
      required final String status,
      final List<PaymentPlanInstallment> installments,
      final DateTime? createdAt,
      final String? notes}) = _$PaymentPlanImpl;

  factory _PaymentPlan.fromJson(Map<String, dynamic> json) =
      _$PaymentPlanImpl.fromJson;

  @override
  String get id;
  @override
  String get debtId;
  @override
  double get totalAmount;
  @override
  double get installmentAmount;
  @override
  String get frequency; // 'weekly', 'monthly', 'quarterly'
  @override
  DateTime get startDate;
  @override
  DateTime get endDate;
  @override
  String get status; // 'active', 'completed', 'defaulted', 'cancelled'
  @override
  List<PaymentPlanInstallment> get installments;
  @override
  DateTime? get createdAt;
  @override
  String? get notes;

  /// Create a copy of PaymentPlan
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentPlanImplCopyWith<_$PaymentPlanImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PaymentPlanInstallment _$PaymentPlanInstallmentFromJson(
    Map<String, dynamic> json) {
  return _PaymentPlanInstallment.fromJson(json);
}

/// @nodoc
mixin _$PaymentPlanInstallment {
  String get id => throw _privateConstructorUsedError;
  String get paymentPlanId => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  DateTime get dueDate => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // 'pending', 'paid', 'overdue', 'partial'
  double get paidAmount => throw _privateConstructorUsedError;
  DateTime? get paidDate => throw _privateConstructorUsedError;
  String? get paymentReference => throw _privateConstructorUsedError;

  /// Serializes this PaymentPlanInstallment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaymentPlanInstallment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentPlanInstallmentCopyWith<PaymentPlanInstallment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentPlanInstallmentCopyWith<$Res> {
  factory $PaymentPlanInstallmentCopyWith(PaymentPlanInstallment value,
          $Res Function(PaymentPlanInstallment) then) =
      _$PaymentPlanInstallmentCopyWithImpl<$Res, PaymentPlanInstallment>;
  @useResult
  $Res call(
      {String id,
      String paymentPlanId,
      double amount,
      DateTime dueDate,
      String status,
      double paidAmount,
      DateTime? paidDate,
      String? paymentReference});
}

/// @nodoc
class _$PaymentPlanInstallmentCopyWithImpl<$Res,
        $Val extends PaymentPlanInstallment>
    implements $PaymentPlanInstallmentCopyWith<$Res> {
  _$PaymentPlanInstallmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentPlanInstallment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? paymentPlanId = null,
    Object? amount = null,
    Object? dueDate = null,
    Object? status = null,
    Object? paidAmount = null,
    Object? paidDate = freezed,
    Object? paymentReference = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      paymentPlanId: null == paymentPlanId
          ? _value.paymentPlanId
          : paymentPlanId // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      dueDate: null == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      paidAmount: null == paidAmount
          ? _value.paidAmount
          : paidAmount // ignore: cast_nullable_to_non_nullable
              as double,
      paidDate: freezed == paidDate
          ? _value.paidDate
          : paidDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      paymentReference: freezed == paymentReference
          ? _value.paymentReference
          : paymentReference // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaymentPlanInstallmentImplCopyWith<$Res>
    implements $PaymentPlanInstallmentCopyWith<$Res> {
  factory _$$PaymentPlanInstallmentImplCopyWith(
          _$PaymentPlanInstallmentImpl value,
          $Res Function(_$PaymentPlanInstallmentImpl) then) =
      __$$PaymentPlanInstallmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String paymentPlanId,
      double amount,
      DateTime dueDate,
      String status,
      double paidAmount,
      DateTime? paidDate,
      String? paymentReference});
}

/// @nodoc
class __$$PaymentPlanInstallmentImplCopyWithImpl<$Res>
    extends _$PaymentPlanInstallmentCopyWithImpl<$Res,
        _$PaymentPlanInstallmentImpl>
    implements _$$PaymentPlanInstallmentImplCopyWith<$Res> {
  __$$PaymentPlanInstallmentImplCopyWithImpl(
      _$PaymentPlanInstallmentImpl _value,
      $Res Function(_$PaymentPlanInstallmentImpl) _then)
      : super(_value, _then);

  /// Create a copy of PaymentPlanInstallment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? paymentPlanId = null,
    Object? amount = null,
    Object? dueDate = null,
    Object? status = null,
    Object? paidAmount = null,
    Object? paidDate = freezed,
    Object? paymentReference = freezed,
  }) {
    return _then(_$PaymentPlanInstallmentImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      paymentPlanId: null == paymentPlanId
          ? _value.paymentPlanId
          : paymentPlanId // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      dueDate: null == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      paidAmount: null == paidAmount
          ? _value.paidAmount
          : paidAmount // ignore: cast_nullable_to_non_nullable
              as double,
      paidDate: freezed == paidDate
          ? _value.paidDate
          : paidDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      paymentReference: freezed == paymentReference
          ? _value.paymentReference
          : paymentReference // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentPlanInstallmentImpl implements _PaymentPlanInstallment {
  const _$PaymentPlanInstallmentImpl(
      {required this.id,
      required this.paymentPlanId,
      required this.amount,
      required this.dueDate,
      required this.status,
      this.paidAmount = 0.0,
      this.paidDate,
      this.paymentReference});

  factory _$PaymentPlanInstallmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentPlanInstallmentImplFromJson(json);

  @override
  final String id;
  @override
  final String paymentPlanId;
  @override
  final double amount;
  @override
  final DateTime dueDate;
  @override
  final String status;
// 'pending', 'paid', 'overdue', 'partial'
  @override
  @JsonKey()
  final double paidAmount;
  @override
  final DateTime? paidDate;
  @override
  final String? paymentReference;

  @override
  String toString() {
    return 'PaymentPlanInstallment(id: $id, paymentPlanId: $paymentPlanId, amount: $amount, dueDate: $dueDate, status: $status, paidAmount: $paidAmount, paidDate: $paidDate, paymentReference: $paymentReference)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentPlanInstallmentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.paymentPlanId, paymentPlanId) ||
                other.paymentPlanId == paymentPlanId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.paidAmount, paidAmount) ||
                other.paidAmount == paidAmount) &&
            (identical(other.paidDate, paidDate) ||
                other.paidDate == paidDate) &&
            (identical(other.paymentReference, paymentReference) ||
                other.paymentReference == paymentReference));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, paymentPlanId, amount,
      dueDate, status, paidAmount, paidDate, paymentReference);

  /// Create a copy of PaymentPlanInstallment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentPlanInstallmentImplCopyWith<_$PaymentPlanInstallmentImpl>
      get copyWith => __$$PaymentPlanInstallmentImplCopyWithImpl<
          _$PaymentPlanInstallmentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentPlanInstallmentImplToJson(
      this,
    );
  }
}

abstract class _PaymentPlanInstallment implements PaymentPlanInstallment {
  const factory _PaymentPlanInstallment(
      {required final String id,
      required final String paymentPlanId,
      required final double amount,
      required final DateTime dueDate,
      required final String status,
      final double paidAmount,
      final DateTime? paidDate,
      final String? paymentReference}) = _$PaymentPlanInstallmentImpl;

  factory _PaymentPlanInstallment.fromJson(Map<String, dynamic> json) =
      _$PaymentPlanInstallmentImpl.fromJson;

  @override
  String get id;
  @override
  String get paymentPlanId;
  @override
  double get amount;
  @override
  DateTime get dueDate;
  @override
  String get status; // 'pending', 'paid', 'overdue', 'partial'
  @override
  double get paidAmount;
  @override
  DateTime? get paidDate;
  @override
  String? get paymentReference;

  /// Create a copy of PaymentPlanInstallment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentPlanInstallmentImplCopyWith<_$PaymentPlanInstallmentImpl>
      get copyWith => throw _privateConstructorUsedError;
}

DebtFilter _$DebtFilterFromJson(Map<String, dynamic> json) {
  return _DebtFilter.fromJson(json);
}

/// @nodoc
mixin _$DebtFilter {
  String get counterpartyType =>
      throw _privateConstructorUsedError; // 'all', 'group', 'external', 'customer', 'vendor'
  String get riskCategory =>
      throw _privateConstructorUsedError; // 'all', 'critical', 'attention', 'watch', 'current'
  String get paymentStatus =>
      throw _privateConstructorUsedError; // 'all', 'overdue', 'current', 'disputed'
  int get minDaysOverdue => throw _privateConstructorUsedError;
  double get minAmount => throw _privateConstructorUsedError;
  bool get hasPaymentPlan => throw _privateConstructorUsedError;
  bool get isDisputed => throw _privateConstructorUsedError;
  DateTime? get fromDate => throw _privateConstructorUsedError;
  DateTime? get toDate => throw _privateConstructorUsedError;
  String? get searchQuery => throw _privateConstructorUsedError;

  /// Serializes this DebtFilter to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DebtFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DebtFilterCopyWith<DebtFilter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DebtFilterCopyWith<$Res> {
  factory $DebtFilterCopyWith(
          DebtFilter value, $Res Function(DebtFilter) then) =
      _$DebtFilterCopyWithImpl<$Res, DebtFilter>;
  @useResult
  $Res call(
      {String counterpartyType,
      String riskCategory,
      String paymentStatus,
      int minDaysOverdue,
      double minAmount,
      bool hasPaymentPlan,
      bool isDisputed,
      DateTime? fromDate,
      DateTime? toDate,
      String? searchQuery});
}

/// @nodoc
class _$DebtFilterCopyWithImpl<$Res, $Val extends DebtFilter>
    implements $DebtFilterCopyWith<$Res> {
  _$DebtFilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DebtFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? counterpartyType = null,
    Object? riskCategory = null,
    Object? paymentStatus = null,
    Object? minDaysOverdue = null,
    Object? minAmount = null,
    Object? hasPaymentPlan = null,
    Object? isDisputed = null,
    Object? fromDate = freezed,
    Object? toDate = freezed,
    Object? searchQuery = freezed,
  }) {
    return _then(_value.copyWith(
      counterpartyType: null == counterpartyType
          ? _value.counterpartyType
          : counterpartyType // ignore: cast_nullable_to_non_nullable
              as String,
      riskCategory: null == riskCategory
          ? _value.riskCategory
          : riskCategory // ignore: cast_nullable_to_non_nullable
              as String,
      paymentStatus: null == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as String,
      minDaysOverdue: null == minDaysOverdue
          ? _value.minDaysOverdue
          : minDaysOverdue // ignore: cast_nullable_to_non_nullable
              as int,
      minAmount: null == minAmount
          ? _value.minAmount
          : minAmount // ignore: cast_nullable_to_non_nullable
              as double,
      hasPaymentPlan: null == hasPaymentPlan
          ? _value.hasPaymentPlan
          : hasPaymentPlan // ignore: cast_nullable_to_non_nullable
              as bool,
      isDisputed: null == isDisputed
          ? _value.isDisputed
          : isDisputed // ignore: cast_nullable_to_non_nullable
              as bool,
      fromDate: freezed == fromDate
          ? _value.fromDate
          : fromDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      toDate: freezed == toDate
          ? _value.toDate
          : toDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      searchQuery: freezed == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DebtFilterImplCopyWith<$Res>
    implements $DebtFilterCopyWith<$Res> {
  factory _$$DebtFilterImplCopyWith(
          _$DebtFilterImpl value, $Res Function(_$DebtFilterImpl) then) =
      __$$DebtFilterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String counterpartyType,
      String riskCategory,
      String paymentStatus,
      int minDaysOverdue,
      double minAmount,
      bool hasPaymentPlan,
      bool isDisputed,
      DateTime? fromDate,
      DateTime? toDate,
      String? searchQuery});
}

/// @nodoc
class __$$DebtFilterImplCopyWithImpl<$Res>
    extends _$DebtFilterCopyWithImpl<$Res, _$DebtFilterImpl>
    implements _$$DebtFilterImplCopyWith<$Res> {
  __$$DebtFilterImplCopyWithImpl(
      _$DebtFilterImpl _value, $Res Function(_$DebtFilterImpl) _then)
      : super(_value, _then);

  /// Create a copy of DebtFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? counterpartyType = null,
    Object? riskCategory = null,
    Object? paymentStatus = null,
    Object? minDaysOverdue = null,
    Object? minAmount = null,
    Object? hasPaymentPlan = null,
    Object? isDisputed = null,
    Object? fromDate = freezed,
    Object? toDate = freezed,
    Object? searchQuery = freezed,
  }) {
    return _then(_$DebtFilterImpl(
      counterpartyType: null == counterpartyType
          ? _value.counterpartyType
          : counterpartyType // ignore: cast_nullable_to_non_nullable
              as String,
      riskCategory: null == riskCategory
          ? _value.riskCategory
          : riskCategory // ignore: cast_nullable_to_non_nullable
              as String,
      paymentStatus: null == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as String,
      minDaysOverdue: null == minDaysOverdue
          ? _value.minDaysOverdue
          : minDaysOverdue // ignore: cast_nullable_to_non_nullable
              as int,
      minAmount: null == minAmount
          ? _value.minAmount
          : minAmount // ignore: cast_nullable_to_non_nullable
              as double,
      hasPaymentPlan: null == hasPaymentPlan
          ? _value.hasPaymentPlan
          : hasPaymentPlan // ignore: cast_nullable_to_non_nullable
              as bool,
      isDisputed: null == isDisputed
          ? _value.isDisputed
          : isDisputed // ignore: cast_nullable_to_non_nullable
              as bool,
      fromDate: freezed == fromDate
          ? _value.fromDate
          : fromDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      toDate: freezed == toDate
          ? _value.toDate
          : toDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      searchQuery: freezed == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DebtFilterImpl implements _DebtFilter {
  const _$DebtFilterImpl(
      {this.counterpartyType = 'all',
      this.riskCategory = 'all',
      this.paymentStatus = 'all',
      this.minDaysOverdue = 0,
      this.minAmount = 0.0,
      this.hasPaymentPlan = false,
      this.isDisputed = false,
      this.fromDate,
      this.toDate,
      this.searchQuery});

  factory _$DebtFilterImpl.fromJson(Map<String, dynamic> json) =>
      _$$DebtFilterImplFromJson(json);

  @override
  @JsonKey()
  final String counterpartyType;
// 'all', 'group', 'external', 'customer', 'vendor'
  @override
  @JsonKey()
  final String riskCategory;
// 'all', 'critical', 'attention', 'watch', 'current'
  @override
  @JsonKey()
  final String paymentStatus;
// 'all', 'overdue', 'current', 'disputed'
  @override
  @JsonKey()
  final int minDaysOverdue;
  @override
  @JsonKey()
  final double minAmount;
  @override
  @JsonKey()
  final bool hasPaymentPlan;
  @override
  @JsonKey()
  final bool isDisputed;
  @override
  final DateTime? fromDate;
  @override
  final DateTime? toDate;
  @override
  final String? searchQuery;

  @override
  String toString() {
    return 'DebtFilter(counterpartyType: $counterpartyType, riskCategory: $riskCategory, paymentStatus: $paymentStatus, minDaysOverdue: $minDaysOverdue, minAmount: $minAmount, hasPaymentPlan: $hasPaymentPlan, isDisputed: $isDisputed, fromDate: $fromDate, toDate: $toDate, searchQuery: $searchQuery)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DebtFilterImpl &&
            (identical(other.counterpartyType, counterpartyType) ||
                other.counterpartyType == counterpartyType) &&
            (identical(other.riskCategory, riskCategory) ||
                other.riskCategory == riskCategory) &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus) &&
            (identical(other.minDaysOverdue, minDaysOverdue) ||
                other.minDaysOverdue == minDaysOverdue) &&
            (identical(other.minAmount, minAmount) ||
                other.minAmount == minAmount) &&
            (identical(other.hasPaymentPlan, hasPaymentPlan) ||
                other.hasPaymentPlan == hasPaymentPlan) &&
            (identical(other.isDisputed, isDisputed) ||
                other.isDisputed == isDisputed) &&
            (identical(other.fromDate, fromDate) ||
                other.fromDate == fromDate) &&
            (identical(other.toDate, toDate) || other.toDate == toDate) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      counterpartyType,
      riskCategory,
      paymentStatus,
      minDaysOverdue,
      minAmount,
      hasPaymentPlan,
      isDisputed,
      fromDate,
      toDate,
      searchQuery);

  /// Create a copy of DebtFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DebtFilterImplCopyWith<_$DebtFilterImpl> get copyWith =>
      __$$DebtFilterImplCopyWithImpl<_$DebtFilterImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DebtFilterImplToJson(
      this,
    );
  }
}

abstract class _DebtFilter implements DebtFilter {
  const factory _DebtFilter(
      {final String counterpartyType,
      final String riskCategory,
      final String paymentStatus,
      final int minDaysOverdue,
      final double minAmount,
      final bool hasPaymentPlan,
      final bool isDisputed,
      final DateTime? fromDate,
      final DateTime? toDate,
      final String? searchQuery}) = _$DebtFilterImpl;

  factory _DebtFilter.fromJson(Map<String, dynamic> json) =
      _$DebtFilterImpl.fromJson;

  @override
  String
      get counterpartyType; // 'all', 'group', 'external', 'customer', 'vendor'
  @override
  String get riskCategory; // 'all', 'critical', 'attention', 'watch', 'current'
  @override
  String get paymentStatus; // 'all', 'overdue', 'current', 'disputed'
  @override
  int get minDaysOverdue;
  @override
  double get minAmount;
  @override
  bool get hasPaymentPlan;
  @override
  bool get isDisputed;
  @override
  DateTime? get fromDate;
  @override
  DateTime? get toDate;
  @override
  String? get searchQuery;

  /// Create a copy of DebtFilter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DebtFilterImplCopyWith<_$DebtFilterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DebtAnalytics _$DebtAnalyticsFromJson(Map<String, dynamic> json) {
  return _DebtAnalytics.fromJson(json);
}

/// @nodoc
mixin _$DebtAnalytics {
  AgingAnalysis get currentAging => throw _privateConstructorUsedError;
  List<AgingTrendPoint> get agingTrend => throw _privateConstructorUsedError;
  double get collectionEfficiency => throw _privateConstructorUsedError;
  List<CollectionTrendPoint> get collectionTrend =>
      throw _privateConstructorUsedError;
  Map<String, double> get riskDistribution =>
      throw _privateConstructorUsedError;
  List<CounterpartyRiskScore> get topRisks =>
      throw _privateConstructorUsedError;
  DateTime? get reportDate => throw _privateConstructorUsedError;

  /// Serializes this DebtAnalytics to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DebtAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DebtAnalyticsCopyWith<DebtAnalytics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DebtAnalyticsCopyWith<$Res> {
  factory $DebtAnalyticsCopyWith(
          DebtAnalytics value, $Res Function(DebtAnalytics) then) =
      _$DebtAnalyticsCopyWithImpl<$Res, DebtAnalytics>;
  @useResult
  $Res call(
      {AgingAnalysis currentAging,
      List<AgingTrendPoint> agingTrend,
      double collectionEfficiency,
      List<CollectionTrendPoint> collectionTrend,
      Map<String, double> riskDistribution,
      List<CounterpartyRiskScore> topRisks,
      DateTime? reportDate});

  $AgingAnalysisCopyWith<$Res> get currentAging;
}

/// @nodoc
class _$DebtAnalyticsCopyWithImpl<$Res, $Val extends DebtAnalytics>
    implements $DebtAnalyticsCopyWith<$Res> {
  _$DebtAnalyticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DebtAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentAging = null,
    Object? agingTrend = null,
    Object? collectionEfficiency = null,
    Object? collectionTrend = null,
    Object? riskDistribution = null,
    Object? topRisks = null,
    Object? reportDate = freezed,
  }) {
    return _then(_value.copyWith(
      currentAging: null == currentAging
          ? _value.currentAging
          : currentAging // ignore: cast_nullable_to_non_nullable
              as AgingAnalysis,
      agingTrend: null == agingTrend
          ? _value.agingTrend
          : agingTrend // ignore: cast_nullable_to_non_nullable
              as List<AgingTrendPoint>,
      collectionEfficiency: null == collectionEfficiency
          ? _value.collectionEfficiency
          : collectionEfficiency // ignore: cast_nullable_to_non_nullable
              as double,
      collectionTrend: null == collectionTrend
          ? _value.collectionTrend
          : collectionTrend // ignore: cast_nullable_to_non_nullable
              as List<CollectionTrendPoint>,
      riskDistribution: null == riskDistribution
          ? _value.riskDistribution
          : riskDistribution // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      topRisks: null == topRisks
          ? _value.topRisks
          : topRisks // ignore: cast_nullable_to_non_nullable
              as List<CounterpartyRiskScore>,
      reportDate: freezed == reportDate
          ? _value.reportDate
          : reportDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  /// Create a copy of DebtAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AgingAnalysisCopyWith<$Res> get currentAging {
    return $AgingAnalysisCopyWith<$Res>(_value.currentAging, (value) {
      return _then(_value.copyWith(currentAging: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DebtAnalyticsImplCopyWith<$Res>
    implements $DebtAnalyticsCopyWith<$Res> {
  factory _$$DebtAnalyticsImplCopyWith(
          _$DebtAnalyticsImpl value, $Res Function(_$DebtAnalyticsImpl) then) =
      __$$DebtAnalyticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {AgingAnalysis currentAging,
      List<AgingTrendPoint> agingTrend,
      double collectionEfficiency,
      List<CollectionTrendPoint> collectionTrend,
      Map<String, double> riskDistribution,
      List<CounterpartyRiskScore> topRisks,
      DateTime? reportDate});

  @override
  $AgingAnalysisCopyWith<$Res> get currentAging;
}

/// @nodoc
class __$$DebtAnalyticsImplCopyWithImpl<$Res>
    extends _$DebtAnalyticsCopyWithImpl<$Res, _$DebtAnalyticsImpl>
    implements _$$DebtAnalyticsImplCopyWith<$Res> {
  __$$DebtAnalyticsImplCopyWithImpl(
      _$DebtAnalyticsImpl _value, $Res Function(_$DebtAnalyticsImpl) _then)
      : super(_value, _then);

  /// Create a copy of DebtAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentAging = null,
    Object? agingTrend = null,
    Object? collectionEfficiency = null,
    Object? collectionTrend = null,
    Object? riskDistribution = null,
    Object? topRisks = null,
    Object? reportDate = freezed,
  }) {
    return _then(_$DebtAnalyticsImpl(
      currentAging: null == currentAging
          ? _value.currentAging
          : currentAging // ignore: cast_nullable_to_non_nullable
              as AgingAnalysis,
      agingTrend: null == agingTrend
          ? _value._agingTrend
          : agingTrend // ignore: cast_nullable_to_non_nullable
              as List<AgingTrendPoint>,
      collectionEfficiency: null == collectionEfficiency
          ? _value.collectionEfficiency
          : collectionEfficiency // ignore: cast_nullable_to_non_nullable
              as double,
      collectionTrend: null == collectionTrend
          ? _value._collectionTrend
          : collectionTrend // ignore: cast_nullable_to_non_nullable
              as List<CollectionTrendPoint>,
      riskDistribution: null == riskDistribution
          ? _value._riskDistribution
          : riskDistribution // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      topRisks: null == topRisks
          ? _value._topRisks
          : topRisks // ignore: cast_nullable_to_non_nullable
              as List<CounterpartyRiskScore>,
      reportDate: freezed == reportDate
          ? _value.reportDate
          : reportDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DebtAnalyticsImpl implements _DebtAnalytics {
  const _$DebtAnalyticsImpl(
      {required this.currentAging,
      final List<AgingTrendPoint> agingTrend = const [],
      required this.collectionEfficiency,
      final List<CollectionTrendPoint> collectionTrend = const [],
      required final Map<String, double> riskDistribution,
      final List<CounterpartyRiskScore> topRisks = const [],
      this.reportDate})
      : _agingTrend = agingTrend,
        _collectionTrend = collectionTrend,
        _riskDistribution = riskDistribution,
        _topRisks = topRisks;

  factory _$DebtAnalyticsImpl.fromJson(Map<String, dynamic> json) =>
      _$$DebtAnalyticsImplFromJson(json);

  @override
  final AgingAnalysis currentAging;
  final List<AgingTrendPoint> _agingTrend;
  @override
  @JsonKey()
  List<AgingTrendPoint> get agingTrend {
    if (_agingTrend is EqualUnmodifiableListView) return _agingTrend;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_agingTrend);
  }

  @override
  final double collectionEfficiency;
  final List<CollectionTrendPoint> _collectionTrend;
  @override
  @JsonKey()
  List<CollectionTrendPoint> get collectionTrend {
    if (_collectionTrend is EqualUnmodifiableListView) return _collectionTrend;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_collectionTrend);
  }

  final Map<String, double> _riskDistribution;
  @override
  Map<String, double> get riskDistribution {
    if (_riskDistribution is EqualUnmodifiableMapView) return _riskDistribution;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_riskDistribution);
  }

  final List<CounterpartyRiskScore> _topRisks;
  @override
  @JsonKey()
  List<CounterpartyRiskScore> get topRisks {
    if (_topRisks is EqualUnmodifiableListView) return _topRisks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topRisks);
  }

  @override
  final DateTime? reportDate;

  @override
  String toString() {
    return 'DebtAnalytics(currentAging: $currentAging, agingTrend: $agingTrend, collectionEfficiency: $collectionEfficiency, collectionTrend: $collectionTrend, riskDistribution: $riskDistribution, topRisks: $topRisks, reportDate: $reportDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DebtAnalyticsImpl &&
            (identical(other.currentAging, currentAging) ||
                other.currentAging == currentAging) &&
            const DeepCollectionEquality()
                .equals(other._agingTrend, _agingTrend) &&
            (identical(other.collectionEfficiency, collectionEfficiency) ||
                other.collectionEfficiency == collectionEfficiency) &&
            const DeepCollectionEquality()
                .equals(other._collectionTrend, _collectionTrend) &&
            const DeepCollectionEquality()
                .equals(other._riskDistribution, _riskDistribution) &&
            const DeepCollectionEquality().equals(other._topRisks, _topRisks) &&
            (identical(other.reportDate, reportDate) ||
                other.reportDate == reportDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      currentAging,
      const DeepCollectionEquality().hash(_agingTrend),
      collectionEfficiency,
      const DeepCollectionEquality().hash(_collectionTrend),
      const DeepCollectionEquality().hash(_riskDistribution),
      const DeepCollectionEquality().hash(_topRisks),
      reportDate);

  /// Create a copy of DebtAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DebtAnalyticsImplCopyWith<_$DebtAnalyticsImpl> get copyWith =>
      __$$DebtAnalyticsImplCopyWithImpl<_$DebtAnalyticsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DebtAnalyticsImplToJson(
      this,
    );
  }
}

abstract class _DebtAnalytics implements DebtAnalytics {
  const factory _DebtAnalytics(
      {required final AgingAnalysis currentAging,
      final List<AgingTrendPoint> agingTrend,
      required final double collectionEfficiency,
      final List<CollectionTrendPoint> collectionTrend,
      required final Map<String, double> riskDistribution,
      final List<CounterpartyRiskScore> topRisks,
      final DateTime? reportDate}) = _$DebtAnalyticsImpl;

  factory _DebtAnalytics.fromJson(Map<String, dynamic> json) =
      _$DebtAnalyticsImpl.fromJson;

  @override
  AgingAnalysis get currentAging;
  @override
  List<AgingTrendPoint> get agingTrend;
  @override
  double get collectionEfficiency;
  @override
  List<CollectionTrendPoint> get collectionTrend;
  @override
  Map<String, double> get riskDistribution;
  @override
  List<CounterpartyRiskScore> get topRisks;
  @override
  DateTime? get reportDate;

  /// Create a copy of DebtAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DebtAnalyticsImplCopyWith<_$DebtAnalyticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CollectionTrendPoint _$CollectionTrendPointFromJson(Map<String, dynamic> json) {
  return _CollectionTrendPoint.fromJson(json);
}

/// @nodoc
mixin _$CollectionTrendPoint {
  DateTime get date => throw _privateConstructorUsedError;
  double get collectionRate => throw _privateConstructorUsedError;
  double get totalCollected => throw _privateConstructorUsedError;
  double get totalOutstanding => throw _privateConstructorUsedError;

  /// Serializes this CollectionTrendPoint to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CollectionTrendPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CollectionTrendPointCopyWith<CollectionTrendPoint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CollectionTrendPointCopyWith<$Res> {
  factory $CollectionTrendPointCopyWith(CollectionTrendPoint value,
          $Res Function(CollectionTrendPoint) then) =
      _$CollectionTrendPointCopyWithImpl<$Res, CollectionTrendPoint>;
  @useResult
  $Res call(
      {DateTime date,
      double collectionRate,
      double totalCollected,
      double totalOutstanding});
}

/// @nodoc
class _$CollectionTrendPointCopyWithImpl<$Res,
        $Val extends CollectionTrendPoint>
    implements $CollectionTrendPointCopyWith<$Res> {
  _$CollectionTrendPointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CollectionTrendPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? collectionRate = null,
    Object? totalCollected = null,
    Object? totalOutstanding = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      collectionRate: null == collectionRate
          ? _value.collectionRate
          : collectionRate // ignore: cast_nullable_to_non_nullable
              as double,
      totalCollected: null == totalCollected
          ? _value.totalCollected
          : totalCollected // ignore: cast_nullable_to_non_nullable
              as double,
      totalOutstanding: null == totalOutstanding
          ? _value.totalOutstanding
          : totalOutstanding // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CollectionTrendPointImplCopyWith<$Res>
    implements $CollectionTrendPointCopyWith<$Res> {
  factory _$$CollectionTrendPointImplCopyWith(_$CollectionTrendPointImpl value,
          $Res Function(_$CollectionTrendPointImpl) then) =
      __$$CollectionTrendPointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime date,
      double collectionRate,
      double totalCollected,
      double totalOutstanding});
}

/// @nodoc
class __$$CollectionTrendPointImplCopyWithImpl<$Res>
    extends _$CollectionTrendPointCopyWithImpl<$Res, _$CollectionTrendPointImpl>
    implements _$$CollectionTrendPointImplCopyWith<$Res> {
  __$$CollectionTrendPointImplCopyWithImpl(_$CollectionTrendPointImpl _value,
      $Res Function(_$CollectionTrendPointImpl) _then)
      : super(_value, _then);

  /// Create a copy of CollectionTrendPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? collectionRate = null,
    Object? totalCollected = null,
    Object? totalOutstanding = null,
  }) {
    return _then(_$CollectionTrendPointImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      collectionRate: null == collectionRate
          ? _value.collectionRate
          : collectionRate // ignore: cast_nullable_to_non_nullable
              as double,
      totalCollected: null == totalCollected
          ? _value.totalCollected
          : totalCollected // ignore: cast_nullable_to_non_nullable
              as double,
      totalOutstanding: null == totalOutstanding
          ? _value.totalOutstanding
          : totalOutstanding // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CollectionTrendPointImpl implements _CollectionTrendPoint {
  const _$CollectionTrendPointImpl(
      {required this.date,
      required this.collectionRate,
      required this.totalCollected,
      required this.totalOutstanding});

  factory _$CollectionTrendPointImpl.fromJson(Map<String, dynamic> json) =>
      _$$CollectionTrendPointImplFromJson(json);

  @override
  final DateTime date;
  @override
  final double collectionRate;
  @override
  final double totalCollected;
  @override
  final double totalOutstanding;

  @override
  String toString() {
    return 'CollectionTrendPoint(date: $date, collectionRate: $collectionRate, totalCollected: $totalCollected, totalOutstanding: $totalOutstanding)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CollectionTrendPointImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.collectionRate, collectionRate) ||
                other.collectionRate == collectionRate) &&
            (identical(other.totalCollected, totalCollected) ||
                other.totalCollected == totalCollected) &&
            (identical(other.totalOutstanding, totalOutstanding) ||
                other.totalOutstanding == totalOutstanding));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, date, collectionRate, totalCollected, totalOutstanding);

  /// Create a copy of CollectionTrendPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CollectionTrendPointImplCopyWith<_$CollectionTrendPointImpl>
      get copyWith =>
          __$$CollectionTrendPointImplCopyWithImpl<_$CollectionTrendPointImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CollectionTrendPointImplToJson(
      this,
    );
  }
}

abstract class _CollectionTrendPoint implements CollectionTrendPoint {
  const factory _CollectionTrendPoint(
      {required final DateTime date,
      required final double collectionRate,
      required final double totalCollected,
      required final double totalOutstanding}) = _$CollectionTrendPointImpl;

  factory _CollectionTrendPoint.fromJson(Map<String, dynamic> json) =
      _$CollectionTrendPointImpl.fromJson;

  @override
  DateTime get date;
  @override
  double get collectionRate;
  @override
  double get totalCollected;
  @override
  double get totalOutstanding;

  /// Create a copy of CollectionTrendPoint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CollectionTrendPointImplCopyWith<_$CollectionTrendPointImpl>
      get copyWith => throw _privateConstructorUsedError;
}

CounterpartyRiskScore _$CounterpartyRiskScoreFromJson(
    Map<String, dynamic> json) {
  return _CounterpartyRiskScore.fromJson(json);
}

/// @nodoc
mixin _$CounterpartyRiskScore {
  String get counterpartyId => throw _privateConstructorUsedError;
  String get counterpartyName => throw _privateConstructorUsedError;
  double get riskScore => throw _privateConstructorUsedError; // 0-100
  double get totalExposure => throw _privateConstructorUsedError;
  int get daysOutstanding => throw _privateConstructorUsedError;
  String get riskFactors => throw _privateConstructorUsedError;

  /// Serializes this CounterpartyRiskScore to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CounterpartyRiskScore
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CounterpartyRiskScoreCopyWith<CounterpartyRiskScore> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CounterpartyRiskScoreCopyWith<$Res> {
  factory $CounterpartyRiskScoreCopyWith(CounterpartyRiskScore value,
          $Res Function(CounterpartyRiskScore) then) =
      _$CounterpartyRiskScoreCopyWithImpl<$Res, CounterpartyRiskScore>;
  @useResult
  $Res call(
      {String counterpartyId,
      String counterpartyName,
      double riskScore,
      double totalExposure,
      int daysOutstanding,
      String riskFactors});
}

/// @nodoc
class _$CounterpartyRiskScoreCopyWithImpl<$Res,
        $Val extends CounterpartyRiskScore>
    implements $CounterpartyRiskScoreCopyWith<$Res> {
  _$CounterpartyRiskScoreCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CounterpartyRiskScore
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? counterpartyId = null,
    Object? counterpartyName = null,
    Object? riskScore = null,
    Object? totalExposure = null,
    Object? daysOutstanding = null,
    Object? riskFactors = null,
  }) {
    return _then(_value.copyWith(
      counterpartyId: null == counterpartyId
          ? _value.counterpartyId
          : counterpartyId // ignore: cast_nullable_to_non_nullable
              as String,
      counterpartyName: null == counterpartyName
          ? _value.counterpartyName
          : counterpartyName // ignore: cast_nullable_to_non_nullable
              as String,
      riskScore: null == riskScore
          ? _value.riskScore
          : riskScore // ignore: cast_nullable_to_non_nullable
              as double,
      totalExposure: null == totalExposure
          ? _value.totalExposure
          : totalExposure // ignore: cast_nullable_to_non_nullable
              as double,
      daysOutstanding: null == daysOutstanding
          ? _value.daysOutstanding
          : daysOutstanding // ignore: cast_nullable_to_non_nullable
              as int,
      riskFactors: null == riskFactors
          ? _value.riskFactors
          : riskFactors // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CounterpartyRiskScoreImplCopyWith<$Res>
    implements $CounterpartyRiskScoreCopyWith<$Res> {
  factory _$$CounterpartyRiskScoreImplCopyWith(
          _$CounterpartyRiskScoreImpl value,
          $Res Function(_$CounterpartyRiskScoreImpl) then) =
      __$$CounterpartyRiskScoreImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String counterpartyId,
      String counterpartyName,
      double riskScore,
      double totalExposure,
      int daysOutstanding,
      String riskFactors});
}

/// @nodoc
class __$$CounterpartyRiskScoreImplCopyWithImpl<$Res>
    extends _$CounterpartyRiskScoreCopyWithImpl<$Res,
        _$CounterpartyRiskScoreImpl>
    implements _$$CounterpartyRiskScoreImplCopyWith<$Res> {
  __$$CounterpartyRiskScoreImplCopyWithImpl(_$CounterpartyRiskScoreImpl _value,
      $Res Function(_$CounterpartyRiskScoreImpl) _then)
      : super(_value, _then);

  /// Create a copy of CounterpartyRiskScore
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? counterpartyId = null,
    Object? counterpartyName = null,
    Object? riskScore = null,
    Object? totalExposure = null,
    Object? daysOutstanding = null,
    Object? riskFactors = null,
  }) {
    return _then(_$CounterpartyRiskScoreImpl(
      counterpartyId: null == counterpartyId
          ? _value.counterpartyId
          : counterpartyId // ignore: cast_nullable_to_non_nullable
              as String,
      counterpartyName: null == counterpartyName
          ? _value.counterpartyName
          : counterpartyName // ignore: cast_nullable_to_non_nullable
              as String,
      riskScore: null == riskScore
          ? _value.riskScore
          : riskScore // ignore: cast_nullable_to_non_nullable
              as double,
      totalExposure: null == totalExposure
          ? _value.totalExposure
          : totalExposure // ignore: cast_nullable_to_non_nullable
              as double,
      daysOutstanding: null == daysOutstanding
          ? _value.daysOutstanding
          : daysOutstanding // ignore: cast_nullable_to_non_nullable
              as int,
      riskFactors: null == riskFactors
          ? _value.riskFactors
          : riskFactors // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CounterpartyRiskScoreImpl implements _CounterpartyRiskScore {
  const _$CounterpartyRiskScoreImpl(
      {required this.counterpartyId,
      required this.counterpartyName,
      required this.riskScore,
      required this.totalExposure,
      required this.daysOutstanding,
      required this.riskFactors});

  factory _$CounterpartyRiskScoreImpl.fromJson(Map<String, dynamic> json) =>
      _$$CounterpartyRiskScoreImplFromJson(json);

  @override
  final String counterpartyId;
  @override
  final String counterpartyName;
  @override
  final double riskScore;
// 0-100
  @override
  final double totalExposure;
  @override
  final int daysOutstanding;
  @override
  final String riskFactors;

  @override
  String toString() {
    return 'CounterpartyRiskScore(counterpartyId: $counterpartyId, counterpartyName: $counterpartyName, riskScore: $riskScore, totalExposure: $totalExposure, daysOutstanding: $daysOutstanding, riskFactors: $riskFactors)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CounterpartyRiskScoreImpl &&
            (identical(other.counterpartyId, counterpartyId) ||
                other.counterpartyId == counterpartyId) &&
            (identical(other.counterpartyName, counterpartyName) ||
                other.counterpartyName == counterpartyName) &&
            (identical(other.riskScore, riskScore) ||
                other.riskScore == riskScore) &&
            (identical(other.totalExposure, totalExposure) ||
                other.totalExposure == totalExposure) &&
            (identical(other.daysOutstanding, daysOutstanding) ||
                other.daysOutstanding == daysOutstanding) &&
            (identical(other.riskFactors, riskFactors) ||
                other.riskFactors == riskFactors));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, counterpartyId, counterpartyName,
      riskScore, totalExposure, daysOutstanding, riskFactors);

  /// Create a copy of CounterpartyRiskScore
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CounterpartyRiskScoreImplCopyWith<_$CounterpartyRiskScoreImpl>
      get copyWith => __$$CounterpartyRiskScoreImplCopyWithImpl<
          _$CounterpartyRiskScoreImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CounterpartyRiskScoreImplToJson(
      this,
    );
  }
}

abstract class _CounterpartyRiskScore implements CounterpartyRiskScore {
  const factory _CounterpartyRiskScore(
      {required final String counterpartyId,
      required final String counterpartyName,
      required final double riskScore,
      required final double totalExposure,
      required final int daysOutstanding,
      required final String riskFactors}) = _$CounterpartyRiskScoreImpl;

  factory _CounterpartyRiskScore.fromJson(Map<String, dynamic> json) =
      _$CounterpartyRiskScoreImpl.fromJson;

  @override
  String get counterpartyId;
  @override
  String get counterpartyName;
  @override
  double get riskScore; // 0-100
  @override
  double get totalExposure;
  @override
  int get daysOutstanding;
  @override
  String get riskFactors;

  /// Create a copy of CounterpartyRiskScore
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CounterpartyRiskScoreImplCopyWith<_$CounterpartyRiskScoreImpl>
      get copyWith => throw _privateConstructorUsedError;
}
