/// Template Defaults - Pre-filled values extracted from template
///
/// Purpose: Stores default values extracted from template for RPC call:
/// - Cash location IDs (from template data or tags)
/// - Counterparty IDs (for debt transactions)
/// - Description templates
/// - Default amounts (if specified in template)
///
/// Used by TemplateLinesBuilder to populate p_lines with defaults.
/// Clean Architecture: DOMAIN LAYER - Value Object
library;

import 'package:equatable/equatable.dart';

/// Immutable container for template default values
///
/// Extracts and normalizes default values from various template formats:
/// - Legacy format: cash_location_id in entry
/// - New format: cash_location_id in tags.cash_locations[index]
/// - Nested format: cash.cash_location_id within entry
class TemplateDefaults extends Equatable {
  /// Default cash location ID (for cash accounts)
  final String? cashLocationId;

  /// Default counterparty ID (for debt accounts)
  final String? counterpartyId;

  /// Default counterparty store ID (for internal transfers)
  final String? counterpartyStoreId;

  /// Default counterparty cash location ID (for internal transfers)
  final String? counterpartyCashLocationId;

  /// Default description text
  final String? description;

  /// Default amount (if template has fixed amount)
  final double? baseAmount;

  /// Linked company ID (for internal transfers)
  final String? linkedCompanyId;

  /// Debt category (for external debt transactions)
  final String? debtCategory;

  /// Debt direction: 'in' or 'out' (for debt transactions)
  final String? debtDirection;

  const TemplateDefaults({
    this.cashLocationId,
    this.counterpartyId,
    this.counterpartyStoreId,
    this.counterpartyCashLocationId,
    this.description,
    this.baseAmount,
    this.linkedCompanyId,
    this.debtCategory,
    this.debtDirection,
  });

  /// Empty defaults (no pre-filled values)
  static const TemplateDefaults empty = TemplateDefaults();

  /// Factory constructor to extract defaults from template data
  ///
  /// Handles multiple template formats:
  /// 1. Direct fields in template root
  /// 2. Fields in template.tags
  /// 3. Fields in template.data[index]
  /// 4. Nested cash/debt objects in entries
  factory TemplateDefaults.fromTemplate(Map<String, dynamic> template) {
    final data = template['data'] as List? ?? [];
    final tags = template['tags'] as Map<String, dynamic>? ?? {};

    // Extract cash location (multiple sources)
    String? cashLocationId;
    String? counterpartyId;
    String? counterpartyStoreId;
    String? counterpartyCashLocationId;
    String? linkedCompanyId;
    String? debtCategory;
    String? debtDirection;

    // 1. Check tags.cash_locations array
    final cashLocations = tags['cash_locations'] as List?;
    if (cashLocations != null && cashLocations.isNotEmpty) {
      final first = cashLocations.first;
      if (first != null && first.toString().isNotEmpty && first.toString() != 'none') {
        cashLocationId = first.toString();
      }
    }

    // 2. Check template root fields
    cashLocationId ??= _extractId(template['cash_location_id']);
    counterpartyId ??= _extractId(template['counterparty_id']);
    counterpartyStoreId ??= _extractId(template['counterparty_store_id']);
    counterpartyCashLocationId ??= _extractId(template['counterparty_cash_location_id']);

    // 3. Check each data entry for defaults
    for (var entry in data) {
      if (entry is! Map<String, dynamic>) continue;

      // Cash location from entry
      if (cashLocationId == null) {
        cashLocationId = _extractId(entry['cash_location_id']);

        // Check nested cash object
        if (cashLocationId == null) {
          final cash = entry['cash'] as Map<String, dynamic>?;
          if (cash != null) {
            cashLocationId = _extractId(cash['cash_location_id']);
          }
        }
      }

      // Counterparty from entry
      if (counterpartyId == null) {
        counterpartyId = _extractId(entry['counterparty_id']);
      }

      // Linked company (internal transfer)
      if (linkedCompanyId == null) {
        linkedCompanyId = _extractId(entry['linked_company_id']);
      }

      // Counterparty store/cash location from entry
      if (counterpartyStoreId == null) {
        counterpartyStoreId = _extractId(entry['counterparty_store_id']);
      }
      if (counterpartyCashLocationId == null) {
        counterpartyCashLocationId = _extractId(entry['counterparty_cash_location_id']);
      }

      // Debt configuration from entry
      if (debtCategory == null || debtDirection == null) {
        final debt = entry['debt'] as Map<String, dynamic>?;
        if (debt != null) {
          debtCategory ??= debt['category']?.toString();
          debtDirection ??= debt['direction']?.toString();
        } else {
          // Check direct fields in entry
          debtCategory ??= entry['debt_category']?.toString();
          debtDirection ??= entry['debt_direction']?.toString();
        }
      }
    }

    // Extract description
    String? description;
    if (template['description'] != null) {
      description = template['description'].toString();
    }

    // Extract base amount
    double? baseAmount;
    final amount = template['base_amount'];
    if (amount != null) {
      if (amount is num && amount != 0) {
        baseAmount = amount.toDouble();
      }
    }

    return TemplateDefaults(
      cashLocationId: cashLocationId,
      counterpartyId: counterpartyId,
      counterpartyStoreId: counterpartyStoreId,
      counterpartyCashLocationId: counterpartyCashLocationId,
      description: description,
      baseAmount: baseAmount,
      linkedCompanyId: linkedCompanyId,
      debtCategory: debtCategory,
      debtDirection: debtDirection,
    );
  }

  /// Helper to extract ID from various formats
  static String? _extractId(dynamic value) {
    if (value == null) return null;
    final str = value.toString();
    if (str.isEmpty || str == 'none' || str == 'null') return null;
    return str;
  }

  /// Check if this is an internal transfer (has linked company)
  bool get isInternalTransfer => linkedCompanyId != null;

  /// Check if this has debt configuration
  bool get hasDebtConfig => debtCategory != null || debtDirection != null;

  /// Check if any defaults are available
  bool get isEmpty =>
      cashLocationId == null &&
      counterpartyId == null &&
      counterpartyStoreId == null &&
      counterpartyCashLocationId == null &&
      description == null &&
      baseAmount == null &&
      linkedCompanyId == null;

  /// Create copy with overrides
  TemplateDefaults copyWith({
    String? cashLocationId,
    String? counterpartyId,
    String? counterpartyStoreId,
    String? counterpartyCashLocationId,
    String? description,
    double? baseAmount,
    String? linkedCompanyId,
    String? debtCategory,
    String? debtDirection,
  }) {
    return TemplateDefaults(
      cashLocationId: cashLocationId ?? this.cashLocationId,
      counterpartyId: counterpartyId ?? this.counterpartyId,
      counterpartyStoreId: counterpartyStoreId ?? this.counterpartyStoreId,
      counterpartyCashLocationId:
          counterpartyCashLocationId ?? this.counterpartyCashLocationId,
      description: description ?? this.description,
      baseAmount: baseAmount ?? this.baseAmount,
      linkedCompanyId: linkedCompanyId ?? this.linkedCompanyId,
      debtCategory: debtCategory ?? this.debtCategory,
      debtDirection: debtDirection ?? this.debtDirection,
    );
  }

  @override
  List<Object?> get props => [
        cashLocationId,
        counterpartyId,
        counterpartyStoreId,
        counterpartyCashLocationId,
        description,
        baseAmount,
        linkedCompanyId,
        debtCategory,
        debtDirection,
      ];

  @override
  String toString() => 'TemplateDefaults('
      'cashLocationId: $cashLocationId, '
      'counterpartyId: $counterpartyId, '
      'linkedCompanyId: $linkedCompanyId)';
}
