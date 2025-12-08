import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// ShiftSignupDatePicker
///
/// 7-day horizontal date picker with circular design
/// Shows Mon-Sun with blue dots indicating dates with available shifts
///
/// **Design:**
/// - Circular date buttons (48x48)
/// - Blue dot indicator for shift availability
/// - Selected state with primary color background
/// - Follows Toss design system
class ShiftSignupDatePicker extends StatelessWidget {
  final DateTime weekStartDate;
  final DateTime selectedDate;
  final Set<String> datesWithShifts;
  final Set<String> datesWithUserApproved;
  final Function(DateTime) onDateSelected;

  const ShiftSignupDatePicker({
    super.key,
    required this.weekStartDate,
    required this.selectedDate,
    required this.datesWithShifts,
    required this.datesWithUserApproved,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: TossColors.white,
      padding: EdgeInsets.symmetric(
        horizontal: TossSpacing.space3,
        vertical: TossSpacing.space4,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(7, (index) {
          final date = weekStartDate.add(Duration(days: index));
          final isSelected = _isSameDay(date, selectedDate);
          final dateKey = DateFormat('yyyy-MM-dd').format(date);
          final hasShifts = datesWithShifts.contains(dateKey);
          final hasUserApproved = datesWithUserApproved.contains(dateKey);

          return _DateCircle(
            date: date,
            isSelected: isSelected,
            hasShifts: hasShifts,
            hasUserApproved: hasUserApproved,
            onTap: () => onDateSelected(date),
          );
        }),
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

/// _DateCircle - Individual date button component
class _DateCircle extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final bool hasShifts;
  final bool hasUserApproved;
  final VoidCallback onTap;

  const _DateCircle({
    required this.date,
    required this.isSelected,
    required this.hasShifts,
    required this.hasUserApproved,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final weekdayLabel = DateFormat('E').format(date); // Mon, Tue, etc.
    final dayNumber = date.day.toString();
    final isToday = _isToday(date);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 64,
        decoration: BoxDecoration(
          color: isSelected ? TossColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Weekday label (Mon, Tue, etc.)
            Text(
              weekdayLabel,
              style: TossTextStyles.caption.copyWith(
                color: isSelected
                    ? TossColors.white
                    : isToday
                        ? TossColors.primary
                        : TossColors.gray600,
                fontWeight: isToday ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            SizedBox(height: TossSpacing.space1),

            // Day number
            Text(
              dayNumber,
              style: TossTextStyles.bodyLarge.copyWith(
                color: isSelected
                    ? TossColors.white
                    : isToday
                        ? TossColors.primary
                        : TossColors.gray900,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: TossSpacing.space1),

            // Indicator dot
            _buildIndicatorDot(),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicatorDot() {
    if (hasUserApproved) {
      // Green dot: user has approved shift
      return Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          color: isSelected ? TossColors.white : TossColors.success,
          shape: BoxShape.circle,
        ),
      );
    } else if (hasShifts) {
      // Blue dot: available shifts
      return Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          color: isSelected ? TossColors.white : TossColors.primary,
          shape: BoxShape.circle,
        ),
      );
    }

    // No dot: no shifts available
    return SizedBox(width: 6, height: 6);
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}
