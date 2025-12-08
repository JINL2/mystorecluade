/// Account Mapping Validator Service
///
/// Validates that internal counterparties have proper account mappings
/// before allowing template creation or update.
abstract class AccountMappingValidator {
  /// Check if account mapping exists for the given parameters
  ///
  /// Returns true if mapping exists, false otherwise
  Future<bool> hasAccountMapping({
    required String myCompanyId,
    required String myAccountId,
    required String counterpartyId,
  });

  /// Check if counterparty is internal (has linked_company_id)
  Future<bool> isInternalCounterparty(String counterpartyId);

  /// Get counterparty details including is_internal flag
  Future<CounterpartyInfo?> getCounterpartyInfo(String counterpartyId);

  /// Validate all account mappings for template data
  ///
  /// Returns list of validation errors, empty if all valid
  Future<List<AccountMappingValidationError>> validateTemplateAccountMappings({
    required String companyId,
    required List<Map<String, dynamic>> templateData,
  });
}

/// Counterparty information for validation
class CounterpartyInfo {
  final String counterpartyId;
  final String? linkedCompanyId;
  final bool isInternal;
  final String name;

  const CounterpartyInfo({
    required this.counterpartyId,
    this.linkedCompanyId,
    required this.isInternal,
    required this.name,
  });
}

/// Validation error for account mapping
class AccountMappingValidationError {
  final String accountId;
  final String accountName;
  final String counterpartyId;
  final String counterpartyName;
  final String message;

  const AccountMappingValidationError({
    required this.accountId,
    required this.accountName,
    required this.counterpartyId,
    required this.counterpartyName,
    required this.message,
  });

  @override
  String toString() => message;
}
