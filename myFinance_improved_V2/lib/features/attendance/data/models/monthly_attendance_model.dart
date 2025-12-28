import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/monthly_attendance.dart';

part 'monthly_attendance_model.freezed.dart';
part 'monthly_attendance_model.g.dart';

/// Monthly Attendance DTO (V3)
///
/// RPC 응답을 파싱하여 Domain Entity로 변환
/// V3: scheduled_start_time_utc / scheduled_end_time_utc (TIMESTAMPTZ)
@freezed
class MonthlyAttendanceModel with _$MonthlyAttendanceModel {
  const factory MonthlyAttendanceModel({
    @JsonKey(name: 'attendance_id') required String attendanceId,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'company_id') required String companyId,
    @JsonKey(name: 'store_id') String? storeId,
    @JsonKey(name: 'work_schedule_template_id') String? workScheduleTemplateId,
    @JsonKey(name: 'attendance_date') required String attendanceDate,
    // V3: _utc suffix (TIMESTAMPTZ)
    @JsonKey(name: 'scheduled_start_time_utc') String? scheduledStartTimeUtc,
    @JsonKey(name: 'scheduled_end_time_utc') String? scheduledEndTimeUtc,
    @JsonKey(name: 'check_in_time_utc') String? checkInTimeUtc,
    @JsonKey(name: 'check_out_time_utc') String? checkOutTimeUtc,
    required String status,
    @JsonKey(name: 'is_late') @Default(false) bool isLate,
    @JsonKey(name: 'is_early_leave') @Default(false) bool isEarlyLeave,
    String? notes,
    @JsonKey(name: 'template_name') String? templateName,
    @JsonKey(name: 'day_of_week') int? dayOfWeek,
    String? timezone,
  }) = _MonthlyAttendanceModel;

  const MonthlyAttendanceModel._();

  factory MonthlyAttendanceModel.fromJson(Map<String, dynamic> json) =>
      _$MonthlyAttendanceModelFromJson(json);

  /// Entity 변환
  MonthlyAttendance toEntity() => MonthlyAttendance(
        attendanceId: attendanceId,
        userId: userId,
        companyId: companyId,
        storeId: storeId,
        workScheduleTemplateId: workScheduleTemplateId,
        attendanceDate: DateTime.parse(attendanceDate),
        // V3: DateTime으로 파싱
        scheduledStartTimeUtc: scheduledStartTimeUtc != null
            ? DateTime.parse(scheduledStartTimeUtc!)
            : null,
        scheduledEndTimeUtc: scheduledEndTimeUtc != null
            ? DateTime.parse(scheduledEndTimeUtc!)
            : null,
        checkInTimeUtc:
            checkInTimeUtc != null ? DateTime.parse(checkInTimeUtc!) : null,
        checkOutTimeUtc:
            checkOutTimeUtc != null ? DateTime.parse(checkOutTimeUtc!) : null,
        status: status,
        isLate: isLate,
        isEarlyLeave: isEarlyLeave,
        notes: notes,
        templateName: templateName,
        timezone: timezone,
      );
}

/// Check-in/Check-out 결과 DTO (V3)
@freezed
class MonthlyCheckResultModel with _$MonthlyCheckResultModel {
  const factory MonthlyCheckResultModel({
    required bool success,
    String? error,
    String? message,
    Map<String, dynamic>? data,
  }) = _MonthlyCheckResultModel;

  const MonthlyCheckResultModel._();

  factory MonthlyCheckResultModel.fromJson(Map<String, dynamic> json) =>
      _$MonthlyCheckResultModelFromJson(json);

  /// Entity 변환 (V3: _utc suffix)
  MonthlyCheckResult toEntity() {
    if (!success || data == null) {
      return MonthlyCheckResult(
        success: success,
        error: error,
        message: message,
      );
    }

    return MonthlyCheckResult(
      success: success,
      error: error,
      message: message,
      attendanceId: data!['attendance_id'] as String?,
      attendanceDate: data!['attendance_date'] != null
          ? DateTime.parse(data!['attendance_date'] as String)
          : null,
      checkInTimeUtc: data!['check_in_time_utc'] != null
          ? DateTime.parse(data!['check_in_time_utc'] as String)
          : null,
      checkOutTimeUtc: data!['check_out_time_utc'] != null
          ? DateTime.parse(data!['check_out_time_utc'] as String)
          : null,
      // V3: _utc suffix
      scheduledStartTimeUtc: data!['scheduled_start_time_utc'] != null
          ? DateTime.parse(data!['scheduled_start_time_utc'] as String)
          : null,
      scheduledEndTimeUtc: data!['scheduled_end_time_utc'] != null
          ? DateTime.parse(data!['scheduled_end_time_utc'] as String)
          : null,
      isLate: data!['is_late'] as bool? ?? false,
      isEarlyLeave: data!['is_early_leave'] as bool? ?? false,
      templateName: data!['template_name'] as String?,
      timezone: data!['timezone'] as String?,
    );
  }
}

/// 월간 통계 DTO (V3)
@freezed
class MonthlyAttendanceStatsModel with _$MonthlyAttendanceStatsModel {
  const factory MonthlyAttendanceStatsModel({
    required bool success,
    String? error,
    String? message,
    String? timezone,
    Map<String, dynamic>? period,
    Map<String, dynamic>? today,
    Map<String, dynamic>? stats,
  }) = _MonthlyAttendanceStatsModel;

  const MonthlyAttendanceStatsModel._();

  factory MonthlyAttendanceStatsModel.fromJson(Map<String, dynamic> json) =>
      _$MonthlyAttendanceStatsModelFromJson(json);

  /// Entity 변환 (V3: _utc suffix)
  MonthlyAttendanceStats toEntity() {
    final p = period ?? {};
    final s = stats ?? {};

    MonthlyAttendance? todayAttendance;
    if (today != null && today!.isNotEmpty) {
      // today 데이터를 MonthlyAttendance로 변환 (V3)
      todayAttendance = MonthlyAttendance(
        attendanceId: today!['attendance_id'] as String? ?? '',
        userId: '', // today에는 user_id 없을 수 있음
        companyId: '', // today에는 company_id 없을 수 있음
        attendanceDate: DateTime.now(),
        status: today!['status'] as String? ?? 'scheduled',
        // V3: _utc suffix
        scheduledStartTimeUtc: today!['scheduled_start_time_utc'] != null
            ? DateTime.parse(today!['scheduled_start_time_utc'] as String)
            : null,
        scheduledEndTimeUtc: today!['scheduled_end_time_utc'] != null
            ? DateTime.parse(today!['scheduled_end_time_utc'] as String)
            : null,
        checkInTimeUtc: today!['check_in_time_utc'] != null
            ? DateTime.parse(today!['check_in_time_utc'] as String)
            : null,
        checkOutTimeUtc: today!['check_out_time_utc'] != null
            ? DateTime.parse(today!['check_out_time_utc'] as String)
            : null,
        isLate: today!['is_late'] as bool? ?? false,
        isEarlyLeave: today!['is_early_leave'] as bool? ?? false,
        timezone: timezone,
      );
    }

    return MonthlyAttendanceStats(
      year: p['year'] as int? ?? DateTime.now().year,
      month: p['month'] as int? ?? DateTime.now().month,
      startDate: p['start_date'] != null
          ? DateTime.parse(p['start_date'] as String)
          : DateTime.now(),
      endDate: p['end_date'] != null
          ? DateTime.parse(p['end_date'] as String)
          : DateTime.now(),
      today: todayAttendance,
      completedDays: s['completed_days'] as int? ?? 0,
      workedDays: s['worked_days'] as int? ?? 0,
      absentDays: s['absent_days'] as int? ?? 0,
      lateDays: s['late_days'] as int? ?? 0,
      earlyLeaveDays: s['early_leave_days'] as int? ?? 0,
    );
  }
}

/// 월간 출석 목록 DTO (V3)
@freezed
class MonthlyAttendanceListModel with _$MonthlyAttendanceListModel {
  const factory MonthlyAttendanceListModel({
    required bool success,
    String? error,
    String? message,
    String? timezone,
    Map<String, dynamic>? period,
    @Default(0) int count,
    @Default([]) List<Map<String, dynamic>> data,
  }) = _MonthlyAttendanceListModel;

  const MonthlyAttendanceListModel._();

  factory MonthlyAttendanceListModel.fromJson(Map<String, dynamic> json) =>
      _$MonthlyAttendanceListModelFromJson(json);

  /// Entity 리스트 변환 (V3: _utc suffix)
  List<MonthlyAttendance> toEntityList() {
    return data.map((item) {
      return MonthlyAttendance(
        attendanceId: item['attendance_id'] as String? ?? '',
        userId: item['user_id'] as String? ?? '',
        companyId: item['company_id'] as String? ?? '',
        storeId: item['store_id'] as String?,
        attendanceDate: item['attendance_date'] != null
            ? DateTime.parse(item['attendance_date'] as String)
            : DateTime.now(),
        // V3: _utc suffix
        scheduledStartTimeUtc: item['scheduled_start_time_utc'] != null
            ? DateTime.parse(item['scheduled_start_time_utc'] as String)
            : null,
        scheduledEndTimeUtc: item['scheduled_end_time_utc'] != null
            ? DateTime.parse(item['scheduled_end_time_utc'] as String)
            : null,
        checkInTimeUtc: item['check_in_time_utc'] != null
            ? DateTime.parse(item['check_in_time_utc'] as String)
            : null,
        checkOutTimeUtc: item['check_out_time_utc'] != null
            ? DateTime.parse(item['check_out_time_utc'] as String)
            : null,
        status: item['status'] as String? ?? 'scheduled',
        isLate: item['is_late'] as bool? ?? false,
        isEarlyLeave: item['is_early_leave'] as bool? ?? false,
        notes: item['notes'] as String?,
        timezone: timezone,
      );
    }).toList();
  }
}
