/// Currency-related state variables
/// FROM PRODUCTION LINES 51-59 and 107-109
class CurrencyState {
  // Currency data from Supabase (Lines 51-52)
  final List<Map<String, dynamic>> currencyTypes;
  final bool isLoadingCurrency;
  
  // Company currencies from Supabase (Line 55)
  final List<Map<String, dynamic>> companyCurrencies;
  
  // Currency denominations from Supabase (Line 58)
  final Map<String, List<Map<String, dynamic>>> currencyDenominations;
  
  // Selected currency for each tab (Lines 107-109)
  final String? selectedCashCurrencyId;
  final String? selectedBankCurrencyId;
  final String? selectedVaultCurrencyId;

  CurrencyState({
    this.currencyTypes = const [],
    this.isLoadingCurrency = true,
    this.companyCurrencies = const [],
    this.currencyDenominations = const {},
    this.selectedCashCurrencyId,
    this.selectedBankCurrencyId,
    this.selectedVaultCurrencyId,
  });

  CurrencyState copyWith({
    List<Map<String, dynamic>>? currencyTypes,
    bool? isLoadingCurrency,
    List<Map<String, dynamic>>? companyCurrencies,
    Map<String, List<Map<String, dynamic>>>? currencyDenominations,
    String? selectedCashCurrencyId,
    String? selectedBankCurrencyId,
    String? selectedVaultCurrencyId,
  }) {
    return CurrencyState(
      currencyTypes: currencyTypes ?? this.currencyTypes,
      isLoadingCurrency: isLoadingCurrency ?? this.isLoadingCurrency,
      companyCurrencies: companyCurrencies ?? this.companyCurrencies,
      currencyDenominations: currencyDenominations ?? this.currencyDenominations,
      selectedCashCurrencyId: selectedCashCurrencyId ?? this.selectedCashCurrencyId,
      selectedBankCurrencyId: selectedBankCurrencyId ?? this.selectedBankCurrencyId,
      selectedVaultCurrencyId: selectedVaultCurrencyId ?? this.selectedVaultCurrencyId,
    );
  }
}