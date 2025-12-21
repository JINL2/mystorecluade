import 'package:flutter/material.dart';

/// Bank tab specific state variables
/// FROM PRODUCTION LINES 70-85
class BankState {
  // Bank tab specific variables (Lines 70-73)
  final TextEditingController bankAmountController; // Line 70
  final String? selectedBankCurrencyType; // Selected currency_id for bank tab (Line 71)
  final List<Map<String, dynamic>> recentBankTransactions; // Line 72
  final bool isLoadingBankTransactions; // Line 73
  
  // Currency set mode for bank locations without currency (Lines 76-78)
  final bool isSettingBankCurrency; // Line 76
  final String? tempSelectedBankCurrency; // Temporarily selected currency before saving (Line 77)
  final bool isSavingBankCurrency; // Loading state for saving currency (Line 78)
  
  // View All transactions variables (Lines 81-85)
  final List<Map<String, dynamic>> allBankTransactions; // Line 81
  final bool isLoadingAllTransactions; // Line 82
  final bool hasMoreTransactions; // Line 83
  final int transactionOffset; // Line 84
  final int transactionLimit; // Line 85

  BankState({
    TextEditingController? bankAmountController,
    this.selectedBankCurrencyType,
    this.recentBankTransactions = const [],
    this.isLoadingBankTransactions = false,
    this.isSettingBankCurrency = false,
    this.tempSelectedBankCurrency,
    this.isSavingBankCurrency = false,
    this.allBankTransactions = const [],
    this.isLoadingAllTransactions = false,
    this.hasMoreTransactions = true,
    this.transactionOffset = 0,
    this.transactionLimit = 10,
  }) : bankAmountController = bankAmountController ?? TextEditingController();

  BankState copyWith({
    TextEditingController? bankAmountController,
    String? selectedBankCurrencyType,
    List<Map<String, dynamic>>? recentBankTransactions,
    bool? isLoadingBankTransactions,
    bool? isSettingBankCurrency,
    String? tempSelectedBankCurrency,
    bool? isSavingBankCurrency,
    List<Map<String, dynamic>>? allBankTransactions,
    bool? isLoadingAllTransactions,
    bool? hasMoreTransactions,
    int? transactionOffset,
    int? transactionLimit,
  }) {
    return BankState(
      bankAmountController: bankAmountController ?? this.bankAmountController,
      selectedBankCurrencyType: selectedBankCurrencyType ?? this.selectedBankCurrencyType,
      recentBankTransactions: recentBankTransactions ?? this.recentBankTransactions,
      isLoadingBankTransactions: isLoadingBankTransactions ?? this.isLoadingBankTransactions,
      isSettingBankCurrency: isSettingBankCurrency ?? this.isSettingBankCurrency,
      tempSelectedBankCurrency: tempSelectedBankCurrency ?? this.tempSelectedBankCurrency,
      isSavingBankCurrency: isSavingBankCurrency ?? this.isSavingBankCurrency,
      allBankTransactions: allBankTransactions ?? this.allBankTransactions,
      isLoadingAllTransactions: isLoadingAllTransactions ?? this.isLoadingAllTransactions,
      hasMoreTransactions: hasMoreTransactions ?? this.hasMoreTransactions,
      transactionOffset: transactionOffset ?? this.transactionOffset,
      transactionLimit: transactionLimit ?? this.transactionLimit,
    );
  }

  void dispose() {
    // CRITICAL: Must dispose controller to prevent memory leaks
    bankAmountController.dispose();
  }
}