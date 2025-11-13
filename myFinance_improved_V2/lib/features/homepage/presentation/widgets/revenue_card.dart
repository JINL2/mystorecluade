import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

import '../../../../shared/themes/toss_shadows.dart';
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
      margin: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            TossColors.primary,
            TossColors.primary.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(TossBorderRadius.xxxl),
        boxShadow: TossShadows.elevation3,
      ),
      child: Padding(
        padding: const EdgeInsets.all(TossSpacing.space6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with period selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Revenue',
                  style: TossTextStyles.h3.copyWith(
                    color: TossColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                _PeriodSelector(),
              ],
            ),

            const SizedBox(height: TossSpacing.space3),

            // Company/Store tabs
            _TabSelector(
              selectedTab: selectedTab,
              onTabChanged: (RevenueViewTab tab) {
                ref.read(selectedRevenueTabProvider.notifier).state = tab;
              },
            ),

            const SizedBox(height: TossSpacing.space4),

            // Revenue amount based on selected tab
            revenueAsync.when(
              data: (revenue) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${revenue.currencyCode}${_formatAmount(revenue.amount)}',
                    style: TossTextStyles.display.copyWith(
                      color: TossColors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 36,
                    ),
                  ),

                  const SizedBox(height: TossSpacing.space2),

                  // Growth indicator
                  if (revenue.previousAmount != 0) ...[
                    Row(
                      children: [
                        Icon(
                          revenue.isIncreased ? Icons.trending_up : Icons.trending_down,
                          color: revenue.isIncreased
                              ? TossColors.white.withValues(alpha: 0.9)
                              : TossColors.white.withValues(alpha: 0.7),
                          size: 16,
                        ),
                        const SizedBox(width: TossSpacing.space1),
                        Text(
                          '${revenue.growthPercentage.toStringAsFixed(1)}% vs ${revenue.period.comparisonText}',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.white.withValues(alpha: 0.8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: TossSpacing.space2),

                  // Last updated
                  Text(
                    'Last updated: ${_formatLastUpdated(revenue.lastUpdated)}',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.white.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
              loading: () => const _LoadingRevenue(),
              error: (error, _) => _ErrorRevenue(error: error.toString()),
            ),
          ],
        ),
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

  String _formatLastUpdated(DateTime lastUpdated) {
    final difference = DateTime.now().difference(lastUpdated);
    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    return '${difference.inDays}d ago';
  }
}

class _PeriodSelector extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPeriod = ref.watch(selectedRevenuePeriodProvider);

    return Container(
      decoration: BoxDecoration(
        color: TossColors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      child: PopupMenuButton<RevenuePeriod>(
        initialValue: selectedPeriod,
        onSelected: (period) {
          ref.read(selectedRevenuePeriodProvider.notifier).state = period;
        },
        itemBuilder: (context) => RevenuePeriod.values.map((period) {
          return PopupMenuItem(
            value: period,
            child: Text(period.displayName),
          );
        }).toList(),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: TossSpacing.space2,
            vertical: TossSpacing.space1,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                selectedPeriod.displayName,
                style: TossTextStyles.body.copyWith(
                  color: TossColors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.arrow_drop_down,
                color: TossColors.white,
                size: 20,
              ),
            ],
          ),
        ),
      ),
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
    return Container(
      decoration: BoxDecoration(
        color: TossColors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      padding: const EdgeInsets.all(TossSpacing.space1 / 2),
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
          horizontal: TossSpacing.space3,
          vertical: TossSpacing.space1,
        ),
        decoration: BoxDecoration(
          color: isSelected ? TossColors.white.withValues(alpha: 0.25) : TossColors.transparent,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
        ),
        child: Text(
          label,
          style: TossTextStyles.bodySmall.copyWith(
            color: TossColors.white,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
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
