// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'monthly_salary_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MonthlySalaryReport _$MonthlySalaryReportFromJson(Map<String, dynamic> json) {
  return _MonthlySalaryReport.fromJson(json);
}

/// @nodoc
mixin _$MonthlySalaryReport {
  /// Report metadata
  @JsonKey(name: 'report_month')
  String get reportMonth => throw _privateConstructorUsedError;
  @JsonKey(name: 'generated_at')
  String? get generatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'currency_symbol')
  String get currencySymbol => throw _privateConstructorUsedError;
  @JsonKey(name: 'currency_code')
  String get currencyCode => throw _privateConstructorUsedError;

  /// Summary stats
  @JsonKey(name: 'summary')
  SalarySummary get summary => throw _privateConstructorUsedError;

  /// Employee list with salary and warnings
  @JsonKey(name: 'employees')
  List<SalaryEmployee> get employees => throw _privateConstructorUsedError;

  /// Manager quality metrics
  @JsonKey(name: 'manager_quality')
  ManagerQuality? get managerQuality => throw _privateConstructorUsedError;

  /// Important notices
  @JsonKey(name: 'notices')
  List<SalaryNotice> get notices => throw _privateConstructorUsedError;

  /// AI-generated insights
  @JsonKey(name: 'ai_insights')
  SalaryInsights get aiInsights => throw _privateConstructorUsedError;

  /// Serializes this MonthlySalaryReport to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MonthlySalaryReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MonthlySalaryReportCopyWith<MonthlySalaryReport> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MonthlySalaryReportCopyWith<$Res> {
  factory $MonthlySalaryReportCopyWith(
          MonthlySalaryReport value, $Res Function(MonthlySalaryReport) then) =
      _$MonthlySalaryReportCopyWithImpl<$Res, MonthlySalaryReport>;
  @useResult
  $Res call(
      {@JsonKey(name: 'report_month') String reportMonth,
      @JsonKey(name: 'generated_at') String? generatedAt,
      @JsonKey(name: 'currency_symbol') String currencySymbol,
      @JsonKey(name: 'currency_code') String currencyCode,
      @JsonKey(name: 'summary') SalarySummary summary,
      @JsonKey(name: 'employees') List<SalaryEmployee> employees,
      @JsonKey(name: 'manager_quality') ManagerQuality? managerQuality,
      @JsonKey(name: 'notices') List<SalaryNotice> notices,
      @JsonKey(name: 'ai_insights') SalaryInsights aiInsights});

  $SalarySummaryCopyWith<$Res> get summary;
  $ManagerQualityCopyWith<$Res>? get managerQuality;
  $SalaryInsightsCopyWith<$Res> get aiInsights;
}

/// @nodoc
class _$MonthlySalaryReportCopyWithImpl<$Res, $Val extends MonthlySalaryReport>
    implements $MonthlySalaryReportCopyWith<$Res> {
  _$MonthlySalaryReportCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MonthlySalaryReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reportMonth = null,
    Object? generatedAt = freezed,
    Object? currencySymbol = null,
    Object? currencyCode = null,
    Object? summary = null,
    Object? employees = null,
    Object? managerQuality = freezed,
    Object? notices = null,
    Object? aiInsights = null,
  }) {
    return _then(_value.copyWith(
      reportMonth: null == reportMonth
          ? _value.reportMonth
          : reportMonth // ignore: cast_nullable_to_non_nullable
              as String,
      generatedAt: freezed == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      currencySymbol: null == currencySymbol
          ? _value.currencySymbol
          : currencySymbol // ignore: cast_nullable_to_non_nullable
              as String,
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as SalarySummary,
      employees: null == employees
          ? _value.employees
          : employees // ignore: cast_nullable_to_non_nullable
              as List<SalaryEmployee>,
      managerQuality: freezed == managerQuality
          ? _value.managerQuality
          : managerQuality // ignore: cast_nullable_to_non_nullable
              as ManagerQuality?,
      notices: null == notices
          ? _value.notices
          : notices // ignore: cast_nullable_to_non_nullable
              as List<SalaryNotice>,
      aiInsights: null == aiInsights
          ? _value.aiInsights
          : aiInsights // ignore: cast_nullable_to_non_nullable
              as SalaryInsights,
    ) as $Val);
  }

  /// Create a copy of MonthlySalaryReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SalarySummaryCopyWith<$Res> get summary {
    return $SalarySummaryCopyWith<$Res>(_value.summary, (value) {
      return _then(_value.copyWith(summary: value) as $Val);
    });
  }

  /// Create a copy of MonthlySalaryReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ManagerQualityCopyWith<$Res>? get managerQuality {
    if (_value.managerQuality == null) {
      return null;
    }

    return $ManagerQualityCopyWith<$Res>(_value.managerQuality!, (value) {
      return _then(_value.copyWith(managerQuality: value) as $Val);
    });
  }

  /// Create a copy of MonthlySalaryReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SalaryInsightsCopyWith<$Res> get aiInsights {
    return $SalaryInsightsCopyWith<$Res>(_value.aiInsights, (value) {
      return _then(_value.copyWith(aiInsights: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MonthlySalaryReportImplCopyWith<$Res>
    implements $MonthlySalaryReportCopyWith<$Res> {
  factory _$$MonthlySalaryReportImplCopyWith(_$MonthlySalaryReportImpl value,
          $Res Function(_$MonthlySalaryReportImpl) then) =
      __$$MonthlySalaryReportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'report_month') String reportMonth,
      @JsonKey(name: 'generated_at') String? generatedAt,
      @JsonKey(name: 'currency_symbol') String currencySymbol,
      @JsonKey(name: 'currency_code') String currencyCode,
      @JsonKey(name: 'summary') SalarySummary summary,
      @JsonKey(name: 'employees') List<SalaryEmployee> employees,
      @JsonKey(name: 'manager_quality') ManagerQuality? managerQuality,
      @JsonKey(name: 'notices') List<SalaryNotice> notices,
      @JsonKey(name: 'ai_insights') SalaryInsights aiInsights});

  @override
  $SalarySummaryCopyWith<$Res> get summary;
  @override
  $ManagerQualityCopyWith<$Res>? get managerQuality;
  @override
  $SalaryInsightsCopyWith<$Res> get aiInsights;
}

/// @nodoc
class __$$MonthlySalaryReportImplCopyWithImpl<$Res>
    extends _$MonthlySalaryReportCopyWithImpl<$Res, _$MonthlySalaryReportImpl>
    implements _$$MonthlySalaryReportImplCopyWith<$Res> {
  __$$MonthlySalaryReportImplCopyWithImpl(_$MonthlySalaryReportImpl _value,
      $Res Function(_$MonthlySalaryReportImpl) _then)
      : super(_value, _then);

  /// Create a copy of MonthlySalaryReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reportMonth = null,
    Object? generatedAt = freezed,
    Object? currencySymbol = null,
    Object? currencyCode = null,
    Object? summary = null,
    Object? employees = null,
    Object? managerQuality = freezed,
    Object? notices = null,
    Object? aiInsights = null,
  }) {
    return _then(_$MonthlySalaryReportImpl(
      reportMonth: null == reportMonth
          ? _value.reportMonth
          : reportMonth // ignore: cast_nullable_to_non_nullable
              as String,
      generatedAt: freezed == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      currencySymbol: null == currencySymbol
          ? _value.currencySymbol
          : currencySymbol // ignore: cast_nullable_to_non_nullable
              as String,
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as SalarySummary,
      employees: null == employees
          ? _value._employees
          : employees // ignore: cast_nullable_to_non_nullable
              as List<SalaryEmployee>,
      managerQuality: freezed == managerQuality
          ? _value.managerQuality
          : managerQuality // ignore: cast_nullable_to_non_nullable
              as ManagerQuality?,
      notices: null == notices
          ? _value._notices
          : notices // ignore: cast_nullable_to_non_nullable
              as List<SalaryNotice>,
      aiInsights: null == aiInsights
          ? _value.aiInsights
          : aiInsights // ignore: cast_nullable_to_non_nullable
              as SalaryInsights,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MonthlySalaryReportImpl implements _MonthlySalaryReport {
  const _$MonthlySalaryReportImpl(
      {@JsonKey(name: 'report_month') required this.reportMonth,
      @JsonKey(name: 'generated_at') this.generatedAt,
      @JsonKey(name: 'currency_symbol') this.currencySymbol = '₫',
      @JsonKey(name: 'currency_code') this.currencyCode = 'VND',
      @JsonKey(name: 'summary') required this.summary,
      @JsonKey(name: 'employees')
      final List<SalaryEmployee> employees = const [],
      @JsonKey(name: 'manager_quality') this.managerQuality,
      @JsonKey(name: 'notices') final List<SalaryNotice> notices = const [],
      @JsonKey(name: 'ai_insights') required this.aiInsights})
      : _employees = employees,
        _notices = notices;

  factory _$MonthlySalaryReportImpl.fromJson(Map<String, dynamic> json) =>
      _$$MonthlySalaryReportImplFromJson(json);

  /// Report metadata
  @override
  @JsonKey(name: 'report_month')
  final String reportMonth;
  @override
  @JsonKey(name: 'generated_at')
  final String? generatedAt;
  @override
  @JsonKey(name: 'currency_symbol')
  final String currencySymbol;
  @override
  @JsonKey(name: 'currency_code')
  final String currencyCode;

  /// Summary stats
  @override
  @JsonKey(name: 'summary')
  final SalarySummary summary;

  /// Employee list with salary and warnings
  final List<SalaryEmployee> _employees;

  /// Employee list with salary and warnings
  @override
  @JsonKey(name: 'employees')
  List<SalaryEmployee> get employees {
    if (_employees is EqualUnmodifiableListView) return _employees;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_employees);
  }

  /// Manager quality metrics
  @override
  @JsonKey(name: 'manager_quality')
  final ManagerQuality? managerQuality;

  /// Important notices
  final List<SalaryNotice> _notices;

  /// Important notices
  @override
  @JsonKey(name: 'notices')
  List<SalaryNotice> get notices {
    if (_notices is EqualUnmodifiableListView) return _notices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_notices);
  }

  /// AI-generated insights
  @override
  @JsonKey(name: 'ai_insights')
  final SalaryInsights aiInsights;

  @override
  String toString() {
    return 'MonthlySalaryReport(reportMonth: $reportMonth, generatedAt: $generatedAt, currencySymbol: $currencySymbol, currencyCode: $currencyCode, summary: $summary, employees: $employees, managerQuality: $managerQuality, notices: $notices, aiInsights: $aiInsights)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MonthlySalaryReportImpl &&
            (identical(other.reportMonth, reportMonth) ||
                other.reportMonth == reportMonth) &&
            (identical(other.generatedAt, generatedAt) ||
                other.generatedAt == generatedAt) &&
            (identical(other.currencySymbol, currencySymbol) ||
                other.currencySymbol == currencySymbol) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            const DeepCollectionEquality()
                .equals(other._employees, _employees) &&
            (identical(other.managerQuality, managerQuality) ||
                other.managerQuality == managerQuality) &&
            const DeepCollectionEquality().equals(other._notices, _notices) &&
            (identical(other.aiInsights, aiInsights) ||
                other.aiInsights == aiInsights));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      reportMonth,
      generatedAt,
      currencySymbol,
      currencyCode,
      summary,
      const DeepCollectionEquality().hash(_employees),
      managerQuality,
      const DeepCollectionEquality().hash(_notices),
      aiInsights);

  /// Create a copy of MonthlySalaryReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MonthlySalaryReportImplCopyWith<_$MonthlySalaryReportImpl> get copyWith =>
      __$$MonthlySalaryReportImplCopyWithImpl<_$MonthlySalaryReportImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MonthlySalaryReportImplToJson(
      this,
    );
  }
}

abstract class _MonthlySalaryReport implements MonthlySalaryReport {
  const factory _MonthlySalaryReport(
      {@JsonKey(name: 'report_month') required final String reportMonth,
      @JsonKey(name: 'generated_at') final String? generatedAt,
      @JsonKey(name: 'currency_symbol') final String currencySymbol,
      @JsonKey(name: 'currency_code') final String currencyCode,
      @JsonKey(name: 'summary') required final SalarySummary summary,
      @JsonKey(name: 'employees') final List<SalaryEmployee> employees,
      @JsonKey(name: 'manager_quality') final ManagerQuality? managerQuality,
      @JsonKey(name: 'notices') final List<SalaryNotice> notices,
      @JsonKey(name: 'ai_insights')
      required final SalaryInsights aiInsights}) = _$MonthlySalaryReportImpl;

  factory _MonthlySalaryReport.fromJson(Map<String, dynamic> json) =
      _$MonthlySalaryReportImpl.fromJson;

  /// Report metadata
  @override
  @JsonKey(name: 'report_month')
  String get reportMonth;
  @override
  @JsonKey(name: 'generated_at')
  String? get generatedAt;
  @override
  @JsonKey(name: 'currency_symbol')
  String get currencySymbol;
  @override
  @JsonKey(name: 'currency_code')
  String get currencyCode;

  /// Summary stats
  @override
  @JsonKey(name: 'summary')
  SalarySummary get summary;

  /// Employee list with salary and warnings
  @override
  @JsonKey(name: 'employees')
  List<SalaryEmployee> get employees;

  /// Manager quality metrics
  @override
  @JsonKey(name: 'manager_quality')
  ManagerQuality? get managerQuality;

  /// Important notices
  @override
  @JsonKey(name: 'notices')
  List<SalaryNotice> get notices;

  /// AI-generated insights
  @override
  @JsonKey(name: 'ai_insights')
  SalaryInsights get aiInsights;

  /// Create a copy of MonthlySalaryReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MonthlySalaryReportImplCopyWith<_$MonthlySalaryReportImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SalarySummary _$SalarySummaryFromJson(Map<String, dynamic> json) {
  return _SalarySummary.fromJson(json);
}

/// @nodoc
mixin _$SalarySummary {
  @JsonKey(name: 'total_payment')
  double get totalPayment => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_payment_formatted')
  String get totalPaymentFormatted => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_base')
  double get totalBase => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_bonus')
  double get totalBonus => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_employees')
  int get totalEmployees => throw _privateConstructorUsedError;
  @JsonKey(name: 'employees_with_warnings')
  int get employeesWithWarnings => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_warnings')
  int get totalWarnings => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_warning_amount')
  double get totalWarningAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_warning_amount_formatted')
  String get totalWarningAmountFormatted => throw _privateConstructorUsedError;
  @JsonKey(name: 'payroll_status')
  String get payrollStatus => throw _privateConstructorUsedError;

  /// Serializes this SalarySummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SalarySummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SalarySummaryCopyWith<SalarySummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SalarySummaryCopyWith<$Res> {
  factory $SalarySummaryCopyWith(
          SalarySummary value, $Res Function(SalarySummary) then) =
      _$SalarySummaryCopyWithImpl<$Res, SalarySummary>;
  @useResult
  $Res call(
      {@JsonKey(name: 'total_payment') double totalPayment,
      @JsonKey(name: 'total_payment_formatted') String totalPaymentFormatted,
      @JsonKey(name: 'total_base') double totalBase,
      @JsonKey(name: 'total_bonus') double totalBonus,
      @JsonKey(name: 'total_employees') int totalEmployees,
      @JsonKey(name: 'employees_with_warnings') int employeesWithWarnings,
      @JsonKey(name: 'total_warnings') int totalWarnings,
      @JsonKey(name: 'total_warning_amount') double totalWarningAmount,
      @JsonKey(name: 'total_warning_amount_formatted')
      String totalWarningAmountFormatted,
      @JsonKey(name: 'payroll_status') String payrollStatus});
}

/// @nodoc
class _$SalarySummaryCopyWithImpl<$Res, $Val extends SalarySummary>
    implements $SalarySummaryCopyWith<$Res> {
  _$SalarySummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SalarySummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalPayment = null,
    Object? totalPaymentFormatted = null,
    Object? totalBase = null,
    Object? totalBonus = null,
    Object? totalEmployees = null,
    Object? employeesWithWarnings = null,
    Object? totalWarnings = null,
    Object? totalWarningAmount = null,
    Object? totalWarningAmountFormatted = null,
    Object? payrollStatus = null,
  }) {
    return _then(_value.copyWith(
      totalPayment: null == totalPayment
          ? _value.totalPayment
          : totalPayment // ignore: cast_nullable_to_non_nullable
              as double,
      totalPaymentFormatted: null == totalPaymentFormatted
          ? _value.totalPaymentFormatted
          : totalPaymentFormatted // ignore: cast_nullable_to_non_nullable
              as String,
      totalBase: null == totalBase
          ? _value.totalBase
          : totalBase // ignore: cast_nullable_to_non_nullable
              as double,
      totalBonus: null == totalBonus
          ? _value.totalBonus
          : totalBonus // ignore: cast_nullable_to_non_nullable
              as double,
      totalEmployees: null == totalEmployees
          ? _value.totalEmployees
          : totalEmployees // ignore: cast_nullable_to_non_nullable
              as int,
      employeesWithWarnings: null == employeesWithWarnings
          ? _value.employeesWithWarnings
          : employeesWithWarnings // ignore: cast_nullable_to_non_nullable
              as int,
      totalWarnings: null == totalWarnings
          ? _value.totalWarnings
          : totalWarnings // ignore: cast_nullable_to_non_nullable
              as int,
      totalWarningAmount: null == totalWarningAmount
          ? _value.totalWarningAmount
          : totalWarningAmount // ignore: cast_nullable_to_non_nullable
              as double,
      totalWarningAmountFormatted: null == totalWarningAmountFormatted
          ? _value.totalWarningAmountFormatted
          : totalWarningAmountFormatted // ignore: cast_nullable_to_non_nullable
              as String,
      payrollStatus: null == payrollStatus
          ? _value.payrollStatus
          : payrollStatus // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SalarySummaryImplCopyWith<$Res>
    implements $SalarySummaryCopyWith<$Res> {
  factory _$$SalarySummaryImplCopyWith(
          _$SalarySummaryImpl value, $Res Function(_$SalarySummaryImpl) then) =
      __$$SalarySummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'total_payment') double totalPayment,
      @JsonKey(name: 'total_payment_formatted') String totalPaymentFormatted,
      @JsonKey(name: 'total_base') double totalBase,
      @JsonKey(name: 'total_bonus') double totalBonus,
      @JsonKey(name: 'total_employees') int totalEmployees,
      @JsonKey(name: 'employees_with_warnings') int employeesWithWarnings,
      @JsonKey(name: 'total_warnings') int totalWarnings,
      @JsonKey(name: 'total_warning_amount') double totalWarningAmount,
      @JsonKey(name: 'total_warning_amount_formatted')
      String totalWarningAmountFormatted,
      @JsonKey(name: 'payroll_status') String payrollStatus});
}

/// @nodoc
class __$$SalarySummaryImplCopyWithImpl<$Res>
    extends _$SalarySummaryCopyWithImpl<$Res, _$SalarySummaryImpl>
    implements _$$SalarySummaryImplCopyWith<$Res> {
  __$$SalarySummaryImplCopyWithImpl(
      _$SalarySummaryImpl _value, $Res Function(_$SalarySummaryImpl) _then)
      : super(_value, _then);

  /// Create a copy of SalarySummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalPayment = null,
    Object? totalPaymentFormatted = null,
    Object? totalBase = null,
    Object? totalBonus = null,
    Object? totalEmployees = null,
    Object? employeesWithWarnings = null,
    Object? totalWarnings = null,
    Object? totalWarningAmount = null,
    Object? totalWarningAmountFormatted = null,
    Object? payrollStatus = null,
  }) {
    return _then(_$SalarySummaryImpl(
      totalPayment: null == totalPayment
          ? _value.totalPayment
          : totalPayment // ignore: cast_nullable_to_non_nullable
              as double,
      totalPaymentFormatted: null == totalPaymentFormatted
          ? _value.totalPaymentFormatted
          : totalPaymentFormatted // ignore: cast_nullable_to_non_nullable
              as String,
      totalBase: null == totalBase
          ? _value.totalBase
          : totalBase // ignore: cast_nullable_to_non_nullable
              as double,
      totalBonus: null == totalBonus
          ? _value.totalBonus
          : totalBonus // ignore: cast_nullable_to_non_nullable
              as double,
      totalEmployees: null == totalEmployees
          ? _value.totalEmployees
          : totalEmployees // ignore: cast_nullable_to_non_nullable
              as int,
      employeesWithWarnings: null == employeesWithWarnings
          ? _value.employeesWithWarnings
          : employeesWithWarnings // ignore: cast_nullable_to_non_nullable
              as int,
      totalWarnings: null == totalWarnings
          ? _value.totalWarnings
          : totalWarnings // ignore: cast_nullable_to_non_nullable
              as int,
      totalWarningAmount: null == totalWarningAmount
          ? _value.totalWarningAmount
          : totalWarningAmount // ignore: cast_nullable_to_non_nullable
              as double,
      totalWarningAmountFormatted: null == totalWarningAmountFormatted
          ? _value.totalWarningAmountFormatted
          : totalWarningAmountFormatted // ignore: cast_nullable_to_non_nullable
              as String,
      payrollStatus: null == payrollStatus
          ? _value.payrollStatus
          : payrollStatus // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SalarySummaryImpl implements _SalarySummary {
  const _$SalarySummaryImpl(
      {@JsonKey(name: 'total_payment') this.totalPayment = 0,
      @JsonKey(name: 'total_payment_formatted') this.totalPaymentFormatted = '',
      @JsonKey(name: 'total_base') this.totalBase = 0,
      @JsonKey(name: 'total_bonus') this.totalBonus = 0,
      @JsonKey(name: 'total_employees') this.totalEmployees = 0,
      @JsonKey(name: 'employees_with_warnings') this.employeesWithWarnings = 0,
      @JsonKey(name: 'total_warnings') this.totalWarnings = 0,
      @JsonKey(name: 'total_warning_amount') this.totalWarningAmount = 0,
      @JsonKey(name: 'total_warning_amount_formatted')
      this.totalWarningAmountFormatted = '',
      @JsonKey(name: 'payroll_status') this.payrollStatus = 'normal'});

  factory _$SalarySummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$SalarySummaryImplFromJson(json);

  @override
  @JsonKey(name: 'total_payment')
  final double totalPayment;
  @override
  @JsonKey(name: 'total_payment_formatted')
  final String totalPaymentFormatted;
  @override
  @JsonKey(name: 'total_base')
  final double totalBase;
  @override
  @JsonKey(name: 'total_bonus')
  final double totalBonus;
  @override
  @JsonKey(name: 'total_employees')
  final int totalEmployees;
  @override
  @JsonKey(name: 'employees_with_warnings')
  final int employeesWithWarnings;
  @override
  @JsonKey(name: 'total_warnings')
  final int totalWarnings;
  @override
  @JsonKey(name: 'total_warning_amount')
  final double totalWarningAmount;
  @override
  @JsonKey(name: 'total_warning_amount_formatted')
  final String totalWarningAmountFormatted;
  @override
  @JsonKey(name: 'payroll_status')
  final String payrollStatus;

  @override
  String toString() {
    return 'SalarySummary(totalPayment: $totalPayment, totalPaymentFormatted: $totalPaymentFormatted, totalBase: $totalBase, totalBonus: $totalBonus, totalEmployees: $totalEmployees, employeesWithWarnings: $employeesWithWarnings, totalWarnings: $totalWarnings, totalWarningAmount: $totalWarningAmount, totalWarningAmountFormatted: $totalWarningAmountFormatted, payrollStatus: $payrollStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SalarySummaryImpl &&
            (identical(other.totalPayment, totalPayment) ||
                other.totalPayment == totalPayment) &&
            (identical(other.totalPaymentFormatted, totalPaymentFormatted) ||
                other.totalPaymentFormatted == totalPaymentFormatted) &&
            (identical(other.totalBase, totalBase) ||
                other.totalBase == totalBase) &&
            (identical(other.totalBonus, totalBonus) ||
                other.totalBonus == totalBonus) &&
            (identical(other.totalEmployees, totalEmployees) ||
                other.totalEmployees == totalEmployees) &&
            (identical(other.employeesWithWarnings, employeesWithWarnings) ||
                other.employeesWithWarnings == employeesWithWarnings) &&
            (identical(other.totalWarnings, totalWarnings) ||
                other.totalWarnings == totalWarnings) &&
            (identical(other.totalWarningAmount, totalWarningAmount) ||
                other.totalWarningAmount == totalWarningAmount) &&
            (identical(other.totalWarningAmountFormatted,
                    totalWarningAmountFormatted) ||
                other.totalWarningAmountFormatted ==
                    totalWarningAmountFormatted) &&
            (identical(other.payrollStatus, payrollStatus) ||
                other.payrollStatus == payrollStatus));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalPayment,
      totalPaymentFormatted,
      totalBase,
      totalBonus,
      totalEmployees,
      employeesWithWarnings,
      totalWarnings,
      totalWarningAmount,
      totalWarningAmountFormatted,
      payrollStatus);

  /// Create a copy of SalarySummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SalarySummaryImplCopyWith<_$SalarySummaryImpl> get copyWith =>
      __$$SalarySummaryImplCopyWithImpl<_$SalarySummaryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SalarySummaryImplToJson(
      this,
    );
  }
}

abstract class _SalarySummary implements SalarySummary {
  const factory _SalarySummary(
      {@JsonKey(name: 'total_payment') final double totalPayment,
      @JsonKey(name: 'total_payment_formatted')
      final String totalPaymentFormatted,
      @JsonKey(name: 'total_base') final double totalBase,
      @JsonKey(name: 'total_bonus') final double totalBonus,
      @JsonKey(name: 'total_employees') final int totalEmployees,
      @JsonKey(name: 'employees_with_warnings') final int employeesWithWarnings,
      @JsonKey(name: 'total_warnings') final int totalWarnings,
      @JsonKey(name: 'total_warning_amount') final double totalWarningAmount,
      @JsonKey(name: 'total_warning_amount_formatted')
      final String totalWarningAmountFormatted,
      @JsonKey(name: 'payroll_status')
      final String payrollStatus}) = _$SalarySummaryImpl;

  factory _SalarySummary.fromJson(Map<String, dynamic> json) =
      _$SalarySummaryImpl.fromJson;

  @override
  @JsonKey(name: 'total_payment')
  double get totalPayment;
  @override
  @JsonKey(name: 'total_payment_formatted')
  String get totalPaymentFormatted;
  @override
  @JsonKey(name: 'total_base')
  double get totalBase;
  @override
  @JsonKey(name: 'total_bonus')
  double get totalBonus;
  @override
  @JsonKey(name: 'total_employees')
  int get totalEmployees;
  @override
  @JsonKey(name: 'employees_with_warnings')
  int get employeesWithWarnings;
  @override
  @JsonKey(name: 'total_warnings')
  int get totalWarnings;
  @override
  @JsonKey(name: 'total_warning_amount')
  double get totalWarningAmount;
  @override
  @JsonKey(name: 'total_warning_amount_formatted')
  String get totalWarningAmountFormatted;
  @override
  @JsonKey(name: 'payroll_status')
  String get payrollStatus;

  /// Create a copy of SalarySummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SalarySummaryImplCopyWith<_$SalarySummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SalaryEmployee _$SalaryEmployeeFromJson(Map<String, dynamic> json) {
  return _SalaryEmployee.fromJson(json);
}

/// @nodoc
mixin _$SalaryEmployee {
  @JsonKey(name: 'employee_name')
  String get employeeName => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_manager')
  bool get isManager => throw _privateConstructorUsedError;
  @JsonKey(name: 'salary')
  EmployeeSalary get salary => throw _privateConstructorUsedError;
  @JsonKey(name: 'bank_info')
  BankInfo? get bankInfo => throw _privateConstructorUsedError;
  @JsonKey(name: 'has_warnings')
  bool get hasWarnings => throw _privateConstructorUsedError;
  @JsonKey(name: 'warning_count')
  int get warningCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'warning_total')
  double get warningTotal => throw _privateConstructorUsedError;
  @JsonKey(name: 'warning_total_formatted')
  String get warningTotalFormatted => throw _privateConstructorUsedError;
  @JsonKey(name: 'warnings')
  List<SalaryWarning> get warnings => throw _privateConstructorUsedError;

  /// Serializes this SalaryEmployee to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SalaryEmployee
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SalaryEmployeeCopyWith<SalaryEmployee> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SalaryEmployeeCopyWith<$Res> {
  factory $SalaryEmployeeCopyWith(
          SalaryEmployee value, $Res Function(SalaryEmployee) then) =
      _$SalaryEmployeeCopyWithImpl<$Res, SalaryEmployee>;
  @useResult
  $Res call(
      {@JsonKey(name: 'employee_name') String employeeName,
      @JsonKey(name: 'is_manager') bool isManager,
      @JsonKey(name: 'salary') EmployeeSalary salary,
      @JsonKey(name: 'bank_info') BankInfo? bankInfo,
      @JsonKey(name: 'has_warnings') bool hasWarnings,
      @JsonKey(name: 'warning_count') int warningCount,
      @JsonKey(name: 'warning_total') double warningTotal,
      @JsonKey(name: 'warning_total_formatted') String warningTotalFormatted,
      @JsonKey(name: 'warnings') List<SalaryWarning> warnings});

  $EmployeeSalaryCopyWith<$Res> get salary;
  $BankInfoCopyWith<$Res>? get bankInfo;
}

/// @nodoc
class _$SalaryEmployeeCopyWithImpl<$Res, $Val extends SalaryEmployee>
    implements $SalaryEmployeeCopyWith<$Res> {
  _$SalaryEmployeeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SalaryEmployee
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? employeeName = null,
    Object? isManager = null,
    Object? salary = null,
    Object? bankInfo = freezed,
    Object? hasWarnings = null,
    Object? warningCount = null,
    Object? warningTotal = null,
    Object? warningTotalFormatted = null,
    Object? warnings = null,
  }) {
    return _then(_value.copyWith(
      employeeName: null == employeeName
          ? _value.employeeName
          : employeeName // ignore: cast_nullable_to_non_nullable
              as String,
      isManager: null == isManager
          ? _value.isManager
          : isManager // ignore: cast_nullable_to_non_nullable
              as bool,
      salary: null == salary
          ? _value.salary
          : salary // ignore: cast_nullable_to_non_nullable
              as EmployeeSalary,
      bankInfo: freezed == bankInfo
          ? _value.bankInfo
          : bankInfo // ignore: cast_nullable_to_non_nullable
              as BankInfo?,
      hasWarnings: null == hasWarnings
          ? _value.hasWarnings
          : hasWarnings // ignore: cast_nullable_to_non_nullable
              as bool,
      warningCount: null == warningCount
          ? _value.warningCount
          : warningCount // ignore: cast_nullable_to_non_nullable
              as int,
      warningTotal: null == warningTotal
          ? _value.warningTotal
          : warningTotal // ignore: cast_nullable_to_non_nullable
              as double,
      warningTotalFormatted: null == warningTotalFormatted
          ? _value.warningTotalFormatted
          : warningTotalFormatted // ignore: cast_nullable_to_non_nullable
              as String,
      warnings: null == warnings
          ? _value.warnings
          : warnings // ignore: cast_nullable_to_non_nullable
              as List<SalaryWarning>,
    ) as $Val);
  }

  /// Create a copy of SalaryEmployee
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $EmployeeSalaryCopyWith<$Res> get salary {
    return $EmployeeSalaryCopyWith<$Res>(_value.salary, (value) {
      return _then(_value.copyWith(salary: value) as $Val);
    });
  }

  /// Create a copy of SalaryEmployee
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BankInfoCopyWith<$Res>? get bankInfo {
    if (_value.bankInfo == null) {
      return null;
    }

    return $BankInfoCopyWith<$Res>(_value.bankInfo!, (value) {
      return _then(_value.copyWith(bankInfo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SalaryEmployeeImplCopyWith<$Res>
    implements $SalaryEmployeeCopyWith<$Res> {
  factory _$$SalaryEmployeeImplCopyWith(_$SalaryEmployeeImpl value,
          $Res Function(_$SalaryEmployeeImpl) then) =
      __$$SalaryEmployeeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'employee_name') String employeeName,
      @JsonKey(name: 'is_manager') bool isManager,
      @JsonKey(name: 'salary') EmployeeSalary salary,
      @JsonKey(name: 'bank_info') BankInfo? bankInfo,
      @JsonKey(name: 'has_warnings') bool hasWarnings,
      @JsonKey(name: 'warning_count') int warningCount,
      @JsonKey(name: 'warning_total') double warningTotal,
      @JsonKey(name: 'warning_total_formatted') String warningTotalFormatted,
      @JsonKey(name: 'warnings') List<SalaryWarning> warnings});

  @override
  $EmployeeSalaryCopyWith<$Res> get salary;
  @override
  $BankInfoCopyWith<$Res>? get bankInfo;
}

/// @nodoc
class __$$SalaryEmployeeImplCopyWithImpl<$Res>
    extends _$SalaryEmployeeCopyWithImpl<$Res, _$SalaryEmployeeImpl>
    implements _$$SalaryEmployeeImplCopyWith<$Res> {
  __$$SalaryEmployeeImplCopyWithImpl(
      _$SalaryEmployeeImpl _value, $Res Function(_$SalaryEmployeeImpl) _then)
      : super(_value, _then);

  /// Create a copy of SalaryEmployee
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? employeeName = null,
    Object? isManager = null,
    Object? salary = null,
    Object? bankInfo = freezed,
    Object? hasWarnings = null,
    Object? warningCount = null,
    Object? warningTotal = null,
    Object? warningTotalFormatted = null,
    Object? warnings = null,
  }) {
    return _then(_$SalaryEmployeeImpl(
      employeeName: null == employeeName
          ? _value.employeeName
          : employeeName // ignore: cast_nullable_to_non_nullable
              as String,
      isManager: null == isManager
          ? _value.isManager
          : isManager // ignore: cast_nullable_to_non_nullable
              as bool,
      salary: null == salary
          ? _value.salary
          : salary // ignore: cast_nullable_to_non_nullable
              as EmployeeSalary,
      bankInfo: freezed == bankInfo
          ? _value.bankInfo
          : bankInfo // ignore: cast_nullable_to_non_nullable
              as BankInfo?,
      hasWarnings: null == hasWarnings
          ? _value.hasWarnings
          : hasWarnings // ignore: cast_nullable_to_non_nullable
              as bool,
      warningCount: null == warningCount
          ? _value.warningCount
          : warningCount // ignore: cast_nullable_to_non_nullable
              as int,
      warningTotal: null == warningTotal
          ? _value.warningTotal
          : warningTotal // ignore: cast_nullable_to_non_nullable
              as double,
      warningTotalFormatted: null == warningTotalFormatted
          ? _value.warningTotalFormatted
          : warningTotalFormatted // ignore: cast_nullable_to_non_nullable
              as String,
      warnings: null == warnings
          ? _value._warnings
          : warnings // ignore: cast_nullable_to_non_nullable
              as List<SalaryWarning>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SalaryEmployeeImpl implements _SalaryEmployee {
  const _$SalaryEmployeeImpl(
      {@JsonKey(name: 'employee_name') this.employeeName = '',
      @JsonKey(name: 'is_manager') this.isManager = false,
      @JsonKey(name: 'salary') required this.salary,
      @JsonKey(name: 'bank_info') this.bankInfo,
      @JsonKey(name: 'has_warnings') this.hasWarnings = false,
      @JsonKey(name: 'warning_count') this.warningCount = 0,
      @JsonKey(name: 'warning_total') this.warningTotal = 0,
      @JsonKey(name: 'warning_total_formatted') this.warningTotalFormatted = '',
      @JsonKey(name: 'warnings') final List<SalaryWarning> warnings = const []})
      : _warnings = warnings;

  factory _$SalaryEmployeeImpl.fromJson(Map<String, dynamic> json) =>
      _$$SalaryEmployeeImplFromJson(json);

  @override
  @JsonKey(name: 'employee_name')
  final String employeeName;
  @override
  @JsonKey(name: 'is_manager')
  final bool isManager;
  @override
  @JsonKey(name: 'salary')
  final EmployeeSalary salary;
  @override
  @JsonKey(name: 'bank_info')
  final BankInfo? bankInfo;
  @override
  @JsonKey(name: 'has_warnings')
  final bool hasWarnings;
  @override
  @JsonKey(name: 'warning_count')
  final int warningCount;
  @override
  @JsonKey(name: 'warning_total')
  final double warningTotal;
  @override
  @JsonKey(name: 'warning_total_formatted')
  final String warningTotalFormatted;
  final List<SalaryWarning> _warnings;
  @override
  @JsonKey(name: 'warnings')
  List<SalaryWarning> get warnings {
    if (_warnings is EqualUnmodifiableListView) return _warnings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_warnings);
  }

  @override
  String toString() {
    return 'SalaryEmployee(employeeName: $employeeName, isManager: $isManager, salary: $salary, bankInfo: $bankInfo, hasWarnings: $hasWarnings, warningCount: $warningCount, warningTotal: $warningTotal, warningTotalFormatted: $warningTotalFormatted, warnings: $warnings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SalaryEmployeeImpl &&
            (identical(other.employeeName, employeeName) ||
                other.employeeName == employeeName) &&
            (identical(other.isManager, isManager) ||
                other.isManager == isManager) &&
            (identical(other.salary, salary) || other.salary == salary) &&
            (identical(other.bankInfo, bankInfo) ||
                other.bankInfo == bankInfo) &&
            (identical(other.hasWarnings, hasWarnings) ||
                other.hasWarnings == hasWarnings) &&
            (identical(other.warningCount, warningCount) ||
                other.warningCount == warningCount) &&
            (identical(other.warningTotal, warningTotal) ||
                other.warningTotal == warningTotal) &&
            (identical(other.warningTotalFormatted, warningTotalFormatted) ||
                other.warningTotalFormatted == warningTotalFormatted) &&
            const DeepCollectionEquality().equals(other._warnings, _warnings));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      employeeName,
      isManager,
      salary,
      bankInfo,
      hasWarnings,
      warningCount,
      warningTotal,
      warningTotalFormatted,
      const DeepCollectionEquality().hash(_warnings));

  /// Create a copy of SalaryEmployee
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SalaryEmployeeImplCopyWith<_$SalaryEmployeeImpl> get copyWith =>
      __$$SalaryEmployeeImplCopyWithImpl<_$SalaryEmployeeImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SalaryEmployeeImplToJson(
      this,
    );
  }
}

abstract class _SalaryEmployee implements SalaryEmployee {
  const factory _SalaryEmployee(
          {@JsonKey(name: 'employee_name') final String employeeName,
          @JsonKey(name: 'is_manager') final bool isManager,
          @JsonKey(name: 'salary') required final EmployeeSalary salary,
          @JsonKey(name: 'bank_info') final BankInfo? bankInfo,
          @JsonKey(name: 'has_warnings') final bool hasWarnings,
          @JsonKey(name: 'warning_count') final int warningCount,
          @JsonKey(name: 'warning_total') final double warningTotal,
          @JsonKey(name: 'warning_total_formatted')
          final String warningTotalFormatted,
          @JsonKey(name: 'warnings') final List<SalaryWarning> warnings}) =
      _$SalaryEmployeeImpl;

  factory _SalaryEmployee.fromJson(Map<String, dynamic> json) =
      _$SalaryEmployeeImpl.fromJson;

  @override
  @JsonKey(name: 'employee_name')
  String get employeeName;
  @override
  @JsonKey(name: 'is_manager')
  bool get isManager;
  @override
  @JsonKey(name: 'salary')
  EmployeeSalary get salary;
  @override
  @JsonKey(name: 'bank_info')
  BankInfo? get bankInfo;
  @override
  @JsonKey(name: 'has_warnings')
  bool get hasWarnings;
  @override
  @JsonKey(name: 'warning_count')
  int get warningCount;
  @override
  @JsonKey(name: 'warning_total')
  double get warningTotal;
  @override
  @JsonKey(name: 'warning_total_formatted')
  String get warningTotalFormatted;
  @override
  @JsonKey(name: 'warnings')
  List<SalaryWarning> get warnings;

  /// Create a copy of SalaryEmployee
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SalaryEmployeeImplCopyWith<_$SalaryEmployeeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EmployeeSalary _$EmployeeSalaryFromJson(Map<String, dynamic> json) {
  return _EmployeeSalary.fromJson(json);
}

/// @nodoc
mixin _$EmployeeSalary {
  @JsonKey(name: 'total_payment')
  double get totalPayment => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_payment_formatted')
  String get totalPaymentFormatted => throw _privateConstructorUsedError;
  @JsonKey(name: 'base_payment')
  double get basePayment => throw _privateConstructorUsedError;
  @JsonKey(name: 'bonus')
  double get bonus => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_hours')
  double get totalHours => throw _privateConstructorUsedError;
  @JsonKey(name: 'shift_count')
  int get shiftCount => throw _privateConstructorUsedError;

  /// Serializes this EmployeeSalary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EmployeeSalary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EmployeeSalaryCopyWith<EmployeeSalary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmployeeSalaryCopyWith<$Res> {
  factory $EmployeeSalaryCopyWith(
          EmployeeSalary value, $Res Function(EmployeeSalary) then) =
      _$EmployeeSalaryCopyWithImpl<$Res, EmployeeSalary>;
  @useResult
  $Res call(
      {@JsonKey(name: 'total_payment') double totalPayment,
      @JsonKey(name: 'total_payment_formatted') String totalPaymentFormatted,
      @JsonKey(name: 'base_payment') double basePayment,
      @JsonKey(name: 'bonus') double bonus,
      @JsonKey(name: 'total_hours') double totalHours,
      @JsonKey(name: 'shift_count') int shiftCount});
}

/// @nodoc
class _$EmployeeSalaryCopyWithImpl<$Res, $Val extends EmployeeSalary>
    implements $EmployeeSalaryCopyWith<$Res> {
  _$EmployeeSalaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EmployeeSalary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalPayment = null,
    Object? totalPaymentFormatted = null,
    Object? basePayment = null,
    Object? bonus = null,
    Object? totalHours = null,
    Object? shiftCount = null,
  }) {
    return _then(_value.copyWith(
      totalPayment: null == totalPayment
          ? _value.totalPayment
          : totalPayment // ignore: cast_nullable_to_non_nullable
              as double,
      totalPaymentFormatted: null == totalPaymentFormatted
          ? _value.totalPaymentFormatted
          : totalPaymentFormatted // ignore: cast_nullable_to_non_nullable
              as String,
      basePayment: null == basePayment
          ? _value.basePayment
          : basePayment // ignore: cast_nullable_to_non_nullable
              as double,
      bonus: null == bonus
          ? _value.bonus
          : bonus // ignore: cast_nullable_to_non_nullable
              as double,
      totalHours: null == totalHours
          ? _value.totalHours
          : totalHours // ignore: cast_nullable_to_non_nullable
              as double,
      shiftCount: null == shiftCount
          ? _value.shiftCount
          : shiftCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EmployeeSalaryImplCopyWith<$Res>
    implements $EmployeeSalaryCopyWith<$Res> {
  factory _$$EmployeeSalaryImplCopyWith(_$EmployeeSalaryImpl value,
          $Res Function(_$EmployeeSalaryImpl) then) =
      __$$EmployeeSalaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'total_payment') double totalPayment,
      @JsonKey(name: 'total_payment_formatted') String totalPaymentFormatted,
      @JsonKey(name: 'base_payment') double basePayment,
      @JsonKey(name: 'bonus') double bonus,
      @JsonKey(name: 'total_hours') double totalHours,
      @JsonKey(name: 'shift_count') int shiftCount});
}

/// @nodoc
class __$$EmployeeSalaryImplCopyWithImpl<$Res>
    extends _$EmployeeSalaryCopyWithImpl<$Res, _$EmployeeSalaryImpl>
    implements _$$EmployeeSalaryImplCopyWith<$Res> {
  __$$EmployeeSalaryImplCopyWithImpl(
      _$EmployeeSalaryImpl _value, $Res Function(_$EmployeeSalaryImpl) _then)
      : super(_value, _then);

  /// Create a copy of EmployeeSalary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalPayment = null,
    Object? totalPaymentFormatted = null,
    Object? basePayment = null,
    Object? bonus = null,
    Object? totalHours = null,
    Object? shiftCount = null,
  }) {
    return _then(_$EmployeeSalaryImpl(
      totalPayment: null == totalPayment
          ? _value.totalPayment
          : totalPayment // ignore: cast_nullable_to_non_nullable
              as double,
      totalPaymentFormatted: null == totalPaymentFormatted
          ? _value.totalPaymentFormatted
          : totalPaymentFormatted // ignore: cast_nullable_to_non_nullable
              as String,
      basePayment: null == basePayment
          ? _value.basePayment
          : basePayment // ignore: cast_nullable_to_non_nullable
              as double,
      bonus: null == bonus
          ? _value.bonus
          : bonus // ignore: cast_nullable_to_non_nullable
              as double,
      totalHours: null == totalHours
          ? _value.totalHours
          : totalHours // ignore: cast_nullable_to_non_nullable
              as double,
      shiftCount: null == shiftCount
          ? _value.shiftCount
          : shiftCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EmployeeSalaryImpl implements _EmployeeSalary {
  const _$EmployeeSalaryImpl(
      {@JsonKey(name: 'total_payment') this.totalPayment = 0,
      @JsonKey(name: 'total_payment_formatted') this.totalPaymentFormatted = '',
      @JsonKey(name: 'base_payment') this.basePayment = 0,
      @JsonKey(name: 'bonus') this.bonus = 0,
      @JsonKey(name: 'total_hours') this.totalHours = 0,
      @JsonKey(name: 'shift_count') this.shiftCount = 0});

  factory _$EmployeeSalaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$EmployeeSalaryImplFromJson(json);

  @override
  @JsonKey(name: 'total_payment')
  final double totalPayment;
  @override
  @JsonKey(name: 'total_payment_formatted')
  final String totalPaymentFormatted;
  @override
  @JsonKey(name: 'base_payment')
  final double basePayment;
  @override
  @JsonKey(name: 'bonus')
  final double bonus;
  @override
  @JsonKey(name: 'total_hours')
  final double totalHours;
  @override
  @JsonKey(name: 'shift_count')
  final int shiftCount;

  @override
  String toString() {
    return 'EmployeeSalary(totalPayment: $totalPayment, totalPaymentFormatted: $totalPaymentFormatted, basePayment: $basePayment, bonus: $bonus, totalHours: $totalHours, shiftCount: $shiftCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmployeeSalaryImpl &&
            (identical(other.totalPayment, totalPayment) ||
                other.totalPayment == totalPayment) &&
            (identical(other.totalPaymentFormatted, totalPaymentFormatted) ||
                other.totalPaymentFormatted == totalPaymentFormatted) &&
            (identical(other.basePayment, basePayment) ||
                other.basePayment == basePayment) &&
            (identical(other.bonus, bonus) || other.bonus == bonus) &&
            (identical(other.totalHours, totalHours) ||
                other.totalHours == totalHours) &&
            (identical(other.shiftCount, shiftCount) ||
                other.shiftCount == shiftCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, totalPayment,
      totalPaymentFormatted, basePayment, bonus, totalHours, shiftCount);

  /// Create a copy of EmployeeSalary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EmployeeSalaryImplCopyWith<_$EmployeeSalaryImpl> get copyWith =>
      __$$EmployeeSalaryImplCopyWithImpl<_$EmployeeSalaryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EmployeeSalaryImplToJson(
      this,
    );
  }
}

abstract class _EmployeeSalary implements EmployeeSalary {
  const factory _EmployeeSalary(
          {@JsonKey(name: 'total_payment') final double totalPayment,
          @JsonKey(name: 'total_payment_formatted')
          final String totalPaymentFormatted,
          @JsonKey(name: 'base_payment') final double basePayment,
          @JsonKey(name: 'bonus') final double bonus,
          @JsonKey(name: 'total_hours') final double totalHours,
          @JsonKey(name: 'shift_count') final int shiftCount}) =
      _$EmployeeSalaryImpl;

  factory _EmployeeSalary.fromJson(Map<String, dynamic> json) =
      _$EmployeeSalaryImpl.fromJson;

  @override
  @JsonKey(name: 'total_payment')
  double get totalPayment;
  @override
  @JsonKey(name: 'total_payment_formatted')
  String get totalPaymentFormatted;
  @override
  @JsonKey(name: 'base_payment')
  double get basePayment;
  @override
  @JsonKey(name: 'bonus')
  double get bonus;
  @override
  @JsonKey(name: 'total_hours')
  double get totalHours;
  @override
  @JsonKey(name: 'shift_count')
  int get shiftCount;

  /// Create a copy of EmployeeSalary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EmployeeSalaryImplCopyWith<_$EmployeeSalaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BankInfo _$BankInfoFromJson(Map<String, dynamic> json) {
  return _BankInfo.fromJson(json);
}

/// @nodoc
mixin _$BankInfo {
  @JsonKey(name: 'bank_name')
  String? get bankName => throw _privateConstructorUsedError;
  @JsonKey(name: 'account_number')
  String? get accountNumber => throw _privateConstructorUsedError;

  /// Serializes this BankInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BankInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BankInfoCopyWith<BankInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BankInfoCopyWith<$Res> {
  factory $BankInfoCopyWith(BankInfo value, $Res Function(BankInfo) then) =
      _$BankInfoCopyWithImpl<$Res, BankInfo>;
  @useResult
  $Res call(
      {@JsonKey(name: 'bank_name') String? bankName,
      @JsonKey(name: 'account_number') String? accountNumber});
}

/// @nodoc
class _$BankInfoCopyWithImpl<$Res, $Val extends BankInfo>
    implements $BankInfoCopyWith<$Res> {
  _$BankInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BankInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bankName = freezed,
    Object? accountNumber = freezed,
  }) {
    return _then(_value.copyWith(
      bankName: freezed == bankName
          ? _value.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as String?,
      accountNumber: freezed == accountNumber
          ? _value.accountNumber
          : accountNumber // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BankInfoImplCopyWith<$Res>
    implements $BankInfoCopyWith<$Res> {
  factory _$$BankInfoImplCopyWith(
          _$BankInfoImpl value, $Res Function(_$BankInfoImpl) then) =
      __$$BankInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'bank_name') String? bankName,
      @JsonKey(name: 'account_number') String? accountNumber});
}

/// @nodoc
class __$$BankInfoImplCopyWithImpl<$Res>
    extends _$BankInfoCopyWithImpl<$Res, _$BankInfoImpl>
    implements _$$BankInfoImplCopyWith<$Res> {
  __$$BankInfoImplCopyWithImpl(
      _$BankInfoImpl _value, $Res Function(_$BankInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of BankInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bankName = freezed,
    Object? accountNumber = freezed,
  }) {
    return _then(_$BankInfoImpl(
      bankName: freezed == bankName
          ? _value.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as String?,
      accountNumber: freezed == accountNumber
          ? _value.accountNumber
          : accountNumber // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BankInfoImpl implements _BankInfo {
  const _$BankInfoImpl(
      {@JsonKey(name: 'bank_name') this.bankName,
      @JsonKey(name: 'account_number') this.accountNumber});

  factory _$BankInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$BankInfoImplFromJson(json);

  @override
  @JsonKey(name: 'bank_name')
  final String? bankName;
  @override
  @JsonKey(name: 'account_number')
  final String? accountNumber;

  @override
  String toString() {
    return 'BankInfo(bankName: $bankName, accountNumber: $accountNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BankInfoImpl &&
            (identical(other.bankName, bankName) ||
                other.bankName == bankName) &&
            (identical(other.accountNumber, accountNumber) ||
                other.accountNumber == accountNumber));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, bankName, accountNumber);

  /// Create a copy of BankInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BankInfoImplCopyWith<_$BankInfoImpl> get copyWith =>
      __$$BankInfoImplCopyWithImpl<_$BankInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BankInfoImplToJson(
      this,
    );
  }
}

abstract class _BankInfo implements BankInfo {
  const factory _BankInfo(
          {@JsonKey(name: 'bank_name') final String? bankName,
          @JsonKey(name: 'account_number') final String? accountNumber}) =
      _$BankInfoImpl;

  factory _BankInfo.fromJson(Map<String, dynamic> json) =
      _$BankInfoImpl.fromJson;

  @override
  @JsonKey(name: 'bank_name')
  String? get bankName;
  @override
  @JsonKey(name: 'account_number')
  String? get accountNumber;

  /// Create a copy of BankInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BankInfoImplCopyWith<_$BankInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SalaryWarning _$SalaryWarningFromJson(Map<String, dynamic> json) {
  return _SalaryWarning.fromJson(json);
}

/// @nodoc
mixin _$SalaryWarning {
  @JsonKey(name: 'date')
  String get date => throw _privateConstructorUsedError;
  @JsonKey(name: 'message')
  String get message => throw _privateConstructorUsedError;
  @JsonKey(name: 'amount')
  double get amount => throw _privateConstructorUsedError;
  @JsonKey(name: 'amount_formatted')
  String get amountFormatted => throw _privateConstructorUsedError;
  @JsonKey(name: 'approved_by')
  String get approvedBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'self_approved')
  bool get selfApproved => throw _privateConstructorUsedError;

  /// Serializes this SalaryWarning to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SalaryWarning
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SalaryWarningCopyWith<SalaryWarning> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SalaryWarningCopyWith<$Res> {
  factory $SalaryWarningCopyWith(
          SalaryWarning value, $Res Function(SalaryWarning) then) =
      _$SalaryWarningCopyWithImpl<$Res, SalaryWarning>;
  @useResult
  $Res call(
      {@JsonKey(name: 'date') String date,
      @JsonKey(name: 'message') String message,
      @JsonKey(name: 'amount') double amount,
      @JsonKey(name: 'amount_formatted') String amountFormatted,
      @JsonKey(name: 'approved_by') String approvedBy,
      @JsonKey(name: 'self_approved') bool selfApproved});
}

/// @nodoc
class _$SalaryWarningCopyWithImpl<$Res, $Val extends SalaryWarning>
    implements $SalaryWarningCopyWith<$Res> {
  _$SalaryWarningCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SalaryWarning
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? message = null,
    Object? amount = null,
    Object? amountFormatted = null,
    Object? approvedBy = null,
    Object? selfApproved = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      amountFormatted: null == amountFormatted
          ? _value.amountFormatted
          : amountFormatted // ignore: cast_nullable_to_non_nullable
              as String,
      approvedBy: null == approvedBy
          ? _value.approvedBy
          : approvedBy // ignore: cast_nullable_to_non_nullable
              as String,
      selfApproved: null == selfApproved
          ? _value.selfApproved
          : selfApproved // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SalaryWarningImplCopyWith<$Res>
    implements $SalaryWarningCopyWith<$Res> {
  factory _$$SalaryWarningImplCopyWith(
          _$SalaryWarningImpl value, $Res Function(_$SalaryWarningImpl) then) =
      __$$SalaryWarningImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'date') String date,
      @JsonKey(name: 'message') String message,
      @JsonKey(name: 'amount') double amount,
      @JsonKey(name: 'amount_formatted') String amountFormatted,
      @JsonKey(name: 'approved_by') String approvedBy,
      @JsonKey(name: 'self_approved') bool selfApproved});
}

/// @nodoc
class __$$SalaryWarningImplCopyWithImpl<$Res>
    extends _$SalaryWarningCopyWithImpl<$Res, _$SalaryWarningImpl>
    implements _$$SalaryWarningImplCopyWith<$Res> {
  __$$SalaryWarningImplCopyWithImpl(
      _$SalaryWarningImpl _value, $Res Function(_$SalaryWarningImpl) _then)
      : super(_value, _then);

  /// Create a copy of SalaryWarning
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? message = null,
    Object? amount = null,
    Object? amountFormatted = null,
    Object? approvedBy = null,
    Object? selfApproved = null,
  }) {
    return _then(_$SalaryWarningImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      amountFormatted: null == amountFormatted
          ? _value.amountFormatted
          : amountFormatted // ignore: cast_nullable_to_non_nullable
              as String,
      approvedBy: null == approvedBy
          ? _value.approvedBy
          : approvedBy // ignore: cast_nullable_to_non_nullable
              as String,
      selfApproved: null == selfApproved
          ? _value.selfApproved
          : selfApproved // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SalaryWarningImpl implements _SalaryWarning {
  const _$SalaryWarningImpl(
      {@JsonKey(name: 'date') this.date = '',
      @JsonKey(name: 'message') this.message = '',
      @JsonKey(name: 'amount') this.amount = 0,
      @JsonKey(name: 'amount_formatted') this.amountFormatted = '',
      @JsonKey(name: 'approved_by') this.approvedBy = '',
      @JsonKey(name: 'self_approved') this.selfApproved = false});

  factory _$SalaryWarningImpl.fromJson(Map<String, dynamic> json) =>
      _$$SalaryWarningImplFromJson(json);

  @override
  @JsonKey(name: 'date')
  final String date;
  @override
  @JsonKey(name: 'message')
  final String message;
  @override
  @JsonKey(name: 'amount')
  final double amount;
  @override
  @JsonKey(name: 'amount_formatted')
  final String amountFormatted;
  @override
  @JsonKey(name: 'approved_by')
  final String approvedBy;
  @override
  @JsonKey(name: 'self_approved')
  final bool selfApproved;

  @override
  String toString() {
    return 'SalaryWarning(date: $date, message: $message, amount: $amount, amountFormatted: $amountFormatted, approvedBy: $approvedBy, selfApproved: $selfApproved)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SalaryWarningImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.amountFormatted, amountFormatted) ||
                other.amountFormatted == amountFormatted) &&
            (identical(other.approvedBy, approvedBy) ||
                other.approvedBy == approvedBy) &&
            (identical(other.selfApproved, selfApproved) ||
                other.selfApproved == selfApproved));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, date, message, amount,
      amountFormatted, approvedBy, selfApproved);

  /// Create a copy of SalaryWarning
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SalaryWarningImplCopyWith<_$SalaryWarningImpl> get copyWith =>
      __$$SalaryWarningImplCopyWithImpl<_$SalaryWarningImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SalaryWarningImplToJson(
      this,
    );
  }
}

abstract class _SalaryWarning implements SalaryWarning {
  const factory _SalaryWarning(
          {@JsonKey(name: 'date') final String date,
          @JsonKey(name: 'message') final String message,
          @JsonKey(name: 'amount') final double amount,
          @JsonKey(name: 'amount_formatted') final String amountFormatted,
          @JsonKey(name: 'approved_by') final String approvedBy,
          @JsonKey(name: 'self_approved') final bool selfApproved}) =
      _$SalaryWarningImpl;

  factory _SalaryWarning.fromJson(Map<String, dynamic> json) =
      _$SalaryWarningImpl.fromJson;

  @override
  @JsonKey(name: 'date')
  String get date;
  @override
  @JsonKey(name: 'message')
  String get message;
  @override
  @JsonKey(name: 'amount')
  double get amount;
  @override
  @JsonKey(name: 'amount_formatted')
  String get amountFormatted;
  @override
  @JsonKey(name: 'approved_by')
  String get approvedBy;
  @override
  @JsonKey(name: 'self_approved')
  bool get selfApproved;

  /// Create a copy of SalaryWarning
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SalaryWarningImplCopyWith<_$SalaryWarningImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SalaryInsights _$SalaryInsightsFromJson(Map<String, dynamic> json) {
  return _SalaryInsights.fromJson(json);
}

/// @nodoc
mixin _$SalaryInsights {
  String get summary => throw _privateConstructorUsedError;
  @JsonKey(name: 'attention_required')
  List<String> get attentionRequired => throw _privateConstructorUsedError;
  List<String> get recommendations => throw _privateConstructorUsedError;

  /// Serializes this SalaryInsights to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SalaryInsights
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SalaryInsightsCopyWith<SalaryInsights> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SalaryInsightsCopyWith<$Res> {
  factory $SalaryInsightsCopyWith(
          SalaryInsights value, $Res Function(SalaryInsights) then) =
      _$SalaryInsightsCopyWithImpl<$Res, SalaryInsights>;
  @useResult
  $Res call(
      {String summary,
      @JsonKey(name: 'attention_required') List<String> attentionRequired,
      List<String> recommendations});
}

/// @nodoc
class _$SalaryInsightsCopyWithImpl<$Res, $Val extends SalaryInsights>
    implements $SalaryInsightsCopyWith<$Res> {
  _$SalaryInsightsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SalaryInsights
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? summary = null,
    Object? attentionRequired = null,
    Object? recommendations = null,
  }) {
    return _then(_value.copyWith(
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String,
      attentionRequired: null == attentionRequired
          ? _value.attentionRequired
          : attentionRequired // ignore: cast_nullable_to_non_nullable
              as List<String>,
      recommendations: null == recommendations
          ? _value.recommendations
          : recommendations // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SalaryInsightsImplCopyWith<$Res>
    implements $SalaryInsightsCopyWith<$Res> {
  factory _$$SalaryInsightsImplCopyWith(_$SalaryInsightsImpl value,
          $Res Function(_$SalaryInsightsImpl) then) =
      __$$SalaryInsightsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String summary,
      @JsonKey(name: 'attention_required') List<String> attentionRequired,
      List<String> recommendations});
}

/// @nodoc
class __$$SalaryInsightsImplCopyWithImpl<$Res>
    extends _$SalaryInsightsCopyWithImpl<$Res, _$SalaryInsightsImpl>
    implements _$$SalaryInsightsImplCopyWith<$Res> {
  __$$SalaryInsightsImplCopyWithImpl(
      _$SalaryInsightsImpl _value, $Res Function(_$SalaryInsightsImpl) _then)
      : super(_value, _then);

  /// Create a copy of SalaryInsights
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? summary = null,
    Object? attentionRequired = null,
    Object? recommendations = null,
  }) {
    return _then(_$SalaryInsightsImpl(
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String,
      attentionRequired: null == attentionRequired
          ? _value._attentionRequired
          : attentionRequired // ignore: cast_nullable_to_non_nullable
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
class _$SalaryInsightsImpl implements _SalaryInsights {
  const _$SalaryInsightsImpl(
      {this.summary = '',
      @JsonKey(name: 'attention_required')
      final List<String> attentionRequired = const [],
      final List<String> recommendations = const []})
      : _attentionRequired = attentionRequired,
        _recommendations = recommendations;

  factory _$SalaryInsightsImpl.fromJson(Map<String, dynamic> json) =>
      _$$SalaryInsightsImplFromJson(json);

  @override
  @JsonKey()
  final String summary;
  final List<String> _attentionRequired;
  @override
  @JsonKey(name: 'attention_required')
  List<String> get attentionRequired {
    if (_attentionRequired is EqualUnmodifiableListView)
      return _attentionRequired;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_attentionRequired);
  }

  final List<String> _recommendations;
  @override
  @JsonKey()
  List<String> get recommendations {
    if (_recommendations is EqualUnmodifiableListView) return _recommendations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recommendations);
  }

  @override
  String toString() {
    return 'SalaryInsights(summary: $summary, attentionRequired: $attentionRequired, recommendations: $recommendations)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SalaryInsightsImpl &&
            (identical(other.summary, summary) || other.summary == summary) &&
            const DeepCollectionEquality()
                .equals(other._attentionRequired, _attentionRequired) &&
            const DeepCollectionEquality()
                .equals(other._recommendations, _recommendations));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      summary,
      const DeepCollectionEquality().hash(_attentionRequired),
      const DeepCollectionEquality().hash(_recommendations));

  /// Create a copy of SalaryInsights
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SalaryInsightsImplCopyWith<_$SalaryInsightsImpl> get copyWith =>
      __$$SalaryInsightsImplCopyWithImpl<_$SalaryInsightsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SalaryInsightsImplToJson(
      this,
    );
  }
}

abstract class _SalaryInsights implements SalaryInsights {
  const factory _SalaryInsights(
      {final String summary,
      @JsonKey(name: 'attention_required') final List<String> attentionRequired,
      final List<String> recommendations}) = _$SalaryInsightsImpl;

  factory _SalaryInsights.fromJson(Map<String, dynamic> json) =
      _$SalaryInsightsImpl.fromJson;

  @override
  String get summary;
  @override
  @JsonKey(name: 'attention_required')
  List<String> get attentionRequired;
  @override
  List<String> get recommendations;

  /// Create a copy of SalaryInsights
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SalaryInsightsImplCopyWith<_$SalaryInsightsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ManagerQuality _$ManagerQualityFromJson(Map<String, dynamic> json) {
  return _ManagerQuality.fromJson(json);
}

/// @nodoc
mixin _$ManagerQuality {
  @JsonKey(name: 'total_managers')
  int get totalManagers => throw _privateConstructorUsedError;
  @JsonKey(name: 'managers_with_issues')
  int get managersWithIssues => throw _privateConstructorUsedError;
  @JsonKey(name: 'self_approval_count')
  int get selfApprovalCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'quality_score')
  double get qualityScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'quality_status')
  String get qualityStatus =>
      throw _privateConstructorUsedError; // good, warning, critical
  @JsonKey(name: 'quality_message')
  String get qualityMessage => throw _privateConstructorUsedError;

  /// Serializes this ManagerQuality to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ManagerQuality
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ManagerQualityCopyWith<ManagerQuality> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ManagerQualityCopyWith<$Res> {
  factory $ManagerQualityCopyWith(
          ManagerQuality value, $Res Function(ManagerQuality) then) =
      _$ManagerQualityCopyWithImpl<$Res, ManagerQuality>;
  @useResult
  $Res call(
      {@JsonKey(name: 'total_managers') int totalManagers,
      @JsonKey(name: 'managers_with_issues') int managersWithIssues,
      @JsonKey(name: 'self_approval_count') int selfApprovalCount,
      @JsonKey(name: 'quality_score') double qualityScore,
      @JsonKey(name: 'quality_status') String qualityStatus,
      @JsonKey(name: 'quality_message') String qualityMessage});
}

/// @nodoc
class _$ManagerQualityCopyWithImpl<$Res, $Val extends ManagerQuality>
    implements $ManagerQualityCopyWith<$Res> {
  _$ManagerQualityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ManagerQuality
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalManagers = null,
    Object? managersWithIssues = null,
    Object? selfApprovalCount = null,
    Object? qualityScore = null,
    Object? qualityStatus = null,
    Object? qualityMessage = null,
  }) {
    return _then(_value.copyWith(
      totalManagers: null == totalManagers
          ? _value.totalManagers
          : totalManagers // ignore: cast_nullable_to_non_nullable
              as int,
      managersWithIssues: null == managersWithIssues
          ? _value.managersWithIssues
          : managersWithIssues // ignore: cast_nullable_to_non_nullable
              as int,
      selfApprovalCount: null == selfApprovalCount
          ? _value.selfApprovalCount
          : selfApprovalCount // ignore: cast_nullable_to_non_nullable
              as int,
      qualityScore: null == qualityScore
          ? _value.qualityScore
          : qualityScore // ignore: cast_nullable_to_non_nullable
              as double,
      qualityStatus: null == qualityStatus
          ? _value.qualityStatus
          : qualityStatus // ignore: cast_nullable_to_non_nullable
              as String,
      qualityMessage: null == qualityMessage
          ? _value.qualityMessage
          : qualityMessage // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ManagerQualityImplCopyWith<$Res>
    implements $ManagerQualityCopyWith<$Res> {
  factory _$$ManagerQualityImplCopyWith(_$ManagerQualityImpl value,
          $Res Function(_$ManagerQualityImpl) then) =
      __$$ManagerQualityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'total_managers') int totalManagers,
      @JsonKey(name: 'managers_with_issues') int managersWithIssues,
      @JsonKey(name: 'self_approval_count') int selfApprovalCount,
      @JsonKey(name: 'quality_score') double qualityScore,
      @JsonKey(name: 'quality_status') String qualityStatus,
      @JsonKey(name: 'quality_message') String qualityMessage});
}

/// @nodoc
class __$$ManagerQualityImplCopyWithImpl<$Res>
    extends _$ManagerQualityCopyWithImpl<$Res, _$ManagerQualityImpl>
    implements _$$ManagerQualityImplCopyWith<$Res> {
  __$$ManagerQualityImplCopyWithImpl(
      _$ManagerQualityImpl _value, $Res Function(_$ManagerQualityImpl) _then)
      : super(_value, _then);

  /// Create a copy of ManagerQuality
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalManagers = null,
    Object? managersWithIssues = null,
    Object? selfApprovalCount = null,
    Object? qualityScore = null,
    Object? qualityStatus = null,
    Object? qualityMessage = null,
  }) {
    return _then(_$ManagerQualityImpl(
      totalManagers: null == totalManagers
          ? _value.totalManagers
          : totalManagers // ignore: cast_nullable_to_non_nullable
              as int,
      managersWithIssues: null == managersWithIssues
          ? _value.managersWithIssues
          : managersWithIssues // ignore: cast_nullable_to_non_nullable
              as int,
      selfApprovalCount: null == selfApprovalCount
          ? _value.selfApprovalCount
          : selfApprovalCount // ignore: cast_nullable_to_non_nullable
              as int,
      qualityScore: null == qualityScore
          ? _value.qualityScore
          : qualityScore // ignore: cast_nullable_to_non_nullable
              as double,
      qualityStatus: null == qualityStatus
          ? _value.qualityStatus
          : qualityStatus // ignore: cast_nullable_to_non_nullable
              as String,
      qualityMessage: null == qualityMessage
          ? _value.qualityMessage
          : qualityMessage // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ManagerQualityImpl implements _ManagerQuality {
  const _$ManagerQualityImpl(
      {@JsonKey(name: 'total_managers') this.totalManagers = 0,
      @JsonKey(name: 'managers_with_issues') this.managersWithIssues = 0,
      @JsonKey(name: 'self_approval_count') this.selfApprovalCount = 0,
      @JsonKey(name: 'quality_score') this.qualityScore = 0,
      @JsonKey(name: 'quality_status') this.qualityStatus = 'good',
      @JsonKey(name: 'quality_message') this.qualityMessage = ''});

  factory _$ManagerQualityImpl.fromJson(Map<String, dynamic> json) =>
      _$$ManagerQualityImplFromJson(json);

  @override
  @JsonKey(name: 'total_managers')
  final int totalManagers;
  @override
  @JsonKey(name: 'managers_with_issues')
  final int managersWithIssues;
  @override
  @JsonKey(name: 'self_approval_count')
  final int selfApprovalCount;
  @override
  @JsonKey(name: 'quality_score')
  final double qualityScore;
  @override
  @JsonKey(name: 'quality_status')
  final String qualityStatus;
// good, warning, critical
  @override
  @JsonKey(name: 'quality_message')
  final String qualityMessage;

  @override
  String toString() {
    return 'ManagerQuality(totalManagers: $totalManagers, managersWithIssues: $managersWithIssues, selfApprovalCount: $selfApprovalCount, qualityScore: $qualityScore, qualityStatus: $qualityStatus, qualityMessage: $qualityMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ManagerQualityImpl &&
            (identical(other.totalManagers, totalManagers) ||
                other.totalManagers == totalManagers) &&
            (identical(other.managersWithIssues, managersWithIssues) ||
                other.managersWithIssues == managersWithIssues) &&
            (identical(other.selfApprovalCount, selfApprovalCount) ||
                other.selfApprovalCount == selfApprovalCount) &&
            (identical(other.qualityScore, qualityScore) ||
                other.qualityScore == qualityScore) &&
            (identical(other.qualityStatus, qualityStatus) ||
                other.qualityStatus == qualityStatus) &&
            (identical(other.qualityMessage, qualityMessage) ||
                other.qualityMessage == qualityMessage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalManagers,
      managersWithIssues,
      selfApprovalCount,
      qualityScore,
      qualityStatus,
      qualityMessage);

  /// Create a copy of ManagerQuality
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ManagerQualityImplCopyWith<_$ManagerQualityImpl> get copyWith =>
      __$$ManagerQualityImplCopyWithImpl<_$ManagerQualityImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ManagerQualityImplToJson(
      this,
    );
  }
}

abstract class _ManagerQuality implements ManagerQuality {
  const factory _ManagerQuality(
          {@JsonKey(name: 'total_managers') final int totalManagers,
          @JsonKey(name: 'managers_with_issues') final int managersWithIssues,
          @JsonKey(name: 'self_approval_count') final int selfApprovalCount,
          @JsonKey(name: 'quality_score') final double qualityScore,
          @JsonKey(name: 'quality_status') final String qualityStatus,
          @JsonKey(name: 'quality_message') final String qualityMessage}) =
      _$ManagerQualityImpl;

  factory _ManagerQuality.fromJson(Map<String, dynamic> json) =
      _$ManagerQualityImpl.fromJson;

  @override
  @JsonKey(name: 'total_managers')
  int get totalManagers;
  @override
  @JsonKey(name: 'managers_with_issues')
  int get managersWithIssues;
  @override
  @JsonKey(name: 'self_approval_count')
  int get selfApprovalCount;
  @override
  @JsonKey(name: 'quality_score')
  double get qualityScore;
  @override
  @JsonKey(name: 'quality_status')
  String get qualityStatus; // good, warning, critical
  @override
  @JsonKey(name: 'quality_message')
  String get qualityMessage;

  /// Create a copy of ManagerQuality
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ManagerQualityImplCopyWith<_$ManagerQualityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SalaryNotice _$SalaryNoticeFromJson(Map<String, dynamic> json) {
  return _SalaryNotice.fromJson(json);
}

/// @nodoc
mixin _$SalaryNotice {
  @JsonKey(name: 'type')
  String get type =>
      throw _privateConstructorUsedError; // info, warning, critical
  @JsonKey(name: 'title')
  String get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'message')
  String get message => throw _privateConstructorUsedError;
  @JsonKey(name: 'employee_name')
  String? get employeeName => throw _privateConstructorUsedError;
  @JsonKey(name: 'amount')
  double? get amount => throw _privateConstructorUsedError;
  @JsonKey(name: 'amount_formatted')
  String? get amountFormatted => throw _privateConstructorUsedError;

  /// Serializes this SalaryNotice to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SalaryNotice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SalaryNoticeCopyWith<SalaryNotice> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SalaryNoticeCopyWith<$Res> {
  factory $SalaryNoticeCopyWith(
          SalaryNotice value, $Res Function(SalaryNotice) then) =
      _$SalaryNoticeCopyWithImpl<$Res, SalaryNotice>;
  @useResult
  $Res call(
      {@JsonKey(name: 'type') String type,
      @JsonKey(name: 'title') String title,
      @JsonKey(name: 'message') String message,
      @JsonKey(name: 'employee_name') String? employeeName,
      @JsonKey(name: 'amount') double? amount,
      @JsonKey(name: 'amount_formatted') String? amountFormatted});
}

/// @nodoc
class _$SalaryNoticeCopyWithImpl<$Res, $Val extends SalaryNotice>
    implements $SalaryNoticeCopyWith<$Res> {
  _$SalaryNoticeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SalaryNotice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? title = null,
    Object? message = null,
    Object? employeeName = freezed,
    Object? amount = freezed,
    Object? amountFormatted = freezed,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      employeeName: freezed == employeeName
          ? _value.employeeName
          : employeeName // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double?,
      amountFormatted: freezed == amountFormatted
          ? _value.amountFormatted
          : amountFormatted // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SalaryNoticeImplCopyWith<$Res>
    implements $SalaryNoticeCopyWith<$Res> {
  factory _$$SalaryNoticeImplCopyWith(
          _$SalaryNoticeImpl value, $Res Function(_$SalaryNoticeImpl) then) =
      __$$SalaryNoticeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'type') String type,
      @JsonKey(name: 'title') String title,
      @JsonKey(name: 'message') String message,
      @JsonKey(name: 'employee_name') String? employeeName,
      @JsonKey(name: 'amount') double? amount,
      @JsonKey(name: 'amount_formatted') String? amountFormatted});
}

/// @nodoc
class __$$SalaryNoticeImplCopyWithImpl<$Res>
    extends _$SalaryNoticeCopyWithImpl<$Res, _$SalaryNoticeImpl>
    implements _$$SalaryNoticeImplCopyWith<$Res> {
  __$$SalaryNoticeImplCopyWithImpl(
      _$SalaryNoticeImpl _value, $Res Function(_$SalaryNoticeImpl) _then)
      : super(_value, _then);

  /// Create a copy of SalaryNotice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? title = null,
    Object? message = null,
    Object? employeeName = freezed,
    Object? amount = freezed,
    Object? amountFormatted = freezed,
  }) {
    return _then(_$SalaryNoticeImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      employeeName: freezed == employeeName
          ? _value.employeeName
          : employeeName // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double?,
      amountFormatted: freezed == amountFormatted
          ? _value.amountFormatted
          : amountFormatted // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SalaryNoticeImpl implements _SalaryNotice {
  const _$SalaryNoticeImpl(
      {@JsonKey(name: 'type') this.type = 'info',
      @JsonKey(name: 'title') this.title = '',
      @JsonKey(name: 'message') this.message = '',
      @JsonKey(name: 'employee_name') this.employeeName,
      @JsonKey(name: 'amount') this.amount,
      @JsonKey(name: 'amount_formatted') this.amountFormatted});

  factory _$SalaryNoticeImpl.fromJson(Map<String, dynamic> json) =>
      _$$SalaryNoticeImplFromJson(json);

  @override
  @JsonKey(name: 'type')
  final String type;
// info, warning, critical
  @override
  @JsonKey(name: 'title')
  final String title;
  @override
  @JsonKey(name: 'message')
  final String message;
  @override
  @JsonKey(name: 'employee_name')
  final String? employeeName;
  @override
  @JsonKey(name: 'amount')
  final double? amount;
  @override
  @JsonKey(name: 'amount_formatted')
  final String? amountFormatted;

  @override
  String toString() {
    return 'SalaryNotice(type: $type, title: $title, message: $message, employeeName: $employeeName, amount: $amount, amountFormatted: $amountFormatted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SalaryNoticeImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.employeeName, employeeName) ||
                other.employeeName == employeeName) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.amountFormatted, amountFormatted) ||
                other.amountFormatted == amountFormatted));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, type, title, message, employeeName, amount, amountFormatted);

  /// Create a copy of SalaryNotice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SalaryNoticeImplCopyWith<_$SalaryNoticeImpl> get copyWith =>
      __$$SalaryNoticeImplCopyWithImpl<_$SalaryNoticeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SalaryNoticeImplToJson(
      this,
    );
  }
}

abstract class _SalaryNotice implements SalaryNotice {
  const factory _SalaryNotice(
          {@JsonKey(name: 'type') final String type,
          @JsonKey(name: 'title') final String title,
          @JsonKey(name: 'message') final String message,
          @JsonKey(name: 'employee_name') final String? employeeName,
          @JsonKey(name: 'amount') final double? amount,
          @JsonKey(name: 'amount_formatted') final String? amountFormatted}) =
      _$SalaryNoticeImpl;

  factory _SalaryNotice.fromJson(Map<String, dynamic> json) =
      _$SalaryNoticeImpl.fromJson;

  @override
  @JsonKey(name: 'type')
  String get type; // info, warning, critical
  @override
  @JsonKey(name: 'title')
  String get title;
  @override
  @JsonKey(name: 'message')
  String get message;
  @override
  @JsonKey(name: 'employee_name')
  String? get employeeName;
  @override
  @JsonKey(name: 'amount')
  double? get amount;
  @override
  @JsonKey(name: 'amount_formatted')
  String? get amountFormatted;

  /// Create a copy of SalaryNotice
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SalaryNoticeImplCopyWith<_$SalaryNoticeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
