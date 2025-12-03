// lib/features/report_control/presentation/pages/templates/financial_summary/domain/entities/transaction_entry.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_entry.freezed.dart';
part 'transaction_entry.g.dart';

/// 개별 거래 내역 Entity
///
/// get_cpa_audit_report RPC에서 반환되는 거래 데이터
@freezed
class TransactionEntry with _$TransactionEntry {
  const factory TransactionEntry({
    required double amount,
    required String formattedAmount,
    required String debitAccount,   // 차변 계정
    required String creditAccount,  // 대변 계정
    required String employeeName,
    required String storeName,
    required DateTime entryDate,
    String? description,
  }) = _TransactionEntry;

  const TransactionEntry._();

  factory TransactionEntry.fromJson(Map<String, dynamic> json) =>
      _$TransactionEntryFromJson(json);
}
