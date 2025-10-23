import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/delegation_audit.dart';

part 'delegation_audit_model.freezed.dart';
part 'delegation_audit_model.g.dart';

@freezed
class DelegationAuditModel with _$DelegationAuditModel {
  const DelegationAuditModel._();

  const factory DelegationAuditModel({
    required String id,
    required String delegationId,
    required String action,
    required String performedBy,
    required Map<String, dynamic> performedByUser,
    required Map<String, dynamic> details,
    required DateTime timestamp,
  }) = _DelegationAuditModel;

  factory DelegationAuditModel.fromJson(Map<String, dynamic> json) =>
      _$DelegationAuditModelFromJson(json);

  /// Convert model to domain entity
  DelegationAudit toEntity() {
    return DelegationAudit(
      id: id,
      delegationId: delegationId,
      action: action,
      performedBy: performedBy,
      performedByUser: performedByUser,
      details: details,
      timestamp: timestamp,
    );
  }

  /// Create model from domain entity
  factory DelegationAuditModel.fromEntity(DelegationAudit entity) {
    return DelegationAuditModel(
      id: entity.id,
      delegationId: entity.delegationId,
      action: entity.action,
      performedBy: entity.performedBy,
      performedByUser: entity.performedByUser,
      details: entity.details,
      timestamp: entity.timestamp,
    );
  }
}
