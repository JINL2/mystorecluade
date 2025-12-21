import 'package:freezed_annotation/freezed_annotation.dart';

part 'delegate_role_models.freezed.dart';
part 'delegate_role_models.g.dart';

@freezed
class RoleDelegation with _$RoleDelegation {
  const RoleDelegation._();
  
  const factory RoleDelegation({
    required String id,
    required String delegatorId,
    required String delegateId,
    required String companyId,
    required String roleId,
    required String roleName,
    required Map<String, dynamic> delegateUser,
    required List<String> permissions,
    required DateTime startDate,
    required DateTime endDate,
    required bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _RoleDelegation;

  factory RoleDelegation.fromJson(Map<String, dynamic> json) =>
      _$RoleDelegationFromJson(json);
}

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

  factory DelegationAudit.fromJson(Map<String, dynamic> json) =>
      _$DelegationAuditFromJson(json);
}

@freezed
class DelegatableRole with _$DelegatableRole {
  const factory DelegatableRole({
    required String roleId,
    required String roleName,
    required String description,
    required List<String> permissions,
    required bool canDelegate,
  }) = _DelegatableRole;

  factory DelegatableRole.fromJson(Map<String, dynamic> json) =>
      _$DelegatableRoleFromJson(json);
}

@freezed
class CreateDelegationRequest with _$CreateDelegationRequest {
  const factory CreateDelegationRequest({
    required String delegateId,
    required String roleId,
    required List<String> permissions,
    required DateTime startDate,
    required DateTime endDate,
  }) = _CreateDelegationRequest;

  factory CreateDelegationRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateDelegationRequestFromJson(json);
}

// Extension methods for model helpers
extension RoleDelegationX on RoleDelegation {
  bool get isExpired => DateTime.now().isAfter(endDate);
  bool get isActiveNow => isActive && !isExpired;
  
  String get delegateUserName => delegateUser['name'] ?? 'Unknown';
  String get delegateUserEmail => delegateUser['email'] ?? '';
  String get delegateUserInitial {
    final name = delegateUserName;
    return name.isNotEmpty ? name.substring(0, 1).toUpperCase() : '?';
  }
  
  int get daysRemaining {
    if (isExpired) return 0;
    return endDate.difference(DateTime.now()).inDays;
  }
}