import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/atoms/display/toss_badge.dart';
import 'package:myfinance_improved/shared/widgets/molecules/cards/toss_card.dart';

import '../../domain/entities/sales_analytics.dart';

/// Top Products Preview Widget (Phase 2)
/// Shows top 3 products with "View All" button
/// Replaces the old TopProductsList with Expand/Collapse pattern
class TopProductsPreview extends StatelessWidget {
  final List<AnalyticsDataPoint> products;
  final bool isLoading;
  final VoidCallback onViewAll;
  final Metric selectedMetric;

  const TopProductsPreview({
    super.key,
    required this.products,
    this.isLoading = false,
    required this.onViewAll,
    this.selectedMetric = Metric.revenue,
  });

  /// Get metric value from product based on selectedMetric
  double _getMetricValue(AnalyticsDataPoint product) {
    switch (selectedMetric) {
      case Metric.revenue:
        return product.totalRevenue;
      case Metric.quantity:
        return product.totalQuantity;
      case Metric.margin:
        return product.totalMargin;
    }
  }

  /// Get growth value based on selectedMetric
  double? _getGrowthValue(AnalyticsDataPoint product) {
    switch (selectedMetric) {
      case Metric.revenue:
        return product.revenueGrowth;
      case Metric.quantity:
        return product.quantityGrowth;
      case Metric.margin:
        return product.marginGrowth;
    }
  }

  /// Get header title based on selectedMetric
  String get _headerTitle {
    switch (selectedMetric) {
      case Metric.revenue:
        return 'Top Products (Revenue)';
      case Metric.quantity:
        return 'Top Products (Quantity)';
      case Metric.margin:
        return 'Top Products (Margin)';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Sort products by selected metric, filter out items with empty names
    final sortedProducts = List<AnalyticsDataPoint>.from(products)
      ..removeWhere((p) => p.dimensionName.isEmpty)
      ..sort((a, b) => _getMetricValue(b).compareTo(_getMetricValue(a)));

    final displayProducts = sortedProducts.take(3).toList();
    final maxValue = sortedProducts.isNotEmpty ? _getMetricValue(sortedProducts.first) : 1.0;

    // Debug: Log top 3 products
    for (var i = 0; i < displayProducts.length; i++) {
      final p = displayProducts[i];
      // ignore: avoid_print
      print('🏆 TopProducts[$i]: id=${p.dimensionId}, name="${p.dimensionName}", revenue=${p.totalRevenue}');
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: TossCard(
        padding: const EdgeInsets.all(TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.emoji_events,
                      size: 20,
                      color: TossRankBadge.gold,
                    ),
                    const SizedBox(width: TossSpacing.space2),
                    Text(
                      _headerTitle,
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                // View All Button
                if (sortedProducts.length > 3)
                  GestureDetector(
                    onTap: onViewAll,
                    child: Row(
                      children: [
                        Text(
                          'View All',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: TossSpacing.space0_5),
                        const Icon(
                          Icons.chevron_right,
                          size: 16,
                          color: TossColors.primary,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: TossSpacing.space4),

            // List
            if (isLoading)
              _buildShimmer()
            else if (sortedProducts.isEmpty)
              _buildEmptyState()
            else
              Column(
                children: displayProducts.asMap().entries.map((entry) {
                  final index = entry.key;
                  final product = entry.value;
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index < displayProducts.length - 1
                          ? TossSpacing.space3
                          : 0,
                    ),
                    child: _TopProductItem(
                      rank: index + 1,
                      name: product.dimensionName,
                      value: _getMetricValue(product),
                      growth: _getGrowthValue(product),
                      shareRatio: _getMetricValue(product) / maxValue,
                      selectedMetric: selectedMetric,
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return Column(
      children: List.generate(
        3,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: TossSpacing.space3),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: TossColors.gray100,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(TossSpacing.space6),
        child: Column(
          children: [
            const Icon(
              Icons.inventory_2_outlined,
              size: 48,
              color: TossColors.gray300,
            ),
            const SizedBox(height: TossSpacing.space2),
            Text(
              'No products found',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopProductItem extends StatelessWidget {
  final int rank;
  final String name;
  final double value;
  final double? growth;
  final double shareRatio;
  final Metric selectedMetric;

  const _TopProductItem({
    required this.rank,
    required this.name,
    required this.value,
    this.growth,
    required this.shareRatio,
    required this.selectedMetric,
  });

  Color get _rankColor {
    switch (rank) {
      case 1:
        return TossRankBadge.gold;
      case 2:
        return TossRankBadge.silver;
      case 3:
        return TossRankBadge.bronze;
      default:
        return TossColors.primary;
    }
  }

  Color get _rankBgColor {
    switch (rank) {
      case 1:
      case 2:
      case 3:
        return TossColors.primarySurface;
      default:
        return TossColors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: _rankBgColor,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.gray100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              // Rank badge
              TossRankBadge(rank: rank, size: 24),
              const SizedBox(width: TossSpacing.space3),
              // Product name
              Expanded(
                child: Text(
                  name,
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Growth indicator
              if (growth != null) TossGrowthBadge(growthValue: growth!),
            ],
          ),
          const SizedBox(height: TossSpacing.space2),
          // Value + Progress bar
          Row(
            children: [
              Text(
                _formatValue(value),
                style: TossTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: TossColors.gray900,
                ),
              ),
              const SizedBox(width: TossSpacing.space3),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                  child: LinearProgressIndicator(
                    value: shareRatio.clamp(0.0, 1.0),
                    backgroundColor: TossColors.gray100,
                    valueColor: AlwaysStoppedAnimation(_rankColor),
                    minHeight: 6,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatValue(double value) {
    switch (selectedMetric) {
      case Metric.revenue:
      case Metric.margin:
        // Currency format
        if (value.abs() >= 1000000000) {
          return '\$${(value / 1000000000).toStringAsFixed(1)}B';
        } else if (value.abs() >= 1000000) {
          return '\$${(value / 1000000).toStringAsFixed(1)}M';
        } else if (value.abs() >= 1000) {
          return '\$${(value / 1000).toStringAsFixed(1)}K';
        }
        return '\$${value.toStringAsFixed(0)}';
      case Metric.quantity:
        // Quantity format (no currency symbol)
        if (value.abs() >= 1000000) {
          return '${(value / 1000000).toStringAsFixed(1)}M pcs';
        } else if (value.abs() >= 1000) {
          return '${(value / 1000).toStringAsFixed(1)}K pcs';
        }
        return '${value.toInt()} pcs';
    }
  }
}
