import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_shadows.dart';
import '../../../../core/themes/toss_animations.dart';
import '../providers/revenue_provider.dart';
import '../models/revenue_models.dart';

class RevenueCard extends ConsumerWidget {
  const RevenueCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final revenueAsync = ref.watch(revenueProvider);
    final formattedRevenue = ref.watch(formattedRevenueProvider);
    final growthPercentage = ref.watch(formattedGrowthProvider);
    final comparisonText = ref.watch(revenueComparisonTextProvider);
    final selectedPeriod = ref.watch(selectedRevenuePeriodProvider);

    return Container(
      margin: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            TossColors.primary,
            TossColors.primary.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: TossShadows.elevation3,
      ),
      child: Stack(
        children: [
          // Background pattern
          Positioned(
            right: -50,
            top: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            left: -30,
            bottom: -30,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          
          // Content
          Padding(
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
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    _PeriodSelector(
                      selectedPeriod: selectedPeriod,
                      onPeriodChanged: (period) {
                        ref.read(selectedRevenuePeriodProvider.notifier).state = period;
                      },
                    ),
                  ],
                ),
                
                const SizedBox(height: TossSpacing.space4),
                
                // Revenue amount
                revenueAsync.when(
                  data: (revenue) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formattedRevenue,
                          style: TossTextStyles.display.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 36,
                          ),
                        ),
                        const SizedBox(height: TossSpacing.space2),
                        
                        // Growth indicator
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: TossSpacing.space2,
                                vertical: TossSpacing.space1,
                              ),
                              decoration: BoxDecoration(
                                color: _getGrowthColor(ref.read(revenueGrowthProvider)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    ref.read(revenueGrowthProvider) >= 0
                                        ? Icons.trending_up
                                        : Icons.trending_down,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    growthPercentage,
                                    style: TossTextStyles.body.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: TossSpacing.space2),
                            Expanded(
                              child: Text(
                                comparisonText,
                                style: TossTextStyles.bodySmall.copyWith(
                                  color: Colors.white.withOpacity(0.9),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: TossSpacing.space4),
                        
                        // Quick stats
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _QuickStat(
                              label: 'Transactions',
                              value: '${125 + revenue.amount.toInt() % 50}',
                              icon: Icons.receipt_long,
                            ),
                            _QuickStat(
                              label: 'Avg. Order',
                              value: '\$${(revenue.amount / (125 + revenue.amount.toInt() % 50)).toStringAsFixed(2)}',
                              icon: Icons.shopping_cart,
                            ),
                            _QuickStat(
                              label: 'Peak Hour',
                              value: '2-3 PM',
                              icon: Icons.access_time,
                            ),
                          ],
                        ),
                      ],
                    ),
                  loading: () => const _LoadingRevenue(),
                  error: (error, _) => _ErrorRevenue(error: error.toString()),
                ),
                
                // Last updated
                if (revenueAsync.hasValue)
                  Padding(
                    padding: const EdgeInsets.only(top: TossSpacing.space2),
                    child: Text(
                      'Last updated: ${_formatLastUpdated(revenueAsync.value?.lastUpdated)}',
                      style: TossTextStyles.caption.copyWith(
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getGrowthColor(double growth) {
    if (growth > 0) return Colors.green.shade600;
    if (growth < 0) return Colors.red.shade600;
    return Colors.grey.shade600;
  }

  String _formatLastUpdated(DateTime? lastUpdated) {
    if (lastUpdated == null) return 'Just now';
    
    final difference = DateTime.now().difference(lastUpdated);
    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    return '${difference.inDays}d ago';
  }
}

class _PeriodSelector extends StatelessWidget {
  final RevenuePeriod selectedPeriod;
  final ValueChanged<RevenuePeriod> onPeriodChanged;

  const _PeriodSelector({
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: PopupMenuButton<RevenuePeriod>(
        initialValue: selectedPeriod,
        onSelected: onPeriodChanged,
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
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.arrow_drop_down,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _QuickStat({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space2),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white.withOpacity(0.9),
            size: 20,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TossTextStyles.body.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TossTextStyles.caption.copyWith(
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
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
          width: 150,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        Container(
          width: 200,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}

class _ErrorRevenue extends StatelessWidget {
  final String error;

  const _ErrorRevenue({required this.error});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: TossSpacing.space2),
          Expanded(
            child: Text(
              'Unable to load revenue data',
              style: TossTextStyles.body.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}