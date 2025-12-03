// Presentation Page: Inventory Management
// Main page for inventory management with Clean Architecture

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_icons.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../../../../shared/widgets/common/toss_white_card.dart';
import '../../../../shared/widgets/toss/toss_list_tile.dart';
import '../../../../shared/widgets/toss/toss_search_field.dart';
import '../../domain/entities/product.dart';
import '../providers/inventory_providers.dart';
import '../providers/states/inventory_page_state.dart';

/// Inventory Management Page
/// 재고 관리 메인 페이지
class InventoryManagementPage extends ConsumerStatefulWidget {
  const InventoryManagementPage({super.key});

  @override
  ConsumerState<InventoryManagementPage> createState() =>
      _InventoryManagementPageState();
}

class _InventoryManagementPageState
    extends ConsumerState<InventoryManagementPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _searchDebounceTimer;

  // Sorting
  _SortOption? _currentSort; // null = database default order
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    // Load initial data
    Future.microtask(() => ref.read(inventoryPageProvider.notifier).refresh());
    // Add scroll listener for infinite scroll
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _searchDebounceTimer?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Load next page when near bottom (200px threshold)
      final pageState = ref.read(inventoryPageProvider);
      debugPrint('[InventoryPage] _onScroll: pixels=${_scrollController.position.pixels.toInt()}, max=${_scrollController.position.maxScrollExtent.toInt()}, canLoadMore=${pageState.canLoadMore}, isLoadingMore=${pageState.isLoadingMore}');
      if (pageState.canLoadMore) {
        debugPrint('[InventoryPage] _onScroll: Calling loadNextPage()');
        ref.read(inventoryPageProvider.notifier).loadNextPage();
      }
    }
  }

  void _onSearchChanged() {
    // Cancel previous timer if it exists
    _searchDebounceTimer?.cancel();

    // Start new timer for debouncing (300ms delay)
    _searchDebounceTimer = Timer(const Duration(milliseconds: 300), () {
      ref.read(inventoryPageProvider.notifier).setSearchQuery(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final pageState = ref.watch(inventoryPageProvider);

    return TossScaffold(
      backgroundColor: TossColors.gray100,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(TossIcons.back),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Product',
          style: TossTextStyles.h3.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: TossColors.gray100,
        foregroundColor: TossColors.black,
      ),
      body: _buildSimpleProductList(pageState),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/inventoryManagement/addProduct');
        },
        backgroundColor: TossColors.primary,
        child: const Icon(TossIcons.add, color: TossColors.white),
      ),
    );
  }

  Widget _buildSearchFilterSection() {
    return Column(
      children: [
        // Filter and Sort Controls
        Container(
          margin: const EdgeInsets.fromLTRB(
            TossSpacing.space4,
            TossSpacing.space3,
            TossSpacing.space4,
            TossSpacing.space2,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: TossSpacing.space3,
            vertical: TossSpacing.space2,
          ),
          decoration: BoxDecoration(
            color: TossColors.surface,
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            boxShadow: [
              BoxShadow(
                color: TossColors.black.withValues(alpha: 0.02),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              _showSortOptionsSheet();
            },
            borderRadius: BorderRadius.circular(TossBorderRadius.sm),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space3,
                vertical: TossSpacing.space2,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.swap_vert_rounded,
                    size: 22,
                    color: TossColors.gray600,
                  ),
                  const SizedBox(width: TossSpacing.space2),
                  Expanded(
                    child: Text(
                      _getSortLabel(),
                      style: TossTextStyles.labelLarge.copyWith(
                        color: TossColors.gray700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 20,
                    color: TossColors.gray500,
                  ),
                ],
              ),
            ),
          ),
        ),

        // Search Field
        Container(
          margin: const EdgeInsets.fromLTRB(
            TossSpacing.space4,
            TossSpacing.space2,
            TossSpacing.space4,
            TossSpacing.space3,
          ),
          child: TossSearchField(
            controller: _searchController,
            hintText: 'Search products...',
            onChanged: (value) {
              _onSearchChanged();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSimpleProductList(InventoryPageState pageState) {
    // Apply local sorting
    List<Product> displayProducts = _applyLocalSort(pageState.products);

    // Calculate total item count: header + search/filter + products + loading indicator + bottom padding
    // Index 0: Search/Filter section
    // Index 1: Products header (only if products exist)
    // Index 2 to N+1: Product items
    // Index N+2: Loading indicator (if loading more)
    // Index N+3: Bottom padding

    if (displayProducts.isEmpty && !pageState.isLoading) {
      // Empty state
      return Column(
        children: [
          _buildSearchFilterSection(),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.inventory_2,
                    size: 64,
                    color: TossColors.gray400,
                  ),
                  const SizedBox(height: TossSpacing.space3),
                  Text(
                    'No products found',
                    style: TossTextStyles.bodyLarge.copyWith(
                      color: TossColors.gray600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    if (pageState.isLoading && displayProducts.isEmpty) {
      // Initial loading state
      return Column(
        children: [
          _buildSearchFilterSection(),
          const Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      );
    }

    // Product list with infinite scroll
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        // Search and Filter Section
        SliverToBoxAdapter(
          child: _buildSearchFilterSection(),
        ),

        // Products Card with Header
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.fromLTRB(
              TossSpacing.space4,
              0,
              TossSpacing.space4,
              0,
            ),
            child: TossWhiteCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  // Section Header
                  Container(
                    padding: const EdgeInsets.all(TossSpacing.space4),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: TossColors.gray100,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.inventory_2_rounded,
                          color: TossColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: TossSpacing.space2),
                        Text(
                          'Products',
                          style: TossTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w700,
                            color: TossColors.gray900,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: TossSpacing.space2,
                            vertical: TossSpacing.space1,
                          ),
                          decoration: BoxDecoration(
                            color: TossColors.primary.withValues(alpha: 0.1),
                            borderRadius:
                                BorderRadius.circular(TossBorderRadius.sm),
                          ),
                          child: Text(
                            '${pageState.pagination.total} items',
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Product List Items
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final product = displayProducts[index];
              return Container(
                margin: EdgeInsets.fromLTRB(
                  TossSpacing.space4,
                  0,
                  TossSpacing.space4,
                  index == displayProducts.length - 1 ? 0 : 0,
                ),
                decoration: BoxDecoration(
                  color: TossColors.surface,
                  borderRadius: index == displayProducts.length - 1
                      ? const BorderRadius.only(
                          bottomLeft: Radius.circular(TossBorderRadius.lg),
                          bottomRight: Radius.circular(TossBorderRadius.lg),
                        )
                      : null,
                ),
                child: Column(
                  children: [
                    _buildProductListTile(product),
                    if (index < displayProducts.length - 1)
                      const Divider(
                        height: 1,
                        color: TossColors.gray100,
                        indent: TossSpacing.space4,
                        endIndent: TossSpacing.space4,
                      ),
                  ],
                ),
              );
            },
            childCount: displayProducts.length,
          ),
        ),

        // Loading More Indicator
        if (pageState.isLoadingMore)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(TossSpacing.space4),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),

        // Bottom padding to prevent FAB overlap
        const SliverToBoxAdapter(
          child: SizedBox(height: 80),
        ),
      ],
    );
  }

  Widget _buildProductListTile(Product product) {
    final pageState = ref.watch(inventoryPageProvider);
    final currencySymbol = pageState.currency?.symbol ?? '';

    return TossListTile(
      title: product.name,
      subtitle: product.sku,
      showDivider: false,
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: TossColors.gray100,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
        ),
        child: product.images.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
                child: Image.network(
                  product.images.first,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.inventory_2, color: TossColors.gray400, size: 24),
                ),
              )
            : const Icon(Icons.inventory_2, color: TossColors.gray400, size: 24),
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$currencySymbol${_formatCurrency(product.salePrice)}',
            style: TossTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
              color: TossColors.gray900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            product.onHand.toString(),
            style: TossTextStyles.body.copyWith(
              color: _getStockColor(product),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      onTap: () {
        context.push('/inventoryManagement/product/${product.id}');
      },
    );
  }

  String _formatCurrency(double value) {
    return value.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  Color _getStockColor(Product product) {
    if (product.onHand == 0) return TossColors.error;
    final status = product.getStockStatus();
    switch (status) {
      case StockStatus.critical:
        return TossColors.error;
      case StockStatus.low:
        return TossColors.warning;
      case StockStatus.normal:
        return TossColors.success;
      case StockStatus.excess:
        return TossColors.info;
      case StockStatus.outOfStock:
        return TossColors.error;
    }
  }

  String _getSortLabel() {
    if (_currentSort == null) return 'Name (A-Z)';

    switch (_currentSort!) {
      case _SortOption.nameAsc:
      case _SortOption.nameDesc:
        return _sortAscending ? 'Name (A-Z)' : 'Name (Z-A)';
      case _SortOption.priceAsc:
      case _SortOption.priceDesc:
        return _sortAscending ? 'Price (Low to High)' : 'Price (High to Low)';
      case _SortOption.stockAsc:
      case _SortOption.stockDesc:
        return _sortAscending ? 'Stock (Low to High)' : 'Stock (High to Low)';
      case _SortOption.valueDesc:
        return 'Value (High to Low)';
    }
  }

  List<Product> _applyLocalSort(List<Product> products) {
    List<Product> sorted = List.from(products);

    // Apply sorting only if sort option is selected
    if (_currentSort != null) {
      switch (_currentSort!) {
        case _SortOption.nameAsc:
        case _SortOption.nameDesc:
          sorted.sort((a, b) => _sortAscending
              ? a.name.compareTo(b.name)
              : b.name.compareTo(a.name),);
          break;
        case _SortOption.priceAsc:
        case _SortOption.priceDesc:
          sorted.sort((a, b) => _sortAscending
              ? a.salePrice.compareTo(b.salePrice)
              : b.salePrice.compareTo(a.salePrice),);
          break;
        case _SortOption.stockAsc:
        case _SortOption.stockDesc:
          sorted.sort((a, b) => _sortAscending
              ? a.onHand.compareTo(b.onHand)
              : b.onHand.compareTo(a.onHand),);
          break;
        case _SortOption.valueDesc:
          sorted.sort((a, b) =>
              (b.onHand * b.salePrice).compareTo(a.onHand * a.salePrice),);
          break;
      }
    }
    // If _currentSort is null, keep database order (no sorting)

    return sorted;
  }

  void _showSortOptionsSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: TossColors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: TossColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(TossBorderRadius.xl),
            topRight: Radius.circular(TossBorderRadius.xl),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 48,
              height: 4,
              margin: const EdgeInsets.only(top: TossSpacing.space3),
              decoration: BoxDecoration(
                color: TossColors.gray300,
                borderRadius: BorderRadius.circular(TossBorderRadius.xs),
              ),
            ),

            // Header
            Container(
              padding: const EdgeInsets.all(TossSpacing.space4),
              child: Text(
                'Sort By',
                style: TossTextStyles.h3.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            // Sort Options
            _buildSortOption('Name (A-Z)', _SortOption.nameAsc),
            _buildSortOption('Name (Z-A)', _SortOption.nameDesc),
            _buildSortOption('Price (Low to High)', _SortOption.priceAsc),
            _buildSortOption('Price (High to Low)', _SortOption.priceDesc),
            _buildSortOption('Stock (Low to High)', _SortOption.stockAsc),
            _buildSortOption('Stock (High to Low)', _SortOption.stockDesc),
            _buildSortOption('Value (High to Low)', _SortOption.valueDesc),

            SizedBox(
              height: MediaQuery.of(context).padding.bottom + TossSpacing.space4,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(String label, _SortOption option) {
    final isSelected = _currentSort == option;
    return ListTile(
      title: Text(
        label,
        style: TossTextStyles.body.copyWith(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          color: isSelected ? TossColors.primary : TossColors.gray900,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check, color: TossColors.primary)
          : null,
      onTap: () {
        setState(() {
          if (_currentSort == option) {
            // Toggle off if same option is selected
            _currentSort = null;
          } else {
            _currentSort = option;
            _sortAscending = option == _SortOption.nameAsc ||
                option == _SortOption.priceAsc ||
                option == _SortOption.stockAsc;
          }
        });
        Navigator.pop(context);
      },
    );
  }
}

enum _SortOption {
  nameAsc,
  nameDesc,
  priceAsc,
  priceDesc,
  stockAsc,
  stockDesc,
  valueDesc,
}
