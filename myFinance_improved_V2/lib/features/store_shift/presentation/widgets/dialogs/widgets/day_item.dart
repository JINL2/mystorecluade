import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_font_weight.dart';
import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';
import 'day_hours_data.dart';
import 'time_button.dart';

/// Day Item Widget
///
/// Displays a single day's business hours with open/closed toggle and time pickers
class DayItem extends StatelessWidget {
  final DayHoursData data;
  final VoidCallback onToggleOpen;
  final void Function(String) onOpenTimeChanged;
  final void Function(String) onCloseTimeChanged;
  final Future<void> Function(String currentTime, ValueChanged<String> onChanged)
      onShowTimePicker;

  const DayItem({
    super.key,
    required this.data,
    required this.onToggleOpen,
    required this.onOpenTimeChanged,
    required this.onCloseTimeChanged,
    required this.onShowTimePicker,
  });

  @override
  Widget build(BuildContext context) {
    final isWeekend = data.dayOfWeek == 0 || data.dayOfWeek == 6;
    final isOvernight = data.isOpen && data.isOvernight;

    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space2),
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space3,
        vertical: TossSpacing.space2,
      ),
      decoration: BoxDecoration(
        color: isWeekend
            ? TossColors.primary.withValues(alpha: 0.05)
            : TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Day name
              SizedBox(
                width: TossSpacing.space12 + TossSpacing.space1,
                child: Text(
                  _getShortDayName(data.dayName),
                  style: TossTextStyles.body.copyWith(
                    color: isWeekend ? TossColors.primary : TossColors.gray700,
                    fontWeight: TossFontWeight.semibold,
                  ),
                ),
              ),

              // Open/Closed Toggle
              GestureDetector(
                onTap: onToggleOpen,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TossSpacing.space2,
                    vertical: TossSpacing.space1,
                  ),
                  decoration: BoxDecoration(
                    color: data.isOpen
                        ? TossColors.success.withValues(alpha: 0.1)
                        : TossColors.gray200,
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  child: Text(
                    data.isOpen ? 'Open' : 'Closed',
                    style: TossTextStyles.caption.copyWith(
                      color:
                          data.isOpen ? TossColors.success : TossColors.gray500,
                      fontWeight: TossFontWeight.semibold,
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // Time Selectors (only if open)
              if (data.isOpen) ...[
                TimeButton(
                  time: data.openTime,
                  onTap: () => onShowTimePicker(data.openTime, onOpenTimeChanged),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: TossSpacing.space2),
                  child: Text(
                    '-',
                    style:
                        TossTextStyles.body.copyWith(color: TossColors.gray400),
                  ),
                ),
                TimeButton(
                  time: data.closeTime,
                  onTap: () => onShowTimePicker(data.closeTime, onCloseTimeChanged),
                ),
              ],
            ],
          ),
          // Overnight indicator
          if (isOvernight)
            Padding(
              padding: const EdgeInsets.only(top: TossSpacing.space1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    LucideIcons.moon,
                    size: TossSpacing.space3,
                    color: TossColors.warning,
                  ),
                  SizedBox(width: TossSpacing.space1),
                  Text(
                    'Closes next day',
                    style: TossTextStyles.small.copyWith(
                      color: TossColors.warning,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  String _getShortDayName(String dayName) {
    const shortNames = {
      'Sunday': 'Sun',
      'Monday': 'Mon',
      'Tuesday': 'Tue',
      'Wednesday': 'Wed',
      'Thursday': 'Thu',
      'Friday': 'Fri',
      'Saturday': 'Sat',
    };
    return shortNames[dayName] ?? dayName;
  }
}
