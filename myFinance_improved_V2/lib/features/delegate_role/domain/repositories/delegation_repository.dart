import '../entities/delegation_audit.dart';
import '../entities/role_delegation.dart';

/// Abstract repository for Role Delegation management
abstract class DelegationRepository {
  /// Get active delegations for a user
  Future<List<RoleDelegation>> getActiveDelegations(String userId, String companyId);

  /// Get delegation history (audit trail)
  Future<List<DelegationAudit>> getDelegationHistory(String companyId);

  /// Create a new delegation
  Future<void> createDelegation({
    required String delegateId,
    required String roleId,
    required List<String> permissions,
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Revoke a delegation
  Future<void> revokeDelegation(String delegationId);
}
