// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'problem_details.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProblemDetails _$ProblemDetailsFromJson(Map<String, dynamic> json) {
  return _ProblemDetails.fromJson(json);
}

/// @nodoc
mixin _$ProblemDetails {
// 빠른 필터링용 플래그
  @JsonKey(name: 'has_late')
  bool get hasLate => throw _privateConstructorUsedError;
  @JsonKey(name: 'has_absence')
  bool get hasAbsence => throw _privateConstructorUsedError;
  @JsonKey(name: 'has_overtime')
  bool get hasOvertime => throw _privateConstructorUsedError;
  @JsonKey(name: 'has_early_leave')
  bool get hasEarlyLeave => throw _privateConstructorUsedError;
  @JsonKey(name: 'has_no_checkout')
  bool get hasNoCheckout => throw _privateConstructorUsedError;
  @JsonKey(name: 'has_location_issue')
  bool get hasLocationIssue => throw _privateConstructorUsedError;
  @JsonKey(name: 'has_reported')
  bool get hasReported => throw _privateConstructorUsedError; // 상태
  @JsonKey(name: 'is_solved')
  bool get isSolved => throw _privateConstructorUsedError;
  @JsonKey(name: 'problem_count')
  int get problemCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'detected_at')
  String? get detectedAt => throw _privateConstructorUsedError; // 상세 문제 목록
  List<Problem> get problems => throw _privateConstructorUsedError;

  /// Serializes this ProblemDetails to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProblemDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProblemDetailsCopyWith<ProblemDetails> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProblemDetailsCopyWith<$Res> {
  factory $ProblemDetailsCopyWith(
          ProblemDetails value, $Res Function(ProblemDetails) then) =
      _$ProblemDetailsCopyWithImpl<$Res, ProblemDetails>;
  @useResult
  $Res call(
      {@JsonKey(name: 'has_late') bool hasLate,
      @JsonKey(name: 'has_absence') bool hasAbsence,
      @JsonKey(name: 'has_overtime') bool hasOvertime,
      @JsonKey(name: 'has_early_leave') bool hasEarlyLeave,
      @JsonKey(name: 'has_no_checkout') bool hasNoCheckout,
      @JsonKey(name: 'has_location_issue') bool hasLocationIssue,
      @JsonKey(name: 'has_reported') bool hasReported,
      @JsonKey(name: 'is_solved') bool isSolved,
      @JsonKey(name: 'problem_count') int problemCount,
      @JsonKey(name: 'detected_at') String? detectedAt,
      List<Problem> problems});
}

/// @nodoc
class _$ProblemDetailsCopyWithImpl<$Res, $Val extends ProblemDetails>
    implements $ProblemDetailsCopyWith<$Res> {
  _$ProblemDetailsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProblemDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hasLate = null,
    Object? hasAbsence = null,
    Object? hasOvertime = null,
    Object? hasEarlyLeave = null,
    Object? hasNoCheckout = null,
    Object? hasLocationIssue = null,
    Object? hasReported = null,
    Object? isSolved = null,
    Object? problemCount = null,
    Object? detectedAt = freezed,
    Object? problems = null,
  }) {
    return _then(_value.copyWith(
      hasLate: null == hasLate
          ? _value.hasLate
          : hasLate // ignore: cast_nullable_to_non_nullable
              as bool,
      hasAbsence: null == hasAbsence
          ? _value.hasAbsence
          : hasAbsence // ignore: cast_nullable_to_non_nullable
              as bool,
      hasOvertime: null == hasOvertime
          ? _value.hasOvertime
          : hasOvertime // ignore: cast_nullable_to_non_nullable
              as bool,
      hasEarlyLeave: null == hasEarlyLeave
          ? _value.hasEarlyLeave
          : hasEarlyLeave // ignore: cast_nullable_to_non_nullable
              as bool,
      hasNoCheckout: null == hasNoCheckout
          ? _value.hasNoCheckout
          : hasNoCheckout // ignore: cast_nullable_to_non_nullable
              as bool,
      hasLocationIssue: null == hasLocationIssue
          ? _value.hasLocationIssue
          : hasLocationIssue // ignore: cast_nullable_to_non_nullable
              as bool,
      hasReported: null == hasReported
          ? _value.hasReported
          : hasReported // ignore: cast_nullable_to_non_nullable
              as bool,
      isSolved: null == isSolved
          ? _value.isSolved
          : isSolved // ignore: cast_nullable_to_non_nullable
              as bool,
      problemCount: null == problemCount
          ? _value.problemCount
          : problemCount // ignore: cast_nullable_to_non_nullable
              as int,
      detectedAt: freezed == detectedAt
          ? _value.detectedAt
          : detectedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      problems: null == problems
          ? _value.problems
          : problems // ignore: cast_nullable_to_non_nullable
              as List<Problem>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProblemDetailsImplCopyWith<$Res>
    implements $ProblemDetailsCopyWith<$Res> {
  factory _$$ProblemDetailsImplCopyWith(_$ProblemDetailsImpl value,
          $Res Function(_$ProblemDetailsImpl) then) =
      __$$ProblemDetailsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'has_late') bool hasLate,
      @JsonKey(name: 'has_absence') bool hasAbsence,
      @JsonKey(name: 'has_overtime') bool hasOvertime,
      @JsonKey(name: 'has_early_leave') bool hasEarlyLeave,
      @JsonKey(name: 'has_no_checkout') bool hasNoCheckout,
      @JsonKey(name: 'has_location_issue') bool hasLocationIssue,
      @JsonKey(name: 'has_reported') bool hasReported,
      @JsonKey(name: 'is_solved') bool isSolved,
      @JsonKey(name: 'problem_count') int problemCount,
      @JsonKey(name: 'detected_at') String? detectedAt,
      List<Problem> problems});
}

/// @nodoc
class __$$ProblemDetailsImplCopyWithImpl<$Res>
    extends _$ProblemDetailsCopyWithImpl<$Res, _$ProblemDetailsImpl>
    implements _$$ProblemDetailsImplCopyWith<$Res> {
  __$$ProblemDetailsImplCopyWithImpl(
      _$ProblemDetailsImpl _value, $Res Function(_$ProblemDetailsImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProblemDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hasLate = null,
    Object? hasAbsence = null,
    Object? hasOvertime = null,
    Object? hasEarlyLeave = null,
    Object? hasNoCheckout = null,
    Object? hasLocationIssue = null,
    Object? hasReported = null,
    Object? isSolved = null,
    Object? problemCount = null,
    Object? detectedAt = freezed,
    Object? problems = null,
  }) {
    return _then(_$ProblemDetailsImpl(
      hasLate: null == hasLate
          ? _value.hasLate
          : hasLate // ignore: cast_nullable_to_non_nullable
              as bool,
      hasAbsence: null == hasAbsence
          ? _value.hasAbsence
          : hasAbsence // ignore: cast_nullable_to_non_nullable
              as bool,
      hasOvertime: null == hasOvertime
          ? _value.hasOvertime
          : hasOvertime // ignore: cast_nullable_to_non_nullable
              as bool,
      hasEarlyLeave: null == hasEarlyLeave
          ? _value.hasEarlyLeave
          : hasEarlyLeave // ignore: cast_nullable_to_non_nullable
              as bool,
      hasNoCheckout: null == hasNoCheckout
          ? _value.hasNoCheckout
          : hasNoCheckout // ignore: cast_nullable_to_non_nullable
              as bool,
      hasLocationIssue: null == hasLocationIssue
          ? _value.hasLocationIssue
          : hasLocationIssue // ignore: cast_nullable_to_non_nullable
              as bool,
      hasReported: null == hasReported
          ? _value.hasReported
          : hasReported // ignore: cast_nullable_to_non_nullable
              as bool,
      isSolved: null == isSolved
          ? _value.isSolved
          : isSolved // ignore: cast_nullable_to_non_nullable
              as bool,
      problemCount: null == problemCount
          ? _value.problemCount
          : problemCount // ignore: cast_nullable_to_non_nullable
              as int,
      detectedAt: freezed == detectedAt
          ? _value.detectedAt
          : detectedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      problems: null == problems
          ? _value._problems
          : problems // ignore: cast_nullable_to_non_nullable
              as List<Problem>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProblemDetailsImpl extends _ProblemDetails {
  const _$ProblemDetailsImpl(
      {@JsonKey(name: 'has_late') this.hasLate = false,
      @JsonKey(name: 'has_absence') this.hasAbsence = false,
      @JsonKey(name: 'has_overtime') this.hasOvertime = false,
      @JsonKey(name: 'has_early_leave') this.hasEarlyLeave = false,
      @JsonKey(name: 'has_no_checkout') this.hasNoCheckout = false,
      @JsonKey(name: 'has_location_issue') this.hasLocationIssue = false,
      @JsonKey(name: 'has_reported') this.hasReported = false,
      @JsonKey(name: 'is_solved') this.isSolved = false,
      @JsonKey(name: 'problem_count') this.problemCount = 0,
      @JsonKey(name: 'detected_at') this.detectedAt,
      final List<Problem> problems = const []})
      : _problems = problems,
        super._();

  factory _$ProblemDetailsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProblemDetailsImplFromJson(json);

// 빠른 필터링용 플래그
  @override
  @JsonKey(name: 'has_late')
  final bool hasLate;
  @override
  @JsonKey(name: 'has_absence')
  final bool hasAbsence;
  @override
  @JsonKey(name: 'has_overtime')
  final bool hasOvertime;
  @override
  @JsonKey(name: 'has_early_leave')
  final bool hasEarlyLeave;
  @override
  @JsonKey(name: 'has_no_checkout')
  final bool hasNoCheckout;
  @override
  @JsonKey(name: 'has_location_issue')
  final bool hasLocationIssue;
  @override
  @JsonKey(name: 'has_reported')
  final bool hasReported;
// 상태
  @override
  @JsonKey(name: 'is_solved')
  final bool isSolved;
  @override
  @JsonKey(name: 'problem_count')
  final int problemCount;
  @override
  @JsonKey(name: 'detected_at')
  final String? detectedAt;
// 상세 문제 목록
  final List<Problem> _problems;
// 상세 문제 목록
  @override
  @JsonKey()
  List<Problem> get problems {
    if (_problems is EqualUnmodifiableListView) return _problems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_problems);
  }

  @override
  String toString() {
    return 'ProblemDetails(hasLate: $hasLate, hasAbsence: $hasAbsence, hasOvertime: $hasOvertime, hasEarlyLeave: $hasEarlyLeave, hasNoCheckout: $hasNoCheckout, hasLocationIssue: $hasLocationIssue, hasReported: $hasReported, isSolved: $isSolved, problemCount: $problemCount, detectedAt: $detectedAt, problems: $problems)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProblemDetailsImpl &&
            (identical(other.hasLate, hasLate) || other.hasLate == hasLate) &&
            (identical(other.hasAbsence, hasAbsence) ||
                other.hasAbsence == hasAbsence) &&
            (identical(other.hasOvertime, hasOvertime) ||
                other.hasOvertime == hasOvertime) &&
            (identical(other.hasEarlyLeave, hasEarlyLeave) ||
                other.hasEarlyLeave == hasEarlyLeave) &&
            (identical(other.hasNoCheckout, hasNoCheckout) ||
                other.hasNoCheckout == hasNoCheckout) &&
            (identical(other.hasLocationIssue, hasLocationIssue) ||
                other.hasLocationIssue == hasLocationIssue) &&
            (identical(other.hasReported, hasReported) ||
                other.hasReported == hasReported) &&
            (identical(other.isSolved, isSolved) ||
                other.isSolved == isSolved) &&
            (identical(other.problemCount, problemCount) ||
                other.problemCount == problemCount) &&
            (identical(other.detectedAt, detectedAt) ||
                other.detectedAt == detectedAt) &&
            const DeepCollectionEquality().equals(other._problems, _problems));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      hasLate,
      hasAbsence,
      hasOvertime,
      hasEarlyLeave,
      hasNoCheckout,
      hasLocationIssue,
      hasReported,
      isSolved,
      problemCount,
      detectedAt,
      const DeepCollectionEquality().hash(_problems));

  /// Create a copy of ProblemDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProblemDetailsImplCopyWith<_$ProblemDetailsImpl> get copyWith =>
      __$$ProblemDetailsImplCopyWithImpl<_$ProblemDetailsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProblemDetailsImplToJson(
      this,
    );
  }
}

abstract class _ProblemDetails extends ProblemDetails {
  const factory _ProblemDetails(
      {@JsonKey(name: 'has_late') final bool hasLate,
      @JsonKey(name: 'has_absence') final bool hasAbsence,
      @JsonKey(name: 'has_overtime') final bool hasOvertime,
      @JsonKey(name: 'has_early_leave') final bool hasEarlyLeave,
      @JsonKey(name: 'has_no_checkout') final bool hasNoCheckout,
      @JsonKey(name: 'has_location_issue') final bool hasLocationIssue,
      @JsonKey(name: 'has_reported') final bool hasReported,
      @JsonKey(name: 'is_solved') final bool isSolved,
      @JsonKey(name: 'problem_count') final int problemCount,
      @JsonKey(name: 'detected_at') final String? detectedAt,
      final List<Problem> problems}) = _$ProblemDetailsImpl;
  const _ProblemDetails._() : super._();

  factory _ProblemDetails.fromJson(Map<String, dynamic> json) =
      _$ProblemDetailsImpl.fromJson;

// 빠른 필터링용 플래그
  @override
  @JsonKey(name: 'has_late')
  bool get hasLate;
  @override
  @JsonKey(name: 'has_absence')
  bool get hasAbsence;
  @override
  @JsonKey(name: 'has_overtime')
  bool get hasOvertime;
  @override
  @JsonKey(name: 'has_early_leave')
  bool get hasEarlyLeave;
  @override
  @JsonKey(name: 'has_no_checkout')
  bool get hasNoCheckout;
  @override
  @JsonKey(name: 'has_location_issue')
  bool get hasLocationIssue;
  @override
  @JsonKey(name: 'has_reported')
  bool get hasReported; // 상태
  @override
  @JsonKey(name: 'is_solved')
  bool get isSolved;
  @override
  @JsonKey(name: 'problem_count')
  int get problemCount;
  @override
  @JsonKey(name: 'detected_at')
  String? get detectedAt; // 상세 문제 목록
  @override
  List<Problem> get problems;

  /// Create a copy of ProblemDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProblemDetailsImplCopyWith<_$ProblemDetailsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Problem _$ProblemFromJson(Map<String, dynamic> json) {
  switch (json['type']) {
    case 'late':
      return LateProblem.fromJson(json);
    case 'overtime':
      return OvertimeProblem.fromJson(json);
    case 'early_leave':
      return EarlyLeaveProblem.fromJson(json);
    case 'absence':
      return AbsenceProblem.fromJson(json);
    case 'no_checkout':
      return NoCheckoutProblem.fromJson(json);
    case 'invalid_checkin':
      return InvalidCheckinProblem.fromJson(json);
    case 'invalid_checkout':
      return InvalidCheckoutProblem.fromJson(json);
    case 'reported':
      return ReportedProblem.fromJson(json);

    default:
      throw CheckedFromJsonException(
          json, 'type', 'Problem', 'Invalid union type "${json['type']}"!');
  }
}

/// @nodoc
mixin _$Problem {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)
        late,
    required TResult Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)
        overtime,
    required TResult Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)
        earlyLeave,
    required TResult Function() absence,
    required TResult Function() noCheckout,
    required TResult Function(int distance) invalidCheckin,
    required TResult Function(int distance) invalidCheckout,
    required TResult Function(
            String reason,
            @JsonKey(name: 'reported_at') String? reportedAt,
            @JsonKey(name: 'is_report_solved') bool isReportSolved)
        reported,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)?
        late,
    TResult? Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)?
        overtime,
    TResult? Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)?
        earlyLeave,
    TResult? Function()? absence,
    TResult? Function()? noCheckout,
    TResult? Function(int distance)? invalidCheckin,
    TResult? Function(int distance)? invalidCheckout,
    TResult? Function(
            String reason,
            @JsonKey(name: 'reported_at') String? reportedAt,
            @JsonKey(name: 'is_report_solved') bool isReportSolved)?
        reported,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)?
        late,
    TResult Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)?
        overtime,
    TResult Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)?
        earlyLeave,
    TResult Function()? absence,
    TResult Function()? noCheckout,
    TResult Function(int distance)? invalidCheckin,
    TResult Function(int distance)? invalidCheckout,
    TResult Function(
            String reason,
            @JsonKey(name: 'reported_at') String? reportedAt,
            @JsonKey(name: 'is_report_solved') bool isReportSolved)?
        reported,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LateProblem value) late,
    required TResult Function(OvertimeProblem value) overtime,
    required TResult Function(EarlyLeaveProblem value) earlyLeave,
    required TResult Function(AbsenceProblem value) absence,
    required TResult Function(NoCheckoutProblem value) noCheckout,
    required TResult Function(InvalidCheckinProblem value) invalidCheckin,
    required TResult Function(InvalidCheckoutProblem value) invalidCheckout,
    required TResult Function(ReportedProblem value) reported,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LateProblem value)? late,
    TResult? Function(OvertimeProblem value)? overtime,
    TResult? Function(EarlyLeaveProblem value)? earlyLeave,
    TResult? Function(AbsenceProblem value)? absence,
    TResult? Function(NoCheckoutProblem value)? noCheckout,
    TResult? Function(InvalidCheckinProblem value)? invalidCheckin,
    TResult? Function(InvalidCheckoutProblem value)? invalidCheckout,
    TResult? Function(ReportedProblem value)? reported,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LateProblem value)? late,
    TResult Function(OvertimeProblem value)? overtime,
    TResult Function(EarlyLeaveProblem value)? earlyLeave,
    TResult Function(AbsenceProblem value)? absence,
    TResult Function(NoCheckoutProblem value)? noCheckout,
    TResult Function(InvalidCheckinProblem value)? invalidCheckin,
    TResult Function(InvalidCheckoutProblem value)? invalidCheckout,
    TResult Function(ReportedProblem value)? reported,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this Problem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProblemCopyWith<$Res> {
  factory $ProblemCopyWith(Problem value, $Res Function(Problem) then) =
      _$ProblemCopyWithImpl<$Res, Problem>;
}

/// @nodoc
class _$ProblemCopyWithImpl<$Res, $Val extends Problem>
    implements $ProblemCopyWith<$Res> {
  _$ProblemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Problem
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$LateProblemImplCopyWith<$Res> {
  factory _$$LateProblemImplCopyWith(
          _$LateProblemImpl value, $Res Function(_$LateProblemImpl) then) =
      __$$LateProblemImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {@JsonKey(name: 'actual_minutes') int actualMinutes,
      @JsonKey(name: 'payroll_minutes') int payrollMinutes,
      @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted});
}

/// @nodoc
class __$$LateProblemImplCopyWithImpl<$Res>
    extends _$ProblemCopyWithImpl<$Res, _$LateProblemImpl>
    implements _$$LateProblemImplCopyWith<$Res> {
  __$$LateProblemImplCopyWithImpl(
      _$LateProblemImpl _value, $Res Function(_$LateProblemImpl) _then)
      : super(_value, _then);

  /// Create a copy of Problem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? actualMinutes = null,
    Object? payrollMinutes = null,
    Object? isPayrollAdjusted = null,
  }) {
    return _then(_$LateProblemImpl(
      actualMinutes: null == actualMinutes
          ? _value.actualMinutes
          : actualMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      payrollMinutes: null == payrollMinutes
          ? _value.payrollMinutes
          : payrollMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      isPayrollAdjusted: null == isPayrollAdjusted
          ? _value.isPayrollAdjusted
          : isPayrollAdjusted // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LateProblemImpl extends LateProblem {
  const _$LateProblemImpl(
      {@JsonKey(name: 'actual_minutes') this.actualMinutes = 0,
      @JsonKey(name: 'payroll_minutes') this.payrollMinutes = 0,
      @JsonKey(name: 'is_payroll_adjusted') this.isPayrollAdjusted = false,
      final String? $type})
      : $type = $type ?? 'late',
        super._();

  factory _$LateProblemImpl.fromJson(Map<String, dynamic> json) =>
      _$$LateProblemImplFromJson(json);

  @override
  @JsonKey(name: 'actual_minutes')
  final int actualMinutes;
  @override
  @JsonKey(name: 'payroll_minutes')
  final int payrollMinutes;
  @override
  @JsonKey(name: 'is_payroll_adjusted')
  final bool isPayrollAdjusted;

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'Problem.late(actualMinutes: $actualMinutes, payrollMinutes: $payrollMinutes, isPayrollAdjusted: $isPayrollAdjusted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LateProblemImpl &&
            (identical(other.actualMinutes, actualMinutes) ||
                other.actualMinutes == actualMinutes) &&
            (identical(other.payrollMinutes, payrollMinutes) ||
                other.payrollMinutes == payrollMinutes) &&
            (identical(other.isPayrollAdjusted, isPayrollAdjusted) ||
                other.isPayrollAdjusted == isPayrollAdjusted));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, actualMinutes, payrollMinutes, isPayrollAdjusted);

  /// Create a copy of Problem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LateProblemImplCopyWith<_$LateProblemImpl> get copyWith =>
      __$$LateProblemImplCopyWithImpl<_$LateProblemImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)
        late,
    required TResult Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)
        overtime,
    required TResult Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)
        earlyLeave,
    required TResult Function() absence,
    required TResult Function() noCheckout,
    required TResult Function(int distance) invalidCheckin,
    required TResult Function(int distance) invalidCheckout,
    required TResult Function(
            String reason,
            @JsonKey(name: 'reported_at') String? reportedAt,
            @JsonKey(name: 'is_report_solved') bool isReportSolved)
        reported,
  }) {
    return late(actualMinutes, payrollMinutes, isPayrollAdjusted);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)?
        late,
    TResult? Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)?
        overtime,
    TResult? Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)?
        earlyLeave,
    TResult? Function()? absence,
    TResult? Function()? noCheckout,
    TResult? Function(int distance)? invalidCheckin,
    TResult? Function(int distance)? invalidCheckout,
    TResult? Function(
            String reason,
            @JsonKey(name: 'reported_at') String? reportedAt,
            @JsonKey(name: 'is_report_solved') bool isReportSolved)?
        reported,
  }) {
    return late?.call(actualMinutes, payrollMinutes, isPayrollAdjusted);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)?
        late,
    TResult Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)?
        overtime,
    TResult Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)?
        earlyLeave,
    TResult Function()? absence,
    TResult Function()? noCheckout,
    TResult Function(int distance)? invalidCheckin,
    TResult Function(int distance)? invalidCheckout,
    TResult Function(
            String reason,
            @JsonKey(name: 'reported_at') String? reportedAt,
            @JsonKey(name: 'is_report_solved') bool isReportSolved)?
        reported,
    required TResult orElse(),
  }) {
    if (late != null) {
      return late(actualMinutes, payrollMinutes, isPayrollAdjusted);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LateProblem value) late,
    required TResult Function(OvertimeProblem value) overtime,
    required TResult Function(EarlyLeaveProblem value) earlyLeave,
    required TResult Function(AbsenceProblem value) absence,
    required TResult Function(NoCheckoutProblem value) noCheckout,
    required TResult Function(InvalidCheckinProblem value) invalidCheckin,
    required TResult Function(InvalidCheckoutProblem value) invalidCheckout,
    required TResult Function(ReportedProblem value) reported,
  }) {
    return late(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LateProblem value)? late,
    TResult? Function(OvertimeProblem value)? overtime,
    TResult? Function(EarlyLeaveProblem value)? earlyLeave,
    TResult? Function(AbsenceProblem value)? absence,
    TResult? Function(NoCheckoutProblem value)? noCheckout,
    TResult? Function(InvalidCheckinProblem value)? invalidCheckin,
    TResult? Function(InvalidCheckoutProblem value)? invalidCheckout,
    TResult? Function(ReportedProblem value)? reported,
  }) {
    return late?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LateProblem value)? late,
    TResult Function(OvertimeProblem value)? overtime,
    TResult Function(EarlyLeaveProblem value)? earlyLeave,
    TResult Function(AbsenceProblem value)? absence,
    TResult Function(NoCheckoutProblem value)? noCheckout,
    TResult Function(InvalidCheckinProblem value)? invalidCheckin,
    TResult Function(InvalidCheckoutProblem value)? invalidCheckout,
    TResult Function(ReportedProblem value)? reported,
    required TResult orElse(),
  }) {
    if (late != null) {
      return late(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$LateProblemImplToJson(
      this,
    );
  }
}

abstract class LateProblem extends Problem {
  const factory LateProblem(
          {@JsonKey(name: 'actual_minutes') final int actualMinutes,
          @JsonKey(name: 'payroll_minutes') final int payrollMinutes,
          @JsonKey(name: 'is_payroll_adjusted') final bool isPayrollAdjusted}) =
      _$LateProblemImpl;
  const LateProblem._() : super._();

  factory LateProblem.fromJson(Map<String, dynamic> json) =
      _$LateProblemImpl.fromJson;

  @JsonKey(name: 'actual_minutes')
  int get actualMinutes;
  @JsonKey(name: 'payroll_minutes')
  int get payrollMinutes;
  @JsonKey(name: 'is_payroll_adjusted')
  bool get isPayrollAdjusted;

  /// Create a copy of Problem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LateProblemImplCopyWith<_$LateProblemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$OvertimeProblemImplCopyWith<$Res> {
  factory _$$OvertimeProblemImplCopyWith(_$OvertimeProblemImpl value,
          $Res Function(_$OvertimeProblemImpl) then) =
      __$$OvertimeProblemImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {@JsonKey(name: 'actual_minutes') int actualMinutes,
      @JsonKey(name: 'payroll_minutes') int payrollMinutes,
      @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted});
}

/// @nodoc
class __$$OvertimeProblemImplCopyWithImpl<$Res>
    extends _$ProblemCopyWithImpl<$Res, _$OvertimeProblemImpl>
    implements _$$OvertimeProblemImplCopyWith<$Res> {
  __$$OvertimeProblemImplCopyWithImpl(
      _$OvertimeProblemImpl _value, $Res Function(_$OvertimeProblemImpl) _then)
      : super(_value, _then);

  /// Create a copy of Problem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? actualMinutes = null,
    Object? payrollMinutes = null,
    Object? isPayrollAdjusted = null,
  }) {
    return _then(_$OvertimeProblemImpl(
      actualMinutes: null == actualMinutes
          ? _value.actualMinutes
          : actualMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      payrollMinutes: null == payrollMinutes
          ? _value.payrollMinutes
          : payrollMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      isPayrollAdjusted: null == isPayrollAdjusted
          ? _value.isPayrollAdjusted
          : isPayrollAdjusted // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OvertimeProblemImpl extends OvertimeProblem {
  const _$OvertimeProblemImpl(
      {@JsonKey(name: 'actual_minutes') this.actualMinutes = 0,
      @JsonKey(name: 'payroll_minutes') this.payrollMinutes = 0,
      @JsonKey(name: 'is_payroll_adjusted') this.isPayrollAdjusted = false,
      final String? $type})
      : $type = $type ?? 'overtime',
        super._();

  factory _$OvertimeProblemImpl.fromJson(Map<String, dynamic> json) =>
      _$$OvertimeProblemImplFromJson(json);

  @override
  @JsonKey(name: 'actual_minutes')
  final int actualMinutes;
  @override
  @JsonKey(name: 'payroll_minutes')
  final int payrollMinutes;
  @override
  @JsonKey(name: 'is_payroll_adjusted')
  final bool isPayrollAdjusted;

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'Problem.overtime(actualMinutes: $actualMinutes, payrollMinutes: $payrollMinutes, isPayrollAdjusted: $isPayrollAdjusted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OvertimeProblemImpl &&
            (identical(other.actualMinutes, actualMinutes) ||
                other.actualMinutes == actualMinutes) &&
            (identical(other.payrollMinutes, payrollMinutes) ||
                other.payrollMinutes == payrollMinutes) &&
            (identical(other.isPayrollAdjusted, isPayrollAdjusted) ||
                other.isPayrollAdjusted == isPayrollAdjusted));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, actualMinutes, payrollMinutes, isPayrollAdjusted);

  /// Create a copy of Problem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OvertimeProblemImplCopyWith<_$OvertimeProblemImpl> get copyWith =>
      __$$OvertimeProblemImplCopyWithImpl<_$OvertimeProblemImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)
        late,
    required TResult Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)
        overtime,
    required TResult Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)
        earlyLeave,
    required TResult Function() absence,
    required TResult Function() noCheckout,
    required TResult Function(int distance) invalidCheckin,
    required TResult Function(int distance) invalidCheckout,
    required TResult Function(
            String reason,
            @JsonKey(name: 'reported_at') String? reportedAt,
            @JsonKey(name: 'is_report_solved') bool isReportSolved)
        reported,
  }) {
    return overtime(actualMinutes, payrollMinutes, isPayrollAdjusted);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)?
        late,
    TResult? Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)?
        overtime,
    TResult? Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)?
        earlyLeave,
    TResult? Function()? absence,
    TResult? Function()? noCheckout,
    TResult? Function(int distance)? invalidCheckin,
    TResult? Function(int distance)? invalidCheckout,
    TResult? Function(
            String reason,
            @JsonKey(name: 'reported_at') String? reportedAt,
            @JsonKey(name: 'is_report_solved') bool isReportSolved)?
        reported,
  }) {
    return overtime?.call(actualMinutes, payrollMinutes, isPayrollAdjusted);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)?
        late,
    TResult Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)?
        overtime,
    TResult Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)?
        earlyLeave,
    TResult Function()? absence,
    TResult Function()? noCheckout,
    TResult Function(int distance)? invalidCheckin,
    TResult Function(int distance)? invalidCheckout,
    TResult Function(
            String reason,
            @JsonKey(name: 'reported_at') String? reportedAt,
            @JsonKey(name: 'is_report_solved') bool isReportSolved)?
        reported,
    required TResult orElse(),
  }) {
    if (overtime != null) {
      return overtime(actualMinutes, payrollMinutes, isPayrollAdjusted);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LateProblem value) late,
    required TResult Function(OvertimeProblem value) overtime,
    required TResult Function(EarlyLeaveProblem value) earlyLeave,
    required TResult Function(AbsenceProblem value) absence,
    required TResult Function(NoCheckoutProblem value) noCheckout,
    required TResult Function(InvalidCheckinProblem value) invalidCheckin,
    required TResult Function(InvalidCheckoutProblem value) invalidCheckout,
    required TResult Function(ReportedProblem value) reported,
  }) {
    return overtime(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LateProblem value)? late,
    TResult? Function(OvertimeProblem value)? overtime,
    TResult? Function(EarlyLeaveProblem value)? earlyLeave,
    TResult? Function(AbsenceProblem value)? absence,
    TResult? Function(NoCheckoutProblem value)? noCheckout,
    TResult? Function(InvalidCheckinProblem value)? invalidCheckin,
    TResult? Function(InvalidCheckoutProblem value)? invalidCheckout,
    TResult? Function(ReportedProblem value)? reported,
  }) {
    return overtime?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LateProblem value)? late,
    TResult Function(OvertimeProblem value)? overtime,
    TResult Function(EarlyLeaveProblem value)? earlyLeave,
    TResult Function(AbsenceProblem value)? absence,
    TResult Function(NoCheckoutProblem value)? noCheckout,
    TResult Function(InvalidCheckinProblem value)? invalidCheckin,
    TResult Function(InvalidCheckoutProblem value)? invalidCheckout,
    TResult Function(ReportedProblem value)? reported,
    required TResult orElse(),
  }) {
    if (overtime != null) {
      return overtime(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$OvertimeProblemImplToJson(
      this,
    );
  }
}

abstract class OvertimeProblem extends Problem {
  const factory OvertimeProblem(
          {@JsonKey(name: 'actual_minutes') final int actualMinutes,
          @JsonKey(name: 'payroll_minutes') final int payrollMinutes,
          @JsonKey(name: 'is_payroll_adjusted') final bool isPayrollAdjusted}) =
      _$OvertimeProblemImpl;
  const OvertimeProblem._() : super._();

  factory OvertimeProblem.fromJson(Map<String, dynamic> json) =
      _$OvertimeProblemImpl.fromJson;

  @JsonKey(name: 'actual_minutes')
  int get actualMinutes;
  @JsonKey(name: 'payroll_minutes')
  int get payrollMinutes;
  @JsonKey(name: 'is_payroll_adjusted')
  bool get isPayrollAdjusted;

  /// Create a copy of Problem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OvertimeProblemImplCopyWith<_$OvertimeProblemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$EarlyLeaveProblemImplCopyWith<$Res> {
  factory _$$EarlyLeaveProblemImplCopyWith(_$EarlyLeaveProblemImpl value,
          $Res Function(_$EarlyLeaveProblemImpl) then) =
      __$$EarlyLeaveProblemImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {@JsonKey(name: 'actual_minutes') int actualMinutes,
      @JsonKey(name: 'payroll_minutes') int payrollMinutes,
      @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted});
}

/// @nodoc
class __$$EarlyLeaveProblemImplCopyWithImpl<$Res>
    extends _$ProblemCopyWithImpl<$Res, _$EarlyLeaveProblemImpl>
    implements _$$EarlyLeaveProblemImplCopyWith<$Res> {
  __$$EarlyLeaveProblemImplCopyWithImpl(_$EarlyLeaveProblemImpl _value,
      $Res Function(_$EarlyLeaveProblemImpl) _then)
      : super(_value, _then);

  /// Create a copy of Problem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? actualMinutes = null,
    Object? payrollMinutes = null,
    Object? isPayrollAdjusted = null,
  }) {
    return _then(_$EarlyLeaveProblemImpl(
      actualMinutes: null == actualMinutes
          ? _value.actualMinutes
          : actualMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      payrollMinutes: null == payrollMinutes
          ? _value.payrollMinutes
          : payrollMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      isPayrollAdjusted: null == isPayrollAdjusted
          ? _value.isPayrollAdjusted
          : isPayrollAdjusted // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EarlyLeaveProblemImpl extends EarlyLeaveProblem {
  const _$EarlyLeaveProblemImpl(
      {@JsonKey(name: 'actual_minutes') this.actualMinutes = 0,
      @JsonKey(name: 'payroll_minutes') this.payrollMinutes = 0,
      @JsonKey(name: 'is_payroll_adjusted') this.isPayrollAdjusted = false,
      final String? $type})
      : $type = $type ?? 'early_leave',
        super._();

  factory _$EarlyLeaveProblemImpl.fromJson(Map<String, dynamic> json) =>
      _$$EarlyLeaveProblemImplFromJson(json);

  @override
  @JsonKey(name: 'actual_minutes')
  final int actualMinutes;
  @override
  @JsonKey(name: 'payroll_minutes')
  final int payrollMinutes;
  @override
  @JsonKey(name: 'is_payroll_adjusted')
  final bool isPayrollAdjusted;

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'Problem.earlyLeave(actualMinutes: $actualMinutes, payrollMinutes: $payrollMinutes, isPayrollAdjusted: $isPayrollAdjusted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EarlyLeaveProblemImpl &&
            (identical(other.actualMinutes, actualMinutes) ||
                other.actualMinutes == actualMinutes) &&
            (identical(other.payrollMinutes, payrollMinutes) ||
                other.payrollMinutes == payrollMinutes) &&
            (identical(other.isPayrollAdjusted, isPayrollAdjusted) ||
                other.isPayrollAdjusted == isPayrollAdjusted));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, actualMinutes, payrollMinutes, isPayrollAdjusted);

  /// Create a copy of Problem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EarlyLeaveProblemImplCopyWith<_$EarlyLeaveProblemImpl> get copyWith =>
      __$$EarlyLeaveProblemImplCopyWithImpl<_$EarlyLeaveProblemImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)
        late,
    required TResult Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)
        overtime,
    required TResult Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)
        earlyLeave,
    required TResult Function() absence,
    required TResult Function() noCheckout,
    required TResult Function(int distance) invalidCheckin,
    required TResult Function(int distance) invalidCheckout,
    required TResult Function(
            String reason,
            @JsonKey(name: 'reported_at') String? reportedAt,
            @JsonKey(name: 'is_report_solved') bool isReportSolved)
        reported,
  }) {
    return earlyLeave(actualMinutes, payrollMinutes, isPayrollAdjusted);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)?
        late,
    TResult? Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)?
        overtime,
    TResult? Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)?
        earlyLeave,
    TResult? Function()? absence,
    TResult? Function()? noCheckout,
    TResult? Function(int distance)? invalidCheckin,
    TResult? Function(int distance)? invalidCheckout,
    TResult? Function(
            String reason,
            @JsonKey(name: 'reported_at') String? reportedAt,
            @JsonKey(name: 'is_report_solved') bool isReportSolved)?
        reported,
  }) {
    return earlyLeave?.call(actualMinutes, payrollMinutes, isPayrollAdjusted);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)?
        late,
    TResult Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)?
        overtime,
    TResult Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)?
        earlyLeave,
    TResult Function()? absence,
    TResult Function()? noCheckout,
    TResult Function(int distance)? invalidCheckin,
    TResult Function(int distance)? invalidCheckout,
    TResult Function(
            String reason,
            @JsonKey(name: 'reported_at') String? reportedAt,
            @JsonKey(name: 'is_report_solved') bool isReportSolved)?
        reported,
    required TResult orElse(),
  }) {
    if (earlyLeave != null) {
      return earlyLeave(actualMinutes, payrollMinutes, isPayrollAdjusted);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LateProblem value) late,
    required TResult Function(OvertimeProblem value) overtime,
    required TResult Function(EarlyLeaveProblem value) earlyLeave,
    required TResult Function(AbsenceProblem value) absence,
    required TResult Function(NoCheckoutProblem value) noCheckout,
    required TResult Function(InvalidCheckinProblem value) invalidCheckin,
    required TResult Function(InvalidCheckoutProblem value) invalidCheckout,
    required TResult Function(ReportedProblem value) reported,
  }) {
    return earlyLeave(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LateProblem value)? late,
    TResult? Function(OvertimeProblem value)? overtime,
    TResult? Function(EarlyLeaveProblem value)? earlyLeave,
    TResult? Function(AbsenceProblem value)? absence,
    TResult? Function(NoCheckoutProblem value)? noCheckout,
    TResult? Function(InvalidCheckinProblem value)? invalidCheckin,
    TResult? Function(InvalidCheckoutProblem value)? invalidCheckout,
    TResult? Function(ReportedProblem value)? reported,
  }) {
    return earlyLeave?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LateProblem value)? late,
    TResult Function(OvertimeProblem value)? overtime,
    TResult Function(EarlyLeaveProblem value)? earlyLeave,
    TResult Function(AbsenceProblem value)? absence,
    TResult Function(NoCheckoutProblem value)? noCheckout,
    TResult Function(InvalidCheckinProblem value)? invalidCheckin,
    TResult Function(InvalidCheckoutProblem value)? invalidCheckout,
    TResult Function(ReportedProblem value)? reported,
    required TResult orElse(),
  }) {
    if (earlyLeave != null) {
      return earlyLeave(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$EarlyLeaveProblemImplToJson(
      this,
    );
  }
}

abstract class EarlyLeaveProblem extends Problem {
  const factory EarlyLeaveProblem(
          {@JsonKey(name: 'actual_minutes') final int actualMinutes,
          @JsonKey(name: 'payroll_minutes') final int payrollMinutes,
          @JsonKey(name: 'is_payroll_adjusted') final bool isPayrollAdjusted}) =
      _$EarlyLeaveProblemImpl;
  const EarlyLeaveProblem._() : super._();

  factory EarlyLeaveProblem.fromJson(Map<String, dynamic> json) =
      _$EarlyLeaveProblemImpl.fromJson;

  @JsonKey(name: 'actual_minutes')
  int get actualMinutes;
  @JsonKey(name: 'payroll_minutes')
  int get payrollMinutes;
  @JsonKey(name: 'is_payroll_adjusted')
  bool get isPayrollAdjusted;

  /// Create a copy of Problem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EarlyLeaveProblemImplCopyWith<_$EarlyLeaveProblemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AbsenceProblemImplCopyWith<$Res> {
  factory _$$AbsenceProblemImplCopyWith(_$AbsenceProblemImpl value,
          $Res Function(_$AbsenceProblemImpl) then) =
      __$$AbsenceProblemImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AbsenceProblemImplCopyWithImpl<$Res>
    extends _$ProblemCopyWithImpl<$Res, _$AbsenceProblemImpl>
    implements _$$AbsenceProblemImplCopyWith<$Res> {
  __$$AbsenceProblemImplCopyWithImpl(
      _$AbsenceProblemImpl _value, $Res Function(_$AbsenceProblemImpl) _then)
      : super(_value, _then);

  /// Create a copy of Problem
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
@JsonSerializable()
class _$AbsenceProblemImpl extends AbsenceProblem {
  const _$AbsenceProblemImpl({final String? $type})
      : $type = $type ?? 'absence',
        super._();

  factory _$AbsenceProblemImpl.fromJson(Map<String, dynamic> json) =>
      _$$AbsenceProblemImplFromJson(json);

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'Problem.absence()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$AbsenceProblemImpl);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)
        late,
    required TResult Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)
        overtime,
    required TResult Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)
        earlyLeave,
    required TResult Function() absence,
    required TResult Function() noCheckout,
    required TResult Function(int distance) invalidCheckin,
    required TResult Function(int distance) invalidCheckout,
    required TResult Function(
            String reason,
            @JsonKey(name: 'reported_at') String? reportedAt,
            @JsonKey(name: 'is_report_solved') bool isReportSolved)
        reported,
  }) {
    return absence();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)?
        late,
    TResult? Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)?
        overtime,
    TResult? Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)?
        earlyLeave,
    TResult? Function()? absence,
    TResult? Function()? noCheckout,
    TResult? Function(int distance)? invalidCheckin,
    TResult? Function(int distance)? invalidCheckout,
    TResult? Function(
            String reason,
            @JsonKey(name: 'reported_at') String? reportedAt,
            @JsonKey(name: 'is_report_solved') bool isReportSolved)?
        reported,
  }) {
    return absence?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)?
        late,
    TResult Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)?
        overtime,
    TResult Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)?
        earlyLeave,
    TResult Function()? absence,
    TResult Function()? noCheckout,
    TResult Function(int distance)? invalidCheckin,
    TResult Function(int distance)? invalidCheckout,
    TResult Function(
            String reason,
            @JsonKey(name: 'reported_at') String? reportedAt,
            @JsonKey(name: 'is_report_solved') bool isReportSolved)?
        reported,
    required TResult orElse(),
  }) {
    if (absence != null) {
      return absence();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LateProblem value) late,
    required TResult Function(OvertimeProblem value) overtime,
    required TResult Function(EarlyLeaveProblem value) earlyLeave,
    required TResult Function(AbsenceProblem value) absence,
    required TResult Function(NoCheckoutProblem value) noCheckout,
    required TResult Function(InvalidCheckinProblem value) invalidCheckin,
    required TResult Function(InvalidCheckoutProblem value) invalidCheckout,
    required TResult Function(ReportedProblem value) reported,
  }) {
    return absence(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LateProblem value)? late,
    TResult? Function(OvertimeProblem value)? overtime,
    TResult? Function(EarlyLeaveProblem value)? earlyLeave,
    TResult? Function(AbsenceProblem value)? absence,
    TResult? Function(NoCheckoutProblem value)? noCheckout,
    TResult? Function(InvalidCheckinProblem value)? invalidCheckin,
    TResult? Function(InvalidCheckoutProblem value)? invalidCheckout,
    TResult? Function(ReportedProblem value)? reported,
  }) {
    return absence?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LateProblem value)? late,
    TResult Function(OvertimeProblem value)? overtime,
    TResult Function(EarlyLeaveProblem value)? earlyLeave,
    TResult Function(AbsenceProblem value)? absence,
    TResult Function(NoCheckoutProblem value)? noCheckout,
    TResult Function(InvalidCheckinProblem value)? invalidCheckin,
    TResult Function(InvalidCheckoutProblem value)? invalidCheckout,
    TResult Function(ReportedProblem value)? reported,
    required TResult orElse(),
  }) {
    if (absence != null) {
      return absence(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$AbsenceProblemImplToJson(
      this,
    );
  }
}

abstract class AbsenceProblem extends Problem {
  const factory AbsenceProblem() = _$AbsenceProblemImpl;
  const AbsenceProblem._() : super._();

  factory AbsenceProblem.fromJson(Map<String, dynamic> json) =
      _$AbsenceProblemImpl.fromJson;
}

/// @nodoc
abstract class _$$NoCheckoutProblemImplCopyWith<$Res> {
  factory _$$NoCheckoutProblemImplCopyWith(_$NoCheckoutProblemImpl value,
          $Res Function(_$NoCheckoutProblemImpl) then) =
      __$$NoCheckoutProblemImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$NoCheckoutProblemImplCopyWithImpl<$Res>
    extends _$ProblemCopyWithImpl<$Res, _$NoCheckoutProblemImpl>
    implements _$$NoCheckoutProblemImplCopyWith<$Res> {
  __$$NoCheckoutProblemImplCopyWithImpl(_$NoCheckoutProblemImpl _value,
      $Res Function(_$NoCheckoutProblemImpl) _then)
      : super(_value, _then);

  /// Create a copy of Problem
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
@JsonSerializable()
class _$NoCheckoutProblemImpl extends NoCheckoutProblem {
  const _$NoCheckoutProblemImpl({final String? $type})
      : $type = $type ?? 'no_checkout',
        super._();

  factory _$NoCheckoutProblemImpl.fromJson(Map<String, dynamic> json) =>
      _$$NoCheckoutProblemImplFromJson(json);

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'Problem.noCheckout()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$NoCheckoutProblemImpl);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)
        late,
    required TResult Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)
        overtime,
    required TResult Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)
        earlyLeave,
    required TResult Function() absence,
    required TResult Function() noCheckout,
    required TResult Function(int distance) invalidCheckin,
    required TResult Function(int distance) invalidCheckout,
    required TResult Function(
            String reason,
            @JsonKey(name: 'reported_at') String? reportedAt,
            @JsonKey(name: 'is_report_solved') bool isReportSolved)
        reported,
  }) {
    return noCheckout();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)?
        late,
    TResult? Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)?
        overtime,
    TResult? Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)?
        earlyLeave,
    TResult? Function()? absence,
    TResult? Function()? noCheckout,
    TResult? Function(int distance)? invalidCheckin,
    TResult? Function(int distance)? invalidCheckout,
    TResult? Function(
            String reason,
            @JsonKey(name: 'reported_at') String? reportedAt,
            @JsonKey(name: 'is_report_solved') bool isReportSolved)?
        reported,
  }) {
    return noCheckout?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)?
        late,
    TResult Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)?
        overtime,
    TResult Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)?
        earlyLeave,
    TResult Function()? absence,
    TResult Function()? noCheckout,
    TResult Function(int distance)? invalidCheckin,
    TResult Function(int distance)? invalidCheckout,
    TResult Function(
            String reason,
            @JsonKey(name: 'reported_at') String? reportedAt,
            @JsonKey(name: 'is_report_solved') bool isReportSolved)?
        reported,
    required TResult orElse(),
  }) {
    if (noCheckout != null) {
      return noCheckout();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LateProblem value) late,
    required TResult Function(OvertimeProblem value) overtime,
    required TResult Function(EarlyLeaveProblem value) earlyLeave,
    required TResult Function(AbsenceProblem value) absence,
    required TResult Function(NoCheckoutProblem value) noCheckout,
    required TResult Function(InvalidCheckinProblem value) invalidCheckin,
    required TResult Function(InvalidCheckoutProblem value) invalidCheckout,
    required TResult Function(ReportedProblem value) reported,
  }) {
    return noCheckout(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LateProblem value)? late,
    TResult? Function(OvertimeProblem value)? overtime,
    TResult? Function(EarlyLeaveProblem value)? earlyLeave,
    TResult? Function(AbsenceProblem value)? absence,
    TResult? Function(NoCheckoutProblem value)? noCheckout,
    TResult? Function(InvalidCheckinProblem value)? invalidCheckin,
    TResult? Function(InvalidCheckoutProblem value)? invalidCheckout,
    TResult? Function(ReportedProblem value)? reported,
  }) {
    return noCheckout?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LateProblem value)? late,
    TResult Function(OvertimeProblem value)? overtime,
    TResult Function(EarlyLeaveProblem value)? earlyLeave,
    TResult Function(AbsenceProblem value)? absence,
    TResult Function(NoCheckoutProblem value)? noCheckout,
    TResult Function(InvalidCheckinProblem value)? invalidCheckin,
    TResult Function(InvalidCheckoutProblem value)? invalidCheckout,
    TResult Function(ReportedProblem value)? reported,
    required TResult orElse(),
  }) {
    if (noCheckout != null) {
      return noCheckout(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$NoCheckoutProblemImplToJson(
      this,
    );
  }
}

abstract class NoCheckoutProblem extends Problem {
  const factory NoCheckoutProblem() = _$NoCheckoutProblemImpl;
  const NoCheckoutProblem._() : super._();

  factory NoCheckoutProblem.fromJson(Map<String, dynamic> json) =
      _$NoCheckoutProblemImpl.fromJson;
}

/// @nodoc
abstract class _$$InvalidCheckinProblemImplCopyWith<$Res> {
  factory _$$InvalidCheckinProblemImplCopyWith(
          _$InvalidCheckinProblemImpl value,
          $Res Function(_$InvalidCheckinProblemImpl) then) =
      __$$InvalidCheckinProblemImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int distance});
}

/// @nodoc
class __$$InvalidCheckinProblemImplCopyWithImpl<$Res>
    extends _$ProblemCopyWithImpl<$Res, _$InvalidCheckinProblemImpl>
    implements _$$InvalidCheckinProblemImplCopyWith<$Res> {
  __$$InvalidCheckinProblemImplCopyWithImpl(_$InvalidCheckinProblemImpl _value,
      $Res Function(_$InvalidCheckinProblemImpl) _then)
      : super(_value, _then);

  /// Create a copy of Problem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? distance = null,
  }) {
    return _then(_$InvalidCheckinProblemImpl(
      distance: null == distance
          ? _value.distance
          : distance // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InvalidCheckinProblemImpl extends InvalidCheckinProblem {
  const _$InvalidCheckinProblemImpl({this.distance = 0, final String? $type})
      : $type = $type ?? 'invalid_checkin',
        super._();

  factory _$InvalidCheckinProblemImpl.fromJson(Map<String, dynamic> json) =>
      _$$InvalidCheckinProblemImplFromJson(json);

  @override
  @JsonKey()
  final int distance;

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'Problem.invalidCheckin(distance: $distance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InvalidCheckinProblemImpl &&
            (identical(other.distance, distance) ||
                other.distance == distance));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, distance);

  /// Create a copy of Problem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InvalidCheckinProblemImplCopyWith<_$InvalidCheckinProblemImpl>
      get copyWith => __$$InvalidCheckinProblemImplCopyWithImpl<
          _$InvalidCheckinProblemImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)
        late,
    required TResult Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)
        overtime,
    required TResult Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)
        earlyLeave,
    required TResult Function() absence,
    required TResult Function() noCheckout,
    required TResult Function(int distance) invalidCheckin,
    required TResult Function(int distance) invalidCheckout,
    required TResult Function(
            String reason,
            @JsonKey(name: 'reported_at') String? reportedAt,
            @JsonKey(name: 'is_report_solved') bool isReportSolved)
        reported,
  }) {
    return invalidCheckin(distance);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)?
        late,
    TResult? Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)?
        overtime,
    TResult? Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)?
        earlyLeave,
    TResult? Function()? absence,
    TResult? Function()? noCheckout,
    TResult? Function(int distance)? invalidCheckin,
    TResult? Function(int distance)? invalidCheckout,
    TResult? Function(
            String reason,
            @JsonKey(name: 'reported_at') String? reportedAt,
            @JsonKey(name: 'is_report_solved') bool isReportSolved)?
        reported,
  }) {
    return invalidCheckin?.call(distance);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)?
        late,
    TResult Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)?
        overtime,
    TResult Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)?
        earlyLeave,
    TResult Function()? absence,
    TResult Function()? noCheckout,
    TResult Function(int distance)? invalidCheckin,
    TResult Function(int distance)? invalidCheckout,
    TResult Function(
            String reason,
            @JsonKey(name: 'reported_at') String? reportedAt,
            @JsonKey(name: 'is_report_solved') bool isReportSolved)?
        reported,
    required TResult orElse(),
  }) {
    if (invalidCheckin != null) {
      return invalidCheckin(distance);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LateProblem value) late,
    required TResult Function(OvertimeProblem value) overtime,
    required TResult Function(EarlyLeaveProblem value) earlyLeave,
    required TResult Function(AbsenceProblem value) absence,
    required TResult Function(NoCheckoutProblem value) noCheckout,
    required TResult Function(InvalidCheckinProblem value) invalidCheckin,
    required TResult Function(InvalidCheckoutProblem value) invalidCheckout,
    required TResult Function(ReportedProblem value) reported,
  }) {
    return invalidCheckin(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LateProblem value)? late,
    TResult? Function(OvertimeProblem value)? overtime,
    TResult? Function(EarlyLeaveProblem value)? earlyLeave,
    TResult? Function(AbsenceProblem value)? absence,
    TResult? Function(NoCheckoutProblem value)? noCheckout,
    TResult? Function(InvalidCheckinProblem value)? invalidCheckin,
    TResult? Function(InvalidCheckoutProblem value)? invalidCheckout,
    TResult? Function(ReportedProblem value)? reported,
  }) {
    return invalidCheckin?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LateProblem value)? late,
    TResult Function(OvertimeProblem value)? overtime,
    TResult Function(EarlyLeaveProblem value)? earlyLeave,
    TResult Function(AbsenceProblem value)? absence,
    TResult Function(NoCheckoutProblem value)? noCheckout,
    TResult Function(InvalidCheckinProblem value)? invalidCheckin,
    TResult Function(InvalidCheckoutProblem value)? invalidCheckout,
    TResult Function(ReportedProblem value)? reported,
    required TResult orElse(),
  }) {
    if (invalidCheckin != null) {
      return invalidCheckin(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$InvalidCheckinProblemImplToJson(
      this,
    );
  }
}

abstract class InvalidCheckinProblem extends Problem {
  const factory InvalidCheckinProblem({final int distance}) =
      _$InvalidCheckinProblemImpl;
  const InvalidCheckinProblem._() : super._();

  factory InvalidCheckinProblem.fromJson(Map<String, dynamic> json) =
      _$InvalidCheckinProblemImpl.fromJson;

  int get distance;

  /// Create a copy of Problem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InvalidCheckinProblemImplCopyWith<_$InvalidCheckinProblemImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$InvalidCheckoutProblemImplCopyWith<$Res> {
  factory _$$InvalidCheckoutProblemImplCopyWith(
          _$InvalidCheckoutProblemImpl value,
          $Res Function(_$InvalidCheckoutProblemImpl) then) =
      __$$InvalidCheckoutProblemImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int distance});
}

/// @nodoc
class __$$InvalidCheckoutProblemImplCopyWithImpl<$Res>
    extends _$ProblemCopyWithImpl<$Res, _$InvalidCheckoutProblemImpl>
    implements _$$InvalidCheckoutProblemImplCopyWith<$Res> {
  __$$InvalidCheckoutProblemImplCopyWithImpl(
      _$InvalidCheckoutProblemImpl _value,
      $Res Function(_$InvalidCheckoutProblemImpl) _then)
      : super(_value, _then);

  /// Create a copy of Problem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? distance = null,
  }) {
    return _then(_$InvalidCheckoutProblemImpl(
      distance: null == distance
          ? _value.distance
          : distance // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InvalidCheckoutProblemImpl extends InvalidCheckoutProblem {
  const _$InvalidCheckoutProblemImpl({this.distance = 0, final String? $type})
      : $type = $type ?? 'invalid_checkout',
        super._();

  factory _$InvalidCheckoutProblemImpl.fromJson(Map<String, dynamic> json) =>
      _$$InvalidCheckoutProblemImplFromJson(json);

  @override
  @JsonKey()
  final int distance;

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'Problem.invalidCheckout(distance: $distance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InvalidCheckoutProblemImpl &&
            (identical(other.distance, distance) ||
                other.distance == distance));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, distance);

  /// Create a copy of Problem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InvalidCheckoutProblemImplCopyWith<_$InvalidCheckoutProblemImpl>
      get copyWith => __$$InvalidCheckoutProblemImplCopyWithImpl<
          _$InvalidCheckoutProblemImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)
        late,
    required TResult Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)
        overtime,
    required TResult Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)
        earlyLeave,
    required TResult Function() absence,
    required TResult Function() noCheckout,
    required TResult Function(int distance) invalidCheckin,
    required TResult Function(int distance) invalidCheckout,
    required TResult Function(
            String reason,
            @JsonKey(name: 'reported_at') String? reportedAt,
            @JsonKey(name: 'is_report_solved') bool isReportSolved)
        reported,
  }) {
    return invalidCheckout(distance);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)?
        late,
    TResult? Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)?
        overtime,
    TResult? Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)?
        earlyLeave,
    TResult? Function()? absence,
    TResult? Function()? noCheckout,
    TResult? Function(int distance)? invalidCheckin,
    TResult? Function(int distance)? invalidCheckout,
    TResult? Function(
            String reason,
            @JsonKey(name: 'reported_at') String? reportedAt,
            @JsonKey(name: 'is_report_solved') bool isReportSolved)?
        reported,
  }) {
    return invalidCheckout?.call(distance);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)?
        late,
    TResult Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)?
        overtime,
    TResult Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)?
        earlyLeave,
    TResult Function()? absence,
    TResult Function()? noCheckout,
    TResult Function(int distance)? invalidCheckin,
    TResult Function(int distance)? invalidCheckout,
    TResult Function(
            String reason,
            @JsonKey(name: 'reported_at') String? reportedAt,
            @JsonKey(name: 'is_report_solved') bool isReportSolved)?
        reported,
    required TResult orElse(),
  }) {
    if (invalidCheckout != null) {
      return invalidCheckout(distance);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LateProblem value) late,
    required TResult Function(OvertimeProblem value) overtime,
    required TResult Function(EarlyLeaveProblem value) earlyLeave,
    required TResult Function(AbsenceProblem value) absence,
    required TResult Function(NoCheckoutProblem value) noCheckout,
    required TResult Function(InvalidCheckinProblem value) invalidCheckin,
    required TResult Function(InvalidCheckoutProblem value) invalidCheckout,
    required TResult Function(ReportedProblem value) reported,
  }) {
    return invalidCheckout(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LateProblem value)? late,
    TResult? Function(OvertimeProblem value)? overtime,
    TResult? Function(EarlyLeaveProblem value)? earlyLeave,
    TResult? Function(AbsenceProblem value)? absence,
    TResult? Function(NoCheckoutProblem value)? noCheckout,
    TResult? Function(InvalidCheckinProblem value)? invalidCheckin,
    TResult? Function(InvalidCheckoutProblem value)? invalidCheckout,
    TResult? Function(ReportedProblem value)? reported,
  }) {
    return invalidCheckout?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LateProblem value)? late,
    TResult Function(OvertimeProblem value)? overtime,
    TResult Function(EarlyLeaveProblem value)? earlyLeave,
    TResult Function(AbsenceProblem value)? absence,
    TResult Function(NoCheckoutProblem value)? noCheckout,
    TResult Function(InvalidCheckinProblem value)? invalidCheckin,
    TResult Function(InvalidCheckoutProblem value)? invalidCheckout,
    TResult Function(ReportedProblem value)? reported,
    required TResult orElse(),
  }) {
    if (invalidCheckout != null) {
      return invalidCheckout(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$InvalidCheckoutProblemImplToJson(
      this,
    );
  }
}

abstract class InvalidCheckoutProblem extends Problem {
  const factory InvalidCheckoutProblem({final int distance}) =
      _$InvalidCheckoutProblemImpl;
  const InvalidCheckoutProblem._() : super._();

  factory InvalidCheckoutProblem.fromJson(Map<String, dynamic> json) =
      _$InvalidCheckoutProblemImpl.fromJson;

  int get distance;

  /// Create a copy of Problem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InvalidCheckoutProblemImplCopyWith<_$InvalidCheckoutProblemImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ReportedProblemImplCopyWith<$Res> {
  factory _$$ReportedProblemImplCopyWith(_$ReportedProblemImpl value,
          $Res Function(_$ReportedProblemImpl) then) =
      __$$ReportedProblemImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {String reason,
      @JsonKey(name: 'reported_at') String? reportedAt,
      @JsonKey(name: 'is_report_solved') bool isReportSolved});
}

/// @nodoc
class __$$ReportedProblemImplCopyWithImpl<$Res>
    extends _$ProblemCopyWithImpl<$Res, _$ReportedProblemImpl>
    implements _$$ReportedProblemImplCopyWith<$Res> {
  __$$ReportedProblemImplCopyWithImpl(
      _$ReportedProblemImpl _value, $Res Function(_$ReportedProblemImpl) _then)
      : super(_value, _then);

  /// Create a copy of Problem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reason = null,
    Object? reportedAt = freezed,
    Object? isReportSolved = null,
  }) {
    return _then(_$ReportedProblemImpl(
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      reportedAt: freezed == reportedAt
          ? _value.reportedAt
          : reportedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      isReportSolved: null == isReportSolved
          ? _value.isReportSolved
          : isReportSolved // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReportedProblemImpl extends ReportedProblem {
  const _$ReportedProblemImpl(
      {this.reason = '',
      @JsonKey(name: 'reported_at') this.reportedAt,
      @JsonKey(name: 'is_report_solved') this.isReportSolved = false,
      final String? $type})
      : $type = $type ?? 'reported',
        super._();

  factory _$ReportedProblemImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReportedProblemImplFromJson(json);

  @override
  @JsonKey()
  final String reason;
  @override
  @JsonKey(name: 'reported_at')
  final String? reportedAt;
  @override
  @JsonKey(name: 'is_report_solved')
  final bool isReportSolved;

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'Problem.reported(reason: $reason, reportedAt: $reportedAt, isReportSolved: $isReportSolved)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReportedProblemImpl &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.reportedAt, reportedAt) ||
                other.reportedAt == reportedAt) &&
            (identical(other.isReportSolved, isReportSolved) ||
                other.isReportSolved == isReportSolved));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, reason, reportedAt, isReportSolved);

  /// Create a copy of Problem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReportedProblemImplCopyWith<_$ReportedProblemImpl> get copyWith =>
      __$$ReportedProblemImplCopyWithImpl<_$ReportedProblemImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)
        late,
    required TResult Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)
        overtime,
    required TResult Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)
        earlyLeave,
    required TResult Function() absence,
    required TResult Function() noCheckout,
    required TResult Function(int distance) invalidCheckin,
    required TResult Function(int distance) invalidCheckout,
    required TResult Function(
            String reason,
            @JsonKey(name: 'reported_at') String? reportedAt,
            @JsonKey(name: 'is_report_solved') bool isReportSolved)
        reported,
  }) {
    return reported(reason, reportedAt, isReportSolved);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)?
        late,
    TResult? Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)?
        overtime,
    TResult? Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)?
        earlyLeave,
    TResult? Function()? absence,
    TResult? Function()? noCheckout,
    TResult? Function(int distance)? invalidCheckin,
    TResult? Function(int distance)? invalidCheckout,
    TResult? Function(
            String reason,
            @JsonKey(name: 'reported_at') String? reportedAt,
            @JsonKey(name: 'is_report_solved') bool isReportSolved)?
        reported,
  }) {
    return reported?.call(reason, reportedAt, isReportSolved);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)?
        late,
    TResult Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)?
        overtime,
    TResult Function(
            @JsonKey(name: 'actual_minutes') int actualMinutes,
            @JsonKey(name: 'payroll_minutes') int payrollMinutes,
            @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted)?
        earlyLeave,
    TResult Function()? absence,
    TResult Function()? noCheckout,
    TResult Function(int distance)? invalidCheckin,
    TResult Function(int distance)? invalidCheckout,
    TResult Function(
            String reason,
            @JsonKey(name: 'reported_at') String? reportedAt,
            @JsonKey(name: 'is_report_solved') bool isReportSolved)?
        reported,
    required TResult orElse(),
  }) {
    if (reported != null) {
      return reported(reason, reportedAt, isReportSolved);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LateProblem value) late,
    required TResult Function(OvertimeProblem value) overtime,
    required TResult Function(EarlyLeaveProblem value) earlyLeave,
    required TResult Function(AbsenceProblem value) absence,
    required TResult Function(NoCheckoutProblem value) noCheckout,
    required TResult Function(InvalidCheckinProblem value) invalidCheckin,
    required TResult Function(InvalidCheckoutProblem value) invalidCheckout,
    required TResult Function(ReportedProblem value) reported,
  }) {
    return reported(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LateProblem value)? late,
    TResult? Function(OvertimeProblem value)? overtime,
    TResult? Function(EarlyLeaveProblem value)? earlyLeave,
    TResult? Function(AbsenceProblem value)? absence,
    TResult? Function(NoCheckoutProblem value)? noCheckout,
    TResult? Function(InvalidCheckinProblem value)? invalidCheckin,
    TResult? Function(InvalidCheckoutProblem value)? invalidCheckout,
    TResult? Function(ReportedProblem value)? reported,
  }) {
    return reported?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LateProblem value)? late,
    TResult Function(OvertimeProblem value)? overtime,
    TResult Function(EarlyLeaveProblem value)? earlyLeave,
    TResult Function(AbsenceProblem value)? absence,
    TResult Function(NoCheckoutProblem value)? noCheckout,
    TResult Function(InvalidCheckinProblem value)? invalidCheckin,
    TResult Function(InvalidCheckoutProblem value)? invalidCheckout,
    TResult Function(ReportedProblem value)? reported,
    required TResult orElse(),
  }) {
    if (reported != null) {
      return reported(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$ReportedProblemImplToJson(
      this,
    );
  }
}

abstract class ReportedProblem extends Problem {
  const factory ReportedProblem(
          {final String reason,
          @JsonKey(name: 'reported_at') final String? reportedAt,
          @JsonKey(name: 'is_report_solved') final bool isReportSolved}) =
      _$ReportedProblemImpl;
  const ReportedProblem._() : super._();

  factory ReportedProblem.fromJson(Map<String, dynamic> json) =
      _$ReportedProblemImpl.fromJson;

  String get reason;
  @JsonKey(name: 'reported_at')
  String? get reportedAt;
  @JsonKey(name: 'is_report_solved')
  bool get isReportSolved;

  /// Create a copy of Problem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReportedProblemImplCopyWith<_$ReportedProblemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
