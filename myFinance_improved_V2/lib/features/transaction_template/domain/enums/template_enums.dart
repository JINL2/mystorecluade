/// Template visibility level constants (matching original string-based approach)
class VisibilityLevels {
  static const String public = 'public';
  static const String private = 'private';
  static const String team = 'team';

  /// All available visibility levels
  static const List<String> all = [public, private, team];

  /// Validates if a visibility level is valid
  static bool isValid(String level) => all.contains(level);

  /// Gets display name for a visibility level
  static String getDisplayName(String level) {
    switch (level) {
      case public:
        return 'Public';
      case private:
        return 'Private';
      case team:
        return 'Team';
      default:
        return level;
    }
  }
}

/// Template permission level constants (matching original string-based approach)
class PermissionLevels {
  static const String common = 'common';
  static const String manager = 'manager';
  static const String admin = 'admin';

  /// All available permission levels
  static const List<String> all = [common, manager, admin];

  /// Validates if a permission level is valid
  static bool isValid(String level) => all.contains(level);

  /// Gets display name for a permission level
  static String getDisplayName(String level) {
    switch (level) {
      case common:
        return 'Common';
      case manager:
        return 'Manager';
      case admin:
        return 'Admin';
      default:
        return level;
    }
  }

  /// Checks if a permission level requires approval
  static bool requiresApproval(String level) {
    return level == manager || level == admin;
  }
}

/// Template form complexity levels (matching production pattern)
/// 
/// Defines the complexity levels for transaction template forms,
/// following the exact pattern used in production codebase.
enum FormComplexity {
  /// Only amount input needed
  simple,
  
  /// Need cash location selection  
  withCash,
  
  /// Need counterparty's cash location
  withCounterparty,
  
  /// Multiple selections needed
  complex
}

/// Extension methods for FormComplexity enum
extension FormComplexityExtension on FormComplexity {
  /// Gets display name for the complexity level
  String get displayName {
    switch (this) {
      case FormComplexity.simple:
        return 'Simple';
      case FormComplexity.withCash:
        return 'With Cash';
      case FormComplexity.withCounterparty:
        return 'With Counterparty';
      case FormComplexity.complex:
        return 'Complex';
    }
  }

  /// Gets detailed description of the complexity level
  String get description {
    switch (this) {
      case FormComplexity.simple:
        return 'Only amount input needed';
      case FormComplexity.withCash:
        return 'Need cash location selection';
      case FormComplexity.withCounterparty:
        return 'Need counterparty\'s cash location';
      case FormComplexity.complex:
        return 'Multiple selections needed';
    }
  }

  /// Checks if complexity level requires special permissions
  bool get requiresSpecialPermissions {
    return this == FormComplexity.complex;
  }

  /// Converts to string value (for serialization/storage)
  String get value {
    switch (this) {
      case FormComplexity.simple:
        return 'simple';
      case FormComplexity.withCash:
        return 'withCash';
      case FormComplexity.withCounterparty:
        return 'withCounterparty';
      case FormComplexity.complex:
        return 'complex';
    }
  }

  /// Creates FormComplexity from string value
  static FormComplexity fromString(String value) {
    switch (value.toLowerCase()) {
      case 'simple':
        return FormComplexity.simple;
      case 'withcash':
      case 'with_cash':
        return FormComplexity.withCash;
      case 'withcounterparty':
      case 'with_counterparty':
        return FormComplexity.withCounterparty;
      case 'complex':
        return FormComplexity.complex;
      default:
        return FormComplexity.simple; // Default fallback
    }
  }
}

/// Template RPC Type - Determines which RPC strategy to use
///
/// Purpose: Identifies the type of journal transaction for RPC parameter building.
/// Used by TemplateLinesBuilder to construct the correct p_lines structure.
///
/// Clean Architecture: DOMAIN LAYER - Enum (Business Logic Classification)
enum TemplateRpcType {
  /// Cash-to-Cash transfer: Both sides are cash accounts
  /// - Example: Transfer from wallet to safe
  /// - p_lines: 2 entries with cash_location_id
  cashCash,

  /// Internal transfer between stores: Uses linked_company_id
  /// - Example: Transfer to another company's store
  /// - p_lines: 2 entries with counterparty_store_id reference
  internal,

  /// External debt transaction: Payable/Receivable with external counterparty
  /// - Example: Loan to supplier, Payment from customer
  /// - p_lines: Entry with debt object (counterparty_id, direction, category)
  externalDebt,

  /// Revenue/Expense with Cash: Income or expense transaction
  /// - Example: Sales revenue, Utility expense
  /// - p_lines: Revenue/Expense account + Cash account entry
  expenseRevenueCash,

  /// Unknown or unsupported template type
  /// - Should trigger validation error in production
  unknown,
}

/// Extension methods for TemplateRpcType enum
extension TemplateRpcTypeExtension on TemplateRpcType {
  /// Gets display name for the RPC type
  String get displayName {
    switch (this) {
      case TemplateRpcType.cashCash:
        return 'Cash Transfer';
      case TemplateRpcType.internal:
        return 'Internal Transfer';
      case TemplateRpcType.externalDebt:
        return 'External Debt';
      case TemplateRpcType.expenseRevenueCash:
        return 'Revenue/Expense';
      case TemplateRpcType.unknown:
        return 'Unknown';
    }
  }

  /// Gets description for the RPC type
  String get description {
    switch (this) {
      case TemplateRpcType.cashCash:
        return 'Transfer between cash locations (wallet, safe, etc.)';
      case TemplateRpcType.internal:
        return 'Transfer between internal company stores';
      case TemplateRpcType.externalDebt:
        return 'Debt transaction with external counterparty';
      case TemplateRpcType.expenseRevenueCash:
        return 'Revenue or expense with cash payment';
      case TemplateRpcType.unknown:
        return 'Unable to determine transaction type';
    }
  }

  /// Checks if this type requires cash location selection
  bool get requiresCashLocation {
    return this == TemplateRpcType.cashCash ||
        this == TemplateRpcType.expenseRevenueCash;
  }

  /// Checks if this type requires counterparty selection
  bool get requiresCounterparty {
    return this == TemplateRpcType.externalDebt;
  }

  /// Checks if this type requires counterparty cash location
  bool get requiresCounterpartyCashLocation {
    return this == TemplateRpcType.internal;
  }

  /// Checks if this is a valid type for transaction creation
  bool get isValid => this != TemplateRpcType.unknown;

  /// Gets validation priority (higher = stricter validation)
  int get validationPriority {
    switch (this) {
      case TemplateRpcType.internal:
        return 10; // Highest - cross-company
      case TemplateRpcType.externalDebt:
        return 8; // High - external parties
      case TemplateRpcType.cashCash:
        return 5; // Medium - internal cash
      case TemplateRpcType.expenseRevenueCash:
        return 3; // Lower - standard transactions
      case TemplateRpcType.unknown:
        return 0; // Invalid
    }
  }
}

/// Account types for validation and business logic
///
/// Used to determine specific validation requirements for different
/// account types in transaction templates.
enum AccountType {
  /// Cash accounts - require cash location
  cash,
  
  /// Bank accounts - require bank location  
  bank,
  
  /// Accounts payable - require counterparty
  payable,
  
  /// Accounts receivable - require counterparty
  receivable,
  
  /// Revenue accounts
  revenue,
  
  /// Expense accounts
  expense,
  
  /// Asset accounts
  asset,
  
  /// Liability accounts
  liability,
  
  /// Other/unknown account types
  other,
}

/// Extension methods for AccountType enum
extension AccountTypeExtension on AccountType {
  /// Gets display name for the account type
  String get displayName {
    switch (this) {
      case AccountType.cash:
        return 'Cash';
      case AccountType.bank:
        return 'Bank';
      case AccountType.payable:
        return 'Accounts Payable';
      case AccountType.receivable:
        return 'Accounts Receivable';
      case AccountType.revenue:
        return 'Revenue';
      case AccountType.expense:
        return 'Expense';
      case AccountType.asset:
        return 'Asset';
      case AccountType.liability:
        return 'Liability';
      case AccountType.other:
        return 'Other';
    }
  }

  /// Checks if this account type requires counterparty information
  bool get requiresCounterparty {
    return this == AccountType.payable || 
           this == AccountType.receivable;
  }

  /// Checks if this account type requires cash location
  bool get requiresCashLocation {
    return this == AccountType.cash ||
           this == AccountType.bank;
  }

  /// Checks if this account type is a balance sheet account
  bool get isBalanceSheetAccount {
    return this == AccountType.cash ||
           this == AccountType.bank ||
           this == AccountType.payable ||
           this == AccountType.receivable ||
           this == AccountType.asset ||
           this == AccountType.liability;
  }

  /// Checks if this account type is an income statement account
  bool get isIncomeStatementAccount {
    return this == AccountType.revenue ||
           this == AccountType.expense;
  }

  /// Gets validation priority (higher = more strict validation)
  int get validationPriority {
    switch (this) {
      case AccountType.cash:
      case AccountType.bank:
        return 10; // Highest priority - cash handling
      case AccountType.payable:
      case AccountType.receivable:
        return 8;  // High priority - external relationships
      case AccountType.revenue:
      case AccountType.expense:
        return 5;  // Medium priority
      case AccountType.asset:
      case AccountType.liability:
        return 3;  // Lower priority
      case AccountType.other:
        return 1;  // Lowest priority
    }
  }
}