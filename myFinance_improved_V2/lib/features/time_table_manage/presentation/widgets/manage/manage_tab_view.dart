import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/common/toss_loading_view.dart';
import '../../../domain/entities/manager_overview.dart';
import '../../../domain/entities/manager_shift_cards.dart';
import '../../../domain/entities/shift_card.dart';
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
    final filteredByDate = filteredCards.where((card) => card.shiftDate == selectedDateStr).toList();

    // Return ShiftCard entities directly
    return filteredByDate;
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
