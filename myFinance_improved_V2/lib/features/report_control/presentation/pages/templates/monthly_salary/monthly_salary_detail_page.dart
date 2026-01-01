// lib/features/report_control/presentation/pages/templates/monthly_salary/monthly_salary_detail_page.dart

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../../shared/themes/index.dart';
import '../../../../domain/entities/report_notification.dart';
import '../../../utils/report_parser.dart';
import 'domain/entities/monthly_salary_report.dart';
import 'widgets/salary_hero_card.dart';
import 'widgets/employee_salary_card.dart';
import 'widgets/salary_insights_card.dart';
import 'widgets/salary_notices_card.dart';
import 'widgets/manager_quality_card.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Monthly Salary Report Detail Page
///
/// Features:
/// - Clickable filter chips (With Warnings, Clean)
/// - Employees sorted by warning count (most warnings first)
/// - Expandable warning details per employee
/// - Minimalist Toss-style design
class MonthlySalaryDetailPage extends StatefulWidget {
  final ReportNotification? notification;
  final MonthlySalaryReport? directReport;
  final String? directTitle;

  /// Constructor for notification-based loading
  const MonthlySalaryDetailPage({
    super.key,
    required this.notification,
  })  : directReport = null,
        directTitle = null;

  /// Named constructor for direct report (for testing)
  const MonthlySalaryDetailPage.withReport({
    super.key,
    required MonthlySalaryReport report,
    String? title,
  })  : notification = null,
        directReport = report,
        directTitle = title;

  @override
  State<MonthlySalaryDetailPage> createState() => _MonthlySalaryDetailPageState();
}

class _MonthlySalaryDetailPageState extends State<MonthlySalaryDetailPage> {
  SalaryFilter _activeFilter = SalaryFilter.all;

  @override
  Widget build(BuildContext context) {
    // If direct report provided, use it
    if (widget.directReport != null) {
      return _buildReportView(widget.directReport!, widget.directTitle);
    }

    // Parse from notification
    final reportJson = ReportParser.parse(widget.notification?.body ?? '');

    if (reportJson == null) {
      return _buildErrorPage('Failed to parse report data');
    }

    MonthlySalaryReport? report;
    try {
      report = MonthlySalaryReport.fromJson(reportJson);
    } catch (e, stackTrace) {
      print('❌ [MonthlySalary] Error parsing report: $e');
      print('📚 [MonthlySalary] Stack trace: $stackTrace');
      return _buildErrorPage('Error parsing report: $e');
    }

    return _buildReportView(report, widget.notification?.title);
  }

  Widget _buildReportView(MonthlySalaryReport report, String? title) {
    // Filter employees
    final filteredEmployees = _filterEmployees(report.employees, _activeFilter);

    // Sort by warning count (most warnings first), then by name
    final sortedEmployees = List<SalaryEmployee>.from(filteredEmployees)
      ..sort((a, b) {
        final warningCompare = b.warningCount.compareTo(a.warningCount);
        if (warningCompare != 0) return warningCompare;
        return a.employeeName.compareTo(b.employeeName);
      });

    return TossScaffold(
      backgroundColor: TossColors.gray50,
      appBar: TossAppBar1(
        title: title ?? 'Monthly Salary Report',
        backgroundColor: TossColors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Month badge
            _buildMonthBadge(report.reportMonth),

            const SizedBox(height: 16),

            // Hero card with filters
            SalaryHeroCard(
              summary: report.summary,
              activeFilter: _activeFilter,
              onFilterChanged: (filter) {
                setState(() {
                  _activeFilter = filter;
                });
              },
            ),

            const SizedBox(height: 20),

            // Section header
            _buildSectionHeader(
              title: _getSectionTitle(),
              count: sortedEmployees.length,
            ),

            const SizedBox(height: 12),

            // Employee cards
            if (sortedEmployees.isEmpty)
              _buildEmptyView()
            else
              ...sortedEmployees.map((employee) => EmployeeSalaryCard(
                    employee: employee,
                    initiallyExpanded: false,
                  )),

            const SizedBox(height: 20),

            // Important Notices
            if (report.notices.isNotEmpty) ...[
              SalaryNoticesCard(notices: report.notices),
              const SizedBox(height: 16),
            ],

            // Manager Quality
            if (report.managerQuality != null) ...[
              ManagerQualityCard(quality: report.managerQuality!),
              const SizedBox(height: 16),
            ],

            // AI Insights
            SalaryInsightsCard(insights: report.aiInsights),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  List<SalaryEmployee> _filterEmployees(
    List<SalaryEmployee> employees,
    SalaryFilter filter,
  ) {
    switch (filter) {
      case SalaryFilter.withWarnings:
        return employees.where((e) => e.hasWarnings && e.warnings.isNotEmpty).toList();
      case SalaryFilter.noWarnings:
        return employees.where((e) => !e.hasWarnings || e.warnings.isEmpty).toList();
      case SalaryFilter.selfApproved:
        return employees
            .where((e) => e.warnings.any((w) => w.selfApproved))
            .toList();
      case SalaryFilter.all:
      default:
        return employees;
    }
  }

  String _getSectionTitle() {
    switch (_activeFilter) {
      case SalaryFilter.withWarnings:
        return 'Employees with Warnings';
      case SalaryFilter.noWarnings:
        return 'Clean Employees';
      case SalaryFilter.selfApproved:
        return 'Self-Approved Cases';
      case SalaryFilter.all:
      default:
        return 'All Employees';
    }
  }

  Widget _buildEmptyView() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(TossSpacing.space8),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Column(
        children: [
          Icon(
            _activeFilter == SalaryFilter.noWarnings
                ? LucideIcons.partyPopper
                : LucideIcons.search,
            size: 48,
            color: _activeFilter == SalaryFilter.noWarnings
                ? const Color(0xFF10B981)
                : TossColors.gray300,
          ),
          const SizedBox(height: 16),
          Text(
            _activeFilter == SalaryFilter.noWarnings
                ? 'All employees have warnings'
                : 'No employees found',
            style: TossTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: TossColors.gray600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the filter again to see all employees',
            style: TossTextStyles.bodySmall.copyWith(
              color: TossColors.gray400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorPage(String message) {
    return TossScaffold(
      backgroundColor: TossColors.gray50,
      appBar: const TossAppBar1(
        title: 'Error',
        backgroundColor: TossColors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LucideIcons.alertCircle, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: TossSpacing.space8),
              child: Text(
                message,
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthBadge(String reportMonth) {
    // Format "2025-11" to "November 2025"
    String formattedMonth = reportMonth;
    try {
      final parts = reportMonth.split('-');
      if (parts.length == 2) {
        final year = parts[0];
        final month = int.parse(parts[1]);
        final months = [
          'January', 'February', 'March', 'April', 'May', 'June',
          'July', 'August', 'September', 'October', 'November', 'December'
        ];
        formattedMonth = '${months[month - 1]} $year';
      }
    } catch (_) {}

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: TossColors.gray100,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.calendar_month,
            size: 14,
            color: TossColors.gray600,
          ),
          const SizedBox(width: 6),
          Text(
            formattedMonth,
            style: TossTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
              color: TossColors.gray700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required int count,
  }) {
    return Row(
      children: [
        Text(
          title,
          style: TossTextStyles.body.copyWith(
            fontWeight: FontWeight.w600,
            color: TossColors.gray700,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: TossColors.gray200,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '$count',
            style: TossTextStyles.labelSmall.copyWith(
              fontWeight: FontWeight.w600,
              color: TossColors.gray600,
            ),
          ),
        ),
      ],
    );
  }
}
