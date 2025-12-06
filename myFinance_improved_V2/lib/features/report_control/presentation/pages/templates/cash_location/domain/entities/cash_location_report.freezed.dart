// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cash_location_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CashLocationReport _$CashLocationReportFromJson(Map<String, dynamic> json) {
  return _CashLocationReport.fromJson(json);
}

/// @nodoc
mixin _$CashLocationReport {
  /// Report metadata
  @JsonKey(name: 'report_date')
  String get reportDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'currency_symbol')
  String get currencySymbol => throw _privateConstructorUsedError;
  @JsonKey(name: 'currency_code')
  String get currencyCode => throw _privateConstructorUsedError;

  /// Hero stats for summary display
  @JsonKey(name: 'hero_stats')
  CashLocationHeroStats get heroStats => throw _privateConstructorUsedError;

  /// Locations grouped by store (optional - may not be in JSON)
  @JsonKey(name: 'locations_by_store')
  List<StoreLocations> get locationsByStore =>
      throw _privateConstructorUsedError;

  /// Recent cash entries (optional - may not be in JSON)
  @JsonKey(name: 'recent_entries')
  List<CashEntry> get recentEntries => throw _privateConstructorUsedError;

  /// Issues summary (locations with problems)
  @JsonKey(name: 'issues')
  List<CashLocationIssue> get issues => throw _privateConstructorUsedError;

  /// AI-generated insights
  @JsonKey(name: 'ai_insights')
  CashLocationInsights get aiInsights => throw _privateConstructorUsedError;

  /// Serializes this CashLocationReport to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CashLocationReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CashLocationReportCopyWith<CashLocationReport> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CashLocationReportCopyWith<$Res> {
  factory $CashLocationReportCopyWith(
          CashLocationReport value, $Res Function(CashLocationReport) then) =
      _$CashLocationReportCopyWithImpl<$Res, CashLocationReport>;
  @useResult
  $Res call(
      {@JsonKey(name: 'report_date') String reportDate,
      @JsonKey(name: 'currency_symbol') String currencySymbol,
      @JsonKey(name: 'currency_code') String currencyCode,
      @JsonKey(name: 'hero_stats') CashLocationHeroStats heroStats,
      @JsonKey(name: 'locations_by_store')
      List<StoreLocations> locationsByStore,
      @JsonKey(name: 'recent_entries') List<CashEntry> recentEntries,
      @JsonKey(name: 'issues') List<CashLocationIssue> issues,
      @JsonKey(name: 'ai_insights') CashLocationInsights aiInsights});

  $CashLocationHeroStatsCopyWith<$Res> get heroStats;
  $CashLocationInsightsCopyWith<$Res> get aiInsights;
}

/// @nodoc
class _$CashLocationReportCopyWithImpl<$Res, $Val extends CashLocationReport>
    implements $CashLocationReportCopyWith<$Res> {
  _$CashLocationReportCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CashLocationReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reportDate = null,
    Object? currencySymbol = null,
    Object? currencyCode = null,
    Object? heroStats = null,
    Object? locationsByStore = null,
    Object? recentEntries = null,
    Object? issues = null,
    Object? aiInsights = null,
  }) {
    return _then(_value.copyWith(
      reportDate: null == reportDate
          ? _value.reportDate
          : reportDate // ignore: cast_nullable_to_non_nullable
              as String,
      currencySymbol: null == currencySymbol
          ? _value.currencySymbol
          : currencySymbol // ignore: cast_nullable_to_non_nullable
              as String,
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      heroStats: null == heroStats
          ? _value.heroStats
          : heroStats // ignore: cast_nullable_to_non_nullable
              as CashLocationHeroStats,
      locationsByStore: null == locationsByStore
          ? _value.locationsByStore
          : locationsByStore // ignore: cast_nullable_to_non_nullable
              as List<StoreLocations>,
      recentEntries: null == recentEntries
          ? _value.recentEntries
          : recentEntries // ignore: cast_nullable_to_non_nullable
              as List<CashEntry>,
      issues: null == issues
          ? _value.issues
          : issues // ignore: cast_nullable_to_non_nullable
              as List<CashLocationIssue>,
      aiInsights: null == aiInsights
          ? _value.aiInsights
          : aiInsights // ignore: cast_nullable_to_non_nullable
              as CashLocationInsights,
    ) as $Val);
  }

  /// Create a copy of CashLocationReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CashLocationHeroStatsCopyWith<$Res> get heroStats {
    return $CashLocationHeroStatsCopyWith<$Res>(_value.heroStats, (value) {
      return _then(_value.copyWith(heroStats: value) as $Val);
    });
  }

  /// Create a copy of CashLocationReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CashLocationInsightsCopyWith<$Res> get aiInsights {
    return $CashLocationInsightsCopyWith<$Res>(_value.aiInsights, (value) {
      return _then(_value.copyWith(aiInsights: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CashLocationReportImplCopyWith<$Res>
    implements $CashLocationReportCopyWith<$Res> {
  factory _$$CashLocationReportImplCopyWith(_$CashLocationReportImpl value,
          $Res Function(_$CashLocationReportImpl) then) =
      __$$CashLocationReportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'report_date') String reportDate,
      @JsonKey(name: 'currency_symbol') String currencySymbol,
      @JsonKey(name: 'currency_code') String currencyCode,
      @JsonKey(name: 'hero_stats') CashLocationHeroStats heroStats,
      @JsonKey(name: 'locations_by_store')
      List<StoreLocations> locationsByStore,
      @JsonKey(name: 'recent_entries') List<CashEntry> recentEntries,
      @JsonKey(name: 'issues') List<CashLocationIssue> issues,
      @JsonKey(name: 'ai_insights') CashLocationInsights aiInsights});

  @override
  $CashLocationHeroStatsCopyWith<$Res> get heroStats;
  @override
  $CashLocationInsightsCopyWith<$Res> get aiInsights;
}

/// @nodoc
class __$$CashLocationReportImplCopyWithImpl<$Res>
    extends _$CashLocationReportCopyWithImpl<$Res, _$CashLocationReportImpl>
    implements _$$CashLocationReportImplCopyWith<$Res> {
  __$$CashLocationReportImplCopyWithImpl(_$CashLocationReportImpl _value,
      $Res Function(_$CashLocationReportImpl) _then)
      : super(_value, _then);

  /// Create a copy of CashLocationReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reportDate = null,
    Object? currencySymbol = null,
    Object? currencyCode = null,
    Object? heroStats = null,
    Object? locationsByStore = null,
    Object? recentEntries = null,
    Object? issues = null,
    Object? aiInsights = null,
  }) {
    return _then(_$CashLocationReportImpl(
      reportDate: null == reportDate
          ? _value.reportDate
          : reportDate // ignore: cast_nullable_to_non_nullable
              as String,
      currencySymbol: null == currencySymbol
          ? _value.currencySymbol
          : currencySymbol // ignore: cast_nullable_to_non_nullable
              as String,
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      heroStats: null == heroStats
          ? _value.heroStats
          : heroStats // ignore: cast_nullable_to_non_nullable
              as CashLocationHeroStats,
      locationsByStore: null == locationsByStore
          ? _value._locationsByStore
          : locationsByStore // ignore: cast_nullable_to_non_nullable
              as List<StoreLocations>,
      recentEntries: null == recentEntries
          ? _value._recentEntries
          : recentEntries // ignore: cast_nullable_to_non_nullable
              as List<CashEntry>,
      issues: null == issues
          ? _value._issues
          : issues // ignore: cast_nullable_to_non_nullable
              as List<CashLocationIssue>,
      aiInsights: null == aiInsights
          ? _value.aiInsights
          : aiInsights // ignore: cast_nullable_to_non_nullable
              as CashLocationInsights,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CashLocationReportImpl implements _CashLocationReport {
  const _$CashLocationReportImpl(
      {@JsonKey(name: 'report_date') required this.reportDate,
      @JsonKey(name: 'currency_symbol') this.currencySymbol = '₫',
      @JsonKey(name: 'currency_code') this.currencyCode = 'VND',
      @JsonKey(name: 'hero_stats') required this.heroStats,
      @JsonKey(name: 'locations_by_store')
      final List<StoreLocations> locationsByStore = const [],
      @JsonKey(name: 'recent_entries')
      final List<CashEntry> recentEntries = const [],
      @JsonKey(name: 'issues') final List<CashLocationIssue> issues = const [],
      @JsonKey(name: 'ai_insights') required this.aiInsights})
      : _locationsByStore = locationsByStore,
        _recentEntries = recentEntries,
        _issues = issues;

  factory _$CashLocationReportImpl.fromJson(Map<String, dynamic> json) =>
      _$$CashLocationReportImplFromJson(json);

  /// Report metadata
  @override
  @JsonKey(name: 'report_date')
  final String reportDate;
  @override
  @JsonKey(name: 'currency_symbol')
  final String currencySymbol;
  @override
  @JsonKey(name: 'currency_code')
  final String currencyCode;

  /// Hero stats for summary display
  @override
  @JsonKey(name: 'hero_stats')
  final CashLocationHeroStats heroStats;

  /// Locations grouped by store (optional - may not be in JSON)
  final List<StoreLocations> _locationsByStore;

  /// Locations grouped by store (optional - may not be in JSON)
  @override
  @JsonKey(name: 'locations_by_store')
  List<StoreLocations> get locationsByStore {
    if (_locationsByStore is EqualUnmodifiableListView)
      return _locationsByStore;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_locationsByStore);
  }

  /// Recent cash entries (optional - may not be in JSON)
  final List<CashEntry> _recentEntries;

  /// Recent cash entries (optional - may not be in JSON)
  @override
  @JsonKey(name: 'recent_entries')
  List<CashEntry> get recentEntries {
    if (_recentEntries is EqualUnmodifiableListView) return _recentEntries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentEntries);
  }

  /// Issues summary (locations with problems)
  final List<CashLocationIssue> _issues;

  /// Issues summary (locations with problems)
  @override
  @JsonKey(name: 'issues')
  List<CashLocationIssue> get issues {
    if (_issues is EqualUnmodifiableListView) return _issues;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_issues);
  }

  /// AI-generated insights
  @override
  @JsonKey(name: 'ai_insights')
  final CashLocationInsights aiInsights;

  @override
  String toString() {
    return 'CashLocationReport(reportDate: $reportDate, currencySymbol: $currencySymbol, currencyCode: $currencyCode, heroStats: $heroStats, locationsByStore: $locationsByStore, recentEntries: $recentEntries, issues: $issues, aiInsights: $aiInsights)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CashLocationReportImpl &&
            (identical(other.reportDate, reportDate) ||
                other.reportDate == reportDate) &&
            (identical(other.currencySymbol, currencySymbol) ||
                other.currencySymbol == currencySymbol) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.heroStats, heroStats) ||
                other.heroStats == heroStats) &&
            const DeepCollectionEquality()
                .equals(other._locationsByStore, _locationsByStore) &&
            const DeepCollectionEquality()
                .equals(other._recentEntries, _recentEntries) &&
            const DeepCollectionEquality().equals(other._issues, _issues) &&
            (identical(other.aiInsights, aiInsights) ||
                other.aiInsights == aiInsights));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      reportDate,
      currencySymbol,
      currencyCode,
      heroStats,
      const DeepCollectionEquality().hash(_locationsByStore),
      const DeepCollectionEquality().hash(_recentEntries),
      const DeepCollectionEquality().hash(_issues),
      aiInsights);

  /// Create a copy of CashLocationReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CashLocationReportImplCopyWith<_$CashLocationReportImpl> get copyWith =>
      __$$CashLocationReportImplCopyWithImpl<_$CashLocationReportImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CashLocationReportImplToJson(
      this,
    );
  }
}

abstract class _CashLocationReport implements CashLocationReport {
  const factory _CashLocationReport(
          {@JsonKey(name: 'report_date') required final String reportDate,
          @JsonKey(name: 'currency_symbol') final String currencySymbol,
          @JsonKey(name: 'currency_code') final String currencyCode,
          @JsonKey(name: 'hero_stats')
          required final CashLocationHeroStats heroStats,
          @JsonKey(name: 'locations_by_store')
          final List<StoreLocations> locationsByStore,
          @JsonKey(name: 'recent_entries') final List<CashEntry> recentEntries,
          @JsonKey(name: 'issues') final List<CashLocationIssue> issues,
          @JsonKey(name: 'ai_insights')
          required final CashLocationInsights aiInsights}) =
      _$CashLocationReportImpl;

  factory _CashLocationReport.fromJson(Map<String, dynamic> json) =
      _$CashLocationReportImpl.fromJson;

  /// Report metadata
  @override
  @JsonKey(name: 'report_date')
  String get reportDate;
  @override
  @JsonKey(name: 'currency_symbol')
  String get currencySymbol;
  @override
  @JsonKey(name: 'currency_code')
  String get currencyCode;

  /// Hero stats for summary display
  @override
  @JsonKey(name: 'hero_stats')
  CashLocationHeroStats get heroStats;

  /// Locations grouped by store (optional - may not be in JSON)
  @override
  @JsonKey(name: 'locations_by_store')
  List<StoreLocations> get locationsByStore;

  /// Recent cash entries (optional - may not be in JSON)
  @override
  @JsonKey(name: 'recent_entries')
  List<CashEntry> get recentEntries;

  /// Issues summary (locations with problems)
  @override
  @JsonKey(name: 'issues')
  List<CashLocationIssue> get issues;

  /// AI-generated insights
  @override
  @JsonKey(name: 'ai_insights')
  CashLocationInsights get aiInsights;

  /// Create a copy of CashLocationReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CashLocationReportImplCopyWith<_$CashLocationReportImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CashLocationHeroStats _$CashLocationHeroStatsFromJson(
    Map<String, dynamic> json) {
  return _CashLocationHeroStats.fromJson(json);
}

/// @nodoc
mixin _$CashLocationHeroStats {
  @JsonKey(name: 'total_locations')
  int get totalLocations => throw _privateConstructorUsedError;
  @JsonKey(name: 'balanced_count')
  int get balancedCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'issues_count')
  int get issuesCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'shortage_count')
  int get shortageCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'surplus_count')
  int get surplusCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_book_amount')
  double get totalBookAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_actual_amount')
  double get totalActualAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'net_difference')
  double get netDifference => throw _privateConstructorUsedError;
  @JsonKey(name: 'overall_status')
  String get overallStatus =>
      throw _privateConstructorUsedError; // Formatted strings
  @JsonKey(name: 'total_book_formatted')
  String get totalBookFormatted => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_actual_formatted')
  String get totalActualFormatted => throw _privateConstructorUsedError;
  @JsonKey(name: 'net_difference_formatted')
  String get netDifferenceFormatted => throw _privateConstructorUsedError;

  /// Serializes this CashLocationHeroStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CashLocationHeroStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CashLocationHeroStatsCopyWith<CashLocationHeroStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CashLocationHeroStatsCopyWith<$Res> {
  factory $CashLocationHeroStatsCopyWith(CashLocationHeroStats value,
          $Res Function(CashLocationHeroStats) then) =
      _$CashLocationHeroStatsCopyWithImpl<$Res, CashLocationHeroStats>;
  @useResult
  $Res call(
      {@JsonKey(name: 'total_locations') int totalLocations,
      @JsonKey(name: 'balanced_count') int balancedCount,
      @JsonKey(name: 'issues_count') int issuesCount,
      @JsonKey(name: 'shortage_count') int shortageCount,
      @JsonKey(name: 'surplus_count') int surplusCount,
      @JsonKey(name: 'total_book_amount') double totalBookAmount,
      @JsonKey(name: 'total_actual_amount') double totalActualAmount,
      @JsonKey(name: 'net_difference') double netDifference,
      @JsonKey(name: 'overall_status') String overallStatus,
      @JsonKey(name: 'total_book_formatted') String totalBookFormatted,
      @JsonKey(name: 'total_actual_formatted') String totalActualFormatted,
      @JsonKey(name: 'net_difference_formatted')
      String netDifferenceFormatted});
}

/// @nodoc
class _$CashLocationHeroStatsCopyWithImpl<$Res,
        $Val extends CashLocationHeroStats>
    implements $CashLocationHeroStatsCopyWith<$Res> {
  _$CashLocationHeroStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CashLocationHeroStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalLocations = null,
    Object? balancedCount = null,
    Object? issuesCount = null,
    Object? shortageCount = null,
    Object? surplusCount = null,
    Object? totalBookAmount = null,
    Object? totalActualAmount = null,
    Object? netDifference = null,
    Object? overallStatus = null,
    Object? totalBookFormatted = null,
    Object? totalActualFormatted = null,
    Object? netDifferenceFormatted = null,
  }) {
    return _then(_value.copyWith(
      totalLocations: null == totalLocations
          ? _value.totalLocations
          : totalLocations // ignore: cast_nullable_to_non_nullable
              as int,
      balancedCount: null == balancedCount
          ? _value.balancedCount
          : balancedCount // ignore: cast_nullable_to_non_nullable
              as int,
      issuesCount: null == issuesCount
          ? _value.issuesCount
          : issuesCount // ignore: cast_nullable_to_non_nullable
              as int,
      shortageCount: null == shortageCount
          ? _value.shortageCount
          : shortageCount // ignore: cast_nullable_to_non_nullable
              as int,
      surplusCount: null == surplusCount
          ? _value.surplusCount
          : surplusCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalBookAmount: null == totalBookAmount
          ? _value.totalBookAmount
          : totalBookAmount // ignore: cast_nullable_to_non_nullable
              as double,
      totalActualAmount: null == totalActualAmount
          ? _value.totalActualAmount
          : totalActualAmount // ignore: cast_nullable_to_non_nullable
              as double,
      netDifference: null == netDifference
          ? _value.netDifference
          : netDifference // ignore: cast_nullable_to_non_nullable
              as double,
      overallStatus: null == overallStatus
          ? _value.overallStatus
          : overallStatus // ignore: cast_nullable_to_non_nullable
              as String,
      totalBookFormatted: null == totalBookFormatted
          ? _value.totalBookFormatted
          : totalBookFormatted // ignore: cast_nullable_to_non_nullable
              as String,
      totalActualFormatted: null == totalActualFormatted
          ? _value.totalActualFormatted
          : totalActualFormatted // ignore: cast_nullable_to_non_nullable
              as String,
      netDifferenceFormatted: null == netDifferenceFormatted
          ? _value.netDifferenceFormatted
          : netDifferenceFormatted // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CashLocationHeroStatsImplCopyWith<$Res>
    implements $CashLocationHeroStatsCopyWith<$Res> {
  factory _$$CashLocationHeroStatsImplCopyWith(
          _$CashLocationHeroStatsImpl value,
          $Res Function(_$CashLocationHeroStatsImpl) then) =
      __$$CashLocationHeroStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'total_locations') int totalLocations,
      @JsonKey(name: 'balanced_count') int balancedCount,
      @JsonKey(name: 'issues_count') int issuesCount,
      @JsonKey(name: 'shortage_count') int shortageCount,
      @JsonKey(name: 'surplus_count') int surplusCount,
      @JsonKey(name: 'total_book_amount') double totalBookAmount,
      @JsonKey(name: 'total_actual_amount') double totalActualAmount,
      @JsonKey(name: 'net_difference') double netDifference,
      @JsonKey(name: 'overall_status') String overallStatus,
      @JsonKey(name: 'total_book_formatted') String totalBookFormatted,
      @JsonKey(name: 'total_actual_formatted') String totalActualFormatted,
      @JsonKey(name: 'net_difference_formatted')
      String netDifferenceFormatted});
}

/// @nodoc
class __$$CashLocationHeroStatsImplCopyWithImpl<$Res>
    extends _$CashLocationHeroStatsCopyWithImpl<$Res,
        _$CashLocationHeroStatsImpl>
    implements _$$CashLocationHeroStatsImplCopyWith<$Res> {
  __$$CashLocationHeroStatsImplCopyWithImpl(_$CashLocationHeroStatsImpl _value,
      $Res Function(_$CashLocationHeroStatsImpl) _then)
      : super(_value, _then);

  /// Create a copy of CashLocationHeroStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalLocations = null,
    Object? balancedCount = null,
    Object? issuesCount = null,
    Object? shortageCount = null,
    Object? surplusCount = null,
    Object? totalBookAmount = null,
    Object? totalActualAmount = null,
    Object? netDifference = null,
    Object? overallStatus = null,
    Object? totalBookFormatted = null,
    Object? totalActualFormatted = null,
    Object? netDifferenceFormatted = null,
  }) {
    return _then(_$CashLocationHeroStatsImpl(
      totalLocations: null == totalLocations
          ? _value.totalLocations
          : totalLocations // ignore: cast_nullable_to_non_nullable
              as int,
      balancedCount: null == balancedCount
          ? _value.balancedCount
          : balancedCount // ignore: cast_nullable_to_non_nullable
              as int,
      issuesCount: null == issuesCount
          ? _value.issuesCount
          : issuesCount // ignore: cast_nullable_to_non_nullable
              as int,
      shortageCount: null == shortageCount
          ? _value.shortageCount
          : shortageCount // ignore: cast_nullable_to_non_nullable
              as int,
      surplusCount: null == surplusCount
          ? _value.surplusCount
          : surplusCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalBookAmount: null == totalBookAmount
          ? _value.totalBookAmount
          : totalBookAmount // ignore: cast_nullable_to_non_nullable
              as double,
      totalActualAmount: null == totalActualAmount
          ? _value.totalActualAmount
          : totalActualAmount // ignore: cast_nullable_to_non_nullable
              as double,
      netDifference: null == netDifference
          ? _value.netDifference
          : netDifference // ignore: cast_nullable_to_non_nullable
              as double,
      overallStatus: null == overallStatus
          ? _value.overallStatus
          : overallStatus // ignore: cast_nullable_to_non_nullable
              as String,
      totalBookFormatted: null == totalBookFormatted
          ? _value.totalBookFormatted
          : totalBookFormatted // ignore: cast_nullable_to_non_nullable
              as String,
      totalActualFormatted: null == totalActualFormatted
          ? _value.totalActualFormatted
          : totalActualFormatted // ignore: cast_nullable_to_non_nullable
              as String,
      netDifferenceFormatted: null == netDifferenceFormatted
          ? _value.netDifferenceFormatted
          : netDifferenceFormatted // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CashLocationHeroStatsImpl implements _CashLocationHeroStats {
  const _$CashLocationHeroStatsImpl(
      {@JsonKey(name: 'total_locations') required this.totalLocations,
      @JsonKey(name: 'balanced_count') required this.balancedCount,
      @JsonKey(name: 'issues_count') required this.issuesCount,
      @JsonKey(name: 'shortage_count') this.shortageCount = 0,
      @JsonKey(name: 'surplus_count') this.surplusCount = 0,
      @JsonKey(name: 'total_book_amount') required this.totalBookAmount,
      @JsonKey(name: 'total_actual_amount') required this.totalActualAmount,
      @JsonKey(name: 'net_difference') required this.netDifference,
      @JsonKey(name: 'overall_status') required this.overallStatus,
      @JsonKey(name: 'total_book_formatted') required this.totalBookFormatted,
      @JsonKey(name: 'total_actual_formatted')
      required this.totalActualFormatted,
      @JsonKey(name: 'net_difference_formatted')
      required this.netDifferenceFormatted});

  factory _$CashLocationHeroStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$CashLocationHeroStatsImplFromJson(json);

  @override
  @JsonKey(name: 'total_locations')
  final int totalLocations;
  @override
  @JsonKey(name: 'balanced_count')
  final int balancedCount;
  @override
  @JsonKey(name: 'issues_count')
  final int issuesCount;
  @override
  @JsonKey(name: 'shortage_count')
  final int shortageCount;
  @override
  @JsonKey(name: 'surplus_count')
  final int surplusCount;
  @override
  @JsonKey(name: 'total_book_amount')
  final double totalBookAmount;
  @override
  @JsonKey(name: 'total_actual_amount')
  final double totalActualAmount;
  @override
  @JsonKey(name: 'net_difference')
  final double netDifference;
  @override
  @JsonKey(name: 'overall_status')
  final String overallStatus;
// Formatted strings
  @override
  @JsonKey(name: 'total_book_formatted')
  final String totalBookFormatted;
  @override
  @JsonKey(name: 'total_actual_formatted')
  final String totalActualFormatted;
  @override
  @JsonKey(name: 'net_difference_formatted')
  final String netDifferenceFormatted;

  @override
  String toString() {
    return 'CashLocationHeroStats(totalLocations: $totalLocations, balancedCount: $balancedCount, issuesCount: $issuesCount, shortageCount: $shortageCount, surplusCount: $surplusCount, totalBookAmount: $totalBookAmount, totalActualAmount: $totalActualAmount, netDifference: $netDifference, overallStatus: $overallStatus, totalBookFormatted: $totalBookFormatted, totalActualFormatted: $totalActualFormatted, netDifferenceFormatted: $netDifferenceFormatted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CashLocationHeroStatsImpl &&
            (identical(other.totalLocations, totalLocations) ||
                other.totalLocations == totalLocations) &&
            (identical(other.balancedCount, balancedCount) ||
                other.balancedCount == balancedCount) &&
            (identical(other.issuesCount, issuesCount) ||
                other.issuesCount == issuesCount) &&
            (identical(other.shortageCount, shortageCount) ||
                other.shortageCount == shortageCount) &&
            (identical(other.surplusCount, surplusCount) ||
                other.surplusCount == surplusCount) &&
            (identical(other.totalBookAmount, totalBookAmount) ||
                other.totalBookAmount == totalBookAmount) &&
            (identical(other.totalActualAmount, totalActualAmount) ||
                other.totalActualAmount == totalActualAmount) &&
            (identical(other.netDifference, netDifference) ||
                other.netDifference == netDifference) &&
            (identical(other.overallStatus, overallStatus) ||
                other.overallStatus == overallStatus) &&
            (identical(other.totalBookFormatted, totalBookFormatted) ||
                other.totalBookFormatted == totalBookFormatted) &&
            (identical(other.totalActualFormatted, totalActualFormatted) ||
                other.totalActualFormatted == totalActualFormatted) &&
            (identical(other.netDifferenceFormatted, netDifferenceFormatted) ||
                other.netDifferenceFormatted == netDifferenceFormatted));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalLocations,
      balancedCount,
      issuesCount,
      shortageCount,
      surplusCount,
      totalBookAmount,
      totalActualAmount,
      netDifference,
      overallStatus,
      totalBookFormatted,
      totalActualFormatted,
      netDifferenceFormatted);

  /// Create a copy of CashLocationHeroStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CashLocationHeroStatsImplCopyWith<_$CashLocationHeroStatsImpl>
      get copyWith => __$$CashLocationHeroStatsImplCopyWithImpl<
          _$CashLocationHeroStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CashLocationHeroStatsImplToJson(
      this,
    );
  }
}

abstract class _CashLocationHeroStats implements CashLocationHeroStats {
  const factory _CashLocationHeroStats(
      {@JsonKey(name: 'total_locations') required final int totalLocations,
      @JsonKey(name: 'balanced_count') required final int balancedCount,
      @JsonKey(name: 'issues_count') required final int issuesCount,
      @JsonKey(name: 'shortage_count') final int shortageCount,
      @JsonKey(name: 'surplus_count') final int surplusCount,
      @JsonKey(name: 'total_book_amount') required final double totalBookAmount,
      @JsonKey(name: 'total_actual_amount')
      required final double totalActualAmount,
      @JsonKey(name: 'net_difference') required final double netDifference,
      @JsonKey(name: 'overall_status') required final String overallStatus,
      @JsonKey(name: 'total_book_formatted')
      required final String totalBookFormatted,
      @JsonKey(name: 'total_actual_formatted')
      required final String totalActualFormatted,
      @JsonKey(name: 'net_difference_formatted')
      required final String
          netDifferenceFormatted}) = _$CashLocationHeroStatsImpl;

  factory _CashLocationHeroStats.fromJson(Map<String, dynamic> json) =
      _$CashLocationHeroStatsImpl.fromJson;

  @override
  @JsonKey(name: 'total_locations')
  int get totalLocations;
  @override
  @JsonKey(name: 'balanced_count')
  int get balancedCount;
  @override
  @JsonKey(name: 'issues_count')
  int get issuesCount;
  @override
  @JsonKey(name: 'shortage_count')
  int get shortageCount;
  @override
  @JsonKey(name: 'surplus_count')
  int get surplusCount;
  @override
  @JsonKey(name: 'total_book_amount')
  double get totalBookAmount;
  @override
  @JsonKey(name: 'total_actual_amount')
  double get totalActualAmount;
  @override
  @JsonKey(name: 'net_difference')
  double get netDifference;
  @override
  @JsonKey(name: 'overall_status')
  String get overallStatus; // Formatted strings
  @override
  @JsonKey(name: 'total_book_formatted')
  String get totalBookFormatted;
  @override
  @JsonKey(name: 'total_actual_formatted')
  String get totalActualFormatted;
  @override
  @JsonKey(name: 'net_difference_formatted')
  String get netDifferenceFormatted;

  /// Create a copy of CashLocationHeroStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CashLocationHeroStatsImplCopyWith<_$CashLocationHeroStatsImpl>
      get copyWith => throw _privateConstructorUsedError;
}

StoreLocations _$StoreLocationsFromJson(Map<String, dynamic> json) {
  return _StoreLocations.fromJson(json);
}

/// @nodoc
mixin _$StoreLocations {
  @JsonKey(name: 'store_id')
  String get storeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'store_name')
  String get storeName => throw _privateConstructorUsedError;
  @JsonKey(name: 'locations')
  List<CashLocation> get locations => throw _privateConstructorUsedError;
  @JsonKey(name: 'store_total_book')
  double get storeTotalBook => throw _privateConstructorUsedError;
  @JsonKey(name: 'store_total_actual')
  double get storeTotalActual => throw _privateConstructorUsedError;
  @JsonKey(name: 'store_difference')
  double get storeDifference => throw _privateConstructorUsedError;

  /// Serializes this StoreLocations to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StoreLocations
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StoreLocationsCopyWith<StoreLocations> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoreLocationsCopyWith<$Res> {
  factory $StoreLocationsCopyWith(
          StoreLocations value, $Res Function(StoreLocations) then) =
      _$StoreLocationsCopyWithImpl<$Res, StoreLocations>;
  @useResult
  $Res call(
      {@JsonKey(name: 'store_id') String storeId,
      @JsonKey(name: 'store_name') String storeName,
      @JsonKey(name: 'locations') List<CashLocation> locations,
      @JsonKey(name: 'store_total_book') double storeTotalBook,
      @JsonKey(name: 'store_total_actual') double storeTotalActual,
      @JsonKey(name: 'store_difference') double storeDifference});
}

/// @nodoc
class _$StoreLocationsCopyWithImpl<$Res, $Val extends StoreLocations>
    implements $StoreLocationsCopyWith<$Res> {
  _$StoreLocationsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StoreLocations
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? storeId = null,
    Object? storeName = null,
    Object? locations = null,
    Object? storeTotalBook = null,
    Object? storeTotalActual = null,
    Object? storeDifference = null,
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
      locations: null == locations
          ? _value.locations
          : locations // ignore: cast_nullable_to_non_nullable
              as List<CashLocation>,
      storeTotalBook: null == storeTotalBook
          ? _value.storeTotalBook
          : storeTotalBook // ignore: cast_nullable_to_non_nullable
              as double,
      storeTotalActual: null == storeTotalActual
          ? _value.storeTotalActual
          : storeTotalActual // ignore: cast_nullable_to_non_nullable
              as double,
      storeDifference: null == storeDifference
          ? _value.storeDifference
          : storeDifference // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StoreLocationsImplCopyWith<$Res>
    implements $StoreLocationsCopyWith<$Res> {
  factory _$$StoreLocationsImplCopyWith(_$StoreLocationsImpl value,
          $Res Function(_$StoreLocationsImpl) then) =
      __$$StoreLocationsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'store_id') String storeId,
      @JsonKey(name: 'store_name') String storeName,
      @JsonKey(name: 'locations') List<CashLocation> locations,
      @JsonKey(name: 'store_total_book') double storeTotalBook,
      @JsonKey(name: 'store_total_actual') double storeTotalActual,
      @JsonKey(name: 'store_difference') double storeDifference});
}

/// @nodoc
class __$$StoreLocationsImplCopyWithImpl<$Res>
    extends _$StoreLocationsCopyWithImpl<$Res, _$StoreLocationsImpl>
    implements _$$StoreLocationsImplCopyWith<$Res> {
  __$$StoreLocationsImplCopyWithImpl(
      _$StoreLocationsImpl _value, $Res Function(_$StoreLocationsImpl) _then)
      : super(_value, _then);

  /// Create a copy of StoreLocations
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? storeId = null,
    Object? storeName = null,
    Object? locations = null,
    Object? storeTotalBook = null,
    Object? storeTotalActual = null,
    Object? storeDifference = null,
  }) {
    return _then(_$StoreLocationsImpl(
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      storeName: null == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String,
      locations: null == locations
          ? _value._locations
          : locations // ignore: cast_nullable_to_non_nullable
              as List<CashLocation>,
      storeTotalBook: null == storeTotalBook
          ? _value.storeTotalBook
          : storeTotalBook // ignore: cast_nullable_to_non_nullable
              as double,
      storeTotalActual: null == storeTotalActual
          ? _value.storeTotalActual
          : storeTotalActual // ignore: cast_nullable_to_non_nullable
              as double,
      storeDifference: null == storeDifference
          ? _value.storeDifference
          : storeDifference // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StoreLocationsImpl implements _StoreLocations {
  const _$StoreLocationsImpl(
      {@JsonKey(name: 'store_id') required this.storeId,
      @JsonKey(name: 'store_name') required this.storeName,
      @JsonKey(name: 'locations') required final List<CashLocation> locations,
      @JsonKey(name: 'store_total_book') this.storeTotalBook = 0,
      @JsonKey(name: 'store_total_actual') this.storeTotalActual = 0,
      @JsonKey(name: 'store_difference') this.storeDifference = 0})
      : _locations = locations;

  factory _$StoreLocationsImpl.fromJson(Map<String, dynamic> json) =>
      _$$StoreLocationsImplFromJson(json);

  @override
  @JsonKey(name: 'store_id')
  final String storeId;
  @override
  @JsonKey(name: 'store_name')
  final String storeName;
  final List<CashLocation> _locations;
  @override
  @JsonKey(name: 'locations')
  List<CashLocation> get locations {
    if (_locations is EqualUnmodifiableListView) return _locations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_locations);
  }

  @override
  @JsonKey(name: 'store_total_book')
  final double storeTotalBook;
  @override
  @JsonKey(name: 'store_total_actual')
  final double storeTotalActual;
  @override
  @JsonKey(name: 'store_difference')
  final double storeDifference;

  @override
  String toString() {
    return 'StoreLocations(storeId: $storeId, storeName: $storeName, locations: $locations, storeTotalBook: $storeTotalBook, storeTotalActual: $storeTotalActual, storeDifference: $storeDifference)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoreLocationsImpl &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.storeName, storeName) ||
                other.storeName == storeName) &&
            const DeepCollectionEquality()
                .equals(other._locations, _locations) &&
            (identical(other.storeTotalBook, storeTotalBook) ||
                other.storeTotalBook == storeTotalBook) &&
            (identical(other.storeTotalActual, storeTotalActual) ||
                other.storeTotalActual == storeTotalActual) &&
            (identical(other.storeDifference, storeDifference) ||
                other.storeDifference == storeDifference));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      storeId,
      storeName,
      const DeepCollectionEquality().hash(_locations),
      storeTotalBook,
      storeTotalActual,
      storeDifference);

  /// Create a copy of StoreLocations
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StoreLocationsImplCopyWith<_$StoreLocationsImpl> get copyWith =>
      __$$StoreLocationsImplCopyWithImpl<_$StoreLocationsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StoreLocationsImplToJson(
      this,
    );
  }
}

abstract class _StoreLocations implements StoreLocations {
  const factory _StoreLocations(
      {@JsonKey(name: 'store_id') required final String storeId,
      @JsonKey(name: 'store_name') required final String storeName,
      @JsonKey(name: 'locations') required final List<CashLocation> locations,
      @JsonKey(name: 'store_total_book') final double storeTotalBook,
      @JsonKey(name: 'store_total_actual') final double storeTotalActual,
      @JsonKey(name: 'store_difference')
      final double storeDifference}) = _$StoreLocationsImpl;

  factory _StoreLocations.fromJson(Map<String, dynamic> json) =
      _$StoreLocationsImpl.fromJson;

  @override
  @JsonKey(name: 'store_id')
  String get storeId;
  @override
  @JsonKey(name: 'store_name')
  String get storeName;
  @override
  @JsonKey(name: 'locations')
  List<CashLocation> get locations;
  @override
  @JsonKey(name: 'store_total_book')
  double get storeTotalBook;
  @override
  @JsonKey(name: 'store_total_actual')
  double get storeTotalActual;
  @override
  @JsonKey(name: 'store_difference')
  double get storeDifference;

  /// Create a copy of StoreLocations
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoreLocationsImplCopyWith<_$StoreLocationsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CashLocation _$CashLocationFromJson(Map<String, dynamic> json) {
  return _CashLocation.fromJson(json);
}

/// @nodoc
mixin _$CashLocation {
  @JsonKey(name: 'location_id')
  String get locationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'location_name')
  String get locationName => throw _privateConstructorUsedError;
  @JsonKey(name: 'location_type')
  String get locationType =>
      throw _privateConstructorUsedError; // cash, bank, vault
  @JsonKey(name: 'book_amount')
  double get bookAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'actual_amount')
  double get actualAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'difference')
  double get difference => throw _privateConstructorUsedError;
  @JsonKey(name: 'status')
  String get status =>
      throw _privateConstructorUsedError; // balanced, shortage, surplus
// Formatted strings
  @JsonKey(name: 'book_formatted')
  String get bookFormatted => throw _privateConstructorUsedError;
  @JsonKey(name: 'actual_formatted')
  String get actualFormatted => throw _privateConstructorUsedError;
  @JsonKey(name: 'difference_formatted')
  String get differenceFormatted => throw _privateConstructorUsedError;

  /// Serializes this CashLocation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CashLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CashLocationCopyWith<CashLocation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CashLocationCopyWith<$Res> {
  factory $CashLocationCopyWith(
          CashLocation value, $Res Function(CashLocation) then) =
      _$CashLocationCopyWithImpl<$Res, CashLocation>;
  @useResult
  $Res call(
      {@JsonKey(name: 'location_id') String locationId,
      @JsonKey(name: 'location_name') String locationName,
      @JsonKey(name: 'location_type') String locationType,
      @JsonKey(name: 'book_amount') double bookAmount,
      @JsonKey(name: 'actual_amount') double actualAmount,
      @JsonKey(name: 'difference') double difference,
      @JsonKey(name: 'status') String status,
      @JsonKey(name: 'book_formatted') String bookFormatted,
      @JsonKey(name: 'actual_formatted') String actualFormatted,
      @JsonKey(name: 'difference_formatted') String differenceFormatted});
}

/// @nodoc
class _$CashLocationCopyWithImpl<$Res, $Val extends CashLocation>
    implements $CashLocationCopyWith<$Res> {
  _$CashLocationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CashLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? locationId = null,
    Object? locationName = null,
    Object? locationType = null,
    Object? bookAmount = null,
    Object? actualAmount = null,
    Object? difference = null,
    Object? status = null,
    Object? bookFormatted = null,
    Object? actualFormatted = null,
    Object? differenceFormatted = null,
  }) {
    return _then(_value.copyWith(
      locationId: null == locationId
          ? _value.locationId
          : locationId // ignore: cast_nullable_to_non_nullable
              as String,
      locationName: null == locationName
          ? _value.locationName
          : locationName // ignore: cast_nullable_to_non_nullable
              as String,
      locationType: null == locationType
          ? _value.locationType
          : locationType // ignore: cast_nullable_to_non_nullable
              as String,
      bookAmount: null == bookAmount
          ? _value.bookAmount
          : bookAmount // ignore: cast_nullable_to_non_nullable
              as double,
      actualAmount: null == actualAmount
          ? _value.actualAmount
          : actualAmount // ignore: cast_nullable_to_non_nullable
              as double,
      difference: null == difference
          ? _value.difference
          : difference // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      bookFormatted: null == bookFormatted
          ? _value.bookFormatted
          : bookFormatted // ignore: cast_nullable_to_non_nullable
              as String,
      actualFormatted: null == actualFormatted
          ? _value.actualFormatted
          : actualFormatted // ignore: cast_nullable_to_non_nullable
              as String,
      differenceFormatted: null == differenceFormatted
          ? _value.differenceFormatted
          : differenceFormatted // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CashLocationImplCopyWith<$Res>
    implements $CashLocationCopyWith<$Res> {
  factory _$$CashLocationImplCopyWith(
          _$CashLocationImpl value, $Res Function(_$CashLocationImpl) then) =
      __$$CashLocationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'location_id') String locationId,
      @JsonKey(name: 'location_name') String locationName,
      @JsonKey(name: 'location_type') String locationType,
      @JsonKey(name: 'book_amount') double bookAmount,
      @JsonKey(name: 'actual_amount') double actualAmount,
      @JsonKey(name: 'difference') double difference,
      @JsonKey(name: 'status') String status,
      @JsonKey(name: 'book_formatted') String bookFormatted,
      @JsonKey(name: 'actual_formatted') String actualFormatted,
      @JsonKey(name: 'difference_formatted') String differenceFormatted});
}

/// @nodoc
class __$$CashLocationImplCopyWithImpl<$Res>
    extends _$CashLocationCopyWithImpl<$Res, _$CashLocationImpl>
    implements _$$CashLocationImplCopyWith<$Res> {
  __$$CashLocationImplCopyWithImpl(
      _$CashLocationImpl _value, $Res Function(_$CashLocationImpl) _then)
      : super(_value, _then);

  /// Create a copy of CashLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? locationId = null,
    Object? locationName = null,
    Object? locationType = null,
    Object? bookAmount = null,
    Object? actualAmount = null,
    Object? difference = null,
    Object? status = null,
    Object? bookFormatted = null,
    Object? actualFormatted = null,
    Object? differenceFormatted = null,
  }) {
    return _then(_$CashLocationImpl(
      locationId: null == locationId
          ? _value.locationId
          : locationId // ignore: cast_nullable_to_non_nullable
              as String,
      locationName: null == locationName
          ? _value.locationName
          : locationName // ignore: cast_nullable_to_non_nullable
              as String,
      locationType: null == locationType
          ? _value.locationType
          : locationType // ignore: cast_nullable_to_non_nullable
              as String,
      bookAmount: null == bookAmount
          ? _value.bookAmount
          : bookAmount // ignore: cast_nullable_to_non_nullable
              as double,
      actualAmount: null == actualAmount
          ? _value.actualAmount
          : actualAmount // ignore: cast_nullable_to_non_nullable
              as double,
      difference: null == difference
          ? _value.difference
          : difference // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      bookFormatted: null == bookFormatted
          ? _value.bookFormatted
          : bookFormatted // ignore: cast_nullable_to_non_nullable
              as String,
      actualFormatted: null == actualFormatted
          ? _value.actualFormatted
          : actualFormatted // ignore: cast_nullable_to_non_nullable
              as String,
      differenceFormatted: null == differenceFormatted
          ? _value.differenceFormatted
          : differenceFormatted // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CashLocationImpl implements _CashLocation {
  const _$CashLocationImpl(
      {@JsonKey(name: 'location_id') required this.locationId,
      @JsonKey(name: 'location_name') required this.locationName,
      @JsonKey(name: 'location_type') required this.locationType,
      @JsonKey(name: 'book_amount') required this.bookAmount,
      @JsonKey(name: 'actual_amount') required this.actualAmount,
      @JsonKey(name: 'difference') required this.difference,
      @JsonKey(name: 'status') required this.status,
      @JsonKey(name: 'book_formatted') required this.bookFormatted,
      @JsonKey(name: 'actual_formatted') required this.actualFormatted,
      @JsonKey(name: 'difference_formatted')
      required this.differenceFormatted});

  factory _$CashLocationImpl.fromJson(Map<String, dynamic> json) =>
      _$$CashLocationImplFromJson(json);

  @override
  @JsonKey(name: 'location_id')
  final String locationId;
  @override
  @JsonKey(name: 'location_name')
  final String locationName;
  @override
  @JsonKey(name: 'location_type')
  final String locationType;
// cash, bank, vault
  @override
  @JsonKey(name: 'book_amount')
  final double bookAmount;
  @override
  @JsonKey(name: 'actual_amount')
  final double actualAmount;
  @override
  @JsonKey(name: 'difference')
  final double difference;
  @override
  @JsonKey(name: 'status')
  final String status;
// balanced, shortage, surplus
// Formatted strings
  @override
  @JsonKey(name: 'book_formatted')
  final String bookFormatted;
  @override
  @JsonKey(name: 'actual_formatted')
  final String actualFormatted;
  @override
  @JsonKey(name: 'difference_formatted')
  final String differenceFormatted;

  @override
  String toString() {
    return 'CashLocation(locationId: $locationId, locationName: $locationName, locationType: $locationType, bookAmount: $bookAmount, actualAmount: $actualAmount, difference: $difference, status: $status, bookFormatted: $bookFormatted, actualFormatted: $actualFormatted, differenceFormatted: $differenceFormatted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CashLocationImpl &&
            (identical(other.locationId, locationId) ||
                other.locationId == locationId) &&
            (identical(other.locationName, locationName) ||
                other.locationName == locationName) &&
            (identical(other.locationType, locationType) ||
                other.locationType == locationType) &&
            (identical(other.bookAmount, bookAmount) ||
                other.bookAmount == bookAmount) &&
            (identical(other.actualAmount, actualAmount) ||
                other.actualAmount == actualAmount) &&
            (identical(other.difference, difference) ||
                other.difference == difference) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.bookFormatted, bookFormatted) ||
                other.bookFormatted == bookFormatted) &&
            (identical(other.actualFormatted, actualFormatted) ||
                other.actualFormatted == actualFormatted) &&
            (identical(other.differenceFormatted, differenceFormatted) ||
                other.differenceFormatted == differenceFormatted));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      locationId,
      locationName,
      locationType,
      bookAmount,
      actualAmount,
      difference,
      status,
      bookFormatted,
      actualFormatted,
      differenceFormatted);

  /// Create a copy of CashLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CashLocationImplCopyWith<_$CashLocationImpl> get copyWith =>
      __$$CashLocationImplCopyWithImpl<_$CashLocationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CashLocationImplToJson(
      this,
    );
  }
}

abstract class _CashLocation implements CashLocation {
  const factory _CashLocation(
      {@JsonKey(name: 'location_id') required final String locationId,
      @JsonKey(name: 'location_name') required final String locationName,
      @JsonKey(name: 'location_type') required final String locationType,
      @JsonKey(name: 'book_amount') required final double bookAmount,
      @JsonKey(name: 'actual_amount') required final double actualAmount,
      @JsonKey(name: 'difference') required final double difference,
      @JsonKey(name: 'status') required final String status,
      @JsonKey(name: 'book_formatted') required final String bookFormatted,
      @JsonKey(name: 'actual_formatted') required final String actualFormatted,
      @JsonKey(name: 'difference_formatted')
      required final String differenceFormatted}) = _$CashLocationImpl;

  factory _CashLocation.fromJson(Map<String, dynamic> json) =
      _$CashLocationImpl.fromJson;

  @override
  @JsonKey(name: 'location_id')
  String get locationId;
  @override
  @JsonKey(name: 'location_name')
  String get locationName;
  @override
  @JsonKey(name: 'location_type')
  String get locationType; // cash, bank, vault
  @override
  @JsonKey(name: 'book_amount')
  double get bookAmount;
  @override
  @JsonKey(name: 'actual_amount')
  double get actualAmount;
  @override
  @JsonKey(name: 'difference')
  double get difference;
  @override
  @JsonKey(name: 'status')
  String get status; // balanced, shortage, surplus
// Formatted strings
  @override
  @JsonKey(name: 'book_formatted')
  String get bookFormatted;
  @override
  @JsonKey(name: 'actual_formatted')
  String get actualFormatted;
  @override
  @JsonKey(name: 'difference_formatted')
  String get differenceFormatted;

  /// Create a copy of CashLocation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CashLocationImplCopyWith<_$CashLocationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CashEntry _$CashEntryFromJson(Map<String, dynamic> json) {
  return _CashEntry.fromJson(json);
}

/// @nodoc
mixin _$CashEntry {
  @JsonKey(name: 'entry_id')
  String get entryId => throw _privateConstructorUsedError;
  @JsonKey(name: 'date')
  String get date => throw _privateConstructorUsedError;
  @JsonKey(name: 'location_name')
  String get locationName => throw _privateConstructorUsedError;
  @JsonKey(name: 'store_name')
  String get storeName => throw _privateConstructorUsedError;
  @JsonKey(name: 'employee_name')
  String get employeeName => throw _privateConstructorUsedError;
  @JsonKey(name: 'net_cash_flow')
  double get netCashFlow => throw _privateConstructorUsedError;
  @JsonKey(name: 'formatted_amount')
  String get formattedAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'description')
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'entry_type')
  String? get entryType => throw _privateConstructorUsedError;

  /// Serializes this CashEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CashEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CashEntryCopyWith<CashEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CashEntryCopyWith<$Res> {
  factory $CashEntryCopyWith(CashEntry value, $Res Function(CashEntry) then) =
      _$CashEntryCopyWithImpl<$Res, CashEntry>;
  @useResult
  $Res call(
      {@JsonKey(name: 'entry_id') String entryId,
      @JsonKey(name: 'date') String date,
      @JsonKey(name: 'location_name') String locationName,
      @JsonKey(name: 'store_name') String storeName,
      @JsonKey(name: 'employee_name') String employeeName,
      @JsonKey(name: 'net_cash_flow') double netCashFlow,
      @JsonKey(name: 'formatted_amount') String formattedAmount,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'entry_type') String? entryType});
}

/// @nodoc
class _$CashEntryCopyWithImpl<$Res, $Val extends CashEntry>
    implements $CashEntryCopyWith<$Res> {
  _$CashEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CashEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? entryId = null,
    Object? date = null,
    Object? locationName = null,
    Object? storeName = null,
    Object? employeeName = null,
    Object? netCashFlow = null,
    Object? formattedAmount = null,
    Object? description = freezed,
    Object? entryType = freezed,
  }) {
    return _then(_value.copyWith(
      entryId: null == entryId
          ? _value.entryId
          : entryId // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      locationName: null == locationName
          ? _value.locationName
          : locationName // ignore: cast_nullable_to_non_nullable
              as String,
      storeName: null == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String,
      employeeName: null == employeeName
          ? _value.employeeName
          : employeeName // ignore: cast_nullable_to_non_nullable
              as String,
      netCashFlow: null == netCashFlow
          ? _value.netCashFlow
          : netCashFlow // ignore: cast_nullable_to_non_nullable
              as double,
      formattedAmount: null == formattedAmount
          ? _value.formattedAmount
          : formattedAmount // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      entryType: freezed == entryType
          ? _value.entryType
          : entryType // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CashEntryImplCopyWith<$Res>
    implements $CashEntryCopyWith<$Res> {
  factory _$$CashEntryImplCopyWith(
          _$CashEntryImpl value, $Res Function(_$CashEntryImpl) then) =
      __$$CashEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'entry_id') String entryId,
      @JsonKey(name: 'date') String date,
      @JsonKey(name: 'location_name') String locationName,
      @JsonKey(name: 'store_name') String storeName,
      @JsonKey(name: 'employee_name') String employeeName,
      @JsonKey(name: 'net_cash_flow') double netCashFlow,
      @JsonKey(name: 'formatted_amount') String formattedAmount,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'entry_type') String? entryType});
}

/// @nodoc
class __$$CashEntryImplCopyWithImpl<$Res>
    extends _$CashEntryCopyWithImpl<$Res, _$CashEntryImpl>
    implements _$$CashEntryImplCopyWith<$Res> {
  __$$CashEntryImplCopyWithImpl(
      _$CashEntryImpl _value, $Res Function(_$CashEntryImpl) _then)
      : super(_value, _then);

  /// Create a copy of CashEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? entryId = null,
    Object? date = null,
    Object? locationName = null,
    Object? storeName = null,
    Object? employeeName = null,
    Object? netCashFlow = null,
    Object? formattedAmount = null,
    Object? description = freezed,
    Object? entryType = freezed,
  }) {
    return _then(_$CashEntryImpl(
      entryId: null == entryId
          ? _value.entryId
          : entryId // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      locationName: null == locationName
          ? _value.locationName
          : locationName // ignore: cast_nullable_to_non_nullable
              as String,
      storeName: null == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String,
      employeeName: null == employeeName
          ? _value.employeeName
          : employeeName // ignore: cast_nullable_to_non_nullable
              as String,
      netCashFlow: null == netCashFlow
          ? _value.netCashFlow
          : netCashFlow // ignore: cast_nullable_to_non_nullable
              as double,
      formattedAmount: null == formattedAmount
          ? _value.formattedAmount
          : formattedAmount // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      entryType: freezed == entryType
          ? _value.entryType
          : entryType // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CashEntryImpl implements _CashEntry {
  const _$CashEntryImpl(
      {@JsonKey(name: 'entry_id') required this.entryId,
      @JsonKey(name: 'date') required this.date,
      @JsonKey(name: 'location_name') required this.locationName,
      @JsonKey(name: 'store_name') required this.storeName,
      @JsonKey(name: 'employee_name') required this.employeeName,
      @JsonKey(name: 'net_cash_flow') required this.netCashFlow,
      @JsonKey(name: 'formatted_amount') required this.formattedAmount,
      @JsonKey(name: 'description') this.description,
      @JsonKey(name: 'entry_type') this.entryType});

  factory _$CashEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$CashEntryImplFromJson(json);

  @override
  @JsonKey(name: 'entry_id')
  final String entryId;
  @override
  @JsonKey(name: 'date')
  final String date;
  @override
  @JsonKey(name: 'location_name')
  final String locationName;
  @override
  @JsonKey(name: 'store_name')
  final String storeName;
  @override
  @JsonKey(name: 'employee_name')
  final String employeeName;
  @override
  @JsonKey(name: 'net_cash_flow')
  final double netCashFlow;
  @override
  @JsonKey(name: 'formatted_amount')
  final String formattedAmount;
  @override
  @JsonKey(name: 'description')
  final String? description;
  @override
  @JsonKey(name: 'entry_type')
  final String? entryType;

  @override
  String toString() {
    return 'CashEntry(entryId: $entryId, date: $date, locationName: $locationName, storeName: $storeName, employeeName: $employeeName, netCashFlow: $netCashFlow, formattedAmount: $formattedAmount, description: $description, entryType: $entryType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CashEntryImpl &&
            (identical(other.entryId, entryId) || other.entryId == entryId) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.locationName, locationName) ||
                other.locationName == locationName) &&
            (identical(other.storeName, storeName) ||
                other.storeName == storeName) &&
            (identical(other.employeeName, employeeName) ||
                other.employeeName == employeeName) &&
            (identical(other.netCashFlow, netCashFlow) ||
                other.netCashFlow == netCashFlow) &&
            (identical(other.formattedAmount, formattedAmount) ||
                other.formattedAmount == formattedAmount) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.entryType, entryType) ||
                other.entryType == entryType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      entryId,
      date,
      locationName,
      storeName,
      employeeName,
      netCashFlow,
      formattedAmount,
      description,
      entryType);

  /// Create a copy of CashEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CashEntryImplCopyWith<_$CashEntryImpl> get copyWith =>
      __$$CashEntryImplCopyWithImpl<_$CashEntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CashEntryImplToJson(
      this,
    );
  }
}

abstract class _CashEntry implements CashEntry {
  const factory _CashEntry(
      {@JsonKey(name: 'entry_id') required final String entryId,
      @JsonKey(name: 'date') required final String date,
      @JsonKey(name: 'location_name') required final String locationName,
      @JsonKey(name: 'store_name') required final String storeName,
      @JsonKey(name: 'employee_name') required final String employeeName,
      @JsonKey(name: 'net_cash_flow') required final double netCashFlow,
      @JsonKey(name: 'formatted_amount') required final String formattedAmount,
      @JsonKey(name: 'description') final String? description,
      @JsonKey(name: 'entry_type') final String? entryType}) = _$CashEntryImpl;

  factory _CashEntry.fromJson(Map<String, dynamic> json) =
      _$CashEntryImpl.fromJson;

  @override
  @JsonKey(name: 'entry_id')
  String get entryId;
  @override
  @JsonKey(name: 'date')
  String get date;
  @override
  @JsonKey(name: 'location_name')
  String get locationName;
  @override
  @JsonKey(name: 'store_name')
  String get storeName;
  @override
  @JsonKey(name: 'employee_name')
  String get employeeName;
  @override
  @JsonKey(name: 'net_cash_flow')
  double get netCashFlow;
  @override
  @JsonKey(name: 'formatted_amount')
  String get formattedAmount;
  @override
  @JsonKey(name: 'description')
  String? get description;
  @override
  @JsonKey(name: 'entry_type')
  String? get entryType;

  /// Create a copy of CashEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CashEntryImplCopyWith<_$CashEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CashLocationIssue _$CashLocationIssueFromJson(Map<String, dynamic> json) {
  return _CashLocationIssue.fromJson(json);
}

/// @nodoc
mixin _$CashLocationIssue {
  @JsonKey(name: 'location_id')
  String get locationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'location_name')
  String get locationName => throw _privateConstructorUsedError;
  @JsonKey(name: 'location_type')
  String get locationType =>
      throw _privateConstructorUsedError; // cash, bank, vault
  @JsonKey(name: 'store_id')
  String get storeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'store_name')
  String get storeName => throw _privateConstructorUsedError; // Amounts
  @JsonKey(name: 'book_amount')
  double get bookAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'actual_amount')
  double get actualAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'difference')
  double get difference => throw _privateConstructorUsedError; // Formatted
  @JsonKey(name: 'book_formatted')
  String get bookFormatted => throw _privateConstructorUsedError;
  @JsonKey(name: 'actual_formatted')
  String get actualFormatted => throw _privateConstructorUsedError;
  @JsonKey(name: 'difference_formatted')
  String get differenceFormatted =>
      throw _privateConstructorUsedError; // Issue info
  @JsonKey(name: 'issue_type')
  String get issueType =>
      throw _privateConstructorUsedError; // shortage, surplus
  @JsonKey(name: 'severity')
  String get severity =>
      throw _privateConstructorUsedError; // low, medium, high
// Last entry (for investigation)
  @JsonKey(name: 'last_entry')
  LastEntryInfo? get lastEntry => throw _privateConstructorUsedError;

  /// Serializes this CashLocationIssue to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CashLocationIssue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CashLocationIssueCopyWith<CashLocationIssue> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CashLocationIssueCopyWith<$Res> {
  factory $CashLocationIssueCopyWith(
          CashLocationIssue value, $Res Function(CashLocationIssue) then) =
      _$CashLocationIssueCopyWithImpl<$Res, CashLocationIssue>;
  @useResult
  $Res call(
      {@JsonKey(name: 'location_id') String locationId,
      @JsonKey(name: 'location_name') String locationName,
      @JsonKey(name: 'location_type') String locationType,
      @JsonKey(name: 'store_id') String storeId,
      @JsonKey(name: 'store_name') String storeName,
      @JsonKey(name: 'book_amount') double bookAmount,
      @JsonKey(name: 'actual_amount') double actualAmount,
      @JsonKey(name: 'difference') double difference,
      @JsonKey(name: 'book_formatted') String bookFormatted,
      @JsonKey(name: 'actual_formatted') String actualFormatted,
      @JsonKey(name: 'difference_formatted') String differenceFormatted,
      @JsonKey(name: 'issue_type') String issueType,
      @JsonKey(name: 'severity') String severity,
      @JsonKey(name: 'last_entry') LastEntryInfo? lastEntry});

  $LastEntryInfoCopyWith<$Res>? get lastEntry;
}

/// @nodoc
class _$CashLocationIssueCopyWithImpl<$Res, $Val extends CashLocationIssue>
    implements $CashLocationIssueCopyWith<$Res> {
  _$CashLocationIssueCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CashLocationIssue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? locationId = null,
    Object? locationName = null,
    Object? locationType = null,
    Object? storeId = null,
    Object? storeName = null,
    Object? bookAmount = null,
    Object? actualAmount = null,
    Object? difference = null,
    Object? bookFormatted = null,
    Object? actualFormatted = null,
    Object? differenceFormatted = null,
    Object? issueType = null,
    Object? severity = null,
    Object? lastEntry = freezed,
  }) {
    return _then(_value.copyWith(
      locationId: null == locationId
          ? _value.locationId
          : locationId // ignore: cast_nullable_to_non_nullable
              as String,
      locationName: null == locationName
          ? _value.locationName
          : locationName // ignore: cast_nullable_to_non_nullable
              as String,
      locationType: null == locationType
          ? _value.locationType
          : locationType // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      storeName: null == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String,
      bookAmount: null == bookAmount
          ? _value.bookAmount
          : bookAmount // ignore: cast_nullable_to_non_nullable
              as double,
      actualAmount: null == actualAmount
          ? _value.actualAmount
          : actualAmount // ignore: cast_nullable_to_non_nullable
              as double,
      difference: null == difference
          ? _value.difference
          : difference // ignore: cast_nullable_to_non_nullable
              as double,
      bookFormatted: null == bookFormatted
          ? _value.bookFormatted
          : bookFormatted // ignore: cast_nullable_to_non_nullable
              as String,
      actualFormatted: null == actualFormatted
          ? _value.actualFormatted
          : actualFormatted // ignore: cast_nullable_to_non_nullable
              as String,
      differenceFormatted: null == differenceFormatted
          ? _value.differenceFormatted
          : differenceFormatted // ignore: cast_nullable_to_non_nullable
              as String,
      issueType: null == issueType
          ? _value.issueType
          : issueType // ignore: cast_nullable_to_non_nullable
              as String,
      severity: null == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as String,
      lastEntry: freezed == lastEntry
          ? _value.lastEntry
          : lastEntry // ignore: cast_nullable_to_non_nullable
              as LastEntryInfo?,
    ) as $Val);
  }

  /// Create a copy of CashLocationIssue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LastEntryInfoCopyWith<$Res>? get lastEntry {
    if (_value.lastEntry == null) {
      return null;
    }

    return $LastEntryInfoCopyWith<$Res>(_value.lastEntry!, (value) {
      return _then(_value.copyWith(lastEntry: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CashLocationIssueImplCopyWith<$Res>
    implements $CashLocationIssueCopyWith<$Res> {
  factory _$$CashLocationIssueImplCopyWith(_$CashLocationIssueImpl value,
          $Res Function(_$CashLocationIssueImpl) then) =
      __$$CashLocationIssueImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'location_id') String locationId,
      @JsonKey(name: 'location_name') String locationName,
      @JsonKey(name: 'location_type') String locationType,
      @JsonKey(name: 'store_id') String storeId,
      @JsonKey(name: 'store_name') String storeName,
      @JsonKey(name: 'book_amount') double bookAmount,
      @JsonKey(name: 'actual_amount') double actualAmount,
      @JsonKey(name: 'difference') double difference,
      @JsonKey(name: 'book_formatted') String bookFormatted,
      @JsonKey(name: 'actual_formatted') String actualFormatted,
      @JsonKey(name: 'difference_formatted') String differenceFormatted,
      @JsonKey(name: 'issue_type') String issueType,
      @JsonKey(name: 'severity') String severity,
      @JsonKey(name: 'last_entry') LastEntryInfo? lastEntry});

  @override
  $LastEntryInfoCopyWith<$Res>? get lastEntry;
}

/// @nodoc
class __$$CashLocationIssueImplCopyWithImpl<$Res>
    extends _$CashLocationIssueCopyWithImpl<$Res, _$CashLocationIssueImpl>
    implements _$$CashLocationIssueImplCopyWith<$Res> {
  __$$CashLocationIssueImplCopyWithImpl(_$CashLocationIssueImpl _value,
      $Res Function(_$CashLocationIssueImpl) _then)
      : super(_value, _then);

  /// Create a copy of CashLocationIssue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? locationId = null,
    Object? locationName = null,
    Object? locationType = null,
    Object? storeId = null,
    Object? storeName = null,
    Object? bookAmount = null,
    Object? actualAmount = null,
    Object? difference = null,
    Object? bookFormatted = null,
    Object? actualFormatted = null,
    Object? differenceFormatted = null,
    Object? issueType = null,
    Object? severity = null,
    Object? lastEntry = freezed,
  }) {
    return _then(_$CashLocationIssueImpl(
      locationId: null == locationId
          ? _value.locationId
          : locationId // ignore: cast_nullable_to_non_nullable
              as String,
      locationName: null == locationName
          ? _value.locationName
          : locationName // ignore: cast_nullable_to_non_nullable
              as String,
      locationType: null == locationType
          ? _value.locationType
          : locationType // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      storeName: null == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String,
      bookAmount: null == bookAmount
          ? _value.bookAmount
          : bookAmount // ignore: cast_nullable_to_non_nullable
              as double,
      actualAmount: null == actualAmount
          ? _value.actualAmount
          : actualAmount // ignore: cast_nullable_to_non_nullable
              as double,
      difference: null == difference
          ? _value.difference
          : difference // ignore: cast_nullable_to_non_nullable
              as double,
      bookFormatted: null == bookFormatted
          ? _value.bookFormatted
          : bookFormatted // ignore: cast_nullable_to_non_nullable
              as String,
      actualFormatted: null == actualFormatted
          ? _value.actualFormatted
          : actualFormatted // ignore: cast_nullable_to_non_nullable
              as String,
      differenceFormatted: null == differenceFormatted
          ? _value.differenceFormatted
          : differenceFormatted // ignore: cast_nullable_to_non_nullable
              as String,
      issueType: null == issueType
          ? _value.issueType
          : issueType // ignore: cast_nullable_to_non_nullable
              as String,
      severity: null == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as String,
      lastEntry: freezed == lastEntry
          ? _value.lastEntry
          : lastEntry // ignore: cast_nullable_to_non_nullable
              as LastEntryInfo?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CashLocationIssueImpl implements _CashLocationIssue {
  const _$CashLocationIssueImpl(
      {@JsonKey(name: 'location_id') required this.locationId,
      @JsonKey(name: 'location_name') required this.locationName,
      @JsonKey(name: 'location_type') required this.locationType,
      @JsonKey(name: 'store_id') required this.storeId,
      @JsonKey(name: 'store_name') required this.storeName,
      @JsonKey(name: 'book_amount') required this.bookAmount,
      @JsonKey(name: 'actual_amount') required this.actualAmount,
      @JsonKey(name: 'difference') required this.difference,
      @JsonKey(name: 'book_formatted') required this.bookFormatted,
      @JsonKey(name: 'actual_formatted') required this.actualFormatted,
      @JsonKey(name: 'difference_formatted') required this.differenceFormatted,
      @JsonKey(name: 'issue_type') required this.issueType,
      @JsonKey(name: 'severity') this.severity = 'medium',
      @JsonKey(name: 'last_entry') this.lastEntry});

  factory _$CashLocationIssueImpl.fromJson(Map<String, dynamic> json) =>
      _$$CashLocationIssueImplFromJson(json);

  @override
  @JsonKey(name: 'location_id')
  final String locationId;
  @override
  @JsonKey(name: 'location_name')
  final String locationName;
  @override
  @JsonKey(name: 'location_type')
  final String locationType;
// cash, bank, vault
  @override
  @JsonKey(name: 'store_id')
  final String storeId;
  @override
  @JsonKey(name: 'store_name')
  final String storeName;
// Amounts
  @override
  @JsonKey(name: 'book_amount')
  final double bookAmount;
  @override
  @JsonKey(name: 'actual_amount')
  final double actualAmount;
  @override
  @JsonKey(name: 'difference')
  final double difference;
// Formatted
  @override
  @JsonKey(name: 'book_formatted')
  final String bookFormatted;
  @override
  @JsonKey(name: 'actual_formatted')
  final String actualFormatted;
  @override
  @JsonKey(name: 'difference_formatted')
  final String differenceFormatted;
// Issue info
  @override
  @JsonKey(name: 'issue_type')
  final String issueType;
// shortage, surplus
  @override
  @JsonKey(name: 'severity')
  final String severity;
// low, medium, high
// Last entry (for investigation)
  @override
  @JsonKey(name: 'last_entry')
  final LastEntryInfo? lastEntry;

  @override
  String toString() {
    return 'CashLocationIssue(locationId: $locationId, locationName: $locationName, locationType: $locationType, storeId: $storeId, storeName: $storeName, bookAmount: $bookAmount, actualAmount: $actualAmount, difference: $difference, bookFormatted: $bookFormatted, actualFormatted: $actualFormatted, differenceFormatted: $differenceFormatted, issueType: $issueType, severity: $severity, lastEntry: $lastEntry)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CashLocationIssueImpl &&
            (identical(other.locationId, locationId) ||
                other.locationId == locationId) &&
            (identical(other.locationName, locationName) ||
                other.locationName == locationName) &&
            (identical(other.locationType, locationType) ||
                other.locationType == locationType) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.storeName, storeName) ||
                other.storeName == storeName) &&
            (identical(other.bookAmount, bookAmount) ||
                other.bookAmount == bookAmount) &&
            (identical(other.actualAmount, actualAmount) ||
                other.actualAmount == actualAmount) &&
            (identical(other.difference, difference) ||
                other.difference == difference) &&
            (identical(other.bookFormatted, bookFormatted) ||
                other.bookFormatted == bookFormatted) &&
            (identical(other.actualFormatted, actualFormatted) ||
                other.actualFormatted == actualFormatted) &&
            (identical(other.differenceFormatted, differenceFormatted) ||
                other.differenceFormatted == differenceFormatted) &&
            (identical(other.issueType, issueType) ||
                other.issueType == issueType) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            (identical(other.lastEntry, lastEntry) ||
                other.lastEntry == lastEntry));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      locationId,
      locationName,
      locationType,
      storeId,
      storeName,
      bookAmount,
      actualAmount,
      difference,
      bookFormatted,
      actualFormatted,
      differenceFormatted,
      issueType,
      severity,
      lastEntry);

  /// Create a copy of CashLocationIssue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CashLocationIssueImplCopyWith<_$CashLocationIssueImpl> get copyWith =>
      __$$CashLocationIssueImplCopyWithImpl<_$CashLocationIssueImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CashLocationIssueImplToJson(
      this,
    );
  }
}

abstract class _CashLocationIssue implements CashLocationIssue {
  const factory _CashLocationIssue(
      {@JsonKey(name: 'location_id') required final String locationId,
      @JsonKey(name: 'location_name') required final String locationName,
      @JsonKey(name: 'location_type') required final String locationType,
      @JsonKey(name: 'store_id') required final String storeId,
      @JsonKey(name: 'store_name') required final String storeName,
      @JsonKey(name: 'book_amount') required final double bookAmount,
      @JsonKey(name: 'actual_amount') required final double actualAmount,
      @JsonKey(name: 'difference') required final double difference,
      @JsonKey(name: 'book_formatted') required final String bookFormatted,
      @JsonKey(name: 'actual_formatted') required final String actualFormatted,
      @JsonKey(name: 'difference_formatted')
      required final String differenceFormatted,
      @JsonKey(name: 'issue_type') required final String issueType,
      @JsonKey(name: 'severity') final String severity,
      @JsonKey(name: 'last_entry')
      final LastEntryInfo? lastEntry}) = _$CashLocationIssueImpl;

  factory _CashLocationIssue.fromJson(Map<String, dynamic> json) =
      _$CashLocationIssueImpl.fromJson;

  @override
  @JsonKey(name: 'location_id')
  String get locationId;
  @override
  @JsonKey(name: 'location_name')
  String get locationName;
  @override
  @JsonKey(name: 'location_type')
  String get locationType; // cash, bank, vault
  @override
  @JsonKey(name: 'store_id')
  String get storeId;
  @override
  @JsonKey(name: 'store_name')
  String get storeName; // Amounts
  @override
  @JsonKey(name: 'book_amount')
  double get bookAmount;
  @override
  @JsonKey(name: 'actual_amount')
  double get actualAmount;
  @override
  @JsonKey(name: 'difference')
  double get difference; // Formatted
  @override
  @JsonKey(name: 'book_formatted')
  String get bookFormatted;
  @override
  @JsonKey(name: 'actual_formatted')
  String get actualFormatted;
  @override
  @JsonKey(name: 'difference_formatted')
  String get differenceFormatted; // Issue info
  @override
  @JsonKey(name: 'issue_type')
  String get issueType; // shortage, surplus
  @override
  @JsonKey(name: 'severity')
  String get severity; // low, medium, high
// Last entry (for investigation)
  @override
  @JsonKey(name: 'last_entry')
  LastEntryInfo? get lastEntry;

  /// Create a copy of CashLocationIssue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CashLocationIssueImplCopyWith<_$CashLocationIssueImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LastEntryInfo _$LastEntryInfoFromJson(Map<String, dynamic> json) {
  return _LastEntryInfo.fromJson(json);
}

/// @nodoc
mixin _$LastEntryInfo {
  @JsonKey(name: 'entry_id')
  String get entryId => throw _privateConstructorUsedError;
  @JsonKey(name: 'employee_id')
  String get employeeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'employee_name')
  String get employeeName => throw _privateConstructorUsedError;
  @JsonKey(name: 'entry_date')
  String get entryDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'entry_time')
  String get entryTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'amount')
  double get amount => throw _privateConstructorUsedError;
  @JsonKey(name: 'formatted_amount')
  String get formattedAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'description')
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'entry_type')
  String? get entryType => throw _privateConstructorUsedError;

  /// Serializes this LastEntryInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LastEntryInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LastEntryInfoCopyWith<LastEntryInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LastEntryInfoCopyWith<$Res> {
  factory $LastEntryInfoCopyWith(
          LastEntryInfo value, $Res Function(LastEntryInfo) then) =
      _$LastEntryInfoCopyWithImpl<$Res, LastEntryInfo>;
  @useResult
  $Res call(
      {@JsonKey(name: 'entry_id') String entryId,
      @JsonKey(name: 'employee_id') String employeeId,
      @JsonKey(name: 'employee_name') String employeeName,
      @JsonKey(name: 'entry_date') String entryDate,
      @JsonKey(name: 'entry_time') String entryTime,
      @JsonKey(name: 'amount') double amount,
      @JsonKey(name: 'formatted_amount') String formattedAmount,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'entry_type') String? entryType});
}

/// @nodoc
class _$LastEntryInfoCopyWithImpl<$Res, $Val extends LastEntryInfo>
    implements $LastEntryInfoCopyWith<$Res> {
  _$LastEntryInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LastEntryInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? entryId = null,
    Object? employeeId = null,
    Object? employeeName = null,
    Object? entryDate = null,
    Object? entryTime = null,
    Object? amount = null,
    Object? formattedAmount = null,
    Object? description = freezed,
    Object? entryType = freezed,
  }) {
    return _then(_value.copyWith(
      entryId: null == entryId
          ? _value.entryId
          : entryId // ignore: cast_nullable_to_non_nullable
              as String,
      employeeId: null == employeeId
          ? _value.employeeId
          : employeeId // ignore: cast_nullable_to_non_nullable
              as String,
      employeeName: null == employeeName
          ? _value.employeeName
          : employeeName // ignore: cast_nullable_to_non_nullable
              as String,
      entryDate: null == entryDate
          ? _value.entryDate
          : entryDate // ignore: cast_nullable_to_non_nullable
              as String,
      entryTime: null == entryTime
          ? _value.entryTime
          : entryTime // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      formattedAmount: null == formattedAmount
          ? _value.formattedAmount
          : formattedAmount // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      entryType: freezed == entryType
          ? _value.entryType
          : entryType // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LastEntryInfoImplCopyWith<$Res>
    implements $LastEntryInfoCopyWith<$Res> {
  factory _$$LastEntryInfoImplCopyWith(
          _$LastEntryInfoImpl value, $Res Function(_$LastEntryInfoImpl) then) =
      __$$LastEntryInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'entry_id') String entryId,
      @JsonKey(name: 'employee_id') String employeeId,
      @JsonKey(name: 'employee_name') String employeeName,
      @JsonKey(name: 'entry_date') String entryDate,
      @JsonKey(name: 'entry_time') String entryTime,
      @JsonKey(name: 'amount') double amount,
      @JsonKey(name: 'formatted_amount') String formattedAmount,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'entry_type') String? entryType});
}

/// @nodoc
class __$$LastEntryInfoImplCopyWithImpl<$Res>
    extends _$LastEntryInfoCopyWithImpl<$Res, _$LastEntryInfoImpl>
    implements _$$LastEntryInfoImplCopyWith<$Res> {
  __$$LastEntryInfoImplCopyWithImpl(
      _$LastEntryInfoImpl _value, $Res Function(_$LastEntryInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of LastEntryInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? entryId = null,
    Object? employeeId = null,
    Object? employeeName = null,
    Object? entryDate = null,
    Object? entryTime = null,
    Object? amount = null,
    Object? formattedAmount = null,
    Object? description = freezed,
    Object? entryType = freezed,
  }) {
    return _then(_$LastEntryInfoImpl(
      entryId: null == entryId
          ? _value.entryId
          : entryId // ignore: cast_nullable_to_non_nullable
              as String,
      employeeId: null == employeeId
          ? _value.employeeId
          : employeeId // ignore: cast_nullable_to_non_nullable
              as String,
      employeeName: null == employeeName
          ? _value.employeeName
          : employeeName // ignore: cast_nullable_to_non_nullable
              as String,
      entryDate: null == entryDate
          ? _value.entryDate
          : entryDate // ignore: cast_nullable_to_non_nullable
              as String,
      entryTime: null == entryTime
          ? _value.entryTime
          : entryTime // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      formattedAmount: null == formattedAmount
          ? _value.formattedAmount
          : formattedAmount // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      entryType: freezed == entryType
          ? _value.entryType
          : entryType // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LastEntryInfoImpl implements _LastEntryInfo {
  const _$LastEntryInfoImpl(
      {@JsonKey(name: 'entry_id') required this.entryId,
      @JsonKey(name: 'employee_id') required this.employeeId,
      @JsonKey(name: 'employee_name') required this.employeeName,
      @JsonKey(name: 'entry_date') required this.entryDate,
      @JsonKey(name: 'entry_time') required this.entryTime,
      @JsonKey(name: 'amount') required this.amount,
      @JsonKey(name: 'formatted_amount') required this.formattedAmount,
      @JsonKey(name: 'description') this.description,
      @JsonKey(name: 'entry_type') this.entryType});

  factory _$LastEntryInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$LastEntryInfoImplFromJson(json);

  @override
  @JsonKey(name: 'entry_id')
  final String entryId;
  @override
  @JsonKey(name: 'employee_id')
  final String employeeId;
  @override
  @JsonKey(name: 'employee_name')
  final String employeeName;
  @override
  @JsonKey(name: 'entry_date')
  final String entryDate;
  @override
  @JsonKey(name: 'entry_time')
  final String entryTime;
  @override
  @JsonKey(name: 'amount')
  final double amount;
  @override
  @JsonKey(name: 'formatted_amount')
  final String formattedAmount;
  @override
  @JsonKey(name: 'description')
  final String? description;
  @override
  @JsonKey(name: 'entry_type')
  final String? entryType;

  @override
  String toString() {
    return 'LastEntryInfo(entryId: $entryId, employeeId: $employeeId, employeeName: $employeeName, entryDate: $entryDate, entryTime: $entryTime, amount: $amount, formattedAmount: $formattedAmount, description: $description, entryType: $entryType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LastEntryInfoImpl &&
            (identical(other.entryId, entryId) || other.entryId == entryId) &&
            (identical(other.employeeId, employeeId) ||
                other.employeeId == employeeId) &&
            (identical(other.employeeName, employeeName) ||
                other.employeeName == employeeName) &&
            (identical(other.entryDate, entryDate) ||
                other.entryDate == entryDate) &&
            (identical(other.entryTime, entryTime) ||
                other.entryTime == entryTime) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.formattedAmount, formattedAmount) ||
                other.formattedAmount == formattedAmount) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.entryType, entryType) ||
                other.entryType == entryType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      entryId,
      employeeId,
      employeeName,
      entryDate,
      entryTime,
      amount,
      formattedAmount,
      description,
      entryType);

  /// Create a copy of LastEntryInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LastEntryInfoImplCopyWith<_$LastEntryInfoImpl> get copyWith =>
      __$$LastEntryInfoImplCopyWithImpl<_$LastEntryInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LastEntryInfoImplToJson(
      this,
    );
  }
}

abstract class _LastEntryInfo implements LastEntryInfo {
  const factory _LastEntryInfo(
      {@JsonKey(name: 'entry_id') required final String entryId,
      @JsonKey(name: 'employee_id') required final String employeeId,
      @JsonKey(name: 'employee_name') required final String employeeName,
      @JsonKey(name: 'entry_date') required final String entryDate,
      @JsonKey(name: 'entry_time') required final String entryTime,
      @JsonKey(name: 'amount') required final double amount,
      @JsonKey(name: 'formatted_amount') required final String formattedAmount,
      @JsonKey(name: 'description') final String? description,
      @JsonKey(name: 'entry_type')
      final String? entryType}) = _$LastEntryInfoImpl;

  factory _LastEntryInfo.fromJson(Map<String, dynamic> json) =
      _$LastEntryInfoImpl.fromJson;

  @override
  @JsonKey(name: 'entry_id')
  String get entryId;
  @override
  @JsonKey(name: 'employee_id')
  String get employeeId;
  @override
  @JsonKey(name: 'employee_name')
  String get employeeName;
  @override
  @JsonKey(name: 'entry_date')
  String get entryDate;
  @override
  @JsonKey(name: 'entry_time')
  String get entryTime;
  @override
  @JsonKey(name: 'amount')
  double get amount;
  @override
  @JsonKey(name: 'formatted_amount')
  String get formattedAmount;
  @override
  @JsonKey(name: 'description')
  String? get description;
  @override
  @JsonKey(name: 'entry_type')
  String? get entryType;

  /// Create a copy of LastEntryInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LastEntryInfoImplCopyWith<_$LastEntryInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CashLocationInsights _$CashLocationInsightsFromJson(Map<String, dynamic> json) {
  return _CashLocationInsights.fromJson(json);
}

/// @nodoc
mixin _$CashLocationInsights {
  String get summary => throw _privateConstructorUsedError;
  List<String> get recommendations => throw _privateConstructorUsedError;

  /// Serializes this CashLocationInsights to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CashLocationInsights
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CashLocationInsightsCopyWith<CashLocationInsights> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CashLocationInsightsCopyWith<$Res> {
  factory $CashLocationInsightsCopyWith(CashLocationInsights value,
          $Res Function(CashLocationInsights) then) =
      _$CashLocationInsightsCopyWithImpl<$Res, CashLocationInsights>;
  @useResult
  $Res call({String summary, List<String> recommendations});
}

/// @nodoc
class _$CashLocationInsightsCopyWithImpl<$Res,
        $Val extends CashLocationInsights>
    implements $CashLocationInsightsCopyWith<$Res> {
  _$CashLocationInsightsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CashLocationInsights
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? summary = null,
    Object? recommendations = null,
  }) {
    return _then(_value.copyWith(
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String,
      recommendations: null == recommendations
          ? _value.recommendations
          : recommendations // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CashLocationInsightsImplCopyWith<$Res>
    implements $CashLocationInsightsCopyWith<$Res> {
  factory _$$CashLocationInsightsImplCopyWith(_$CashLocationInsightsImpl value,
          $Res Function(_$CashLocationInsightsImpl) then) =
      __$$CashLocationInsightsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String summary, List<String> recommendations});
}

/// @nodoc
class __$$CashLocationInsightsImplCopyWithImpl<$Res>
    extends _$CashLocationInsightsCopyWithImpl<$Res, _$CashLocationInsightsImpl>
    implements _$$CashLocationInsightsImplCopyWith<$Res> {
  __$$CashLocationInsightsImplCopyWithImpl(_$CashLocationInsightsImpl _value,
      $Res Function(_$CashLocationInsightsImpl) _then)
      : super(_value, _then);

  /// Create a copy of CashLocationInsights
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? summary = null,
    Object? recommendations = null,
  }) {
    return _then(_$CashLocationInsightsImpl(
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String,
      recommendations: null == recommendations
          ? _value._recommendations
          : recommendations // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CashLocationInsightsImpl implements _CashLocationInsights {
  const _$CashLocationInsightsImpl(
      {required this.summary, required final List<String> recommendations})
      : _recommendations = recommendations;

  factory _$CashLocationInsightsImpl.fromJson(Map<String, dynamic> json) =>
      _$$CashLocationInsightsImplFromJson(json);

  @override
  final String summary;
  final List<String> _recommendations;
  @override
  List<String> get recommendations {
    if (_recommendations is EqualUnmodifiableListView) return _recommendations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recommendations);
  }

  @override
  String toString() {
    return 'CashLocationInsights(summary: $summary, recommendations: $recommendations)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CashLocationInsightsImpl &&
            (identical(other.summary, summary) || other.summary == summary) &&
            const DeepCollectionEquality()
                .equals(other._recommendations, _recommendations));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, summary,
      const DeepCollectionEquality().hash(_recommendations));

  /// Create a copy of CashLocationInsights
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CashLocationInsightsImplCopyWith<_$CashLocationInsightsImpl>
      get copyWith =>
          __$$CashLocationInsightsImplCopyWithImpl<_$CashLocationInsightsImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CashLocationInsightsImplToJson(
      this,
    );
  }
}

abstract class _CashLocationInsights implements CashLocationInsights {
  const factory _CashLocationInsights(
          {required final String summary,
          required final List<String> recommendations}) =
      _$CashLocationInsightsImpl;

  factory _CashLocationInsights.fromJson(Map<String, dynamic> json) =
      _$CashLocationInsightsImpl.fromJson;

  @override
  String get summary;
  @override
  List<String> get recommendations;

  /// Create a copy of CashLocationInsights
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CashLocationInsightsImplCopyWith<_$CashLocationInsightsImpl>
      get copyWith => throw _privateConstructorUsedError;
}
