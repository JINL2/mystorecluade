// lib/features/report_control/presentation/pages/financial_summary_detail_page.dart

import 'package:flutter/material.dart';

import '../../../../../../shared/themes/index.dart';
import '../../../../domain/entities/report_detail.dart';
import '../../../widgets/templates/financial_summary/account_changes_section.dart';
import '../../../widgets/templates/financial_summary/red_flags_section.dart';
import '../../../widgets/templates/financial_summary/ai_insights_section.dart';
import 'domain/entities/cpa_audit_data.dart';
import 'widgets/all_transactions_section.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Financial Summary Detail Page
///
/// Displays a financial report with rich visualizations.
/// Design follows Attendance Stats pattern for consistency.
class FinancialSummaryDetailPage extends StatefulWidget {
  final ReportDetail report;
  final CpaAuditData? auditData; // ← 추가

  const FinancialSummaryDetailPage({
    super.key,
    required this.report,
    this.auditData, // ← 추가
  });

  @override
  State<FinancialSummaryDetailPage> createState() =>
      _FinancialSummaryDetailPageState();
}

class _FinancialSummaryDetailPageState
    extends State<FinancialSummaryDetailPage> {
  @override
  Widget build(BuildContext context) {
    return TossScaffold(
      backgroundColor: TossColors.gray50,
      appBar: const TossAppBar(
        title: 'Daily Financial Summary',
        backgroundColor: TossColors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account Changes (AI 요약)
            AccountChangesSection(
              accountChanges: widget.report.accountChanges,
            ),

            const SizedBox(height: 20),

            // AI Insights
            AiInsightsSection(
              insights: widget.report.aiInsights,
            ),

            const SizedBox(height: 20),

            // Red Flags
            RedFlagsSection(
              redFlags: widget.report.redFlags,
            ),

            const SizedBox(height: 20),

            // All Transactions (실제 거래 데이터 - 맨 아래로 이동!)
            if (widget.auditData != null) ...[
              AllTransactionsSection(
                auditData: widget.auditData!,
                isMinimal: true, // 미니멀 모드 활성화
              ),
            ],

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
