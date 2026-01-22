import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_dimensions.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/themes/toss_font_weight.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';
import 'package:myfinance_improved/shared/widgets/organisms/sheets/toss_bottom_sheet.dart';

/// Shows a date picker bottom sheet
void showDatePickerBottomSheet({
  required BuildContext context,
  required DateTime? initialDate,
  required ValueChanged<DateTime> onDateSelected,
}) {
  final now = DateTime.now();
  final defaultDate = initialDate ?? DateTime(now.year - 25, now.month, now.day);

  TossBottomSheet.show<void>(
    context: context,
    title: 'Select Date',
    content: _DatePickerContent(
      initialDate: defaultDate,
      now: now,
      onDateSelected: onDateSelected,
    ),
  );
}

/// Stateful content widget for date picker
class _DatePickerContent extends StatefulWidget {
  final DateTime initialDate;
  final DateTime now;
  final ValueChanged<DateTime> onDateSelected;

  const _DatePickerContent({
    required this.initialDate,
    required this.now,
    required this.onDateSelected,
  });

  @override
  State<_DatePickerContent> createState() => _DatePickerContentState();
}

class _DatePickerContentState extends State<_DatePickerContent> {
  late int selectedYear;
  late int selectedMonth;
  late int selectedDay;

  @override
  void initState() {
    super.initState();
    selectedYear = widget.initialDate.year;
    selectedMonth = widget.initialDate.month;
    selectedDay = widget.initialDate.day;
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(selectedYear, selectedMonth + 1, 0).day;
    if (selectedDay > daysInMonth) {
      selectedDay = daysInMonth;
    }

    return SizedBox(
      height: TossSpacing.space20 * 4, // 320
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
              TossButton.textButton(
                text: 'Done',
                onPressed: () {
                  widget.onDateSelected(DateTime(selectedYear, selectedMonth, selectedDay));
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
                    items: List.generate(100, (i) => (widget.now.year - i).toString()),
                    selectedValue: selectedYear.toString(),
                    onChanged: (value) {
                      setState(() {
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
                      setState(() {
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
                      setState(() {
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
  }
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
