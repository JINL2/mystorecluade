/// Simple Selectors - Static selection bottom sheets
///
/// These are simple selectors that work with raw data (Map<String, dynamic>).
/// For autonomous state-managed selectors, use the domain selectors
/// (account/, cash_location/, counterparty/).
///
/// All selectors use "Simple" prefix to avoid naming conflicts with
/// feature-specific selector widgets.
library;

export 'store_selector.dart' show SimpleStoreSelector;
export 'company_selector.dart' show SimpleCompanySelector;
export 'simple_account_selector.dart' show SimpleAccountSelector;
export 'simple_cash_location_selector.dart' show SimpleCashLocationSelector;
