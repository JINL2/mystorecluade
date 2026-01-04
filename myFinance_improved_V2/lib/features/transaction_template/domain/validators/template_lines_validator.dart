/// Template Lines Validator - Validates p_lines structure for RPC
///
/// Purpose: Validates the p_lines array before sending to RPC:
/// - Account ID validation
/// - Debit/Credit balance validation
/// - Cash location validation for cash accounts
/// - Counterparty validation for debt accounts
/// - Amount validation
///
/// Uses existing ValidationError class for error reporting.
/// Clean Architecture: DOMAIN LAYER - Validator
library;

import '../enums/template_enums.dart';
import '../exceptions/validation_error.dart';

/// Validates p_lines structure for insert_journal_with_everything_utc RPC
///
/// Follows existing TemplateFormValidator pattern.
class TemplateLinesValidator {
  /// Validates the complete p_lines array
  ///
  /// Returns: List of ValidationError (empty if valid)
  static List<ValidationError> validate({
    required List<Map<String, dynamic>> lines,
    required TemplateRpcType rpcType,
    required double amount,
  }) {
    final errors = <ValidationError>[];

    // 1. Basic structure validation
    if (lines.isEmpty) {
      errors.add(const ValidationError(
        fieldName: 'p_lines',
        fieldValue: '',
        message: 'At least one journal line is required',
        validationRule: 'required',
      ));
      return errors; // Cannot continue with empty lines
    }

    // 2. Amount validation
    if (amount <= 0) {
      errors.add(ValidationError(
        fieldName: 'amount',
        fieldValue: amount.toString(),
        message: 'Amount must be greater than zero',
        validationRule: 'positive_number',
      ));
    }

    // 3. Validate each line
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      final lineErrors = _validateLine(
        line: line,
        lineIndex: i,
        rpcType: rpcType,
      );
      errors.addAll(lineErrors);
    }

    // 4. Validate debit/credit balance
    final balanceErrors = _validateDebitCreditBalance(lines);
    errors.addAll(balanceErrors);

    // 5. RPC type-specific validation
    final typeErrors = _validateByRpcType(
      lines: lines,
      rpcType: rpcType,
    );
    errors.addAll(typeErrors);

    return errors;
  }

  /// Validates a single journal line
  static List<ValidationError> _validateLine({
    required Map<String, dynamic> line,
    required int lineIndex,
    required TemplateRpcType rpcType,
  }) {
    final errors = <ValidationError>[];
    final fieldPrefix = 'lines[$lineIndex]';

    // Account ID is required
    final accountId = line['account_id'];
    if (accountId == null || accountId.toString().isEmpty) {
      errors.add(ValidationError(
        fieldName: '$fieldPrefix.account_id',
        fieldValue: '',
        message: 'Account ID is required for line ${lineIndex + 1}',
        validationRule: 'required',
      ));
    }

    // Debit or Credit must be non-null (one must be set)
    final debit = line['debit'];
    final credit = line['credit'];
    final hasDebit = debit != null;
    final hasCredit = credit != null;

    if (!hasDebit && !hasCredit) {
      errors.add(ValidationError(
        fieldName: '$fieldPrefix.debit/credit',
        fieldValue: '',
        message: 'Either debit or credit must be set for line ${lineIndex + 1}',
        validationRule: 'required_one',
      ));
    }

    // Validate cash object if present
    final cash = line['cash'] as Map<String, dynamic>?;
    if (cash != null) {
      final cashLocationId = cash['cash_location_id'];
      if (cashLocationId == null || cashLocationId.toString().isEmpty) {
        errors.add(ValidationError(
          fieldName: '$fieldPrefix.cash.cash_location_id',
          fieldValue: '',
          message: 'Cash location ID is required for cash account',
          validationRule: 'required',
        ));
      }
    }

    // Validate debt object if present
    final debt = line['debt'] as Map<String, dynamic>?;
    if (debt != null) {
      final counterpartyId = debt['counterparty_id'];
      if (counterpartyId == null || counterpartyId.toString().isEmpty) {
        errors.add(ValidationError(
          fieldName: '$fieldPrefix.debt.counterparty_id',
          fieldValue: '',
          message: 'Counterparty ID is required for debt account',
          validationRule: 'required',
        ));
      }

      final direction = debt['direction'];
      // RPC accepts: 'receivable', 'payable' (categoryTag values)
      // Reference: test_template_mapping_page.dart line 319
      const validDirections = ['in', 'out', 'receivable', 'payable'];
      if (direction == null || !validDirections.contains(direction.toString())) {
        errors.add(ValidationError(
          fieldName: '$fieldPrefix.debt.direction',
          fieldValue: direction?.toString() ?? '',
          message: 'Debt direction must be "receivable" or "payable"',
          validationRule: 'enum_value',
        ));
      }

      // Category can be null, but if present should be valid
      final category = debt['category'];
      if (category != null && category.toString().isNotEmpty) {
        // Valid categories: 'loan', 'trade', 'other', 'account'
        // Reference: test_template_mapping_page.dart line 320
        const validCategories = ['loan', 'trade', 'other', 'account'];
        if (!validCategories.contains(category.toString())) {
          errors.add(ValidationError(
            fieldName: '$fieldPrefix.debt.category',
            fieldValue: category.toString(),
            message: 'Invalid debt category',
            validationRule: 'enum_value',
          ));
        }
      }
    }

    return errors;
  }

  /// Validates that total debits equal total credits
  static List<ValidationError> _validateDebitCreditBalance(
    List<Map<String, dynamic>> lines,
  ) {
    final errors = <ValidationError>[];

    double totalDebit = 0;
    double totalCredit = 0;

    for (var line in lines) {
      final debit = line['debit'];
      final credit = line['credit'];

      if (debit != null && debit is num) {
        totalDebit += debit.toDouble();
      }
      if (credit != null && credit is num) {
        totalCredit += credit.toDouble();
      }
    }

    // Allow for small floating point differences
    const tolerance = 0.001;
    if ((totalDebit - totalCredit).abs() > tolerance) {
      errors.add(ValidationError(
        fieldName: 'p_lines',
        fieldValue: 'Debit: $totalDebit, Credit: $totalCredit',
        message:
            'Total debits ($totalDebit) must equal total credits ($totalCredit)',
        validationRule: 'balance_check',
      ));
    }

    return errors;
  }

  /// Validates based on RPC type requirements
  static List<ValidationError> _validateByRpcType({
    required List<Map<String, dynamic>> lines,
    required TemplateRpcType rpcType,
  }) {
    final errors = <ValidationError>[];

    switch (rpcType) {
      case TemplateRpcType.cashCash:
        // Both lines must have cash.cash_location_id
        for (var i = 0; i < lines.length; i++) {
          final cash = lines[i]['cash'] as Map<String, dynamic>?;
          if (cash == null || cash['cash_location_id'] == null) {
            errors.add(ValidationError(
              fieldName: 'lines[$i].cash',
              fieldValue: '',
              message: 'Cash transfer requires cash location for all entries',
              validationRule: 'cash_cash_requirement',
            ));
          }
        }

      case TemplateRpcType.internal:
        // Must have at least one line with counterparty_store reference
        final hasCounterpartyStore = lines.any((line) {
          final cash = line['cash'] as Map<String, dynamic>?;
          return cash?['counterparty_store_id'] != null ||
              line['counterparty_store_id'] != null;
        });
        if (!hasCounterpartyStore) {
          errors.add(const ValidationError(
            fieldName: 'p_lines',
            fieldValue: '',
            message: 'Internal transfer requires counterparty store information',
            validationRule: 'internal_requirement',
          ));
        }

      case TemplateRpcType.externalDebt:
        // Must have at least one line with debt object
        final hasDebtObject = lines.any((line) => line['debt'] != null);
        if (!hasDebtObject) {
          errors.add(const ValidationError(
            fieldName: 'p_lines',
            fieldValue: '',
            message: 'External debt transaction requires debt configuration',
            validationRule: 'external_debt_requirement',
          ));
        }

      case TemplateRpcType.expenseRevenueCash:
        // Must have at least one cash line and one expense/revenue line
        final hasCash = lines.any((line) => line['cash'] != null);
        if (!hasCash) {
          errors.add(const ValidationError(
            fieldName: 'p_lines',
            fieldValue: '',
            message: 'Revenue/expense transaction requires cash account',
            validationRule: 'expense_revenue_requirement',
          ));
        }

      case TemplateRpcType.generalJournal:
        // General journal: just needs valid account_ids and balanced debits/credits
        // No special requirements - basic validation is enough
        break;

      case TemplateRpcType.unknown:
        errors.add(const ValidationError(
          fieldName: 'rpc_type',
          fieldValue: '',
          message: 'Unable to determine transaction type',
          validationRule: 'known_type_requirement',
        ));
    }

    return errors;
  }

  /// Quick validation check (returns true/false without error details)
  static bool isValid({
    required List<Map<String, dynamic>> lines,
    required TemplateRpcType rpcType,
    required double amount,
  }) {
    final errors = validate(
      lines: lines,
      rpcType: rpcType,
      amount: amount,
    );
    return errors.isEmpty;
  }

  /// Get first error message (for simple UI display)
  static String? getFirstErrorMessage({
    required List<Map<String, dynamic>> lines,
    required TemplateRpcType rpcType,
    required double amount,
  }) {
    final errors = validate(
      lines: lines,
      rpcType: rpcType,
      amount: amount,
    );
    return errors.isEmpty ? null : errors.first.message;
  }
}
