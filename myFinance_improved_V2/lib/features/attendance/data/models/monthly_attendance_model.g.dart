// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_attendance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MonthlyAttendanceModelImpl _$$MonthlyAttendanceModelImplFromJson(
        Map<String, dynamic> json) =>
    _$MonthlyAttendanceModelImpl(
      attendanceId: json['attendance_id'] as String,
      userId: json['user_id'] as String,
      companyId: json['company_id'] as String,
      storeId: json['store_id'] as String?,
      workScheduleTemplateId: json['work_schedule_template_id'] as String?,
      attendanceDate: json['attendance_date'] as String,
      scheduledStartTimeUtc: json['scheduled_start_time_utc'] as String?,
      scheduledEndTimeUtc: json['scheduled_end_time_utc'] as String?,
      checkInTimeUtc: json['check_in_time_utc'] as String?,
      checkOutTimeUtc: json['check_out_time_utc'] as String?,
      status: json['status'] as String,
      isLate: json['is_late'] as bool? ?? false,
      isEarlyLeave: json['is_early_leave'] as bool? ?? false,
      notes: json['notes'] as String?,
      templateName: json['template_name'] as String?,
      dayOfWeek: (json['day_of_week'] as num?)?.toInt(),
      timezone: json['timezone'] as String?,
    );

Map<String, dynamic> _$$MonthlyAttendanceModelImplToJson(
        _$MonthlyAttendanceModelImpl instance) =>
    <String, dynamic>{
      'attendance_id': instance.attendanceId,
      'user_id': instance.userId,
      'company_id': instance.companyId,
      'store_id': instance.storeId,
      'work_schedule_template_id': instance.workScheduleTemplateId,
      'attendance_date': instance.attendanceDate,
      'scheduled_start_time_utc': instance.scheduledStartTimeUtc,
      'scheduled_end_time_utc': instance.scheduledEndTimeUtc,
      'check_in_time_utc': instance.checkInTimeUtc,
      'check_out_time_utc': instance.checkOutTimeUtc,
      'status': instance.status,
      'is_late': instance.isLate,
      'is_early_leave': instance.isEarlyLeave,
      'notes': instance.notes,
      'template_name': instance.templateName,
      'day_of_week': instance.dayOfWeek,
      'timezone': instance.timezone,
    };

_$MonthlyCheckResultModelImpl _$$MonthlyCheckResultModelImplFromJson(
        Map<String, dynamic> json) =>
    _$MonthlyCheckResultModelImpl(
      success: json['success'] as bool,
      error: json['error'] as String?,
      message: json['message'] as String?,
      data: json['data'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$MonthlyCheckResultModelImplToJson(
        _$MonthlyCheckResultModelImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'error': instance.error,
      'message': instance.message,
      'data': instance.data,
    };

_$MonthlyAttendanceStatsModelImpl _$$MonthlyAttendanceStatsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$MonthlyAttendanceStatsModelImpl(
      success: json['success'] as bool,
      error: json['error'] as String?,
      message: json['message'] as String?,
      timezone: json['timezone'] as String?,
      period: json['period'] as Map<String, dynamic>?,
      today: json['today'] as Map<String, dynamic>?,
      stats: json['stats'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$MonthlyAttendanceStatsModelImplToJson(
        _$MonthlyAttendanceStatsModelImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'error': instance.error,
      'message': instance.message,
      'timezone': instance.timezone,
      'period': instance.period,
      'today': instance.today,
      'stats': instance.stats,
    };

_$MonthlyAttendanceListModelImpl _$$MonthlyAttendanceListModelImplFromJson(
        Map<String, dynamic> json) =>
    _$MonthlyAttendanceListModelImpl(
      success: json['success'] as bool,
      error: json['error'] as String?,
      message: json['message'] as String?,
      timezone: json['timezone'] as String?,
      period: json['period'] as Map<String, dynamic>?,
      count: (json['count'] as num?)?.toInt() ?? 0,
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$MonthlyAttendanceListModelImplToJson(
        _$MonthlyAttendanceListModelImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'error': instance.error,
      'message': instance.message,
      'timezone': instance.timezone,
      'period': instance.period,
      'count': instance.count,
      'data': instance.data,
    };
