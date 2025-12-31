import 'package:freezed_annotation/freezed_annotation.dart';

part 'problem_details.freezed.dart';

/// ProblemDetails Entity - 시프트 문제 상세 정보
///
/// problem_details_v2 JSONB에서 매핑됨
/// 모든 문제 관련 정보를 하나의 객체로 통합
///
/// Note: JSON serialization is handled by ProblemDetailsModel in data layer
@freezed
class ProblemDetails with _$ProblemDetails {
  const ProblemDetails._();

  const factory ProblemDetails({
    // 빠른 필터링용 플래그
    @Default(false) bool hasLate,
    @Default(false) bool hasAbsence,
    @Default(false) bool hasOvertime,
    @Default(false) bool hasEarlyLeave,
    @Default(false) bool hasNoCheckout,
    @Default(false) bool hasLocationIssue,
    @Default(false) bool hasReported,

    // 상태
    @Default(false) bool isSolved,
    @Default(0) int problemCount,
    String? detectedAt,

    // 상세 문제 목록
    @Default([]) List<Problem> problems,
  }) = _ProblemDetails;

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
///
/// Note: JSON serialization is handled by ProblemItemModel in data layer
@Freezed()
sealed class Problem with _$Problem {
  const Problem._();

  const factory Problem.late({
    @Default(0) int actualMinutes,
    @Default(0) int payrollMinutes,
    @Default(false) bool isPayrollAdjusted,
  }) = LateProblem;

  const factory Problem.overtime({
    @Default(0) int actualMinutes,
    @Default(0) int payrollMinutes,
    @Default(false) bool isPayrollAdjusted,
  }) = OvertimeProblem;

  const factory Problem.earlyLeave({
    @Default(0) int actualMinutes,
    @Default(0) int payrollMinutes,
    @Default(false) bool isPayrollAdjusted,
  }) = EarlyLeaveProblem;

  const factory Problem.absence() = AbsenceProblem;

  const factory Problem.noCheckout() = NoCheckoutProblem;

  const factory Problem.invalidCheckin({
    @Default(0) int distance,
  }) = InvalidCheckinProblem;

  const factory Problem.invalidCheckout({
    @Default(0) int distance,
  }) = InvalidCheckoutProblem;

  const factory Problem.reported({
    @Default('') String reason,
    String? reportedAt,
    @Default(false) bool isReportSolved,
  }) = ReportedProblem;
}

