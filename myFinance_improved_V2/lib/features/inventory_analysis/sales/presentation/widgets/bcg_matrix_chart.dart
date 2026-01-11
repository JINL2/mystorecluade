import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/molecules/cards/toss_card.dart';

import '../../domain/entities/bcg_category.dart';
import '../../domain/entities/sales_analytics.dart';
import 'bcg_matrix/index.dart';

/// BCG Matrix Chart Widget for Sales Analytics V2 Page
/// Features: Loading/Empty states, Full-screen dialog, Mean/Median toggle, Revenue/Qty toggle
class BcgMatrixChart extends StatefulWidget {
  final BcgMatrix? bcgMatrix;
  final bool isLoading;
  final String currencySymbol;
  final Metric selectedMetric;

  const BcgMatrixChart({
    super.key,
    this.bcgMatrix,
    this.isLoading = false,
    this.currencySymbol = '₫',
    this.selectedMetric = Metric.revenue,
  });

  @override
  State<BcgMatrixChart> createState() => _BcgMatrixChartState();
}

class _BcgMatrixChartState extends State<BcgMatrixChart> {
  bool _useMean = false;
  bool? _useRevenueOverride; // null = follow selectedMetric, non-null = user override

  /// Compute X-axis mode based on selectedMetric and user override
  bool get _useRevenue {
    if (_useRevenueOverride != null) {
      return _useRevenueOverride!;
    }
    // Follow global metric: quantity -> quantity, otherwise revenue
    return widget.selectedMetric != Metric.quantity;
  }

  @override
  void didUpdateWidget(BcgMatrixChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset user override when global metric changes
    if (oldWidget.selectedMetric != widget.selectedMetric) {
      _useRevenueOverride = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.isLoading)
            _buildShimmer()
          else if (widget.bcgMatrix == null || widget.bcgMatrix!.categories.isEmpty)
            _buildEmptyState()
          else
            _buildBcgMatrix(widget.bcgMatrix!),
        ],
      ),
    );
  }

  Widget _buildBcgMatrix(BcgMatrix bcgMatrix) {
    final chartData = BcgChartData.calculate(
      bcgMatrix,
      useMean: _useMean,
      xAxisMode: _useRevenue ? BcgXAxisMode.revenue : BcgXAxisMode.quantity,
    );

    return Column(
      children: [
        TossCard(
          padding: const EdgeInsets.all(TossSpacing.space4),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        'BCG Matrix',
                        style: TossTextStyles.h4.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            BcgXAxisToggle(
                              useRevenue: _useRevenue,
                              onChanged: (value) => setState(() => _useRevenueOverride = value),
                            ),
                            const SizedBox(width: TossSpacing.space2),
                            BcgMeanMedianToggle(
                              useMean: _useMean,
                              onChanged: (value) => setState(() => _useMean = value),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: TossSpacing.space4),

                // Chart
                BcgScatterChart(
                  chartData: chartData,
                  height: 300,
                  currencySymbol: widget.currencySymbol,
                ),
              ],
            ),
        ),
        const SizedBox(height: TossSpacing.space3),

        // Legend
        BcgLegend(
          bcgMatrix: bcgMatrix,
          counts: chartData.quadrantCounts,
        ),
      ],
    );
  }

  Widget _buildShimmer() {
    return TossCard(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Container(
        height: 300,
        decoration: BoxDecoration(
          color: TossColors.gray100,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return TossCard(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: SizedBox(
        height: 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.grid_view_outlined,
                size: 48,
                color: TossColors.gray300,
              ),
              const SizedBox(height: TossSpacing.space2),
              Text(
                'No BCG data available',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
