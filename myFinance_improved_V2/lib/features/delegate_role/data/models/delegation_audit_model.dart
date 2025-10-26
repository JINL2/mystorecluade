import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:myfinance_improved/core/utils/datetime_utils.dart';
import '../../domain/entities/delegation_audit.dart';

part 'delegation_audit_model.freezed.dart';
part 'delegation_audit_model.g.dart';

/// Custom JSON converter for DateTime with UTC to Local conversion
class _DateTimeConverter implements JsonConverter<DateTime, String> {
  const _DateTimeConverter();

  @override
  DateTime fromJson(String json) {
    return DateTimeUtils.toLocal(json);
  }

  @override
  String toJson(DateTime object) {
    return DateTimeUtils.toUtc(object);
  }
}

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
    @_DateTimeConverter() required DateTime timestamp,
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
