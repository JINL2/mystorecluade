import '../../../domain/entities/bulk_approval_result.dart';
import 'bulk_approval_result_dto.dart';

/// Extension to map BulkApprovalResultDto → Domain Entity
extension BulkApprovalResultDtoMapper on BulkApprovalResultDto {
  /// Convert DTO to Domain Entity
  BulkApprovalResult toEntity() {
    return BulkApprovalResult(
      totalProcessed: totalProcessed,
      successCount: successCount,
      failureCount: failureCount,
      successfulIds: successfulIds,
      errors: errors.map((e) => e.toEntity()).toList(),
    );
  }
}

/// Extension to map BulkApprovalErrorDto → Domain Entity
extension BulkApprovalErrorDtoMapper on BulkApprovalErrorDto {
  /// Convert DTO to Domain Entity
  BulkApprovalError toEntity() {
    return BulkApprovalError(
      shiftRequestId: shiftRequestId,
      errorMessage: errorMessage,
      errorCode: errorCode,
    );
  }
}
