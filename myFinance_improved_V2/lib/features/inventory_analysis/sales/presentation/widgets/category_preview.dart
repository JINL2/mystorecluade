import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/atoms/display/toss_badge.dart';
import 'package:myfinance_improved/shared/widgets/molecules/cards/toss_card.dart';

import '../../domain/entities/sales_analytics.dart';
import 'drill_down_breadcrumb.dart';

/// Category Preview Widget (Phase 3)
/// Shows top 3 categories with "View All" button
/// Replaces the old DrillDownSection with Expand/Collapse pattern
class CategoryPreview extends StatelessWidget {
  final DrillDownState drillDownState;
  final List<DrillDownItem> items;
  final bool isLoading;
  final VoidCallback onViewAll;
  final void Function(int) onBreadcrumbTap;
  final Metric selectedMetric;

  const CategoryPreview({
    super.key,
    required this.drillDownState,
    required this.items,
    this.isLoading = false,
    required this.onViewAll,
    required this.onBreadcrumbTap,
    this.selectedMetric = Metric.revenue,
  });

  /// Get metric value from item based on selectedMetric
  double _getMetricValue(DrillDownItem item) {
    switch (selectedMetric) {
      case Metric.revenue:
        return item.totalRevenue;
      case Metric.quantity:
        return item.totalQuantity;
      case Metric.margin:
        return item.totalRevenue * item.marginRate / 100; // Approximate margin
    }
  }

  /// Get header title based on selectedMetric
  String get _headerTitle {
    switch (selectedMetric) {
      case Metric.revenue:
        return 'Category Analysis (Revenue)';
      case Metric.quantity:
        return 'Category Analysis (Quantity)';
      case Metric.margin:
        return 'Category Analysis (Margin)';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Sort items by selected metric (descending)
    final sortedItems = List<DrillDownItem>.from(items)
      ..sort((a, b) => _getMetricValue(b).compareTo(_getMetricValue(a)));

    final displayItems = sortedItems.take(3).toList();
    final maxValue = sortedItems.isNotEmpty ? _getMetricValue(sortedItems.first) : 1.0;

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
                    const Icon(
                      Icons.category_outlined,
                      size: 20,
                      color: TossColors.primary,
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
                if (sortedItems.length > 3)
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
                        const SizedBox(width: 2),
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
            const SizedBox(height: TossSpacing.space3),

            // Breadcrumb
            DrillDownBreadcrumb(
              items: drillDownState.breadcrumbs,
              onTap: onBreadcrumbTap,
            ),
            const SizedBox(height: TossSpacing.space4),

            // List
            if (isLoading)
              _buildShimmer()
            else if (items.isEmpty)
              _buildEmptyState()
            else
              Column(
                children: displayItems.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index < displayItems.length - 1
                          ? TossSpacing.space3
                          : 0,
                    ),
                    child: _CategoryListItem(
                      rank: index + 1,
                      item: item,
                      shareRatio: _getMetricValue(item) / maxValue,
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
            height: 72,
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
              Icons.folder_open_outlined,
              size: 48,
              color: TossColors.gray300,
            ),
            const SizedBox(height: TossSpacing.space2),
            Text(
              'No data available',
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

class _CategoryListItem extends StatelessWidget {
  final int rank;
  final DrillDownItem item;
  final double shareRatio;
  final Metric selectedMetric;

  const _CategoryListItem({
    required this.rank,
    required this.item,
    required this.shareRatio,
    required this.selectedMetric,
  });

  /// Get metric value from item based on selectedMetric
  double _getMetricValue() {
    switch (selectedMetric) {
      case Metric.revenue:
        return item.totalRevenue;
      case Metric.quantity:
        return item.totalQuantity;
      case Metric.margin:
        return item.totalRevenue * item.marginRate / 100;
    }
  }

  /// Rank colors: 1=Green, 2=Blue, 3=LightGray, 4+=Primary
  Color get _rankColor {
    switch (rank) {
      case 1:
        return TossColors.success;
      case 2:
        return TossColors.info;
      case 3:
        return TossColors.gray400;
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
              TossBadge.circle(
                text: '$rank',
                backgroundColor: _rankColor,
              ),
              const SizedBox(width: TossSpacing.space3),
              Expanded(
                child: Text(
                  item.name,
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space2),
          // Value + Progress bar
          Row(
            children: [
              Text(
                _formatValue(_getMetricValue()),
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
