import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/common/toss_calendar_bottom_sheet.dart';
import '../../../../../shared/widgets/common/toss_loading_view.dart';
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
  final Map<String, Map<String, dynamic>> managerOverviewDataByMonth;
  final Map<String, Map<String, dynamic>> managerCardsDataByMonth;
  final void Function(String?) onFilterChanged;
  final void Function(DateTime) onDateChanged;
  final void Function(Map<String, dynamic>) onCardTap;
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
    required this.onCardTap,
    required this.getMonthName,
  });

  String _getMonthlyStatValue(String statKey) {
    final monthKey = '${manageSelectedDate.year}-${manageSelectedDate.month.toString().padLeft(2, '0')}';
    final monthData = managerOverviewDataByMonth[monthKey];

    if (monthData == null || monthData['stores'] == null) {
      return '0';
    }

    final stores = monthData['stores'] as List<dynamic>? ?? [];
    if (stores.isEmpty) {
      return '0';
    }

    final storeData = stores.first as Map<String, dynamic>;
    final monthlyStats = storeData['monthly_stats'] as List<dynamic>? ?? [];

    if (monthlyStats.isEmpty) {
      return '0';
    }

    final monthStat = monthlyStats.first as Map<String, dynamic>;
    final value = monthStat[statKey];

    return value?.toString() ?? '0';
  }

  Map<String, bool> _getDateShiftStatus(DateTime date) {
    final monthKey = '${date.year}-${date.month.toString().padLeft(2, '0')}';
    final monthData = managerCardsDataByMonth[monthKey];

    if (monthData == null || monthData['stores'] == null) {
      return {'hasApproved': false, 'hasPending': false, 'hasProblem': false};
    }

    final stores = monthData['stores'] as List<dynamic>? ?? [];
    if (stores.isEmpty) {
      return {'hasApproved': false, 'hasPending': false, 'hasProblem': false};
    }

    final storeData = stores.first as Map<String, dynamic>;
    final cards = storeData['cards'] as List<dynamic>? ?? [];

    final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    final dateCards = cards
        .where((card) => (card as Map<String, dynamic>)['request_date'] == dateStr)
        .cast<Map<String, dynamic>>()
        .toList();

    bool hasApproved = false;
    bool hasPending = false;
    bool hasProblem = false;

    for (final card in dateCards) {
      if (card['is_problem'] == true && card['is_problem_solved'] != true) {
        hasProblem = true;
      }

      if (card['is_approved'] == true) {
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

  List<Map<String, dynamic>> _getFilteredCards() {
    final monthKey = '${manageSelectedDate.year}-${manageSelectedDate.month.toString().padLeft(2, '0')}';
    final monthData = managerCardsDataByMonth[monthKey];

    if (monthData == null || monthData['stores'] == null) {
      return [];
    }

    final stores = monthData['stores'] as List<dynamic>? ?? [];
    if (stores.isEmpty) {
      return [];
    }

    final storeData = stores.first as Map<String, dynamic>;
    final cards = storeData['cards'] as List<dynamic>? ?? [];

    if (selectedFilter == null || selectedFilter == 'all') {
      return cards.cast<Map<String, dynamic>>();
    }

    return cards.where((card) {
      final cardMap = card as Map<String, dynamic>;
      if (selectedFilter == 'problem') {
        return cardMap['is_problem'] == true && cardMap['is_problem_solved'] != true;
      } else if (selectedFilter == 'approved') {
        return cardMap['is_approved'] == true;
      } else if (selectedFilter == 'pending') {
        return cardMap['is_approved'] != true;
      }
      return true;
    }).cast<Map<String, dynamic>>().toList();
  }

  Map<String, TossCalendarIndicatorType> _buildDateIndicatorsForCalendar() {
    final indicators = <String, TossCalendarIndicatorType>{};
    final monthKey = '${manageSelectedDate.year}-${manageSelectedDate.month.toString().padLeft(2, '0')}';
    final monthData = managerCardsDataByMonth[monthKey];

    if (monthData != null && monthData['stores'] != null) {
      final stores = monthData['stores'] as List<dynamic>? ?? [];
      if (stores.isNotEmpty) {
        final storeData = stores.first as Map<String, dynamic>;
        final cards = storeData['cards'] as List<dynamic>? ?? [];

        for (final card in cards) {
          final cardMap = card as Map<String, dynamic>;
          final requestDate = cardMap['request_date'] as String?;
          if (requestDate != null) {
            final isProblem = (cardMap['is_problem'] == true) && (cardMap['is_problem_solved'] != true);
            final isApproved = (cardMap['is_approved'] as bool?) ?? false;

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
          // Monthly Overview Section
          Container(
            margin: const EdgeInsets.all(TossSpacing.space5),
            padding: const EdgeInsets.all(TossSpacing.space5),
            decoration: BoxDecoration(
              color: TossColors.primarySurface,
              borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
            ),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Header
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$monthName ${manageSelectedDate.year}',
                        style: TossTextStyles.h2.copyWith(
                          color: TossColors.gray900,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Monthly Overview',
                        style: TossTextStyles.bodySmall.copyWith(
                          color: TossColors.gray500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: TossSpacing.space5),
                  // Stats Grid
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 1.45,
                    mainAxisSpacing: TossSpacing.space3,
                    crossAxisSpacing: TossSpacing.space3,
                    children: [
                      StatCardWidget(
                        icon: Icons.calendar_today,
                        iconColor: TossColors.primary,
                        backgroundColor: TossColors.background,
                        title: 'Total Request',
                        value: _getMonthlyStatValue('total_requests'),
                        subtitle: 'requests',
                        onTap: () => onFilterChanged('all'),
                      ),
                      StatCardWidget(
                        icon: Icons.warning_amber_rounded,
                        iconColor: TossColors.error,
                        backgroundColor: TossColors.errorLight,
                        title: 'Problem',
                        value: _getMonthlyStatValue('total_problems'),
                        subtitle: 'issues',
                        onTap: () => onFilterChanged('problem'),
                      ),
                      StatCardWidget(
                        icon: Icons.check_circle,
                        iconColor: TossColors.success,
                        backgroundColor: TossColors.successLight,
                        title: 'Total Approve',
                        value: _getMonthlyStatValue('total_approved'),
                        subtitle: 'approved',
                        onTap: () => onFilterChanged('approved'),
                      ),
                      StatCardWidget(
                        icon: Icons.pending_actions,
                        iconColor: TossColors.warning,
                        backgroundColor: TossColors.warningLight,
                        title: 'Pending',
                        value: _getMonthlyStatValue('total_pending'),
                        subtitle: 'pending',
                        onTap: () => onFilterChanged('pending'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: TossSpacing.space5),

          // This Week Schedule Section
          Container(
            margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'This Week Schedule',
                          style: TossTextStyles.h3.copyWith(
                            color: TossColors.gray900,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$monthName ${manageSelectedDate.year}',
                          style: TossTextStyles.bodySmall.copyWith(
                            color: TossColors.gray500,
                          ),
                        ),
                      ],
                    ),
                    // View Calendar Button
                    InkWell(
                      onTap: () async {
                        HapticFeedback.selectionClick();
                        await TossCalendarBottomSheet.show(
                          context: context,
                          initialDate: manageSelectedDate,
                          displayMonth: manageSelectedDate,
                          title: 'Select Date',
                          dateIndicators: _buildDateIndicatorsForCalendar(),
                          onDateSelected: (date) async {
                            onDateChanged(date);
                          },
                        );
                      },
                      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: TossSpacing.space3,
                          vertical: TossSpacing.space2,
                        ),
                        decoration: BoxDecoration(
                          color: TossColors.gray50,
                          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_month,
                              size: 18,
                              color: TossColors.gray600,
                            ),
                            const SizedBox(width: TossSpacing.space1),
                            Text(
                              'View Calendar',
                              style: TossTextStyles.bodySmall.copyWith(
                                color: TossColors.gray600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: TossSpacing.space4),
                // Week Days - 7 days with selected date in center
                SizedBox(
                  height: 100,
                  child: Row(
                    children: List.generate(7, (index) {
                      final offset = index - 3;
                      final date = manageSelectedDate.add(Duration(days: offset));
                      final isSelected = index == 3;
                      final today = DateTime.now();
                      final isToday = date.day == today.day &&
                          date.month == today.month &&
                          date.year == today.year;

                      const dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
                      final dayName = dayNames[date.weekday % 7];

                      final shiftStatus = _getDateShiftStatus(date);

                      return Expanded(
                        child: InkWell(
                          onTap: () => onDateChanged(date),
                          borderRadius: BorderRadius.circular(isSelected ? 20 : 12),
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: index == 0 || index == 6 ? 0 : 2),
                            decoration: BoxDecoration(
                              color: isSelected ? TossColors.primary : TossColors.gray50,
                              borderRadius: BorderRadius.circular(isSelected ? 20 : 12),
                              border: isToday && !isSelected
                                  ? Border.all(color: TossColors.primary.withValues(alpha: 0.3), width: 1)
                                  : null,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  dayName,
                                  style: TossTextStyles.caption.copyWith(
                                    color: isSelected
                                        ? TossColors.white.withValues(alpha: 0.8)
                                        : TossColors.gray500,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: TossSpacing.space2),
                                Text(
                                  '${date.day}',
                                  style: TossTextStyles.h3.copyWith(
                                    color: isSelected ? TossColors.white : TossColors.gray900,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: TossSpacing.space1),
                                SizedBox(
                                  height: 8,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (shiftStatus['hasProblem'] == true)
                                        Container(
                                          width: 6,
                                          height: 6,
                                          margin: const EdgeInsets.symmetric(horizontal: 1),
                                          decoration: BoxDecoration(
                                            color: isSelected ? TossColors.white : TossColors.error,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      if (shiftStatus['hasPending'] == true && shiftStatus['hasProblem'] != true)
                                        Container(
                                          width: 6,
                                          height: 6,
                                          margin: const EdgeInsets.symmetric(horizontal: 1),
                                          decoration: BoxDecoration(
                                            color: isSelected ? TossColors.white : TossColors.warning,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      if (shiftStatus['hasApproved'] == true && shiftStatus['hasProblem'] != true && shiftStatus['hasPending'] != true)
                                        Container(
                                          width: 6,
                                          height: 6,
                                          margin: const EdgeInsets.symmetric(horizontal: 1),
                                          decoration: BoxDecoration(
                                            color: isSelected ? TossColors.white : TossColors.success,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      if (shiftStatus['hasApproved'] != true && shiftStatus['hasPending'] != true && shiftStatus['hasProblem'] != true)
                                        Container(
                                          width: 6,
                                          height: 6,
                                          margin: const EdgeInsets.symmetric(horizontal: 1),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? TossColors.white.withValues(alpha: 0.5)
                                                : TossColors.gray300,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: TossSpacing.space5),

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
