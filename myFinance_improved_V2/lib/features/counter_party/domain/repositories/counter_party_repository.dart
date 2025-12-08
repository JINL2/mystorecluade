import '../entities/counter_party.dart';
import '../entities/counter_party_deletion_validation.dart';
import '../value_objects/counter_party_filter.dart';
import '../value_objects/counter_party_type.dart';

/// Counter Party Repository Interface
abstract class CounterPartyRepository {
  /// Get all counter parties for a company with filters
  Future<List<CounterParty>> getCounterParties({
    required String companyId,
    CounterPartyFilter? filter,
  });

  /// Get a single counter party by ID
  Future<CounterParty?> getCounterPartyById(String counterpartyId);

  /// Create a new counter party
  Future<CounterParty> createCounterParty({
    required String companyId,
    required String name,
    required CounterPartyType type,
    String? email,
    String? phone,
    String? address,
    String? notes,
    bool isInternal = false,
    String? linkedCompanyId,
  });

  /// Update an existing counter party
  Future<CounterParty> updateCounterParty({
    required String counterpartyId,
    required String companyId,
    required String name,
    required CounterPartyType type,
    String? email,
    String? phone,
    String? address,
    String? notes,
    bool isInternal = false,
    String? linkedCompanyId,
  });

  /// Validate if counter party can be deleted
  Future<CounterPartyDeletionValidation> validateDeletion(String counterpartyId);

  /// Soft delete a counter party
  Future<bool> deleteCounterParty(String counterpartyId);

  /// Get unlinked companies for internal linking
  Future<List<Map<String, dynamic>>> getUnlinkedCompanies({
    required String userId,
    required String companyId,
  });
}
