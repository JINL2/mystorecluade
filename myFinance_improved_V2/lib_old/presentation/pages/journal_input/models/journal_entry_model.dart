// Journal Entry Model for managing journal input data
import 'package:flutter/foundation.dart';

class TransactionLine {
  String? accountId;
  String? accountName;
  String? categoryTag;
  String? description;
  double amount;
  bool isDebit;
  String? counterpartyId;
  String? counterpartyName;
  String? counterpartyStoreId;
  String? counterpartyStoreName;
  String? cashLocationId;
  String? cashLocationName;
  String? cashLocationType;
  String? linkedCompanyId; // The linked_company_id from counterparty
  String? counterpartyCashLocationId; // Cash location for counterparty
  
  // Debt related fields
  String? debtCategory;
  double? interestRate;
  DateTime? issueDate;
  DateTime? dueDate;
  String? debtDescription;
  
  // Fixed asset fields
  String? fixedAssetName;
  double? salvageValue;
  DateTime? acquisitionDate;
  int? usefulLife;
  
  // Account mapping fields for internal transactions
  Map<String, dynamic>? accountMapping;

  TransactionLine({
    this.accountId,
    this.accountName,
    this.categoryTag,
    this.description,
    this.amount = 0.0,
    this.isDebit = true,
    this.counterpartyId,
    this.counterpartyName,
    this.counterpartyStoreId,
    this.counterpartyStoreName,
    this.cashLocationId,
    this.cashLocationName,
    this.cashLocationType,
    this.linkedCompanyId,
    this.counterpartyCashLocationId,
    this.debtCategory,
    this.interestRate,
    this.issueDate,
    this.dueDate,
    this.debtDescription,
    this.fixedAssetName,
    this.salvageValue,
    this.acquisitionDate,
    this.usefulLife,
    this.accountMapping,
  });
  
  TransactionLine copyWith({
    String? accountId,
    String? accountName,
    String? categoryTag,
    String? description,
    double? amount,
    bool? isDebit,
    String? counterpartyId,
    String? counterpartyName,
    String? counterpartyStoreId,
    String? counterpartyStoreName,
    String? cashLocationId,
    String? cashLocationName,
    String? cashLocationType,
    String? linkedCompanyId,
    String? counterpartyCashLocationId,
    String? debtCategory,
    double? interestRate,
    DateTime? issueDate,
    DateTime? dueDate,
    String? debtDescription,
    String? fixedAssetName,
    double? salvageValue,
    DateTime? acquisitionDate,
    int? usefulLife,
    Map<String, dynamic>? accountMapping,
  }) {
    return TransactionLine(
      accountId: accountId ?? this.accountId,
      accountName: accountName ?? this.accountName,
      categoryTag: categoryTag ?? this.categoryTag,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      isDebit: isDebit ?? this.isDebit,
      counterpartyId: counterpartyId ?? this.counterpartyId,
      counterpartyName: counterpartyName ?? this.counterpartyName,
      counterpartyStoreId: counterpartyStoreId ?? this.counterpartyStoreId,
      counterpartyStoreName: counterpartyStoreName ?? this.counterpartyStoreName,
      cashLocationId: cashLocationId ?? this.cashLocationId,
      cashLocationName: cashLocationName ?? this.cashLocationName,
      cashLocationType: cashLocationType ?? this.cashLocationType,
      linkedCompanyId: linkedCompanyId ?? this.linkedCompanyId,
      counterpartyCashLocationId: counterpartyCashLocationId ?? this.counterpartyCashLocationId,
      debtCategory: debtCategory ?? this.debtCategory,
      interestRate: interestRate ?? this.interestRate,
      issueDate: issueDate ?? this.issueDate,
      dueDate: dueDate ?? this.dueDate,
      debtDescription: debtDescription ?? this.debtDescription,
      fixedAssetName: fixedAssetName ?? this.fixedAssetName,
      salvageValue: salvageValue ?? this.salvageValue,
      acquisitionDate: acquisitionDate ?? this.acquisitionDate,
      usefulLife: usefulLife ?? this.usefulLife,
      accountMapping: accountMapping ?? this.accountMapping,
    );
  }
  
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'account_id': accountId,
      'description': description,
      'debit': isDebit ? amount.toString() : '0',
      'credit': !isDebit ? amount.toString() : '0',
    };
    
    // Add counterparty if present
    if (counterpartyId != null && counterpartyId!.isNotEmpty) {
      json['counterparty_id'] = counterpartyId;
    }
    
    // Add cash location if it's a cash account
    if (categoryTag == 'cash' && cashLocationId != null) {
      json['cash'] = {
        'cash_location_id': cashLocationId,
      };
    }
    
    // Add debt information if it's payable/receivable
    if ((categoryTag == 'payable' || categoryTag == 'receivable') && 
        counterpartyId != null && 
        (debtCategory != null || interestRate != null)) {
      json['debt'] = {
        'direction': categoryTag,
        'category': debtCategory ?? 'other',
        'counterparty_id': counterpartyId,
        'original_amount': amount.toString(),
        'interest_rate': (interestRate ?? 0.0).toString(),
        'interest_account_id': '',
        'interest_due_day': 0,
        'issue_date': issueDate?.toIso8601String().split('T')[0] ?? DateTime.now().toIso8601String().split('T')[0],
        'due_date': dueDate?.toIso8601String().split('T')[0] ?? DateTime.now().add(Duration(days: 30)).toIso8601String().split('T')[0],
        'description': debtDescription ?? '',
        'linkedCounterparty_store_id': counterpartyStoreId ?? '',
        'linkedCounterparty_companyId': linkedCompanyId ?? '',
      };
    }
    
    // Add fixed asset information if it's a fixed asset
    if (categoryTag == 'fixedasset' && fixedAssetName != null) {
      json['fix_asset'] = {
        'asset_name': fixedAssetName,
        'salvage_value': (salvageValue ?? 0.0).toString(),
        'acquire_date': acquisitionDate?.toIso8601String().split('T')[0] ?? DateTime.now().toIso8601String().split('T')[0],
        'useful_life': (usefulLife ?? 5).toString(),
      };
    }
    
    // Add account mapping if available
    if (accountMapping != null) {
      json['account_mapping'] = accountMapping;
    }
    
    return json;
  }
}

class JournalEntryModel extends ChangeNotifier {
  List<TransactionLine> transactionLines = [];
  DateTime entryDate = DateTime.now();
  String? overallDescription;
  String? selectedCompanyId;
  String? selectedStoreId;
  String? counterpartyCashLocationId;
  
  // Calculated values
  double get totalDebits => transactionLines
      .where((line) => line.isDebit)
      .fold(0.0, (sum, line) => sum + line.amount);
      
  double get totalCredits => transactionLines
      .where((line) => !line.isDebit)
      .fold(0.0, (sum, line) => sum + line.amount);
      
  double get difference => totalDebits - totalCredits;
  
  bool get isBalanced => difference.abs() < 0.01; // Allow for small rounding differences
  
  int get debitCount => transactionLines.where((line) => line.isDebit).length;
  int get creditCount => transactionLines.where((line) => !line.isDebit).length;
  
  void addTransactionLine(TransactionLine line) {
    transactionLines.add(line);
    notifyListeners();
  }
  
  void removeTransactionLine(int index) {
    if (index >= 0 && index < transactionLines.length) {
      transactionLines.removeAt(index);
      notifyListeners();
    }
  }
  
  void updateTransactionLine(int index, TransactionLine line) {
    if (index >= 0 && index < transactionLines.length) {
      transactionLines[index] = line;
      notifyListeners();
    }
  }
  
  void setEntryDate(DateTime date) {
    entryDate = date;
    notifyListeners();
  }
  
  void setOverallDescription(String? description) {
    overallDescription = description;
    notifyListeners();
  }
  
  void setSelectedCompany(String? companyId) {
    selectedCompanyId = companyId;
    notifyListeners();
  }
  
  void setSelectedStore(String? storeId) {
    selectedStoreId = storeId;
    notifyListeners();
  }
  
  void setCounterpartyCashLocation(String? cashLocationId) {
    counterpartyCashLocationId = cashLocationId;
    notifyListeners();
  }
  
  void clear() {
    transactionLines.clear();
    entryDate = DateTime.now();
    overallDescription = null;
    counterpartyCashLocationId = null;
    // Don't clear company and store IDs - they should remain from app state
    // selectedCompanyId and selectedStoreId should persist
    notifyListeners();
  }
  
  bool canSubmit() {
    return transactionLines.isNotEmpty && 
           isBalanced && 
           selectedCompanyId != null;
  }
}