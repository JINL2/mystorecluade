// lib/features/report_control/presentation/pages/templates/financial_summary/data/datasources/financial_data_datasource.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/cpa_audit_data.dart';
import '../../domain/entities/employee_summary.dart';
import '../../domain/entities/transaction_entry.dart';

/// Financial Summary 전용 데이터 소스
///
/// Supabase RPC 호출
class FinancialDataDataSource {
  final SupabaseClient _supabase;

  FinancialDataDataSource(this._supabase);

  /// get_cpa_audit_report RPC 호출
  Future<CpaAuditData> getCpaAuditReport({
    required String companyId,
    String? storeId,
    required DateTime targetDate,
    String reportType = 'daily',
  }) async {
    try {
      print('🔍 [FinancialDataSource] Calling get_cpa_audit_report...');
      print('   - company_id: $companyId');
      print('   - store_id: $storeId');
      print('   - target_date: $targetDate');
      print('   - report_type: $reportType');

      final response = await _supabase.rpc<Map<String, dynamic>>(
        'get_cpa_audit_report',
        params: {
          'p_company_id': companyId,
          if (storeId != null) 'p_store_id': storeId,
          'p_target_date': targetDate.toIso8601String().split('T')[0],
          'p_report_type': reportType,
        },
      );

      if (response == null) {
        throw Exception('No data returned from get_cpa_audit_report');
      }

      print('✅ [FinancialDataSource] RPC call successful');

      return _parseCpaAuditData(response);
    } catch (e, stackTrace) {
      print('❌ [FinancialDataSource] Error: $e');
      print('📚 [FinancialDataSource] Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// RPC 응답을 CpaAuditData entity로 변환
  CpaAuditData _parseCpaAuditData(Map<String, dynamic> json) {
    // report_metadata 파싱
    final metadata = json['report_metadata'] as Map<String, dynamic>;
    final dateRange = metadata['date_range'] as Map<String, dynamic>;

    // employees_by_store 파싱
    final employeesByStoreJson =
        (json['employees_by_store'] as List<dynamic>?) ?? [];
    final employeesByStore = employeesByStoreJson
        .map((store) => _parseStoreEmployeeSummary(store as Map<String, dynamic>))
        .toList();

    // anomalies 파싱
    final anomalies = json['anomalies'] as Map<String, dynamic>;
    final highValueJson = (anomalies['high_value'] as List<dynamic>?) ?? [];
    final noDescriptionJson =
        (anomalies['no_description'] as List<dynamic>?) ?? [];

    final highValueTransactions = highValueJson
        .map((txn) => _parseTransaction(txn as Map<String, dynamic>))
        .toList();

    final missingDescriptions = noDescriptionJson
        .map((txn) => _parseTransaction(txn as Map<String, dynamic>))
        .toList();

    return CpaAuditData(
      targetDate: DateTime.parse(metadata['target_date'] as String),
      startDate: DateTime.parse(dateRange['start_date'] as String),
      endDate: DateTime.parse(dateRange['end_date'] as String),
      employeesByStore: employeesByStore,
      highValueTransactions: highValueTransactions,
      missingDescriptions: missingDescriptions,
    );
  }

  /// StoreEmployeeSummary 파싱
  StoreEmployeeSummary _parseStoreEmployeeSummary(Map<String, dynamic> json) {
    final employeesJson = (json['employees'] as List<dynamic>?) ?? [];
    final employees = employeesJson
        .map((emp) => _parseEmployeeSummary(
              emp as Map<String, dynamic>,
              json['store_name'] as String,
            ))
        .toList();

    return StoreEmployeeSummary(
      storeId: json['store_id'] as String,
      storeName: json['store_name'] as String,
      storeTotal: (json['store_total'] as num).toDouble(),
      employees: employees,
    );
  }

  /// EmployeeSummary 파싱
  EmployeeSummary _parseEmployeeSummary(
    Map<String, dynamic> json,
    String storeName,
  ) {
    final transactionsJson = (json['transactions'] as List<dynamic>?) ?? [];
    final transactions = transactionsJson
        .map((txn) => _parseTransaction(
              txn as Map<String, dynamic>,
              employeeName: json['employee_name'] as String,
              storeName: storeName,
            ))
        .toList();

    return EmployeeSummary(
      employeeName: json['employee_name'] as String,
      transactionCount: json['transaction_count'] as int,
      totalAmount: (json['total_amount'] as num).toDouble(),
      transactions: transactions,
    );
  }

  /// TransactionEntry 파싱
  TransactionEntry _parseTransaction(
    Map<String, dynamic> json, {
    String? employeeName,
    String? storeName,
  }) {
    final amount = (json['amount'] as num).toDouble();

    return TransactionEntry(
      amount: amount,
      formattedAmount: _formatCurrency(amount),
      debitAccount: json['debit_account'] as String,
      creditAccount: json['credit_account'] as String,
      employeeName: employeeName ?? (json['employee_name'] as String),
      storeName: storeName ?? (json['store_name'] as String),
      entryDate: DateTime.parse(json['entry_date'] as String),
      description: json['description'] as String?,
    );
  }

  /// 금액 포맷
  String _formatCurrency(double amount) {
    final formatted = amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
    return '$formatted ₫';
  }
}
