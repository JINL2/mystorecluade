// Data Model: TransactionLineModel
// DTO (Data Transfer Object) with mapper to domain entity

import '../../../../core/utils/datetime_utils.dart';
import '../../domain/entities/transaction_line.dart';

class TransactionLineModel {
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
  final String? debtCategory;
  final double? interestRate;
  final DateTime? issueDate;
  final DateTime? dueDate;
  final String? debtDescription;
  final String? fixedAssetName;
  final double? salvageValue;
  final DateTime? acquisitionDate;
  final int? usefulLife;
  final Map<String, dynamic>? accountMapping;

  TransactionLineModel({
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

  // Convert domain entity to model
  factory TransactionLineModel.fromEntity(TransactionLine entity) {
    return TransactionLineModel(
      accountId: entity.accountId,
      accountName: entity.accountName,
      categoryTag: entity.categoryTag,
      description: entity.description,
      amount: entity.amount,
      isDebit: entity.isDebit,
      counterpartyId: entity.counterpartyId,
      counterpartyName: entity.counterpartyName,
      counterpartyStoreId: entity.counterpartyStoreId,
      counterpartyStoreName: entity.counterpartyStoreName,
      cashLocationId: entity.cashLocationId,
      cashLocationName: entity.cashLocationName,
      cashLocationType: entity.cashLocationType,
      linkedCompanyId: entity.linkedCompanyId,
      counterpartyCashLocationId: entity.counterpartyCashLocationId,
      debtCategory: entity.debtCategory,
      interestRate: entity.interestRate,
      issueDate: entity.issueDate,
      dueDate: entity.dueDate,
      debtDescription: entity.debtDescription,
      fixedAssetName: entity.fixedAssetName,
      salvageValue: entity.salvageValue,
      acquisitionDate: entity.acquisitionDate,
      usefulLife: entity.usefulLife,
      accountMapping: entity.accountMapping,
    );
  }

  // Convert model to domain entity
  TransactionLine toEntity() {
    return TransactionLine(
      accountId: accountId,
      accountName: accountName,
      categoryTag: categoryTag,
      description: description,
      amount: amount,
      isDebit: isDebit,
      counterpartyId: counterpartyId,
      counterpartyName: counterpartyName,
      counterpartyStoreId: counterpartyStoreId,
      counterpartyStoreName: counterpartyStoreName,
      cashLocationId: cashLocationId,
      cashLocationName: cashLocationName,
      cashLocationType: cashLocationType,
      linkedCompanyId: linkedCompanyId,
      counterpartyCashLocationId: counterpartyCashLocationId,
      debtCategory: debtCategory,
      interestRate: interestRate,
      issueDate: issueDate,
      dueDate: dueDate,
      debtDescription: debtDescription,
      fixedAssetName: fixedAssetName,
      salvageValue: salvageValue,
      acquisitionDate: acquisitionDate,
      usefulLife: usefulLife,
      accountMapping: accountMapping,
    );
  }

  // Convert to JSON for API submission
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
        'issue_date': issueDate != null
            ? DateTimeUtils.toDateOnly(issueDate!)
            : DateTimeUtils.toDateOnly(DateTime.now()),
        'due_date': dueDate != null
            ? DateTimeUtils.toDateOnly(dueDate!)
            : DateTimeUtils.toDateOnly(DateTime.now().add(const Duration(days: 30))),
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
        'acquire_date': acquisitionDate != null
            ? DateTimeUtils.toDateOnly(acquisitionDate!)
            : DateTimeUtils.toDateOnly(DateTime.now()),
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
