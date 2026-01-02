import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

/// Date picker field widget
class DatePickerField extends StatelessWidget {
  final DateTime? selectedDate;
  final VoidCallback onTap;

  const DatePickerField({
    super.key,
    required this.selectedDate,
    required this.onTap,
  });

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date of Birth',
          style: TossTextStyles.label.copyWith(
            color: TossColors.gray700,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: TossSpacing.space4,
              vertical: TossSpacing.space4,
            ),
            decoration: BoxDecoration(
              color: TossColors.white,
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              border: Border.all(
                color: TossColors.gray100,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedDate != null
                      ? _formatDate(selectedDate!)
                      : 'Select date',
                  style: TossTextStyles.body.copyWith(
                    color: selectedDate != null
                        ? TossColors.gray900
                        : TossColors.gray500,
                    fontWeight: selectedDate != null
                        ? FontWeight.w500
                        : FontWeight.w400,
                  ),
                ),
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 20,
                  color: TossColors.gray600,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
