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

  /// Validate denomination configuration (check for duplicates, gaps, etc.)
  Future<DenominationValidationResult> validateDenominations(
    String companyId,
    String currencyId,
    List<DenominationInput> denominations,
  );

  /// Stream of denominations for real-time updates
  Stream<List<Denomination>> watchCurrencyDenominations(String companyId, String currencyId);

  /// Get denomination statistics for analytics
  Future<DenominationStats> getDenominationStats(String companyId, String currencyId);
}

/// Validation result for denomination configurations
class DenominationValidationResult {
  const DenominationValidationResult({
    required this.isValid,
    this.errors = const [],
    this.warnings = const [],
    this.suggestions = const [],
  });

  final bool isValid;
  final List<String> errors;
  final List<String> warnings;
  final List<String> suggestions;

  bool get hasWarnings => warnings.isNotEmpty;
  bool get hasSuggestions => suggestions.isNotEmpty;
}

/// Statistics about denomination configuration
class DenominationStats {
  const DenominationStats({
    required this.totalCount,
    required this.coinCount,
    required this.billCount,
    required this.minValue,
    required this.maxValue,
    required this.averageValue,
    required this.hasDuplicates,
    required this.hasGaps,
  });

  final int totalCount;
  final int coinCount;
  final int billCount;
  final double minValue;
  final double maxValue;
  final double averageValue;
  final bool hasDuplicates;
  final bool hasGaps;

  /// Calculate coverage completeness (0.0 to 1.0)
  double get completeness {
    // Simple heuristic based on count and range
    if (totalCount == 0) return 0.0;
    
    // More denominations and better range coverage = higher completeness
    final countScore = (totalCount / 10.0).clamp(0.0, 1.0);
    final rangeScore = maxValue > minValue * 100 ? 1.0 : 0.5;
    final balanceScore = (coinCount > 0 && billCount > 0) ? 1.0 : 0.7;
    
    return (countScore + rangeScore + balanceScore) / 3.0;
  }
}