import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/atoms/display/toss_badge.dart';
import 'package:myfinance_improved/shared/widgets/molecules/cards/toss_card.dart';

import '../../domain/entities/sales_analytics.dart';

/// Top Products List Widget
/// Expandable list showing top 10 products
class TopProductsList extends StatefulWidget {
  final List<AnalyticsDataPoint> products;
  final bool isLoading;
  final int initialShowCount;

  const TopProductsList({
    super.key,
    required this.products,
    this.isLoading = false,
    this.initialShowCount = 5,
  });

  @override
  State<TopProductsList> createState() => _TopProductsListState();
}

class _TopProductsListState extends State<TopProductsList> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final displayProducts = _isExpanded
        ? widget.products
        : widget.products.take(widget.initialShowCount).toList();

    final maxRevenue = widget.products.isNotEmpty
        ? widget.products.first.totalRevenue
        : 1.0;

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
                    'Top ${widget.products.length} Products',
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              if (widget.products.length > widget.initialShowCount)
                GestureDetector(
                  onTap: () => setState(() => _isExpanded = !_isExpanded),
                  child: Row(
                    children: [
                      Text(
                        _isExpanded ? 'Collapse' : 'Expand',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.primary,
                        ),
                      ),
                      Icon(
                        _isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
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
          if (widget.isLoading)
            _buildShimmer()
          else if (widget.products.isEmpty)
            _buildEmptyState()
          else
            AnimatedSize(
              duration: TossAnimations.slow,
              child: Column(
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
                      revenue: product.totalRevenue,
                      growth: product.revenueGrowth,
                      shareRatio: product.totalRevenue / maxRevenue,
                    ),
                  );
                }).toList(),
              ),
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
            Icon(
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
  final double revenue;
  final double? growth;
  final double shareRatio;

  const _TopProductItem({
    required this.rank,
    required this.name,
    required this.revenue,
    this.growth,
    required this.shareRatio,
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
          // Revenue + Progress bar
          Row(
            children: [
              Text(
                _formatCurrency(revenue),
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

  String _formatCurrency(double value) {
    if (value.abs() >= 1000000000) {
      return '\$${(value / 1000000000).toStringAsFixed(1)}B';
    } else if (value.abs() >= 1000000) {
      return '\$${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value.abs() >= 1000) {
      return '\$${(value / 1000).toStringAsFixed(1)}K';
    }
    return '\$${value.toStringAsFixed(0)}';
  }
}
