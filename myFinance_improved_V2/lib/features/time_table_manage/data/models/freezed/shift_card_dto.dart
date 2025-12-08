// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import '../converters/shift_time_converter.dart';

part 'shift_card_dto.freezed.dart';
part 'shift_card_dto.g.dart';

/// Shift Card DTO
///
/// Maps exactly to manager_shift_get_cards_v3 RPC response
/// v3: Uses shift_date (from start_time_utc) instead of request_date
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
