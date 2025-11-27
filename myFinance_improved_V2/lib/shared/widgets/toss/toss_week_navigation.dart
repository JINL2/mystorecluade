import 'package:flutter/material.dart';
import '../../themes/toss_colors.dart';
import '../../themes/toss_text_styles.dart';

/// TossWeekNavigation - Navigation for Week view (Prev/Current/Next)
///
/// Design Specs (from screenshot):
/// - Layout: Row (space-between) with Left/Center/Right buttons
/// - Center text: "This week • 17 - 23 Jun" format
/// - Left button: "< Previous week"
/// - Right button: "Next week >"
/// - Gray600 color for all text
class TossWeekNavigation extends StatelessWidget {
  final String weekLabel;          // "This week", "Previous week", etc.
  final String dateRange;          // "17 - 23 Jun"
  final VoidCallback onPrevWeek;
  final VoidCallback onCurrentWeek;
  final VoidCallback onNextWeek;

  const TossWeekNavigation({
    super.key,
    required this.weekLabel,
    required this.dateRange,
    required this.onPrevWeek,
    required this.onCurrentWeek,
    required this.onNextWeek,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          // Left: Previous week button (icon only)
          IconButton(
            onPressed: onPrevWeek,
            icon: Icon(Icons.chevron_left, size: 24, color: TossColors.gray600),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 40, minHeight: 48),
          ),

          // Center: Current week text (tappable) - takes remaining space
          Expanded(
            child: InkWell(
              onTap: onCurrentWeek,
              borderRadius: BorderRadius.circular(8),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    '$weekLabel • $dateRange',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
            ),
          ),

          // Right: Next week button (icon only)
          IconButton(
            onPressed: onNextWeek,
            icon: Icon(Icons.chevron_right, size: 24, color: TossColors.gray600),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 40, minHeight: 48),
          ),
        ],
      ),
    );
  }
}
