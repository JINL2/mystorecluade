// lib/features/report_control/presentation/pages/templates/financial_summary/data/repositories/financial_data_repository_impl.dart

import '../../domain/entities/cpa_audit_data.dart';
import '../../domain/repositories/financial_data_repository.dart';
import '../datasources/financial_data_datasource.dart';

/// FinancialDataRepository 구현체
class FinancialDataRepositoryImpl implements FinancialDataRepository {
  final FinancialDataDataSource _dataSource;

  FinancialDataRepositoryImpl(this._dataSource);

  @override
  Future<CpaAuditData> getCpaAuditReport({
    required String companyId,
    String? storeId,
    required DateTime targetDate,
    String reportType = 'daily',
  }) async {
    try {
      return await _dataSource.getCpaAuditReport(
        companyId: companyId,
        storeId: storeId,
        targetDate: targetDate,
        reportType: reportType,
      );
    } catch (e) {
      print('❌ [FinancialDataRepository] Error: $e');
      rethrow;
    }
  }
}
