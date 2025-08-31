import 'package:flutter/material.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_border_radius.dart';

/// Simple time picker widget for Toss design system
class TossSimpleTimePicker extends StatelessWidget {
  final TimeOfDay? time;
  final String placeholder;
  final Function(TimeOfDay) onTimeChanged;
  final bool use24HourFormat;
  
  const TossSimpleTimePicker({
    super.key,
    this.time,
    required this.placeholder,
    required this.onTimeChanged,
    this.use24HourFormat = false,
  });
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: time ?? TimeOfDay.now(),
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: TossColors.primary,
                  onPrimary: TossColors.white,
                  onSurface: TossColors.gray900,
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor: TossColors.primary,
                  ),
                ),
              ),
              child: child!,
            );
          },
        );
        
        if (picked != null) {
          onTimeChanged(picked);
        }
      },
      borderRadius: BorderRadius.circular(TossBorderRadius.md),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: TossSpacing.space3,
          vertical: TossSpacing.space3,
        ),
        decoration: BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          border: Border.all(
            color: TossColors.gray200,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              time != null 
                ? _formatTime(time!, use24HourFormat)
                : placeholder,
              style: TossTextStyles.body.copyWith(
                color: time != null 
                  ? TossColors.gray900 
                  : TossColors.gray400,
              ),
            ),
            Icon(
              Icons.access_time,
              color: TossColors.gray400,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
  
  String _formatTime(TimeOfDay time, bool use24Hour) {
    if (use24Hour) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else {
      final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
      final period = time.period == DayPeriod.am ? 'AM' : 'PM';
      return '${hour.toString()}:${time.minute.toString().padLeft(2, '0')} $period';
    }
  }
}