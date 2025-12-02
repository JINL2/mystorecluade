// lib/features/report_control/presentation/pages/financial_summary_detail_page.dart

import 'package:flutter/material.dart';

import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/widgets/common/toss_app_bar_1.dart';
import '../../../../../../shared/widgets/common/toss_scaffold.dart';
import '../../../../domain/entities/report_detail.dart';
import '../../../widgets/templates/financial_summary/account_changes_section.dart';
import '../../../widgets/templates/financial_summary/red_flags_section.dart';
import '../../../widgets/templates/financial_summary/ai_insights_section.dart';

/// Financial Summary Detail Page
///
/// Displays a financial report with rich visualizations.
/// Design follows Attendance Stats pattern for consistency.
class FinancialSummaryDetailPage extends StatefulWidget {
  final ReportDetail report;

  const FinancialSummaryDetailPage({
    super.key,
    required this.report,
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
      appBar: const TossAppBar1(
        title: 'Daily Financial Summary',
        backgroundColor: TossColors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account Changes (Main Content - First!)
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

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
