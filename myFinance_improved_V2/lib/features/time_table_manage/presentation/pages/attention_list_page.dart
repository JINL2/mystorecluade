import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../providers/time_table_providers.dart';
import '../widgets/overview/attention_card.dart';
import '../widgets/timesheets/staff_timelog_card.dart';
import 'staff_timelog_detail_page.dart';

/// Attention List Page
///
/// Full page showing all items that need attention in a 2-column grid.
class AttentionListPage extends ConsumerWidget {
  final List<AttentionItemData> items;
  final String? storeId;
  /// Callback to navigate to Schedule tab with a specific date
  final void Function(DateTime date)? onNavigateToSchedule;

  const AttentionListPage({
    super.key,
    required this.items,
    this.storeId,
    this.onNavigateToSchedule,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: TossColors.gray50,
      appBar: AppBar(
        backgroundColor: TossColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: TossColors.gray900),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Need Attention (${items.length})',
          style: TossTextStyles.h3.copyWith(
            color: TossColors.gray900,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: items.isEmpty
          ? _buildEmptyState()
          : GridView.builder(
              padding: const EdgeInsets.all(TossSpacing.space3),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: TossSpacing.space3,
                mainAxisSpacing: TossSpacing.space3,
                childAspectRatio: 0.85,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return AttentionCard(
                  item: item,
                  onTap: () => _handleAttentionItemTap(context, ref, item),
                );
              },
            ),
    );
  }

  /// Handle attention item tap - navigate to detail page if it's a staff issue
  Future<void> _handleAttentionItemTap(
    BuildContext context,
    WidgetRef ref,
    AttentionItemData item,
  ) async {
    // For shift-level issues (understaffed), navigate to Schedule tab with the date
    if (item.isShiftProblem) {
      if (item.shiftDate != null && onNavigateToSchedule != null) {
        // Pop this page first, then navigate to schedule
        Navigator.of(context).pop();
        onNavigateToSchedule!(item.shiftDate!);
      }
      return;
    }

    // For staff-level issues (late, overtime, problem, reported), navigate to detail page
    if (item.shiftRequestId == null) return;

    // Create StaffTimeRecord from AttentionItemData
    final staffRecord = StaffTimeRecord(
      staffId: item.staffId ?? '',
      staffName: item.title,
      avatarUrl: item.avatarUrl,
      clockIn: item.clockIn ?? '--:--',
      clockOut: item.clockOut ?? '--:--',
      isLate: item.isLate,
      isOvertime: item.isOvertime,
      needsConfirm: !item.isConfirmed,
      isConfirmed: item.isConfirmed,
      shiftRequestId: item.shiftRequestId,
      actualStart: item.actualStart,
      actualEnd: item.actualEnd,
      confirmStartTime: item.confirmStartTime,
      confirmEndTime: item.confirmEndTime,
      isReported: item.isReported,
      reportReason: item.reportReason,
      isProblemSolved: item.isProblemSolved,
      bonusAmount: item.bonusAmount,
      salaryType: item.salaryType,
      salaryAmount: item.salaryAmount,
      basePay: item.basePay,
      totalPayWithBonus: item.totalPayWithBonus,
      paidHour: item.paidHour,
      lateMinute: item.lateMinute,
      overtimeMinute: item.overtimeMinute,
    );

    // Format shift date for display
    final shiftDateStr = item.shiftDate != null
        ? DateFormat('EEE, d MMM yyyy').format(item.shiftDate!)
        : item.date;

    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (context) => StaffTimelogDetailPage(
          staffRecord: staffRecord,
          shiftName: item.shiftName ?? 'Shift',
          shiftDate: shiftDateStr,
          shiftTimeRange: item.shiftTimeRange ?? item.time,
        ),
      ),
    );

    // If save was successful, force refresh the data
    if (result == true && storeId != null) {
      ref.read(managerCardsProvider(storeId!).notifier).loadMonth(
        month: DateTime.now(),
        forceRefresh: true,
      );
      ref.invalidate(monthlyShiftStatusProvider(storeId!));
    }
  }

  /// Build empty state
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle_outline,
            size: 64,
            color: TossColors.gray400,
          ),
          const SizedBox(height: TossSpacing.space4),
          Text(
            'All caught up!',
            style: TossTextStyles.h3.copyWith(
              color: TossColors.gray900,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: TossSpacing.space2),
          Text(
            'No items need attention',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray600,
            ),
          ),
        ],
      ),
    );
  }
}
