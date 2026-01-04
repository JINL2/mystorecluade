import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

import '../providers/cash_location_providers.dart';

/// Cash account card widget showing location details
/// Displays account name, percentage, balance, and errors
class CashAccountCard extends StatelessWidget {
  final CashLocation location;
  final double totalAmount;
  final String locationType;
  final VoidCallback onRefresh;
  final IconData icon;
  final String Function(double, String) formatCurrency;

  const CashAccountCard({
    super.key,
    required this.location,
    required this.totalAmount,
    required this.locationType,
    required this.onRefresh,
    required this.icon,
    required this.formatCurrency,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate percentage
    final percentage = totalAmount > 0
        ? ((location.totalJournalCashAmount / totalAmount) * 100).round()
        : 0;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        // Refresh data before navigating
        onRefresh();

        await context.push(
          '/cashLocation/account/${Uri.encodeComponent(location.locationName)}',
          extra: {
            'locationId': location.locationId,
            'locationType': locationType,
            'accountName': location.locationName,
            'totalJournal': location.totalJournalCashAmount.round(),
            'totalReal': location.totalRealCashAmount.round(),
            'cashDifference': location.cashDifference.round(),
            'currencySymbol': location.currencySymbol,
            // Legacy fields for compatibility (can be removed later)
            'balance': location.totalJournalCashAmount.round(),
            'errors': location.cashDifference.abs().round(),
          },
        );

        // Refresh data when returning from detail page
        onRefresh();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: TossSpacing.space4,
        ),
        child: Row(
          children: [
            // Logo icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Icon(
                icon,
                color: TossColors.primary,
                size: 22,
              ),
            ),

            const SizedBox(width: TossSpacing.space3),

            // Account details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    location.locationName,
                    style: TossTextStyles.bodyMedium.copyWith(
                      color: TossColors.gray900,
                    ),
                  ),
                  const SizedBox(height: TossSpacing.space1),
                  Text(
                    '$percentage% of total balance',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray600,
                    ),
                  ),
                ],
              ),
            ),

            // Total Journal and Error with arrow
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      formatCurrency(location.totalJournalCashAmount, location.currencySymbol),
                      style: TossTextStyles.bodyMedium.copyWith(
                        color: TossColors.primary,
                      ),
                    ),
                    const SizedBox(height: TossSpacing.space1),
                    Text(
                      formatCurrency(location.cashDifference.abs(), ''),
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.error,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: TossSpacing.space2),
                const Icon(
                  Icons.chevron_right,
                  color: TossColors.gray400,
                  size: 22,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
