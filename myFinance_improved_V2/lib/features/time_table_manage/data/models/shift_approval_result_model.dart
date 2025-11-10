import '../../../../core/utils/datetime_utils.dart';
import '../../domain/entities/shift_approval_result.dart';
import 'shift_request_model.dart';

/// Shift Approval Result Model (DTO + Mapper)
class ShiftApprovalResultModel {
  final String shiftRequestId;
  final bool isApproved;
  final String approvedAt;
  final String? approvedBy;
  final ShiftRequestModel updatedRequest;
  final String? message;

  const ShiftApprovalResultModel({
    required this.shiftRequestId,
    required this.isApproved,
    required this.approvedAt,
    this.approvedBy,
    required this.updatedRequest,
    this.message,
  });

  factory ShiftApprovalResultModel.fromJson(Map<String, dynamic> json) {
    return ShiftApprovalResultModel(
      shiftRequestId: json['shift_request_id'] as String? ?? '',
      isApproved: json['is_approved'] as bool? ?? false,
      approvedAt: json['approved_at'] as String? ?? '',
      approvedBy: json['approved_by'] as String?,
      updatedRequest: ShiftRequestModel.fromJson(
        json['updated_request'] as Map<String, dynamic>? ?? {},
      ),
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'shift_request_id': shiftRequestId,
      'is_approved': isApproved,
      'approved_at': approvedAt,
      if (approvedBy != null) 'approved_by': approvedBy,
      'updated_request': updatedRequest.toJson(),
      if (message != null) 'message': message,
    };
  }

  ShiftApprovalResult toEntity() {
    return ShiftApprovalResult(
      shiftRequestId: shiftRequestId,
      isApproved: isApproved,
      approvedAt: DateTimeUtils.toLocal(approvedAt),
      approvedBy: approvedBy,
      updatedRequest: updatedRequest.toEntity(),
      message: message,
    );
  }

  factory ShiftApprovalResultModel.fromEntity(ShiftApprovalResult entity) {
    return ShiftApprovalResultModel(
      shiftRequestId: entity.shiftRequestId,
      isApproved: entity.isApproved,
      approvedAt: DateTimeUtils.toUtc(entity.approvedAt),
      approvedBy: entity.approvedBy,
      updatedRequest: ShiftRequestModel.fromEntity(entity.updatedRequest),
      message: entity.message,
    );
  }
}
