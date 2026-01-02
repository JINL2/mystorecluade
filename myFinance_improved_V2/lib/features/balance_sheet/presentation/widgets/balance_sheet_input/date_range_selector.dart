import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/shared/widgets/index.dart' hide DateRange;

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/value_objects/date_range.dart';
import '../../providers/balance_sheet_providers.dart';

/// Date range selector widget
class DateRangeSelector extends ConsumerWidget {
  final DateRange dateRange;

  const DateRangeSelector({
    super.key,
    required this.dateRange,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startDate = dateRange.startDateFormatted;
    final endDate = dateRange.endDateFormatted;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Period',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray500,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        InkWell(
          onTap: () {
            _showDateRangePicker(context, ref, dateRange);
          },
          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
          child: Container(
            padding: const EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: TossColors.background,
              borderRadius: BorderRadius.circular(TossBorderRadius.xl),
              border: Border.all(
                color: TossColors.primary.withValues(alpha: 0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: TossColors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Calendar Icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: TossColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  ),
                  child: const Icon(
                    Icons.calendar_today_outlined,
                    color: TossColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: TossSpacing.space3),

                // Date Range
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date Range',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$startDate ~ $endDate',
                        style: TossTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrow
                const Icon(
                  Icons.chevron_right,
                  color: TossColors.gray400,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Show date range picker bottom sheet
  void _showDateRangePicker(
    BuildContext context,
    WidgetRef ref,
    DateRange currentDateRange,
  ) {
    DateTime tempStartDate = currentDateRange.startDate;
    DateTime tempEndDate = currentDateRange.endDate;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: TossColors.background,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(TossBorderRadius.xl),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Handle bar
                    Container(
                      margin: const EdgeInsets.only(top: TossSpacing.space3),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: TossColors.gray300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),

                    // Title
                    Padding(
                      padding: const EdgeInsets.all(TossSpacing.space4),
                      child: Text(
                        'Select Period',
                        style: TossTextStyles.h4.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const Divider(height: 1, color: TossColors.gray200),

                    // Date Selection Cards
                    Padding(
                      padding: const EdgeInsets.all(TossSpacing.space4),
                      child: Column(
                        children: [
                          // Start Date
                          _DatePickerCard(
                            label: 'Start Date',
                            date: tempStartDate,
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: tempStartDate,
                                firstDate: DateTime(2020),
                                lastDate: DateTime.now(),
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: const ColorScheme.light(
                                        primary: TossColors.primary,
                                        onPrimary: TossColors.white,
                                        surface: TossColors.background,
                                        onSurface: TossColors.gray900,
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (picked != null) {
                                setState(() {
                                  tempStartDate = picked;
                                  if (tempEndDate.isBefore(tempStartDate)) {
                                    tempEndDate = tempStartDate;
                                  }
                                });
                              }
                            },
                          ),

                          const SizedBox(height: TossSpacing.space3),

                          // End Date
                          _DatePickerCard(
                            label: 'End Date',
                            date: tempEndDate,
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: tempEndDate,
                                firstDate: tempStartDate,
                                lastDate: DateTime.now(),
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: const ColorScheme.light(
                                        primary: TossColors.primary,
                                        onPrimary: TossColors.white,
                                        surface: TossColors.background,
                                        onSurface: TossColors.gray900,
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (picked != null) {
                                setState(() {
                                  tempEndDate = picked;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),

                    // Quick Selection Buttons
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
                      child: Row(
                        children: [
                          Expanded(
                            child: _QuickSelectButton(
                              label: 'This Month',
                              onTap: () {
                                final now = DateTime.now();
                                setState(() {
                                  tempStartDate = DateTime(now.year, now.month, 1);
                                  tempEndDate = DateTime(now.year, now.month + 1, 0);
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: TossSpacing.space2),
                          Expanded(
                            child: _QuickSelectButton(
                              label: 'Last Month',
                              onTap: () {
                                final now = DateTime.now();
                                setState(() {
                                  tempStartDate = DateTime(now.year, now.month - 1, 1);
                                  tempEndDate = DateTime(now.year, now.month, 0);
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: TossSpacing.space2),
                          Expanded(
                            child: _QuickSelectButton(
                              label: 'This Year',
                              onTap: () {
                                final now = DateTime.now();
                                setState(() {
                                  tempStartDate = DateTime(now.year, 1, 1);
                                  tempEndDate = now;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: TossSpacing.space4),

                    // Apply Button
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
                      child: TossButton.primary(
                        text: 'Apply',
                        onPressed: () {
                          final newDateRange = DateRange(
                            startDate: tempStartDate,
                            endDate: tempEndDate,
                          );
                          ref
                              .read(balanceSheetPageNotifierProvider.notifier)
                              .changeDateRange(newDateRange);
                          Navigator.pop(context);
                        },
                        fullWidth: true,
                      ),
                    ),

                    const SizedBox(height: TossSpacing.space4),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

/// Date picker card widget
class _DatePickerCard extends StatelessWidget {
  final String label;
  final DateTime date;
  final VoidCallback onTap;

  const _DatePickerCard({
    required this.label,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      child: Container(
        padding: const EdgeInsets.all(TossSpacing.space3),
        decoration: BoxDecoration(
          color: TossColors.gray50,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          border: Border.all(color: TossColors.gray200),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: TossColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: const Icon(
                Icons.calendar_today_outlined,
                color: TossColors.primary,
                size: 18,
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    formattedDate,
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: TossColors.gray400,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

/// Quick select button widget
class _QuickSelectButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _QuickSelectButton({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TossButton.outlinedGray(
      text: label,
      onPressed: onTap,
    );
  }
}
