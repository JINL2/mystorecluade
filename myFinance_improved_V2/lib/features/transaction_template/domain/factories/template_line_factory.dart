/// Template Line Factory - Creates transaction lines based on account types
///
/// Purpose: Domain layer factory for building template data structure
/// - Handles account-type-specific logic (cash, payable, receivable)
/// - Ensures correct FLAT data structure for template creation (matches database format)
/// - Clean Architecture: DOMAIN LAYER - Factories
///
/// Usage: TemplateLineFactory.createLine(...)
library;

/// Factory for creating template transaction lines with FLAT structure
class TemplateLineFactory {
  /// Create a transaction line based on account type
  ///
  /// Returns a Map representing a single transaction line with FLAT structure:
  /// - type: 'debit' or 'credit'
  /// - account_id, account_name, category_tag
  /// - amount, debit, credit: '0' for templates (filled in when template is used)
  /// - description: Line description
  /// - counterparty_id, counterparty_name, counterparty_cash_location_id (for payable/receivable)
  /// - cash_location_id, cash_location_name (for cash/bank)
  static Map<String, dynamic> createLine({
    required String accountId,
    required String accountName,
    required String accountCategoryTag,
    required bool isDebit,
    String? description,
    // Account code for expense account identification (5000-9999)
    String? accountCode,
    // Cash account parameters
    String? cashLocationId,
    String? cashLocationName,
    // Payable/Receivable account parameters
    String? counterpartyId,
    String? counterpartyName,
    String? counterpartyCashLocationId,
    String? counterpartyCashLocationName,
  }) {
    // Create FLAT structure (not nested) matching database format
    final line = <String, dynamic>{
      'type': isDebit ? 'debit' : 'credit',
      'account_id': accountId,
      'account_name': accountName,
      'category_tag': accountCategoryTag,
      'account_code': accountCode, // For expense account detection (5000-9999)
      'amount': '0', // Template default, filled in when used
      'debit': '0',
      'credit': '0',
      'description': description,
    };

    // Add fields based on account categoryTag (FLAT, not nested)
    final categoryLower = accountCategoryTag.toLowerCase();

    switch (categoryLower) {
      case 'cash':
      case 'bank':
        // Cash/Bank accounts - add cash_location fields
        line['cash_location_id'] = cashLocationId;
        line['cash_location_name'] = cashLocationName;
        line['counterparty_id'] = null;
        line['counterparty_name'] = null;
        line['counterparty_cash_location_id'] = null;
        break;

      case 'payable':
      case 'receivable':
        // Payable/Receivable accounts - add counterparty fields
        line['counterparty_id'] = counterpartyId;
        line['counterparty_name'] = counterpartyName;
        line['counterparty_cash_location_id'] = counterpartyCashLocationId;
        line['counterparty_cash_location_name'] = counterpartyCashLocationName;
        line['cash_location_id'] = null;
        line['cash_location_name'] = null;
        break;

      default:
        // Other account types - set all to null
        line['counterparty_id'] = null;
        line['counterparty_name'] = null;
        line['counterparty_cash_location_id'] = null;
        line['counterparty_cash_location_name'] = null;
        line['cash_location_id'] = null;
        line['cash_location_name'] = null;
        break;
    }

    return line;
  }

  /// Create multiple transaction lines from provided parameters
  static List<Map<String, dynamic>> createLines({
    // Debit line parameters
    String? debitAccountId,
    String? debitAccountName,
    String? debitCategoryTag,
    String? debitAccountCode, // Account code for expense detection
    String? debitCashLocationId,
    String? debitCashLocationName,
    String? debitCounterpartyId,
    String? debitCounterpartyName,
    String? debitCounterpartyCashLocationId,
    String? debitCounterpartyCashLocationName,
    // Credit line parameters
    String? creditAccountId,
    String? creditAccountName,
    String? creditCategoryTag,
    String? creditAccountCode, // Account code for expense detection
    String? creditCashLocationId,
    String? creditCashLocationName,
    String? creditCounterpartyId,
    String? creditCounterpartyName,
    String? creditCounterpartyCashLocationId,
    String? creditCounterpartyCashLocationName,
    // Shared parameters
    required String templateName,
  }) {
    final lines = <Map<String, dynamic>>[];

    // Create debit line
    // ✅ FIX: Allow null categoryTag for accounts without specific category (e.g., expense accounts)
    if (debitAccountId != null && debitAccountName != null) {
      lines.add(createLine(
        accountId: debitAccountId,
        accountName: debitAccountName,
        accountCategoryTag: debitCategoryTag ?? 'other',  // ✅ Default to 'other' if null
        accountCode: debitAccountCode,
        isDebit: true,
        description: 'Debit entry - $templateName',
        cashLocationId: debitCashLocationId,
        cashLocationName: debitCashLocationName,
        counterpartyId: debitCounterpartyId,
        counterpartyName: debitCounterpartyName,
        counterpartyCashLocationId: debitCounterpartyCashLocationId,
        counterpartyCashLocationName: debitCounterpartyCashLocationName,
      ),);
    }

    // Create credit line
    // ✅ FIX: Allow null categoryTag for accounts without specific category (e.g., expense accounts)
    if (creditAccountId != null && creditAccountName != null) {
      lines.add(createLine(
        accountId: creditAccountId,
        accountName: creditAccountName,
        accountCategoryTag: creditCategoryTag ?? 'other',  // ✅ Default to 'other' if null
        accountCode: creditAccountCode,
        isDebit: false,
        description: 'Credit entry - $templateName',
        cashLocationId: creditCashLocationId,
        cashLocationName: creditCashLocationName,
        counterpartyId: creditCounterpartyId,
        counterpartyName: creditCounterpartyName,
        counterpartyCashLocationId: creditCounterpartyCashLocationId,
        counterpartyCashLocationName: creditCounterpartyCashLocationName,
      ),);
    }

    return lines;
  }

  /// Validate line requirements based on account category
  static List<String> validateLineRequirements({
    required String accountCategoryTag,
    required String accountName,
    String? cashLocationId,
    String? counterpartyId,
  }) {
    final errors = <String>[];
    final categoryLower = accountCategoryTag.toLowerCase();

    switch (categoryLower) {
      case 'cash':
      case 'bank':
        if (cashLocationId == null || cashLocationId.isEmpty) {
          errors.add('$accountName requires cash location');
        }
        break;

      case 'payable':
      case 'receivable':
        if (counterpartyId == null || counterpartyId.isEmpty) {
          errors.add('$accountName requires counterparty');
        }
        break;

      default:
        // Other account types have no special requirements
        break;
    }

    return errors;
  }
}
