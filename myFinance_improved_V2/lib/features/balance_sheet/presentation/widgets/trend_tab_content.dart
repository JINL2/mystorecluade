import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/toss_loading_view.dart';
import '../providers/financial_statements_provider.dart';
import 'trend_tab/trend_tab_widgets.dart';

/// Trend Tab Content - P&L Charts
/// Refactored: 637 lines → ~100 lines
class TrendTabContent extends ConsumerStatefulWidget {
  final String companyId;
  final String? storeId;
  final String currencySymbol;

  const TrendTabContent({
    super.key,
    required this.companyId,
    this.storeId,
    required this.currencySymbol,
  });

  @override
  ConsumerState<TrendTabContent> createState() => _TrendTabContentState();
}

class _TrendTabContentState extends ConsumerState<TrendTabContent> {
  int _selectedPeriodDays = 7; // 7, 30, 90

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final startDate = today.subtract(Duration(days: _selectedPeriodDays - 1));

    final params = TrendParams(
      companyId: widget.companyId,
      startDate: startDate,
      endDate: today,
      storeId: widget.storeId,
    );

    final trendAsync = ref.watch(dailyPnlTrendProvider(params));

    return Column(
      children: [
        // Period Selector
        PeriodSelector(
          selectedPeriodDays: _selectedPeriodDays,
          onPeriodChanged: (days) => setState(() => _selectedPeriodDays = days),
        ),

        // Content
        Expanded(
          child: trendAsync.when(
            data: (data) => RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(dailyPnlTrendProvider(params));
              },
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(TossSpacing.space4),
                      child: Column(
                        children: [
                          // Net Income Chart
                          NetIncomeChart(
                            data: data,
                            currencySymbol: widget.currencySymbol,
                          ),

                          const SizedBox(height: TossSpacing.space4),

                          // Revenue vs Expense Chart
                          RevenueExpenseChart(
                            data: data,
                            currencySymbol: widget.currencySymbol,
                          ),

                          const SizedBox(height: TossSpacing.space4),

                          // Daily Summary List
                          DailySummaryList(
                            data: data,
                            currencySymbol: widget.currencySymbol,
                          ),

                          const SizedBox(height: TossSpacing.space8),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            loading: () => const TossLoadingView(),
            error: (error, _) => _buildError(error.toString()),
          ),
        ),
      ],
    );
  }

  Widget _buildError(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(TossSpacing.space6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
              color: TossColors.gray400,
            ),
            const SizedBox(height: TossSpacing.space4),
            Text(
              'Failed to load trend data',
              style: TossTextStyles.bodyLarge.copyWith(
                color: TossColors.gray600,
              ),
            ),
            const SizedBox(height: TossSpacing.space2),
            Text(
              error,
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
