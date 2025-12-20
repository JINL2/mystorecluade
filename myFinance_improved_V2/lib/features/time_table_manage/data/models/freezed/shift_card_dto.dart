// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import '../converters/shift_time_converter.dart';

part 'shift_card_dto.freezed.dart';
part 'shift_card_dto.g.dart';

/// Shift Card DTO
///
/// Maps exactly to manager_shift_get_cards_v4 RPC response
/// v3: Uses shift_date (from start_time_utc) instead of request_date
/// v4: Adds is_reported_solved (bool), manager_memo (jsonb array)
/// RPC Field Names → Dart Properties (with @JsonKey)
@freezed
class ShiftCardDto with _$ShiftCardDto {
  const factory ShiftCardDto({
    // Core identification
    // v3: shift_date (actual work date from start_time_utc) instead of request_date
    // Made nullable with defaults to handle empty RPC responses
    @JsonKey(name: 'shift_date') @Default('') String shiftDate,
    @JsonKey(name: 'shift_request_id') @Default('') String shiftRequestId,

    // User information
    @JsonKey(name: 'user_id') @Default('') String userId,
    @JsonKey(name: 'user_name') @Default('') String userName,
    @JsonKey(name: 'profile_image') String? profileImage,

    // Shift information
    @JsonKey(name: 'shift_name') String? shiftName,
    @JsonKey(name: 'shift_time') @ShiftTimeConverter() ShiftTime? shiftTime,
    // Shift start/end time (NEW: "2025-12-05 14:00" format)
    @JsonKey(name: 'shift_start_time') String? shiftStartTime,
    @JsonKey(name: 'shift_end_time') String? shiftEndTime,

    // Approval status
    @JsonKey(name: 'is_approved') @Default(false) bool isApproved,
    @JsonKey(name: 'is_problem') @Default(false) bool isProblem,
    @JsonKey(name: 'is_problem_solved') @Default(false) bool isProblemSolved,

    // Time tracking
    @JsonKey(name: 'is_late') @Default(false) bool isLate,
    @JsonKey(name: 'late_minute') @Default(0) int lateMinute,
    @JsonKey(name: 'is_over_time') @Default(false) bool isOverTime,
    @JsonKey(name: 'over_time_minute') @Default(0) int overTimeMinute,
    @JsonKey(name: 'paid_hour') @Default(0.0) double paidHour,

    // Salary information (NEW in RPC)
    @JsonKey(name: 'salary_type') String? salaryType,
    @JsonKey(name: 'salary_amount') String? salaryAmount,
    @JsonKey(name: 'base_pay') String? basePay,
    @JsonKey(name: 'total_pay_with_bonus') String? totalPayWithBonus,

    // Bonus information
    @JsonKey(name: 'bonus_amount') @Default(0.0) double bonusAmount,

    // Time records (HH:MM:SS or HH:MM format from RPC)
    @JsonKey(name: 'actual_start') String? actualStart,
    @JsonKey(name: 'actual_end') String? actualEnd,
    @JsonKey(name: 'confirm_start_time') String? confirmStartTime,
    @JsonKey(name: 'confirm_end_time') String? confirmEndTime,

    // Tags (jsonb array in RPC)
    @JsonKey(name: 'notice_tag') @Default([]) List<TagDto> noticeTags,

    // Problem details
    @JsonKey(name: 'problem_type') String? problemType,
    @JsonKey(name: 'is_reported') @Default(false) bool isReported,
    @JsonKey(name: 'report_reason') String? reportReason,

    // v4: Report resolution status
    @JsonKey(name: 'is_reported_solved') bool? isReportedSolved,

    // v4: Manager memos (jsonb array)
    @JsonKey(name: 'manager_memo') @Default([]) List<ManagerMemoDto> managerMemos,

    // v5: Problem details (jsonb)
    @JsonKey(name: 'problem_details') ProblemDetailsDto? problemDetails,

    // Location validation (NEW in RPC)
    @JsonKey(name: 'is_valid_checkin_location') bool? isValidCheckinLocation,
    @JsonKey(name: 'checkin_distance_from_store') @Default(0.0) double checkinDistanceFromStore,
    @JsonKey(name: 'is_valid_checkout_location') bool? isValidCheckoutLocation,
    @JsonKey(name: 'checkout_distance_from_store') @Default(0.0) double checkoutDistanceFromStore,

    // Store information
    @JsonKey(name: 'store_name') String? storeName,
  }) = _ShiftCardDto;

  factory ShiftCardDto.fromJson(Map<String, dynamic> json) =>
      _$ShiftCardDtoFromJson(json);
}

/// Tag DTO
///
/// Maps to notice_tag jsonb array from RPC
@freezed
class TagDto with _$TagDto {
  const factory TagDto({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'type') String? type,
    @JsonKey(name: 'content') String? content,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'created_by') String? createdBy,
    @JsonKey(name: 'created_by_name') String? createdByName,
  }) = _TagDto;

  factory TagDto.fromJson(Map<String, dynamic> json) =>
      _$TagDtoFromJson(json);
}

/// Manager Memo DTO
///
/// Maps to manager_memo jsonb array from RPC v4
/// Structure: {"type": "note", "content": "...", "created_at": "...", "created_by": "..."}
@freezed
class ManagerMemoDto with _$ManagerMemoDto {
  const factory ManagerMemoDto({
    @JsonKey(name: 'type') String? type,
    @JsonKey(name: 'content') String? content,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'created_by') String? createdBy,
  }) = _ManagerMemoDto;

  factory ManagerMemoDto.fromJson(Map<String, dynamic> json) =>
      _$ManagerMemoDtoFromJson(json);
}

/// Problem Details DTO
///
/// Maps to problem_details jsonb from RPC v5
/// Contains detailed problem information with types and minutes
@freezed
class ProblemDetailsDto with _$ProblemDetailsDto {
  const factory ProblemDetailsDto({
    @JsonKey(name: 'has_late') @Default(false) bool hasLate,
    @JsonKey(name: 'has_overtime') @Default(false) bool hasOvertime,
    @JsonKey(name: 'has_reported') @Default(false) bool hasReported,
    @JsonKey(name: 'has_no_checkout') @Default(false) bool hasNoCheckout,
    @JsonKey(name: 'has_absence') @Default(false) bool hasAbsence,
    @JsonKey(name: 'has_early_leave') @Default(false) bool hasEarlyLeave,
    @JsonKey(name: 'has_location_issue') @Default(false) bool hasLocationIssue,
    @JsonKey(name: 'has_payroll_late') @Default(false) bool hasPayrollLate,
    @JsonKey(name: 'has_payroll_overtime') @Default(false) bool hasPayrollOvertime,
    @JsonKey(name: 'has_payroll_early_leave') @Default(false) bool hasPayrollEarlyLeave,
    @JsonKey(name: 'problem_count') @Default(0) int problemCount,
    @JsonKey(name: 'is_solved') @Default(false) bool isSolved,
    @JsonKey(name: 'detected_at') String? detectedAt,
    @JsonKey(name: 'problems') @Default([]) List<ProblemItemDto> problems,
  }) = _ProblemDetailsDto;

  factory ProblemDetailsDto.fromJson(Map<String, dynamic> json) =>
      _$ProblemDetailsDtoFromJson(json);
}

/// Problem Item DTO
///
/// Individual problem entry in problems array
/// Types: "late", "overtime", "reported", "no_checkout", "early_leave", etc.
@freezed
class ProblemItemDto with _$ProblemItemDto {
  const factory ProblemItemDto({
    @JsonKey(name: 'type') String? type,
    @JsonKey(name: 'actual_minutes') int? actualMinutes,
    @JsonKey(name: 'payroll_minutes') int? payrollMinutes,
    @JsonKey(name: 'is_payroll_adjusted') @Default(false) bool isPayrollAdjusted,
    // For reported type
    @JsonKey(name: 'reason') String? reason,
    @JsonKey(name: 'reported_at') String? reportedAt,
    @JsonKey(name: 'is_report_solved') @Default(false) bool isReportSolved,
  }) = _ProblemItemDto;

  factory ProblemItemDto.fromJson(Map<String, dynamic> json) =>
      _$ProblemItemDtoFromJson(json);
}
