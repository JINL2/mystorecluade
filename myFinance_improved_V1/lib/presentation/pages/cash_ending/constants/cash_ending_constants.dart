/// Constants for cash ending functionality
class CashEndingConstants {
  // Tab indices
  static const int cashTabIndex = 0;
  static const int bankTabIndex = 1;
  static const int vaultTabIndex = 2;

  // Tab labels
  static const String cashTabLabel = 'Cash';
  static const String bankTabLabel = 'Bank';
  static const String vaultTabLabel = 'Vault';

  // Permissions
  static const List<String> vaultBankPermissionRoles = ['owner', 'manager'];

  // UI Constants
  static const double tabBarHeight = 48.0;
  static const double tabBarBorderRadius = 24.0;
  static const double tabIndicatorBorderRadius = 22.0;
  static const double iconSize = 20.0;
  static const double loadingStrokeWidth = 2.0;

  // Pagination
  static const int transactionLimit = 10;
  static const int initialTransactionOffset = 0;

  // Messages
  static const String noPermissionMessage = 
      'You do not have permission to access Bank/Vault features';
  static const String noStoresMessage = 'No stores available';
  static const String noLocationsMessage = 'No locations available for this store';
  static const String noRecentCashEndingMessage = 
      'No recent cash ending found for this location';
  static const String noVaultBalanceMessage = 'No vault balance data available';
  static const String noBankTransactionsMessage = 'No recent bank transactions';
  static const String loadingCurrencyMessage = 'Loading currency data...';
  static const String selectStoreMessage = 'Please select a store first';
  static const String selectLocationMessage = 'Please select a location';
  static const String selectCurrencyMessage = 'Please select a currency';

  // Success Messages
  static const String cashEndingSavedMessage = 'Cash ending saved successfully';
  static const String bankBalanceSavedMessage = 'Bank balance saved successfully';
  static const String vaultBalanceSavedMessage = 'Vault balance saved successfully';

  // Error Messages
  static const String genericErrorMessage = 'An error occurred. Please try again.';
  static const String loadingErrorMessage = 'Failed to load data';
  static const String savingErrorMessage = 'Failed to save. Please try again.';

  // Location Types
  static const String cashLocationType = 'cash';
  static const String bankLocationType = 'bank';
  static const String vaultLocationType = 'vault';

  // Transaction Types
  static const String debitTransaction = 'debit';
  static const String creditTransaction = 'credit';

  // Time Constants
  static const Duration snackBarDuration = Duration(seconds: 2);
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration debounceDelay = Duration(milliseconds: 500);

  // Haptic Feedback
  static const bool enableHapticFeedback = true;

  // Number Formatting
  static const String decimalSeparator = '.';
  static const String thousandsSeparator = ',';
  static const String defaultCurrencySymbol = '\$';
  static const String defaultCurrencyCode = 'USD';

  // Database Table Names
  static const String cashEndingTable = 'cash_ending';
  static const String bankBalanceTable = 'bank_balance';
  static const String vaultBalanceTable = 'vault_balance';
  static const String currencyTypesTable = 'currency_types';
  static const String currencyDenominationsTable = 'currency_denominations';
  static const String companyCurrenciesTable = 'company_currencies';
  static const String companyLocationsTable = 'company_locations';

  // RPC Function Names
  static const String getAccountsRpc = 'get_accounts';
  static const String getCashLocationsRpc = 'get_cash_locations';
  static const String getStoresRpc = 'get_stores';
  static const String saveCashEndingRpc = 'save_cash_ending';
  static const String saveBankBalanceRpc = 'save_bank_balance';
  static const String saveVaultBalanceRpc = 'save_vault_balance';
}
