// lib/features/report_control/presentation/pages/templates/daily_attendance/daily_attendance_detail_page.dart

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../../shared/themes/toss_shadows.dart';
import '../../../../../../shared/widgets/common/toss_app_bar_1.dart';
import '../../../../../../shared/widgets/common/toss_scaffold.dart';
import '../../../../domain/entities/report_notification.dart';
import '../../../../domain/entities/templates/daily_attendance/attendance_report.dart';
import '../../../utils/report_parser.dart';

/// Daily Attendance Report Detail Page
///
/// 비즈니스 오너가 한눈에 전날 상황을 파악할 수 있도록 설계
class DailyAttendanceDetailPage extends StatelessWidget {
  final ReportNotification notification;

  const DailyAttendanceDetailPage({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    // Parse JSON from notification.body
    final reportJson = ReportParser.parse(notification.body ?? '');

    if (reportJson == null) {
      return _buildErrorPage('Failed to parse report data');
    }

    AttendanceReport? report;
    try {
      report = AttendanceReport.fromJson(reportJson);
    } catch (e, stackTrace) {
      print('❌ [DailyAttendance] Error parsing report: $e');
      print('📚 [DailyAttendance] Stack trace: $stackTrace');
      return _buildErrorPage('Error parsing report: $e');
    }

    return TossScaffold(
      backgroundColor: TossColors.gray50,
      appBar: const TossAppBar1(
        title: 'Daily Attendance Report',
        backgroundColor: TossColors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(TossSpacing.paddingMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Overview (미니멀 - 한 줄)
            _OverviewSection(
              reportDate: notification.reportDate,
              heroStats: report.heroStats,
              aiSummary: report.aiSummary,
            ),
            SizedBox(height: TossSpacing.marginLG),

            // 2. Store Performance (매장별 현황 - 큰 스코프)
            _StorePerformanceSection(stores: report.stores),
            SizedBox(height: TossSpacing.marginLG),

            // 3. Issues Detail (직원별 상세 - 작은 스코프)
            _IssuesDetailSection(issues: report.issues),
            SizedBox(height: TossSpacing.marginLG),

            // 4. Manager Quality Flags (매니저 평가)
            if (report.managerQualityFlags != null && report.managerQualityFlags!.isNotEmpty)
              _ManagerQualitySection(flags: report.managerQualityFlags!),
            if (report.managerQualityFlags != null && report.managerQualityFlags!.isNotEmpty)
              SizedBox(height: TossSpacing.marginLG),

            // 5. Action Items (해야 할 일)
            _ActionItemsSection(actions: report.urgentActions),
            SizedBox(height: TossSpacing.marginMD),
          ],
        ),
      ),
    );
  }

  /// Build error page
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
            Icon(LucideIcons.alertCircle, size: 64, color: Colors.red),
            SizedBox(height: TossSpacing.space4),
            Text(
              message,
              style: TossTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Format date for display
  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

/// Overview Section - 미니멀 한 줄
class _OverviewSection extends StatelessWidget {
  final DateTime reportDate;
  final HeroStats heroStats;
  final String? aiSummary;

  const _OverviewSection({
    required this.reportDate,
    required this.heroStats,
    this.aiSummary,
  });

  @override
  Widget build(BuildContext context) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final dateStr = '${months[reportDate.month - 1]} ${reportDate.day}, ${reportDate.year}';

    final solvedCount = heroStats.solvedCount ?? 0;
    final unsolvedCount = heroStats.unsolvedCount ?? 0;

    return Container(
      padding: EdgeInsets.all(TossSpacing.paddingMD),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        boxShadow: TossShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // First row: Date + Stats
          Row(
            children: [
              // Date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dateStr,
                      style: TossTextStyles.h4.copyWith(
                        color: TossColors.gray900,
                      ),
                    ),
                    SizedBox(height: TossSpacing.space1),
                    Text(
                      '${heroStats.totalShifts} shifts',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray600,
                      ),
                    ),
                  ],
                ),
              ),

              // Stats summary
              Row(
                children: [
                  // Total Issues
                  Icon(
                    LucideIcons.alertCircle,
                    size: 16,
                    color: heroStats.totalIssues > 0 ? Colors.red : TossColors.gray400,
                  ),
                  SizedBox(width: TossSpacing.space1),
                  Text(
                    '${heroStats.totalIssues}',
                    style: TossTextStyles.bodyMedium.copyWith(
                      color: heroStats.totalIssues > 0 ? Colors.red : TossColors.gray600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  SizedBox(width: TossSpacing.space3),

                  // Resolved
                  Icon(
                    LucideIcons.checkCircle,
                    size: 16,
                    color: Colors.green,
                  ),
                  SizedBox(width: TossSpacing.space1),
                  Text(
                    '$solvedCount',
                    style: TossTextStyles.bodyMedium.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  SizedBox(width: TossSpacing.space3),

                  // Pending
                  Icon(
                    LucideIcons.clock,
                    size: 16,
                    color: unsolvedCount > 0 ? Colors.orange : TossColors.gray400,
                  ),
                  SizedBox(width: TossSpacing.space1),
                  Text(
                    '$unsolvedCount',
                    style: TossTextStyles.bodyMedium.copyWith(
                      color: unsolvedCount > 0 ? Colors.orange : TossColors.gray600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // AI Summary (if available)
          if (aiSummary != null) ...[
            SizedBox(height: TossSpacing.space3),
            Container(
              padding: EdgeInsets.all(TossSpacing.paddingSM),
              decoration: BoxDecoration(
                color: TossColors.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    LucideIcons.sparkles,
                    size: 16,
                    color: TossColors.primary,
                  ),
                  SizedBox(width: TossSpacing.space2),
                  Expanded(
                    child: Text(
                      aiSummary!,
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.gray700,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// Removed unused widgets: _HeroStatsSection, _HeroStatCard, _formatDate
// Now using _OverviewSection instead

/// Store Performance - 매장별 요약
class _StorePerformanceSection extends StatelessWidget {
  final List<StorePerformance> stores;

  const _StorePerformanceSection({required this.stores});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(TossSpacing.paddingLG),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        boxShadow: TossShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(TossSpacing.space2),
                decoration: BoxDecoration(
                  color: TossColors.gray100,
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                child: Icon(
                  LucideIcons.building2,
                  size: TossSpacing.iconSM,
                  color: TossColors.gray600,
                ),
              ),
              SizedBox(width: TossSpacing.gapMD),
              Text(
                'Store Performance',
                style: TossTextStyles.h4.copyWith(
                  color: TossColors.gray900,
                ),
              ),
            ],
          ),

          SizedBox(height: TossSpacing.gapLG),

          // Store List - 문제 있는 매장 먼저
          ...stores.map((store) {
            final hasIssues = store.issuesCount > 0;
            final status = store.status;

            Color statusColor;
            IconData statusIcon;

            if (status == 'critical') {
              statusColor = Colors.red;
              statusIcon = LucideIcons.xCircle;
            } else if (status == 'warning') {
              statusColor = Colors.orange;
              statusIcon = LucideIcons.alertCircle;
            } else {
              statusColor = Colors.green;
              statusIcon = LucideIcons.checkCircle;
            }

            return Container(
              margin: EdgeInsets.only(bottom: TossSpacing.space2),
              padding: EdgeInsets.all(TossSpacing.paddingSM),
              decoration: BoxDecoration(
                color: hasIssues
                    ? statusColor.withOpacity(0.03)
                    : TossColors.gray50,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
                border: Border.all(
                  color: hasIssues
                      ? statusColor.withOpacity(0.2)
                      : TossColors.gray200,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    statusIcon,
                    size: TossSpacing.iconXS,
                    color: statusColor,
                  ),
                  SizedBox(width: TossSpacing.space2),
                  Expanded(
                    child: Text(
                      store.storeName,
                      style: TossTextStyles.bodyMedium.copyWith(
                        color: TossColors.gray900,
                      ),
                    ),
                  ),
                  if (hasIssues)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: TossSpacing.space2,
                        vertical: TossSpacing.space1,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius:
                            BorderRadius.circular(TossBorderRadius.full),
                      ),
                      child: Text(
                        '${store.issuesCount} issues',
                        style: TossTextStyles.labelMedium.copyWith(
                          color: statusColor,
                        ),
                      ),
                    )
                  else
                    Text(
                      'No issues',
                      style: TossTextStyles.caption.copyWith(
                        color: Colors.green,
                      ),
                    ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

/// Issues Detail Section - 상세 정보
class _IssuesDetailSection extends StatefulWidget {
  final List<AttendanceIssue> issues;

  const _IssuesDetailSection({required this.issues});

  @override
  State<_IssuesDetailSection> createState() => _IssuesDetailSectionState();
}

class _IssuesDetailSectionState extends State<_IssuesDetailSection> {
  final Map<int, bool> _expandedStates = {};

  @override
  Widget build(BuildContext context) {
    if (widget.issues.isEmpty) {
      return Container(
        padding: EdgeInsets.all(TossSpacing.paddingLG),
        decoration: BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
          boxShadow: TossShadows.card,
        ),
        child: Center(
          child: Column(
            children: [
              Icon(LucideIcons.checkCircle, size: 48, color: Colors.green),
              SizedBox(height: TossSpacing.space3),
              Text(
                'No issues found',
                style: TossTextStyles.bodyMedium.copyWith(
                  color: TossColors.gray600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Separate unsolved and solved issues
    final unsolvedIssues = widget.issues.where((i) => !i.isSolved).toList();
    final solvedIssues = widget.issues.where((i) => i.isSolved).toList();

    return Column(
      children: [
        // Unsolved Issues (Priority)
        if (unsolvedIssues.isNotEmpty) ...[
          _IssueGroupContainer(
            title: 'Pending Issues',
            subtitle: '${unsolvedIssues.length} employees need attention',
            icon: LucideIcons.alertCircle,
            iconColor: Colors.red,
            issues: unsolvedIssues,
            expandedStates: _expandedStates,
            onToggle: (index) {
              setState(() {
                _expandedStates[index] = !(_expandedStates[index] ?? false);
              });
            },
          ),
          SizedBox(height: TossSpacing.marginMD),
        ],

        // Solved Issues
        if (solvedIssues.isNotEmpty)
          _IssueGroupContainer(
            title: 'Resolved Issues',
            subtitle: '${solvedIssues.length} issues resolved by managers',
            icon: LucideIcons.checkCircle,
            iconColor: Colors.green,
            issues: solvedIssues,
            expandedStates: _expandedStates,
            onToggle: (index) {
              setState(() {
                final actualIndex = unsolvedIssues.length + index;
                _expandedStates[actualIndex] = !(_expandedStates[actualIndex] ?? false);
              });
            },
            startIndex: unsolvedIssues.length,
          ),
      ],
    );
  }
}

/// Issue Group Container
class _IssueGroupContainer extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final List<AttendanceIssue> issues;
  final Map<int, bool> expandedStates;
  final Function(int) onToggle;
  final int startIndex;

  const _IssueGroupContainer({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.issues,
    required this.expandedStates,
    required this.onToggle,
    this.startIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(TossSpacing.paddingLG),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        boxShadow: TossShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(TossSpacing.space2),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                child: Icon(
                  icon,
                  size: TossSpacing.iconSM,
                  color: iconColor,
                ),
              ),
              SizedBox(width: TossSpacing.gapMD),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TossTextStyles.h4.copyWith(
                        color: TossColors.gray900,
                      ),
                    ),
                    SizedBox(height: TossSpacing.space1),
                    Text(
                      subtitle,
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.gray600,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: TossSpacing.gapLG),

          // Issue Cards
          ...issues.asMap().entries.map((entry) {
            final index = entry.key;
            final issue = entry.value;
            final actualIndex = startIndex + index;
            final isExpanded = expandedStates[actualIndex] ?? false;
            final isCritical = issue.severity == 'critical';

            return Container(
              margin: EdgeInsets.only(bottom: TossSpacing.space3),
              decoration: BoxDecoration(
                color: TossColors.white,
                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                border: Border.all(
                  color: TossColors.gray200,
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  // Compact view - 클릭 가능
                  InkWell(
                    onTap: () => onToggle(index),
                    child: Padding(
                      padding: EdgeInsets.all(TossSpacing.paddingSM),
                      child: Column(
                        children: [
                          // 첫 줄: 직원 + Badge (미니멀)
                          Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: TossColors.gray100,
                                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                                ),
                                child: Icon(
                                  isCritical ? LucideIcons.userX : LucideIcons.clock,
                                  size: TossSpacing.iconXS,
                                  color: TossColors.gray600,
                                ),
                              ),
                              SizedBox(width: TossSpacing.space3),
                              Expanded(
                                child: Text(
                                  issue.employeeName,
                                  style: TossTextStyles.bodyMedium.copyWith(
                                    color: TossColors.gray900,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: TossSpacing.space2,
                                  vertical: TossSpacing.space1,
                                ),
                                decoration: BoxDecoration(
                                  color: TossColors.gray100,
                                  borderRadius: BorderRadius.circular(
                                      TossBorderRadius.full),
                                ),
                                child: Text(
                                  issue.problemType,
                                  style: TossTextStyles.labelMedium.copyWith(
                                    color: TossColors.gray700,
                                  ),
                                ),
                              ),
                              SizedBox(width: TossSpacing.space2),
                              Icon(
                                isExpanded
                                    ? LucideIcons.chevronUp
                                    : LucideIcons.chevronDown,
                                size: TossSpacing.iconXS,
                                color: TossColors.gray500,
                              ),
                            ],
                          ),

                          SizedBox(height: TossSpacing.space2),

                          // 둘째 줄: 매장 + 매니저 조치
                          Row(
                            children: [
                              Icon(
                                LucideIcons.store,
                                size: 12,
                                color: TossColors.gray500,
                              ),
                              SizedBox(width: TossSpacing.marginXS),
                              Expanded(
                                child: Text(
                                  issue.storeName,
                                  style: TossTextStyles.caption.copyWith(
                                    color: TossColors.gray600,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    issue.isSolved ? LucideIcons.userCheck : LucideIcons.clock,
                                    size: 12,
                                    color: issue.isSolved ? Colors.green : TossColors.gray500,
                                  ),
                                  SizedBox(width: 2),
                                  Text(
                                    issue.isSolved
                                        ? (issue.managerAdjustment.adjustedBy != null
                                            ? 'by ${issue.managerAdjustment.adjustedBy}'
                                            : 'Resolved')
                                        : 'Pending',
                                    style: TossTextStyles.small.copyWith(
                                      color: issue.isSolved ? Colors.green : TossColors.gray600,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Expanded details - 시간 타임라인
                  if (isExpanded) ...[
                    Divider(
                      height: 1,
                      color: isCritical
                          ? Colors.red.withOpacity(0.1)
                          : Colors.orange.withOpacity(0.1),
                    ),
                    Padding(
                      padding: EdgeInsets.all(TossSpacing.paddingSM),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Payment 타임라인 (모든 케이스에 표시)
                          _PaymentTimeBar(
                            scheduledStart: issue.timeDetail.scheduledStart,
                            scheduledEnd: issue.timeDetail.scheduledEnd,
                            actualStart: issue.timeDetail.actualStart,
                            actualEnd: issue.timeDetail.actualEnd,
                            paymentStart: issue.managerAdjustment.paymentStart,
                            paymentEnd: issue.managerAdjustment.paymentEnd,
                            isManagerAdjusted: issue.managerAdjustment.isAdjusted,
                            managerName: issue.managerAdjustment.adjustedBy,
                            penalty: issue.managerAdjustment.finalPenaltyMinutes,
                            overtime: issue.managerAdjustment.finalOvertimeMinutes,
                            managerReason: issue.managerAdjustment.reason,
                          ),

                          SizedBox(height: TossSpacing.space3),

                          // AI Comment
                          if (issue.aiComment != null)
                            Container(
                              padding: EdgeInsets.all(TossSpacing.paddingSM),
                              decoration: BoxDecoration(
                                color: TossColors.primary.withOpacity(0.05),
                                borderRadius:
                                    BorderRadius.circular(TossBorderRadius.md),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    LucideIcons.sparkles,
                                    size: TossSpacing.iconXS,
                                    color: TossColors.primary,
                                  ),
                                  SizedBox(width: TossSpacing.space2),
                                  Expanded(
                                    child: Text(
                                      issue.aiComment!,
                                      style: TossTextStyles.bodySmall.copyWith(
                                        color: TossColors.gray700,
                                        height: 1.5,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

/// Manager Quality Flags Section
class _ManagerQualitySection extends StatelessWidget {
  final List<ManagerQualityFlag> flags;

  const _ManagerQualitySection({required this.flags});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(TossSpacing.paddingLG),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        boxShadow: TossShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(TossSpacing.space2),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                child: Icon(
                  LucideIcons.flag,
                  size: TossSpacing.iconSM,
                  color: Colors.amber,
                ),
              ),
              SizedBox(width: TossSpacing.gapMD),
              Text(
                'Manager Quality Flags',
                style: TossTextStyles.h4.copyWith(
                  color: TossColors.gray900,
                ),
              ),
            ],
          ),

          SizedBox(height: TossSpacing.gapLG),

          // Flags
          ...flags.map((flag) {
            return Container(
              margin: EdgeInsets.only(bottom: TossSpacing.space2),
              padding: EdgeInsets.all(TossSpacing.paddingSM),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.05),
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
                border: Border.all(
                  color: Colors.amber.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    LucideIcons.alertTriangle,
                    size: TossSpacing.iconXS,
                    color: Colors.amber,
                  ),
                  SizedBox(width: TossSpacing.space2),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          flag.description,
                          style: TossTextStyles.bodySmall.copyWith(
                            color: TossColors.gray800,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (flag.affectedEmployee != null) ...[
                          SizedBox(height: TossSpacing.space1),
                          Text(
                            'Employee: ${flag.affectedEmployee}',
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray600,
                            ),
                          ),
                        ],
                        if (flag.manager != null) ...[
                          SizedBox(height: TossSpacing.space1),
                          Text(
                            'Manager: ${flag.manager}',
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

/// Action Items Section
class _ActionItemsSection extends StatefulWidget {
  final List<UrgentAction> actions;

  const _ActionItemsSection({required this.actions});

  @override
  State<_ActionItemsSection> createState() => _ActionItemsSectionState();
}

class _ActionItemsSectionState extends State<_ActionItemsSection> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.all(TossSpacing.paddingLG),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        boxShadow: TossShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(TossSpacing.space2),
                  decoration: BoxDecoration(
                    color: TossColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  ),
                  child: Icon(
                    LucideIcons.clipboardCheck,
                    size: TossSpacing.iconSM,
                    color: TossColors.primary,
                  ),
                ),
                SizedBox(width: TossSpacing.gapMD),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Action Items',
                        style: TossTextStyles.h4.copyWith(
                          color: TossColors.gray900,
                        ),
                      ),
                      SizedBox(height: TossSpacing.space1),
                      Text(
                        '${widget.actions.length} tasks',
                        style: TossTextStyles.bodySmall.copyWith(
                          color: TossColors.gray600,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  _isExpanded
                      ? LucideIcons.chevronUp
                      : LucideIcons.chevronDown,
                  color: TossColors.gray600,
                  size: TossSpacing.iconSM,
                ),
              ],
            ),
          ),

          // Actions List
          if (_isExpanded) ...[
            SizedBox(height: TossSpacing.gapLG),
            ...widget.actions.asMap().entries.map((entry) {
              final index = entry.key;
              final action = entry.value;

              return Container(
                margin: EdgeInsets.only(bottom: TossSpacing.space2),
                padding: EdgeInsets.all(TossSpacing.paddingSM),
                decoration: BoxDecoration(
                  color: TossColors.gray50,
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: TossColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${index + 1}',
                        style: TossTextStyles.labelMedium.copyWith(
                          color: TossColors.primary,
                        ),
                      ),
                    ),
                    SizedBox(width: TossSpacing.space3),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Employee + Store info
                          Row(
                            children: [
                              Icon(
                                LucideIcons.user,
                                size: 12,
                                color: TossColors.gray500,
                              ),
                              SizedBox(width: 4),
                              Text(
                                action.employee,
                                style: TossTextStyles.bodySmall.copyWith(
                                  color: TossColors.gray900,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: TossSpacing.space2),
                              Icon(
                                LucideIcons.store,
                                size: 12,
                                color: TossColors.gray500,
                              ),
                              SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  action.store,
                                  style: TossTextStyles.caption.copyWith(
                                    color: TossColors.gray600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: TossSpacing.space1),
                          // Issue type
                          Text(
                            '${action.issue}: ${action.action}',
                            style: TossTextStyles.bodySmall.copyWith(
                              color: TossColors.gray700,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}

// Removed unused _TimelineRow widget

/// Payment Time Bar - 급여 지불 시간 타임라인
class _PaymentTimeBar extends StatelessWidget {
  final String scheduledStart;
  final String scheduledEnd;
  final String? actualStart;
  final String? actualEnd;
  final String? paymentStart;
  final String? paymentEnd;
  final bool isManagerAdjusted;
  final String? managerName;
  final int penalty;
  final int overtime;
  final String? managerReason;

  const _PaymentTimeBar({
    required this.scheduledStart,
    required this.scheduledEnd,
    this.actualStart,
    this.actualEnd,
    this.paymentStart,
    this.paymentEnd,
    this.isManagerAdjusted = false,
    this.managerName,
    required this.penalty,
    required this.overtime,
    this.managerReason,
  });

  @override
  Widget build(BuildContext context) {
    final netPayment = overtime - penalty;

    // Calculate scheduled hours (handle overnight shifts)
    final schedStart = _parseTime(scheduledStart);
    var schedEnd = _parseTime(scheduledEnd);

    // If end time is less than start time, it's an overnight shift
    if (schedEnd < schedStart) {
      schedEnd += 1440; // Add 24 hours (1440 minutes)
    }

    final scheduledMinutes = schedEnd - schedStart;
    final scheduledHours = scheduledMinutes ~/ 60;
    final scheduledMins = scheduledMinutes % 60;

    return Container(
      padding: EdgeInsets.all(TossSpacing.paddingSM),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                LucideIcons.dollarSign,
                size: TossSpacing.iconXS,
                color: TossColors.gray700,
              ),
              SizedBox(width: TossSpacing.space2),
              Text(
                'Payment',
                style: TossTextStyles.labelMedium.copyWith(
                  color: TossColors.gray700,
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: TossSpacing.space2,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: isManagerAdjusted
                      ? TossColors.primary.withOpacity(0.1)
                      : TossColors.gray100,
                  borderRadius: BorderRadius.circular(TossBorderRadius.full),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isManagerAdjusted ? LucideIcons.userCheck : LucideIcons.calculator,
                      size: 10,
                      color: isManagerAdjusted ? TossColors.primary : TossColors.gray600,
                    ),
                    SizedBox(width: TossSpacing.space1),
                    Text(
                      isManagerAdjusted ? 'Manual' : 'Auto',
                      style: TossTextStyles.labelSmall.copyWith(
                        color: isManagerAdjusted ? TossColors.primary : TossColors.gray600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: TossSpacing.space3),

          // Time comparison bars (vs Scheduled baseline)
          _ComparisonTimeBar(
            label: 'Actual',
            scheduledStart: scheduledStart,
            scheduledEnd: scheduledEnd,
            actualStart: actualStart ?? '?',
            actualEnd: actualEnd ?? '?',
          ),
          SizedBox(height: TossSpacing.space2),
          _ComparisonTimeBar(
            label: isManagerAdjusted
                ? 'Payment (by ${managerName ?? "Manager"})'
                : 'Payment',
            scheduledStart: scheduledStart,
            scheduledEnd: scheduledEnd,
            actualStart: paymentStart ?? actualStart ?? '?',
            actualEnd: paymentEnd ?? actualEnd ?? scheduledEnd,
            isPayment: true,
            isManagerAdjusted: isManagerAdjusted,
          ),

          SizedBox(height: TossSpacing.space3),

          // Final Payment Calculation
          Container(
            padding: EdgeInsets.all(TossSpacing.paddingSM),
            decoration: BoxDecoration(
              color: TossColors.white,
              borderRadius: BorderRadius.circular(TossBorderRadius.sm),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Formula
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        scheduledMins > 0 ? '${scheduledHours}h ${scheduledMins}min' : '${scheduledHours}h',
                        style: TossTextStyles.bodyMedium.copyWith(
                          color: TossColors.gray700,
                        ),
                      ),
                      SizedBox(width: TossSpacing.space1),
                      Text(
                        '${netPayment >= 0 ? "+" : ""}${netPayment} min',
                        style: TossTextStyles.bodyMedium.copyWith(
                          color: netPayment >= 0 ? Colors.green : Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: TossSpacing.space1),
                      Text(
                        '=',
                        style: TossTextStyles.bodyMedium.copyWith(
                          color: TossColors.gray400,
                        ),
                      ),
                    ],
                  ),
                ),
                // Result
                Text(
                  '${(scheduledMinutes + netPayment) ~/ 60}h ${(scheduledMinutes + netPayment) % 60}min',
                  style: TossTextStyles.h3.copyWith(
                    color: isManagerAdjusted ? TossColors.primary : TossColors.gray900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          // Manager reason
          if (isManagerAdjusted && managerReason != null && managerReason!.isNotEmpty) ...[
            SizedBox(height: TossSpacing.space2),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  LucideIcons.messageSquare,
                  size: 12,
                  color: TossColors.gray500,
                ),
                SizedBox(width: TossSpacing.space1),
                Expanded(
                  child: Text(
                    managerReason!,
                    style: TossTextStyles.small.copyWith(
                      color: TossColors.gray600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  int _parseTime(String time) {
    final parts = time.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }
}

/// Comparison Time Bar - Scheduled 기준 비교
class _ComparisonTimeBar extends StatelessWidget {
  final String label;
  final String scheduledStart;
  final String scheduledEnd;
  final String actualStart;
  final String actualEnd;
  final bool isPayment;
  final bool isManagerAdjusted;

  const _ComparisonTimeBar({
    required this.label,
    required this.scheduledStart,
    required this.scheduledEnd,
    required this.actualStart,
    required this.actualEnd,
    this.isPayment = false,
    this.isManagerAdjusted = false,
  });

  @override
  Widget build(BuildContext context) {
    // Parse times (null-safe)
    final schedStart = _parseTime(scheduledStart);
    final schedEnd = _parseTime(scheduledEnd);
    final actStart = actualStart == '?' ? null : _parseTime(actualStart);
    final actEnd = actualEnd == '?' ? null : _parseTime(actualEnd);

    final startDiff = actStart != null ? (actStart - schedStart) : 0;
    final endDiff = actEnd != null ? (actEnd - schedEnd) : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label + Time info
        Row(
          children: [
            SizedBox(
              width: 70,
              child: Text(
                label,
                style: TossTextStyles.small.copyWith(
                  color: TossColors.gray600,
                  fontWeight: isPayment ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            if (startDiff != 0)
              Row(
                children: [
                  Icon(
                    LucideIcons.clock,
                    size: 12,
                    color: startDiff > 0 ? Colors.red : Colors.green,
                  ),
                  SizedBox(width: 2),
                  Text(
                    '${startDiff > 0 ? "+" : ""}${startDiff} min',
                    style: TossTextStyles.labelSmall.copyWith(
                      color: startDiff > 0 ? Colors.red : Colors.green,
                    ),
                  ),
                ],
              ),
            Spacer(),
            if (endDiff != 0)
              Row(
                children: [
                  Text(
                    '${endDiff > 0 ? "+" : ""}${endDiff} min',
                    style: TossTextStyles.labelSmall.copyWith(
                      color: endDiff > 0 ? Colors.green : Colors.red,
                    ),
                  ),
                  SizedBox(width: 2),
                  Icon(
                    LucideIcons.clock,
                    size: 12,
                    color: endDiff > 0 ? Colors.green : Colors.red,
                  ),
                ],
              ),
          ],
        ),
        SizedBox(height: TossSpacing.space1),

        // Time bar with colors
        Row(
          children: [
            SizedBox(width: 70),
            Expanded(
              child: Column(
                children: [
                  // Bar
                  Container(
                    height: isPayment ? 24 : 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                      border: Border.all(
                        color: isManagerAdjusted ? TossColors.primary : TossColors.gray200,
                        width: isManagerAdjusted ? 2 : 1,
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Base
                        Container(
                          decoration: BoxDecoration(
                            color: TossColors.gray100,
                            borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                          ),
                        ),
                        // Colored bar with time inside
                        ClipRRect(
                          borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                          child: Row(
                            children: [
                              // Left - Late (빨강)
                              if (startDiff > 0)
                                Container(
                                  width: 40,
                                  color: Colors.red.withOpacity(0.6),
                                )
                              else if (startDiff < 0)
                                Container(
                                  width: 30,
                                  color: Colors.green.withOpacity(0.6),
                                ),
                              // Middle - Normal
                              Expanded(child: SizedBox()),
                              // Right - Overtime (초록)
                              if (endDiff > 0)
                                Container(
                                  width: 25,
                                  color: Colors.green.withOpacity(0.6),
                                )
                              else if (endDiff < 0)
                                Container(
                                  width: 20,
                                  color: Colors.red.withOpacity(0.6),
                                ),
                            ],
                          ),
                        ),
                        // Time labels on top of bar
                        Positioned.fill(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: TossSpacing.space2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  actualStart,
                                  style: TossTextStyles.small.copyWith(
                                    color: isManagerAdjusted ? TossColors.primary : TossColors.gray900,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  actualEnd,
                                  style: TossTextStyles.small.copyWith(
                                    color: isManagerAdjusted ? TossColors.primary : TossColors.gray900,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Scheduled markers (△)
                  SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '△$scheduledStart',
                        style: TossTextStyles.small.copyWith(
                          color: TossColors.gray400,
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        '△$scheduledEnd',
                        style: TossTextStyles.small.copyWith(
                          color: TossColors.gray400,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  int _parseTime(String time) {
    final parts = time.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }
}
