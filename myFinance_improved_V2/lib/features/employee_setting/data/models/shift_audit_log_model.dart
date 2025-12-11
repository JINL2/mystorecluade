import 'package:myfinance_improved/core/utils/datetime_utils.dart';
import '../../domain/entities/shift_audit_log.dart';

/// Data Model: Shift Audit Log Model
///
/// DTO (Data Transfer Object) for ShiftAuditLog with JSON serialization.
/// This model knows how to convert between JSON and Domain Entity.
class ShiftAuditLogModel extends ShiftAuditLog {
  const ShiftAuditLogModel({
    required super.auditId,
    required super.shiftRequestId,
    required super.userId,
    super.storeId,
    super.storeName,
    super.requestDate,
    required super.operation,
    required super.actionType,
    super.changedColumns,
    super.changedBy,
    super.changedByName,
    required super.changedAt,
    super.reason,
    required super.totalCount,
  });

  /// Create model from JSON (Supabase RPC response)
  factory ShiftAuditLogModel.fromJson(Map<String, dynamic> json) {
    // Parse changed_columns which comes as List<dynamic> from Supabase
    List<String>? changedColumns;
    if (json['changed_columns'] != null) {
      changedColumns = (json['changed_columns'] as List<dynamic>)
          .map((e) => e.toString())
          .toList();
    }

    return ShiftAuditLogModel(
      auditId: json['audit_id'] as String? ?? '',
      shiftRequestId: json['shift_request_id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      storeId: json['store_id'] as String?,
      storeName: json['store_name'] as String?,
      requestDate: json['request_date'] != null
          ? DateTime.tryParse(json['request_date'].toString())
          : null,
      operation: json['operation'] as String? ?? 'UPDATE',
      actionType: json['action_type'] as String? ?? 'UNKNOWN',
      changedColumns: changedColumns,
      changedBy: json['changed_by'] as String?,
      changedByName: json['changed_by_name'] as String?,
      changedAt: DateTimeUtils.toLocalSafe(json['changed_at'] as String?) ??
          DateTime.now(),
      reason: json['reason'] as String?,
      totalCount: (json['total_count'] as num?)?.toInt() ?? 0,
    );
  }

  /// Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'audit_id': auditId,
      'shift_request_id': shiftRequestId,
      'user_id': userId,
      'store_id': storeId,
      'store_name': storeName,
      'request_date': requestDate?.toIso8601String(),
      'operation': operation,
      'action_type': actionType,
      'changed_columns': changedColumns,
      'changed_by': changedBy,
      'changed_by_name': changedByName,
      'changed_at': DateTimeUtils.toUtc(changedAt),
      'reason': reason,
      'total_count': totalCount,
    };
  }

  /// Convert model to domain entity
  ShiftAuditLog toEntity() {
    return ShiftAuditLog(
      auditId: auditId,
      shiftRequestId: shiftRequestId,
      userId: userId,
      storeId: storeId,
      storeName: storeName,
      requestDate: requestDate,
      operation: operation,
      actionType: actionType,
      changedColumns: changedColumns,
      changedBy: changedBy,
      changedByName: changedByName,
      changedAt: changedAt,
      reason: reason,
      totalCount: totalCount,
    );
  }
}
