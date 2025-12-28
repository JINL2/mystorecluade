import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// A styled date picker widget for form inputs
///
/// Displays a tappable container that shows a date picker dialog.
/// Used in AddTransactionDialog for selecting dates like issue date, due date, etc.
class FormDatePicker extends StatelessWidget {
  final DateTime? date;
  final ValueChanged<DateTime> onChanged;
  final String placeholder;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const FormDatePicker({
    super.key,
    required this.date,
    required this.onChanged,
    this.placeholder = 'Select date',
    this.firstDate,
    this.lastDate,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showPicker(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: TossColors.gray50,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          border: Border.all(
            color: TossColors.gray200,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, size: 18, color: TossColors.gray600),
            const SizedBox(width: TossSpacing.space2),
            Text(
              date != null ? DateFormat('yyyy-MM-dd').format(date!) : placeholder,
              style: TossTextStyles.body.copyWith(
                color: date != null ? TossColors.gray900 : TossColors.gray400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showPicker(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: date ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(2000),
      lastDate: lastDate ?? DateTime(2100),
    );
    if (picked != null) {
      onChanged(picked);
    }
  }
}
