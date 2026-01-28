import '../entities/denomination.dart';
import '../entities/denomination_delete_result.dart';

abstract class DenominationRepository {
  /// Get all denominations for a specific currency within a company
  Future<List<Denomination>> getCurrencyDenominations(String companyId, String currencyId);

  /// Add a new denomination
  Future<Denomination> addDenomination(DenominationInput input);

  /// Remove a denomination (uses RPC for safe deletion with blocking location info)
  Future<DenominationDeleteResult> removeDenomination(String denominationId, String companyId);

  /// Apply a standard template for a currency (e.g., USD standard denominations)
  Future<List<Denomination>> applyDenominationTemplate(
    String currencyCode,
    String companyId,
    String currencyId,
  );

  /// Add multiple denominations in bulk
  Future<List<Denomination>> addBulkDenominations(List<DenominationInput> inputs);
}