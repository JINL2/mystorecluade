// lib/features/report_control/presentation/pages/templates/financial_summary/domain/entities/cpa_audit_data.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import 'transaction_entry.dart';
import 'employee_summary.dart';

part 'cpa_audit_data.freezed.dart';
part 'cpa_audit_data.g.dart';

/// CPA 감사 데이터 Entity
///
/// get_cpa_audit_report RPC의 전체 응답 데이터
@freezed
class CpaAuditData with _$CpaAuditData {
  const factory CpaAuditData({
    required DateTime targetDate,
    required DateTime startDate,
    required DateTime endDate,
    required List<StoreEmployeeSummary> employeesByStore,
    required List<TransactionEntry> highValueTransactions,
    required List<TransactionEntry> missingDescriptions,
  }) = _CpaAuditData;

  const CpaAuditData._();

  factory CpaAuditData.fromJson(Map<String, dynamic> json) =>
      _$CpaAuditDataFromJson(json);

  /// 모든 거래 내역 (고액 + 일반)
  ///
  /// 중복 제거하고 날짜순 정렬
  List<TransactionEntry> get allTransactions {
    final allTxns = <String, TransactionEntry>{};

    // 고액 거래 추가
    for (final txn in highValueTransactions) {
      final key = '${txn.entryDate}_${txn.amount}_${txn.employeeName}';
      allTxns[key] = txn;
    }

    // 설명 없는 거래 추가
    for (final txn in missingDescriptions) {
      final key = '${txn.entryDate}_${txn.amount}_${txn.employeeName}';
      allTxns[key] = txn;
    }

    // employeesByStore에서 모든 거래 추가
    for (final store in employeesByStore) {
      for (final emp in store.employees) {
        for (final txn in emp.transactions) {
          final key = '${txn.entryDate}_${txn.amount}_${txn.employeeName}';
          allTxns[key] = txn;
        }
      }
    }

    // 날짜순 정렬 (최신순)
    final sorted = allTxns.values.toList()
      ..sort((a, b) => b.entryDate.compareTo(a.entryDate));

    return sorted;
  }
}
