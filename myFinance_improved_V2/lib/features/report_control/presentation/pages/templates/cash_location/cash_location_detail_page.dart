// lib/features/report_control/presentation/pages/templates/cash_location/cash_location_detail_page.dart

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../../shared/themes/index.dart';
import '../../../../domain/entities/report_notification.dart';
import '../../../utils/report_parser.dart';
import 'domain/entities/cash_location_report.dart';
import 'widgets/issues_hero_card.dart';
import 'widgets/store_issues_card.dart';
import 'widgets/ai_recommendations_card.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Cash Location Report Detail Page
///
/// Features:
/// - Clickable filter chips (Shortages, Surpluses, Balanced)
/// - Stores collapsed by default (user chooses what to see)
/// - Minimalist Toss-style design
class CashLocationDetailPage extends StatefulWidget {
  final ReportNotification? notification;
  final CashLocationReport? directReport;
  final String? directTitle;

  /// Constructor for notification-based loading (from template routing)
  const CashLocationDetailPage({
    super.key,
    required this.notification,
  })  : directReport = null,
        directTitle = null;

  /// Named constructor for direct report (for example page)
  const CashLocationDetailPage.withReport({
    super.key,
    required CashLocationReport report,
    String? title,
  })  : notification = null,
        directReport = report,
        directTitle = title;

  @override
  State<CashLocationDetailPage> createState() => _CashLocationDetailPageState();
}

class _CashLocationDetailPageState extends State<CashLocationDetailPage> {
  CashLocationFilter _activeFilter = CashLocationFilter.all;

  @override
  Widget build(BuildContext context) {
    // If direct report provided (example page), use it
    if (widget.directReport != null) {
      return _buildReportView(widget.directReport!, widget.directTitle);
    }

    // Otherwise, parse from notification
    final reportJson = ReportParser.parse(widget.notification?.body ?? '');

    if (reportJson == null) {
      return _buildErrorPage('Failed to parse report data');
    }

    CashLocationReport? report;
    try {
      report = CashLocationReport.fromJson(reportJson);
    } catch (e, stackTrace) {
      print('❌ [CashLocation] Error parsing report: $e');
      print('📚 [CashLocation] Stack trace: $stackTrace');
      return _buildErrorPage('Error parsing report: $e');
    }

    return _buildReportView(report, widget.notification?.title);
  }

  /// Build the main report view
  Widget _buildReportView(CashLocationReport report, String? title) {
    // Filter issues based on active filter
    final filteredIssues = _filterIssues(report.issues, _activeFilter);

    // Group filtered issues by store
    final storeGroups = _groupIssuesByStore(filteredIssues);

    // Sort stores by total difference (most severe first)
    final sortedStoreIds = storeGroups.keys.toList()
      ..sort((a, b) {
        final aTotal = storeGroups[a]!.fold<double>(
          0,
          (sum, issue) => sum + issue.difference.abs(),
        );
        final bTotal = storeGroups[b]!.fold<double>(
          0,
          (sum, issue) => sum + issue.difference.abs(),
        );
        return bTotal.compareTo(aTotal);
      });

    return TossScaffold(
      backgroundColor: TossColors.gray50,
      appBar: TossAppBar(
        title: title ?? 'Cash Location Report',
        backgroundColor: TossColors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Report date badge
            _buildDateBadge(report.reportDate),

            const SizedBox(height: 16),

            // Hero card with clickable filters
            IssuesHeroCard(
              stats: report.heroStats,
              activeFilter: _activeFilter,
              onFilterChanged: (filter) {
                setState(() {
                  _activeFilter = filter;
                });
              },
            ),

            const SizedBox(height: 20),

            // Show content based on filter
            if (_activeFilter == CashLocationFilter.balanced)
              _buildBalancedFilterView(report.heroStats.balancedCount)
            else if (storeGroups.isEmpty)
              _buildNoResultsView()
            else ...[
              // Section header with filter indicator
              _buildSectionHeader(
                title: _getSectionTitle(),
                count: sortedStoreIds.length,
              ),

              const SizedBox(height: 12),

              // Store cards (all collapsed by default)
              ...sortedStoreIds.map((storeId) {
                final issues = storeGroups[storeId]!;

                // Sort issues within store by severity
                final sortedIssues = List<CashLocationIssue>.from(issues)
                  ..sort((a, b) {
                    final severityOrder = {'high': 0, 'medium': 1, 'low': 2};
                    final severityCompare =
                        (severityOrder[a.severity] ?? 3)
                            .compareTo(severityOrder[b.severity] ?? 3);
                    if (severityCompare != 0) return severityCompare;
                    return b.difference.abs().compareTo(a.difference.abs());
                  });

                return StoreIssuesCard(
                  storeId: storeId,
                  storeName: sortedIssues.first.storeName,
                  issues: sortedIssues,
                  // All collapsed by default - user chooses what to see
                  initiallyExpanded: false,
                );
              }),

              const SizedBox(height: 20),

              // AI recommendations
              AiRecommendationsCard(insights: report.aiInsights),
            ],

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  /// Filter issues based on active filter
  List<CashLocationIssue> _filterIssues(
    List<CashLocationIssue> issues,
    CashLocationFilter filter,
  ) {
    switch (filter) {
      case CashLocationFilter.shortage:
        return issues.where((i) => i.issueType == 'shortage').toList();
      case CashLocationFilter.surplus:
        return issues.where((i) => i.issueType == 'surplus').toList();
      case CashLocationFilter.balanced:
        // Balanced locations are not in issues list
        return [];
      case CashLocationFilter.all:
      default:
        return issues;
    }
  }

  /// Get section title based on filter
  String _getSectionTitle() {
    switch (_activeFilter) {
      case CashLocationFilter.shortage:
        return 'Stores with Shortages';
      case CashLocationFilter.surplus:
        return 'Stores with Surpluses';
      case CashLocationFilter.balanced:
        return 'Balanced Locations';
      case CashLocationFilter.all:
      default:
        return 'Stores with Issues';
    }
  }

  /// Build view for balanced filter (no issues to show)
  Widget _buildBalancedFilterView(int balancedCount) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(TossSpacing.space8),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              LucideIcons.checkCircle,
              size: 32,
              color: Color(0xFF10B981),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '$balancedCount Balanced Locations',
            style: TossTextStyles.h4.copyWith(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF10B981),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'These locations have matching book and actual amounts.\nNo action required.',
            textAlign: TextAlign.center,
            style: TossTextStyles.bodySmall.copyWith(
              color: TossColors.gray500,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  /// Build view when no results match filter
  Widget _buildNoResultsView() {
    final filterName = _activeFilter == CashLocationFilter.shortage
        ? 'shortages'
        : 'surpluses';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(TossSpacing.space8),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Column(
        children: [
          Icon(
            LucideIcons.search,
            size: 48,
            color: TossColors.gray300,
          ),
          const SizedBox(height: 16),
          Text(
            'No $filterName found',
            style: TossTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: TossColors.gray600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the filter again to see all issues',
            style: TossTextStyles.bodySmall.copyWith(
              color: TossColors.gray400,
            ),
          ),
        ],
      ),
    );
  }

  /// Build error page
  Widget _buildErrorPage(String message) {
    return TossScaffold(
      backgroundColor: TossColors.gray50,
      appBar: const TossAppBar(
        title: 'Error',
        backgroundColor: TossColors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LucideIcons.alertCircle, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              message,
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray700,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Group issues by store ID
  Map<String, List<CashLocationIssue>> _groupIssuesByStore(
    List<CashLocationIssue> issues,
  ) {
    final groups = <String, List<CashLocationIssue>>{};

    for (final issue in issues) {
      if (!groups.containsKey(issue.storeId)) {
        groups[issue.storeId] = [];
      }
      groups[issue.storeId]!.add(issue);
    }

    return groups;
  }

  Widget _buildDateBadge(String reportDate) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space3, vertical: TossSpacing.space2),
      decoration: BoxDecoration(
        color: TossColors.gray100,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.calendar_today,
            size: 14,
            color: TossColors.gray600,
          ),
          const SizedBox(width: 6),
          Text(
            reportDate,
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
          padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space2, vertical: 2),
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
