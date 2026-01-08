import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_dimensions.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/themes/toss_font_weight.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Shows a date picker bottom sheet
void showDatePickerBottomSheet({
  required BuildContext context,
  required DateTime? initialDate,
  required ValueChanged<DateTime> onDateSelected,
}) {
  final now = DateTime.now();
  final defaultDate = initialDate ?? DateTime(now.year - 25, now.month, now.day);

  int selectedYear = defaultDate.year;
  int selectedMonth = defaultDate.month;
  int selectedDay = defaultDate.day;

  showModalBottomSheet(
    context: context,
    backgroundColor: TossColors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(TossBorderRadius.bottomSheet)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          final daysInMonth = DateTime(selectedYear, selectedMonth + 1, 0).day;
          if (selectedDay > daysInMonth) {
            selectedDay = daysInMonth;
          }

          return Container(
            height: TossSpacing.space20 * 5, // 400
            padding: const EdgeInsets.all(TossSpacing.space6),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TossButton.textButton(
                      text: 'Cancel',
                      onPressed: () => Navigator.pop(context),
                      textColor: TossColors.gray600,
                    ),
                    Text(
                      'Select Date',
                      style: TossTextStyles.h3.copyWith(
                        fontWeight: TossFontWeight.bold,
                      ),
                    ),
                    TossButton.textButton(
                      text: 'Done',
                      onPressed: () {
                        onDateSelected(DateTime(selectedYear, selectedMonth, selectedDay));
                        Navigator.pop(context);
                      },
                      textColor: TossColors.primary,
                      fontWeight: TossFontWeight.semibold,
                    ),
                  ],
                ),
                const SizedBox(height: TossSpacing.space4),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: _WheelPicker(
                          items: List.generate(100, (i) => (now.year - i).toString()),
                          selectedValue: selectedYear.toString(),
                          onChanged: (value) {
                            setModalState(() {
                              selectedYear = int.parse(value);
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: TossSpacing.space2),
                      Expanded(
                        child: _WheelPicker(
                          items: const [
                            'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                            'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
                          ],
                          selectedValue: const [
                            'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                            'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
                          ][selectedMonth - 1],
                          onChanged: (value) {
                            setModalState(() {
                              selectedMonth = const [
                                'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                                'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
                              ].indexOf(value) + 1;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: TossSpacing.space2),
                      Expanded(
                        child: _WheelPicker(
                          items: List.generate(daysInMonth, (i) => (i + 1).toString()),
                          selectedValue: selectedDay.toString(),
                          onChanged: (value) {
                            setModalState(() {
                              selectedDay = int.parse(value);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

class _WheelPicker extends StatelessWidget {
  final List<String> items;
  final String selectedValue;
  final ValueChanged<String> onChanged;

  const _WheelPicker({
    required this.items,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: TossDimensions.bottomSheetMinHeight,
      decoration: BoxDecoration(
        border: Border.all(color: TossColors.gray200),
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: ListWheelScrollView.useDelegate(
        itemExtent: TossSpacing.space10,
        physics: const FixedExtentScrollPhysics(),
        diameterRatio: 1.5,
        perspective: 0.002,
        controller: FixedExtentScrollController(
          initialItem: items.indexOf(selectedValue),
        ),
        onSelectedItemChanged: (index) {
          onChanged(items[index]);
        },
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            if (index < 0 || index >= items.length) return null;
            final isSelected = items[index] == selectedValue;
            return Center(
              child: Text(
                items[index],
                style: isSelected
                    ? TossTextStyles.bodyLarge.copyWith(
                        fontWeight: TossFontWeight.semibold,
                        color: TossColors.gray900,
                      )
                    : TossTextStyles.body.copyWith(
                        fontWeight: TossFontWeight.regular,
                        color: TossColors.gray500,
                      ),
              ),
            );
          },
          childCount: items.length,
        ),
      ),
    );
  }
}
