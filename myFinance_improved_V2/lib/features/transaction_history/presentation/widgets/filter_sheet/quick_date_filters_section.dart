// lib/features/transaction_history/presentation/widgets/filter_sheet/quick_date_filters_section.dart
//
// Quick date filters section extracted from transaction_filter_sheet.dart
// Following Clean Architecture 2025 - Single Responsibility Principle

import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_font_weight.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/index.dart';

/// Date range callback
typedef DateRangeCallback = void Function(DateTime from, DateTime to);

/// Quick date filters section
class QuickDateFiltersSection extends StatelessWidget {
  final DateRangeCallback onDateRangeSelected;

  const QuickDateFiltersSection({
    super.key,
    required this.onDateRangeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Filters',
          style: TossTextStyles.label.copyWith(
            color: TossColors.textSecondary,
            fontWeight: TossFontWeight.semibold,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        Wrap(
          spacing: TossSpacing.space2,
          runSpacing: TossSpacing.space2,
          children: [
            TossChip(
              label: 'Today',
              onTap: () {
                final now = DateTime.now();
                onDateRangeSelected(
                  DateTime(now.year, now.month, now.day),
                  DateTime(now.year, now.month, now.day, 23, 59, 59),
                );
              },
            ),
            TossChip(
              label: 'Yesterday',
              onTap: () {
                final yesterday = DateTime.now().subtract(const Duration(days: 1));
                onDateRangeSelected(
                  DateTime(yesterday.year, yesterday.month, yesterday.day),
                  DateTime(yesterday.year, yesterday.month, yesterday.day, 23, 59, 59),
                );
              },
            ),
            TossChip(
              label: 'This Week',
              onTap: () {
                final now = DateTime.now();
                final weekStart = now.subtract(Duration(days: now.weekday - 1));
                onDateRangeSelected(
                  DateTime(weekStart.year, weekStart.month, weekStart.day),
                  DateTime(now.year, now.month, now.day, 23, 59, 59),
                );
              },
            ),
            TossChip(
              label: 'This Month',
              onTap: () {
                final now = DateTime.now();
                onDateRangeSelected(
                  DateTime(now.year, now.month, 1),
                  DateTime(now.year, now.month + 1, 0, 23, 59, 59),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
