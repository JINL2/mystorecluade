// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'debt_overview.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DebtOverview {
  KpiMetrics get kpiMetrics => throw _privateConstructorUsedError;
  AgingAnalysis get agingAnalysis => throw _privateConstructorUsedError;
  List<CriticalAlert> get criticalAlerts => throw _privateConstructorUsedError;
  List<PrioritizedDebt> get topRisks => throw _privateConstructorUsedError;
  String? get viewpointDescription => throw _privateConstructorUsedError;
  DateTime? get lastUpdated => throw _privateConstructorUsedError;

  /// Create a copy of DebtOverview
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DebtOverviewCopyWith<DebtOverview> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DebtOverviewCopyWith<$Res> {
  factory $DebtOverviewCopyWith(
          DebtOverview value, $Res Function(DebtOverview) then) =
      _$DebtOverviewCopyWithImpl<$Res, DebtOverview>;
  @useResult
  $Res call(
      {KpiMetrics kpiMetrics,
      AgingAnalysis agingAnalysis,
      List<CriticalAlert> criticalAlerts,
      List<PrioritizedDebt> topRisks,
      String? viewpointDescription,
      DateTime? lastUpdated});

  $KpiMetricsCopyWith<$Res> get kpiMetrics;
  $AgingAnalysisCopyWith<$Res> get agingAnalysis;
}

/// @nodoc
class _$DebtOverviewCopyWithImpl<$Res, $Val extends DebtOverview>
    implements $DebtOverviewCopyWith<$Res> {
  _$DebtOverviewCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DebtOverview
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
              as KpiMetrics,
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

  /// Create a copy of DebtOverview
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $KpiMetricsCopyWith<$Res> get kpiMetrics {
    return $KpiMetricsCopyWith<$Res>(_value.kpiMetrics, (value) {
      return _then(_value.copyWith(kpiMetrics: value) as $Val);
    });
  }

  /// Create a copy of DebtOverview
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
abstract class _$$DebtOverviewImplCopyWith<$Res>
    implements $DebtOverviewCopyWith<$Res> {
  factory _$$DebtOverviewImplCopyWith(
          _$DebtOverviewImpl value, $Res Function(_$DebtOverviewImpl) then) =
      __$$DebtOverviewImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {KpiMetrics kpiMetrics,
      AgingAnalysis agingAnalysis,
      List<CriticalAlert> criticalAlerts,
      List<PrioritizedDebt> topRisks,
      String? viewpointDescription,
      DateTime? lastUpdated});

  @override
  $KpiMetricsCopyWith<$Res> get kpiMetrics;
  @override
  $AgingAnalysisCopyWith<$Res> get agingAnalysis;
}

/// @nodoc
class __$$DebtOverviewImplCopyWithImpl<$Res>
    extends _$DebtOverviewCopyWithImpl<$Res, _$DebtOverviewImpl>
    implements _$$DebtOverviewImplCopyWith<$Res> {
  __$$DebtOverviewImplCopyWithImpl(
      _$DebtOverviewImpl _value, $Res Function(_$DebtOverviewImpl) _then)
      : super(_value, _then);

  /// Create a copy of DebtOverview
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
    return _then(_$DebtOverviewImpl(
      kpiMetrics: null == kpiMetrics
          ? _value.kpiMetrics
          : kpiMetrics // ignore: cast_nullable_to_non_nullable
              as KpiMetrics,
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

class _$DebtOverviewImpl extends _DebtOverview {
  const _$DebtOverviewImpl(
      {required this.kpiMetrics,
      required this.agingAnalysis,
      final List<CriticalAlert> criticalAlerts = const [],
      final List<PrioritizedDebt> topRisks = const [],
      this.viewpointDescription,
      this.lastUpdated})
      : _criticalAlerts = criticalAlerts,
        _topRisks = topRisks,
        super._();

  @override
  final KpiMetrics kpiMetrics;
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
    return 'DebtOverview(kpiMetrics: $kpiMetrics, agingAnalysis: $agingAnalysis, criticalAlerts: $criticalAlerts, topRisks: $topRisks, viewpointDescription: $viewpointDescription, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DebtOverviewImpl &&
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

  @override
  int get hashCode => Object.hash(
      runtimeType,
      kpiMetrics,
      agingAnalysis,
      const DeepCollectionEquality().hash(_criticalAlerts),
      const DeepCollectionEquality().hash(_topRisks),
      viewpointDescription,
      lastUpdated);

  /// Create a copy of DebtOverview
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DebtOverviewImplCopyWith<_$DebtOverviewImpl> get copyWith =>
      __$$DebtOverviewImplCopyWithImpl<_$DebtOverviewImpl>(this, _$identity);
}

abstract class _DebtOverview extends DebtOverview {
  const factory _DebtOverview(
      {required final KpiMetrics kpiMetrics,
      required final AgingAnalysis agingAnalysis,
      final List<CriticalAlert> criticalAlerts,
      final List<PrioritizedDebt> topRisks,
      final String? viewpointDescription,
      final DateTime? lastUpdated}) = _$DebtOverviewImpl;
  const _DebtOverview._() : super._();

  @override
  KpiMetrics get kpiMetrics;
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

  /// Create a copy of DebtOverview
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DebtOverviewImplCopyWith<_$DebtOverviewImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
