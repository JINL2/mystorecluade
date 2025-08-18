import 'package:flutter/material.dart';

/// State model for cash ending page
class CashEndingState {
  // Store and location selection
  final String? selectedStoreId;
  final String? selectedLocationId;
  
  // Recent cash endings
  final List<Map<String, dynamic>> recentCashEndings;
  final bool isLoadingRecentEndings;
  
  // Currency data
  final List<Map<String, dynamic>> currencyTypes;
  final bool isLoadingCurrency;
  final List<Map<String, dynamic>> companyCurrencies;
  final Map<String, List<Map<String, dynamic>>> currencyDenominations;
  
  // Cash locations
  final List<Map<String, dynamic>> cashLocations;
  final bool isLoadingCashLocations;
  
  // Bank locations
  final List<Map<String, dynamic>> bankLocations;
  final bool isLoadingBankLocations;
  final String? selectedBankLocationId;
  
  // Bank tab specific
  final TextEditingController bankAmountController;
  final String? selectedBankCurrencyType;
  final List<Map<String, dynamic>> recentBankTransactions;
  final bool isLoadingBankTransactions;
  
  // View all transactions
  final List<Map<String, dynamic>> allBankTransactions;
  final bool isLoadingAllTransactions;
  final bool hasMoreTransactions;
  final int transactionOffset;
  
  // Vault balance
  final Map<String, dynamic>? vaultBalanceData;
  final bool isLoadingVaultBalance;
  final String? vaultTransactionType;
  
  // Vault locations
  final List<Map<String, dynamic>> vaultLocations;
  final bool isLoadingVaultLocations;
  final String? selectedVaultLocationId;
  
  // Stores
  final List<Map<String, dynamic>> stores;
  final bool isLoadingStores;
  
  // Denomination controllers
  final Map<String, Map<String, TextEditingController>> denominationControllers;
  
  // Selected currency for each tab
  final String? selectedCashCurrencyId;
  final String? selectedBankCurrencyId;
  final String? selectedVaultCurrencyId;

  const CashEndingState({
    this.selectedStoreId,
    this.selectedLocationId,
    this.recentCashEndings = const [],
    this.isLoadingRecentEndings = false,
    this.currencyTypes = const [],
    this.isLoadingCurrency = true,
    this.companyCurrencies = const [],
    this.currencyDenominations = const {},
    this.cashLocations = const [],
    this.isLoadingCashLocations = false,
    this.bankLocations = const [],
    this.isLoadingBankLocations = false,
    this.selectedBankLocationId,
    required this.bankAmountController,
    this.selectedBankCurrencyType,
    this.recentBankTransactions = const [],
    this.isLoadingBankTransactions = false,
    this.allBankTransactions = const [],
    this.isLoadingAllTransactions = false,
    this.hasMoreTransactions = true,
    this.transactionOffset = 0,
    this.vaultBalanceData,
    this.isLoadingVaultBalance = false,
    this.vaultTransactionType,
    this.vaultLocations = const [],
    this.isLoadingVaultLocations = false,
    this.selectedVaultLocationId,
    this.stores = const [],
    this.isLoadingStores = true,
    this.denominationControllers = const {},
    this.selectedCashCurrencyId,
    this.selectedBankCurrencyId,
    this.selectedVaultCurrencyId,
  });

  CashEndingState copyWith({
    String? selectedStoreId,
    String? selectedLocationId,
    List<Map<String, dynamic>>? recentCashEndings,
    bool? isLoadingRecentEndings,
    List<Map<String, dynamic>>? currencyTypes,
    bool? isLoadingCurrency,
    List<Map<String, dynamic>>? companyCurrencies,
    Map<String, List<Map<String, dynamic>>>? currencyDenominations,
    List<Map<String, dynamic>>? cashLocations,
    bool? isLoadingCashLocations,
    List<Map<String, dynamic>>? bankLocations,
    bool? isLoadingBankLocations,
    String? selectedBankLocationId,
    TextEditingController? bankAmountController,
    String? selectedBankCurrencyType,
    List<Map<String, dynamic>>? recentBankTransactions,
    bool? isLoadingBankTransactions,
    List<Map<String, dynamic>>? allBankTransactions,
    bool? isLoadingAllTransactions,
    bool? hasMoreTransactions,
    int? transactionOffset,
    Map<String, dynamic>? vaultBalanceData,
    bool? isLoadingVaultBalance,
    String? vaultTransactionType,
    List<Map<String, dynamic>>? vaultLocations,
    bool? isLoadingVaultLocations,
    String? selectedVaultLocationId,
    List<Map<String, dynamic>>? stores,
    bool? isLoadingStores,
    Map<String, Map<String, TextEditingController>>? denominationControllers,
    String? selectedCashCurrencyId,
    String? selectedBankCurrencyId,
    String? selectedVaultCurrencyId,
  }) {
    return CashEndingState(
      selectedStoreId: selectedStoreId ?? this.selectedStoreId,
      selectedLocationId: selectedLocationId ?? this.selectedLocationId,
      recentCashEndings: recentCashEndings ?? this.recentCashEndings,
      isLoadingRecentEndings: isLoadingRecentEndings ?? this.isLoadingRecentEndings,
      currencyTypes: currencyTypes ?? this.currencyTypes,
      isLoadingCurrency: isLoadingCurrency ?? this.isLoadingCurrency,
      companyCurrencies: companyCurrencies ?? this.companyCurrencies,
      currencyDenominations: currencyDenominations ?? this.currencyDenominations,
      cashLocations: cashLocations ?? this.cashLocations,
      isLoadingCashLocations: isLoadingCashLocations ?? this.isLoadingCashLocations,
      bankLocations: bankLocations ?? this.bankLocations,
      isLoadingBankLocations: isLoadingBankLocations ?? this.isLoadingBankLocations,
      selectedBankLocationId: selectedBankLocationId ?? this.selectedBankLocationId,
      bankAmountController: bankAmountController ?? this.bankAmountController,
      selectedBankCurrencyType: selectedBankCurrencyType ?? this.selectedBankCurrencyType,
      recentBankTransactions: recentBankTransactions ?? this.recentBankTransactions,
      isLoadingBankTransactions: isLoadingBankTransactions ?? this.isLoadingBankTransactions,
      allBankTransactions: allBankTransactions ?? this.allBankTransactions,
      isLoadingAllTransactions: isLoadingAllTransactions ?? this.isLoadingAllTransactions,
      hasMoreTransactions: hasMoreTransactions ?? this.hasMoreTransactions,
      transactionOffset: transactionOffset ?? this.transactionOffset,
      vaultBalanceData: vaultBalanceData ?? this.vaultBalanceData,
      isLoadingVaultBalance: isLoadingVaultBalance ?? this.isLoadingVaultBalance,
      vaultTransactionType: vaultTransactionType ?? this.vaultTransactionType,
      vaultLocations: vaultLocations ?? this.vaultLocations,
      isLoadingVaultLocations: isLoadingVaultLocations ?? this.isLoadingVaultLocations,
      selectedVaultLocationId: selectedVaultLocationId ?? this.selectedVaultLocationId,
      stores: stores ?? this.stores,
      isLoadingStores: isLoadingStores ?? this.isLoadingStores,
      denominationControllers: denominationControllers ?? this.denominationControllers,
      selectedCashCurrencyId: selectedCashCurrencyId ?? this.selectedCashCurrencyId,
      selectedBankCurrencyId: selectedBankCurrencyId ?? this.selectedBankCurrencyId,
      selectedVaultCurrencyId: selectedVaultCurrencyId ?? this.selectedVaultCurrencyId,
    );
  }
}