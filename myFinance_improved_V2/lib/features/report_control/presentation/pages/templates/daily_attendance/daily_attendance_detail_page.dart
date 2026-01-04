// lib/features/report_control/presentation/pages/templates/daily_attendance/daily_attendance_detail_page.dart

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';
import '../../../../domain/entities/report_notification.dart';
import '../../../../domain/entities/templates/daily_attendance/attendance_report.dart';
import '../../../utils/report_parser.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';
import 'widgets/widgets.dart';

/// Daily Attendance Report Detail Page
///
/// Designed for business owners to quickly understand yesterday's situation at a glance
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
      print('[DailyAttendance] Error parsing report: $e');
      print('[DailyAttendance] Stack trace: $stackTrace');
      return _buildErrorPage('Error parsing report: $e');
    }

    return TossScaffold(
      backgroundColor: TossColors.gray50,
      appBar: const TossAppBar(
        title: 'Daily Attendance Report',
        backgroundColor: TossColors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(TossSpacing.paddingMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Overview (minimal - one line)
            if (report.heroStats != null)
              OverviewSection(
                reportDate: notification.reportDate,
                heroStats: report.heroStats!,
                aiSummary: report.aiSummary,
              ),
            if (report.heroStats != null)
              SizedBox(height: TossSpacing.marginLG),

            // 2. Store Performance (store status - big scope)
            StorePerformanceSection(stores: report.stores),
            SizedBox(height: TossSpacing.marginLG),

            // 3. Issues Detail (employee details - small scope)
            IssuesDetailSection(issues: report.issues),
            SizedBox(height: TossSpacing.marginLG),

            // 4. Manager Quality Flags (manager evaluation)
            if (report.managerQualityFlags != null &&
                report.managerQualityFlags!.isNotEmpty)
              ManagerQualitySection(flags: report.managerQualityFlags!),
            if (report.managerQualityFlags != null &&
                report.managerQualityFlags!.isNotEmpty)
              SizedBox(height: TossSpacing.marginLG),

            // 5. Action Items (things to do)
            ActionItemsSection(actions: report.urgentActions),
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
      appBar: const TossAppBar(
        title: 'Error',
        backgroundColor: TossColors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.alertCircle, size: 64, color: TossColors.error),
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
}
