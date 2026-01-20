import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/atoms/display/toss_badge.dart';
import 'package:myfinance_improved/shared/widgets/molecules/navigation/toss_app_bar.dart';
import 'package:myfinance_improved/shared/widgets/templates/toss_scaffold.dart';

import '../../domain/entities/sales_analytics.dart';
import '../providers/sales_analytics_v2_notifier.dart';
import '../widgets/drill_down_breadcrumb.dart';

/// Category Analysis Page (Phase 3)
/// Full list of categories with drill-down and virtual scrolling
/// Replaces the old DrillDownSection with Expand/Collapse pattern
class CategoryAnalysisPage extends ConsumerStatefulWidget {
  final String companyId;
  final String? storeId;
  final DrillDownState initialDrillDownState;
  final List<DrillDownItem> initialItems;

  const CategoryAnalysisPage({
    super.key,
    required this.companyId,
    this.storeId,
    required this.initialDrillDownState,
    required this.initialItems,
  });

  @override
  ConsumerState<CategoryAnalysisPage> createState() => _CategoryAnalysisPageState();
}

class _CategoryAnalysisPageState extends ConsumerState<CategoryAnalysisPage> {
  String _searchQuery = '';
  late List<DrillDownItem> _filteredItems;

  @override
  void initState() {
    super.initState();
    _filteredItems = _sortedItems;
  }

  List<DrillDownItem> get _sortedItems {
    final state = ref.read(salesAnalyticsV2NotifierProvider);
    final items = state.drillDownData?.data ?? widget.initialItems;
    return List<DrillDownItem>.from(items)
      ..sort((a, b) => b.totalRevenue.compareTo(a.totalRevenue));
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      _filteredItems = _sortedItems.where((item) {
        return item.name.toLowerCase().contains(_searchQuery);
      }).toList();
    });
  }

  void _onItemTap(DrillDownItem item) {
    final state = ref.read(salesAnalyticsV2NotifierProvider);
    if (!state.drillDownState.canDrillDown) return;

    ref.read(salesAnalyticsV2NotifierProvider.notifier).drillDown(
      id: item.id,
      name: item.name,
      companyId: widget.companyId,
      storeId: widget.storeId,
    );

    // Reset search and update filtered items
    setState(() {
      _searchQuery = '';
      _filteredItems = _sortedItems;
    });
  }

  void _onBreadcrumbTap(int index) {
    ref.read(salesAnalyticsV2NotifierProvider.notifier).navigateToBreadcrumb(
      index: index,
      companyId: widget.companyId,
      storeId: widget.storeId,
    );

    // Reset search and update filtered items
    setState(() {
      _searchQuery = '';
      _filteredItems = _sortedItems;
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(salesAnalyticsV2NotifierProvider);
    final drillDownState = state.drillDownState;
    final isLoading = state.isDrillDownLoading;

    // Update filtered items when state changes
    if (!isLoading && _searchQuery.isEmpty) {
      _filteredItems = _sortedItems;
    }

    final maxRevenue = _filteredItems.isNotEmpty
        ? _filteredItems.first.totalRevenue
        : 1.0;

    return TossScaffold(
      backgroundColor: TossColors.gray50,
      appBar: const TossAppBar(
        title: 'Category Analysis',
      ),
      body: Column(
        children: [
          // Breadcrumb
          Container(
            padding: const EdgeInsets.all(TossSpacing.space4),
            color: TossColors.white,
            child: DrillDownBreadcrumb(
              items: drillDownState.breadcrumbs,
              onTap: _onBreadcrumbTap,
            ),
          ),

          // Search Bar
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: TossSpacing.space4,
              vertical: TossSpacing.space2,
            ),
            color: TossColors.white,
            child: TextField(
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search categories...',
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

          // Info bar
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: TossSpacing.space4,
              vertical: TossSpacing.space2,
            ),
            color: TossColors.white,
            child: Row(
              children: [
                Icon(
                  drillDownState.canDrillDown
                      ? Icons.touch_app_outlined
                      : Icons.check_circle_outline,
                  size: 16,
                  color: TossColors.gray500,
                ),
                const SizedBox(width: TossSpacing.space2),
                Text(
                  drillDownState.canDrillDown
                      ? 'Tap to drill down'
                      : 'Lowest level (products)',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray500,
                  ),
                ),
                const Spacer(),
                Text(
                  '${_filteredItems.length} items',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: TossSpacing.space2),

          // Category List with Virtual Scrolling
          Expanded(
            child: isLoading
                ? _buildLoadingState()
                : _filteredItems.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: TossSpacing.space4,
                        ),
                        itemCount: _filteredItems.length,
                        itemBuilder: (context, index) {
                          final item = _filteredItems[index];
                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: TossSpacing.space3,
                            ),
                            child: _CategoryListTile(
                              rank: index + 1,
                              item: item,
                              maxRevenue: maxRevenue,
                              canDrillDown: drillDownState.canDrillDown,
                              onTap: () => _onItemTap(item),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: TossColors.primary,
          ),
          const SizedBox(height: TossSpacing.space3),
          Text(
            'Loading...',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray500,
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
            'No categories found',
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

class _CategoryListTile extends StatelessWidget {
  final int rank;
  final DrillDownItem item;
  final double maxRevenue;
  final bool canDrillDown;
  final VoidCallback onTap;

  const _CategoryListTile({
    required this.rank,
    required this.item,
    required this.maxRevenue,
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
    final shareRatio = maxRevenue > 0 ? item.totalRevenue / maxRevenue : 0.0;

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
