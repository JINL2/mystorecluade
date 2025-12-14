// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'monthly_shift_status_dto.freezed.dart';
part 'monthly_shift_status_dto.g.dart';

/// Monthly Shift Status DTO
///
/// Maps exactly to get_monthly_shift_status_manager_v4 RPC response
/// RPC returns TABLE with these columns:
/// - shift_date (date) - actual work date from start_time_utc
/// - store_id (uuid)
/// - total_required (integer)
/// - total_approved (integer)
/// - total_pending (integer)
/// - shifts (jsonb array)
@freezed
class MonthlyShiftStatusDto with _$MonthlyShiftStatusDto {
  const factory MonthlyShiftStatusDto({
    // RPC TABLE columns (exact names)
    // v4: shift_date (from start_time_utc) instead of request_date
    @JsonKey(name: 'shift_date') required String shiftDate,
    @JsonKey(name: 'store_id') required String storeId,
    @JsonKey(name: 'total_required') @Default(0) int totalRequired,
    @JsonKey(name: 'total_approved') @Default(0) int totalApproved,
    @JsonKey(name: 'total_pending') @Default(0) int totalPending,

    // shifts jsonb array from RPC
    @JsonKey(name: 'shifts') @Default([]) List<ShiftWithEmployeesDto> shifts,
  }) = _MonthlyShiftStatusDto;

  factory MonthlyShiftStatusDto.fromJson(Map<String, dynamic> json) =>
      _$MonthlyShiftStatusDtoFromJson(json);
}

/// Shift With Employees DTO
///
/// Maps to each element in shifts jsonb array from RPC
/// Structure from SQL: jsonb_build_object(...)
@freezed
class ShiftWithEmployeesDto with _$ShiftWithEmployeesDto {
  const factory ShiftWithEmployeesDto({
    // Shift identification
    @JsonKey(name: 'shift_id') required String shiftId,
    @JsonKey(name: 'shift_name') String? shiftName,
    @JsonKey(name: 'required_employees') @Default(0) int requiredEmployees,

    // Shift time range (from RPC: YYYY-MM-DD HH24:MI:SS format in user's timezone)
    @JsonKey(name: 'shift_start_time') String? shiftStartTime,
    @JsonKey(name: 'shift_end_time') String? shiftEndTime,

    // Counts
    @JsonKey(name: 'approved_count') @Default(0) int approvedCount,
    @JsonKey(name: 'pending_count') @Default(0) int pendingCount,

    // Employee arrays from RPC nested SELECT
    @JsonKey(name: 'approved_employees')
    @Default([])
    List<ShiftEmployeeDto> approvedEmployees,

    @JsonKey(name: 'pending_employees')
    @Default([])
    List<ShiftEmployeeDto> pendingEmployees,
  }) = _ShiftWithEmployeesDto;

  factory ShiftWithEmployeesDto.fromJson(Map<String, dynamic> json) =>
      _$ShiftWithEmployeesDtoFromJson(json);
}

/// Shift Employee DTO
///
/// Maps to employee objects in approved_employees/pending_employees arrays
/// From RPC SQL: jsonb_build_object('shift_request_id', ..., 'user_id', ...)
@freezed
class ShiftEmployeeDto with _$ShiftEmployeeDto {
  const factory ShiftEmployeeDto({
    @JsonKey(name: 'shift_request_id') required String shiftRequestId,
    @JsonKey(name: 'user_id') required String userId,
    // user_name can be null when user profile is incomplete
    @JsonKey(name: 'user_name') @Default('Unknown') String userName,
    @JsonKey(name: 'is_approved') @Default(false) bool isApproved,
    @JsonKey(name: 'profile_image') String? profileImage,
  }) = _ShiftEmployeeDto;

  factory ShiftEmployeeDto.fromJson(Map<String, dynamic> json) =>
      _$ShiftEmployeeDtoFromJson(json);
}
