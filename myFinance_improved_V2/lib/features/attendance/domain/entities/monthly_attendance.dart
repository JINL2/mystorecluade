import 'package:freezed_annotation/freezed_annotation.dart';

part 'monthly_attendance.freezed.dart';

/// Monthly 직원 출퇴근 Entity (V3)
///
/// Hourly와 완전 분리된 구조:
/// - Hourly: shift_requests 테이블, 시급 계산 필요
/// - Monthly: monthly_attendance 테이블, 출퇴근 시간만 기록
///
/// V3 변경사항:
/// - scheduledStartTime/EndTime (String) → scheduledStartTimeUtc/EndTimeUtc (DateTime)
/// - 모든 시간이 UTC로 통일되어 Flutter에서 바로 비교 가능
@freezed
class MonthlyAttendance with _$MonthlyAttendance {
  const factory MonthlyAttendance({
    required String attendanceId,
    required String userId,
    required String companyId,
    String? storeId,
    String? workScheduleTemplateId,

    /// 출근 날짜 (로컬 기준)
    required DateTime attendanceDate,

    /// 예정 시간 (UTC) - V3: TIMESTAMPTZ로 변경됨
    /// DB에서 template 시간 + company timezone → UTC로 변환하여 저장
    DateTime? scheduledStartTimeUtc,
    DateTime? scheduledEndTimeUtc,

    /// 실제 출퇴근 시간 (UTC)
    DateTime? checkInTimeUtc,
    DateTime? checkOutTimeUtc,

    /// 상태: scheduled, checked_in, completed, absent, day_off
    required String status,

    /// 문제 플래그 (참고용, 금액 계산 없음)
    @Default(false) bool isLate,
    @Default(false) bool isEarlyLeave,

    /// 메모
    String? notes,

    /// 템플릿 이름 (UI 표시용)
    String? templateName,

    /// 회사 timezone (UI 표시용)
    String? timezone,
  }) = _MonthlyAttendance;

  const MonthlyAttendance._();

  /// 체크인 완료 여부
  bool get isCheckedIn =>
      status == 'checked_in' || status == 'completed';

  /// 체크아웃 완료 여부
  bool get isCheckedOut => status == 'completed';

  /// 현재 근무 중 여부
  bool get isWorking => status == 'checked_in';

  /// 상태 표시 텍스트
  String get statusDisplayText {
    switch (status) {
      case 'scheduled':
        return 'Scheduled';
      case 'checked_in':
        return 'Working';
      case 'completed':
        return 'Completed';
      case 'absent':
        return 'Absent';
      case 'day_off':
        return 'Day Off';
      default:
        return status;
    }
  }
}

/// Monthly 출석 통계 Entity
@freezed
class MonthlyAttendanceStats with _$MonthlyAttendanceStats {
  const factory MonthlyAttendanceStats({
    /// 기간 정보
    required int year,
    required int month,
    required DateTime startDate,
    required DateTime endDate,

    /// 오늘 출석 정보 (null이면 오늘 기록 없음)
    MonthlyAttendance? today,

    /// 통계
    @Default(0) int completedDays,
    @Default(0) int workedDays,
    @Default(0) int absentDays,
    @Default(0) int lateDays,
    @Default(0) int earlyLeaveDays,
  }) = _MonthlyAttendanceStats;
}

/// Check-in/Check-out 결과 Entity (V3)
@freezed
class MonthlyCheckResult with _$MonthlyCheckResult {
  const factory MonthlyCheckResult({
    required bool success,
    String? error,
    String? message,

    /// 성공 시 데이터
    String? attendanceId,
    DateTime? attendanceDate,
    DateTime? checkInTimeUtc,
    DateTime? checkOutTimeUtc,

    /// 예정 시간 (UTC) - V3
    DateTime? scheduledStartTimeUtc,
    DateTime? scheduledEndTimeUtc,

    @Default(false) bool isLate,
    @Default(false) bool isEarlyLeave,
    String? templateName,

    /// 회사 timezone (UI 표시용)
    String? timezone,
  }) = _MonthlyCheckResult;

  const MonthlyCheckResult._();

  /// 체크인 결과인지 (체크아웃이 없으면 체크인)
  bool get isCheckIn => checkOutTimeUtc == null;

  /// 체크아웃 결과인지
  bool get isCheckOut => checkOutTimeUtc != null;
}
