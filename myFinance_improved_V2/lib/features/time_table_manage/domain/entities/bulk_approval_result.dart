import 'package:freezed_annotation/freezed_annotation.dart';

part 'bulk_approval_result.freezed.dart';
part 'bulk_approval_result.g.dart';

/// Bulk Approval Result Entity
///
/// Represents the result of processing multiple shift approval requests
/// in a single batch operation.
@freezed
class BulkApprovalResult with _$BulkApprovalResult {
  const BulkApprovalResult._();

  const factory BulkApprovalResult({
    /// Total number of requests processed
    @JsonKey(name: 'total_processed')
    required int totalProcessed,

    /// Number of successfully processed requests
    @JsonKey(name: 'success_count')
    required int successCount,

    /// Number of failed requests
    @JsonKey(name: 'failure_count')
    required int failureCount,

    /// List of successfully processed shift request IDs
    @JsonKey(name: 'successful_ids', defaultValue: <String>[])
    required List<String> successfulIds,

    /// List of errors encountered during processing
    @JsonKey(defaultValue: <BulkApprovalError>[])
    required List<BulkApprovalError> errors,
  }) = _BulkApprovalResult;

  /// Create from JSON
  factory BulkApprovalResult.fromJson(Map<String, dynamic> json) =>
      _$BulkApprovalResultFromJson(json);

  /// Check if there were any errors
  bool get hasErrors => errors.isNotEmpty;

  /// Check if all requests succeeded
  bool get allSuccess => failureCount == 0 && successCount == totalProcessed;

  /// Check if all requests failed
  bool get allFailed => successCount == 0 && failureCount == totalProcessed;

  /// Check if some requests succeeded and some failed
  bool get partialSuccess => successCount > 0 && failureCount > 0;

  /// Get success rate as percentage
  double get successRate {
    if (totalProcessed == 0) return 0.0;
    return (successCount / totalProcessed) * 100;
  }

  /// Get error messages as a list of strings
  List<String> get errorMessages {
    return errors.map((e) => e.errorMessage).toList();
  }
}

/// Bulk Approval Error
///
/// Represents an individual error that occurred during bulk approval processing.
@freezed
class BulkApprovalError with _$BulkApprovalError {
  const factory BulkApprovalError({
    /// The shift request ID that failed
    @JsonKey(name: 'shift_request_id')
    required String shiftRequestId,

    /// Error message describing what went wrong
    @JsonKey(name: 'error_message')
    required String errorMessage,

    /// Optional error code
    @JsonKey(name: 'error_code')
    String? errorCode,
  }) = _BulkApprovalError;

  /// Create from JSON
  factory BulkApprovalError.fromJson(Map<String, dynamic> json) =>
      _$BulkApprovalErrorFromJson(json);
}
