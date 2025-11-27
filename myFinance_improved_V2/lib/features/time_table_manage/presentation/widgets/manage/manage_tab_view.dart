import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/common/toss_calendar_bottom_sheet.dart';
import '../../../../../shared/widgets/common/toss_loading_view.dart';
import '../../../domain/entities/manager_overview.dart';
import '../../../domain/entities/manager_shift_cards.dart';
import '../../../domain/entities/shift_card.dart';
import '../common/stat_card_widget.dart';
import 'manage_shift_card.dart';

/// Manage Tab View
///
/// Full view for the Manage tab with overview stats and shift cards list
class ManageTabView extends ConsumerWidget {
  final DateTime manageSelectedDate;
  final String? selectedFilter;
  final bool isLoadingOverview;
  final bool isLoadingCards;
  final Map<String, ManagerOverview> managerOverviewDataByMonth;
  final Map<String, ManagerShiftCards> managerCardsDataByMonth;
  final void Function(String?) onFilterChanged;
  final void Function(DateTime) onDateChanged;
  final Future<void> Function(DateTime)? onMonthChanged;
  final void Function(ShiftCard) onCardTap;
  final String Function(int) getMonthName;

  const ManageTabView({
    super.key,
    required this.manageSelectedDate,
    required this.selectedFilter,
    required this.isLoadingOverview,
    required this.isLoadingCards,
    required this.managerOverviewDataByMonth,
    required this.managerCardsDataByMonth,
    required this.onFilterChanged,
    required this.onDateChanged,
    this.onMonthChanged,
    required this.onCardTap,
    required this.getMonthName,
  });

  String _getMonthlyStatValue(String statKey) {
    final monthKey = '${manageSelectedDate.year}-${manageSelectedDate.month.toString().padLeft(2, '0')}';
    final overview = managerOverviewDataByMonth[monthKey];

    if (overview == null) {
      return '0';
    }

    // Map statKey to entity properties
    switch (statKey) {
      case 'total_requests':
        return overview.totalShifts.toString();
      case 'total_problems':
        return (overview.additionalStats['total_problems'] ?? 0).toString();
      case 'total_approved':
        return overview.totalApprovedRequests.toString();
      case 'total_pending':
        return overview.totalPendingRequests.toString();
      case 'total_employees':
        return overview.totalEmployees.toString();
      case 'total_cost':
        return overview.totalEstimatedCost.toStringAsFixed(0);
      default:
        return '0';
    }
  }

  Map<String, bool> _getDateShiftStatus(DateTime date) {
    final monthKey = '${date.year}-${date.month.toString().padLeft(2, '0')}';
    final monthData = managerCardsDataByMonth[monthKey];

    if (monthData == null) {
      return {'hasApproved': false, 'hasPending': false, 'hasProblem': false};
    }

    final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    final dateCards = monthData.getCardsByDate(dateStr);

    bool hasApproved = false;
    bool hasPending = false;
    bool hasProblem = false;

    for (final card in dateCards) {
      if (card.hasProblem) {
        hasProblem = true;
      }

      if (card.isApproved) {
        hasApproved = true;
      } else {
        hasPending = true;
      }
    }

    return {
      'hasApproved': hasApproved,
      'hasPending': hasPending,
      'hasProblem': hasProblem,
    };
  }

  List<ShiftCard> _getFilteredCards() {
    final monthKey = '${manageSelectedDate.year}-${manageSelectedDate.month.toString().padLeft(2, '0')}';
    final monthData = managerCardsDataByMonth[monthKey];

    if (monthData == null) {
      return [];
    }

    // First filter by selected date
    final selectedDateStr = '${manageSelectedDate.year}-${manageSelectedDate.month.toString().padLeft(2, '0')}-${manageSelectedDate.day.toString().padLeft(2, '0')}';

    // Then apply status filter
    final filteredCards = monthData.filterByStatus(selectedFilter);
    final filteredByDate = filteredCards.where((card) => card.requestDate == selectedDateStr).toList();

    // Return ShiftCard entities directly
    return filteredByDate;
  }

  // DEPRECATED: Old Map conversion method (kept for reference)
  List<Map<String, dynamic>> _getFilteredCardsAsMap() {
    final filteredByDate = _getFilteredCards();

    // Convert ShiftCard entities to Map for compatibility with existing widgets
    final result = filteredByDate.map((card) {
      // Format shift time as "HH:mm-HH:mm" in UTC for the widget to convert to local
      final startHour = card.shift.planStartTime.toUtc().hour.toString().padLeft(2, '0');
      final startMin = card.shift.planStartTime.toUtc().minute.toString().padLeft(2, '0');
      final endHour = card.shift.planEndTime.toUtc().hour.toString().padLeft(2, '0');
      final endMin = card.shift.planEndTime.toUtc().minute.toString().padLeft(2, '0');
      final shiftTime = '$startHour:$startMin-$endHour:$endMin';

      final noticeTagList = card.tags.map((tag) => {
        'id': tag.tagId,
        'type': tag.tagType,
        'content': tag.tagContent,
      },).toList();

      return {
        'shift_request_id': card.shiftRequestId,
        'request_date': card.requestDate,
        'is_approved': card.isApproved,
        'is_problem': card.hasProblem,
        'is_problem_solved': card.isProblemSolved,
        'is_late': card.isLate,
        'late_minute': card.lateMinute,
        'is_over_time': card.isOverTime,
        'over_time_minute': card.overTimeMinute,
        'paid_hour': card.paidHour,
        'is_reported': card.isReported,
        'user_id': card.employee.userId,
        'user_name': card.employee.userName,
        'profile_image': card.employee.profileImage,
        'shift_name': card.shift.shiftName ?? 'Unknown Shift',
        'shift_time': shiftTime, // Required by ManageShiftCard widget
        'plan_start_time': card.shift.planStartTime.toIso8601String(),
        'plan_end_time': card.shift.planEndTime.toIso8601String(),
        'confirm_start_time': card.confirmedStartTime?.toIso8601String(),
        'confirm_end_time': card.confirmedEndTime?.toIso8601String(),
        // Actual times from Entity (employee's check-in/out times from device)
        'actual_start': card.actualStartTime?.toIso8601String(),
        'actual_end': card.actualEndTime?.toIso8601String(),
        // Location data from Entity
        'is_valid_checkin_location': card.isValidCheckinLocation,
        'checkin_distance_from_store': card.checkinDistanceFromStore,
        'is_valid_checkout_location': card.isValidCheckoutLocation,
        'checkout_distance_from_store': card.checkoutDistanceFromStore,
        'salary_type': card.salaryType,
        'salary_amount': card.salaryAmount,
        'bonus_amount': card.bonusAmount,
        'bonus_reason': card.bonusReason,
        // Use 'notice_tag' to match RPC response format (legacy field name)
        'notice_tag': noticeTagList,
        'problem_type': card.problemType,
        'report_reason': card.reportReason,
      };
    }).toList();

    return result;
  }

  Map<String, TossCalendarIndicatorType> _buildDateIndicatorsForCalendar() {
    return _buildDateIndicatorsForMonth(manageSelectedDate);
  }

  Map<String, TossCalendarIndicatorType> _buildDateIndicatorsForMonth(DateTime targetMonth) {
    final indicators = <String, TossCalendarIndicatorType>{};
    final monthKey = '${targetMonth.year}-${targetMonth.month.toString().padLeft(2, '0')}';
    final monthData = managerCardsDataByMonth[monthKey];

    if (monthData != null) {
      for (final card in monthData.cards) {
        final requestDate = card.requestDate;
        final isProblem = card.hasProblem;
        final isApproved = card.isApproved;

        // Priority: Problem > Pending > Approved
        if (isProblem) {
          indicators[requestDate] = TossCalendarIndicatorType.problem;
        } else if (!isApproved && !indicators.containsKey(requestDate)) {
          // Only set pending if not already marked as problem
          indicators[requestDate] = TossCalendarIndicatorType.pending;
        } else if (isApproved && !indicators.containsKey(requestDate)) {
          // Only set approved if not already marked as problem or pending
          indicators[requestDate] = TossCalendarIndicatorType.approved;
        }
      }
    }

    return indicators;
  }

  String _buildEmptyMessage() {
    final day = manageSelectedDate.day;
    final monthName = getMonthName(manageSelectedDate.month);

    String filterMessage = '';
    if (selectedFilter == 'problem') {
      filterMessage = ' (unsolved problems)';
    } else if (selectedFilter == 'approved') {
      filterMessage = ' (approved)';
    } else if (selectedFilter == 'pending') {
      filterMessage = ' (pending)';
    }

    return 'No shifts for $day $monthName$filterMessage';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monthName = getMonthName(manageSelectedDate.month);

    if (isLoadingOverview) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(TossSpacing.space10),
          child: TossLoadingView(),
        ),
      );
    }

    final filteredCards = _getFilteredCards();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Shift Cards List
          if (isLoadingCards)
            Container(
              margin: const EdgeInsets.all(TossSpacing.space5),
              padding: const EdgeInsets.all(TossSpacing.space10),
              child: const Center(
                child: TossLoadingView(),
              ),
            )
          else if (filteredCards.isEmpty)
            Container(
              margin: const EdgeInsets.all(TossSpacing.space5),
              padding: const EdgeInsets.all(TossSpacing.space10),
              child: Center(
                child: Text(
                  _buildEmptyMessage(),
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray500,
                  ),
                ),
              ),
            )
          else
            Container(
              margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
              child: Column(
                children: filteredCards.map((card) {
                  return ManageShiftCard(
                    card: card,
                    onTap: () => onCardTap(card),
                  );
                }).toList(),
              ),
            ),

          const SizedBox(height: TossSpacing.space10),
        ],
      ),
    );
  }
}
