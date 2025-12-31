import 'manager_memo.dart';

/// Attention Type
///
/// 별도 파일로 분리하여 DCM이 위젯과 데이터 클래스를 혼동하지 않도록 함
enum AttentionType {
  late,
  understaffed,
  overtime,
  reported,
  noCheckIn,
  noCheckOut,
  earlyCheckOut,
}

/// Attention Item Data
///
/// 주의가 필요한 항목의 데이터를 담는 클래스
/// - Late: 지각
/// - Understaffed: 인원 부족
/// - Overtime: 초과 근무
/// - Reported: 신고됨
/// - NoCheckIn/NoCheckOut: 출퇴근 미기록
/// - EarlyCheckOut: 조기 퇴근
class AttentionItemData {
  final AttentionType type;
  final String title;
  final String date;
  final String time;
  final String subtext;

  // Staff-specific fields for navigation to detail page
  final String? staffId;
  final String? shiftRequestId;
  final String? clockIn;
  final String? clockOut;
  final bool isLate;
  final bool isOvertime;
  final bool isConfirmed;
  final String? actualStart;
  final String? actualEnd;
  final String? confirmStartTime;
  final String? confirmEndTime;
  final bool isReported;
  final String? reportReason;
  final bool isProblemSolved;
  final double bonusAmount;
  final String? salaryType;
  final String? salaryAmount;
  final String? basePay;
  final String? totalPayWithBonus;
  final double paidHour;
  final int lateMinute;
  final int overtimeMinute;
  final String? avatarUrl;
  final DateTime? shiftDate;
  final String? shiftName;
  final String? shiftTimeRange;
  final bool isShiftProblem; // True if understaffed, false if staff problem
  final DateTime? shiftEndTime;

  // v4: New fields
  final bool? isReportedSolved;
  final List<ManagerMemo> managerMemos;

  AttentionItemData({
    required this.type,
    required this.title,
    required this.date,
    required this.time,
    required this.subtext,
    this.staffId,
    this.shiftRequestId,
    this.clockIn,
    this.clockOut,
    this.isLate = false,
    this.isOvertime = false,
    this.isConfirmed = false,
    this.actualStart,
    this.actualEnd,
    this.confirmStartTime,
    this.confirmEndTime,
    this.isReported = false,
    this.reportReason,
    this.isProblemSolved = false,
    this.bonusAmount = 0.0,
    this.salaryType,
    this.salaryAmount,
    this.basePay,
    this.totalPayWithBonus,
    this.paidHour = 0.0,
    this.lateMinute = 0,
    this.overtimeMinute = 0,
    this.avatarUrl,
    this.shiftDate,
    this.shiftName,
    this.shiftTimeRange,
    this.isShiftProblem = false,
    this.shiftEndTime,
    // v4: New fields
    this.isReportedSolved,
    this.managerMemos = const [],
  });
}
