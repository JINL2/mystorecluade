/// Core Domain Constants - Account IDs
///
/// These are stable account IDs used across multiple features.
/// IMPORTANT: Keep all account IDs centralized here to avoid duplication
/// and maintain Clean Architecture (no cross-feature domain imports).
class AccountIds {
  AccountIds._(); // Private constructor - utility class

  // ============================================================
  // ASSET ACCOUNTS (자산)
  // ============================================================

  /// Cash account ID for journal entries (현금)
  /// Code: 1000
  static const String cash = 'd4a7a16e-45a1-47fe-992b-ff807c8673f0';

  /// Accounts Receivable (미수금) - money owed TO us
  /// Code: 1100
  /// Used for: Lend Money (돈 빌려줌), Collect Debt (빌려준 돈 회수)
  static const String accountsReceivable = '600bac8d-d8a7-40c2-8e0e-44f90fde5f07';

  /// Inventory account (재고자산)
  /// Code: 1200
  /// Used for: Inventory tracking, COGS calculation
  static const String inventory = '8babc1b3-47b4-4982-8f50-099ab9cdcaf9';

  /// Inter-branch Receivable (지점간 미수금) - money owed from other store/branch
  /// Code: 1360
  /// Used for: Transfer between stores in SAME company
  static const String interBranchReceivable = '70910193-f3a4-4ff1-91ee-ca299bc0f532';

  /// Note Receivable (받을어음) - money owed from ANOTHER company
  /// Code: 1110
  /// Used for: Transfer between DIFFERENT companies
  static const String noteReceivable = 'f04a4895-5846-450f-8fe9-08f1182d23d1';

  // ============================================================
  // LIABILITY ACCOUNTS (부채)
  // ============================================================

  /// Accounts Payable (미지급금) - money we OWE
  /// Code: 2000
  /// Used for: Borrow Money (돈 빌림), Repay Debt (빌린 돈 갚음)
  static const String accountsPayable = '2e61e534-a9fa-4648-bfaf-bb0077ddaffc';

  /// Notes Payable (지급어음) - money owed TO another company
  /// Code: 2010
  /// Used for: Transfer between DIFFERENT companies
  static const String notePayable = 'e2ab1c58-f374-46b7-9c5b-ff5929ad4027';

  /// Inter-branch Payable (지점간 미지급금) - money owed to other store/branch
  /// Code: 2360
  /// Used for: Transfer between stores in SAME company
  static const String interBranchPayable = '37efeb1a-31e1-4730-a584-8568e0b1e111';

  // ============================================================
  // REVENUE ACCOUNTS (수익)
  // ============================================================

  /// Sales Revenue account (매출)
  /// Code: 4000
  /// Used for: Sales invoices, product sales
  static const String salesRevenue = 'e45e7d41-7fda-43a1-ac55-9779f3e59697';

  // ============================================================
  // EXPENSE ACCOUNTS (비용)
  // ============================================================

  /// Cost of Goods Sold (매출원가)
  /// Code: 5000
  /// Used for: Inventory cost matching with sales
  static const String cogs = '90565fe4-5bfc-4c5e-8759-af9a64e98cae';

  // ============================================================
  // OTHER ACCOUNTS (기타)
  // ============================================================

  /// Foreign currency translation account (외화환산)
  /// Used for: Currency exchange adjustments
  static const String foreignCurrencyTranslation = '80b311db-f548-46e3-9854-67c5ff6766e8';

  /// Error adjustment account (오차조정)
  /// Used for: Cash ending discrepancy adjustments
  static const String errorAdjustment = 'a45fac5d-010c-4b1b-92e9-ddcf8f3222bf';
}
