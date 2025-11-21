/**
 * Account IDs Constants
 * Fixed account IDs used throughout the application
 *
 * NOTE: These IDs are specific to the database and should not be changed
 * unless the corresponding accounts are updated in the database.
 */

/**
 * Standard Chart of Accounts IDs
 */
export const ACCOUNT_IDS = {
  /**
   * Cash Account
   * Used for all cash transactions and cash ending adjustments
   */
  CASH: 'd4a7a16e-45a1-47fe-992b-ff807c8673f0',

  /**
   * Sales Revenue Account
   * Used for recording sales revenue and refunds
   */
  SALES_REVENUE: 'e45e7d41-7fda-43a1-ac55-9779f3e59697',

  /**
   * Make Error Account
   * Used to record cash discrepancies and errors
   */
  MAKE_ERROR: 'a45fac5d-010c-4b1b-92e9-ddcf8f3222bf',

  /**
   * Foreign Exchange Rate Difference Account
   * Used to record gains/losses from foreign currency translation
   */
  EXCHANGE_RATE_DIFFERENCE: '80b311db-f548-46e3-9854-67c5ff6766e8',
} as const;

/**
 * Type-safe account ID type
 */
export type AccountId = typeof ACCOUNT_IDS[keyof typeof ACCOUNT_IDS];

/**
 * Account metadata for display purposes
 */
export const ACCOUNT_METADATA = {
  [ACCOUNT_IDS.CASH]: {
    name: 'Cash',
    code: '1010',
    category: 'Asset',
    description: 'Cash account for all cash transactions',
  },
  [ACCOUNT_IDS.SALES_REVENUE]: {
    name: 'Sales Revenue',
    code: '4010',
    category: 'Revenue',
    description: 'Account for sales revenue and refunds',
  },
  [ACCOUNT_IDS.MAKE_ERROR]: {
    name: 'Make Error',
    code: '8010',
    category: 'Expense',
    description: 'Account for cash discrepancies and errors',
  },
  [ACCOUNT_IDS.EXCHANGE_RATE_DIFFERENCE]: {
    name: 'Foreign Exchange Gain/Loss',
    code: '8020',
    category: 'Income/Expense',
    description: 'Account for foreign currency translation differences',
  },
} as const;

/**
 * Get account metadata by ID
 */
export function getAccountMetadata(accountId: string) {
  return ACCOUNT_METADATA[accountId as AccountId] || null;
}

/**
 * Validate if account ID is a valid known account
 */
export function isValidAccountId(accountId: string): boolean {
  return Object.values(ACCOUNT_IDS).includes(accountId as any);
}
