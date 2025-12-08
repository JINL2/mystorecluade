import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/widgets/toss/toss_week_navigation.dart';

/// ShiftSignupWeekHeader
///
/// Week navigation component for shift signup tab
/// Shows: < Previous week | This week • 10-16 Jun | Next week >
///
/// **Design:**
/// - Uses shared TossWeekNavigation component
/// - Follows Toss design system spacing and colors
/// - Clean separation of UI from business logic
class ShiftSignupWeekHeader extends StatelessWidget {
  final String weekLabel;
  final String dateRange;
  final bool canGoPrevious;
  final bool canGoNext;
  final VoidCallback onPreviousWeek;
  final VoidCallback onNextWeek;

  const ShiftSignupWeekHeader({
    super.key,
    required this.weekLabel,
    required this.dateRange,
    required this.canGoPrevious,
    required this.canGoNext,
    required this.onPreviousWeek,
    required this.onNextWeek,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: TossColors.white,
      padding: EdgeInsets.fromLTRB(
        TossSpacing.space4,
        TossSpacing.space3,
        TossSpacing.space4,
        TossSpacing.space2,
      ),
      child: TossWeekNavigation(
        weekLabel: weekLabel,
        dateRange: dateRange,
        canGoPrevious: canGoPrevious,
        canGoNext: canGoNext,
        onPreviousWeek: onPreviousWeek,
        onNextWeek: onNextWeek,
      ),
    );
  }
}
