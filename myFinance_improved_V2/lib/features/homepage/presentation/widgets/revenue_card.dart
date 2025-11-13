import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

import '../../domain/revenue_period.dart';
import '../providers/homepage_providers.dart';

class RevenueCard extends ConsumerWidget {
  const RevenueCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch selected period and tab
    final selectedPeriod = ref.watch(selectedRevenuePeriodProvider);
    final selectedTab = ref.watch(selectedRevenueTabProvider);

    // Watch revenue data with selected period
    final revenueAsync = ref.watch(revenueProvider(selectedPeriod));

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      padding: const EdgeInsets.all(TossSpacing.space5),
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Company/Store tabs on right
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Title with period dropdown
              PopupMenuButton<RevenuePeriod>(
                initialValue: selectedPeriod,
                onSelected: (period) {
                  ref.read(selectedRevenuePeriodProvider.notifier).state = period;
                },
                offset: const Offset(0, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                ),
                color: TossColors.surface,
                elevation: 8,
                itemBuilder: (context) => RevenuePeriod.values.map((period) {
                  return PopupMenuItem(
                    value: period,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          period.displayName,
                          style: TossTextStyles.body.copyWith(
                            color: period == selectedPeriod
                                ? TossColors.primary
                                : TossColors.textPrimary,
                            fontWeight: period == selectedPeriod
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                        if (period == selectedPeriod)
                          const Icon(
                            Icons.check,
                            color: TossColors.primary,
                            size: 18,
                          ),
                      ],
                    ),
                  );
                }).toList(),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Revenue ${selectedPeriod.displayName}',
                      style: TossTextStyles.h3.copyWith(
                        fontSize: 20,
                        color: TossColors.textPrimary,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(width: TossSpacing.space1),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: TossColors.textSecondary,
                      size: 20,
                    ),
                  ],
                ),
              ),

              // Company/Store tabs on right
              _TabSelector(
                selectedTab: selectedTab,
                onTabChanged: (RevenueViewTab tab) {
                  ref.read(selectedRevenueTabProvider.notifier).state = tab;
                },
              ),
            ],
          ),

          const SizedBox(height: TossSpacing.space4),

          // Revenue amount based on selected tab
          revenueAsync.when(
            data: (revenue) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Amount
                Text(
                  '${revenue.currencyCode}${_formatAmount(revenue.amount)}',
                  style: TossTextStyles.display.copyWith(
                    color: TossColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    height: 1.2,
                    letterSpacing: -1.0,
                  ),
                ),

                const SizedBox(height: TossSpacing.space2),

                // Growth indicator
                if (revenue.previousAmount != 0) ...[
                  Row(
                    children: [
                      Icon(
                        revenue.isIncreased ? Icons.trending_up : Icons.trending_down,
                        color: revenue.isIncreased ? TossColors.error : TossColors.success,
                        size: 16,
                      ),
                      const SizedBox(width: TossSpacing.space1),
                      Text(
                        '${revenue.isIncreased ? '' : '-'}${revenue.growthPercentage.abs().toStringAsFixed(1)}% vs ${revenue.period.comparisonText}',
                        style: TossTextStyles.body.copyWith(
                          color: revenue.isIncreased ? TossColors.error : TossColors.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: TossSpacing.space3),
                ],
              ],
            ),
            loading: () => const _LoadingRevenue(),
            error: (error, _) => _ErrorRevenue(error: error.toString()),
          ),
        ],
      ),
    );
  }

  String _formatAmount(double amount) {
    // Format with thousands separator
    final intAmount = amount.toInt();
    return intAmount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}


class _LoadingRevenue extends StatelessWidget {
  const _LoadingRevenue();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 200,
          height: 36,
          decoration: BoxDecoration(
            color: TossColors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        Container(
          width: 150,
          height: 20,
          decoration: BoxDecoration(
            color: TossColors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(TossBorderRadius.xs),
          ),
        ),
      ],
    );
  }
}

class _TabSelector extends StatelessWidget {
  final RevenueViewTab selectedTab;
  final ValueChanged<RevenueViewTab> onTabChanged;

  const _TabSelector({
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(TossSpacing.space5, 0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTab(
            'Company',
            RevenueViewTab.company,
            selectedTab == RevenueViewTab.company,
          ),
          _buildTab(
            'Store',
            RevenueViewTab.store,
            selectedTab == RevenueViewTab.store,
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String label, RevenueViewTab tab, bool isSelected) {
    return GestureDetector(
      onTap: () => onTabChanged(tab),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: isSelected ? TossColors.primary : TossColors.transparent,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          label,
          style: TossTextStyles.caption.copyWith(
            fontSize: 12,
            color: isSelected ? TossColors.white : TossColors.textTertiary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _ErrorRevenue extends StatelessWidget {
  final String error;

  const _ErrorRevenue({required this.error});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.error.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: TossColors.white,
            size: 20,
          ),
          const SizedBox(width: TossSpacing.space2),
          Expanded(
            child: Text(
              'Unable to load revenue data',
              style: TossTextStyles.body.copyWith(
                color: TossColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
