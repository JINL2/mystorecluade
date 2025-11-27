import 'package:flutter/material.dart';
import '../../themes/toss_colors.dart';
import '../../themes/toss_text_styles.dart';

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
      height: 48,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Previous month button
          IconButton(
            onPressed: onPrevMonth,
            icon: const Icon(Icons.chevron_left),
            color: TossColors.gray600,
            iconSize: 24,
          ),
          // Center: Current month text (tappable)
          InkWell(
            onTap: onCurrentMonth,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                '$currentMonth $year',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray900,
                ),
              ),
            ),
          ),
          // Right: Next month button
          IconButton(
            onPressed: onNextMonth,
            icon: const Icon(Icons.chevron_right),
            color: TossColors.gray600,
            iconSize: 24,
          ),
        ],
      ),
    );
  }
}
