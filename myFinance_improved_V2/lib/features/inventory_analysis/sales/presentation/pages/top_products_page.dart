import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/atoms/display/toss_badge.dart';
import 'package:myfinance_improved/shared/widgets/molecules/navigation/toss_app_bar.dart';

import '../../domain/entities/sales_analytics.dart';

/// Top Products Page (Phase 2)
/// Full list of products with virtual scrolling (ListView.builder)
/// Replaces the old Expand/Collapse pattern for better performance
class TopProductsPage extends StatefulWidget {
  final List<AnalyticsDataPoint> products;
  final Metric selectedMetric;

  const TopProductsPage({
    super.key,
    required this.products,
    required this.selectedMetric,
  });

  @override
  State<TopProductsPage> createState() => _TopProductsPageState();
}

class _TopProductsPageState extends State<TopProductsPage> {
  String _searchQuery = '';
  late List<AnalyticsDataPoint> _filteredProducts;

  @override
  void initState() {
    super.initState();
    _filteredProducts = widget.products;
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      _filteredProducts = widget.products.where((product) {
        return product.dimensionName.toLowerCase().contains(_searchQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final maxRevenue = widget.products.isNotEmpty
        ? widget.products.first.totalRevenue
        : 1.0;

    return Scaffold(
      backgroundColor: TossColors.gray50,
      appBar: const TossAppBar(
        title: 'Top Products',
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(TossSpacing.space4),
            color: TossColors.white,
            child: TextField(
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search products...',
                hintStyle: TossTextStyles.body.copyWith(
                  color: TossColors.gray400,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: TossColors.gray400,
                ),
                filled: true,
                fillColor: TossColors.gray50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: TossSpacing.space4,
                  vertical: TossSpacing.space3,
                ),
              ),
            ),
          ),

          // Metric Info
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: TossSpacing.space4,
              vertical: TossSpacing.space2,
            ),
            color: TossColors.white,
            child: Row(
              children: [
                Icon(
                  Icons.sort,
                  size: 16,
                  color: TossColors.gray500,
                ),
                const SizedBox(width: TossSpacing.space2),
                Text(
                  'Sorted by ${widget.selectedMetric.name.toUpperCase()}',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray500,
                  ),
                ),
                const Spacer(),
                Text(
                  '${_filteredProducts.length} products',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: TossSpacing.space2),

          // Product List with Virtual Scrolling
          Expanded(
            child: _filteredProducts.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TossSpacing.space4,
                    ),
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = _filteredProducts[index];
                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: TossSpacing.space3,
                        ),
                        child: _ProductListTile(
                          rank: index + 1,
                          product: product,
                          maxRevenue: maxRevenue,
                          selectedMetric: widget.selectedMetric,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search_off,
            size: 48,
            color: TossColors.gray300,
          ),
          const SizedBox(height: TossSpacing.space3),
          Text(
            'No products found',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray500,
            ),
          ),
          if (_searchQuery.isNotEmpty) ...[
            const SizedBox(height: TossSpacing.space2),
            Text(
              'Try a different search term',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray400,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ProductListTile extends StatelessWidget {
  final int rank;
  final AnalyticsDataPoint product;
  final double maxRevenue;
  final Metric selectedMetric;

  const _ProductListTile({
    required this.rank,
    required this.product,
    required this.maxRevenue,
    required this.selectedMetric,
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

  double get _metricValue {
    return switch (selectedMetric) {
      Metric.revenue => product.totalRevenue,
      Metric.margin => product.totalMargin,
      Metric.quantity => product.totalQuantity,
    };
  }

  double? get _metricGrowth {
    return switch (selectedMetric) {
      Metric.revenue => product.revenueGrowth,
      Metric.margin => product.marginGrowth,
      Metric.quantity => product.quantityGrowth,
    };
  }

  @override
  Widget build(BuildContext context) {
    final shareRatio = maxRevenue > 0 ? product.totalRevenue / maxRevenue : 0.0;

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
                  product.dimensionName,
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (_metricGrowth != null)
                TossBadge.growth(value: _metricGrowth!),
            ],
          ),
          const SizedBox(height: TossSpacing.space2),
          // Value + Progress bar
          Row(
            children: [
              Text(
                _formatValue(_metricValue),
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
    if (selectedMetric == Metric.quantity) {
      return _formatNumber(value);
    }
    return _formatCurrency(value);
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

  String _formatNumber(double value) {
    if (value.abs() >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value.abs() >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toStringAsFixed(0);
  }
}
