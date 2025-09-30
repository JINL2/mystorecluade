# PRODUCTION TO STRUCTURE MAPPING
## Exact Line-by-Line Mapping from Production to New LEGO Architecture

### 📍 PRODUCTION FILE
**Source**: `/Users/jinlee/Desktop/mystorecluade-main/myFinance_improved_V1/lib/presentation/pages/cash_ending/cash_ending_page.dart`
**Lines**: 6,288

### 🎯 TARGET STRUCTURE
**Destination**: `/Applications/XAMPP/xamppfiles/htdocs/mysite/mystorecluade/myFinance_improved_V1/lib/presentation/pages/cash_ending/`

---

## 📑 DETAILED LINE MAPPING

### **IMPORTS SECTION (Lines 1-31)**
```
Lines 1-31 → cash_ending_page.dart (main file)
- Will be distributed to relevant files based on usage
```

---

### **STATE VARIABLES (Lines 42-121)**
```
Line 43-44   → state/providers/cash_ending_state.dart
  selectedStoreId, selectedLocationId
  
Lines 47-48  → state/providers/cash_ending_state.dart  
  recentCashEndings, isLoadingRecentEndings
  
Lines 51-59  → state/providers/currency_state.dart
  currencyTypes, isLoadingCurrency, companyCurrencies, currencyDenominations
  
Lines 61-67  → state/providers/location_state.dart
  cashLocations, isLoadingCashLocations, bankLocations, isLoadingBankLocations
  
Lines 70-85  → state/providers/bank_state.dart
  bankAmountController, selectedBankCurrencyType, recentBankTransactions,
  isSettingBankCurrency, tempSelectedBankCurrency, isSavingBankCurrency,
  allBankTransactions, isLoadingAllTransactions, hasMoreTransactions
  
Lines 88-97  → state/providers/vault_state.dart
  vaultBalanceData, isLoadingVaultBalance, vaultTransactionType,
  vaultLocations, isLoadingVaultLocations, selectedVaultLocationId
  
Lines 100-104 → state/controllers/denomination_controller_state.dart
  stores, isLoadingStores, denominationControllers
  
Lines 107-121 → state/providers/flow_state.dart
  selectedCashCurrencyId, selectedBankCurrencyId, selectedVaultCurrencyId,
  journalFlows, actualFlows, locationSummary, isLoadingFlows, flowsOffset
```

---

### **LIFECYCLE METHODS (Lines 123-202)**
```
Lines 123-182 → cash_ending_page.dart (initState)
Lines 185-202 → cash_ending_page.dart (dispose)
```

---

### **DATA LOADING FUNCTIONS (Lines 205-525)**
```
Lines 205-273   → data/services/currency_service.dart
  _loadCompanyCurrencies()
  
Lines 276-334   → data/services/currency_service.dart
  _loadCurrencyDenominations()
  
Lines 337-361   → data/services/currency_service.dart
  _loadCurrencyTypes()
  
Lines 364-394   → data/services/location_service.dart
  _loadStores()
  
Lines 397-414   → data/services/currency_service.dart
  getDefaultCurrency()
  
Lines 418-525   → data/services/location_service.dart
  _fetchLocations()
```

---

### **PERMISSION CHECK (Lines 527-556)**
```
Lines 527-556 → core/utils/permissions.dart
  _hasVaultBankPermission()
```

---

### **BUILD METHOD & MAIN SCAFFOLD (Lines 559-625)**
```
Lines 559-625 → cash_ending_page.dart
  @override Widget build()
```

---

### **DISABLED TAB CONTENT (Lines 627-655)**
```
Lines 627-655 → ui/widgets/common/disabled_tab_content.dart
  _buildDisabledTabContent()
```

---

### **CASH TAB (Lines 657-693)**
```
Lines 657-693 → ui/tabs/cash/cash_tab.dart
  _buildCashTab()
```

---

### **BANK TAB FUNCTIONS (Lines 2055-3560)**
```
Lines 2055-2092  → ui/tabs/bank/bank_tab.dart
  _buildBankTab()
  
Lines 2093-2188  → ui/tabs/bank/bank_amount_input.dart
  _buildBankAmountInput()
  
Lines 2189-2206  → ui/tabs/bank/bank_save_button.dart
  _buildBankSaveButton()
  
Lines 2207-2275  → data/services/bank_transaction_service.dart
  _fetchRecentBankTransactions()
  
Lines 2276-2314  → data/services/vault_service.dart
  _fetchVaultBalance()
  
Lines 2315-2445  → data/services/bank_transaction_service.dart
  _fetchAllBankTransactions()
  
Lines 2446-2588  → data/services/bank_service.dart
  _saveBankBalance() [CRITICAL: Line 2510-2511 RPC]
  
Lines 2589-2713  → data/services/bank_service.dart
  _saveBankLocationCurrency()
  
Lines 2714-2844  → ui/sheets/transaction_bottom_sheet.dart
  _showAllTransactionsBottomSheet()
  
Lines 2845-2990  → ui/widgets/transaction/transaction_card.dart
  _buildTransactionCard()
  
Lines 2991-3100  → ui/dialogs/bank_result_dialog.dart
  _showBankBalanceResultDialog()
  
Lines 3101-3374  → ui/tabs/bank/bank_currency_selector.dart
  _buildBankCurrencySelector()
  
Lines 3375-3560  → ui/tabs/bank/bank_transaction_history.dart
  _buildBankTransactionHistory()
```

---

### **VAULT TAB FUNCTIONS (Lines 3561-4041)**
```
Lines 3561-3600  → ui/tabs/vault/vault_tab.dart
  _buildVaultTab()
  
Lines 3601-3606  → core/utils/denomination_helpers.dart
  _getDenominationValueAsString()
  
Lines 3607-3615  → core/utils/calculators.dart
  _calculateSubtotal()
  
Lines 3616-3629  → core/utils/validators.dart
  _currencyHasData()
  
Lines 3630-3668  → core/utils/calculators.dart
  _calculateTotal()
  
Lines 3669-3721  → core/utils/calculators.dart
  _calculateTotalAmount()
  
Lines 3722-3831  → data/services/vault_service.dart
  _saveVaultBalance() [CRITICAL: Line 3790-3791 RPC]
  
Lines 3832-4041  → data/services/cash_service.dart
  _saveCashEnding() [CRITICAL: Line 3985-3986 RPC]
```

---

### **SUCCESS DIALOG & HELPERS (Lines 4042-4453)**
```
Lines 4042-4147  → ui/dialogs/success_bottom_sheet.dart
  _showSuccessBottomSheet()
  
Lines 4148-4394  → ui/sheets/store_selector_sheet.dart
  _showStoreSelector()
  
Lines 4395-4425  → data/services/currency_service.dart
  getBaseCurrency()
  
Lines 4426-4453  → core/utils/formatters.dart
  formatCurrency()
```

---

### **DATA REFRESH & LOADING (Lines 4454-4706)**
```
Lines 4454-4458  → cash_ending_page.dart
  _refreshData()
  
Lines 4459-4629  → data/services/cash_history_service.dart
  _loadRecentCashEndings()
  
Lines 4630-4706  → data/services/stock_flow_service.dart
  _fetchLocationStockFlow()
```

---

### **FORMATTERS (Lines 4707-4726)**
```
Lines 4707-4712  → core/utils/formatters.dart
  _formatCurrency()
  
Lines 4713-4720  → core/utils/formatters.dart
  _formatTransactionAmount()
  
Lines 4721-4726  → core/utils/formatters.dart
  _formatBalance()
```

---

### **FILTER SHEET (Lines 4727-4826)**
```
Lines 4727-4793  → ui/sheets/filter_bottom_sheet.dart
  _showFilterBottomSheet()
  
Lines 4794-4826  → ui/widgets/filter/filter_option.dart
  _buildFilterOption()
```

---

### **REAL/JOURNAL TABS (Lines 4827-6140)**
```
Lines 4827-4961   → ui/tabs/real/real_tab_content.dart
  _buildRealTabContent()
  
Lines 4962-5090   → ui/tabs/journal/journal_tab_content.dart
  _buildJournalTabContent()
  
Lines 5091-5226   → ui/widgets/real_journal/real_item.dart
  _buildRealItem()
  
Lines 5227-5357   → ui/widgets/real_journal/journal_item.dart
  _buildJournalItem()
  
Lines 5358-5782   → ui/sheets/real_detail_bottom_sheet.dart
  _showRealDetailBottomSheet()
  
Lines 5783-6000   → ui/sheets/journal_detail_bottom_sheet.dart
  _showJournalDetailBottomSheet()
  
Lines 6001-6031   → ui/widgets/detail/detail_row.dart
  _buildDetailRow()
  
Lines 6032-6056   → ui/widgets/detail/info_row.dart
  _buildInfoRow()
  
Lines 6057-6140   → ui/widgets/real_journal/real_journal_section.dart
  _buildRealJournalSection()
```

---

### **TOGGLE BUTTON WIDGETS (Lines 6144-6288)**
```
Lines 6144-6226  → ui/widgets/common/toggle_buttons.dart
  class TossToggleButton
  
Lines 6229-6271  → ui/widgets/common/toggle_buttons.dart
  class TossToggleButtonGroup
  
Lines 6274-6288  → ui/widgets/common/toggle_buttons.dart
  class TossToggleButtonData
```

---

### **UI COMPONENT BUILDERS (Lines 936-2020)**
```
Lines 936-958    → ui/tabs/vault/debit_credit_toggle.dart
  _buildDebitCreditToggle()
  
Lines 959-1250   → ui/tabs/vault/vault_balance.dart
  _buildVaultBalance()
  
Lines 1251-1314  → ui/widgets/history/history_item.dart
  _buildHistoryItem()
  
Lines 1315-1441  → ui/widgets/common/store_selector.dart
  _buildStoreSelector()
  
Lines 1442-1637  → ui/widgets/common/location_selector.dart
  _buildLocationSelector()
  
Lines 1638-1704  → ui/widgets/denomination/denomination_section.dart
  _buildDenominationSection()
  
Lines 1705-1761  → ui/widgets/denomination/denomination_list.dart
  _buildDenominationList()
  
Lines 1762-1835  → ui/widgets/denomination/currency_selector.dart
  _buildCurrencySelector()
  
Lines 1836-1963  → ui/widgets/denomination/denomination_input.dart
  _buildDenominationInput()
  
Lines 1964-2020  → ui/widgets/common/total_section.dart
  _buildTotalSection()
  
Lines 2021-2054  → ui/widgets/common/submit_button.dart
  _buildSubmitButton()
```

---

## 📊 FILE COUNT SUMMARY

| Directory | Files | Total Lines |
|-----------|-------|-------------|
| cash_ending_page.dart | 1 | ~400 |
| core/ | 6 | ~350 |
| data/services/ | 12 | ~2100 |
| state/ | 8 | ~200 |
| ui/tabs/ | 10 | ~800 |
| ui/widgets/ | 20 | ~1800 |
| ui/dialogs/ | 3 | ~450 |
| ui/sheets/ | 8 | ~1100 |
| **TOTAL** | **68** | **~7200** |

---

## ⚠️ CRITICAL PRESERVATION CHECKLIST

### RPC CALLS (MUST BE EXACT)
- [ ] Line 3985-3986: `insert_cashier_amount_lines`
- [ ] Line 2510-2511: `bank_amount_insert_v2`
- [ ] Line 3790-3791: `vault_amount_insert`

### CONTROLLER LIFECYCLE
- [ ] Line 104: denominationControllers initialization
- [ ] Line 196-201: Controller disposal pattern
- [ ] Line 70: bankAmountController

### STATE DEPENDENCIES
- [ ] Line 42-121: All state variables preserved
- [ ] TabController management
- [ ] Navigation lock clearing (129-136)

### UI STRUCTURE
- [ ] Tab structure preserved
- [ ] Widget hierarchy maintained
- [ ] Modal presentations unchanged

---

## 🔍 VALIDATION MATRIX

| Production Line Range | Target File | Status | Verified |
|----------------------|-------------|---------|----------|
| 1-31 | Distributed to files | ⏳ | ☐ |
| 42-121 | state/* | ⏳ | ☐ |
| 123-202 | cash_ending_page.dart | ⏳ | ☐ |
| 205-525 | data/services/* | ⏳ | ☐ |
| 527-556 | core/utils/permissions.dart | ⏳ | ☐ |
| 559-625 | cash_ending_page.dart | ⏳ | ☐ |
| 657-693 | ui/tabs/cash/cash_tab.dart | ⏳ | ☐ |
| 936-2054 | ui/widgets/* | ⏳ | ☐ |
| 2055-3560 | ui/tabs/bank/* | ⏳ | ☐ |
| 3561-4041 | ui/tabs/vault/* | ⏳ | ☐ |
| 4042-4706 | Various | ⏳ | ☐ |
| 4727-6140 | ui/sheets/* ui/widgets/real_journal/* | ⏳ | ☐ |
| 6144-6288 | ui/widgets/common/toggle_buttons.dart | ⏳ | ☐ |

---

## 📝 MIGRATION NOTES

1. **Import Management**: After splitting, update import paths in each file
2. **Context Passing**: Ensure BuildContext is passed where needed
3. **State Access**: Use proper Consumer/ConsumerWidget patterns
4. **Method Visibility**: Convert private methods to public where needed for cross-file access
5. **Parameter Passing**: Ensure all required parameters are passed to extracted functions

---

## ✅ POST-MIGRATION VERIFICATION

### Phase 1: Structural
- [ ] All 6,288 lines accounted for
- [ ] No duplicate code
- [ ] No missing functionality

### Phase 2: Functional
- [ ] App compiles without errors
- [ ] All imports resolved
- [ ] State management working

### Phase 3: Behavioral
- [ ] UI renders identically
- [ ] All user interactions work
- [ ] Database operations succeed

### Phase 4: Performance
- [ ] No performance degradation
- [ ] Memory usage normal
- [ ] Build time acceptable

---

**CRITICAL**: This mapping must be followed EXACTLY. Any deviation could break functionality. Always refer back to the production code at `/Users/jinlee/Desktop/mystorecluade-main/.../cash_ending_page.dart` for verification.