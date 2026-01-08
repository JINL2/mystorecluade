// lib/features/transaction_history/presentation/widgets/filter_sheet/date_range_section.dart
//
// Date range section extracted from transaction_filter_sheet.dart
// Following Clean Architecture 2025 - Single Responsibility Principle

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_dimensions.dart';
import '../../../../../shared/themes/toss_font_weight.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// Date range section with From/To pickers
class DateRangeSection extends StatelessWidget {
  final DateTime? fromDate;
  final DateTime? toDate;
  final ValueChanged<DateTime?> onFromDateChanged;
  final ValueChanged<DateTime?> onToDateChanged;

  const DateRangeSection({
    super.key,
    this.fromDate,
    this.toDate,
    required this.onFromDateChanged,
    required this.onToDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date Range',
          style: TossTextStyles.label.copyWith(
            color: TossColors.textSecondary,
            fontWeight: TossFontWeight.semibold,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        Row(
          children: [
            Expanded(
              child: _DatePicker(
                label: 'From',
                value: fromDate,
                onChanged: onFromDateChanged,
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
            Expanded(
              child: _DatePicker(
                label: 'To',
                value: toDate,
                onChanged: onToDateChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Date picker widget
class _DatePicker extends StatelessWidget {
  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;

  const _DatePicker({
    required this.label,
    this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showDatePicker(context),
      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      child: Container(
        padding: const EdgeInsets.all(TossSpacing.space3),
        decoration: BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          border: Border.all(
            color: TossColors.border,
            width: TossDimensions.dividerThickness,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TossTextStyles.small.copyWith(
                    color: TossColors.textSecondary,
                    fontWeight: TossFontWeight.semibold,
                  ),
                ),
                const SizedBox(height: TossSpacing.space1 / 2),
                Text(
                  value != null
                      ? DateFormat('MMM d, yyyy').format(value!)
                      : 'Select date',
                  style: TossTextStyles.body.copyWith(
                    color: value != null ? TossColors.gray900 : TossColors.gray400,
                    fontWeight: value != null ? TossFontWeight.medium : TossFontWeight.regular,
                  ),
                ),
              ],
            ),
            const Icon(
              Icons.calendar_today,
              size: TossSpacing.iconXS,
              color: TossColors.gray500,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: value ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: TossColors.primary,
              onPrimary: TossColors.white,
              surface: TossColors.white,
              onSurface: TossColors.gray900,
            ),
          ),
          child: child!,
        );
      },
    );

    if (!context.mounted) return;

    if (picked != null) {
      onChanged(picked);
    }
  }
}
