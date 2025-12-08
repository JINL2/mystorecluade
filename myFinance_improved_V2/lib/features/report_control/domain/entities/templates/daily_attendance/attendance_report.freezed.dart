// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attendance_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AttendanceReport _$AttendanceReportFromJson(Map<String, dynamic> json) {
  return _AttendanceReport.fromJson(json);
}

/// @nodoc
mixin _$AttendanceReport {
  @JsonKey(name: 'hero_stats')
  HeroStats get heroStats => throw _privateConstructorUsedError;
  @JsonKey(name: 'cost_impact')
  CostImpact get costImpact => throw _privateConstructorUsedError;
  List<AttendanceIssue> get issues => throw _privateConstructorUsedError;
  List<StorePerformance> get stores => throw _privateConstructorUsedError;
  @JsonKey(name: 'urgent_actions')
  List<UrgentAction> get urgentActions => throw _privateConstructorUsedError;
  @JsonKey(name: 'manager_quality_flags')
  List<ManagerQualityFlag>? get managerQualityFlags =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'ai_summary')
  String? get aiSummary => throw _privateConstructorUsedError;

  /// Serializes this AttendanceReport to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AttendanceReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AttendanceReportCopyWith<AttendanceReport> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AttendanceReportCopyWith<$Res> {
  factory $AttendanceReportCopyWith(
          AttendanceReport value, $Res Function(AttendanceReport) then) =
      _$AttendanceReportCopyWithImpl<$Res, AttendanceReport>;
  @useResult
  $Res call(
      {@JsonKey(name: 'hero_stats') HeroStats heroStats,
      @JsonKey(name: 'cost_impact') CostImpact costImpact,
      List<AttendanceIssue> issues,
      List<StorePerformance> stores,
      @JsonKey(name: 'urgent_actions') List<UrgentAction> urgentActions,
      @JsonKey(name: 'manager_quality_flags')
      List<ManagerQualityFlag>? managerQualityFlags,
      @JsonKey(name: 'ai_summary') String? aiSummary});

  $HeroStatsCopyWith<$Res> get heroStats;
  $CostImpactCopyWith<$Res> get costImpact;
}

/// @nodoc
class _$AttendanceReportCopyWithImpl<$Res, $Val extends AttendanceReport>
    implements $AttendanceReportCopyWith<$Res> {
  _$AttendanceReportCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AttendanceReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? heroStats = null,
    Object? costImpact = null,
    Object? issues = null,
    Object? stores = null,
    Object? urgentActions = null,
    Object? managerQualityFlags = freezed,
    Object? aiSummary = freezed,
  }) {
    return _then(_value.copyWith(
      heroStats: null == heroStats
          ? _value.heroStats
          : heroStats // ignore: cast_nullable_to_non_nullable
              as HeroStats,
      costImpact: null == costImpact
          ? _value.costImpact
          : costImpact // ignore: cast_nullable_to_non_nullable
              as CostImpact,
      issues: null == issues
          ? _value.issues
          : issues // ignore: cast_nullable_to_non_nullable
              as List<AttendanceIssue>,
      stores: null == stores
          ? _value.stores
          : stores // ignore: cast_nullable_to_non_nullable
              as List<StorePerformance>,
      urgentActions: null == urgentActions
          ? _value.urgentActions
          : urgentActions // ignore: cast_nullable_to_non_nullable
              as List<UrgentAction>,
      managerQualityFlags: freezed == managerQualityFlags
          ? _value.managerQualityFlags
          : managerQualityFlags // ignore: cast_nullable_to_non_nullable
              as List<ManagerQualityFlag>?,
      aiSummary: freezed == aiSummary
          ? _value.aiSummary
          : aiSummary // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of AttendanceReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $HeroStatsCopyWith<$Res> get heroStats {
    return $HeroStatsCopyWith<$Res>(_value.heroStats, (value) {
      return _then(_value.copyWith(heroStats: value) as $Val);
    });
  }

  /// Create a copy of AttendanceReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CostImpactCopyWith<$Res> get costImpact {
    return $CostImpactCopyWith<$Res>(_value.costImpact, (value) {
      return _then(_value.copyWith(costImpact: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AttendanceReportImplCopyWith<$Res>
    implements $AttendanceReportCopyWith<$Res> {
  factory _$$AttendanceReportImplCopyWith(_$AttendanceReportImpl value,
          $Res Function(_$AttendanceReportImpl) then) =
      __$$AttendanceReportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'hero_stats') HeroStats heroStats,
      @JsonKey(name: 'cost_impact') CostImpact costImpact,
      List<AttendanceIssue> issues,
      List<StorePerformance> stores,
      @JsonKey(name: 'urgent_actions') List<UrgentAction> urgentActions,
      @JsonKey(name: 'manager_quality_flags')
      List<ManagerQualityFlag>? managerQualityFlags,
      @JsonKey(name: 'ai_summary') String? aiSummary});

  @override
  $HeroStatsCopyWith<$Res> get heroStats;
  @override
  $CostImpactCopyWith<$Res> get costImpact;
}

/// @nodoc
class __$$AttendanceReportImplCopyWithImpl<$Res>
    extends _$AttendanceReportCopyWithImpl<$Res, _$AttendanceReportImpl>
    implements _$$AttendanceReportImplCopyWith<$Res> {
  __$$AttendanceReportImplCopyWithImpl(_$AttendanceReportImpl _value,
      $Res Function(_$AttendanceReportImpl) _then)
      : super(_value, _then);

  /// Create a copy of AttendanceReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? heroStats = null,
    Object? costImpact = null,
    Object? issues = null,
    Object? stores = null,
    Object? urgentActions = null,
    Object? managerQualityFlags = freezed,
    Object? aiSummary = freezed,
  }) {
    return _then(_$AttendanceReportImpl(
      heroStats: null == heroStats
          ? _value.heroStats
          : heroStats // ignore: cast_nullable_to_non_nullable
              as HeroStats,
      costImpact: null == costImpact
          ? _value.costImpact
          : costImpact // ignore: cast_nullable_to_non_nullable
              as CostImpact,
      issues: null == issues
          ? _value._issues
          : issues // ignore: cast_nullable_to_non_nullable
              as List<AttendanceIssue>,
      stores: null == stores
          ? _value._stores
          : stores // ignore: cast_nullable_to_non_nullable
              as List<StorePerformance>,
      urgentActions: null == urgentActions
          ? _value._urgentActions
          : urgentActions // ignore: cast_nullable_to_non_nullable
              as List<UrgentAction>,
      managerQualityFlags: freezed == managerQualityFlags
          ? _value._managerQualityFlags
          : managerQualityFlags // ignore: cast_nullable_to_non_nullable
              as List<ManagerQualityFlag>?,
      aiSummary: freezed == aiSummary
          ? _value.aiSummary
          : aiSummary // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AttendanceReportImpl implements _AttendanceReport {
  const _$AttendanceReportImpl(
      {@JsonKey(name: 'hero_stats') required this.heroStats,
      @JsonKey(name: 'cost_impact') required this.costImpact,
      required final List<AttendanceIssue> issues,
      required final List<StorePerformance> stores,
      @JsonKey(name: 'urgent_actions')
      required final List<UrgentAction> urgentActions,
      @JsonKey(name: 'manager_quality_flags')
      final List<ManagerQualityFlag>? managerQualityFlags,
      @JsonKey(name: 'ai_summary') this.aiSummary})
      : _issues = issues,
        _stores = stores,
        _urgentActions = urgentActions,
        _managerQualityFlags = managerQualityFlags;

  factory _$AttendanceReportImpl.fromJson(Map<String, dynamic> json) =>
      _$$AttendanceReportImplFromJson(json);

  @override
  @JsonKey(name: 'hero_stats')
  final HeroStats heroStats;
  @override
  @JsonKey(name: 'cost_impact')
  final CostImpact costImpact;
  final List<AttendanceIssue> _issues;
  @override
  List<AttendanceIssue> get issues {
    if (_issues is EqualUnmodifiableListView) return _issues;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_issues);
  }

  final List<StorePerformance> _stores;
  @override
  List<StorePerformance> get stores {
    if (_stores is EqualUnmodifiableListView) return _stores;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_stores);
  }

  final List<UrgentAction> _urgentActions;
  @override
  @JsonKey(name: 'urgent_actions')
  List<UrgentAction> get urgentActions {
    if (_urgentActions is EqualUnmodifiableListView) return _urgentActions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_urgentActions);
  }

  final List<ManagerQualityFlag>? _managerQualityFlags;
  @override
  @JsonKey(name: 'manager_quality_flags')
  List<ManagerQualityFlag>? get managerQualityFlags {
    final value = _managerQualityFlags;
    if (value == null) return null;
    if (_managerQualityFlags is EqualUnmodifiableListView)
      return _managerQualityFlags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'ai_summary')
  final String? aiSummary;

  @override
  String toString() {
    return 'AttendanceReport(heroStats: $heroStats, costImpact: $costImpact, issues: $issues, stores: $stores, urgentActions: $urgentActions, managerQualityFlags: $managerQualityFlags, aiSummary: $aiSummary)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AttendanceReportImpl &&
            (identical(other.heroStats, heroStats) ||
                other.heroStats == heroStats) &&
            (identical(other.costImpact, costImpact) ||
                other.costImpact == costImpact) &&
            const DeepCollectionEquality().equals(other._issues, _issues) &&
            const DeepCollectionEquality().equals(other._stores, _stores) &&
            const DeepCollectionEquality()
                .equals(other._urgentActions, _urgentActions) &&
            const DeepCollectionEquality()
                .equals(other._managerQualityFlags, _managerQualityFlags) &&
            (identical(other.aiSummary, aiSummary) ||
                other.aiSummary == aiSummary));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      heroStats,
      costImpact,
      const DeepCollectionEquality().hash(_issues),
      const DeepCollectionEquality().hash(_stores),
      const DeepCollectionEquality().hash(_urgentActions),
      const DeepCollectionEquality().hash(_managerQualityFlags),
      aiSummary);

  /// Create a copy of AttendanceReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AttendanceReportImplCopyWith<_$AttendanceReportImpl> get copyWith =>
      __$$AttendanceReportImplCopyWithImpl<_$AttendanceReportImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AttendanceReportImplToJson(
      this,
    );
  }
}

abstract class _AttendanceReport implements AttendanceReport {
  const factory _AttendanceReport(
          {@JsonKey(name: 'hero_stats') required final HeroStats heroStats,
          @JsonKey(name: 'cost_impact') required final CostImpact costImpact,
          required final List<AttendanceIssue> issues,
          required final List<StorePerformance> stores,
          @JsonKey(name: 'urgent_actions')
          required final List<UrgentAction> urgentActions,
          @JsonKey(name: 'manager_quality_flags')
          final List<ManagerQualityFlag>? managerQualityFlags,
          @JsonKey(name: 'ai_summary') final String? aiSummary}) =
      _$AttendanceReportImpl;

  factory _AttendanceReport.fromJson(Map<String, dynamic> json) =
      _$AttendanceReportImpl.fromJson;

  @override
  @JsonKey(name: 'hero_stats')
  HeroStats get heroStats;
  @override
  @JsonKey(name: 'cost_impact')
  CostImpact get costImpact;
  @override
  List<AttendanceIssue> get issues;
  @override
  List<StorePerformance> get stores;
  @override
  @JsonKey(name: 'urgent_actions')
  List<UrgentAction> get urgentActions;
  @override
  @JsonKey(name: 'manager_quality_flags')
  List<ManagerQualityFlag>? get managerQualityFlags;
  @override
  @JsonKey(name: 'ai_summary')
  String? get aiSummary;

  /// Create a copy of AttendanceReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AttendanceReportImplCopyWith<_$AttendanceReportImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HeroStats _$HeroStatsFromJson(Map<String, dynamic> json) {
  return _HeroStats.fromJson(json);
}

/// @nodoc
mixin _$HeroStats {
  @JsonKey(name: 'total_shifts')
  int get totalShifts => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_issues')
  int get totalIssues => throw _privateConstructorUsedError;
  @JsonKey(name: 'solved_count')
  int? get solvedCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'unsolved_count')
  int? get unsolvedCount => throw _privateConstructorUsedError;

  /// Serializes this HeroStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HeroStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HeroStatsCopyWith<HeroStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HeroStatsCopyWith<$Res> {
  factory $HeroStatsCopyWith(HeroStats value, $Res Function(HeroStats) then) =
      _$HeroStatsCopyWithImpl<$Res, HeroStats>;
  @useResult
  $Res call(
      {@JsonKey(name: 'total_shifts') int totalShifts,
      @JsonKey(name: 'total_issues') int totalIssues,
      @JsonKey(name: 'solved_count') int? solvedCount,
      @JsonKey(name: 'unsolved_count') int? unsolvedCount});
}

/// @nodoc
class _$HeroStatsCopyWithImpl<$Res, $Val extends HeroStats>
    implements $HeroStatsCopyWith<$Res> {
  _$HeroStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HeroStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalShifts = null,
    Object? totalIssues = null,
    Object? solvedCount = freezed,
    Object? unsolvedCount = freezed,
  }) {
    return _then(_value.copyWith(
      totalShifts: null == totalShifts
          ? _value.totalShifts
          : totalShifts // ignore: cast_nullable_to_non_nullable
              as int,
      totalIssues: null == totalIssues
          ? _value.totalIssues
          : totalIssues // ignore: cast_nullable_to_non_nullable
              as int,
      solvedCount: freezed == solvedCount
          ? _value.solvedCount
          : solvedCount // ignore: cast_nullable_to_non_nullable
              as int?,
      unsolvedCount: freezed == unsolvedCount
          ? _value.unsolvedCount
          : unsolvedCount // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HeroStatsImplCopyWith<$Res>
    implements $HeroStatsCopyWith<$Res> {
  factory _$$HeroStatsImplCopyWith(
          _$HeroStatsImpl value, $Res Function(_$HeroStatsImpl) then) =
      __$$HeroStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'total_shifts') int totalShifts,
      @JsonKey(name: 'total_issues') int totalIssues,
      @JsonKey(name: 'solved_count') int? solvedCount,
      @JsonKey(name: 'unsolved_count') int? unsolvedCount});
}

/// @nodoc
class __$$HeroStatsImplCopyWithImpl<$Res>
    extends _$HeroStatsCopyWithImpl<$Res, _$HeroStatsImpl>
    implements _$$HeroStatsImplCopyWith<$Res> {
  __$$HeroStatsImplCopyWithImpl(
      _$HeroStatsImpl _value, $Res Function(_$HeroStatsImpl) _then)
      : super(_value, _then);

  /// Create a copy of HeroStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalShifts = null,
    Object? totalIssues = null,
    Object? solvedCount = freezed,
    Object? unsolvedCount = freezed,
  }) {
    return _then(_$HeroStatsImpl(
      totalShifts: null == totalShifts
          ? _value.totalShifts
          : totalShifts // ignore: cast_nullable_to_non_nullable
              as int,
      totalIssues: null == totalIssues
          ? _value.totalIssues
          : totalIssues // ignore: cast_nullable_to_non_nullable
              as int,
      solvedCount: freezed == solvedCount
          ? _value.solvedCount
          : solvedCount // ignore: cast_nullable_to_non_nullable
              as int?,
      unsolvedCount: freezed == unsolvedCount
          ? _value.unsolvedCount
          : unsolvedCount // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HeroStatsImpl implements _HeroStats {
  const _$HeroStatsImpl(
      {@JsonKey(name: 'total_shifts') required this.totalShifts,
      @JsonKey(name: 'total_issues') required this.totalIssues,
      @JsonKey(name: 'solved_count') this.solvedCount,
      @JsonKey(name: 'unsolved_count') this.unsolvedCount});

  factory _$HeroStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$HeroStatsImplFromJson(json);

  @override
  @JsonKey(name: 'total_shifts')
  final int totalShifts;
  @override
  @JsonKey(name: 'total_issues')
  final int totalIssues;
  @override
  @JsonKey(name: 'solved_count')
  final int? solvedCount;
  @override
  @JsonKey(name: 'unsolved_count')
  final int? unsolvedCount;

  @override
  String toString() {
    return 'HeroStats(totalShifts: $totalShifts, totalIssues: $totalIssues, solvedCount: $solvedCount, unsolvedCount: $unsolvedCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HeroStatsImpl &&
            (identical(other.totalShifts, totalShifts) ||
                other.totalShifts == totalShifts) &&
            (identical(other.totalIssues, totalIssues) ||
                other.totalIssues == totalIssues) &&
            (identical(other.solvedCount, solvedCount) ||
                other.solvedCount == solvedCount) &&
            (identical(other.unsolvedCount, unsolvedCount) ||
                other.unsolvedCount == unsolvedCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, totalShifts, totalIssues, solvedCount, unsolvedCount);

  /// Create a copy of HeroStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HeroStatsImplCopyWith<_$HeroStatsImpl> get copyWith =>
      __$$HeroStatsImplCopyWithImpl<_$HeroStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HeroStatsImplToJson(
      this,
    );
  }
}

abstract class _HeroStats implements HeroStats {
  const factory _HeroStats(
          {@JsonKey(name: 'total_shifts') required final int totalShifts,
          @JsonKey(name: 'total_issues') required final int totalIssues,
          @JsonKey(name: 'solved_count') final int? solvedCount,
          @JsonKey(name: 'unsolved_count') final int? unsolvedCount}) =
      _$HeroStatsImpl;

  factory _HeroStats.fromJson(Map<String, dynamic> json) =
      _$HeroStatsImpl.fromJson;

  @override
  @JsonKey(name: 'total_shifts')
  int get totalShifts;
  @override
  @JsonKey(name: 'total_issues')
  int get totalIssues;
  @override
  @JsonKey(name: 'solved_count')
  int? get solvedCount;
  @override
  @JsonKey(name: 'unsolved_count')
  int? get unsolvedCount;

  /// Create a copy of HeroStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HeroStatsImplCopyWith<_$HeroStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CostImpact _$CostImpactFromJson(Map<String, dynamic> json) {
  return _CostImpact.fromJson(json);
}

/// @nodoc
mixin _$CostImpact {
  @JsonKey(name: 'net_minutes')
  int get netMinutes => throw _privateConstructorUsedError;
  @JsonKey(name: 'overtime_pay_minutes')
  int get overtimePayMinutes => throw _privateConstructorUsedError;
  @JsonKey(name: 'late_deduction_minutes')
  int get lateDeductionMinutes => throw _privateConstructorUsedError;

  /// Serializes this CostImpact to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CostImpact
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CostImpactCopyWith<CostImpact> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CostImpactCopyWith<$Res> {
  factory $CostImpactCopyWith(
          CostImpact value, $Res Function(CostImpact) then) =
      _$CostImpactCopyWithImpl<$Res, CostImpact>;
  @useResult
  $Res call(
      {@JsonKey(name: 'net_minutes') int netMinutes,
      @JsonKey(name: 'overtime_pay_minutes') int overtimePayMinutes,
      @JsonKey(name: 'late_deduction_minutes') int lateDeductionMinutes});
}

/// @nodoc
class _$CostImpactCopyWithImpl<$Res, $Val extends CostImpact>
    implements $CostImpactCopyWith<$Res> {
  _$CostImpactCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CostImpact
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? netMinutes = null,
    Object? overtimePayMinutes = null,
    Object? lateDeductionMinutes = null,
  }) {
    return _then(_value.copyWith(
      netMinutes: null == netMinutes
          ? _value.netMinutes
          : netMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      overtimePayMinutes: null == overtimePayMinutes
          ? _value.overtimePayMinutes
          : overtimePayMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      lateDeductionMinutes: null == lateDeductionMinutes
          ? _value.lateDeductionMinutes
          : lateDeductionMinutes // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CostImpactImplCopyWith<$Res>
    implements $CostImpactCopyWith<$Res> {
  factory _$$CostImpactImplCopyWith(
          _$CostImpactImpl value, $Res Function(_$CostImpactImpl) then) =
      __$$CostImpactImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'net_minutes') int netMinutes,
      @JsonKey(name: 'overtime_pay_minutes') int overtimePayMinutes,
      @JsonKey(name: 'late_deduction_minutes') int lateDeductionMinutes});
}

/// @nodoc
class __$$CostImpactImplCopyWithImpl<$Res>
    extends _$CostImpactCopyWithImpl<$Res, _$CostImpactImpl>
    implements _$$CostImpactImplCopyWith<$Res> {
  __$$CostImpactImplCopyWithImpl(
      _$CostImpactImpl _value, $Res Function(_$CostImpactImpl) _then)
      : super(_value, _then);

  /// Create a copy of CostImpact
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? netMinutes = null,
    Object? overtimePayMinutes = null,
    Object? lateDeductionMinutes = null,
  }) {
    return _then(_$CostImpactImpl(
      netMinutes: null == netMinutes
          ? _value.netMinutes
          : netMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      overtimePayMinutes: null == overtimePayMinutes
          ? _value.overtimePayMinutes
          : overtimePayMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      lateDeductionMinutes: null == lateDeductionMinutes
          ? _value.lateDeductionMinutes
          : lateDeductionMinutes // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CostImpactImpl implements _CostImpact {
  const _$CostImpactImpl(
      {@JsonKey(name: 'net_minutes') required this.netMinutes,
      @JsonKey(name: 'overtime_pay_minutes') required this.overtimePayMinutes,
      @JsonKey(name: 'late_deduction_minutes')
      required this.lateDeductionMinutes});

  factory _$CostImpactImpl.fromJson(Map<String, dynamic> json) =>
      _$$CostImpactImplFromJson(json);

  @override
  @JsonKey(name: 'net_minutes')
  final int netMinutes;
  @override
  @JsonKey(name: 'overtime_pay_minutes')
  final int overtimePayMinutes;
  @override
  @JsonKey(name: 'late_deduction_minutes')
  final int lateDeductionMinutes;

  @override
  String toString() {
    return 'CostImpact(netMinutes: $netMinutes, overtimePayMinutes: $overtimePayMinutes, lateDeductionMinutes: $lateDeductionMinutes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CostImpactImpl &&
            (identical(other.netMinutes, netMinutes) ||
                other.netMinutes == netMinutes) &&
            (identical(other.overtimePayMinutes, overtimePayMinutes) ||
                other.overtimePayMinutes == overtimePayMinutes) &&
            (identical(other.lateDeductionMinutes, lateDeductionMinutes) ||
                other.lateDeductionMinutes == lateDeductionMinutes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, netMinutes, overtimePayMinutes, lateDeductionMinutes);

  /// Create a copy of CostImpact
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CostImpactImplCopyWith<_$CostImpactImpl> get copyWith =>
      __$$CostImpactImplCopyWithImpl<_$CostImpactImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CostImpactImplToJson(
      this,
    );
  }
}

abstract class _CostImpact implements CostImpact {
  const factory _CostImpact(
      {@JsonKey(name: 'net_minutes') required final int netMinutes,
      @JsonKey(name: 'overtime_pay_minutes')
      required final int overtimePayMinutes,
      @JsonKey(name: 'late_deduction_minutes')
      required final int lateDeductionMinutes}) = _$CostImpactImpl;

  factory _CostImpact.fromJson(Map<String, dynamic> json) =
      _$CostImpactImpl.fromJson;

  @override
  @JsonKey(name: 'net_minutes')
  int get netMinutes;
  @override
  @JsonKey(name: 'overtime_pay_minutes')
  int get overtimePayMinutes;
  @override
  @JsonKey(name: 'late_deduction_minutes')
  int get lateDeductionMinutes;

  /// Create a copy of CostImpact
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CostImpactImplCopyWith<_$CostImpactImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AttendanceIssue _$AttendanceIssueFromJson(Map<String, dynamic> json) {
  return _AttendanceIssue.fromJson(json);
}

/// @nodoc
mixin _$AttendanceIssue {
  @JsonKey(name: 'employee_id')
  String get employeeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'employee_name')
  String get employeeName => throw _privateConstructorUsedError;
  @JsonKey(name: 'store_id')
  String get storeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'store_name')
  String get storeName => throw _privateConstructorUsedError;
  @JsonKey(name: 'shift_name')
  String get shiftName => throw _privateConstructorUsedError;
  @JsonKey(name: 'problem_type')
  String get problemType => throw _privateConstructorUsedError;
  String get severity => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_solved')
  bool get isSolved => throw _privateConstructorUsedError;
  @JsonKey(name: 'time_detail')
  TimeDetail get timeDetail => throw _privateConstructorUsedError;
  @JsonKey(name: 'manager_adjustment')
  ManagerAdjustment get managerAdjustment => throw _privateConstructorUsedError;
  @JsonKey(name: 'monthly_performance')
  MonthlyPerformance? get monthlyPerformance =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'ai_comment')
  String? get aiComment => throw _privateConstructorUsedError;

  /// Serializes this AttendanceIssue to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AttendanceIssue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AttendanceIssueCopyWith<AttendanceIssue> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AttendanceIssueCopyWith<$Res> {
  factory $AttendanceIssueCopyWith(
          AttendanceIssue value, $Res Function(AttendanceIssue) then) =
      _$AttendanceIssueCopyWithImpl<$Res, AttendanceIssue>;
  @useResult
  $Res call(
      {@JsonKey(name: 'employee_id') String employeeId,
      @JsonKey(name: 'employee_name') String employeeName,
      @JsonKey(name: 'store_id') String storeId,
      @JsonKey(name: 'store_name') String storeName,
      @JsonKey(name: 'shift_name') String shiftName,
      @JsonKey(name: 'problem_type') String problemType,
      String severity,
      @JsonKey(name: 'is_solved') bool isSolved,
      @JsonKey(name: 'time_detail') TimeDetail timeDetail,
      @JsonKey(name: 'manager_adjustment') ManagerAdjustment managerAdjustment,
      @JsonKey(name: 'monthly_performance')
      MonthlyPerformance? monthlyPerformance,
      @JsonKey(name: 'ai_comment') String? aiComment});

  $TimeDetailCopyWith<$Res> get timeDetail;
  $ManagerAdjustmentCopyWith<$Res> get managerAdjustment;
  $MonthlyPerformanceCopyWith<$Res>? get monthlyPerformance;
}

/// @nodoc
class _$AttendanceIssueCopyWithImpl<$Res, $Val extends AttendanceIssue>
    implements $AttendanceIssueCopyWith<$Res> {
  _$AttendanceIssueCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AttendanceIssue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? employeeId = null,
    Object? employeeName = null,
    Object? storeId = null,
    Object? storeName = null,
    Object? shiftName = null,
    Object? problemType = null,
    Object? severity = null,
    Object? isSolved = null,
    Object? timeDetail = null,
    Object? managerAdjustment = null,
    Object? monthlyPerformance = freezed,
    Object? aiComment = freezed,
  }) {
    return _then(_value.copyWith(
      employeeId: null == employeeId
          ? _value.employeeId
          : employeeId // ignore: cast_nullable_to_non_nullable
              as String,
      employeeName: null == employeeName
          ? _value.employeeName
          : employeeName // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      storeName: null == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String,
      shiftName: null == shiftName
          ? _value.shiftName
          : shiftName // ignore: cast_nullable_to_non_nullable
              as String,
      problemType: null == problemType
          ? _value.problemType
          : problemType // ignore: cast_nullable_to_non_nullable
              as String,
      severity: null == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as String,
      isSolved: null == isSolved
          ? _value.isSolved
          : isSolved // ignore: cast_nullable_to_non_nullable
              as bool,
      timeDetail: null == timeDetail
          ? _value.timeDetail
          : timeDetail // ignore: cast_nullable_to_non_nullable
              as TimeDetail,
      managerAdjustment: null == managerAdjustment
          ? _value.managerAdjustment
          : managerAdjustment // ignore: cast_nullable_to_non_nullable
              as ManagerAdjustment,
      monthlyPerformance: freezed == monthlyPerformance
          ? _value.monthlyPerformance
          : monthlyPerformance // ignore: cast_nullable_to_non_nullable
              as MonthlyPerformance?,
      aiComment: freezed == aiComment
          ? _value.aiComment
          : aiComment // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of AttendanceIssue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TimeDetailCopyWith<$Res> get timeDetail {
    return $TimeDetailCopyWith<$Res>(_value.timeDetail, (value) {
      return _then(_value.copyWith(timeDetail: value) as $Val);
    });
  }

  /// Create a copy of AttendanceIssue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ManagerAdjustmentCopyWith<$Res> get managerAdjustment {
    return $ManagerAdjustmentCopyWith<$Res>(_value.managerAdjustment, (value) {
      return _then(_value.copyWith(managerAdjustment: value) as $Val);
    });
  }

  /// Create a copy of AttendanceIssue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MonthlyPerformanceCopyWith<$Res>? get monthlyPerformance {
    if (_value.monthlyPerformance == null) {
      return null;
    }

    return $MonthlyPerformanceCopyWith<$Res>(_value.monthlyPerformance!,
        (value) {
      return _then(_value.copyWith(monthlyPerformance: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AttendanceIssueImplCopyWith<$Res>
    implements $AttendanceIssueCopyWith<$Res> {
  factory _$$AttendanceIssueImplCopyWith(_$AttendanceIssueImpl value,
          $Res Function(_$AttendanceIssueImpl) then) =
      __$$AttendanceIssueImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'employee_id') String employeeId,
      @JsonKey(name: 'employee_name') String employeeName,
      @JsonKey(name: 'store_id') String storeId,
      @JsonKey(name: 'store_name') String storeName,
      @JsonKey(name: 'shift_name') String shiftName,
      @JsonKey(name: 'problem_type') String problemType,
      String severity,
      @JsonKey(name: 'is_solved') bool isSolved,
      @JsonKey(name: 'time_detail') TimeDetail timeDetail,
      @JsonKey(name: 'manager_adjustment') ManagerAdjustment managerAdjustment,
      @JsonKey(name: 'monthly_performance')
      MonthlyPerformance? monthlyPerformance,
      @JsonKey(name: 'ai_comment') String? aiComment});

  @override
  $TimeDetailCopyWith<$Res> get timeDetail;
  @override
  $ManagerAdjustmentCopyWith<$Res> get managerAdjustment;
  @override
  $MonthlyPerformanceCopyWith<$Res>? get monthlyPerformance;
}

/// @nodoc
class __$$AttendanceIssueImplCopyWithImpl<$Res>
    extends _$AttendanceIssueCopyWithImpl<$Res, _$AttendanceIssueImpl>
    implements _$$AttendanceIssueImplCopyWith<$Res> {
  __$$AttendanceIssueImplCopyWithImpl(
      _$AttendanceIssueImpl _value, $Res Function(_$AttendanceIssueImpl) _then)
      : super(_value, _then);

  /// Create a copy of AttendanceIssue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? employeeId = null,
    Object? employeeName = null,
    Object? storeId = null,
    Object? storeName = null,
    Object? shiftName = null,
    Object? problemType = null,
    Object? severity = null,
    Object? isSolved = null,
    Object? timeDetail = null,
    Object? managerAdjustment = null,
    Object? monthlyPerformance = freezed,
    Object? aiComment = freezed,
  }) {
    return _then(_$AttendanceIssueImpl(
      employeeId: null == employeeId
          ? _value.employeeId
          : employeeId // ignore: cast_nullable_to_non_nullable
              as String,
      employeeName: null == employeeName
          ? _value.employeeName
          : employeeName // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      storeName: null == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String,
      shiftName: null == shiftName
          ? _value.shiftName
          : shiftName // ignore: cast_nullable_to_non_nullable
              as String,
      problemType: null == problemType
          ? _value.problemType
          : problemType // ignore: cast_nullable_to_non_nullable
              as String,
      severity: null == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as String,
      isSolved: null == isSolved
          ? _value.isSolved
          : isSolved // ignore: cast_nullable_to_non_nullable
              as bool,
      timeDetail: null == timeDetail
          ? _value.timeDetail
          : timeDetail // ignore: cast_nullable_to_non_nullable
              as TimeDetail,
      managerAdjustment: null == managerAdjustment
          ? _value.managerAdjustment
          : managerAdjustment // ignore: cast_nullable_to_non_nullable
              as ManagerAdjustment,
      monthlyPerformance: freezed == monthlyPerformance
          ? _value.monthlyPerformance
          : monthlyPerformance // ignore: cast_nullable_to_non_nullable
              as MonthlyPerformance?,
      aiComment: freezed == aiComment
          ? _value.aiComment
          : aiComment // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AttendanceIssueImpl implements _AttendanceIssue {
  const _$AttendanceIssueImpl(
      {@JsonKey(name: 'employee_id') required this.employeeId,
      @JsonKey(name: 'employee_name') required this.employeeName,
      @JsonKey(name: 'store_id') required this.storeId,
      @JsonKey(name: 'store_name') required this.storeName,
      @JsonKey(name: 'shift_name') required this.shiftName,
      @JsonKey(name: 'problem_type') required this.problemType,
      required this.severity,
      @JsonKey(name: 'is_solved') required this.isSolved,
      @JsonKey(name: 'time_detail') required this.timeDetail,
      @JsonKey(name: 'manager_adjustment') required this.managerAdjustment,
      @JsonKey(name: 'monthly_performance') this.monthlyPerformance,
      @JsonKey(name: 'ai_comment') this.aiComment});

  factory _$AttendanceIssueImpl.fromJson(Map<String, dynamic> json) =>
      _$$AttendanceIssueImplFromJson(json);

  @override
  @JsonKey(name: 'employee_id')
  final String employeeId;
  @override
  @JsonKey(name: 'employee_name')
  final String employeeName;
  @override
  @JsonKey(name: 'store_id')
  final String storeId;
  @override
  @JsonKey(name: 'store_name')
  final String storeName;
  @override
  @JsonKey(name: 'shift_name')
  final String shiftName;
  @override
  @JsonKey(name: 'problem_type')
  final String problemType;
  @override
  final String severity;
  @override
  @JsonKey(name: 'is_solved')
  final bool isSolved;
  @override
  @JsonKey(name: 'time_detail')
  final TimeDetail timeDetail;
  @override
  @JsonKey(name: 'manager_adjustment')
  final ManagerAdjustment managerAdjustment;
  @override
  @JsonKey(name: 'monthly_performance')
  final MonthlyPerformance? monthlyPerformance;
  @override
  @JsonKey(name: 'ai_comment')
  final String? aiComment;

  @override
  String toString() {
    return 'AttendanceIssue(employeeId: $employeeId, employeeName: $employeeName, storeId: $storeId, storeName: $storeName, shiftName: $shiftName, problemType: $problemType, severity: $severity, isSolved: $isSolved, timeDetail: $timeDetail, managerAdjustment: $managerAdjustment, monthlyPerformance: $monthlyPerformance, aiComment: $aiComment)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AttendanceIssueImpl &&
            (identical(other.employeeId, employeeId) ||
                other.employeeId == employeeId) &&
            (identical(other.employeeName, employeeName) ||
                other.employeeName == employeeName) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.storeName, storeName) ||
                other.storeName == storeName) &&
            (identical(other.shiftName, shiftName) ||
                other.shiftName == shiftName) &&
            (identical(other.problemType, problemType) ||
                other.problemType == problemType) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            (identical(other.isSolved, isSolved) ||
                other.isSolved == isSolved) &&
            (identical(other.timeDetail, timeDetail) ||
                other.timeDetail == timeDetail) &&
            (identical(other.managerAdjustment, managerAdjustment) ||
                other.managerAdjustment == managerAdjustment) &&
            (identical(other.monthlyPerformance, monthlyPerformance) ||
                other.monthlyPerformance == monthlyPerformance) &&
            (identical(other.aiComment, aiComment) ||
                other.aiComment == aiComment));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      employeeId,
      employeeName,
      storeId,
      storeName,
      shiftName,
      problemType,
      severity,
      isSolved,
      timeDetail,
      managerAdjustment,
      monthlyPerformance,
      aiComment);

  /// Create a copy of AttendanceIssue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AttendanceIssueImplCopyWith<_$AttendanceIssueImpl> get copyWith =>
      __$$AttendanceIssueImplCopyWithImpl<_$AttendanceIssueImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AttendanceIssueImplToJson(
      this,
    );
  }
}

abstract class _AttendanceIssue implements AttendanceIssue {
  const factory _AttendanceIssue(
          {@JsonKey(name: 'employee_id') required final String employeeId,
          @JsonKey(name: 'employee_name') required final String employeeName,
          @JsonKey(name: 'store_id') required final String storeId,
          @JsonKey(name: 'store_name') required final String storeName,
          @JsonKey(name: 'shift_name') required final String shiftName,
          @JsonKey(name: 'problem_type') required final String problemType,
          required final String severity,
          @JsonKey(name: 'is_solved') required final bool isSolved,
          @JsonKey(name: 'time_detail') required final TimeDetail timeDetail,
          @JsonKey(name: 'manager_adjustment')
          required final ManagerAdjustment managerAdjustment,
          @JsonKey(name: 'monthly_performance')
          final MonthlyPerformance? monthlyPerformance,
          @JsonKey(name: 'ai_comment') final String? aiComment}) =
      _$AttendanceIssueImpl;

  factory _AttendanceIssue.fromJson(Map<String, dynamic> json) =
      _$AttendanceIssueImpl.fromJson;

  @override
  @JsonKey(name: 'employee_id')
  String get employeeId;
  @override
  @JsonKey(name: 'employee_name')
  String get employeeName;
  @override
  @JsonKey(name: 'store_id')
  String get storeId;
  @override
  @JsonKey(name: 'store_name')
  String get storeName;
  @override
  @JsonKey(name: 'shift_name')
  String get shiftName;
  @override
  @JsonKey(name: 'problem_type')
  String get problemType;
  @override
  String get severity;
  @override
  @JsonKey(name: 'is_solved')
  bool get isSolved;
  @override
  @JsonKey(name: 'time_detail')
  TimeDetail get timeDetail;
  @override
  @JsonKey(name: 'manager_adjustment')
  ManagerAdjustment get managerAdjustment;
  @override
  @JsonKey(name: 'monthly_performance')
  MonthlyPerformance? get monthlyPerformance;
  @override
  @JsonKey(name: 'ai_comment')
  String? get aiComment;

  /// Create a copy of AttendanceIssue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AttendanceIssueImplCopyWith<_$AttendanceIssueImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TimeDetail _$TimeDetailFromJson(Map<String, dynamic> json) {
  return _TimeDetail.fromJson(json);
}

/// @nodoc
mixin _$TimeDetail {
  @JsonKey(name: 'scheduled_start')
  String get scheduledStart => throw _privateConstructorUsedError;
  @JsonKey(name: 'scheduled_end')
  String get scheduledEnd => throw _privateConstructorUsedError;
  @JsonKey(name: 'scheduled_hours')
  double? get scheduledHours => throw _privateConstructorUsedError;
  @JsonKey(name: 'actual_start')
  String? get actualStart => throw _privateConstructorUsedError;
  @JsonKey(name: 'actual_end')
  String? get actualEnd => throw _privateConstructorUsedError;
  @JsonKey(name: 'actual_hours')
  double? get actualHours => throw _privateConstructorUsedError;
  @JsonKey(name: 'late_minutes')
  double? get lateMinutes => throw _privateConstructorUsedError;
  @JsonKey(name: 'overtime_minutes')
  double? get overtimeMinutes => throw _privateConstructorUsedError;

  /// Serializes this TimeDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TimeDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TimeDetailCopyWith<TimeDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimeDetailCopyWith<$Res> {
  factory $TimeDetailCopyWith(
          TimeDetail value, $Res Function(TimeDetail) then) =
      _$TimeDetailCopyWithImpl<$Res, TimeDetail>;
  @useResult
  $Res call(
      {@JsonKey(name: 'scheduled_start') String scheduledStart,
      @JsonKey(name: 'scheduled_end') String scheduledEnd,
      @JsonKey(name: 'scheduled_hours') double? scheduledHours,
      @JsonKey(name: 'actual_start') String? actualStart,
      @JsonKey(name: 'actual_end') String? actualEnd,
      @JsonKey(name: 'actual_hours') double? actualHours,
      @JsonKey(name: 'late_minutes') double? lateMinutes,
      @JsonKey(name: 'overtime_minutes') double? overtimeMinutes});
}

/// @nodoc
class _$TimeDetailCopyWithImpl<$Res, $Val extends TimeDetail>
    implements $TimeDetailCopyWith<$Res> {
  _$TimeDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TimeDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? scheduledStart = null,
    Object? scheduledEnd = null,
    Object? scheduledHours = freezed,
    Object? actualStart = freezed,
    Object? actualEnd = freezed,
    Object? actualHours = freezed,
    Object? lateMinutes = freezed,
    Object? overtimeMinutes = freezed,
  }) {
    return _then(_value.copyWith(
      scheduledStart: null == scheduledStart
          ? _value.scheduledStart
          : scheduledStart // ignore: cast_nullable_to_non_nullable
              as String,
      scheduledEnd: null == scheduledEnd
          ? _value.scheduledEnd
          : scheduledEnd // ignore: cast_nullable_to_non_nullable
              as String,
      scheduledHours: freezed == scheduledHours
          ? _value.scheduledHours
          : scheduledHours // ignore: cast_nullable_to_non_nullable
              as double?,
      actualStart: freezed == actualStart
          ? _value.actualStart
          : actualStart // ignore: cast_nullable_to_non_nullable
              as String?,
      actualEnd: freezed == actualEnd
          ? _value.actualEnd
          : actualEnd // ignore: cast_nullable_to_non_nullable
              as String?,
      actualHours: freezed == actualHours
          ? _value.actualHours
          : actualHours // ignore: cast_nullable_to_non_nullable
              as double?,
      lateMinutes: freezed == lateMinutes
          ? _value.lateMinutes
          : lateMinutes // ignore: cast_nullable_to_non_nullable
              as double?,
      overtimeMinutes: freezed == overtimeMinutes
          ? _value.overtimeMinutes
          : overtimeMinutes // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TimeDetailImplCopyWith<$Res>
    implements $TimeDetailCopyWith<$Res> {
  factory _$$TimeDetailImplCopyWith(
          _$TimeDetailImpl value, $Res Function(_$TimeDetailImpl) then) =
      __$$TimeDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'scheduled_start') String scheduledStart,
      @JsonKey(name: 'scheduled_end') String scheduledEnd,
      @JsonKey(name: 'scheduled_hours') double? scheduledHours,
      @JsonKey(name: 'actual_start') String? actualStart,
      @JsonKey(name: 'actual_end') String? actualEnd,
      @JsonKey(name: 'actual_hours') double? actualHours,
      @JsonKey(name: 'late_minutes') double? lateMinutes,
      @JsonKey(name: 'overtime_minutes') double? overtimeMinutes});
}

/// @nodoc
class __$$TimeDetailImplCopyWithImpl<$Res>
    extends _$TimeDetailCopyWithImpl<$Res, _$TimeDetailImpl>
    implements _$$TimeDetailImplCopyWith<$Res> {
  __$$TimeDetailImplCopyWithImpl(
      _$TimeDetailImpl _value, $Res Function(_$TimeDetailImpl) _then)
      : super(_value, _then);

  /// Create a copy of TimeDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? scheduledStart = null,
    Object? scheduledEnd = null,
    Object? scheduledHours = freezed,
    Object? actualStart = freezed,
    Object? actualEnd = freezed,
    Object? actualHours = freezed,
    Object? lateMinutes = freezed,
    Object? overtimeMinutes = freezed,
  }) {
    return _then(_$TimeDetailImpl(
      scheduledStart: null == scheduledStart
          ? _value.scheduledStart
          : scheduledStart // ignore: cast_nullable_to_non_nullable
              as String,
      scheduledEnd: null == scheduledEnd
          ? _value.scheduledEnd
          : scheduledEnd // ignore: cast_nullable_to_non_nullable
              as String,
      scheduledHours: freezed == scheduledHours
          ? _value.scheduledHours
          : scheduledHours // ignore: cast_nullable_to_non_nullable
              as double?,
      actualStart: freezed == actualStart
          ? _value.actualStart
          : actualStart // ignore: cast_nullable_to_non_nullable
              as String?,
      actualEnd: freezed == actualEnd
          ? _value.actualEnd
          : actualEnd // ignore: cast_nullable_to_non_nullable
              as String?,
      actualHours: freezed == actualHours
          ? _value.actualHours
          : actualHours // ignore: cast_nullable_to_non_nullable
              as double?,
      lateMinutes: freezed == lateMinutes
          ? _value.lateMinutes
          : lateMinutes // ignore: cast_nullable_to_non_nullable
              as double?,
      overtimeMinutes: freezed == overtimeMinutes
          ? _value.overtimeMinutes
          : overtimeMinutes // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TimeDetailImpl implements _TimeDetail {
  const _$TimeDetailImpl(
      {@JsonKey(name: 'scheduled_start') required this.scheduledStart,
      @JsonKey(name: 'scheduled_end') required this.scheduledEnd,
      @JsonKey(name: 'scheduled_hours') this.scheduledHours,
      @JsonKey(name: 'actual_start') this.actualStart,
      @JsonKey(name: 'actual_end') this.actualEnd,
      @JsonKey(name: 'actual_hours') this.actualHours,
      @JsonKey(name: 'late_minutes') this.lateMinutes,
      @JsonKey(name: 'overtime_minutes') this.overtimeMinutes});

  factory _$TimeDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$TimeDetailImplFromJson(json);

  @override
  @JsonKey(name: 'scheduled_start')
  final String scheduledStart;
  @override
  @JsonKey(name: 'scheduled_end')
  final String scheduledEnd;
  @override
  @JsonKey(name: 'scheduled_hours')
  final double? scheduledHours;
  @override
  @JsonKey(name: 'actual_start')
  final String? actualStart;
  @override
  @JsonKey(name: 'actual_end')
  final String? actualEnd;
  @override
  @JsonKey(name: 'actual_hours')
  final double? actualHours;
  @override
  @JsonKey(name: 'late_minutes')
  final double? lateMinutes;
  @override
  @JsonKey(name: 'overtime_minutes')
  final double? overtimeMinutes;

  @override
  String toString() {
    return 'TimeDetail(scheduledStart: $scheduledStart, scheduledEnd: $scheduledEnd, scheduledHours: $scheduledHours, actualStart: $actualStart, actualEnd: $actualEnd, actualHours: $actualHours, lateMinutes: $lateMinutes, overtimeMinutes: $overtimeMinutes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimeDetailImpl &&
            (identical(other.scheduledStart, scheduledStart) ||
                other.scheduledStart == scheduledStart) &&
            (identical(other.scheduledEnd, scheduledEnd) ||
                other.scheduledEnd == scheduledEnd) &&
            (identical(other.scheduledHours, scheduledHours) ||
                other.scheduledHours == scheduledHours) &&
            (identical(other.actualStart, actualStart) ||
                other.actualStart == actualStart) &&
            (identical(other.actualEnd, actualEnd) ||
                other.actualEnd == actualEnd) &&
            (identical(other.actualHours, actualHours) ||
                other.actualHours == actualHours) &&
            (identical(other.lateMinutes, lateMinutes) ||
                other.lateMinutes == lateMinutes) &&
            (identical(other.overtimeMinutes, overtimeMinutes) ||
                other.overtimeMinutes == overtimeMinutes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      scheduledStart,
      scheduledEnd,
      scheduledHours,
      actualStart,
      actualEnd,
      actualHours,
      lateMinutes,
      overtimeMinutes);

  /// Create a copy of TimeDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimeDetailImplCopyWith<_$TimeDetailImpl> get copyWith =>
      __$$TimeDetailImplCopyWithImpl<_$TimeDetailImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TimeDetailImplToJson(
      this,
    );
  }
}

abstract class _TimeDetail implements TimeDetail {
  const factory _TimeDetail(
      {@JsonKey(name: 'scheduled_start') required final String scheduledStart,
      @JsonKey(name: 'scheduled_end') required final String scheduledEnd,
      @JsonKey(name: 'scheduled_hours') final double? scheduledHours,
      @JsonKey(name: 'actual_start') final String? actualStart,
      @JsonKey(name: 'actual_end') final String? actualEnd,
      @JsonKey(name: 'actual_hours') final double? actualHours,
      @JsonKey(name: 'late_minutes') final double? lateMinutes,
      @JsonKey(name: 'overtime_minutes')
      final double? overtimeMinutes}) = _$TimeDetailImpl;

  factory _TimeDetail.fromJson(Map<String, dynamic> json) =
      _$TimeDetailImpl.fromJson;

  @override
  @JsonKey(name: 'scheduled_start')
  String get scheduledStart;
  @override
  @JsonKey(name: 'scheduled_end')
  String get scheduledEnd;
  @override
  @JsonKey(name: 'scheduled_hours')
  double? get scheduledHours;
  @override
  @JsonKey(name: 'actual_start')
  String? get actualStart;
  @override
  @JsonKey(name: 'actual_end')
  String? get actualEnd;
  @override
  @JsonKey(name: 'actual_hours')
  double? get actualHours;
  @override
  @JsonKey(name: 'late_minutes')
  double? get lateMinutes;
  @override
  @JsonKey(name: 'overtime_minutes')
  double? get overtimeMinutes;

  /// Create a copy of TimeDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimeDetailImplCopyWith<_$TimeDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ManagerAdjustment _$ManagerAdjustmentFromJson(Map<String, dynamic> json) {
  return _ManagerAdjustment.fromJson(json);
}

/// @nodoc
mixin _$ManagerAdjustment {
  @JsonKey(name: 'is_adjusted')
  bool get isAdjusted => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_start')
  String? get paymentStart => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_end')
  String? get paymentEnd => throw _privateConstructorUsedError;
  @JsonKey(name: 'final_penalty_minutes')
  int get finalPenaltyMinutes => throw _privateConstructorUsedError;
  @JsonKey(name: 'final_overtime_minutes')
  int get finalOvertimeMinutes => throw _privateConstructorUsedError;
  @JsonKey(name: 'adjusted_by')
  String? get adjustedBy => throw _privateConstructorUsedError;
  String? get reason => throw _privateConstructorUsedError;

  /// Serializes this ManagerAdjustment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ManagerAdjustment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ManagerAdjustmentCopyWith<ManagerAdjustment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ManagerAdjustmentCopyWith<$Res> {
  factory $ManagerAdjustmentCopyWith(
          ManagerAdjustment value, $Res Function(ManagerAdjustment) then) =
      _$ManagerAdjustmentCopyWithImpl<$Res, ManagerAdjustment>;
  @useResult
  $Res call(
      {@JsonKey(name: 'is_adjusted') bool isAdjusted,
      @JsonKey(name: 'payment_start') String? paymentStart,
      @JsonKey(name: 'payment_end') String? paymentEnd,
      @JsonKey(name: 'final_penalty_minutes') int finalPenaltyMinutes,
      @JsonKey(name: 'final_overtime_minutes') int finalOvertimeMinutes,
      @JsonKey(name: 'adjusted_by') String? adjustedBy,
      String? reason});
}

/// @nodoc
class _$ManagerAdjustmentCopyWithImpl<$Res, $Val extends ManagerAdjustment>
    implements $ManagerAdjustmentCopyWith<$Res> {
  _$ManagerAdjustmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ManagerAdjustment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isAdjusted = null,
    Object? paymentStart = freezed,
    Object? paymentEnd = freezed,
    Object? finalPenaltyMinutes = null,
    Object? finalOvertimeMinutes = null,
    Object? adjustedBy = freezed,
    Object? reason = freezed,
  }) {
    return _then(_value.copyWith(
      isAdjusted: null == isAdjusted
          ? _value.isAdjusted
          : isAdjusted // ignore: cast_nullable_to_non_nullable
              as bool,
      paymentStart: freezed == paymentStart
          ? _value.paymentStart
          : paymentStart // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentEnd: freezed == paymentEnd
          ? _value.paymentEnd
          : paymentEnd // ignore: cast_nullable_to_non_nullable
              as String?,
      finalPenaltyMinutes: null == finalPenaltyMinutes
          ? _value.finalPenaltyMinutes
          : finalPenaltyMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      finalOvertimeMinutes: null == finalOvertimeMinutes
          ? _value.finalOvertimeMinutes
          : finalOvertimeMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      adjustedBy: freezed == adjustedBy
          ? _value.adjustedBy
          : adjustedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ManagerAdjustmentImplCopyWith<$Res>
    implements $ManagerAdjustmentCopyWith<$Res> {
  factory _$$ManagerAdjustmentImplCopyWith(_$ManagerAdjustmentImpl value,
          $Res Function(_$ManagerAdjustmentImpl) then) =
      __$$ManagerAdjustmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'is_adjusted') bool isAdjusted,
      @JsonKey(name: 'payment_start') String? paymentStart,
      @JsonKey(name: 'payment_end') String? paymentEnd,
      @JsonKey(name: 'final_penalty_minutes') int finalPenaltyMinutes,
      @JsonKey(name: 'final_overtime_minutes') int finalOvertimeMinutes,
      @JsonKey(name: 'adjusted_by') String? adjustedBy,
      String? reason});
}

/// @nodoc
class __$$ManagerAdjustmentImplCopyWithImpl<$Res>
    extends _$ManagerAdjustmentCopyWithImpl<$Res, _$ManagerAdjustmentImpl>
    implements _$$ManagerAdjustmentImplCopyWith<$Res> {
  __$$ManagerAdjustmentImplCopyWithImpl(_$ManagerAdjustmentImpl _value,
      $Res Function(_$ManagerAdjustmentImpl) _then)
      : super(_value, _then);

  /// Create a copy of ManagerAdjustment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isAdjusted = null,
    Object? paymentStart = freezed,
    Object? paymentEnd = freezed,
    Object? finalPenaltyMinutes = null,
    Object? finalOvertimeMinutes = null,
    Object? adjustedBy = freezed,
    Object? reason = freezed,
  }) {
    return _then(_$ManagerAdjustmentImpl(
      isAdjusted: null == isAdjusted
          ? _value.isAdjusted
          : isAdjusted // ignore: cast_nullable_to_non_nullable
              as bool,
      paymentStart: freezed == paymentStart
          ? _value.paymentStart
          : paymentStart // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentEnd: freezed == paymentEnd
          ? _value.paymentEnd
          : paymentEnd // ignore: cast_nullable_to_non_nullable
              as String?,
      finalPenaltyMinutes: null == finalPenaltyMinutes
          ? _value.finalPenaltyMinutes
          : finalPenaltyMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      finalOvertimeMinutes: null == finalOvertimeMinutes
          ? _value.finalOvertimeMinutes
          : finalOvertimeMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      adjustedBy: freezed == adjustedBy
          ? _value.adjustedBy
          : adjustedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ManagerAdjustmentImpl implements _ManagerAdjustment {
  const _$ManagerAdjustmentImpl(
      {@JsonKey(name: 'is_adjusted') required this.isAdjusted,
      @JsonKey(name: 'payment_start') this.paymentStart,
      @JsonKey(name: 'payment_end') this.paymentEnd,
      @JsonKey(name: 'final_penalty_minutes') required this.finalPenaltyMinutes,
      @JsonKey(name: 'final_overtime_minutes')
      required this.finalOvertimeMinutes,
      @JsonKey(name: 'adjusted_by') this.adjustedBy,
      this.reason});

  factory _$ManagerAdjustmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$ManagerAdjustmentImplFromJson(json);

  @override
  @JsonKey(name: 'is_adjusted')
  final bool isAdjusted;
  @override
  @JsonKey(name: 'payment_start')
  final String? paymentStart;
  @override
  @JsonKey(name: 'payment_end')
  final String? paymentEnd;
  @override
  @JsonKey(name: 'final_penalty_minutes')
  final int finalPenaltyMinutes;
  @override
  @JsonKey(name: 'final_overtime_minutes')
  final int finalOvertimeMinutes;
  @override
  @JsonKey(name: 'adjusted_by')
  final String? adjustedBy;
  @override
  final String? reason;

  @override
  String toString() {
    return 'ManagerAdjustment(isAdjusted: $isAdjusted, paymentStart: $paymentStart, paymentEnd: $paymentEnd, finalPenaltyMinutes: $finalPenaltyMinutes, finalOvertimeMinutes: $finalOvertimeMinutes, adjustedBy: $adjustedBy, reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ManagerAdjustmentImpl &&
            (identical(other.isAdjusted, isAdjusted) ||
                other.isAdjusted == isAdjusted) &&
            (identical(other.paymentStart, paymentStart) ||
                other.paymentStart == paymentStart) &&
            (identical(other.paymentEnd, paymentEnd) ||
                other.paymentEnd == paymentEnd) &&
            (identical(other.finalPenaltyMinutes, finalPenaltyMinutes) ||
                other.finalPenaltyMinutes == finalPenaltyMinutes) &&
            (identical(other.finalOvertimeMinutes, finalOvertimeMinutes) ||
                other.finalOvertimeMinutes == finalOvertimeMinutes) &&
            (identical(other.adjustedBy, adjustedBy) ||
                other.adjustedBy == adjustedBy) &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      isAdjusted,
      paymentStart,
      paymentEnd,
      finalPenaltyMinutes,
      finalOvertimeMinutes,
      adjustedBy,
      reason);

  /// Create a copy of ManagerAdjustment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ManagerAdjustmentImplCopyWith<_$ManagerAdjustmentImpl> get copyWith =>
      __$$ManagerAdjustmentImplCopyWithImpl<_$ManagerAdjustmentImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ManagerAdjustmentImplToJson(
      this,
    );
  }
}

abstract class _ManagerAdjustment implements ManagerAdjustment {
  const factory _ManagerAdjustment(
      {@JsonKey(name: 'is_adjusted') required final bool isAdjusted,
      @JsonKey(name: 'payment_start') final String? paymentStart,
      @JsonKey(name: 'payment_end') final String? paymentEnd,
      @JsonKey(name: 'final_penalty_minutes')
      required final int finalPenaltyMinutes,
      @JsonKey(name: 'final_overtime_minutes')
      required final int finalOvertimeMinutes,
      @JsonKey(name: 'adjusted_by') final String? adjustedBy,
      final String? reason}) = _$ManagerAdjustmentImpl;

  factory _ManagerAdjustment.fromJson(Map<String, dynamic> json) =
      _$ManagerAdjustmentImpl.fromJson;

  @override
  @JsonKey(name: 'is_adjusted')
  bool get isAdjusted;
  @override
  @JsonKey(name: 'payment_start')
  String? get paymentStart;
  @override
  @JsonKey(name: 'payment_end')
  String? get paymentEnd;
  @override
  @JsonKey(name: 'final_penalty_minutes')
  int get finalPenaltyMinutes;
  @override
  @JsonKey(name: 'final_overtime_minutes')
  int get finalOvertimeMinutes;
  @override
  @JsonKey(name: 'adjusted_by')
  String? get adjustedBy;
  @override
  String? get reason;

  /// Create a copy of ManagerAdjustment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ManagerAdjustmentImplCopyWith<_$ManagerAdjustmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MonthlyPerformance _$MonthlyPerformanceFromJson(Map<String, dynamic> json) {
  return _MonthlyPerformance.fromJson(json);
}

/// @nodoc
mixin _$MonthlyPerformance {
  String? get month => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_shifts')
  int? get totalShifts => throw _privateConstructorUsedError;
  @JsonKey(name: 'attendance_rate')
  double? get attendanceRate => throw _privateConstructorUsedError;
  @JsonKey(name: 'late_count')
  int? get lateCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'avg_late_minutes')
  double? get avgLateMinutes => throw _privateConstructorUsedError;
  @JsonKey(name: 'no_checkin_count')
  int? get noCheckinCount => throw _privateConstructorUsedError;

  /// Serializes this MonthlyPerformance to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MonthlyPerformance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MonthlyPerformanceCopyWith<MonthlyPerformance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MonthlyPerformanceCopyWith<$Res> {
  factory $MonthlyPerformanceCopyWith(
          MonthlyPerformance value, $Res Function(MonthlyPerformance) then) =
      _$MonthlyPerformanceCopyWithImpl<$Res, MonthlyPerformance>;
  @useResult
  $Res call(
      {String? month,
      @JsonKey(name: 'total_shifts') int? totalShifts,
      @JsonKey(name: 'attendance_rate') double? attendanceRate,
      @JsonKey(name: 'late_count') int? lateCount,
      @JsonKey(name: 'avg_late_minutes') double? avgLateMinutes,
      @JsonKey(name: 'no_checkin_count') int? noCheckinCount});
}

/// @nodoc
class _$MonthlyPerformanceCopyWithImpl<$Res, $Val extends MonthlyPerformance>
    implements $MonthlyPerformanceCopyWith<$Res> {
  _$MonthlyPerformanceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MonthlyPerformance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? month = freezed,
    Object? totalShifts = freezed,
    Object? attendanceRate = freezed,
    Object? lateCount = freezed,
    Object? avgLateMinutes = freezed,
    Object? noCheckinCount = freezed,
  }) {
    return _then(_value.copyWith(
      month: freezed == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as String?,
      totalShifts: freezed == totalShifts
          ? _value.totalShifts
          : totalShifts // ignore: cast_nullable_to_non_nullable
              as int?,
      attendanceRate: freezed == attendanceRate
          ? _value.attendanceRate
          : attendanceRate // ignore: cast_nullable_to_non_nullable
              as double?,
      lateCount: freezed == lateCount
          ? _value.lateCount
          : lateCount // ignore: cast_nullable_to_non_nullable
              as int?,
      avgLateMinutes: freezed == avgLateMinutes
          ? _value.avgLateMinutes
          : avgLateMinutes // ignore: cast_nullable_to_non_nullable
              as double?,
      noCheckinCount: freezed == noCheckinCount
          ? _value.noCheckinCount
          : noCheckinCount // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MonthlyPerformanceImplCopyWith<$Res>
    implements $MonthlyPerformanceCopyWith<$Res> {
  factory _$$MonthlyPerformanceImplCopyWith(_$MonthlyPerformanceImpl value,
          $Res Function(_$MonthlyPerformanceImpl) then) =
      __$$MonthlyPerformanceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? month,
      @JsonKey(name: 'total_shifts') int? totalShifts,
      @JsonKey(name: 'attendance_rate') double? attendanceRate,
      @JsonKey(name: 'late_count') int? lateCount,
      @JsonKey(name: 'avg_late_minutes') double? avgLateMinutes,
      @JsonKey(name: 'no_checkin_count') int? noCheckinCount});
}

/// @nodoc
class __$$MonthlyPerformanceImplCopyWithImpl<$Res>
    extends _$MonthlyPerformanceCopyWithImpl<$Res, _$MonthlyPerformanceImpl>
    implements _$$MonthlyPerformanceImplCopyWith<$Res> {
  __$$MonthlyPerformanceImplCopyWithImpl(_$MonthlyPerformanceImpl _value,
      $Res Function(_$MonthlyPerformanceImpl) _then)
      : super(_value, _then);

  /// Create a copy of MonthlyPerformance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? month = freezed,
    Object? totalShifts = freezed,
    Object? attendanceRate = freezed,
    Object? lateCount = freezed,
    Object? avgLateMinutes = freezed,
    Object? noCheckinCount = freezed,
  }) {
    return _then(_$MonthlyPerformanceImpl(
      month: freezed == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as String?,
      totalShifts: freezed == totalShifts
          ? _value.totalShifts
          : totalShifts // ignore: cast_nullable_to_non_nullable
              as int?,
      attendanceRate: freezed == attendanceRate
          ? _value.attendanceRate
          : attendanceRate // ignore: cast_nullable_to_non_nullable
              as double?,
      lateCount: freezed == lateCount
          ? _value.lateCount
          : lateCount // ignore: cast_nullable_to_non_nullable
              as int?,
      avgLateMinutes: freezed == avgLateMinutes
          ? _value.avgLateMinutes
          : avgLateMinutes // ignore: cast_nullable_to_non_nullable
              as double?,
      noCheckinCount: freezed == noCheckinCount
          ? _value.noCheckinCount
          : noCheckinCount // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MonthlyPerformanceImpl implements _MonthlyPerformance {
  const _$MonthlyPerformanceImpl(
      {this.month,
      @JsonKey(name: 'total_shifts') this.totalShifts,
      @JsonKey(name: 'attendance_rate') this.attendanceRate,
      @JsonKey(name: 'late_count') this.lateCount,
      @JsonKey(name: 'avg_late_minutes') this.avgLateMinutes,
      @JsonKey(name: 'no_checkin_count') this.noCheckinCount});

  factory _$MonthlyPerformanceImpl.fromJson(Map<String, dynamic> json) =>
      _$$MonthlyPerformanceImplFromJson(json);

  @override
  final String? month;
  @override
  @JsonKey(name: 'total_shifts')
  final int? totalShifts;
  @override
  @JsonKey(name: 'attendance_rate')
  final double? attendanceRate;
  @override
  @JsonKey(name: 'late_count')
  final int? lateCount;
  @override
  @JsonKey(name: 'avg_late_minutes')
  final double? avgLateMinutes;
  @override
  @JsonKey(name: 'no_checkin_count')
  final int? noCheckinCount;

  @override
  String toString() {
    return 'MonthlyPerformance(month: $month, totalShifts: $totalShifts, attendanceRate: $attendanceRate, lateCount: $lateCount, avgLateMinutes: $avgLateMinutes, noCheckinCount: $noCheckinCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MonthlyPerformanceImpl &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.totalShifts, totalShifts) ||
                other.totalShifts == totalShifts) &&
            (identical(other.attendanceRate, attendanceRate) ||
                other.attendanceRate == attendanceRate) &&
            (identical(other.lateCount, lateCount) ||
                other.lateCount == lateCount) &&
            (identical(other.avgLateMinutes, avgLateMinutes) ||
                other.avgLateMinutes == avgLateMinutes) &&
            (identical(other.noCheckinCount, noCheckinCount) ||
                other.noCheckinCount == noCheckinCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, month, totalShifts,
      attendanceRate, lateCount, avgLateMinutes, noCheckinCount);

  /// Create a copy of MonthlyPerformance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MonthlyPerformanceImplCopyWith<_$MonthlyPerformanceImpl> get copyWith =>
      __$$MonthlyPerformanceImplCopyWithImpl<_$MonthlyPerformanceImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MonthlyPerformanceImplToJson(
      this,
    );
  }
}

abstract class _MonthlyPerformance implements MonthlyPerformance {
  const factory _MonthlyPerformance(
          {final String? month,
          @JsonKey(name: 'total_shifts') final int? totalShifts,
          @JsonKey(name: 'attendance_rate') final double? attendanceRate,
          @JsonKey(name: 'late_count') final int? lateCount,
          @JsonKey(name: 'avg_late_minutes') final double? avgLateMinutes,
          @JsonKey(name: 'no_checkin_count') final int? noCheckinCount}) =
      _$MonthlyPerformanceImpl;

  factory _MonthlyPerformance.fromJson(Map<String, dynamic> json) =
      _$MonthlyPerformanceImpl.fromJson;

  @override
  String? get month;
  @override
  @JsonKey(name: 'total_shifts')
  int? get totalShifts;
  @override
  @JsonKey(name: 'attendance_rate')
  double? get attendanceRate;
  @override
  @JsonKey(name: 'late_count')
  int? get lateCount;
  @override
  @JsonKey(name: 'avg_late_minutes')
  double? get avgLateMinutes;
  @override
  @JsonKey(name: 'no_checkin_count')
  int? get noCheckinCount;

  /// Create a copy of MonthlyPerformance
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MonthlyPerformanceImplCopyWith<_$MonthlyPerformanceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StorePerformance _$StorePerformanceFromJson(Map<String, dynamic> json) {
  return _StorePerformance.fromJson(json);
}

/// @nodoc
mixin _$StorePerformance {
  @JsonKey(name: 'store_id')
  String get storeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'store_name')
  String get storeName => throw _privateConstructorUsedError;
  @JsonKey(name: 'issues_count')
  int get issuesCount => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;

  /// Serializes this StorePerformance to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StorePerformance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StorePerformanceCopyWith<StorePerformance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StorePerformanceCopyWith<$Res> {
  factory $StorePerformanceCopyWith(
          StorePerformance value, $Res Function(StorePerformance) then) =
      _$StorePerformanceCopyWithImpl<$Res, StorePerformance>;
  @useResult
  $Res call(
      {@JsonKey(name: 'store_id') String storeId,
      @JsonKey(name: 'store_name') String storeName,
      @JsonKey(name: 'issues_count') int issuesCount,
      String status});
}

/// @nodoc
class _$StorePerformanceCopyWithImpl<$Res, $Val extends StorePerformance>
    implements $StorePerformanceCopyWith<$Res> {
  _$StorePerformanceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StorePerformance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? storeId = null,
    Object? storeName = null,
    Object? issuesCount = null,
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      storeName: null == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String,
      issuesCount: null == issuesCount
          ? _value.issuesCount
          : issuesCount // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StorePerformanceImplCopyWith<$Res>
    implements $StorePerformanceCopyWith<$Res> {
  factory _$$StorePerformanceImplCopyWith(_$StorePerformanceImpl value,
          $Res Function(_$StorePerformanceImpl) then) =
      __$$StorePerformanceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'store_id') String storeId,
      @JsonKey(name: 'store_name') String storeName,
      @JsonKey(name: 'issues_count') int issuesCount,
      String status});
}

/// @nodoc
class __$$StorePerformanceImplCopyWithImpl<$Res>
    extends _$StorePerformanceCopyWithImpl<$Res, _$StorePerformanceImpl>
    implements _$$StorePerformanceImplCopyWith<$Res> {
  __$$StorePerformanceImplCopyWithImpl(_$StorePerformanceImpl _value,
      $Res Function(_$StorePerformanceImpl) _then)
      : super(_value, _then);

  /// Create a copy of StorePerformance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? storeId = null,
    Object? storeName = null,
    Object? issuesCount = null,
    Object? status = null,
  }) {
    return _then(_$StorePerformanceImpl(
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      storeName: null == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String,
      issuesCount: null == issuesCount
          ? _value.issuesCount
          : issuesCount // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StorePerformanceImpl implements _StorePerformance {
  const _$StorePerformanceImpl(
      {@JsonKey(name: 'store_id') required this.storeId,
      @JsonKey(name: 'store_name') required this.storeName,
      @JsonKey(name: 'issues_count') required this.issuesCount,
      required this.status});

  factory _$StorePerformanceImpl.fromJson(Map<String, dynamic> json) =>
      _$$StorePerformanceImplFromJson(json);

  @override
  @JsonKey(name: 'store_id')
  final String storeId;
  @override
  @JsonKey(name: 'store_name')
  final String storeName;
  @override
  @JsonKey(name: 'issues_count')
  final int issuesCount;
  @override
  final String status;

  @override
  String toString() {
    return 'StorePerformance(storeId: $storeId, storeName: $storeName, issuesCount: $issuesCount, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StorePerformanceImpl &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.storeName, storeName) ||
                other.storeName == storeName) &&
            (identical(other.issuesCount, issuesCount) ||
                other.issuesCount == issuesCount) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, storeId, storeName, issuesCount, status);

  /// Create a copy of StorePerformance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StorePerformanceImplCopyWith<_$StorePerformanceImpl> get copyWith =>
      __$$StorePerformanceImplCopyWithImpl<_$StorePerformanceImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StorePerformanceImplToJson(
      this,
    );
  }
}

abstract class _StorePerformance implements StorePerformance {
  const factory _StorePerformance(
      {@JsonKey(name: 'store_id') required final String storeId,
      @JsonKey(name: 'store_name') required final String storeName,
      @JsonKey(name: 'issues_count') required final int issuesCount,
      required final String status}) = _$StorePerformanceImpl;

  factory _StorePerformance.fromJson(Map<String, dynamic> json) =
      _$StorePerformanceImpl.fromJson;

  @override
  @JsonKey(name: 'store_id')
  String get storeId;
  @override
  @JsonKey(name: 'store_name')
  String get storeName;
  @override
  @JsonKey(name: 'issues_count')
  int get issuesCount;
  @override
  String get status;

  /// Create a copy of StorePerformance
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StorePerformanceImplCopyWith<_$StorePerformanceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UrgentAction _$UrgentActionFromJson(Map<String, dynamic> json) {
  return _UrgentAction.fromJson(json);
}

/// @nodoc
mixin _$UrgentAction {
  String get priority => throw _privateConstructorUsedError;
  String get employee => throw _privateConstructorUsedError;
  String get store => throw _privateConstructorUsedError;
  String get issue => throw _privateConstructorUsedError;
  String get action => throw _privateConstructorUsedError;

  /// Serializes this UrgentAction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UrgentAction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UrgentActionCopyWith<UrgentAction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UrgentActionCopyWith<$Res> {
  factory $UrgentActionCopyWith(
          UrgentAction value, $Res Function(UrgentAction) then) =
      _$UrgentActionCopyWithImpl<$Res, UrgentAction>;
  @useResult
  $Res call(
      {String priority,
      String employee,
      String store,
      String issue,
      String action});
}

/// @nodoc
class _$UrgentActionCopyWithImpl<$Res, $Val extends UrgentAction>
    implements $UrgentActionCopyWith<$Res> {
  _$UrgentActionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UrgentAction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? priority = null,
    Object? employee = null,
    Object? store = null,
    Object? issue = null,
    Object? action = null,
  }) {
    return _then(_value.copyWith(
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
      employee: null == employee
          ? _value.employee
          : employee // ignore: cast_nullable_to_non_nullable
              as String,
      store: null == store
          ? _value.store
          : store // ignore: cast_nullable_to_non_nullable
              as String,
      issue: null == issue
          ? _value.issue
          : issue // ignore: cast_nullable_to_non_nullable
              as String,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UrgentActionImplCopyWith<$Res>
    implements $UrgentActionCopyWith<$Res> {
  factory _$$UrgentActionImplCopyWith(
          _$UrgentActionImpl value, $Res Function(_$UrgentActionImpl) then) =
      __$$UrgentActionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String priority,
      String employee,
      String store,
      String issue,
      String action});
}

/// @nodoc
class __$$UrgentActionImplCopyWithImpl<$Res>
    extends _$UrgentActionCopyWithImpl<$Res, _$UrgentActionImpl>
    implements _$$UrgentActionImplCopyWith<$Res> {
  __$$UrgentActionImplCopyWithImpl(
      _$UrgentActionImpl _value, $Res Function(_$UrgentActionImpl) _then)
      : super(_value, _then);

  /// Create a copy of UrgentAction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? priority = null,
    Object? employee = null,
    Object? store = null,
    Object? issue = null,
    Object? action = null,
  }) {
    return _then(_$UrgentActionImpl(
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
      employee: null == employee
          ? _value.employee
          : employee // ignore: cast_nullable_to_non_nullable
              as String,
      store: null == store
          ? _value.store
          : store // ignore: cast_nullable_to_non_nullable
              as String,
      issue: null == issue
          ? _value.issue
          : issue // ignore: cast_nullable_to_non_nullable
              as String,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UrgentActionImpl implements _UrgentAction {
  const _$UrgentActionImpl(
      {required this.priority,
      required this.employee,
      required this.store,
      required this.issue,
      required this.action});

  factory _$UrgentActionImpl.fromJson(Map<String, dynamic> json) =>
      _$$UrgentActionImplFromJson(json);

  @override
  final String priority;
  @override
  final String employee;
  @override
  final String store;
  @override
  final String issue;
  @override
  final String action;

  @override
  String toString() {
    return 'UrgentAction(priority: $priority, employee: $employee, store: $store, issue: $issue, action: $action)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UrgentActionImpl &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.employee, employee) ||
                other.employee == employee) &&
            (identical(other.store, store) || other.store == store) &&
            (identical(other.issue, issue) || other.issue == issue) &&
            (identical(other.action, action) || other.action == action));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, priority, employee, store, issue, action);

  /// Create a copy of UrgentAction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UrgentActionImplCopyWith<_$UrgentActionImpl> get copyWith =>
      __$$UrgentActionImplCopyWithImpl<_$UrgentActionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UrgentActionImplToJson(
      this,
    );
  }
}

abstract class _UrgentAction implements UrgentAction {
  const factory _UrgentAction(
      {required final String priority,
      required final String employee,
      required final String store,
      required final String issue,
      required final String action}) = _$UrgentActionImpl;

  factory _UrgentAction.fromJson(Map<String, dynamic> json) =
      _$UrgentActionImpl.fromJson;

  @override
  String get priority;
  @override
  String get employee;
  @override
  String get store;
  @override
  String get issue;
  @override
  String get action;

  /// Create a copy of UrgentAction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UrgentActionImplCopyWith<_$UrgentActionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ManagerQualityFlag _$ManagerQualityFlagFromJson(Map<String, dynamic> json) {
  return _ManagerQualityFlag.fromJson(json);
}

/// @nodoc
mixin _$ManagerQualityFlag {
  @JsonKey(name: 'flag_type')
  String get flagType => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'affected_employee')
  String? get affectedEmployee => throw _privateConstructorUsedError;
  String? get manager => throw _privateConstructorUsedError;

  /// Serializes this ManagerQualityFlag to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ManagerQualityFlag
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ManagerQualityFlagCopyWith<ManagerQualityFlag> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ManagerQualityFlagCopyWith<$Res> {
  factory $ManagerQualityFlagCopyWith(
          ManagerQualityFlag value, $Res Function(ManagerQualityFlag) then) =
      _$ManagerQualityFlagCopyWithImpl<$Res, ManagerQualityFlag>;
  @useResult
  $Res call(
      {@JsonKey(name: 'flag_type') String flagType,
      String description,
      @JsonKey(name: 'affected_employee') String? affectedEmployee,
      String? manager});
}

/// @nodoc
class _$ManagerQualityFlagCopyWithImpl<$Res, $Val extends ManagerQualityFlag>
    implements $ManagerQualityFlagCopyWith<$Res> {
  _$ManagerQualityFlagCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ManagerQualityFlag
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? flagType = null,
    Object? description = null,
    Object? affectedEmployee = freezed,
    Object? manager = freezed,
  }) {
    return _then(_value.copyWith(
      flagType: null == flagType
          ? _value.flagType
          : flagType // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      affectedEmployee: freezed == affectedEmployee
          ? _value.affectedEmployee
          : affectedEmployee // ignore: cast_nullable_to_non_nullable
              as String?,
      manager: freezed == manager
          ? _value.manager
          : manager // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ManagerQualityFlagImplCopyWith<$Res>
    implements $ManagerQualityFlagCopyWith<$Res> {
  factory _$$ManagerQualityFlagImplCopyWith(_$ManagerQualityFlagImpl value,
          $Res Function(_$ManagerQualityFlagImpl) then) =
      __$$ManagerQualityFlagImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'flag_type') String flagType,
      String description,
      @JsonKey(name: 'affected_employee') String? affectedEmployee,
      String? manager});
}

/// @nodoc
class __$$ManagerQualityFlagImplCopyWithImpl<$Res>
    extends _$ManagerQualityFlagCopyWithImpl<$Res, _$ManagerQualityFlagImpl>
    implements _$$ManagerQualityFlagImplCopyWith<$Res> {
  __$$ManagerQualityFlagImplCopyWithImpl(_$ManagerQualityFlagImpl _value,
      $Res Function(_$ManagerQualityFlagImpl) _then)
      : super(_value, _then);

  /// Create a copy of ManagerQualityFlag
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? flagType = null,
    Object? description = null,
    Object? affectedEmployee = freezed,
    Object? manager = freezed,
  }) {
    return _then(_$ManagerQualityFlagImpl(
      flagType: null == flagType
          ? _value.flagType
          : flagType // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      affectedEmployee: freezed == affectedEmployee
          ? _value.affectedEmployee
          : affectedEmployee // ignore: cast_nullable_to_non_nullable
              as String?,
      manager: freezed == manager
          ? _value.manager
          : manager // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ManagerQualityFlagImpl implements _ManagerQualityFlag {
  const _$ManagerQualityFlagImpl(
      {@JsonKey(name: 'flag_type') required this.flagType,
      required this.description,
      @JsonKey(name: 'affected_employee') this.affectedEmployee,
      this.manager});

  factory _$ManagerQualityFlagImpl.fromJson(Map<String, dynamic> json) =>
      _$$ManagerQualityFlagImplFromJson(json);

  @override
  @JsonKey(name: 'flag_type')
  final String flagType;
  @override
  final String description;
  @override
  @JsonKey(name: 'affected_employee')
  final String? affectedEmployee;
  @override
  final String? manager;

  @override
  String toString() {
    return 'ManagerQualityFlag(flagType: $flagType, description: $description, affectedEmployee: $affectedEmployee, manager: $manager)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ManagerQualityFlagImpl &&
            (identical(other.flagType, flagType) ||
                other.flagType == flagType) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.affectedEmployee, affectedEmployee) ||
                other.affectedEmployee == affectedEmployee) &&
            (identical(other.manager, manager) || other.manager == manager));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, flagType, description, affectedEmployee, manager);

  /// Create a copy of ManagerQualityFlag
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ManagerQualityFlagImplCopyWith<_$ManagerQualityFlagImpl> get copyWith =>
      __$$ManagerQualityFlagImplCopyWithImpl<_$ManagerQualityFlagImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ManagerQualityFlagImplToJson(
      this,
    );
  }
}

abstract class _ManagerQualityFlag implements ManagerQualityFlag {
  const factory _ManagerQualityFlag(
      {@JsonKey(name: 'flag_type') required final String flagType,
      required final String description,
      @JsonKey(name: 'affected_employee') final String? affectedEmployee,
      final String? manager}) = _$ManagerQualityFlagImpl;

  factory _ManagerQualityFlag.fromJson(Map<String, dynamic> json) =
      _$ManagerQualityFlagImpl.fromJson;

  @override
  @JsonKey(name: 'flag_type')
  String get flagType;
  @override
  String get description;
  @override
  @JsonKey(name: 'affected_employee')
  String? get affectedEmployee;
  @override
  String? get manager;

  /// Create a copy of ManagerQualityFlag
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ManagerQualityFlagImplCopyWith<_$ManagerQualityFlagImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
