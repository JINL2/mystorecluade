// lib/features/report_control/presentation/widgets/received_reports_tab.dart

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';

import '../../../../../shared/themes/index.dart';
import '../../../../../shared/widgets/toss/toss_chip.dart';
import '../../../../../shared/widgets/common/toss_loading_view.dart';
import '../../constants/report_strings.dart';
import '../../../domain/entities/report_notification.dart';
import '../../../domain/entities/report_detail.dart';
import '../../../domain/entities/templates/financial_summary/example_report_data.dart';
import '../../providers/report_provider.dart';
import '../../providers/report_state.dart';
import '../../utils/template_registry.dart';
import 'report_notification_card.dart';

/// Tab for displaying received reports
///
/// Shows list of reports user has received with filtering options
class ReceivedReportsTab extends ConsumerWidget {
  final String userId;
  final String companyId;

  // ✅ 정규식 캐싱
  static final _bulletPointRegex = RegExp(r'([^\n])\s*•\s*');

  const ReceivedReportsTab({
    super.key,
    required this.userId,
    required this.companyId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(reportProvider);
    final notifier = ref.read(reportProvider.notifier);

    if (state.isLoadingReceivedReports) {
      return const TossLoadingView(message: 'Loading reports...');
    }

    final reports = state.filteredReceivedReports;

    return Column(
      children: [
        // Modern filter section with white background
        Container(
          decoration: BoxDecoration(
            color: TossColors.white,
            border: Border(
              bottom: BorderSide(
                color: TossColors.gray100,
                width: 1,
              ),
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: TossSpacing.space4,
            vertical: TossSpacing.space3,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Category chips
              TossChipGroup(
                items: [
                  TossChipItem(
                    value: '',
                    label: ReportStrings.filterAll,
                    count: state.receivedReports.length,
                  ),
                  ...state.categories.map((category) => TossChipItem(
                        value: category.categoryId,
                        label: category.categoryName,
                        count: category.reportCount,
                      )),
                ],
                selectedValue: state.categoryFilter ?? '',
                onChanged: (value) =>
                    notifier.setCategoryFilter(value == '' ? null : value),
                spacing: TossSpacing.space2,
                runSpacing: TossSpacing.space2,
              ),
              SizedBox(height: TossSpacing.space3),
              // Compact filter row
              Row(
                children: [
                  // Unread toggle chip
                  GestureDetector(
                    onTap: () => notifier.toggleShowUnreadOnly(),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: TossSpacing.space3,
                        vertical: TossSpacing.space2,
                      ),
                      decoration: BoxDecoration(
                        color: state.showUnreadOnly
                            ? TossColors.primary.withOpacity(0.1)
                            : TossColors.gray50,
                        borderRadius:
                            BorderRadius.circular(TossBorderRadius.sm),
                        border: Border.all(
                          color: state.showUnreadOnly
                              ? TossColors.primary
                              : TossColors.gray200,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            state.showUnreadOnly
                                ? Icons.mark_email_unread
                                : Icons.mail_outline,
                            size: 16,
                            color: state.showUnreadOnly
                                ? TossColors.primary
                                : TossColors.gray600,
                          ),
                          SizedBox(width: TossSpacing.space1),
                          Text(
                            ReportStrings.filterUnreadOnly,
                            style: TossTextStyles.bodySmall.copyWith(
                              color: state.showUnreadOnly
                                  ? TossColors.primary
                                  : TossColors.gray700,
                              fontWeight: state.showUnreadOnly
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: TossSpacing.space2),
                  // Date range chip
                  GestureDetector(
                    onTap: () => _showDateRangePicker(context, ref),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: TossSpacing.space3,
                        vertical: TossSpacing.space2,
                      ),
                      decoration: BoxDecoration(
                        color:
                            (state.startDate != null || state.endDate != null)
                                ? TossColors.primary.withOpacity(0.1)
                                : TossColors.gray50,
                        borderRadius:
                            BorderRadius.circular(TossBorderRadius.sm),
                        border: Border.all(
                          color:
                              (state.startDate != null || state.endDate != null)
                                  ? TossColors.primary
                                  : TossColors.gray200,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: (state.startDate != null ||
                                    state.endDate != null)
                                ? TossColors.primary
                                : TossColors.gray600,
                          ),
                          SizedBox(width: TossSpacing.space1),
                          Text(
                            _getDateRangeLabel(state),
                            style: TossTextStyles.bodySmall.copyWith(
                              color: (state.startDate != null ||
                                      state.endDate != null)
                                  ? TossColors.primary
                                  : TossColors.gray700,
                              fontWeight: (state.startDate != null ||
                                      state.endDate != null)
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Example button
                  GestureDetector(
                    onTap: () => _showExampleReport(context),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: TossSpacing.space2,
                        vertical: TossSpacing.space2,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.bar_chart,
                            size: 16,
                            color: TossColors.primary,
                          ),
                          SizedBox(width: TossSpacing.space1),
                          Text(
                            'Example',
                            style: TossTextStyles.bodySmall.copyWith(
                              color: TossColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Reset button
                  if (state.hasActiveFilters)
                    GestureDetector(
                      onTap: () => notifier.clearFilters(),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: TossSpacing.space2,
                          vertical: TossSpacing.space2,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.refresh,
                              size: 16,
                              color: TossColors.gray600,
                            ),
                            SizedBox(width: TossSpacing.space1),
                            Text(
                              ReportStrings.filterReset,
                              style: TossTextStyles.bodySmall.copyWith(
                                color: TossColors.gray600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),

        // Reports list
        Expanded(
          child: reports.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inbox_outlined,
                        size: 64,
                        color: TossColors.gray300,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        ReportStrings.noReportsMessage,
                        style: TextStyle(
                          fontSize: 16,
                          color: TossColors.gray500,
                        ),
                      ),
                      if (state.hasActiveFilters) ...[
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () => notifier.clearFilters(),
                          child: const Text(ReportStrings.filterReset),
                        ),
                      ],
                    ],
                  ),
                )
              : ColoredBox(
                  color: TossColors.gray50,
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await notifier.loadReceivedReports(
                        userId: userId,
                        companyId: companyId,
                      );
                    },
                    child: ListView.builder(
                      padding: EdgeInsets.only(
                        top: TossSpacing.space3,
                        bottom: TossSpacing.space4,
                      ),
                      itemCount: reports.length,
                      itemBuilder: (context, index) {
                        final report = reports[index];
                        return ReportNotificationCard(
                          key: ValueKey(report.notificationId),
                          report: report,
                          onTap: () => _showReportDetail(context, ref, report),
                        );
                      },
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  /// Show report detail in bottom sheet or dedicated page
  void _showReportDetail(
      BuildContext context, WidgetRef ref, ReportNotification report) {
    final notifier = ref.read(reportProvider.notifier);

    // Mark as read if not already
    if (!report.isRead) {
      notifier.markReportAsRead(
        notificationId: report.notificationId,
        userId: userId,
      );
    }

    // Try to get template page from registry
    final templatePage = TemplateRegistry.buildByCode(
      report.templateCode,
      report,
    );

    if (templatePage != null) {
      print('✅ [ReceivedReports] Template page found, navigating...');
      // Navigate to template-specific page
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => templatePage),
      );
      return;
    }

    print('⚠️ [ReceivedReports] No template registered, showing markdown fallback');

    // Fallback to markdown bottom sheet
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: TossColors.gray300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: TossColors.gray200),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (report.templateIcon != null)
                          Text(
                            report.templateIcon!,
                            style: const TextStyle(fontSize: 24),
                          ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            report.templateName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      DateFormat('yyyy-MM-dd HH:mm').format(report.reportDate),
                      style: TextStyle(
                        color: TossColors.gray600,
                        fontSize: 14,
                      ),
                    ),
                    if (report.storeName != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        '${ReportStrings.storeLabel}: ${report.storeName}',
                        style: TextStyle(
                          color: TossColors.gray600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Report content (markdown body) - Readable style
                      MarkdownBody(
                        data: _formatMarkdownForDisplay(
                            report.body), // ✅ Pre-process markdown
                        shrinkWrap: true,
                        styleSheet: MarkdownStyleSheet(
                          // Paragraph spacing
                          blockSpacing: 12.0, // ✅ Space between paragraphs
                          listIndent: 20.0, // ✅ Indent for list items

                          // Normal text - not bold
                          p: const TextStyle(
                            fontSize: 15,
                            height: 1.8, // ✅ Increased line height
                            fontWeight: FontWeight.normal,
                            color: TossColors.gray900,
                          ),

                          // H1 - Main titles (bold, larger)
                          h1: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            height: 2.0, // ✅ More spacing
                            color: TossColors.gray900,
                          ),
                          h1Padding: const EdgeInsets.only(
                              top: 16, bottom: 8), // ✅ Padding around H1

                          // H2 - Section titles (semi-bold, medium)
                          h2: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            height: 1.9,
                            color: TossColors.gray800,
                          ),
                          h2Padding: const EdgeInsets.only(
                              top: 12, bottom: 6), // ✅ Padding around H2

                          // H3 - Subsection titles (medium weight)
                          h3: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            height: 1.8,
                            color: TossColors.gray700,
                          ),
                          h3Padding: const EdgeInsets.only(
                              top: 8, bottom: 4), // ✅ Padding around H3

                          // List items - normal weight with proper spacing
                          listBullet: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                          ),

                          // Strong/Bold text - use only when explicitly marked **bold**
                          strong: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: TossColors.primary,
                          ),

                          // Code blocks
                          code: TextStyle(
                            backgroundColor: TossColors.gray100,
                            fontFamily: 'monospace',
                            fontSize: 14,
                          ),
                          codeblockDecoration: BoxDecoration(
                            color: TossColors.gray100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          codeblockPadding: const EdgeInsets.all(
                              12), // ✅ Padding inside code blocks
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Session info
                      if (report.sessionErrorMessage != null) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: TossColors.error.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.error, color: TossColors.error),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      ReportStrings.errorOccurred,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: TossColors.error,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      report.sessionErrorMessage!,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Processing time
                      if (report.processingTimeMs != null)
                        Text(
                          '${ReportStrings.processingTime}: ${(report.processingTimeMs! / 1000).toStringAsFixed(2)}s',
                          style: TextStyle(
                            color: TossColors.gray600,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(ReportNotification report) {
    Color bgColor;
    Color textColor;
    String statusText;
    IconData icon;

    if (report.isCompleted) {
      bgColor = TossColors.success.withOpacity(0.1);
      textColor = TossColors.success;
      statusText = ReportStrings.statusCompleted;
      icon = Icons.check_circle;
    } else if (report.isFailed) {
      bgColor = TossColors.error.withOpacity(0.1);
      textColor = TossColors.error;
      statusText = ReportStrings.statusFailed;
      icon = Icons.error;
    } else {
      bgColor = TossColors.warning.withOpacity(0.1);
      textColor = TossColors.warning;
      statusText = ReportStrings.statusPending;
      icon = Icons.pending;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: textColor),
          const SizedBox(width: 4),
          Text(
            statusText,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  /// Get label for date range button
  String _getDateRangeLabel(ReportState state) {
    if (state.startDate != null && state.endDate != null) {
      final start = DateFormat('MM/dd').format(state.startDate!);
      final end = DateFormat('MM/dd').format(state.endDate!);
      return '$start - $end';
    } else if (state.startDate != null) {
      return 'From ${DateFormat('MM/dd').format(state.startDate!)}';
    } else if (state.endDate != null) {
      return 'Until ${DateFormat('MM/dd').format(state.endDate!)}';
    }
    return 'Date';
  }

  /// Show date range picker dialog
  Future<void> _showDateRangePicker(BuildContext context, WidgetRef ref) async {
    final state = ref.read(reportProvider);
    final notifier = ref.read(reportProvider.notifier);

    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      initialDateRange: state.startDate != null && state.endDate != null
          ? DateTimeRange(start: state.startDate!, end: state.endDate!)
          : null,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: TossColors.primary,
              onPrimary: TossColors.white,
              surface: TossColors.white,
              onSurface: TossColors.gray900,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      notifier.setDateRangeFilter(picked.start, picked.end);
    }
  }

  /// Format markdown for better display
  /// Ensures bullet points are on separate lines
  String _formatMarkdownForDisplay(String markdown) {
    if (markdown.isEmpty) return markdown;

    // Replace • that are not at the start of a line with newline + •
    // This fixes cases like: "item1 • item2 • item3" → "item1\n• item2\n• item3"
    String formatted = markdown.replaceAllMapped(
      _bulletPointRegex, // ✅ 캐시된 정규식 사용
      (match) => '${match.group(1)}\n\n• ',
    );

    // Also handle cases where • is at the very start
    if (!formatted.startsWith('•') && formatted.contains('•')) {
      formatted = formatted.replaceFirst('•', '\n• ');
    }

    return formatted;
  }

  /// Show example report with rich visualization
  void _showExampleReport(BuildContext context) {
    // Create example notification
    final exampleNotification = ReportNotification(
      notificationId: 'example-notification',
      title: 'Daily Financial Summary (Example)',
      body: jsonEncode(ExampleReportData.dailyFinancialSummary.toJson()),
      isRead: false,
      createdAt: DateTime.now(),
      reportDate: DateTime(2025, 12, 1),
      sessionId: 'example-session',
      templateId: 'd7f54762-cfad-422b-8d85-b71d827d10f2',
      subscriptionId: null,
      templateName: 'Daily Financial Summary',
      templateCode: 'daily_fraud_detection',
      templateIcon: null,
      templateFrequency: 'daily',
      categoryId: null,
      categoryName: null,
      sessionStatus: 'completed',
      sessionStartedAt: null,
      sessionCompletedAt: null,
      sessionErrorMessage: null,
      processingTimeMs: null,
      subscriptionEnabled: null,
      subscriptionScheduleTime: null,
      subscriptionScheduleDays: null,
      storeId: null,
      storeName: null,
    );

    // Use registry to show example
    final page = TemplateRegistry.buildByCode(
      'daily_fraud_detection',
      exampleNotification,
    );

    if (page != null) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => page),
      );
    }
  }
}
