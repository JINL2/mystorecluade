import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../trade_shared/presentation/providers/trade_shared_providers.dart';

/// Dashboard header with date range selector
class DashboardHeader extends ConsumerWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateRange = ref.watch(dateRangeProvider);

    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.white,
        border: Border(
          bottom: BorderSide(
            color: TossColors.gray100,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Welcome text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trade Overview',
                  style: TossTextStyles.h3.copyWith(
                    fontWeight: FontWeight.w700,
                    color: TossColors.gray900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _getSubtitle(dateRange),
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray500,
                  ),
                ),
              ],
            ),
          ),

          // Date range chip
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: TossSpacing.space3,
              vertical: TossSpacing.space2,
            ),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.full),
              border: Border.all(
                color: TossColors.gray200,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 14,
                  color: TossColors.gray600,
                ),
                const SizedBox(width: 6),
                Text(
                  dateRange.label,
                  style: TossTextStyles.caption.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TossColors.gray700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getSubtitle(DateRangeState dateRange) {
    if (dateRange.dateFrom != null && dateRange.dateTo != null) {
      return '${_formatDate(dateRange.dateFrom!)} - ${_formatDate(dateRange.dateTo!)}';
    }
    return 'All transactions and activities';
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
