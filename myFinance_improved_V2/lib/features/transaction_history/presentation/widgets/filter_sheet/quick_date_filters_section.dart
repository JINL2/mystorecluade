// lib/features/transaction_history/presentation/widgets/filter_sheet/quick_date_filters_section.dart
//
// Quick date filters section extracted from transaction_filter_sheet.dart
// Following Clean Architecture 2025 - Single Responsibility Principle

import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

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
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        Wrap(
          spacing: TossSpacing.space2,
          runSpacing: TossSpacing.space2,
          children: [
            _QuickFilterChip(
              label: 'Today',
              onTap: () {
                final now = DateTime.now();
                onDateRangeSelected(
                  DateTime(now.year, now.month, now.day),
                  DateTime(now.year, now.month, now.day, 23, 59, 59),
                );
              },
            ),
            _QuickFilterChip(
              label: 'Yesterday',
              onTap: () {
                final yesterday = DateTime.now().subtract(const Duration(days: 1));
                onDateRangeSelected(
                  DateTime(yesterday.year, yesterday.month, yesterday.day),
                  DateTime(yesterday.year, yesterday.month, yesterday.day, 23, 59, 59),
                );
              },
            ),
            _QuickFilterChip(
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
            _QuickFilterChip(
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

/// Quick filter chip
class _QuickFilterChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _QuickFilterChip({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(TossBorderRadius.sm),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space3,
          vertical: TossSpacing.space2,
        ),
        decoration: BoxDecoration(
          color: TossColors.gray50,
          borderRadius: BorderRadius.circular(TossBorderRadius.sm),
          border: Border.all(
            color: TossColors.gray200,
          ),
        ),
        child: Text(
          label,
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray700,
          ),
        ),
      ),
    );
  }
}
