import '../../domain/entities/bulk_approval_result.dart';

/// Bulk Approval Result Model (DTO + Mapper)
class BulkApprovalResultModel {
  final int totalProcessed;
  final int successCount;
  final int failureCount;
  final List<String> successfulIds;
  final List<BulkApprovalErrorModel> errors;

  const BulkApprovalResultModel({
    required this.totalProcessed,
    required this.successCount,
    required this.failureCount,
    required this.successfulIds,
    required this.errors,
  });

  factory BulkApprovalResultModel.fromJson(Map<String, dynamic> json) {
    return BulkApprovalResultModel(
      totalProcessed: json['total_processed'] as int? ?? 0,
      successCount: json['success_count'] as int? ?? 0,
      failureCount: json['failure_count'] as int? ?? 0,
      successfulIds: (json['successful_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      errors: (json['errors'] as List<dynamic>?)
              ?.map((e) => BulkApprovalErrorModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_processed': totalProcessed,
      'success_count': successCount,
      'failure_count': failureCount,
      'successful_ids': successfulIds,
      'errors': errors.map((e) => e.toJson()).toList(),
    };
  }

  BulkApprovalResult toEntity() {
    return BulkApprovalResult(
      totalProcessed: totalProcessed,
      successCount: successCount,
      failureCount: failureCount,
      successfulIds: successfulIds,
      errors: errors.map((e) => e.toEntity()).toList(),
    );
  }

  factory BulkApprovalResultModel.fromEntity(BulkApprovalResult entity) {
    return BulkApprovalResultModel(
      totalProcessed: entity.totalProcessed,
      successCount: entity.successCount,
      failureCount: entity.failureCount,
      successfulIds: entity.successfulIds,
      errors: entity.errors.map((e) => BulkApprovalErrorModel.fromEntity(e)).toList(),
    );
  }
}

class BulkApprovalErrorModel {
  final String shiftRequestId;
  final String errorMessage;
  final String? errorCode;

  const BulkApprovalErrorModel({
    required this.shiftRequestId,
    required this.errorMessage,
    this.errorCode,
  });

  factory BulkApprovalErrorModel.fromJson(Map<String, dynamic> json) {
    return BulkApprovalErrorModel(
      shiftRequestId: json['shift_request_id'] as String? ?? '',
      errorMessage: json['error_message'] as String? ?? '',
      errorCode: json['error_code'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'shift_request_id': shiftRequestId,
      'error_message': errorMessage,
      if (errorCode != null) 'error_code': errorCode,
    };
  }

  BulkApprovalError toEntity() {
    return BulkApprovalError(
      shiftRequestId: shiftRequestId,
      errorMessage: errorMessage,
      errorCode: errorCode,
    );
  }

  factory BulkApprovalErrorModel.fromEntity(BulkApprovalError entity) {
    return BulkApprovalErrorModel(
      shiftRequestId: entity.shiftRequestId,
      errorMessage: entity.errorMessage,
      errorCode: entity.errorCode,
    );
  }
}
