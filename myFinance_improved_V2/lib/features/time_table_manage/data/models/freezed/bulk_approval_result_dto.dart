import 'package:freezed_annotation/freezed_annotation.dart';

part 'bulk_approval_result_dto.freezed.dart';
part 'bulk_approval_result_dto.g.dart';

/// Bulk Approval Result DTO
///
/// Maps to RPC: manager_shift_process_bulk_approval
///
/// Returns the result of bulk approval/rejection operation:
/// - Total processed count
/// - Success/failure counts
/// - List of successful IDs
/// - Error details for failures
@freezed
class BulkApprovalResultDto with _$BulkApprovalResultDto {
  const factory BulkApprovalResultDto({
    /// Total number of shift requests processed
    @JsonKey(name: 'total_processed') @Default(0) int totalProcessed,

    /// Number of successful approvals/rejections
    @JsonKey(name: 'success_count') @Default(0) int successCount,

    /// Number of failed operations
    @JsonKey(name: 'failure_count') @Default(0) int failureCount,

    /// List of successfully processed shift request IDs
    @JsonKey(name: 'successful_ids') @Default([]) List<String> successfulIds,

    /// List of errors for failed operations
    @JsonKey(name: 'errors') @Default([]) List<BulkApprovalErrorDto> errors,
  }) = _BulkApprovalResultDto;

  factory BulkApprovalResultDto.fromJson(Map<String, dynamic> json) =>
      _$BulkApprovalResultDtoFromJson(json);
}

/// Bulk Approval Error DTO
///
/// Represents an individual error in bulk approval operation
@freezed
class BulkApprovalErrorDto with _$BulkApprovalErrorDto {
  const factory BulkApprovalErrorDto({
    /// Shift request ID that failed
    @JsonKey(name: 'shift_request_id') @Default('') String shiftRequestId,

    /// Error message describing the failure
    @JsonKey(name: 'error_message') @Default('') String errorMessage,

    /// Optional error code for categorization
    @JsonKey(name: 'error_code') String? errorCode,
  }) = _BulkApprovalErrorDto;

  factory BulkApprovalErrorDto.fromJson(Map<String, dynamic> json) =>
      _$BulkApprovalErrorDtoFromJson(json);
}
