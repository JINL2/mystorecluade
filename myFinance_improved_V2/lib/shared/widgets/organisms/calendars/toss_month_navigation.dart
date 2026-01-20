import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// TossMonthNavigation - Navigation for Month view (Prev/Current/Next)
///
/// Design Specs:
/// - Layout: Row (space-between) with Left/Center/Right buttons
/// - Height: 48px
/// - Left/Right: IconButtons (chevron_left, chevron_right) 24x24, gray600
/// - Center: Tappable text "{Month} {year}" (body1Medium, gray900)
/// - Center tap: Jump to current month
class TossMonthNavigation extends StatelessWidget {
  final String currentMonth;
  final int year;
  final VoidCallback onPrevMonth;
  final VoidCallback onCurrentMonth;
  final VoidCallback onNextMonth;

  const TossMonthNavigation({
    super.key,
    required this.currentMonth,
    required this.year,
    required this.onPrevMonth,
    required this.onCurrentMonth,
    required this.onNextMonth,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: TossSpacing.iconXXL,
      child: Row(
        children: [
          // Left: Previous month button
          IconButton(
            onPressed: onPrevMonth,
            icon: Icon(Icons.chevron_left, size: TossSpacing.iconLG, color: TossColors.gray600),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 40, minHeight: 48),
          ),
          // Center: Current month text (tappable) - takes remaining space
          Expanded(
            child: InkWell(
              onTap: onCurrentMonth,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space1),
                  child: Text(
                    '$currentMonth $year',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Right: Next month button
          IconButton(
            onPressed: onNextMonth,
            icon: Icon(Icons.chevron_right, size: TossSpacing.iconLG, color: TossColors.gray600),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 40, minHeight: 48),
          ),
        ],
      ),
    );
  }
}
