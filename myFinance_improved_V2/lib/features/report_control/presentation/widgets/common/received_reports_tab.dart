// lib/features/report_control/presentation/widgets/received_reports_tab.dart

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';

import '../../../../../shared/themes/index.dart';
import '../../../../../shared/widgets/atoms/buttons/toggle_button.dart';
import '../../constants/report_strings.dart';
import '../../../domain/entities/report_notification.dart';
import '../../../domain/entities/report_detail.dart';
import '../../providers/report_provider.dart';
import '../../providers/report_state.dart';
import '../../utils/template_registry.dart';
import 'report_notification_card.dart';
import '../../pages/templates/daily_attendance/daily_attendance_detail_page.dart';
import '../../pages/templates/cash_location/cash_location_template.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

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
              ToggleButtonGroup(
                items: [
                  ToggleButtonItem(
                    id: '',
                    label: ReportStrings.filterAll,
                    count: state.receivedReports.length,
                  ),
                  ...state.categories.map((category) => ToggleButtonItem(
                        id: category.categoryId,
                        label: category.categoryName,
                        count: category.reportCount,
                      )),
                ],
                selectedId: state.categoryFilter ?? '',
                onToggle: (value) =>
                    notifier.setCategoryFilter(value == '' ? null : value),
                layout: ToggleButtonLayout.expanded,
              ),
              SizedBox(height: TossSpacing.space3),
              // Compact filter row
              Row(
                children: [
                  // Unread toggle chip
                  Flexible(
                    child: GestureDetector(
                    onTap: () => notifier.toggleShowUnreadOnly(),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: TossSpacing.space3,
                        vertical: TossSpacing.space2,
                      ),
                      decoration: BoxDecoration(
                        color: state.showUnreadOnly
                            ? TossColors.primary.withValues(alpha: TossOpacity.light)
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
                            size: TossSpacing.iconSM2,
                            color: state.showUnreadOnly
                                ? TossColors.primary
                                : TossColors.gray600,
                          ),
                          SizedBox(width: TossSpacing.space1),
                          Flexible(
                            child: Text(
                              ReportStrings.filterUnreadOnly,
                              style: TossTextStyles.bodySmall.copyWith(
                                color: state.showUnreadOnly
                                    ? TossColors.primary
                                    : TossColors.gray700,
                                fontWeight: state.showUnreadOnly
                                    ? TossFontWeight.semibold
                                    : TossFontWeight.regular,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ),
                  SizedBox(width: TossSpacing.space2),
                  // Date range chip
                  Flexible(
                    child: GestureDetector(
                    onTap: () => _showDateRangePicker(context, ref),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: TossSpacing.space3,
                        vertical: TossSpacing.space2,
                      ),
                      decoration: BoxDecoration(
                        color:
                            (state.startDate != null || state.endDate != null)
                                ? TossColors.primary.withValues(alpha: TossOpacity.light)
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
                            size: TossSpacing.iconSM2,
                            color: (state.startDate != null ||
                                    state.endDate != null)
                                ? TossColors.primary
                                : TossColors.gray600,
                          ),
                          SizedBox(width: TossSpacing.space1),
                          Flexible(
                            child: Text(
                              _getDateRangeLabel(state),
                              style: TossTextStyles.bodySmall.copyWith(
                                color: (state.startDate != null ||
                                        state.endDate != null)
                                    ? TossColors.primary
                                    : TossColors.gray700,
                                fontWeight: (state.startDate != null ||
                                        state.endDate != null)
                                    ? TossFontWeight.semibold
                                    : TossFontWeight.regular,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ),
                  const Spacer(),
                  // Example button
                  GestureDetector(
                    onTap: () => _showExampleMenu(context),
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
                            size: TossSpacing.iconSM2,
                            color: TossColors.primary,
                          ),
                          SizedBox(width: TossSpacing.space1),
                          Text(
                            'Example',
                            style: TossTextStyles.bodySmall.copyWith(
                              color: TossColors.primary,
                              fontWeight: TossFontWeight.semibold,
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
                              size: TossSpacing.iconSM2,
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
                        size: TossSpacing.icon4XL,
                        color: TossColors.gray300,
                      ),
                      SizedBox(height: TossSpacing.space4),
                      Text(
                        ReportStrings.noReportsMessage,
                        style: TossTextStyles.titleMedium.copyWith(
                          color: TossColors.gray500,
                        ),
                      ),
                      if (state.hasActiveFilters) ...[
                        SizedBox(height: TossSpacing.space2),
                        TossButton.textButton(
                          text: ReportStrings.filterReset,
                          onPressed: () => notifier.clearFilters(),
                        ),
                      ],
                    ],
                  ),
                )
              : ColoredBox(
                  color: TossColors.white,
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
      backgroundColor: TossColors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(TossBorderRadius.bottomSheet)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: EdgeInsets.only(top: TossSpacing.space3, bottom: TossSpacing.space2),
                width: TossDimensions.avatarLG,
                height: TossDimensions.dragHandleHeight,
                decoration: BoxDecoration(
                  color: TossColors.gray300,
                  borderRadius: BorderRadius.circular(TossBorderRadius.indicator),
                ),
              ),

              // Header
              Container(
                padding: EdgeInsets.all(TossSpacing.space4),
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
                            style: TossTextStyles.h2,
                          ),
                        SizedBox(width: TossSpacing.space2),
                        Expanded(
                          child: Text(
                            report.templateName,
                            style: TossTextStyles.h4.copyWith(
                              fontWeight: TossFontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    SizedBox(height: TossSpacing.space2),
                    Text(
                      DateFormat('yyyy-MM-dd HH:mm').format(report.reportDate),
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.gray600,
                      ),
                    ),
                    if (report.storeName != null) ...[
                      SizedBox(height: TossSpacing.space1),
                      Text(
                        '${ReportStrings.storeLabel}: ${report.storeName}',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray600,
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
                  padding: EdgeInsets.all(TossSpacing.space4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Report content (markdown body) - Readable style
                      MarkdownBody(
                        data: _formatMarkdownForDisplay(
                            report.body), // Pre-process markdown
                        shrinkWrap: true,
                        styleSheet: MarkdownStyleSheet(
                          // Paragraph spacing
                          blockSpacing: 12.0, // Space between paragraphs
                          listIndent: 20.0, // Indent for list items

                          // Normal text - not bold
                          p: TossTextStyles.body.copyWith(
                            height: 1.8, // Increased line height
                            fontWeight: FontWeight.normal,
                            color: TossColors.gray900,
                          ),

                          // H1 - Main titles (bold, larger)
                          h1: TossTextStyles.h3.copyWith(
                            fontWeight: TossFontWeight.bold,
                            height: 2.0, // More spacing
                            color: TossColors.gray900,
                          ),
                          h1Padding: const EdgeInsets.only(
                              top: TossSpacing.space4, bottom: TossSpacing.space2), // Padding around H1

                          // H2 - Section titles (semi-bold, medium)
                          h2: TossTextStyles.h4.copyWith(
                            fontWeight: TossFontWeight.semibold,
                            height: 1.9,
                            color: TossColors.gray800,
                          ),
                          h2Padding: const EdgeInsets.only(
                              top: TossSpacing.space3, bottom: TossSpacing.space2), // Padding around H2

                          // H3 - Subsection titles (medium weight)
                          h3: TossTextStyles.titleMedium.copyWith(
                            fontWeight: TossFontWeight.medium,
                            height: 1.8,
                            color: TossColors.gray700,
                          ),
                          h3Padding: const EdgeInsets.only(
                              top: TossSpacing.space2, bottom: TossSpacing.space1), // Padding around H3

                          // List items - normal weight with proper spacing
                          listBullet: TossTextStyles.body.copyWith(
                            fontWeight: FontWeight.normal,
                          ),

                          // Strong/Bold text - use only when explicitly marked **bold**
                          strong: TossTextStyles.body.copyWith(
                            fontWeight: TossFontWeight.semibold,
                            color: TossColors.primary,
                          ),

                          // Code blocks
                          code: TossTextStyles.body.copyWith(
                            backgroundColor: TossColors.gray100,
                            fontFamily: 'monospace',
                          ),
                          codeblockDecoration: BoxDecoration(
                            color: TossColors.gray100,
                            borderRadius: BorderRadius.circular(TossBorderRadius.md),
                          ),
                          codeblockPadding: const EdgeInsets.all(
                              TossSpacing.space3), // Padding inside code blocks
                        ),
                      ),

                      SizedBox(height: TossSpacing.space6),

                      // Session info
                      if (report.sessionErrorMessage != null) ...[
                        Container(
                          padding: EdgeInsets.all(TossSpacing.space3),
                          decoration: BoxDecoration(
                            color: TossColors.error.withValues(alpha: TossOpacity.light),
                            borderRadius: BorderRadius.circular(TossBorderRadius.md),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.error, color: TossColors.error),
                              SizedBox(width: TossSpacing.space2),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ReportStrings.errorOccurred,
                                      style: TossTextStyles.body.copyWith(
                                        fontWeight: TossFontWeight.bold,
                                        color: TossColors.error,
                                      ),
                                    ),
                                    SizedBox(height: TossSpacing.space1),
                                    Text(
                                      report.sessionErrorMessage!,
                                      style: TossTextStyles.body,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: TossSpacing.space4),
                      ],

                      // Processing time
                      if (report.processingTimeMs != null)
                        Text(
                          '${ReportStrings.processingTime}: ${(report.processingTimeMs! / 1000).toStringAsFixed(2)}s',
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
      bgColor = TossColors.success.withValues(alpha: TossOpacity.light);
      textColor = TossColors.success;
      statusText = ReportStrings.statusCompleted;
      icon = Icons.check_circle;
    } else if (report.isFailed) {
      bgColor = TossColors.error.withValues(alpha: TossOpacity.light);
      textColor = TossColors.error;
      statusText = ReportStrings.statusFailed;
      icon = Icons.error;
    } else {
      bgColor = TossColors.warning.withValues(alpha: TossOpacity.light);
      textColor = TossColors.warning;
      statusText = ReportStrings.statusPending;
      icon = Icons.pending;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: TossSpacing.space3, vertical: TossSpacing.space2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: TossSpacing.iconSM2, color: textColor),
          SizedBox(width: TossSpacing.space1),
          Text(
            statusText,
            style: TossTextStyles.body.copyWith(
              color: textColor,
              fontWeight: TossFontWeight.bold,
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

  /// Show example report menu
  void _showExampleMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(TossBorderRadius.xl)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: EdgeInsets.all(TossSpacing.space4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Example Reports',
                style: TossTextStyles.h4.copyWith(
                  fontWeight: TossFontWeight.bold,
                ),
              ),
              SizedBox(height: TossSpacing.space4),
              // Cash Location Example
              ListTile(
                leading: Container(
                  width: TossDimensions.avatarLG,
                  height: TossDimensions.avatarLG,
                  decoration: BoxDecoration(
                    color: TossColors.emerald.withValues(alpha: TossOpacity.light),
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet,
                    color: TossColors.emerald,
                    size: TossSpacing.iconMD,
                  ),
                ),
                title: const Text('Cash Location Report'),
                subtitle: const Text('Cash reconciliation example'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => CashLocationTemplate.buildExamplePage(),
                    ),
                  );
                },
              ),
              const Divider(),
              // Financial Summary Example (placeholder)
              ListTile(
                leading: Container(
                  width: TossDimensions.avatarLG,
                  height: TossDimensions.avatarLG,
                  decoration: BoxDecoration(
                    color: TossColors.primary.withValues(alpha: TossOpacity.light),
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  ),
                  child: Icon(
                    Icons.analytics,
                    color: TossColors.primary,
                    size: TossSpacing.iconMD,
                  ),
                ),
                title: const Text('Financial Summary'),
                subtitle: const Text('Daily financial report example'),
                trailing: const Icon(Icons.chevron_right),
                enabled: false, // Disabled for now
                onTap: null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
