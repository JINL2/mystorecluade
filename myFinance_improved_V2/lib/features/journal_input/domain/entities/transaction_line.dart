// Domain Entity: TransactionLine
// Pure business entity with no dependencies on frameworks

class TransactionLine {
  final String? accountId;
  final String? accountName;
  final String? categoryTag;
  final String? description;
  final double amount;
  final bool isDebit;
  final String? counterpartyId;
  final String? counterpartyName;
  final String? counterpartyStoreId;
  final String? counterpartyStoreName;
  final String? cashLocationId;
  final String? cashLocationName;
  final String? cashLocationType;
  final String? linkedCompanyId;
  final String? counterpartyCashLocationId;

  // Debt related fields
  final String? debtCategory;
  final double? interestRate;
  final DateTime? issueDate;
  final DateTime? dueDate;
  final String? debtDescription;

  // Fixed asset fields
  final String? fixedAssetName;
  final double? salvageValue;
  final DateTime? acquisitionDate;
  final int? usefulLife;

  // Account mapping fields for internal transactions
  final Map<String, dynamic>? accountMapping;

  const TransactionLine({
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TransactionLine &&
      other.accountId == accountId &&
      other.amount == amount &&
      other.isDebit == isDebit;
  }

  @override
  int get hashCode => Object.hash(accountId, amount, isDebit);
}
