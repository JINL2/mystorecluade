/// Bulk Approval Result Entity
///
/// Represents the result of processing multiple shift approval requests
/// in a single batch operation.
class BulkApprovalResult {
  /// Total number of requests processed
  final int totalProcessed;

  /// Number of successfully processed requests
  final int successCount;

  /// Number of failed requests
  final int failureCount;

  /// List of successfully processed shift request IDs
  final List<String> successfulIds;

  /// List of errors encountered during processing
  final List<BulkApprovalError> errors;

  const BulkApprovalResult({
    required this.totalProcessed,
    required this.successCount,
    required this.failureCount,
    required this.successfulIds,
    required this.errors,
  });

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

  /// Copy with method for immutability
  BulkApprovalResult copyWith({
    int? totalProcessed,
    int? successCount,
    int? failureCount,
    List<String>? successfulIds,
    List<BulkApprovalError>? errors,
  }) {
    return BulkApprovalResult(
      totalProcessed: totalProcessed ?? this.totalProcessed,
      successCount: successCount ?? this.successCount,
      failureCount: failureCount ?? this.failureCount,
      successfulIds: successfulIds ?? this.successfulIds,
      errors: errors ?? this.errors,
    );
  }

  @override
  String toString() {
    return 'BulkApprovalResult(total: $totalProcessed, success: $successCount, failed: $failureCount)';
  }
}

/// Bulk Approval Error
///
/// Represents an individual error that occurred during bulk approval processing.
class BulkApprovalError {
  /// The shift request ID that failed
  final String shiftRequestId;

  /// Error message describing what went wrong
  final String errorMessage;

  /// Optional error code
  final String? errorCode;

  const BulkApprovalError({
    required this.shiftRequestId,
    required this.errorMessage,
    this.errorCode,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BulkApprovalError &&
        other.shiftRequestId == shiftRequestId &&
        other.errorMessage == errorMessage &&
        other.errorCode == errorCode;
  }

  @override
  int get hashCode {
    return shiftRequestId.hashCode ^ errorMessage.hashCode ^ errorCode.hashCode;
  }

  @override
  String toString() {
    return 'BulkApprovalError(id: $shiftRequestId, message: $errorMessage)';
  }
}
