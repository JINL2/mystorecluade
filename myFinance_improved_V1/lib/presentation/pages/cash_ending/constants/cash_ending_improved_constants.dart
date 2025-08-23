/// Constants for Cash Ending Page - Improved Version
/// 
/// This file contains all constants used in the Cash Ending page to replace
/// hardcoded values and maintain consistency across the application.
class CashEndingConstants {
  CashEndingConstants._();

  // ==================== UI DIMENSIONS ====================
  /// Denomination input field dimensions
  static const double denominationLabelWidth = 80.0;
  static const double denominationInputHeight = 48.0;
  static const double denominationIndicatorSize = 8.0;
  
  /// Transaction list item heights
  static const double transactionItemHeight = 72.0;
  static const double transactionItemPadding = 16.0;
  
  /// Tab bar configuration
  static const double tabBarHeight = 48.0;
  static const List<String> tabLabels = ['Cash', 'Bank', 'Vault'];

  // ==================== CURRENCY SETTINGS ====================
  /// Default currency settings
  static const String defaultCurrencyCode = 'KRW';
  static const String defaultCurrencySymbol = '₩';
  static const String defaultCurrencyName = 'Korean Won';
  
  /// Amount formatting
  static const int currencyDecimalPlaces = 0;
  static const String quantityUnit = 'pcs';

  // ==================== VALIDATION THRESHOLDS ====================
  /// Amount thresholds for validation and indicators
  static const double highAmountThreshold = 10000.0;
  static const double warningAmountThreshold = 50000.0;
  static const double maxAllowedAmount = 1000000.0;
  
  /// Input validation
  static const int maxQuantityDigits = 6;
  static const int maxAmountDigits = 10;

  // ==================== TRANSACTION SETTINGS ====================
  /// Transaction pagination
  static const int transactionPageSize = 10;
  static const int maxTransactionHistory = 100;
  
  /// Transaction types
  static const String transactionTypeCash = 'cash';
  static const String transactionTypeBank = 'bank';
  static const String transactionTypeVault = 'vault';
  
  /// Transaction statuses
  static const String statusPending = 'pending';
  static const String statusCompleted = 'completed';
  static const String statusCancelled = 'cancelled';

  // ==================== ERROR MESSAGES ====================
  /// Validation error messages
  static const String errorStoreRequired = 'Please select a store';
  static const String errorLocationRequired = 'Please select a location';
  static const String errorCurrencyRequired = 'Please select a currency';
  static const String errorAmountInvalid = 'Please enter a valid amount';
  static const String errorAmountTooLarge = 'Amount exceeds maximum limit';
  static const String errorQuantityInvalid = 'Please enter a valid quantity';
  
  /// Network error messages
  static const String errorNetworkConnection = 'Network connection failed';
  static const String errorDataLoad = 'Failed to load data';
  static const String errorDataSave = 'Failed to save data';
  static const String errorTransactionLoad = 'Failed to load transaction history';

  // ==================== SUCCESS MESSAGES ====================
  /// Success feedback messages
  static const String successCashEndingSaved = 'Cash ending saved successfully';
  static const String successBankTransactionSaved = 'Bank transaction saved successfully';
  static const String successVaultTransactionSaved = 'Vault transaction saved successfully';
  static const String successDataRefreshed = 'Data refreshed successfully';

  // ==================== LOCALIZATION KEYS ====================
  /// Localized text keys for future i18n support
  static const String keyPageTitle = 'cash_ending.page_title';
  static const String keyTabCash = 'cash_ending.tab_cash';
  static const String keyTabBank = 'cash_ending.tab_bank';
  static const String keyTabVault = 'cash_ending.tab_vault';
  static const String keySelectStore = 'cash_ending.select_store';
  static const String keySelectLocation = 'cash_ending.select_location';
  static const String keyTotalAmount = 'cash_ending.total_amount';
  static const String keyRecentTransactions = 'cash_ending.recent_transactions';
  static const String keyNoTransactions = 'cash_ending.no_transactions';
  static const String keyLoadMore = 'cash_ending.load_more';
  static const String keySave = 'cash_ending.save';
  static const String keyCancel = 'cash_ending.cancel';
  static const String keyRefresh = 'cash_ending.refresh';

  // ==================== ANIMATION SETTINGS ====================
  /// Animation durations for smooth transitions
  static const int fadeAnimationDuration = 300;
  static const int slideAnimationDuration = 250;
  static const int scaleAnimationDuration = 150;
  
  /// Animation curves
  static const String animationCurveEaseInOut = 'ease_in_out';
  static const String animationCurveEaseOut = 'ease_out';

  // ==================== DATA REFRESH SETTINGS ====================
  /// Auto-refresh configuration
  static const int autoRefreshInterval = 30000; // 30 seconds
  static const int maxRetryAttempts = 3;
  static const int retryDelay = 2000; // 2 seconds
  
  /// Cache settings
  static const int cacheTimeout = 300000; // 5 minutes
  static const int maxCacheSize = 50; // entries

  // ==================== ACCESSIBILITY ====================
  /// Accessibility labels and hints
  static const String accessibilityStoreSelector = 'Select store for cash ending';
  static const String accessibilityLocationSelector = 'Select cash location';
  static const String accessibilityCurrencySelector = 'Select currency type';
  static const String accessibilityDenominationInput = 'Enter quantity for denomination';
  static const String accessibilityTotalAmount = 'Total calculated amount';
  static const String accessibilitySaveButton = 'Save cash ending transaction';
  static const String accessibilityRefreshButton = 'Refresh transaction data';
  
  /// Screen reader descriptions
  static const String descriptionCashEndingPage = 'Cash ending management page with tabs for cash, bank, and vault operations';
  static const String descriptionTransactionHistory = 'Recent transaction history list';
  static const String descriptionDenominationList = 'Currency denomination input list';

  // ==================== BUSINESS RULES ====================
  /// Business logic constants
  static const double minimumTransactionAmount = 0.01;
  static const int maxDecimalPlaces = 2;
  static const int maxTransactionDescriptionLength = 255;
  
  /// Audit trail settings
  static const bool enableAuditLog = true;
  static const String auditActionCreate = 'CREATE';
  static const String auditActionUpdate = 'UPDATE';
  static const String auditActionDelete = 'DELETE';
}