import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/atoms/display/toss_badge.dart';
import 'package:myfinance_improved/shared/widgets/molecules/cards/toss_card.dart';

import '../../domain/entities/sales_analytics.dart';
import 'drill_down_breadcrumb.dart';

/// Drill-down Section Widget
/// Category/Brand/Product hierarchy navigation with ranked list
class DrillDownSection extends StatefulWidget {
  final DrillDownState drillDownState;
  final List<DrillDownItem> items;
  final bool isLoading;
  final bool canDrillDown;
  final void Function(int) onBreadcrumbTap;
  final void Function(DrillDownItem) onItemTap;
  final int initialShowCount;

  const DrillDownSection({
    super.key,
    required this.drillDownState,
    required this.items,
    this.isLoading = false,
    this.canDrillDown = true,
    required this.onBreadcrumbTap,
    required this.onItemTap,
    this.initialShowCount = 5,
  });

  @override
  State<DrillDownSection> createState() => _DrillDownSectionState();
}

class _DrillDownSectionState extends State<DrillDownSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    // Sort items by revenue (descending)
    final sortedItems = List<DrillDownItem>.from(widget.items)
      ..sort((a, b) => b.totalRevenue.compareTo(a.totalRevenue));

    final displayItems = _isExpanded
        ? sortedItems
        : sortedItems.take(widget.initialShowCount).toList();

    final maxRevenue =
        sortedItems.isNotEmpty ? sortedItems.first.totalRevenue : 1.0;

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
                      'Category Analysis',
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                if (sortedItems.length > widget.initialShowCount)
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
            const SizedBox(height: TossSpacing.space3),

            // Breadcrumb
            DrillDownBreadcrumb(
              items: widget.drillDownState.breadcrumbs,
              onTap: widget.onBreadcrumbTap,
            ),
            const SizedBox(height: TossSpacing.space4),

            // List
            if (widget.isLoading)
              _buildShimmer()
            else if (widget.items.isEmpty)
              _buildEmptyState()
            else
              AnimatedSize(
                duration: TossAnimations.slow,
                child: Column(
                  children: displayItems.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index < displayItems.length - 1
                            ? TossSpacing.space3
                            : 0,
                      ),
                      child: _DrillDownListItem(
                        rank: index + 1,
                        item: item,
                        shareRatio: item.totalRevenue / maxRevenue,
                        canDrillDown: widget.canDrillDown,
                        onTap: () => widget.onItemTap(item),
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

class _DrillDownListItem extends StatelessWidget {
  final int rank;
  final DrillDownItem item;
  final double shareRatio;
  final bool canDrillDown;
  final VoidCallback onTap;

  const _DrillDownListItem({
    required this.rank,
    required this.item,
    required this.shareRatio,
    required this.canDrillDown,
    required this.onTap,
  });

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
    return GestureDetector(
      onTap: canDrillDown ? onTap : null,
      child: Container(
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
                // Name
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
                // Drill down indicator
                if (canDrillDown)
                  const Icon(
                    Icons.chevron_right,
                    size: 20,
                    color: TossColors.gray400,
                  ),
              ],
            ),
            const SizedBox(height: TossSpacing.space2),
            // Revenue + Progress bar
            Row(
              children: [
                Text(
                  _formatCurrency(item.totalRevenue),
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
            const SizedBox(height: TossSpacing.space2),
            // Stats row
            Row(
              children: [
                if (item.productCount != null) ...[
                  const Icon(
                    Icons.inventory_2_outlined,
                    size: 12,
                    color: TossColors.gray500,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${item.productCount} products',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
                  const SizedBox(width: TossSpacing.space3),
                ],
                if (item.marginRate > 0) ...[
                  const Icon(
                    Icons.trending_up,
                    size: 12,
                    color: TossColors.success,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Margin ${item.marginRate.toStringAsFixed(1)}%',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.success,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
                if (item.totalQuantity > 0) ...[
                  const SizedBox(width: TossSpacing.space3),
                  const Icon(
                    Icons.shopping_cart_outlined,
                    size: 12,
                    color: TossColors.gray500,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${item.totalQuantity.toInt()} sold',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
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
