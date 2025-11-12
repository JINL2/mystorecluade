/**
 * Dashboard Messages Constants
 * Domain layer - Centralized message strings for dashboard feature
 *
 * Purpose:
 * - Eliminate hardcoded strings
 * - Enable future i18n support
 * - Maintain consistent messaging
 * - Separate user-facing messages from technical errors
 */

export const DashboardMessages = {
  // ===== Error Messages (User-facing) =====
  errors: {
    // Data loading errors
    loadFailed: 'Failed to load dashboard data',
    loadFailedTitle: 'Data Load Failed',
    noDataReturned: 'No data returned from server',

    // Validation errors
    invalidCompanyId: 'Invalid company ID',
    companyIdRequired: 'Company ID is required',
    invalidCompanyIdFormat: 'Invalid company ID format (UUID required)',

    invalidDate: 'Invalid date format',
    dateRequired: 'Date is required',
    invalidDateFormat: 'Invalid date format (ISO 8601 format required)',

    // Network/RPC errors
    rpcFailed: 'Failed to communicate with server',
    rpcError: 'An error occurred during server request',
    unknownError: 'An unknown error occurred',
    unexpectedError: 'An unexpected error occurred',

    // Data integrity errors (console warnings only)
    negativeRevenue: 'Today revenue cannot be negative',
    negativeExpense: 'Today expense cannot be negative',
    negativeMonthRevenue: 'This month revenue cannot be negative',
    negativeLastMonthRevenue: 'Last month revenue cannot be negative',
    currencySymbolRequired: 'Currency symbol is required',
    currencyCodeRequired: 'Currency code is required',
    expensePercentageInvalid: 'Expense breakdown percentages do not sum to 100%',
  },

  // ===== Warning Messages =====
  warnings: {
    noExpenseData: 'No expense data for this month',
    noTransactions: 'No recent transactions',
    noDataAvailable: 'No data available to display',
    dataValidationWarnings: 'Data validation warnings exist',
  },

  // ===== Info Messages =====
  info: {
    loading: 'Loading...',
    loadingData: 'Loading data...',
    noCompanySelected: 'Please select a company',
  },

  // ===== Success Messages =====
  success: {
    dataLoaded: 'Dashboard data loaded successfully',
    refreshed: 'Data refreshed successfully',
  },

  // ===== Empty State Messages =====
  emptyStates: {
    noDashboardData: 'No dashboard data available',
    noExpenseData: 'No expense data for this month',
    noRecentActivity: 'No recent activity',
    noTransactions: 'No transactions',
  },

  // ===== Action Button Labels =====
  actions: {
    retry: 'Retry',
    close: 'Close',
    refresh: 'Refresh',
    ok: 'OK',
    cancel: 'Cancel',
  },

  // ===== Technical/Developer Messages (for console logs only) =====
  technical: {
    // Expense breakdown validation
    expenseItemCategoryRequired: (index: number) => `Expense item ${index + 1}: Category is required`,
    expenseItemNegative: (index: number) => `Expense item ${index + 1}: Amount cannot be negative`,
    expenseItemPercentageInvalid: (index: number) => `Expense item ${index + 1}: Percentage must be between 0-100`,

    // Transaction validation
    transactionIdRequired: (index: number) => `Transaction ${index + 1}: ID is required`,
    transactionDateRequired: (index: number) => `Transaction ${index + 1}: Date is required`,
    transactionDescriptionRequired: (index: number) => `Transaction ${index + 1}: Description is required`,
    transactionAmountNegative: (index: number) => `Transaction ${index + 1}: Amount cannot be negative`,
    transactionTypeInvalid: (index: number) => `Transaction ${index + 1}: Type must be 'income' or 'expense'`,

    // RPC debug messages
    rpcDebugFetch: (params: { companyId: string; date: string }) =>
      `📊 Fetching dashboard data: ${JSON.stringify(params)}`,
    rpcDebugResponse: (data: any, error: any) =>
      `📦 Dashboard RPC response: ${JSON.stringify({ data, error })}`,
    rpcDebugError: (error: any) =>
      `❌ Dashboard RPC error: ${error}`,
    rpcDebugSuccess: '✅ Dashboard data fetched successfully',
    rpcDebugNoData: '⚠️ No data returned from dashboard RPC',
    datasourceError: (error: any) =>
      `💥 Dashboard datasource error: ${error}`,
    validationWarnings: (errors: string[]) =>
      `⚠️ Dashboard data validation warnings: ${errors.join(', ')}`,
  },
} as const;

// Type exports for better type safety
export type DashboardErrorKey = keyof typeof DashboardMessages.errors;
export type DashboardWarningKey = keyof typeof DashboardMessages.warnings;
export type DashboardInfoKey = keyof typeof DashboardMessages.info;
export type DashboardSuccessKey = keyof typeof DashboardMessages.success;
export type DashboardEmptyStateKey = keyof typeof DashboardMessages.emptyStates;
export type DashboardActionKey = keyof typeof DashboardMessages.actions;
