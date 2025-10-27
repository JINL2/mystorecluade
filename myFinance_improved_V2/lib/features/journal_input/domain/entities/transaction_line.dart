// Domain Entity: TransactionLine
// Pure business entity with no dependencies on frameworks

import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_line.freezed.dart';

@freezed
class TransactionLine with _$TransactionLine {
  const factory TransactionLine({
    String? accountId,
    String? accountName,
    String? categoryTag,
    String? description,
    @Default(0.0) double amount,
    @Default(true) bool isDebit,
    String? counterpartyId,
    String? counterpartyName,
    String? counterpartyStoreId,
    String? counterpartyStoreName,
    String? cashLocationId,
    String? cashLocationName,
    String? cashLocationType,
    String? linkedCompanyId,
    String? counterpartyCashLocationId,

    // Debt related fields
    String? debtCategory,
    double? interestRate,
    DateTime? issueDate,
    DateTime? dueDate,
    String? debtDescription,

    // Fixed asset fields
    String? fixedAssetName,
    double? salvageValue,
    DateTime? acquisitionDate,
    int? usefulLife,

    // Account mapping fields for internal transactions
    Map<String, dynamic>? accountMapping,
  }) = _TransactionLine;
}
