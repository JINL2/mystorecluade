import 'package:freezed_annotation/freezed_annotation.dart';

part 'delegation_audit.freezed.dart';

@freezed
class DelegationAudit with _$DelegationAudit {
  const factory DelegationAudit({
    required String id,
    required String delegationId,
    required String action, // granted, revoked, modified
    required String performedBy,
    required Map<String, dynamic> performedByUser,
    required Map<String, dynamic> details,
    required DateTime timestamp,
  }) = _DelegationAudit;
}
