import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_shadows.dart';
import '../providers/revenue_provider.dart';
import '../models/revenue_models.dart';
import '../../../providers/app_state_provider.dart';

class RevenueCard extends ConsumerWidget {
  const RevenueCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final revenueAsync = ref.watch(revenueProvider);
    final formattedRevenue = ref.watch(formattedRevenueProvider);
    final selectedPeriod = ref.watch(selectedRevenuePeriodProvider);
    final selectedTab = ref.watch(selectedRevenueTabProvider);

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
                
                const SizedBox(height: TossSpacing.space3),
                
                // Company/Store tabs
                _TabSelector(
                  selectedTab: selectedTab,
                  onTabChanged: (tab) {
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
                          selectedTab == RevenueViewTab.company 
                            ? formattedRevenue
                            : _getStoreRevenue(ref),
                          style: TossTextStyles.display.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 36,
                          ),
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
    );
  }

  String _getStoreRevenue(WidgetRef ref) {
    final revenueAsync = ref.watch(revenueProvider);
    final selectedPeriod = ref.watch(selectedRevenuePeriodProvider);
    final appState = ref.watch(appStateProvider);
    final storeId = appState.storeChoosen;
    
    return revenueAsync.maybeWhen(
      data: (revenue) {
        // Get store-specific revenue from the data
        final storeRevenue = ref.watch(storeRevenueProvider(storeId));
        return storeRevenue;
      },
      orElse: () => '₫0',
    );
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
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(2),
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
          color: isSelected ? Colors.white.withOpacity(0.25) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TossTextStyles.bodySmall.copyWith(
            color: Colors.white,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
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