/// Template Lines Builder - Builds p_lines array for RPC
///
/// Purpose: Transforms template data + user input into p_lines structure:
/// - Handles all 4 template types (cashCash, internal, externalDebt, expenseRevenueCash)
/// - Normalizes legacy template formats
/// - Applies user-selected values (cash location, counterparty, etc.)
/// - Maintains debit/credit balance
///
/// Used by template_rpc_service.dart to prepare RPC parameters.
/// Clean Architecture: DOMAIN LAYER - Service
library;

import 'package:flutter/foundation.dart';

import '../enums/template_enums.dart';
import '../value_objects/template_defaults.dart';

/// Builds p_lines array for insert_journal_with_everything_utc RPC
///
/// The p_lines structure:
/// ```json
/// [
///   {
///     "account_id": "uuid",
///     "debit": 1000,      // or null
///     "credit": null,     // or 1000
///     "cash": {           // optional, for cash accounts
///       "cash_location_id": "uuid"
///     },
///     "debt": {           // optional, for debt accounts
///       "counterparty_id": "uuid",
///       "direction": "in" | "out",
///       "category": "loan" | "trade" | "other" | null,
///       "issue_date": "2024-01-01" | null
///     }
///   }
/// ]
/// ```
class TemplateLinesBuilder {
  /// Build p_lines from template data and user selections
  ///
  /// Parameters:
  /// - [template]: The template map containing 'data' array
  /// - [amount]: The transaction amount entered by user
  /// - [rpcType]: Determined RPC type for this template
  /// - [defaults]: Pre-extracted default values from template
  /// - [selectedCashLocationId]: User-selected cash location (overrides default)
  /// - [selectedCounterpartyId]: User-selected counterparty (overrides default)
  /// - [selectedCounterpartyStoreId]: For internal transfers
  /// - [selectedCounterpartyCashLocationId]: For internal transfers
  /// - [entryDate]: Optional entry date for debt transactions
  ///
  /// Returns: List of line maps ready for RPC
  static List<Map<String, dynamic>> build({
    required Map<String, dynamic> template,
    required double amount,
    required TemplateRpcType rpcType,
    TemplateDefaults defaults = TemplateDefaults.empty,
    String? selectedCashLocationId,
    String? selectedCounterpartyId,
    String? selectedCounterpartyStoreId,
    String? selectedCounterpartyCashLocationId,
    DateTime? entryDate,
  }) {
    _debugLog('┌─────────────────────────────────────────────────────────────');
    _debugLog('│ TemplateLinesBuilder.build()');
    _debugLog('├─────────────────────────────────────────────────────────────');
    _debugLog('│ Input:');
    _debugLog('│   rpcType: ${rpcType.name}');
    _debugLog('│   amount: $amount');
    _debugLog('│   selectedCashLocationId: $selectedCashLocationId');
    _debugLog('│   selectedCounterpartyId: $selectedCounterpartyId');
    _debugLog('│   selectedCounterpartyStoreId: $selectedCounterpartyStoreId');
    _debugLog('│   selectedCounterpartyCashLocationId: $selectedCounterpartyCashLocationId');

    final data = template['data'] as List? ?? [];
    _debugLog('│   template.data entries: ${data.length}');

    if (data.isEmpty) {
      _debugLog('│ ❌ Empty data array, returning []');
      _debugLog('└─────────────────────────────────────────────────────────────');
      return [];
    }

    // Log each entry in template data
    for (var i = 0; i < data.length; i++) {
      final entry = data[i] as Map<String, dynamic>;
      _debugLog('│   data[$i]: account_id=${entry['account_id']}, category_tag=${entry['category_tag']}, type=${entry['type']}');
    }

    // Determine effective values (user selection > defaults > template)
    final effectiveCashLocationId =
        selectedCashLocationId ?? defaults.cashLocationId;
    final effectiveCounterpartyId =
        selectedCounterpartyId ?? defaults.counterpartyId;
    final effectiveCounterpartyStoreId =
        selectedCounterpartyStoreId ?? defaults.counterpartyStoreId;
    final effectiveCounterpartyCashLocationId =
        selectedCounterpartyCashLocationId ?? defaults.counterpartyCashLocationId;

    _debugLog('│ Effective Values:');
    _debugLog('│   effectiveCashLocationId: $effectiveCashLocationId');
    _debugLog('│   effectiveCounterpartyId: $effectiveCounterpartyId');
    _debugLog('│   effectiveCounterpartyStoreId: $effectiveCounterpartyStoreId');
    _debugLog('│   effectiveCounterpartyCashLocationId: $effectiveCounterpartyCashLocationId');

    List<Map<String, dynamic>> result;

    // Build based on RPC type
    switch (rpcType) {
      case TemplateRpcType.cashCash:
        _debugLog('│ Building: CashCash lines...');
        // CashCash: DO NOT pass cashLocationId - each line uses its own template value
        result = _buildCashCashLines(
          data: data,
          amount: amount,
        );

      case TemplateRpcType.internal:
        _debugLog('│ Building: Internal lines...');
        result = _buildInternalLines(
          data: data,
          amount: amount,
          cashLocationId: effectiveCashLocationId,
          counterpartyStoreId: effectiveCounterpartyStoreId,
          counterpartyCashLocationId: effectiveCounterpartyCashLocationId,
        );

      case TemplateRpcType.externalDebt:
        _debugLog('│ Building: ExternalDebt lines...');
        result = _buildExternalDebtLines(
          data: data,
          amount: amount,
          counterpartyId: effectiveCounterpartyId,
          defaults: defaults,
          entryDate: entryDate,
        );

      case TemplateRpcType.expenseRevenueCash:
        _debugLog('│ Building: ExpenseRevenueCash lines...');
        result = _buildExpenseRevenueCashLines(
          data: data,
          amount: amount,
          cashLocationId: effectiveCashLocationId,
        );

      case TemplateRpcType.generalJournal:
        _debugLog('│ Building: GeneralJournal lines...');
        result = _buildGeneralJournalLines(
          data: data,
          amount: amount,
          cashLocationId: effectiveCashLocationId,
        );

      case TemplateRpcType.unknown:
        _debugLog('│ Building: Generic (fallback) lines...');
        // Fallback: try to build generic lines
        result = _buildGenericLines(
          data: data,
          amount: amount,
          cashLocationId: effectiveCashLocationId,
          counterpartyId: effectiveCounterpartyId,
        );
    }

    _debugLog('│ Result: ${result.length} lines built');
    for (var i = 0; i < result.length; i++) {
      final line = result[i];
      _debugLog('│   line[$i]: DR=${line['debit']}, CR=${line['credit']}, cash=${line['cash']}, debt=${line['debt']}');
    }
    _debugLog('└─────────────────────────────────────────────────────────────');

    return result;
  }

  /// Debug logging helper
  static void _debugLog(String message) {
    if (kDebugMode) {
      debugPrint('[TemplateLinesBuilder] $message');
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Cash-to-Cash Transfer
  // ═══════════════════════════════════════════════════════════════════════════

  /// Build lines for cash-to-cash transfer
  ///
  /// Structure:
  /// - Line 1: Debit (destination cash account)
  /// - Line 2: Credit (source cash account)
  ///
  /// IMPORTANT: CashCash transfers have 2 different cash locations (source & destination).
  /// Each line MUST use its own cash_location_id from the template.
  /// DO NOT use user-selected cashLocationId here - it would override both lines!
  static List<Map<String, dynamic>> _buildCashCashLines({
    required List<dynamic> data,
    required double amount,
    // NOTE: cashLocationId parameter removed - CashCash must use template values
  }) {
    final lines = <Map<String, dynamic>>[];

    for (var i = 0; i < data.length; i++) {
      final entry = data[i] as Map<String, dynamic>;
      final accountId = entry['account_id']?.toString();
      if (accountId == null) continue;

      // Check type field (primary), then fallback to is_debit/debit_credit, then index
      final isDebit = entry['type'] == 'debit' ||
          entry['is_debit'] == true ||
          entry['debit_credit'] == 'debit' ||
          i == 0; // Default first entry to debit

      // CashCash: Always use template's cash_location_id for each line
      // Each line has its own location (e.g., Vault -> Cashier)
      final entryCashLocationId = _extractCashLocationId(entry);

      lines.add({
        'account_id': accountId,
        'debit': isDebit ? amount : null,
        'credit': isDebit ? null : amount,
        'cash': {
          'cash_location_id': entryCashLocationId,
        },
      });
    }

    return lines;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Internal Transfer
  // ═══════════════════════════════════════════════════════════════════════════

  /// Build lines for internal transfer (between company stores)
  ///
  /// Structure:
  /// - Line 1: Our cash account (debit or credit based on direction)
  /// - Line 2: Counterparty's cash account reference
  static List<Map<String, dynamic>> _buildInternalLines({
    required List<dynamic> data,
    required double amount,
    String? cashLocationId,
    String? counterpartyStoreId,
    String? counterpartyCashLocationId,
  }) {
    final lines = <Map<String, dynamic>>[];

    for (var entry in data) {
      if (entry is! Map<String, dynamic>) continue;

      final accountId = entry['account_id']?.toString();
      if (accountId == null) continue;

      // Check type field (primary), then fallback to is_debit/debit_credit
      final isDebit = entry['type'] == 'debit' ||
          entry['is_debit'] == true ||
          entry['debit_credit'] == 'debit';

      final hasLinkedCompany = entry['linked_company_id'] != null;

      Map<String, dynamic>? cashObject;

      if (hasLinkedCompany) {
        // This is the counterparty's side
        cashObject = {
          'cash_location_id': counterpartyCashLocationId,
          'counterparty_store_id': counterpartyStoreId,
        };
      } else {
        // This is our side - user selection takes priority
        final entryCashLocationId = cashLocationId ?? _extractCashLocationId(entry);
        cashObject = {
          'cash_location_id': entryCashLocationId,
        };
      }

      lines.add({
        'account_id': accountId,
        'debit': isDebit ? amount : null,
        'credit': isDebit ? null : amount,
        'cash': cashObject,
      });
    }

    return lines;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // External Debt Transaction
  // ═══════════════════════════════════════════════════════════════════════════

  /// Build lines for external debt transaction
  ///
  /// Structure:
  /// - Debt line: Payable/Receivable with debt object
  /// - Counter line: Usually cash or expense/revenue
  static List<Map<String, dynamic>> _buildExternalDebtLines({
    required List<dynamic> data,
    required double amount,
    String? counterpartyId,
    required TemplateDefaults defaults,
    DateTime? entryDate,
  }) {
    final lines = <Map<String, dynamic>>[];

    for (var entry in data) {
      if (entry is! Map<String, dynamic>) continue;

      final accountId = entry['account_id']?.toString();
      if (accountId == null) continue;

      final categoryTag = entry['category_tag']?.toString();
      // Check type field (primary), then fallback to is_debit/debit_credit
      final isDebit = entry['type'] == 'debit' ||
          entry['is_debit'] == true ||
          entry['debit_credit'] == 'debit';

      // Check if this is a debt account
      if (categoryTag == 'payable' || categoryTag == 'receivable') {
        // RPC expects direction to be 'receivable' or 'payable' (same as categoryTag)
        // Reference: test_template_mapping_page.dart line 319
        final direction = defaults.debtDirection ?? categoryTag;

        lines.add({
          'account_id': accountId,
          'debit': isDebit ? amount : null,
          'credit': isDebit ? null : amount,
          'debt': {
            'counterparty_id': counterpartyId ?? defaults.counterpartyId,
            'direction': direction,
            // Reference: test_template_mapping_page.dart line 320 uses 'account'
            'category': defaults.debtCategory ?? 'account',
            if (entryDate != null)
              'issue_date': entryDate.toIso8601String().split('T').first,
          },
        });
      } else {
        // Non-debt account (cash, expense, revenue, etc.)
        final entryCashLocationId = _extractCashLocationId(entry);

        final lineData = <String, dynamic>{
          'account_id': accountId,
          'debit': isDebit ? amount : null,
          'credit': isDebit ? null : amount,
        };

        // Add cash object if this is a cash account
        if (categoryTag == 'cash' && entryCashLocationId != null) {
          lineData['cash'] = {
            'cash_location_id': entryCashLocationId,
          };
        }

        lines.add(lineData);
      }
    }

    return lines;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Expense/Revenue + Cash
  // ═══════════════════════════════════════════════════════════════════════════

  /// Build lines for expense/revenue with cash
  ///
  /// Structure:
  /// - Expense/Revenue line: Simple account entry
  /// - Cash line: With cash_location_id
  static List<Map<String, dynamic>> _buildExpenseRevenueCashLines({
    required List<dynamic> data,
    required double amount,
    String? cashLocationId,
  }) {
    final lines = <Map<String, dynamic>>[];

    for (var entry in data) {
      if (entry is! Map<String, dynamic>) continue;

      final accountId = entry['account_id']?.toString();
      if (accountId == null) continue;

      final categoryTag = entry['category_tag']?.toString();
      // Check type field (primary), then fallback to is_debit/debit_credit
      final isDebit = entry['type'] == 'debit' ||
          entry['is_debit'] == true ||
          entry['debit_credit'] == 'debit';

      final lineData = <String, dynamic>{
        'account_id': accountId,
        'debit': isDebit ? amount : null,
        'credit': isDebit ? null : amount,
      };

      // Add cash object for cash accounts - user selection takes priority
      if (categoryTag == 'cash') {
        final entryCashLocationId = cashLocationId ?? _extractCashLocationId(entry);
        lineData['cash'] = {
          'cash_location_id': entryCashLocationId,
        };
      }

      lines.add(lineData);
    }

    return lines;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // General Journal Entry
  // ═══════════════════════════════════════════════════════════════════════════

  /// Build lines for general journal entry (simple debit/credit)
  ///
  /// Structure:
  /// - account_id, debit, credit
  /// - cash object added for cash accounts (category_tag == 'cash')
  /// - Example: COGS (Expense + Inventory), Depreciation, Adjustments, Dividend
  /// Note: Uses String format for debit/credit to match journal_input behavior
  static List<Map<String, dynamic>> _buildGeneralJournalLines({
    required List<dynamic> data,
    required double amount,
    String? cashLocationId,
  }) {
    final lines = <Map<String, dynamic>>[];

    for (var entry in data) {
      if (entry is! Map<String, dynamic>) continue;

      final accountId = entry['account_id']?.toString();
      if (accountId == null) continue;

      final categoryTag = entry['category_tag']?.toString();

      // Check type field (primary), then fallback to is_debit/debit_credit
      final isDebit = entry['type'] == 'debit' ||
          entry['is_debit'] == true ||
          entry['debit_credit'] == 'debit';

      // Match journal_input format: String values for debit/credit
      final lineData = <String, dynamic>{
        'account_id': accountId,
        'debit': isDebit ? amount.toString() : '0',
        'credit': isDebit ? '0' : amount.toString(),
      };

      // Add cash object if cash_location_id exists (regardless of categoryTag)
      // Cash can be on debit or credit side
      // User selection takes priority over template default
      final entryCashLocationId = _extractCashLocationId(entry);
      if (cashLocationId != null && categoryTag == 'cash') {
        // User selection takes priority for cash accounts
        lineData['cash'] = {
          'cash_location_id': cashLocationId,
        };
      } else if (entryCashLocationId != null) {
        // Template has cash_location_id
        lineData['cash'] = {
          'cash_location_id': entryCashLocationId,
        };
      } else if (categoryTag == 'cash' && cashLocationId != null) {
        // Fallback: use provided cashLocationId for cash category accounts
        lineData['cash'] = {
          'cash_location_id': cashLocationId,
        };
      }

      lines.add(lineData);
    }

    return lines;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Generic Fallback
  // ═══════════════════════════════════════════════════════════════════════════

  /// Build generic lines (fallback for unknown types)
  static List<Map<String, dynamic>> _buildGenericLines({
    required List<dynamic> data,
    required double amount,
    String? cashLocationId,
    String? counterpartyId,
  }) {
    final lines = <Map<String, dynamic>>[];

    for (var entry in data) {
      if (entry is! Map<String, dynamic>) continue;

      final accountId = entry['account_id']?.toString();
      if (accountId == null) continue;

      final categoryTag = entry['category_tag']?.toString();
      // Check type field (primary), then fallback to is_debit/debit_credit
      final isDebit = entry['type'] == 'debit' ||
          entry['is_debit'] == true ||
          entry['debit_credit'] == 'debit';

      final lineData = <String, dynamic>{
        'account_id': accountId,
        'debit': isDebit ? amount : null,
        'credit': isDebit ? null : amount,
      };

      // Add cash object for cash accounts - user selection takes priority
      if (categoryTag == 'cash') {
        final entryCashLocationId = cashLocationId ?? _extractCashLocationId(entry);
        if (entryCashLocationId != null) {
          lineData['cash'] = {
            'cash_location_id': entryCashLocationId,
          };
        }
      }

      // Add debt object for payable/receivable accounts
      // RPC expects direction to be 'receivable' or 'payable' (same as categoryTag)
      if ((categoryTag == 'payable' || categoryTag == 'receivable') &&
          counterpartyId != null) {
        lineData['debt'] = {
          'counterparty_id': counterpartyId,
          'direction': categoryTag,  // 'receivable' or 'payable'
          // Reference: test_template_mapping_page.dart line 320 uses 'account'
          'category': 'account',
        };
      }

      lines.add(lineData);
    }

    return lines;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Helper Methods
  // ═══════════════════════════════════════════════════════════════════════════

  /// Extract cash_location_id from entry (handles various formats)
  static String? _extractCashLocationId(Map<String, dynamic> entry) {
    // 1. Direct field
    var id = entry['cash_location_id'];
    if (_isValidId(id)) return id.toString();

    // 2. Nested cash object
    final cash = entry['cash'] as Map<String, dynamic>?;
    if (cash != null) {
      id = cash['cash_location_id'];
      if (_isValidId(id)) return id.toString();
    }

    return null;
  }

  /// Check if ID value is valid
  static bool _isValidId(dynamic value) {
    if (value == null) return false;
    final str = value.toString();
    return str.isNotEmpty && str != 'none' && str != 'null';
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Utility Methods
  // ═══════════════════════════════════════════════════════════════════════════

  /// Get summary of built lines for logging/debugging
  static String summarizeLines(List<Map<String, dynamic>> lines) {
    final buffer = StringBuffer();
    buffer.writeln('Lines (${lines.length}):');

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      final debit = line['debit'];
      final credit = line['credit'];
      final type = debit != null ? 'DR' : 'CR';
      final amount = debit ?? credit ?? 0;
      final hasCash = line['cash'] != null;
      final hasDebt = line['debt'] != null;

      buffer.writeln(
        '  [$i] $type $amount ${hasCash ? '[cash]' : ''}${hasDebt ? '[debt]' : ''}',
      );
    }

    return buffer.toString();
  }
}
