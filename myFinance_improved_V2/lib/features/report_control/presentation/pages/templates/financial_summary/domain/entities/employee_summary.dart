// lib/features/report_control/presentation/pages/templates/financial_summary/domain/entities/employee_summary.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import 'transaction_entry.dart';

part 'employee_summary.freezed.dart';
part 'employee_summary.g.dart';

/// 직원별 요약 Entity
@freezed
class EmployeeSummary with _$EmployeeSummary {
  const factory EmployeeSummary({
    required String employeeName,
    required int transactionCount,
    required double totalAmount,
    required List<TransactionEntry> transactions,
  }) = _EmployeeSummary;

  const EmployeeSummary._();

  factory EmployeeSummary.fromJson(Map<String, dynamic> json) =>
      _$EmployeeSummaryFromJson(json);
}

/// 매장별 직원 요약 Entity
@freezed
class StoreEmployeeSummary with _$StoreEmployeeSummary {
  const factory StoreEmployeeSummary({
    required String storeId,
    required String storeName,
    required double storeTotal,
    required List<EmployeeSummary> employees,
  }) = _StoreEmployeeSummary;

  const StoreEmployeeSummary._();

  factory StoreEmployeeSummary.fromJson(Map<String, dynamic> json) =>
      _$StoreEmployeeSummaryFromJson(json);
}
