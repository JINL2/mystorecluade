// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ReportDetail _$ReportDetailFromJson(Map<String, dynamic> json) {
  return _ReportDetail.fromJson(json);
}

/// @nodoc
mixin _$ReportDetail {
  @JsonKey(name: 'template_id')
  String get templateId => throw _privateConstructorUsedError;
  @JsonKey(name: 'template_code')
  String get templateCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'report_date')
  String get reportDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'session_id')
  String? get sessionId =>
      throw _privateConstructorUsedError; // Core metrics for hero display
  @JsonKey(name: 'key_metrics')
  KeyMetrics get keyMetrics =>
      throw _privateConstructorUsedError; // Performance cards
  @JsonKey(name: 'performance_cards')
  List<PerformanceCard> get performanceCards =>
      throw _privateConstructorUsedError; // Balance Sheet summary
  @JsonKey(name: 'balance_sheet')
  BalanceSheetSummary get balanceSheet =>
      throw _privateConstructorUsedError; // Account changes data
  @JsonKey(name: 'account_changes')
  AccountChanges get accountChanges =>
      throw _privateConstructorUsedError; // Red flags
  @JsonKey(name: 'red_flags')
  RedFlags get redFlags =>
      throw _privateConstructorUsedError; // AI-generated insights
  @JsonKey(name: 'ai_insights')
  AiInsights get aiInsights =>
      throw _privateConstructorUsedError; // Fallback markdown
  @JsonKey(name: 'markdown_body')
  String? get markdownBody => throw _privateConstructorUsedError;

  /// Serializes this ReportDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReportDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReportDetailCopyWith<ReportDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReportDetailCopyWith<$Res> {
  factory $ReportDetailCopyWith(
          ReportDetail value, $Res Function(ReportDetail) then) =
      _$ReportDetailCopyWithImpl<$Res, ReportDetail>;
  @useResult
  $Res call(
      {@JsonKey(name: 'template_id') String templateId,
      @JsonKey(name: 'template_code') String templateCode,
      @JsonKey(name: 'report_date') String reportDate,
      @JsonKey(name: 'session_id') String? sessionId,
      @JsonKey(name: 'key_metrics') KeyMetrics keyMetrics,
      @JsonKey(name: 'performance_cards')
      List<PerformanceCard> performanceCards,
      @JsonKey(name: 'balance_sheet') BalanceSheetSummary balanceSheet,
      @JsonKey(name: 'account_changes') AccountChanges accountChanges,
      @JsonKey(name: 'red_flags') RedFlags redFlags,
      @JsonKey(name: 'ai_insights') AiInsights aiInsights,
      @JsonKey(name: 'markdown_body') String? markdownBody});

  $KeyMetricsCopyWith<$Res> get keyMetrics;
  $BalanceSheetSummaryCopyWith<$Res> get balanceSheet;
  $AccountChangesCopyWith<$Res> get accountChanges;
  $RedFlagsCopyWith<$Res> get redFlags;
  $AiInsightsCopyWith<$Res> get aiInsights;
}

/// @nodoc
class _$ReportDetailCopyWithImpl<$Res, $Val extends ReportDetail>
    implements $ReportDetailCopyWith<$Res> {
  _$ReportDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReportDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? templateId = null,
    Object? templateCode = null,
    Object? reportDate = null,
    Object? sessionId = freezed,
    Object? keyMetrics = null,
    Object? performanceCards = null,
    Object? balanceSheet = null,
    Object? accountChanges = null,
    Object? redFlags = null,
    Object? aiInsights = null,
    Object? markdownBody = freezed,
  }) {
    return _then(_value.copyWith(
      templateId: null == templateId
          ? _value.templateId
          : templateId // ignore: cast_nullable_to_non_nullable
              as String,
      templateCode: null == templateCode
          ? _value.templateCode
          : templateCode // ignore: cast_nullable_to_non_nullable
              as String,
      reportDate: null == reportDate
          ? _value.reportDate
          : reportDate // ignore: cast_nullable_to_non_nullable
              as String,
      sessionId: freezed == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String?,
      keyMetrics: null == keyMetrics
          ? _value.keyMetrics
          : keyMetrics // ignore: cast_nullable_to_non_nullable
              as KeyMetrics,
      performanceCards: null == performanceCards
          ? _value.performanceCards
          : performanceCards // ignore: cast_nullable_to_non_nullable
              as List<PerformanceCard>,
      balanceSheet: null == balanceSheet
          ? _value.balanceSheet
          : balanceSheet // ignore: cast_nullable_to_non_nullable
              as BalanceSheetSummary,
      accountChanges: null == accountChanges
          ? _value.accountChanges
          : accountChanges // ignore: cast_nullable_to_non_nullable
              as AccountChanges,
      redFlags: null == redFlags
          ? _value.redFlags
          : redFlags // ignore: cast_nullable_to_non_nullable
              as RedFlags,
      aiInsights: null == aiInsights
          ? _value.aiInsights
          : aiInsights // ignore: cast_nullable_to_non_nullable
              as AiInsights,
      markdownBody: freezed == markdownBody
          ? _value.markdownBody
          : markdownBody // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of ReportDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $KeyMetricsCopyWith<$Res> get keyMetrics {
    return $KeyMetricsCopyWith<$Res>(_value.keyMetrics, (value) {
      return _then(_value.copyWith(keyMetrics: value) as $Val);
    });
  }

  /// Create a copy of ReportDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BalanceSheetSummaryCopyWith<$Res> get balanceSheet {
    return $BalanceSheetSummaryCopyWith<$Res>(_value.balanceSheet, (value) {
      return _then(_value.copyWith(balanceSheet: value) as $Val);
    });
  }

  /// Create a copy of ReportDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AccountChangesCopyWith<$Res> get accountChanges {
    return $AccountChangesCopyWith<$Res>(_value.accountChanges, (value) {
      return _then(_value.copyWith(accountChanges: value) as $Val);
    });
  }

  /// Create a copy of ReportDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RedFlagsCopyWith<$Res> get redFlags {
    return $RedFlagsCopyWith<$Res>(_value.redFlags, (value) {
      return _then(_value.copyWith(redFlags: value) as $Val);
    });
  }

  /// Create a copy of ReportDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AiInsightsCopyWith<$Res> get aiInsights {
    return $AiInsightsCopyWith<$Res>(_value.aiInsights, (value) {
      return _then(_value.copyWith(aiInsights: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ReportDetailImplCopyWith<$Res>
    implements $ReportDetailCopyWith<$Res> {
  factory _$$ReportDetailImplCopyWith(
          _$ReportDetailImpl value, $Res Function(_$ReportDetailImpl) then) =
      __$$ReportDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'template_id') String templateId,
      @JsonKey(name: 'template_code') String templateCode,
      @JsonKey(name: 'report_date') String reportDate,
      @JsonKey(name: 'session_id') String? sessionId,
      @JsonKey(name: 'key_metrics') KeyMetrics keyMetrics,
      @JsonKey(name: 'performance_cards')
      List<PerformanceCard> performanceCards,
      @JsonKey(name: 'balance_sheet') BalanceSheetSummary balanceSheet,
      @JsonKey(name: 'account_changes') AccountChanges accountChanges,
      @JsonKey(name: 'red_flags') RedFlags redFlags,
      @JsonKey(name: 'ai_insights') AiInsights aiInsights,
      @JsonKey(name: 'markdown_body') String? markdownBody});

  @override
  $KeyMetricsCopyWith<$Res> get keyMetrics;
  @override
  $BalanceSheetSummaryCopyWith<$Res> get balanceSheet;
  @override
  $AccountChangesCopyWith<$Res> get accountChanges;
  @override
  $RedFlagsCopyWith<$Res> get redFlags;
  @override
  $AiInsightsCopyWith<$Res> get aiInsights;
}

/// @nodoc
class __$$ReportDetailImplCopyWithImpl<$Res>
    extends _$ReportDetailCopyWithImpl<$Res, _$ReportDetailImpl>
    implements _$$ReportDetailImplCopyWith<$Res> {
  __$$ReportDetailImplCopyWithImpl(
      _$ReportDetailImpl _value, $Res Function(_$ReportDetailImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReportDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? templateId = null,
    Object? templateCode = null,
    Object? reportDate = null,
    Object? sessionId = freezed,
    Object? keyMetrics = null,
    Object? performanceCards = null,
    Object? balanceSheet = null,
    Object? accountChanges = null,
    Object? redFlags = null,
    Object? aiInsights = null,
    Object? markdownBody = freezed,
  }) {
    return _then(_$ReportDetailImpl(
      templateId: null == templateId
          ? _value.templateId
          : templateId // ignore: cast_nullable_to_non_nullable
              as String,
      templateCode: null == templateCode
          ? _value.templateCode
          : templateCode // ignore: cast_nullable_to_non_nullable
              as String,
      reportDate: null == reportDate
          ? _value.reportDate
          : reportDate // ignore: cast_nullable_to_non_nullable
              as String,
      sessionId: freezed == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String?,
      keyMetrics: null == keyMetrics
          ? _value.keyMetrics
          : keyMetrics // ignore: cast_nullable_to_non_nullable
              as KeyMetrics,
      performanceCards: null == performanceCards
          ? _value._performanceCards
          : performanceCards // ignore: cast_nullable_to_non_nullable
              as List<PerformanceCard>,
      balanceSheet: null == balanceSheet
          ? _value.balanceSheet
          : balanceSheet // ignore: cast_nullable_to_non_nullable
              as BalanceSheetSummary,
      accountChanges: null == accountChanges
          ? _value.accountChanges
          : accountChanges // ignore: cast_nullable_to_non_nullable
              as AccountChanges,
      redFlags: null == redFlags
          ? _value.redFlags
          : redFlags // ignore: cast_nullable_to_non_nullable
              as RedFlags,
      aiInsights: null == aiInsights
          ? _value.aiInsights
          : aiInsights // ignore: cast_nullable_to_non_nullable
              as AiInsights,
      markdownBody: freezed == markdownBody
          ? _value.markdownBody
          : markdownBody // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReportDetailImpl implements _ReportDetail {
  const _$ReportDetailImpl(
      {@JsonKey(name: 'template_id') required this.templateId,
      @JsonKey(name: 'template_code') required this.templateCode,
      @JsonKey(name: 'report_date') required this.reportDate,
      @JsonKey(name: 'session_id') this.sessionId,
      @JsonKey(name: 'key_metrics') required this.keyMetrics,
      @JsonKey(name: 'performance_cards')
      required final List<PerformanceCard> performanceCards,
      @JsonKey(name: 'balance_sheet') required this.balanceSheet,
      @JsonKey(name: 'account_changes') required this.accountChanges,
      @JsonKey(name: 'red_flags') required this.redFlags,
      @JsonKey(name: 'ai_insights') required this.aiInsights,
      @JsonKey(name: 'markdown_body') this.markdownBody})
      : _performanceCards = performanceCards;

  factory _$ReportDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReportDetailImplFromJson(json);

  @override
  @JsonKey(name: 'template_id')
  final String templateId;
  @override
  @JsonKey(name: 'template_code')
  final String templateCode;
  @override
  @JsonKey(name: 'report_date')
  final String reportDate;
  @override
  @JsonKey(name: 'session_id')
  final String? sessionId;
// Core metrics for hero display
  @override
  @JsonKey(name: 'key_metrics')
  final KeyMetrics keyMetrics;
// Performance cards
  final List<PerformanceCard> _performanceCards;
// Performance cards
  @override
  @JsonKey(name: 'performance_cards')
  List<PerformanceCard> get performanceCards {
    if (_performanceCards is EqualUnmodifiableListView)
      return _performanceCards;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_performanceCards);
  }

// Balance Sheet summary
  @override
  @JsonKey(name: 'balance_sheet')
  final BalanceSheetSummary balanceSheet;
// Account changes data
  @override
  @JsonKey(name: 'account_changes')
  final AccountChanges accountChanges;
// Red flags
  @override
  @JsonKey(name: 'red_flags')
  final RedFlags redFlags;
// AI-generated insights
  @override
  @JsonKey(name: 'ai_insights')
  final AiInsights aiInsights;
// Fallback markdown
  @override
  @JsonKey(name: 'markdown_body')
  final String? markdownBody;

  @override
  String toString() {
    return 'ReportDetail(templateId: $templateId, templateCode: $templateCode, reportDate: $reportDate, sessionId: $sessionId, keyMetrics: $keyMetrics, performanceCards: $performanceCards, balanceSheet: $balanceSheet, accountChanges: $accountChanges, redFlags: $redFlags, aiInsights: $aiInsights, markdownBody: $markdownBody)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReportDetailImpl &&
            (identical(other.templateId, templateId) ||
                other.templateId == templateId) &&
            (identical(other.templateCode, templateCode) ||
                other.templateCode == templateCode) &&
            (identical(other.reportDate, reportDate) ||
                other.reportDate == reportDate) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.keyMetrics, keyMetrics) ||
                other.keyMetrics == keyMetrics) &&
            const DeepCollectionEquality()
                .equals(other._performanceCards, _performanceCards) &&
            (identical(other.balanceSheet, balanceSheet) ||
                other.balanceSheet == balanceSheet) &&
            (identical(other.accountChanges, accountChanges) ||
                other.accountChanges == accountChanges) &&
            (identical(other.redFlags, redFlags) ||
                other.redFlags == redFlags) &&
            (identical(other.aiInsights, aiInsights) ||
                other.aiInsights == aiInsights) &&
            (identical(other.markdownBody, markdownBody) ||
                other.markdownBody == markdownBody));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      templateId,
      templateCode,
      reportDate,
      sessionId,
      keyMetrics,
      const DeepCollectionEquality().hash(_performanceCards),
      balanceSheet,
      accountChanges,
      redFlags,
      aiInsights,
      markdownBody);

  /// Create a copy of ReportDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReportDetailImplCopyWith<_$ReportDetailImpl> get copyWith =>
      __$$ReportDetailImplCopyWithImpl<_$ReportDetailImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReportDetailImplToJson(
      this,
    );
  }
}

abstract class _ReportDetail implements ReportDetail {
  const factory _ReportDetail(
          {@JsonKey(name: 'template_id') required final String templateId,
          @JsonKey(name: 'template_code') required final String templateCode,
          @JsonKey(name: 'report_date') required final String reportDate,
          @JsonKey(name: 'session_id') final String? sessionId,
          @JsonKey(name: 'key_metrics') required final KeyMetrics keyMetrics,
          @JsonKey(name: 'performance_cards')
          required final List<PerformanceCard> performanceCards,
          @JsonKey(name: 'balance_sheet')
          required final BalanceSheetSummary balanceSheet,
          @JsonKey(name: 'account_changes')
          required final AccountChanges accountChanges,
          @JsonKey(name: 'red_flags') required final RedFlags redFlags,
          @JsonKey(name: 'ai_insights') required final AiInsights aiInsights,
          @JsonKey(name: 'markdown_body') final String? markdownBody}) =
      _$ReportDetailImpl;

  factory _ReportDetail.fromJson(Map<String, dynamic> json) =
      _$ReportDetailImpl.fromJson;

  @override
  @JsonKey(name: 'template_id')
  String get templateId;
  @override
  @JsonKey(name: 'template_code')
  String get templateCode;
  @override
  @JsonKey(name: 'report_date')
  String get reportDate;
  @override
  @JsonKey(name: 'session_id')
  String? get sessionId; // Core metrics for hero display
  @override
  @JsonKey(name: 'key_metrics')
  KeyMetrics get keyMetrics; // Performance cards
  @override
  @JsonKey(name: 'performance_cards')
  List<PerformanceCard> get performanceCards; // Balance Sheet summary
  @override
  @JsonKey(name: 'balance_sheet')
  BalanceSheetSummary get balanceSheet; // Account changes data
  @override
  @JsonKey(name: 'account_changes')
  AccountChanges get accountChanges; // Red flags
  @override
  @JsonKey(name: 'red_flags')
  RedFlags get redFlags; // AI-generated insights
  @override
  @JsonKey(name: 'ai_insights')
  AiInsights get aiInsights; // Fallback markdown
  @override
  @JsonKey(name: 'markdown_body')
  String? get markdownBody;

  /// Create a copy of ReportDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReportDetailImplCopyWith<_$ReportDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

KeyMetrics _$KeyMetricsFromJson(Map<String, dynamic> json) {
  return _KeyMetrics.fromJson(json);
}

/// @nodoc
mixin _$KeyMetrics {
  @JsonKey(name: 'total_revenue')
  double get totalRevenue => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_revenue_formatted')
  String get totalRevenueFormatted => throw _privateConstructorUsedError;
  @JsonKey(name: 'revenue_change_percent')
  double? get revenueChangePercent => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_positive_change')
  bool? get isPositiveChange => throw _privateConstructorUsedError;

  /// Serializes this KeyMetrics to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of KeyMetrics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $KeyMetricsCopyWith<KeyMetrics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KeyMetricsCopyWith<$Res> {
  factory $KeyMetricsCopyWith(
          KeyMetrics value, $Res Function(KeyMetrics) then) =
      _$KeyMetricsCopyWithImpl<$Res, KeyMetrics>;
  @useResult
  $Res call(
      {@JsonKey(name: 'total_revenue') double totalRevenue,
      @JsonKey(name: 'total_revenue_formatted') String totalRevenueFormatted,
      @JsonKey(name: 'revenue_change_percent') double? revenueChangePercent,
      @JsonKey(name: 'is_positive_change') bool? isPositiveChange});
}

/// @nodoc
class _$KeyMetricsCopyWithImpl<$Res, $Val extends KeyMetrics>
    implements $KeyMetricsCopyWith<$Res> {
  _$KeyMetricsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of KeyMetrics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalRevenue = null,
    Object? totalRevenueFormatted = null,
    Object? revenueChangePercent = freezed,
    Object? isPositiveChange = freezed,
  }) {
    return _then(_value.copyWith(
      totalRevenue: null == totalRevenue
          ? _value.totalRevenue
          : totalRevenue // ignore: cast_nullable_to_non_nullable
              as double,
      totalRevenueFormatted: null == totalRevenueFormatted
          ? _value.totalRevenueFormatted
          : totalRevenueFormatted // ignore: cast_nullable_to_non_nullable
              as String,
      revenueChangePercent: freezed == revenueChangePercent
          ? _value.revenueChangePercent
          : revenueChangePercent // ignore: cast_nullable_to_non_nullable
              as double?,
      isPositiveChange: freezed == isPositiveChange
          ? _value.isPositiveChange
          : isPositiveChange // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$KeyMetricsImplCopyWith<$Res>
    implements $KeyMetricsCopyWith<$Res> {
  factory _$$KeyMetricsImplCopyWith(
          _$KeyMetricsImpl value, $Res Function(_$KeyMetricsImpl) then) =
      __$$KeyMetricsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'total_revenue') double totalRevenue,
      @JsonKey(name: 'total_revenue_formatted') String totalRevenueFormatted,
      @JsonKey(name: 'revenue_change_percent') double? revenueChangePercent,
      @JsonKey(name: 'is_positive_change') bool? isPositiveChange});
}

/// @nodoc
class __$$KeyMetricsImplCopyWithImpl<$Res>
    extends _$KeyMetricsCopyWithImpl<$Res, _$KeyMetricsImpl>
    implements _$$KeyMetricsImplCopyWith<$Res> {
  __$$KeyMetricsImplCopyWithImpl(
      _$KeyMetricsImpl _value, $Res Function(_$KeyMetricsImpl) _then)
      : super(_value, _then);

  /// Create a copy of KeyMetrics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalRevenue = null,
    Object? totalRevenueFormatted = null,
    Object? revenueChangePercent = freezed,
    Object? isPositiveChange = freezed,
  }) {
    return _then(_$KeyMetricsImpl(
      totalRevenue: null == totalRevenue
          ? _value.totalRevenue
          : totalRevenue // ignore: cast_nullable_to_non_nullable
              as double,
      totalRevenueFormatted: null == totalRevenueFormatted
          ? _value.totalRevenueFormatted
          : totalRevenueFormatted // ignore: cast_nullable_to_non_nullable
              as String,
      revenueChangePercent: freezed == revenueChangePercent
          ? _value.revenueChangePercent
          : revenueChangePercent // ignore: cast_nullable_to_non_nullable
              as double?,
      isPositiveChange: freezed == isPositiveChange
          ? _value.isPositiveChange
          : isPositiveChange // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$KeyMetricsImpl implements _KeyMetrics {
  const _$KeyMetricsImpl(
      {@JsonKey(name: 'total_revenue') required this.totalRevenue,
      @JsonKey(name: 'total_revenue_formatted')
      required this.totalRevenueFormatted,
      @JsonKey(name: 'revenue_change_percent') this.revenueChangePercent,
      @JsonKey(name: 'is_positive_change') this.isPositiveChange});

  factory _$KeyMetricsImpl.fromJson(Map<String, dynamic> json) =>
      _$$KeyMetricsImplFromJson(json);

  @override
  @JsonKey(name: 'total_revenue')
  final double totalRevenue;
  @override
  @JsonKey(name: 'total_revenue_formatted')
  final String totalRevenueFormatted;
  @override
  @JsonKey(name: 'revenue_change_percent')
  final double? revenueChangePercent;
  @override
  @JsonKey(name: 'is_positive_change')
  final bool? isPositiveChange;

  @override
  String toString() {
    return 'KeyMetrics(totalRevenue: $totalRevenue, totalRevenueFormatted: $totalRevenueFormatted, revenueChangePercent: $revenueChangePercent, isPositiveChange: $isPositiveChange)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KeyMetricsImpl &&
            (identical(other.totalRevenue, totalRevenue) ||
                other.totalRevenue == totalRevenue) &&
            (identical(other.totalRevenueFormatted, totalRevenueFormatted) ||
                other.totalRevenueFormatted == totalRevenueFormatted) &&
            (identical(other.revenueChangePercent, revenueChangePercent) ||
                other.revenueChangePercent == revenueChangePercent) &&
            (identical(other.isPositiveChange, isPositiveChange) ||
                other.isPositiveChange == isPositiveChange));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, totalRevenue,
      totalRevenueFormatted, revenueChangePercent, isPositiveChange);

  /// Create a copy of KeyMetrics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$KeyMetricsImplCopyWith<_$KeyMetricsImpl> get copyWith =>
      __$$KeyMetricsImplCopyWithImpl<_$KeyMetricsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$KeyMetricsImplToJson(
      this,
    );
  }
}

abstract class _KeyMetrics implements KeyMetrics {
  const factory _KeyMetrics(
          {@JsonKey(name: 'total_revenue') required final double totalRevenue,
          @JsonKey(name: 'total_revenue_formatted')
          required final String totalRevenueFormatted,
          @JsonKey(name: 'revenue_change_percent')
          final double? revenueChangePercent,
          @JsonKey(name: 'is_positive_change') final bool? isPositiveChange}) =
      _$KeyMetricsImpl;

  factory _KeyMetrics.fromJson(Map<String, dynamic> json) =
      _$KeyMetricsImpl.fromJson;

  @override
  @JsonKey(name: 'total_revenue')
  double get totalRevenue;
  @override
  @JsonKey(name: 'total_revenue_formatted')
  String get totalRevenueFormatted;
  @override
  @JsonKey(name: 'revenue_change_percent')
  double? get revenueChangePercent;
  @override
  @JsonKey(name: 'is_positive_change')
  bool? get isPositiveChange;

  /// Create a copy of KeyMetrics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$KeyMetricsImplCopyWith<_$KeyMetricsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PerformanceCard _$PerformanceCardFromJson(Map<String, dynamic> json) {
  return _PerformanceCard.fromJson(json);
}

/// @nodoc
mixin _$PerformanceCard {
  String get label => throw _privateConstructorUsedError;
  String get value => throw _privateConstructorUsedError;
  String get icon => throw _privateConstructorUsedError;
  String? get trend => throw _privateConstructorUsedError;
  String? get severity => throw _privateConstructorUsedError;

  /// Serializes this PerformanceCard to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PerformanceCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PerformanceCardCopyWith<PerformanceCard> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PerformanceCardCopyWith<$Res> {
  factory $PerformanceCardCopyWith(
          PerformanceCard value, $Res Function(PerformanceCard) then) =
      _$PerformanceCardCopyWithImpl<$Res, PerformanceCard>;
  @useResult
  $Res call(
      {String label,
      String value,
      String icon,
      String? trend,
      String? severity});
}

/// @nodoc
class _$PerformanceCardCopyWithImpl<$Res, $Val extends PerformanceCard>
    implements $PerformanceCardCopyWith<$Res> {
  _$PerformanceCardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PerformanceCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? value = null,
    Object? icon = null,
    Object? trend = freezed,
    Object? severity = freezed,
  }) {
    return _then(_value.copyWith(
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      trend: freezed == trend
          ? _value.trend
          : trend // ignore: cast_nullable_to_non_nullable
              as String?,
      severity: freezed == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PerformanceCardImplCopyWith<$Res>
    implements $PerformanceCardCopyWith<$Res> {
  factory _$$PerformanceCardImplCopyWith(_$PerformanceCardImpl value,
          $Res Function(_$PerformanceCardImpl) then) =
      __$$PerformanceCardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String label,
      String value,
      String icon,
      String? trend,
      String? severity});
}

/// @nodoc
class __$$PerformanceCardImplCopyWithImpl<$Res>
    extends _$PerformanceCardCopyWithImpl<$Res, _$PerformanceCardImpl>
    implements _$$PerformanceCardImplCopyWith<$Res> {
  __$$PerformanceCardImplCopyWithImpl(
      _$PerformanceCardImpl _value, $Res Function(_$PerformanceCardImpl) _then)
      : super(_value, _then);

  /// Create a copy of PerformanceCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? value = null,
    Object? icon = null,
    Object? trend = freezed,
    Object? severity = freezed,
  }) {
    return _then(_$PerformanceCardImpl(
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      trend: freezed == trend
          ? _value.trend
          : trend // ignore: cast_nullable_to_non_nullable
              as String?,
      severity: freezed == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PerformanceCardImpl implements _PerformanceCard {
  const _$PerformanceCardImpl(
      {required this.label,
      required this.value,
      required this.icon,
      this.trend,
      this.severity});

  factory _$PerformanceCardImpl.fromJson(Map<String, dynamic> json) =>
      _$$PerformanceCardImplFromJson(json);

  @override
  final String label;
  @override
  final String value;
  @override
  final String icon;
  @override
  final String? trend;
  @override
  final String? severity;

  @override
  String toString() {
    return 'PerformanceCard(label: $label, value: $value, icon: $icon, trend: $trend, severity: $severity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PerformanceCardImpl &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.trend, trend) || other.trend == trend) &&
            (identical(other.severity, severity) ||
                other.severity == severity));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, label, value, icon, trend, severity);

  /// Create a copy of PerformanceCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PerformanceCardImplCopyWith<_$PerformanceCardImpl> get copyWith =>
      __$$PerformanceCardImplCopyWithImpl<_$PerformanceCardImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PerformanceCardImplToJson(
      this,
    );
  }
}

abstract class _PerformanceCard implements PerformanceCard {
  const factory _PerformanceCard(
      {required final String label,
      required final String value,
      required final String icon,
      final String? trend,
      final String? severity}) = _$PerformanceCardImpl;

  factory _PerformanceCard.fromJson(Map<String, dynamic> json) =
      _$PerformanceCardImpl.fromJson;

  @override
  String get label;
  @override
  String get value;
  @override
  String get icon;
  @override
  String? get trend;
  @override
  String? get severity;

  /// Create a copy of PerformanceCard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PerformanceCardImplCopyWith<_$PerformanceCardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BalanceSheetSummary _$BalanceSheetSummaryFromJson(Map<String, dynamic> json) {
  return _BalanceSheetSummary.fromJson(json);
}

/// @nodoc
mixin _$BalanceSheetSummary {
  @JsonKey(name: 'total_assets')
  double get totalAssets => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_liabilities')
  double get totalLiabilities => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_equity')
  double get totalEquity => throw _privateConstructorUsedError;
  @JsonKey(name: 'assets_change')
  double get assetsChange => throw _privateConstructorUsedError;
  @JsonKey(name: 'liabilities_change')
  double get liabilitiesChange => throw _privateConstructorUsedError;
  @JsonKey(name: 'equity_change')
  double get equityChange => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_assets_formatted')
  String get totalAssetsFormatted => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_liabilities_formatted')
  String get totalLiabilitiesFormatted => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_equity_formatted')
  String get totalEquityFormatted => throw _privateConstructorUsedError;
  @JsonKey(name: 'assets_change_formatted')
  String get assetsChangeFormatted => throw _privateConstructorUsedError;
  @JsonKey(name: 'liabilities_change_formatted')
  String get liabilitiesChangeFormatted => throw _privateConstructorUsedError;
  @JsonKey(name: 'equity_change_formatted')
  String get equityChangeFormatted => throw _privateConstructorUsedError;
  @JsonKey(name: 'assets_increased')
  bool get assetsIncreased => throw _privateConstructorUsedError;
  @JsonKey(name: 'liabilities_increased')
  bool get liabilitiesIncreased => throw _privateConstructorUsedError;
  @JsonKey(name: 'equity_increased')
  bool get equityIncreased => throw _privateConstructorUsedError;

  /// Serializes this BalanceSheetSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BalanceSheetSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BalanceSheetSummaryCopyWith<BalanceSheetSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BalanceSheetSummaryCopyWith<$Res> {
  factory $BalanceSheetSummaryCopyWith(
          BalanceSheetSummary value, $Res Function(BalanceSheetSummary) then) =
      _$BalanceSheetSummaryCopyWithImpl<$Res, BalanceSheetSummary>;
  @useResult
  $Res call(
      {@JsonKey(name: 'total_assets') double totalAssets,
      @JsonKey(name: 'total_liabilities') double totalLiabilities,
      @JsonKey(name: 'total_equity') double totalEquity,
      @JsonKey(name: 'assets_change') double assetsChange,
      @JsonKey(name: 'liabilities_change') double liabilitiesChange,
      @JsonKey(name: 'equity_change') double equityChange,
      @JsonKey(name: 'total_assets_formatted') String totalAssetsFormatted,
      @JsonKey(name: 'total_liabilities_formatted')
      String totalLiabilitiesFormatted,
      @JsonKey(name: 'total_equity_formatted') String totalEquityFormatted,
      @JsonKey(name: 'assets_change_formatted') String assetsChangeFormatted,
      @JsonKey(name: 'liabilities_change_formatted')
      String liabilitiesChangeFormatted,
      @JsonKey(name: 'equity_change_formatted') String equityChangeFormatted,
      @JsonKey(name: 'assets_increased') bool assetsIncreased,
      @JsonKey(name: 'liabilities_increased') bool liabilitiesIncreased,
      @JsonKey(name: 'equity_increased') bool equityIncreased});
}

/// @nodoc
class _$BalanceSheetSummaryCopyWithImpl<$Res, $Val extends BalanceSheetSummary>
    implements $BalanceSheetSummaryCopyWith<$Res> {
  _$BalanceSheetSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BalanceSheetSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalAssets = null,
    Object? totalLiabilities = null,
    Object? totalEquity = null,
    Object? assetsChange = null,
    Object? liabilitiesChange = null,
    Object? equityChange = null,
    Object? totalAssetsFormatted = null,
    Object? totalLiabilitiesFormatted = null,
    Object? totalEquityFormatted = null,
    Object? assetsChangeFormatted = null,
    Object? liabilitiesChangeFormatted = null,
    Object? equityChangeFormatted = null,
    Object? assetsIncreased = null,
    Object? liabilitiesIncreased = null,
    Object? equityIncreased = null,
  }) {
    return _then(_value.copyWith(
      totalAssets: null == totalAssets
          ? _value.totalAssets
          : totalAssets // ignore: cast_nullable_to_non_nullable
              as double,
      totalLiabilities: null == totalLiabilities
          ? _value.totalLiabilities
          : totalLiabilities // ignore: cast_nullable_to_non_nullable
              as double,
      totalEquity: null == totalEquity
          ? _value.totalEquity
          : totalEquity // ignore: cast_nullable_to_non_nullable
              as double,
      assetsChange: null == assetsChange
          ? _value.assetsChange
          : assetsChange // ignore: cast_nullable_to_non_nullable
              as double,
      liabilitiesChange: null == liabilitiesChange
          ? _value.liabilitiesChange
          : liabilitiesChange // ignore: cast_nullable_to_non_nullable
              as double,
      equityChange: null == equityChange
          ? _value.equityChange
          : equityChange // ignore: cast_nullable_to_non_nullable
              as double,
      totalAssetsFormatted: null == totalAssetsFormatted
          ? _value.totalAssetsFormatted
          : totalAssetsFormatted // ignore: cast_nullable_to_non_nullable
              as String,
      totalLiabilitiesFormatted: null == totalLiabilitiesFormatted
          ? _value.totalLiabilitiesFormatted
          : totalLiabilitiesFormatted // ignore: cast_nullable_to_non_nullable
              as String,
      totalEquityFormatted: null == totalEquityFormatted
          ? _value.totalEquityFormatted
          : totalEquityFormatted // ignore: cast_nullable_to_non_nullable
              as String,
      assetsChangeFormatted: null == assetsChangeFormatted
          ? _value.assetsChangeFormatted
          : assetsChangeFormatted // ignore: cast_nullable_to_non_nullable
              as String,
      liabilitiesChangeFormatted: null == liabilitiesChangeFormatted
          ? _value.liabilitiesChangeFormatted
          : liabilitiesChangeFormatted // ignore: cast_nullable_to_non_nullable
              as String,
      equityChangeFormatted: null == equityChangeFormatted
          ? _value.equityChangeFormatted
          : equityChangeFormatted // ignore: cast_nullable_to_non_nullable
              as String,
      assetsIncreased: null == assetsIncreased
          ? _value.assetsIncreased
          : assetsIncreased // ignore: cast_nullable_to_non_nullable
              as bool,
      liabilitiesIncreased: null == liabilitiesIncreased
          ? _value.liabilitiesIncreased
          : liabilitiesIncreased // ignore: cast_nullable_to_non_nullable
              as bool,
      equityIncreased: null == equityIncreased
          ? _value.equityIncreased
          : equityIncreased // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BalanceSheetSummaryImplCopyWith<$Res>
    implements $BalanceSheetSummaryCopyWith<$Res> {
  factory _$$BalanceSheetSummaryImplCopyWith(_$BalanceSheetSummaryImpl value,
          $Res Function(_$BalanceSheetSummaryImpl) then) =
      __$$BalanceSheetSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'total_assets') double totalAssets,
      @JsonKey(name: 'total_liabilities') double totalLiabilities,
      @JsonKey(name: 'total_equity') double totalEquity,
      @JsonKey(name: 'assets_change') double assetsChange,
      @JsonKey(name: 'liabilities_change') double liabilitiesChange,
      @JsonKey(name: 'equity_change') double equityChange,
      @JsonKey(name: 'total_assets_formatted') String totalAssetsFormatted,
      @JsonKey(name: 'total_liabilities_formatted')
      String totalLiabilitiesFormatted,
      @JsonKey(name: 'total_equity_formatted') String totalEquityFormatted,
      @JsonKey(name: 'assets_change_formatted') String assetsChangeFormatted,
      @JsonKey(name: 'liabilities_change_formatted')
      String liabilitiesChangeFormatted,
      @JsonKey(name: 'equity_change_formatted') String equityChangeFormatted,
      @JsonKey(name: 'assets_increased') bool assetsIncreased,
      @JsonKey(name: 'liabilities_increased') bool liabilitiesIncreased,
      @JsonKey(name: 'equity_increased') bool equityIncreased});
}

/// @nodoc
class __$$BalanceSheetSummaryImplCopyWithImpl<$Res>
    extends _$BalanceSheetSummaryCopyWithImpl<$Res, _$BalanceSheetSummaryImpl>
    implements _$$BalanceSheetSummaryImplCopyWith<$Res> {
  __$$BalanceSheetSummaryImplCopyWithImpl(_$BalanceSheetSummaryImpl _value,
      $Res Function(_$BalanceSheetSummaryImpl) _then)
      : super(_value, _then);

  /// Create a copy of BalanceSheetSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalAssets = null,
    Object? totalLiabilities = null,
    Object? totalEquity = null,
    Object? assetsChange = null,
    Object? liabilitiesChange = null,
    Object? equityChange = null,
    Object? totalAssetsFormatted = null,
    Object? totalLiabilitiesFormatted = null,
    Object? totalEquityFormatted = null,
    Object? assetsChangeFormatted = null,
    Object? liabilitiesChangeFormatted = null,
    Object? equityChangeFormatted = null,
    Object? assetsIncreased = null,
    Object? liabilitiesIncreased = null,
    Object? equityIncreased = null,
  }) {
    return _then(_$BalanceSheetSummaryImpl(
      totalAssets: null == totalAssets
          ? _value.totalAssets
          : totalAssets // ignore: cast_nullable_to_non_nullable
              as double,
      totalLiabilities: null == totalLiabilities
          ? _value.totalLiabilities
          : totalLiabilities // ignore: cast_nullable_to_non_nullable
              as double,
      totalEquity: null == totalEquity
          ? _value.totalEquity
          : totalEquity // ignore: cast_nullable_to_non_nullable
              as double,
      assetsChange: null == assetsChange
          ? _value.assetsChange
          : assetsChange // ignore: cast_nullable_to_non_nullable
              as double,
      liabilitiesChange: null == liabilitiesChange
          ? _value.liabilitiesChange
          : liabilitiesChange // ignore: cast_nullable_to_non_nullable
              as double,
      equityChange: null == equityChange
          ? _value.equityChange
          : equityChange // ignore: cast_nullable_to_non_nullable
              as double,
      totalAssetsFormatted: null == totalAssetsFormatted
          ? _value.totalAssetsFormatted
          : totalAssetsFormatted // ignore: cast_nullable_to_non_nullable
              as String,
      totalLiabilitiesFormatted: null == totalLiabilitiesFormatted
          ? _value.totalLiabilitiesFormatted
          : totalLiabilitiesFormatted // ignore: cast_nullable_to_non_nullable
              as String,
      totalEquityFormatted: null == totalEquityFormatted
          ? _value.totalEquityFormatted
          : totalEquityFormatted // ignore: cast_nullable_to_non_nullable
              as String,
      assetsChangeFormatted: null == assetsChangeFormatted
          ? _value.assetsChangeFormatted
          : assetsChangeFormatted // ignore: cast_nullable_to_non_nullable
              as String,
      liabilitiesChangeFormatted: null == liabilitiesChangeFormatted
          ? _value.liabilitiesChangeFormatted
          : liabilitiesChangeFormatted // ignore: cast_nullable_to_non_nullable
              as String,
      equityChangeFormatted: null == equityChangeFormatted
          ? _value.equityChangeFormatted
          : equityChangeFormatted // ignore: cast_nullable_to_non_nullable
              as String,
      assetsIncreased: null == assetsIncreased
          ? _value.assetsIncreased
          : assetsIncreased // ignore: cast_nullable_to_non_nullable
              as bool,
      liabilitiesIncreased: null == liabilitiesIncreased
          ? _value.liabilitiesIncreased
          : liabilitiesIncreased // ignore: cast_nullable_to_non_nullable
              as bool,
      equityIncreased: null == equityIncreased
          ? _value.equityIncreased
          : equityIncreased // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BalanceSheetSummaryImpl extends _BalanceSheetSummary {
  const _$BalanceSheetSummaryImpl(
      {@JsonKey(name: 'total_assets') required this.totalAssets,
      @JsonKey(name: 'total_liabilities') required this.totalLiabilities,
      @JsonKey(name: 'total_equity') required this.totalEquity,
      @JsonKey(name: 'assets_change') required this.assetsChange,
      @JsonKey(name: 'liabilities_change') required this.liabilitiesChange,
      @JsonKey(name: 'equity_change') required this.equityChange,
      @JsonKey(name: 'total_assets_formatted')
      required this.totalAssetsFormatted,
      @JsonKey(name: 'total_liabilities_formatted')
      required this.totalLiabilitiesFormatted,
      @JsonKey(name: 'total_equity_formatted')
      required this.totalEquityFormatted,
      @JsonKey(name: 'assets_change_formatted')
      required this.assetsChangeFormatted,
      @JsonKey(name: 'liabilities_change_formatted')
      required this.liabilitiesChangeFormatted,
      @JsonKey(name: 'equity_change_formatted')
      required this.equityChangeFormatted,
      @JsonKey(name: 'assets_increased') required this.assetsIncreased,
      @JsonKey(name: 'liabilities_increased')
      required this.liabilitiesIncreased,
      @JsonKey(name: 'equity_increased') required this.equityIncreased})
      : super._();

  factory _$BalanceSheetSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$BalanceSheetSummaryImplFromJson(json);

  @override
  @JsonKey(name: 'total_assets')
  final double totalAssets;
  @override
  @JsonKey(name: 'total_liabilities')
  final double totalLiabilities;
  @override
  @JsonKey(name: 'total_equity')
  final double totalEquity;
  @override
  @JsonKey(name: 'assets_change')
  final double assetsChange;
  @override
  @JsonKey(name: 'liabilities_change')
  final double liabilitiesChange;
  @override
  @JsonKey(name: 'equity_change')
  final double equityChange;
  @override
  @JsonKey(name: 'total_assets_formatted')
  final String totalAssetsFormatted;
  @override
  @JsonKey(name: 'total_liabilities_formatted')
  final String totalLiabilitiesFormatted;
  @override
  @JsonKey(name: 'total_equity_formatted')
  final String totalEquityFormatted;
  @override
  @JsonKey(name: 'assets_change_formatted')
  final String assetsChangeFormatted;
  @override
  @JsonKey(name: 'liabilities_change_formatted')
  final String liabilitiesChangeFormatted;
  @override
  @JsonKey(name: 'equity_change_formatted')
  final String equityChangeFormatted;
  @override
  @JsonKey(name: 'assets_increased')
  final bool assetsIncreased;
  @override
  @JsonKey(name: 'liabilities_increased')
  final bool liabilitiesIncreased;
  @override
  @JsonKey(name: 'equity_increased')
  final bool equityIncreased;

  @override
  String toString() {
    return 'BalanceSheetSummary(totalAssets: $totalAssets, totalLiabilities: $totalLiabilities, totalEquity: $totalEquity, assetsChange: $assetsChange, liabilitiesChange: $liabilitiesChange, equityChange: $equityChange, totalAssetsFormatted: $totalAssetsFormatted, totalLiabilitiesFormatted: $totalLiabilitiesFormatted, totalEquityFormatted: $totalEquityFormatted, assetsChangeFormatted: $assetsChangeFormatted, liabilitiesChangeFormatted: $liabilitiesChangeFormatted, equityChangeFormatted: $equityChangeFormatted, assetsIncreased: $assetsIncreased, liabilitiesIncreased: $liabilitiesIncreased, equityIncreased: $equityIncreased)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BalanceSheetSummaryImpl &&
            (identical(other.totalAssets, totalAssets) ||
                other.totalAssets == totalAssets) &&
            (identical(other.totalLiabilities, totalLiabilities) ||
                other.totalLiabilities == totalLiabilities) &&
            (identical(other.totalEquity, totalEquity) ||
                other.totalEquity == totalEquity) &&
            (identical(other.assetsChange, assetsChange) ||
                other.assetsChange == assetsChange) &&
            (identical(other.liabilitiesChange, liabilitiesChange) ||
                other.liabilitiesChange == liabilitiesChange) &&
            (identical(other.equityChange, equityChange) ||
                other.equityChange == equityChange) &&
            (identical(other.totalAssetsFormatted, totalAssetsFormatted) ||
                other.totalAssetsFormatted == totalAssetsFormatted) &&
            (identical(other.totalLiabilitiesFormatted,
                    totalLiabilitiesFormatted) ||
                other.totalLiabilitiesFormatted == totalLiabilitiesFormatted) &&
            (identical(other.totalEquityFormatted, totalEquityFormatted) ||
                other.totalEquityFormatted == totalEquityFormatted) &&
            (identical(other.assetsChangeFormatted, assetsChangeFormatted) ||
                other.assetsChangeFormatted == assetsChangeFormatted) &&
            (identical(other.liabilitiesChangeFormatted,
                    liabilitiesChangeFormatted) ||
                other.liabilitiesChangeFormatted ==
                    liabilitiesChangeFormatted) &&
            (identical(other.equityChangeFormatted, equityChangeFormatted) ||
                other.equityChangeFormatted == equityChangeFormatted) &&
            (identical(other.assetsIncreased, assetsIncreased) ||
                other.assetsIncreased == assetsIncreased) &&
            (identical(other.liabilitiesIncreased, liabilitiesIncreased) ||
                other.liabilitiesIncreased == liabilitiesIncreased) &&
            (identical(other.equityIncreased, equityIncreased) ||
                other.equityIncreased == equityIncreased));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalAssets,
      totalLiabilities,
      totalEquity,
      assetsChange,
      liabilitiesChange,
      equityChange,
      totalAssetsFormatted,
      totalLiabilitiesFormatted,
      totalEquityFormatted,
      assetsChangeFormatted,
      liabilitiesChangeFormatted,
      equityChangeFormatted,
      assetsIncreased,
      liabilitiesIncreased,
      equityIncreased);

  /// Create a copy of BalanceSheetSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BalanceSheetSummaryImplCopyWith<_$BalanceSheetSummaryImpl> get copyWith =>
      __$$BalanceSheetSummaryImplCopyWithImpl<_$BalanceSheetSummaryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BalanceSheetSummaryImplToJson(
      this,
    );
  }
}

abstract class _BalanceSheetSummary extends BalanceSheetSummary {
  const factory _BalanceSheetSummary(
      {@JsonKey(name: 'total_assets') required final double totalAssets,
      @JsonKey(name: 'total_liabilities')
      required final double totalLiabilities,
      @JsonKey(name: 'total_equity') required final double totalEquity,
      @JsonKey(name: 'assets_change') required final double assetsChange,
      @JsonKey(name: 'liabilities_change')
      required final double liabilitiesChange,
      @JsonKey(name: 'equity_change') required final double equityChange,
      @JsonKey(name: 'total_assets_formatted')
      required final String totalAssetsFormatted,
      @JsonKey(name: 'total_liabilities_formatted')
      required final String totalLiabilitiesFormatted,
      @JsonKey(name: 'total_equity_formatted')
      required final String totalEquityFormatted,
      @JsonKey(name: 'assets_change_formatted')
      required final String assetsChangeFormatted,
      @JsonKey(name: 'liabilities_change_formatted')
      required final String liabilitiesChangeFormatted,
      @JsonKey(name: 'equity_change_formatted')
      required final String equityChangeFormatted,
      @JsonKey(name: 'assets_increased') required final bool assetsIncreased,
      @JsonKey(name: 'liabilities_increased')
      required final bool liabilitiesIncreased,
      @JsonKey(name: 'equity_increased')
      required final bool equityIncreased}) = _$BalanceSheetSummaryImpl;
  const _BalanceSheetSummary._() : super._();

  factory _BalanceSheetSummary.fromJson(Map<String, dynamic> json) =
      _$BalanceSheetSummaryImpl.fromJson;

  @override
  @JsonKey(name: 'total_assets')
  double get totalAssets;
  @override
  @JsonKey(name: 'total_liabilities')
  double get totalLiabilities;
  @override
  @JsonKey(name: 'total_equity')
  double get totalEquity;
  @override
  @JsonKey(name: 'assets_change')
  double get assetsChange;
  @override
  @JsonKey(name: 'liabilities_change')
  double get liabilitiesChange;
  @override
  @JsonKey(name: 'equity_change')
  double get equityChange;
  @override
  @JsonKey(name: 'total_assets_formatted')
  String get totalAssetsFormatted;
  @override
  @JsonKey(name: 'total_liabilities_formatted')
  String get totalLiabilitiesFormatted;
  @override
  @JsonKey(name: 'total_equity_formatted')
  String get totalEquityFormatted;
  @override
  @JsonKey(name: 'assets_change_formatted')
  String get assetsChangeFormatted;
  @override
  @JsonKey(name: 'liabilities_change_formatted')
  String get liabilitiesChangeFormatted;
  @override
  @JsonKey(name: 'equity_change_formatted')
  String get equityChangeFormatted;
  @override
  @JsonKey(name: 'assets_increased')
  bool get assetsIncreased;
  @override
  @JsonKey(name: 'liabilities_increased')
  bool get liabilitiesIncreased;
  @override
  @JsonKey(name: 'equity_increased')
  bool get equityIncreased;

  /// Create a copy of BalanceSheetSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BalanceSheetSummaryImplCopyWith<_$BalanceSheetSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AccountChanges _$AccountChangesFromJson(Map<String, dynamic> json) {
  return _AccountChanges.fromJson(json);
}

/// @nodoc
mixin _$AccountChanges {
  @JsonKey(name: 'company_wide')
  List<AccountCategory> get companyWide => throw _privateConstructorUsedError;
  @JsonKey(name: 'by_store')
  List<StoreAccountSummary> get byStore => throw _privateConstructorUsedError;

  /// Serializes this AccountChanges to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AccountChanges
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AccountChangesCopyWith<AccountChanges> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountChangesCopyWith<$Res> {
  factory $AccountChangesCopyWith(
          AccountChanges value, $Res Function(AccountChanges) then) =
      _$AccountChangesCopyWithImpl<$Res, AccountChanges>;
  @useResult
  $Res call(
      {@JsonKey(name: 'company_wide') List<AccountCategory> companyWide,
      @JsonKey(name: 'by_store') List<StoreAccountSummary> byStore});
}

/// @nodoc
class _$AccountChangesCopyWithImpl<$Res, $Val extends AccountChanges>
    implements $AccountChangesCopyWith<$Res> {
  _$AccountChangesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AccountChanges
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? companyWide = null,
    Object? byStore = null,
  }) {
    return _then(_value.copyWith(
      companyWide: null == companyWide
          ? _value.companyWide
          : companyWide // ignore: cast_nullable_to_non_nullable
              as List<AccountCategory>,
      byStore: null == byStore
          ? _value.byStore
          : byStore // ignore: cast_nullable_to_non_nullable
              as List<StoreAccountSummary>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AccountChangesImplCopyWith<$Res>
    implements $AccountChangesCopyWith<$Res> {
  factory _$$AccountChangesImplCopyWith(_$AccountChangesImpl value,
          $Res Function(_$AccountChangesImpl) then) =
      __$$AccountChangesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'company_wide') List<AccountCategory> companyWide,
      @JsonKey(name: 'by_store') List<StoreAccountSummary> byStore});
}

/// @nodoc
class __$$AccountChangesImplCopyWithImpl<$Res>
    extends _$AccountChangesCopyWithImpl<$Res, _$AccountChangesImpl>
    implements _$$AccountChangesImplCopyWith<$Res> {
  __$$AccountChangesImplCopyWithImpl(
      _$AccountChangesImpl _value, $Res Function(_$AccountChangesImpl) _then)
      : super(_value, _then);

  /// Create a copy of AccountChanges
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? companyWide = null,
    Object? byStore = null,
  }) {
    return _then(_$AccountChangesImpl(
      companyWide: null == companyWide
          ? _value._companyWide
          : companyWide // ignore: cast_nullable_to_non_nullable
              as List<AccountCategory>,
      byStore: null == byStore
          ? _value._byStore
          : byStore // ignore: cast_nullable_to_non_nullable
              as List<StoreAccountSummary>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AccountChangesImpl implements _AccountChanges {
  const _$AccountChangesImpl(
      {@JsonKey(name: 'company_wide')
      required final List<AccountCategory> companyWide,
      @JsonKey(name: 'by_store')
      required final List<StoreAccountSummary> byStore})
      : _companyWide = companyWide,
        _byStore = byStore;

  factory _$AccountChangesImpl.fromJson(Map<String, dynamic> json) =>
      _$$AccountChangesImplFromJson(json);

  final List<AccountCategory> _companyWide;
  @override
  @JsonKey(name: 'company_wide')
  List<AccountCategory> get companyWide {
    if (_companyWide is EqualUnmodifiableListView) return _companyWide;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_companyWide);
  }

  final List<StoreAccountSummary> _byStore;
  @override
  @JsonKey(name: 'by_store')
  List<StoreAccountSummary> get byStore {
    if (_byStore is EqualUnmodifiableListView) return _byStore;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_byStore);
  }

  @override
  String toString() {
    return 'AccountChanges(companyWide: $companyWide, byStore: $byStore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccountChangesImpl &&
            const DeepCollectionEquality()
                .equals(other._companyWide, _companyWide) &&
            const DeepCollectionEquality().equals(other._byStore, _byStore));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_companyWide),
      const DeepCollectionEquality().hash(_byStore));

  /// Create a copy of AccountChanges
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AccountChangesImplCopyWith<_$AccountChangesImpl> get copyWith =>
      __$$AccountChangesImplCopyWithImpl<_$AccountChangesImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AccountChangesImplToJson(
      this,
    );
  }
}

abstract class _AccountChanges implements AccountChanges {
  const factory _AccountChanges(
      {@JsonKey(name: 'company_wide')
      required final List<AccountCategory> companyWide,
      @JsonKey(name: 'by_store')
      required final List<StoreAccountSummary> byStore}) = _$AccountChangesImpl;

  factory _AccountChanges.fromJson(Map<String, dynamic> json) =
      _$AccountChangesImpl.fromJson;

  @override
  @JsonKey(name: 'company_wide')
  List<AccountCategory> get companyWide;
  @override
  @JsonKey(name: 'by_store')
  List<StoreAccountSummary> get byStore;

  /// Create a copy of AccountChanges
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AccountChangesImplCopyWith<_$AccountChangesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AccountCategory _$AccountCategoryFromJson(Map<String, dynamic> json) {
  return _AccountCategory.fromJson(json);
}

/// @nodoc
mixin _$AccountCategory {
  String get category => throw _privateConstructorUsedError;
  List<AccountItem> get accounts => throw _privateConstructorUsedError;

  /// Serializes this AccountCategory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AccountCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AccountCategoryCopyWith<AccountCategory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountCategoryCopyWith<$Res> {
  factory $AccountCategoryCopyWith(
          AccountCategory value, $Res Function(AccountCategory) then) =
      _$AccountCategoryCopyWithImpl<$Res, AccountCategory>;
  @useResult
  $Res call({String category, List<AccountItem> accounts});
}

/// @nodoc
class _$AccountCategoryCopyWithImpl<$Res, $Val extends AccountCategory>
    implements $AccountCategoryCopyWith<$Res> {
  _$AccountCategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AccountCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? accounts = null,
  }) {
    return _then(_value.copyWith(
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      accounts: null == accounts
          ? _value.accounts
          : accounts // ignore: cast_nullable_to_non_nullable
              as List<AccountItem>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AccountCategoryImplCopyWith<$Res>
    implements $AccountCategoryCopyWith<$Res> {
  factory _$$AccountCategoryImplCopyWith(_$AccountCategoryImpl value,
          $Res Function(_$AccountCategoryImpl) then) =
      __$$AccountCategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String category, List<AccountItem> accounts});
}

/// @nodoc
class __$$AccountCategoryImplCopyWithImpl<$Res>
    extends _$AccountCategoryCopyWithImpl<$Res, _$AccountCategoryImpl>
    implements _$$AccountCategoryImplCopyWith<$Res> {
  __$$AccountCategoryImplCopyWithImpl(
      _$AccountCategoryImpl _value, $Res Function(_$AccountCategoryImpl) _then)
      : super(_value, _then);

  /// Create a copy of AccountCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? accounts = null,
  }) {
    return _then(_$AccountCategoryImpl(
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      accounts: null == accounts
          ? _value._accounts
          : accounts // ignore: cast_nullable_to_non_nullable
              as List<AccountItem>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AccountCategoryImpl implements _AccountCategory {
  const _$AccountCategoryImpl(
      {required this.category, required final List<AccountItem> accounts})
      : _accounts = accounts;

  factory _$AccountCategoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$AccountCategoryImplFromJson(json);

  @override
  final String category;
  final List<AccountItem> _accounts;
  @override
  List<AccountItem> get accounts {
    if (_accounts is EqualUnmodifiableListView) return _accounts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_accounts);
  }

  @override
  String toString() {
    return 'AccountCategory(category: $category, accounts: $accounts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccountCategoryImpl &&
            (identical(other.category, category) ||
                other.category == category) &&
            const DeepCollectionEquality().equals(other._accounts, _accounts));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, category, const DeepCollectionEquality().hash(_accounts));

  /// Create a copy of AccountCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AccountCategoryImplCopyWith<_$AccountCategoryImpl> get copyWith =>
      __$$AccountCategoryImplCopyWithImpl<_$AccountCategoryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AccountCategoryImplToJson(
      this,
    );
  }
}

abstract class _AccountCategory implements AccountCategory {
  const factory _AccountCategory(
      {required final String category,
      required final List<AccountItem> accounts}) = _$AccountCategoryImpl;

  factory _AccountCategory.fromJson(Map<String, dynamic> json) =
      _$AccountCategoryImpl.fromJson;

  @override
  String get category;
  @override
  List<AccountItem> get accounts;

  /// Create a copy of AccountCategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AccountCategoryImplCopyWith<_$AccountCategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AccountItem _$AccountItemFromJson(Map<String, dynamic> json) {
  return _AccountItem.fromJson(json);
}

/// @nodoc
mixin _$AccountItem {
  String get name => throw _privateConstructorUsedError;
  double? get change =>
      throw _privateConstructorUsedError; // for balance changes
  double? get amount => throw _privateConstructorUsedError; // for totals
  String get formatted => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_increase')
  bool? get isIncrease => throw _privateConstructorUsedError;

  /// Serializes this AccountItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AccountItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AccountItemCopyWith<AccountItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountItemCopyWith<$Res> {
  factory $AccountItemCopyWith(
          AccountItem value, $Res Function(AccountItem) then) =
      _$AccountItemCopyWithImpl<$Res, AccountItem>;
  @useResult
  $Res call(
      {String name,
      double? change,
      double? amount,
      String formatted,
      @JsonKey(name: 'is_increase') bool? isIncrease});
}

/// @nodoc
class _$AccountItemCopyWithImpl<$Res, $Val extends AccountItem>
    implements $AccountItemCopyWith<$Res> {
  _$AccountItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AccountItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? change = freezed,
    Object? amount = freezed,
    Object? formatted = null,
    Object? isIncrease = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      change: freezed == change
          ? _value.change
          : change // ignore: cast_nullable_to_non_nullable
              as double?,
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double?,
      formatted: null == formatted
          ? _value.formatted
          : formatted // ignore: cast_nullable_to_non_nullable
              as String,
      isIncrease: freezed == isIncrease
          ? _value.isIncrease
          : isIncrease // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AccountItemImplCopyWith<$Res>
    implements $AccountItemCopyWith<$Res> {
  factory _$$AccountItemImplCopyWith(
          _$AccountItemImpl value, $Res Function(_$AccountItemImpl) then) =
      __$$AccountItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      double? change,
      double? amount,
      String formatted,
      @JsonKey(name: 'is_increase') bool? isIncrease});
}

/// @nodoc
class __$$AccountItemImplCopyWithImpl<$Res>
    extends _$AccountItemCopyWithImpl<$Res, _$AccountItemImpl>
    implements _$$AccountItemImplCopyWith<$Res> {
  __$$AccountItemImplCopyWithImpl(
      _$AccountItemImpl _value, $Res Function(_$AccountItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of AccountItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? change = freezed,
    Object? amount = freezed,
    Object? formatted = null,
    Object? isIncrease = freezed,
  }) {
    return _then(_$AccountItemImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      change: freezed == change
          ? _value.change
          : change // ignore: cast_nullable_to_non_nullable
              as double?,
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double?,
      formatted: null == formatted
          ? _value.formatted
          : formatted // ignore: cast_nullable_to_non_nullable
              as String,
      isIncrease: freezed == isIncrease
          ? _value.isIncrease
          : isIncrease // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AccountItemImpl implements _AccountItem {
  const _$AccountItemImpl(
      {required this.name,
      this.change,
      this.amount,
      required this.formatted,
      @JsonKey(name: 'is_increase') this.isIncrease});

  factory _$AccountItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$AccountItemImplFromJson(json);

  @override
  final String name;
  @override
  final double? change;
// for balance changes
  @override
  final double? amount;
// for totals
  @override
  final String formatted;
  @override
  @JsonKey(name: 'is_increase')
  final bool? isIncrease;

  @override
  String toString() {
    return 'AccountItem(name: $name, change: $change, amount: $amount, formatted: $formatted, isIncrease: $isIncrease)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccountItemImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.change, change) || other.change == change) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.formatted, formatted) ||
                other.formatted == formatted) &&
            (identical(other.isIncrease, isIncrease) ||
                other.isIncrease == isIncrease));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, name, change, amount, formatted, isIncrease);

  /// Create a copy of AccountItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AccountItemImplCopyWith<_$AccountItemImpl> get copyWith =>
      __$$AccountItemImplCopyWithImpl<_$AccountItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AccountItemImplToJson(
      this,
    );
  }
}

abstract class _AccountItem implements AccountItem {
  const factory _AccountItem(
          {required final String name,
          final double? change,
          final double? amount,
          required final String formatted,
          @JsonKey(name: 'is_increase') final bool? isIncrease}) =
      _$AccountItemImpl;

  factory _AccountItem.fromJson(Map<String, dynamic> json) =
      _$AccountItemImpl.fromJson;

  @override
  String get name;
  @override
  double? get change; // for balance changes
  @override
  double? get amount; // for totals
  @override
  String get formatted;
  @override
  @JsonKey(name: 'is_increase')
  bool? get isIncrease;

  /// Create a copy of AccountItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AccountItemImplCopyWith<_$AccountItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StoreAccountSummary _$StoreAccountSummaryFromJson(Map<String, dynamic> json) {
  return _StoreAccountSummary.fromJson(json);
}

/// @nodoc
mixin _$StoreAccountSummary {
  @JsonKey(name: 'store_name')
  String get storeName => throw _privateConstructorUsedError;
  @JsonKey(name: 'store_id')
  String get storeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_transactions')
  double get totalTransactions => throw _privateConstructorUsedError;
  double get revenue => throw _privateConstructorUsedError;
  List<AccountCategory> get categories => throw _privateConstructorUsedError;

  /// Serializes this StoreAccountSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StoreAccountSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StoreAccountSummaryCopyWith<StoreAccountSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoreAccountSummaryCopyWith<$Res> {
  factory $StoreAccountSummaryCopyWith(
          StoreAccountSummary value, $Res Function(StoreAccountSummary) then) =
      _$StoreAccountSummaryCopyWithImpl<$Res, StoreAccountSummary>;
  @useResult
  $Res call(
      {@JsonKey(name: 'store_name') String storeName,
      @JsonKey(name: 'store_id') String storeId,
      @JsonKey(name: 'total_transactions') double totalTransactions,
      double revenue,
      List<AccountCategory> categories});
}

/// @nodoc
class _$StoreAccountSummaryCopyWithImpl<$Res, $Val extends StoreAccountSummary>
    implements $StoreAccountSummaryCopyWith<$Res> {
  _$StoreAccountSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StoreAccountSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? storeName = null,
    Object? storeId = null,
    Object? totalTransactions = null,
    Object? revenue = null,
    Object? categories = null,
  }) {
    return _then(_value.copyWith(
      storeName: null == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      totalTransactions: null == totalTransactions
          ? _value.totalTransactions
          : totalTransactions // ignore: cast_nullable_to_non_nullable
              as double,
      revenue: null == revenue
          ? _value.revenue
          : revenue // ignore: cast_nullable_to_non_nullable
              as double,
      categories: null == categories
          ? _value.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<AccountCategory>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StoreAccountSummaryImplCopyWith<$Res>
    implements $StoreAccountSummaryCopyWith<$Res> {
  factory _$$StoreAccountSummaryImplCopyWith(_$StoreAccountSummaryImpl value,
          $Res Function(_$StoreAccountSummaryImpl) then) =
      __$$StoreAccountSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'store_name') String storeName,
      @JsonKey(name: 'store_id') String storeId,
      @JsonKey(name: 'total_transactions') double totalTransactions,
      double revenue,
      List<AccountCategory> categories});
}

/// @nodoc
class __$$StoreAccountSummaryImplCopyWithImpl<$Res>
    extends _$StoreAccountSummaryCopyWithImpl<$Res, _$StoreAccountSummaryImpl>
    implements _$$StoreAccountSummaryImplCopyWith<$Res> {
  __$$StoreAccountSummaryImplCopyWithImpl(_$StoreAccountSummaryImpl _value,
      $Res Function(_$StoreAccountSummaryImpl) _then)
      : super(_value, _then);

  /// Create a copy of StoreAccountSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? storeName = null,
    Object? storeId = null,
    Object? totalTransactions = null,
    Object? revenue = null,
    Object? categories = null,
  }) {
    return _then(_$StoreAccountSummaryImpl(
      storeName: null == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      totalTransactions: null == totalTransactions
          ? _value.totalTransactions
          : totalTransactions // ignore: cast_nullable_to_non_nullable
              as double,
      revenue: null == revenue
          ? _value.revenue
          : revenue // ignore: cast_nullable_to_non_nullable
              as double,
      categories: null == categories
          ? _value._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<AccountCategory>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StoreAccountSummaryImpl implements _StoreAccountSummary {
  const _$StoreAccountSummaryImpl(
      {@JsonKey(name: 'store_name') required this.storeName,
      @JsonKey(name: 'store_id') required this.storeId,
      @JsonKey(name: 'total_transactions') required this.totalTransactions,
      required this.revenue,
      required final List<AccountCategory> categories})
      : _categories = categories;

  factory _$StoreAccountSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$StoreAccountSummaryImplFromJson(json);

  @override
  @JsonKey(name: 'store_name')
  final String storeName;
  @override
  @JsonKey(name: 'store_id')
  final String storeId;
  @override
  @JsonKey(name: 'total_transactions')
  final double totalTransactions;
  @override
  final double revenue;
  final List<AccountCategory> _categories;
  @override
  List<AccountCategory> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  @override
  String toString() {
    return 'StoreAccountSummary(storeName: $storeName, storeId: $storeId, totalTransactions: $totalTransactions, revenue: $revenue, categories: $categories)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoreAccountSummaryImpl &&
            (identical(other.storeName, storeName) ||
                other.storeName == storeName) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.totalTransactions, totalTransactions) ||
                other.totalTransactions == totalTransactions) &&
            (identical(other.revenue, revenue) || other.revenue == revenue) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      storeName,
      storeId,
      totalTransactions,
      revenue,
      const DeepCollectionEquality().hash(_categories));

  /// Create a copy of StoreAccountSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StoreAccountSummaryImplCopyWith<_$StoreAccountSummaryImpl> get copyWith =>
      __$$StoreAccountSummaryImplCopyWithImpl<_$StoreAccountSummaryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StoreAccountSummaryImplToJson(
      this,
    );
  }
}

abstract class _StoreAccountSummary implements StoreAccountSummary {
  const factory _StoreAccountSummary(
          {@JsonKey(name: 'store_name') required final String storeName,
          @JsonKey(name: 'store_id') required final String storeId,
          @JsonKey(name: 'total_transactions')
          required final double totalTransactions,
          required final double revenue,
          required final List<AccountCategory> categories}) =
      _$StoreAccountSummaryImpl;

  factory _StoreAccountSummary.fromJson(Map<String, dynamic> json) =
      _$StoreAccountSummaryImpl.fromJson;

  @override
  @JsonKey(name: 'store_name')
  String get storeName;
  @override
  @JsonKey(name: 'store_id')
  String get storeId;
  @override
  @JsonKey(name: 'total_transactions')
  double get totalTransactions;
  @override
  double get revenue;
  @override
  List<AccountCategory> get categories;

  /// Create a copy of StoreAccountSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoreAccountSummaryImplCopyWith<_$StoreAccountSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RedFlags _$RedFlagsFromJson(Map<String, dynamic> json) {
  return _RedFlags.fromJson(json);
}

/// @nodoc
mixin _$RedFlags {
  @JsonKey(name: 'high_value_transactions')
  List<TransactionFlag> get highValueTransactions =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'missing_descriptions')
  List<TransactionFlag> get missingDescriptions =>
      throw _privateConstructorUsedError;

  /// Serializes this RedFlags to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RedFlags
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RedFlagsCopyWith<RedFlags> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RedFlagsCopyWith<$Res> {
  factory $RedFlagsCopyWith(RedFlags value, $Res Function(RedFlags) then) =
      _$RedFlagsCopyWithImpl<$Res, RedFlags>;
  @useResult
  $Res call(
      {@JsonKey(name: 'high_value_transactions')
      List<TransactionFlag> highValueTransactions,
      @JsonKey(name: 'missing_descriptions')
      List<TransactionFlag> missingDescriptions});
}

/// @nodoc
class _$RedFlagsCopyWithImpl<$Res, $Val extends RedFlags>
    implements $RedFlagsCopyWith<$Res> {
  _$RedFlagsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RedFlags
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? highValueTransactions = null,
    Object? missingDescriptions = null,
  }) {
    return _then(_value.copyWith(
      highValueTransactions: null == highValueTransactions
          ? _value.highValueTransactions
          : highValueTransactions // ignore: cast_nullable_to_non_nullable
              as List<TransactionFlag>,
      missingDescriptions: null == missingDescriptions
          ? _value.missingDescriptions
          : missingDescriptions // ignore: cast_nullable_to_non_nullable
              as List<TransactionFlag>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RedFlagsImplCopyWith<$Res>
    implements $RedFlagsCopyWith<$Res> {
  factory _$$RedFlagsImplCopyWith(
          _$RedFlagsImpl value, $Res Function(_$RedFlagsImpl) then) =
      __$$RedFlagsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'high_value_transactions')
      List<TransactionFlag> highValueTransactions,
      @JsonKey(name: 'missing_descriptions')
      List<TransactionFlag> missingDescriptions});
}

/// @nodoc
class __$$RedFlagsImplCopyWithImpl<$Res>
    extends _$RedFlagsCopyWithImpl<$Res, _$RedFlagsImpl>
    implements _$$RedFlagsImplCopyWith<$Res> {
  __$$RedFlagsImplCopyWithImpl(
      _$RedFlagsImpl _value, $Res Function(_$RedFlagsImpl) _then)
      : super(_value, _then);

  /// Create a copy of RedFlags
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? highValueTransactions = null,
    Object? missingDescriptions = null,
  }) {
    return _then(_$RedFlagsImpl(
      highValueTransactions: null == highValueTransactions
          ? _value._highValueTransactions
          : highValueTransactions // ignore: cast_nullable_to_non_nullable
              as List<TransactionFlag>,
      missingDescriptions: null == missingDescriptions
          ? _value._missingDescriptions
          : missingDescriptions // ignore: cast_nullable_to_non_nullable
              as List<TransactionFlag>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RedFlagsImpl implements _RedFlags {
  const _$RedFlagsImpl(
      {@JsonKey(name: 'high_value_transactions')
      required final List<TransactionFlag> highValueTransactions,
      @JsonKey(name: 'missing_descriptions')
      required final List<TransactionFlag> missingDescriptions})
      : _highValueTransactions = highValueTransactions,
        _missingDescriptions = missingDescriptions;

  factory _$RedFlagsImpl.fromJson(Map<String, dynamic> json) =>
      _$$RedFlagsImplFromJson(json);

  final List<TransactionFlag> _highValueTransactions;
  @override
  @JsonKey(name: 'high_value_transactions')
  List<TransactionFlag> get highValueTransactions {
    if (_highValueTransactions is EqualUnmodifiableListView)
      return _highValueTransactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_highValueTransactions);
  }

  final List<TransactionFlag> _missingDescriptions;
  @override
  @JsonKey(name: 'missing_descriptions')
  List<TransactionFlag> get missingDescriptions {
    if (_missingDescriptions is EqualUnmodifiableListView)
      return _missingDescriptions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_missingDescriptions);
  }

  @override
  String toString() {
    return 'RedFlags(highValueTransactions: $highValueTransactions, missingDescriptions: $missingDescriptions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RedFlagsImpl &&
            const DeepCollectionEquality()
                .equals(other._highValueTransactions, _highValueTransactions) &&
            const DeepCollectionEquality()
                .equals(other._missingDescriptions, _missingDescriptions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_highValueTransactions),
      const DeepCollectionEquality().hash(_missingDescriptions));

  /// Create a copy of RedFlags
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RedFlagsImplCopyWith<_$RedFlagsImpl> get copyWith =>
      __$$RedFlagsImplCopyWithImpl<_$RedFlagsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RedFlagsImplToJson(
      this,
    );
  }
}

abstract class _RedFlags implements RedFlags {
  const factory _RedFlags(
          {@JsonKey(name: 'high_value_transactions')
          required final List<TransactionFlag> highValueTransactions,
          @JsonKey(name: 'missing_descriptions')
          required final List<TransactionFlag> missingDescriptions}) =
      _$RedFlagsImpl;

  factory _RedFlags.fromJson(Map<String, dynamic> json) =
      _$RedFlagsImpl.fromJson;

  @override
  @JsonKey(name: 'high_value_transactions')
  List<TransactionFlag> get highValueTransactions;
  @override
  @JsonKey(name: 'missing_descriptions')
  List<TransactionFlag> get missingDescriptions;

  /// Create a copy of RedFlags
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RedFlagsImplCopyWith<_$RedFlagsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TransactionFlag _$TransactionFlagFromJson(Map<String, dynamic> json) {
  return _TransactionFlag.fromJson(json);
}

/// @nodoc
mixin _$TransactionFlag {
  double get amount => throw _privateConstructorUsedError;
  String get formatted => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get employee => throw _privateConstructorUsedError;
  String? get store => throw _privateConstructorUsedError;
  String? get severity => throw _privateConstructorUsedError;

  /// Serializes this TransactionFlag to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TransactionFlag
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionFlagCopyWith<TransactionFlag> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionFlagCopyWith<$Res> {
  factory $TransactionFlagCopyWith(
          TransactionFlag value, $Res Function(TransactionFlag) then) =
      _$TransactionFlagCopyWithImpl<$Res, TransactionFlag>;
  @useResult
  $Res call(
      {double amount,
      String formatted,
      String? description,
      String? employee,
      String? store,
      String? severity});
}

/// @nodoc
class _$TransactionFlagCopyWithImpl<$Res, $Val extends TransactionFlag>
    implements $TransactionFlagCopyWith<$Res> {
  _$TransactionFlagCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransactionFlag
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? amount = null,
    Object? formatted = null,
    Object? description = freezed,
    Object? employee = freezed,
    Object? store = freezed,
    Object? severity = freezed,
  }) {
    return _then(_value.copyWith(
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      formatted: null == formatted
          ? _value.formatted
          : formatted // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      employee: freezed == employee
          ? _value.employee
          : employee // ignore: cast_nullable_to_non_nullable
              as String?,
      store: freezed == store
          ? _value.store
          : store // ignore: cast_nullable_to_non_nullable
              as String?,
      severity: freezed == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransactionFlagImplCopyWith<$Res>
    implements $TransactionFlagCopyWith<$Res> {
  factory _$$TransactionFlagImplCopyWith(_$TransactionFlagImpl value,
          $Res Function(_$TransactionFlagImpl) then) =
      __$$TransactionFlagImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double amount,
      String formatted,
      String? description,
      String? employee,
      String? store,
      String? severity});
}

/// @nodoc
class __$$TransactionFlagImplCopyWithImpl<$Res>
    extends _$TransactionFlagCopyWithImpl<$Res, _$TransactionFlagImpl>
    implements _$$TransactionFlagImplCopyWith<$Res> {
  __$$TransactionFlagImplCopyWithImpl(
      _$TransactionFlagImpl _value, $Res Function(_$TransactionFlagImpl) _then)
      : super(_value, _then);

  /// Create a copy of TransactionFlag
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? amount = null,
    Object? formatted = null,
    Object? description = freezed,
    Object? employee = freezed,
    Object? store = freezed,
    Object? severity = freezed,
  }) {
    return _then(_$TransactionFlagImpl(
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      formatted: null == formatted
          ? _value.formatted
          : formatted // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      employee: freezed == employee
          ? _value.employee
          : employee // ignore: cast_nullable_to_non_nullable
              as String?,
      store: freezed == store
          ? _value.store
          : store // ignore: cast_nullable_to_non_nullable
              as String?,
      severity: freezed == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TransactionFlagImpl implements _TransactionFlag {
  const _$TransactionFlagImpl(
      {required this.amount,
      required this.formatted,
      this.description,
      this.employee,
      this.store,
      this.severity});

  factory _$TransactionFlagImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionFlagImplFromJson(json);

  @override
  final double amount;
  @override
  final String formatted;
  @override
  final String? description;
  @override
  final String? employee;
  @override
  final String? store;
  @override
  final String? severity;

  @override
  String toString() {
    return 'TransactionFlag(amount: $amount, formatted: $formatted, description: $description, employee: $employee, store: $store, severity: $severity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionFlagImpl &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.formatted, formatted) ||
                other.formatted == formatted) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.employee, employee) ||
                other.employee == employee) &&
            (identical(other.store, store) || other.store == store) &&
            (identical(other.severity, severity) ||
                other.severity == severity));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, amount, formatted, description, employee, store, severity);

  /// Create a copy of TransactionFlag
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionFlagImplCopyWith<_$TransactionFlagImpl> get copyWith =>
      __$$TransactionFlagImplCopyWithImpl<_$TransactionFlagImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionFlagImplToJson(
      this,
    );
  }
}

abstract class _TransactionFlag implements TransactionFlag {
  const factory _TransactionFlag(
      {required final double amount,
      required final String formatted,
      final String? description,
      final String? employee,
      final String? store,
      final String? severity}) = _$TransactionFlagImpl;

  factory _TransactionFlag.fromJson(Map<String, dynamic> json) =
      _$TransactionFlagImpl.fromJson;

  @override
  double get amount;
  @override
  String get formatted;
  @override
  String? get description;
  @override
  String? get employee;
  @override
  String? get store;
  @override
  String? get severity;

  /// Create a copy of TransactionFlag
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionFlagImplCopyWith<_$TransactionFlagImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AiInsights _$AiInsightsFromJson(Map<String, dynamic> json) {
  return _AiInsights.fromJson(json);
}

/// @nodoc
mixin _$AiInsights {
  String get summary => throw _privateConstructorUsedError;
  List<String> get trends => throw _privateConstructorUsedError;
  List<String> get recommendations => throw _privateConstructorUsedError;

  /// Serializes this AiInsights to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AiInsights
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AiInsightsCopyWith<AiInsights> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AiInsightsCopyWith<$Res> {
  factory $AiInsightsCopyWith(
          AiInsights value, $Res Function(AiInsights) then) =
      _$AiInsightsCopyWithImpl<$Res, AiInsights>;
  @useResult
  $Res call(
      {String summary, List<String> trends, List<String> recommendations});
}

/// @nodoc
class _$AiInsightsCopyWithImpl<$Res, $Val extends AiInsights>
    implements $AiInsightsCopyWith<$Res> {
  _$AiInsightsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AiInsights
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? summary = null,
    Object? trends = null,
    Object? recommendations = null,
  }) {
    return _then(_value.copyWith(
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String,
      trends: null == trends
          ? _value.trends
          : trends // ignore: cast_nullable_to_non_nullable
              as List<String>,
      recommendations: null == recommendations
          ? _value.recommendations
          : recommendations // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AiInsightsImplCopyWith<$Res>
    implements $AiInsightsCopyWith<$Res> {
  factory _$$AiInsightsImplCopyWith(
          _$AiInsightsImpl value, $Res Function(_$AiInsightsImpl) then) =
      __$$AiInsightsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String summary, List<String> trends, List<String> recommendations});
}

/// @nodoc
class __$$AiInsightsImplCopyWithImpl<$Res>
    extends _$AiInsightsCopyWithImpl<$Res, _$AiInsightsImpl>
    implements _$$AiInsightsImplCopyWith<$Res> {
  __$$AiInsightsImplCopyWithImpl(
      _$AiInsightsImpl _value, $Res Function(_$AiInsightsImpl) _then)
      : super(_value, _then);

  /// Create a copy of AiInsights
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? summary = null,
    Object? trends = null,
    Object? recommendations = null,
  }) {
    return _then(_$AiInsightsImpl(
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String,
      trends: null == trends
          ? _value._trends
          : trends // ignore: cast_nullable_to_non_nullable
              as List<String>,
      recommendations: null == recommendations
          ? _value._recommendations
          : recommendations // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AiInsightsImpl implements _AiInsights {
  const _$AiInsightsImpl(
      {required this.summary,
      required final List<String> trends,
      required final List<String> recommendations})
      : _trends = trends,
        _recommendations = recommendations;

  factory _$AiInsightsImpl.fromJson(Map<String, dynamic> json) =>
      _$$AiInsightsImplFromJson(json);

  @override
  final String summary;
  final List<String> _trends;
  @override
  List<String> get trends {
    if (_trends is EqualUnmodifiableListView) return _trends;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_trends);
  }

  final List<String> _recommendations;
  @override
  List<String> get recommendations {
    if (_recommendations is EqualUnmodifiableListView) return _recommendations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recommendations);
  }

  @override
  String toString() {
    return 'AiInsights(summary: $summary, trends: $trends, recommendations: $recommendations)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AiInsightsImpl &&
            (identical(other.summary, summary) || other.summary == summary) &&
            const DeepCollectionEquality().equals(other._trends, _trends) &&
            const DeepCollectionEquality()
                .equals(other._recommendations, _recommendations));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      summary,
      const DeepCollectionEquality().hash(_trends),
      const DeepCollectionEquality().hash(_recommendations));

  /// Create a copy of AiInsights
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AiInsightsImplCopyWith<_$AiInsightsImpl> get copyWith =>
      __$$AiInsightsImplCopyWithImpl<_$AiInsightsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AiInsightsImplToJson(
      this,
    );
  }
}

abstract class _AiInsights implements AiInsights {
  const factory _AiInsights(
      {required final String summary,
      required final List<String> trends,
      required final List<String> recommendations}) = _$AiInsightsImpl;

  factory _AiInsights.fromJson(Map<String, dynamic> json) =
      _$AiInsightsImpl.fromJson;

  @override
  String get summary;
  @override
  List<String> get trends;
  @override
  List<String> get recommendations;

  /// Create a copy of AiInsights
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AiInsightsImplCopyWith<_$AiInsightsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
