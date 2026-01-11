import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/atoms/buttons/toggle_button.dart';
import 'staff_timelog_card.dart' show StaffTimeRecord;
import '../../pages/staff_timelog_detail_page.dart';
import 'problem_card.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Problems section widget for TimesheetsTab
/// Displays filter chips and list of attendance problems
class ProblemsSection extends StatelessWidget {
  final String? selectedFilter;
  final ValueChanged<String?> onFilterChanged;
  final List<AttendanceProblem> allProblems;
  final List<AttendanceProblem> filteredProblems;
  final int todayCount;
  final int thisWeekCount;
  final int thisMonthCount;
  final void Function(DateTime date)? onNavigateToSchedule;
  final String? selectedStoreId;
  final void Function(String shiftRequestId, String shiftDate, Map<String, dynamic> result)? onSaveResult;

  const ProblemsSection({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.allProblems,
    required this.filteredProblems,
    required this.todayCount,
    required this.thisWeekCount,
    required this.thisMonthCount,
    this.onNavigateToSchedule,
    this.selectedStoreId,
    this.onSaveResult,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // "Problems" Section Header
        Text(
          'Problems',
          style: TossTextStyles.h3.copyWith(
            color: TossColors.gray900,
            fontWeight: TossFontWeight.bold,
          ),
        ),

        const SizedBox(height: TossSpacing.space3),

        // Filter Chips
        ToggleButtonGroup(
          items: [
            ToggleButtonItem(
              id: 'today',
              label: 'Today',
              count: todayCount,
            ),
            ToggleButtonItem(
              id: 'this_week',
              label: 'This week',
              count: thisWeekCount,
            ),
            ToggleButtonItem(
              id: 'this_month',
              label: 'This month',
              count: thisMonthCount,
            ),
          ],
          selectedId: selectedFilter ?? 'today',
          onToggle: (value) => onFilterChanged(value),
          layout: ToggleButtonLayout.expanded,
        ),

        const SizedBox(height: TossSpacing.space3),

        // Problems List
        _buildProblemsList(context),
      ],
    );
  }

  Widget _buildProblemsList(BuildContext context) {
    // Show "No problems found" only when there are NO problems at all in the month
    if (allProblems.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space3,
        ),
        child: TossEmptyView(
          title: 'No problems found',
          description: 'All attendance records look good!',
          compact: true,
        ),
      );
    }

    // Show filter-specific empty message when filtered results are empty
    // but there ARE problems in other time ranges
    if (filteredProblems.isEmpty) {
      final filterLabel = switch (selectedFilter) {
        'today' => 'today',
        'this_week' => 'this week',
        'this_month' => 'this month',
        _ => 'the selected period',
      };
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space3,
        ),
        child: TossEmptyView(
          title: 'No problems $filterLabel',
          description: 'There are ${allProblems.length} problem(s) in other dates. Check the calendar below.',
          compact: true,
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: filteredProblems.length,
      itemBuilder: (context, index) {
        final problem = filteredProblems[index];
        return ProblemCard(
          problem: problem,
          showDayNumber: selectedFilter == 'this_month',
          onTap: () => _handleProblemTap(context, problem),
        );
      },
    );
  }

  Future<void> _handleProblemTap(BuildContext context, AttendanceProblem problem) async {
    // Staff problems navigate to detail page
    if (!problem.isShiftProblem && problem.staffId != null) {
      // Create StaffTimeRecord from problem data
      final staffRecord = StaffTimeRecord(
        staffId: problem.staffId!,
        staffName: problem.name,
        avatarUrl: problem.avatarUrl,
        clockIn: problem.clockIn ?? '--:--',
        clockOut: problem.clockOut ?? '--:--',
        isLate: problem.isLate,
        isOvertime: problem.isOvertime,
        needsConfirm: !problem.isConfirmed && (problem.isLate || problem.isOvertime),
        isConfirmed: problem.isConfirmed,
        shiftRequestId: problem.shiftRequestId,
        actualStart: problem.actualStart,
        actualEnd: problem.actualEnd,
        confirmStartTime: problem.confirmStartTime,
        confirmEndTime: problem.confirmEndTime,
        isReported: problem.isReported,
        reportReason: problem.reportReason,
        isProblemSolved: problem.isProblemSolved,
        bonusAmount: problem.bonusAmount,
        salaryType: problem.salaryType,
        salaryAmount: problem.salaryAmount,
        basePay: problem.basePay,
        totalPayWithBonus: problem.totalPayWithBonus,
        paidHour: problem.paidHour,
        lateMinute: problem.lateMinute,
        overtimeMinute: problem.overtimeMinute,
        shiftEndTime: problem.shiftEndTime,
        problemDetails: problem.problemDetails,
      );

      final result = await Navigator.of(context).push<Map<String, dynamic>>(
        MaterialPageRoute<Map<String, dynamic>>(
          builder: (context) => StaffTimelogDetailPage(
            staffRecord: staffRecord,
            shiftName: problem.shiftName,
            shiftDate: DateFormat('EEE, d MMM yyyy').format(problem.date),
            shiftTimeRange: problem.timeRange ?? '--:-- - --:--',
          ),
        ),
      );

      // Partial Update: Update cached data without full refresh
      if (result != null && result['success'] == true && selectedStoreId != null) {
        final shiftDate = DateFormat('yyyy-MM-dd').format(problem.date);
        onSaveResult?.call(
          result['shiftRequestId'] as String,
          shiftDate,
          result,
        );
      }
    } else {
      // Shift problems (understaffed) navigate to Schedule tab
      onNavigateToSchedule?.call(problem.date);
    }
  }
}
