// lib/features/report_control/presentation/pages/templates/financial_summary/domain/repositories/financial_data_repository.dart

import '../entities/cpa_audit_data.dart';

/// Financial Summary 전용 데이터 Repository Interface
///
/// get_cpa_audit_report RPC 호출
abstract class FinancialDataRepository {
  /// CPA 감사 리포트 가져오기
  ///
  /// RPC: get_cpa_audit_report
  Future<CpaAuditData> getCpaAuditReport({
    required String companyId,
    String? storeId,
    required DateTime targetDate,
    String reportType = 'daily',
  });
}
