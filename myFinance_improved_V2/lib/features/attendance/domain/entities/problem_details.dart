import 'package:freezed_annotation/freezed_annotation.dart';

part 'problem_details.freezed.dart';
part 'problem_details.g.dart';

/// ProblemDetails Entity - 시프트 문제 상세 정보
///
/// problem_details_v2 JSONB에서 매핑됨
/// 모든 문제 관련 정보를 하나의 객체로 통합
@freezed
class ProblemDetails with _$ProblemDetails {
  const ProblemDetails._();

  const factory ProblemDetails({
    // 빠른 필터링용 플래그
    @JsonKey(name: 'has_late') @Default(false) bool hasLate,
    @JsonKey(name: 'has_absence') @Default(false) bool hasAbsence,
    @JsonKey(name: 'has_overtime') @Default(false) bool hasOvertime,
    @JsonKey(name: 'has_early_leave') @Default(false) bool hasEarlyLeave,
    @JsonKey(name: 'has_no_checkout') @Default(false) bool hasNoCheckout,
    @JsonKey(name: 'has_location_issue') @Default(false) bool hasLocationIssue,
    @JsonKey(name: 'has_reported') @Default(false) bool hasReported,

    // 상태
    @JsonKey(name: 'is_solved') @Default(false) bool isSolved,
    @JsonKey(name: 'problem_count') @Default(0) int problemCount,
    @JsonKey(name: 'detected_at') String? detectedAt,

    // 상세 문제 목록
    @Default([]) List<Problem> problems,
  }) = _ProblemDetails;

  factory ProblemDetails.fromJson(Map<String, dynamic> json) =>
      _$ProblemDetailsFromJson(json);

  /// 문제가 있는지 확인
  bool get hasProblem => problemCount > 0;

  /// 지각 문제 찾기
  LateProblem? get lateProblem {
    for (final p in problems) {
      if (p is LateProblem) return p;
    }
    return null;
  }

  /// 초과근무 문제 찾기
  OvertimeProblem? get overtimeProblem {
    for (final p in problems) {
      if (p is OvertimeProblem) return p;
    }
    return null;
  }

  /// 위치 문제 찾기 (InvalidCheckinProblem 또는 InvalidCheckoutProblem)
  Problem? get locationProblem {
    for (final p in problems) {
      if (p is InvalidCheckinProblem || p is InvalidCheckoutProblem) return p;
    }
    return null;
  }

  /// 신고 문제 찾기
  ReportedProblem? get reportedProblem {
    for (final p in problems) {
      if (p is ReportedProblem) return p;
    }
    return null;
  }

  /// 지각 분 (없으면 0)
  int get lateMinutes => lateProblem?.actualMinutes ?? 0;

  /// 초과근무 분 (없으면 0)
  int get overtimeMinutes => overtimeProblem?.actualMinutes ?? 0;

  /// 조퇴 문제 찾기
  EarlyLeaveProblem? get earlyLeaveProblem {
    for (final p in problems) {
      if (p is EarlyLeaveProblem) return p;
    }
    return null;
  }

  /// 조퇴 분 (없으면 0)
  int get earlyLeaveMinutes => earlyLeaveProblem?.actualMinutes ?? 0;

  /// 체크인 거리 (없으면 null)
  int? get checkinDistance {
    final loc = locationProblem;
    if (loc is InvalidCheckinProblem) {
      return loc.distance;
    }
    return null;
  }
}

/// Problem 베이스 클래스 (Sealed class)
@Freezed(unionKey: 'type')
sealed class Problem with _$Problem {
  const Problem._();

  @FreezedUnionValue('late')
  const factory Problem.late({
    @JsonKey(name: 'actual_minutes') @Default(0) int actualMinutes,
    @JsonKey(name: 'payroll_minutes') @Default(0) int payrollMinutes,
    @JsonKey(name: 'is_payroll_adjusted') @Default(false) bool isPayrollAdjusted,
  }) = LateProblem;

  @FreezedUnionValue('overtime')
  const factory Problem.overtime({
    @JsonKey(name: 'actual_minutes') @Default(0) int actualMinutes,
    @JsonKey(name: 'payroll_minutes') @Default(0) int payrollMinutes,
    @JsonKey(name: 'is_payroll_adjusted') @Default(false) bool isPayrollAdjusted,
  }) = OvertimeProblem;

  @FreezedUnionValue('early_leave')
  const factory Problem.earlyLeave({
    @JsonKey(name: 'actual_minutes') @Default(0) int actualMinutes,
    @JsonKey(name: 'payroll_minutes') @Default(0) int payrollMinutes,
    @JsonKey(name: 'is_payroll_adjusted') @Default(false) bool isPayrollAdjusted,
  }) = EarlyLeaveProblem;

  @FreezedUnionValue('absence')
  const factory Problem.absence() = AbsenceProblem;

  @FreezedUnionValue('no_checkout')
  const factory Problem.noCheckout() = NoCheckoutProblem;

  @FreezedUnionValue('invalid_checkin')
  const factory Problem.invalidCheckin({
    @Default(0) int distance,
  }) = InvalidCheckinProblem;

  @FreezedUnionValue('invalid_checkout')
  const factory Problem.invalidCheckout({
    @Default(0) int distance,
  }) = InvalidCheckoutProblem;

  @FreezedUnionValue('reported')
  const factory Problem.reported({
    @Default('') String reason,
    @JsonKey(name: 'reported_at') String? reportedAt,
    @JsonKey(name: 'is_report_solved') @Default(false) bool isReportSolved,
  }) = ReportedProblem;

  factory Problem.fromJson(Map<String, dynamic> json) => _$ProblemFromJson(json);
}

/// LocationProblem 헬퍼 (invalid_checkin, invalid_checkout 통합)
extension LocationProblemExt on Problem {
  bool get isLocationProblem =>
      this is InvalidCheckinProblem || this is InvalidCheckoutProblem;

  String get type {
    return switch (this) {
      LateProblem() => 'late',
      OvertimeProblem() => 'overtime',
      EarlyLeaveProblem() => 'early_leave',
      AbsenceProblem() => 'absence',
      NoCheckoutProblem() => 'no_checkout',
      InvalidCheckinProblem() => 'invalid_checkin',
      InvalidCheckoutProblem() => 'invalid_checkout',
      ReportedProblem() => 'reported',
    };
  }
}

/// LocationProblem 추상화 (invalid_checkin/invalid_checkout 공통)
typedef LocationProblem = ({String type, int distance});

extension ProblemDetailsLocationExt on ProblemDetails {
  LocationProblem? get locationProblemData {
    for (final p in problems) {
      if (p is InvalidCheckinProblem) {
        return (type: 'invalid_checkin', distance: p.distance);
      }
      if (p is InvalidCheckoutProblem) {
        return (type: 'invalid_checkout', distance: p.distance);
      }
    }
    return null;
  }
}
