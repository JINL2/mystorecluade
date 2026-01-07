import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// Month picker bottom sheet widget
class MonthPickerSheet extends StatefulWidget {
  final DateTime selectedMonth;
  final ValueChanged<DateTime> onMonthSelected;

  const MonthPickerSheet({
    super.key,
    required this.selectedMonth,
    required this.onMonthSelected,
  });

  @override
  State<MonthPickerSheet> createState() => _MonthPickerSheetState();
}

class _MonthPickerSheetState extends State<MonthPickerSheet> {
  late int _selectedYear;

  @override
  void initState() {
    super.initState();
    _selectedYear = widget.selectedMonth.year;
  }

  void _changeYear(int delta) {
    HapticFeedback.selectionClick();
    setState(() {
      _selectedYear += delta;
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(TossSpacing.space4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: TossDimensions.dragHandleWidth,
              height: TossDimensions.dragHandleHeight,
              margin: const EdgeInsets.only(bottom: TossSpacing.space4),
              decoration: BoxDecoration(
                color: TossColors.gray300,
                borderRadius: BorderRadius.circular(TossBorderRadius.dragHandle),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  color: TossColors.gray600,
                  onPressed: () => _changeYear(-1),
                ),
                Text(
                  '$_selectedYear',
                  style: TossTextStyles.titleLarge.copyWith(
                    fontWeight: TossFontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  color: TossColors.gray600,
                  onPressed: _selectedYear < now.year ? () => _changeYear(1) : null,
                ),
              ],
            ),
            const SizedBox(height: TossSpacing.space4),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1.5,
                crossAxisSpacing: TossSpacing.space2,
                mainAxisSpacing: TossSpacing.space2,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                final monthName = _getMonthName(index + 1);
                final isSelected = _selectedYear == widget.selectedMonth.year &&
                    index == widget.selectedMonth.month - 1;
                final isFuture = _selectedYear > now.year ||
                    (_selectedYear == now.year && index > now.month - 1);

                return GestureDetector(
                  onTap: isFuture
                      ? null
                      : () {
                          HapticFeedback.selectionClick();
                          widget.onMonthSelected(
                            DateTime(_selectedYear, index + 1),
                          );
                        },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? TossColors.primary
                          : isFuture
                              ? TossColors.gray100
                              : TossColors.gray50,
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      border: isSelected
                          ? null
                          : Border.all(color: TossColors.gray200),
                    ),
                    child: Center(
                      child: Text(
                        monthName,
                        style: TossTextStyles.body.copyWith(
                          color: isSelected
                              ? TossColors.white
                              : isFuture
                                  ? TossColors.gray400
                                  : TossColors.gray900,
                          fontWeight:
                              isSelected ? TossFontWeight.semibold : TossFontWeight.medium,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: TossSpacing.space4),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}
