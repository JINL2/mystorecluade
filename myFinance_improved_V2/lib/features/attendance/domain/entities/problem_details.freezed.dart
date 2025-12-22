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

/// @nodoc
mixin _$ProblemDetails {
// 빠른 필터링용 플래그
  bool get hasLate => throw _privateConstructorUsedError;
  bool get hasAbsence => throw _privateConstructorUsedError;
  bool get hasOvertime => throw _privateConstructorUsedError;
  bool get hasEarlyLeave => throw _privateConstructorUsedError;
  bool get hasNoCheckout => throw _privateConstructorUsedError;
  bool get hasLocationIssue => throw _privateConstructorUsedError;
  bool get hasReported => throw _privateConstructorUsedError; // 상태
  bool get isSolved => throw _privateConstructorUsedError;
  int get problemCount => throw _privateConstructorUsedError;
  String? get detectedAt => throw _privateConstructorUsedError; // 상세 문제 목록
  List<Problem> get problems => throw _privateConstructorUsedError;

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
      {bool hasLate,
      bool hasAbsence,
      bool hasOvertime,
      bool hasEarlyLeave,
      bool hasNoCheckout,
      bool hasLocationIssue,
      bool hasReported,
      bool isSolved,
      int problemCount,
      String? detectedAt,
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
      {bool hasLate,
      bool hasAbsence,
      bool hasOvertime,
      bool hasEarlyLeave,
      bool hasNoCheckout,
      bool hasLocationIssue,
      bool hasReported,
      bool isSolved,
      int problemCount,
      String? detectedAt,
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

class _$ProblemDetailsImpl extends _ProblemDetails {
  const _$ProblemDetailsImpl(
      {this.hasLate = false,
      this.hasAbsence = false,
      this.hasOvertime = false,
      this.hasEarlyLeave = false,
      this.hasNoCheckout = false,
      this.hasLocationIssue = false,
      this.hasReported = false,
      this.isSolved = false,
      this.problemCount = 0,
      this.detectedAt,
      final List<Problem> problems = const []})
      : _problems = problems,
        super._();

// 빠른 필터링용 플래그
  @override
  @JsonKey()
  final bool hasLate;
  @override
  @JsonKey()
  final bool hasAbsence;
  @override
  @JsonKey()
  final bool hasOvertime;
  @override
  @JsonKey()
  final bool hasEarlyLeave;
  @override
  @JsonKey()
  final bool hasNoCheckout;
  @override
  @JsonKey()
  final bool hasLocationIssue;
  @override
  @JsonKey()
  final bool hasReported;
// 상태
  @override
  @JsonKey()
  final bool isSolved;
  @override
  @JsonKey()
  final int problemCount;
  @override
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
}

abstract class _ProblemDetails extends ProblemDetails {
  const factory _ProblemDetails(
      {final bool hasLate,
      final bool hasAbsence,
      final bool hasOvertime,
      final bool hasEarlyLeave,
      final bool hasNoCheckout,
      final bool hasLocationIssue,
      final bool hasReported,
      final bool isSolved,
      final int problemCount,
      final String? detectedAt,
      final List<Problem> problems}) = _$ProblemDetailsImpl;
  const _ProblemDetails._() : super._();

// 빠른 필터링용 플래그
  @override
  bool get hasLate;
  @override
  bool get hasAbsence;
  @override
  bool get hasOvertime;
  @override
  bool get hasEarlyLeave;
  @override
  bool get hasNoCheckout;
  @override
  bool get hasLocationIssue;
  @override
  bool get hasReported; // 상태
  @override
  bool get isSolved;
  @override
  int get problemCount;
  @override
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

/// @nodoc
mixin _$Problem {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)
        late,
    required TResult Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)
        overtime,
    required TResult Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)
        earlyLeave,
    required TResult Function() absence,
    required TResult Function() noCheckout,
    required TResult Function(int distance) invalidCheckin,
    required TResult Function(int distance) invalidCheckout,
    required TResult Function(
            String reason, String? reportedAt, bool isReportSolved)
        reported,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)?
        late,
    TResult? Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)?
        overtime,
    TResult? Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)?
        earlyLeave,
    TResult? Function()? absence,
    TResult? Function()? noCheckout,
    TResult? Function(int distance)? invalidCheckin,
    TResult? Function(int distance)? invalidCheckout,
    TResult? Function(String reason, String? reportedAt, bool isReportSolved)?
        reported,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)?
        late,
    TResult Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)?
        overtime,
    TResult Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)?
        earlyLeave,
    TResult Function()? absence,
    TResult Function()? noCheckout,
    TResult Function(int distance)? invalidCheckin,
    TResult Function(int distance)? invalidCheckout,
    TResult Function(String reason, String? reportedAt, bool isReportSolved)?
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
  $Res call({int actualMinutes, int payrollMinutes, bool isPayrollAdjusted});
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

class _$LateProblemImpl extends LateProblem {
  const _$LateProblemImpl(
      {this.actualMinutes = 0,
      this.payrollMinutes = 0,
      this.isPayrollAdjusted = false})
      : super._();

  @override
  @JsonKey()
  final int actualMinutes;
  @override
  @JsonKey()
  final int payrollMinutes;
  @override
  @JsonKey()
  final bool isPayrollAdjusted;

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
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)
        late,
    required TResult Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)
        overtime,
    required TResult Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)
        earlyLeave,
    required TResult Function() absence,
    required TResult Function() noCheckout,
    required TResult Function(int distance) invalidCheckin,
    required TResult Function(int distance) invalidCheckout,
    required TResult Function(
            String reason, String? reportedAt, bool isReportSolved)
        reported,
  }) {
    return late(actualMinutes, payrollMinutes, isPayrollAdjusted);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)?
        late,
    TResult? Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)?
        overtime,
    TResult? Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)?
        earlyLeave,
    TResult? Function()? absence,
    TResult? Function()? noCheckout,
    TResult? Function(int distance)? invalidCheckin,
    TResult? Function(int distance)? invalidCheckout,
    TResult? Function(String reason, String? reportedAt, bool isReportSolved)?
        reported,
  }) {
    return late?.call(actualMinutes, payrollMinutes, isPayrollAdjusted);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)?
        late,
    TResult Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)?
        overtime,
    TResult Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)?
        earlyLeave,
    TResult Function()? absence,
    TResult Function()? noCheckout,
    TResult Function(int distance)? invalidCheckin,
    TResult Function(int distance)? invalidCheckout,
    TResult Function(String reason, String? reportedAt, bool isReportSolved)?
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
}

abstract class LateProblem extends Problem {
  const factory LateProblem(
      {final int actualMinutes,
      final int payrollMinutes,
      final bool isPayrollAdjusted}) = _$LateProblemImpl;
  const LateProblem._() : super._();

  int get actualMinutes;
  int get payrollMinutes;
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
  $Res call({int actualMinutes, int payrollMinutes, bool isPayrollAdjusted});
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

class _$OvertimeProblemImpl extends OvertimeProblem {
  const _$OvertimeProblemImpl(
      {this.actualMinutes = 0,
      this.payrollMinutes = 0,
      this.isPayrollAdjusted = false})
      : super._();

  @override
  @JsonKey()
  final int actualMinutes;
  @override
  @JsonKey()
  final int payrollMinutes;
  @override
  @JsonKey()
  final bool isPayrollAdjusted;

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
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)
        late,
    required TResult Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)
        overtime,
    required TResult Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)
        earlyLeave,
    required TResult Function() absence,
    required TResult Function() noCheckout,
    required TResult Function(int distance) invalidCheckin,
    required TResult Function(int distance) invalidCheckout,
    required TResult Function(
            String reason, String? reportedAt, bool isReportSolved)
        reported,
  }) {
    return overtime(actualMinutes, payrollMinutes, isPayrollAdjusted);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)?
        late,
    TResult? Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)?
        overtime,
    TResult? Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)?
        earlyLeave,
    TResult? Function()? absence,
    TResult? Function()? noCheckout,
    TResult? Function(int distance)? invalidCheckin,
    TResult? Function(int distance)? invalidCheckout,
    TResult? Function(String reason, String? reportedAt, bool isReportSolved)?
        reported,
  }) {
    return overtime?.call(actualMinutes, payrollMinutes, isPayrollAdjusted);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)?
        late,
    TResult Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)?
        overtime,
    TResult Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)?
        earlyLeave,
    TResult Function()? absence,
    TResult Function()? noCheckout,
    TResult Function(int distance)? invalidCheckin,
    TResult Function(int distance)? invalidCheckout,
    TResult Function(String reason, String? reportedAt, bool isReportSolved)?
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
}

abstract class OvertimeProblem extends Problem {
  const factory OvertimeProblem(
      {final int actualMinutes,
      final int payrollMinutes,
      final bool isPayrollAdjusted}) = _$OvertimeProblemImpl;
  const OvertimeProblem._() : super._();

  int get actualMinutes;
  int get payrollMinutes;
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
  $Res call({int actualMinutes, int payrollMinutes, bool isPayrollAdjusted});
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

class _$EarlyLeaveProblemImpl extends EarlyLeaveProblem {
  const _$EarlyLeaveProblemImpl(
      {this.actualMinutes = 0,
      this.payrollMinutes = 0,
      this.isPayrollAdjusted = false})
      : super._();

  @override
  @JsonKey()
  final int actualMinutes;
  @override
  @JsonKey()
  final int payrollMinutes;
  @override
  @JsonKey()
  final bool isPayrollAdjusted;

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
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)
        late,
    required TResult Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)
        overtime,
    required TResult Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)
        earlyLeave,
    required TResult Function() absence,
    required TResult Function() noCheckout,
    required TResult Function(int distance) invalidCheckin,
    required TResult Function(int distance) invalidCheckout,
    required TResult Function(
            String reason, String? reportedAt, bool isReportSolved)
        reported,
  }) {
    return earlyLeave(actualMinutes, payrollMinutes, isPayrollAdjusted);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)?
        late,
    TResult? Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)?
        overtime,
    TResult? Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)?
        earlyLeave,
    TResult? Function()? absence,
    TResult? Function()? noCheckout,
    TResult? Function(int distance)? invalidCheckin,
    TResult? Function(int distance)? invalidCheckout,
    TResult? Function(String reason, String? reportedAt, bool isReportSolved)?
        reported,
  }) {
    return earlyLeave?.call(actualMinutes, payrollMinutes, isPayrollAdjusted);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)?
        late,
    TResult Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)?
        overtime,
    TResult Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)?
        earlyLeave,
    TResult Function()? absence,
    TResult Function()? noCheckout,
    TResult Function(int distance)? invalidCheckin,
    TResult Function(int distance)? invalidCheckout,
    TResult Function(String reason, String? reportedAt, bool isReportSolved)?
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
}

abstract class EarlyLeaveProblem extends Problem {
  const factory EarlyLeaveProblem(
      {final int actualMinutes,
      final int payrollMinutes,
      final bool isPayrollAdjusted}) = _$EarlyLeaveProblemImpl;
  const EarlyLeaveProblem._() : super._();

  int get actualMinutes;
  int get payrollMinutes;
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

class _$AbsenceProblemImpl extends AbsenceProblem {
  const _$AbsenceProblemImpl() : super._();

  @override
  String toString() {
    return 'Problem.absence()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$AbsenceProblemImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)
        late,
    required TResult Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)
        overtime,
    required TResult Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)
        earlyLeave,
    required TResult Function() absence,
    required TResult Function() noCheckout,
    required TResult Function(int distance) invalidCheckin,
    required TResult Function(int distance) invalidCheckout,
    required TResult Function(
            String reason, String? reportedAt, bool isReportSolved)
        reported,
  }) {
    return absence();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)?
        late,
    TResult? Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)?
        overtime,
    TResult? Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)?
        earlyLeave,
    TResult? Function()? absence,
    TResult? Function()? noCheckout,
    TResult? Function(int distance)? invalidCheckin,
    TResult? Function(int distance)? invalidCheckout,
    TResult? Function(String reason, String? reportedAt, bool isReportSolved)?
        reported,
  }) {
    return absence?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)?
        late,
    TResult Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)?
        overtime,
    TResult Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)?
        earlyLeave,
    TResult Function()? absence,
    TResult Function()? noCheckout,
    TResult Function(int distance)? invalidCheckin,
    TResult Function(int distance)? invalidCheckout,
    TResult Function(String reason, String? reportedAt, bool isReportSolved)?
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
}

abstract class AbsenceProblem extends Problem {
  const factory AbsenceProblem() = _$AbsenceProblemImpl;
  const AbsenceProblem._() : super._();
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

class _$NoCheckoutProblemImpl extends NoCheckoutProblem {
  const _$NoCheckoutProblemImpl() : super._();

  @override
  String toString() {
    return 'Problem.noCheckout()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$NoCheckoutProblemImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)
        late,
    required TResult Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)
        overtime,
    required TResult Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)
        earlyLeave,
    required TResult Function() absence,
    required TResult Function() noCheckout,
    required TResult Function(int distance) invalidCheckin,
    required TResult Function(int distance) invalidCheckout,
    required TResult Function(
            String reason, String? reportedAt, bool isReportSolved)
        reported,
  }) {
    return noCheckout();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)?
        late,
    TResult? Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)?
        overtime,
    TResult? Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)?
        earlyLeave,
    TResult? Function()? absence,
    TResult? Function()? noCheckout,
    TResult? Function(int distance)? invalidCheckin,
    TResult? Function(int distance)? invalidCheckout,
    TResult? Function(String reason, String? reportedAt, bool isReportSolved)?
        reported,
  }) {
    return noCheckout?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)?
        late,
    TResult Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)?
        overtime,
    TResult Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)?
        earlyLeave,
    TResult Function()? absence,
    TResult Function()? noCheckout,
    TResult Function(int distance)? invalidCheckin,
    TResult Function(int distance)? invalidCheckout,
    TResult Function(String reason, String? reportedAt, bool isReportSolved)?
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
}

abstract class NoCheckoutProblem extends Problem {
  const factory NoCheckoutProblem() = _$NoCheckoutProblemImpl;
  const NoCheckoutProblem._() : super._();
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

class _$InvalidCheckinProblemImpl extends InvalidCheckinProblem {
  const _$InvalidCheckinProblemImpl({this.distance = 0}) : super._();

  @override
  @JsonKey()
  final int distance;

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
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)
        late,
    required TResult Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)
        overtime,
    required TResult Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)
        earlyLeave,
    required TResult Function() absence,
    required TResult Function() noCheckout,
    required TResult Function(int distance) invalidCheckin,
    required TResult Function(int distance) invalidCheckout,
    required TResult Function(
            String reason, String? reportedAt, bool isReportSolved)
        reported,
  }) {
    return invalidCheckin(distance);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)?
        late,
    TResult? Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)?
        overtime,
    TResult? Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)?
        earlyLeave,
    TResult? Function()? absence,
    TResult? Function()? noCheckout,
    TResult? Function(int distance)? invalidCheckin,
    TResult? Function(int distance)? invalidCheckout,
    TResult? Function(String reason, String? reportedAt, bool isReportSolved)?
        reported,
  }) {
    return invalidCheckin?.call(distance);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)?
        late,
    TResult Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)?
        overtime,
    TResult Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)?
        earlyLeave,
    TResult Function()? absence,
    TResult Function()? noCheckout,
    TResult Function(int distance)? invalidCheckin,
    TResult Function(int distance)? invalidCheckout,
    TResult Function(String reason, String? reportedAt, bool isReportSolved)?
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
}

abstract class InvalidCheckinProblem extends Problem {
  const factory InvalidCheckinProblem({final int distance}) =
      _$InvalidCheckinProblemImpl;
  const InvalidCheckinProblem._() : super._();

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

class _$InvalidCheckoutProblemImpl extends InvalidCheckoutProblem {
  const _$InvalidCheckoutProblemImpl({this.distance = 0}) : super._();

  @override
  @JsonKey()
  final int distance;

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
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)
        late,
    required TResult Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)
        overtime,
    required TResult Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)
        earlyLeave,
    required TResult Function() absence,
    required TResult Function() noCheckout,
    required TResult Function(int distance) invalidCheckin,
    required TResult Function(int distance) invalidCheckout,
    required TResult Function(
            String reason, String? reportedAt, bool isReportSolved)
        reported,
  }) {
    return invalidCheckout(distance);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)?
        late,
    TResult? Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)?
        overtime,
    TResult? Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)?
        earlyLeave,
    TResult? Function()? absence,
    TResult? Function()? noCheckout,
    TResult? Function(int distance)? invalidCheckin,
    TResult? Function(int distance)? invalidCheckout,
    TResult? Function(String reason, String? reportedAt, bool isReportSolved)?
        reported,
  }) {
    return invalidCheckout?.call(distance);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)?
        late,
    TResult Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)?
        overtime,
    TResult Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)?
        earlyLeave,
    TResult Function()? absence,
    TResult Function()? noCheckout,
    TResult Function(int distance)? invalidCheckin,
    TResult Function(int distance)? invalidCheckout,
    TResult Function(String reason, String? reportedAt, bool isReportSolved)?
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
}

abstract class InvalidCheckoutProblem extends Problem {
  const factory InvalidCheckoutProblem({final int distance}) =
      _$InvalidCheckoutProblemImpl;
  const InvalidCheckoutProblem._() : super._();

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
  $Res call({String reason, String? reportedAt, bool isReportSolved});
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

class _$ReportedProblemImpl extends ReportedProblem {
  const _$ReportedProblemImpl(
      {this.reason = '', this.reportedAt, this.isReportSolved = false})
      : super._();

  @override
  @JsonKey()
  final String reason;
  @override
  final String? reportedAt;
  @override
  @JsonKey()
  final bool isReportSolved;

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
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)
        late,
    required TResult Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)
        overtime,
    required TResult Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)
        earlyLeave,
    required TResult Function() absence,
    required TResult Function() noCheckout,
    required TResult Function(int distance) invalidCheckin,
    required TResult Function(int distance) invalidCheckout,
    required TResult Function(
            String reason, String? reportedAt, bool isReportSolved)
        reported,
  }) {
    return reported(reason, reportedAt, isReportSolved);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)?
        late,
    TResult? Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)?
        overtime,
    TResult? Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)?
        earlyLeave,
    TResult? Function()? absence,
    TResult? Function()? noCheckout,
    TResult? Function(int distance)? invalidCheckin,
    TResult? Function(int distance)? invalidCheckout,
    TResult? Function(String reason, String? reportedAt, bool isReportSolved)?
        reported,
  }) {
    return reported?.call(reason, reportedAt, isReportSolved);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)?
        late,
    TResult Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)?
        overtime,
    TResult Function(
            int actualMinutes, int payrollMinutes, bool isPayrollAdjusted)?
        earlyLeave,
    TResult Function()? absence,
    TResult Function()? noCheckout,
    TResult Function(int distance)? invalidCheckin,
    TResult Function(int distance)? invalidCheckout,
    TResult Function(String reason, String? reportedAt, bool isReportSolved)?
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
}

abstract class ReportedProblem extends Problem {
  const factory ReportedProblem(
      {final String reason,
      final String? reportedAt,
      final bool isReportSolved}) = _$ReportedProblemImpl;
  const ReportedProblem._() : super._();

  String get reason;
  String? get reportedAt;
  bool get isReportSolved;

  /// Create a copy of Problem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReportedProblemImplCopyWith<_$ReportedProblemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
