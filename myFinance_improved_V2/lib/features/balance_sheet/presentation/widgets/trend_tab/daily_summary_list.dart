import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/entities/daily_pnl.dart';

/// Daily summary list widget for trend tab
class DailySummaryList extends StatelessWidget {
  final List<DailyPnl> data;
  final String currencySymbol;

  const DailySummaryList({
    super.key,
    required this.data,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,##0', 'en_US');
    final reversed = data.reversed.toList();

    return Container(
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        boxShadow: [
          BoxShadow(
            color: TossColors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(TossSpacing.space4),
            child: Text(
              'Daily Summary',
              style: TossTextStyles.bodyMediumBold,
            ),
          ),
          Container(height: 1, color: TossColors.gray100),
          ...reversed.take(10).map((item) {
            final isProfit = item.netIncome >= 0;
            final isToday = _isToday(item.date);

            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space4,
                vertical: TossSpacing.space3,
              ),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: TossColors.gray100),
                ),
              ),
              child: Row(
                children: [
                  // Date
                  SizedBox(
                    width: 80,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('MMM d').format(item.date),
                          style: isToday
                              ? TossTextStyles.bodySmallBold
                              : TossTextStyles.bodySmall,
                        ),
                        if (isToday)
                          Text(
                            'Today',
                            style: TossTextStyles.captionPrimary,
                          ),
                      ],
                    ),
                  ),

                  // Revenue
                  Expanded(
                    child: Text(
                      '$currencySymbol${formatter.format(item.revenue)}',
                      style: TossTextStyles.bodySmallGray600,
                      textAlign: TextAlign.right,
                    ),
                  ),

                  const SizedBox(width: TossSpacing.space2),

                  // Arrow
                  const Icon(
                    Icons.arrow_forward,
                    size: 12,
                    color: TossColors.gray400,
                  ),

                  const SizedBox(width: TossSpacing.space2),

                  // Net Income
                  SizedBox(
                    width: 100,
                    child: Text(
                      '${isProfit ? '' : '-'}$currencySymbol${formatter.format(item.netIncome.abs())}',
                      style: TossTextStyles.bodySmallBold.copyWith(
                        color: isProfit ? TossColors.gray900 : TossColors.error,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}
